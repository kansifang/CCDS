<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-客户－0300－财务信息检查
 *           
 * Input Param:
 *      altsce:			从Session中抓取预警对象
 *      sModelNo:		从requst中获取当前处理的模型编号
 *      
 * Output param:
 *      ReturnValue:    预警检查处理通过否，用'$'分割，前两位数字处理方式编号，后提示字符串
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//定义参数
	String sResult="";
	String sTip="校验通过！";
	String sDealMethod="99";
	StringBuffer sbTips = new StringBuffer("");			
	
	//获得参数
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//风险提示	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$模型编号未指定！";
		else{
			//获得参数
			String sCustomerID = altsce.getArgValue("CustomerID");	
			//查询出客户类型
			String sSql = " select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
			String sCustomerType = Sqlca.getString(sSql);
			if (sCustomerType == null) sCustomerType = "";	
					
			if (sCustomerType.substring(0,2).equals("01")) //公司客户
			{
				//处理过程
				String sAccMonth = "";//会计月份
				String sMinAccMonth = "";//前三月
				String sCount = "";//记录数			
				String sCurToday = StringFunction.getToday();//当前日期
				sAccMonth = sCurToday.substring(0,7);//会计月份
				sMinAccMonth = StringFunction.getRelativeAccountMonth(sAccMonth,"Month",-3);
				sCount = Sqlca.getString("select count(RecordNo) from CUSTOMER_FSRECORD where CustomerID = '"+sCustomerID+"' And ReportDate >= '"+sMinAccMonth+"'");
				if( sCount == null || Integer.parseInt(sCount) <= 0 )
				{
					sbTips.append("该客户已经有三个月没有登记财务报表！"+"\r\n");
				}
			}	
		}
		//设置参数
		//altsce.setArgValue("ApplyNo",sObjectNo);
		
		if( sbTips.length() > 0 )
		{
			sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
			sTip = SpecialTools.real2Amarsoft(sbTips.toString());	
		}
		//记录日志
		//根据返回结果，判断成功与否，并根据DealMethod判断是否处理
		altsce.writeAlarmLog(sModelNo,sTip,sDealMethod,Sqlca);
		
		//设置返回值
		sResult = sDealMethod+"$"+sTip;
		
	}catch(Exception ea){
		ea.printStackTrace();
		sResult="10$"+ea.getMessage();
	}
%>
<html>
<head>
</head>
<body onkeydown=mykd1 >
	<iframe name="myprint10" width=0% height=0% style="display:none" frameborder=1></iframe>
</body>
</html>

<script language=javascript >
	self.returnValue = "<%=sResult%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
