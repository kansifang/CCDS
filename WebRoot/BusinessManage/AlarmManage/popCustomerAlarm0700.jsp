<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-客户－0500－申请人他行授信业务检查
 *           
 * Input Param:
 *      altsce:			从Session中抓取预警对象
 *      sModelNo:		从requst中获取当前处理的模型编号
 *      
 * Output param:
 *      ReturnValue:    预警检查处理通过否，用'$'分割，前两位数字处理方式编号，后提示字符串
 * History Log:  
 *		zywei 2007/10/10 将金额展现形式改为三位一逗
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//定义参数
	String sResult="";
	String sTip="校验通过！";
	StringBuffer sbTips = new StringBuffer("");
	String sDealMethod="99";	
	String sSql="";
	ASResultSet rs=null;
	//获得参数	自己按需要获取
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
			
			//他行范围内	
			sSql = 	" select count(*) from CUSTOMER_OACTIVITY "+
					" where CustomerID = '"+sCustomerID+"' "+					
					" and UptoDate <= '"+StringFunction.getToday()+"' ";	
			String sCount = Sqlca.getString(sSql);
			if( sCount == null || Integer.parseInt(sCount,10) == 0 )
			{								
			}else
			{
				sbTips.append("在他行未结清的授信业务笔数："+sCount+";\n\r");
				sSql = 	" select sum(BusinessSum*getERate(Currency,'01','')) as BusinessSum, "+
						" sum(Balance*getERate(Currency,'01','')) as BalanceSum ,getBusinessName(BUSINESSTYPE) as BusinessType "+
						" from CUSTOMER_OACTIVITY "+
						" where CustomerID = '"+sCustomerID+"' "+
						" and UptoDate <= '"+StringFunction.getToday()+"' group by BusinessType ";
				rs = Sqlca.getResultSet(sSql);
				while(rs.next())
				{
					String sBusinessSum = rs.getString("BusinessSum");
					String sBalanceSum = rs.getString("BalanceSum");
					String sBusinessType = rs.getString("BusinessType");
					if(sBusinessSum == null) sBusinessSum = "0.00";
					if(sBalanceSum == null) sBalanceSum = "0.00";
					sbTips.append("在他行未结清的【"+sBusinessType+"】发放总金额（折人民币）："+DataConvert.toMoney(sBusinessSum)+",余额（折人民币）："+DataConvert.toMoney(sBalanceSum)+";\n\r");
				}
				rs.getStatement().close();
			}
						
			//设置参数
			//altsce.setArgValue("VouchType",sVouchType);
						
			if( sbTips.length() > 0 )
				sTip = SpecialTools.real2Amarsoft(sbTips.toString());

			//记录日志
			//根据返回结果，判断成功与否，并根据DealMethod判断是否处理
			if( sbTips.length() > 0 ){
				sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
				sTip = SpecialTools.real2Amarsoft(sbTips.toString());
			}
			
			altsce.writeAlarmLog(sModelNo,sTip,sDealMethod,Sqlca);
			
			//设置返回值
			sResult = sDealMethod+"$"+sTip;
		}
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
