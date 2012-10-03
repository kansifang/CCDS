<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-客户－0200－预警客户检查
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
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//定义参数
	String sResult="";
	String sTip="校验通过！";
	String sDealMethod="99";
	String sCount="";
	StringBuffer sbTips = new StringBuffer("");
	boolean bResult=true;
	
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
			
			//检查该客户是否存在已生效的预警信息
			String sSql = " select count(RS1.SerialNo) from RISK_SIGNAL RS1  "+
						  " where RS1.SerialNo not in (select distinct RS2.RelativeSerialNo "+
						  " from RISK_SIGNAL RS2 "+
						  " where RS2.SignalType='02' "+
						  " and RS2.SignalStatus='30') "+
						  " and RS1.ObjectType = 'Customer' "+
						  " and RS1.ObjectNo = '"+sCustomerID+"' "+
						  " and SignalType = '01' "+
						  " and RS1.SignalStatus='30' ";
			sCount = Sqlca.getString(sSql);
			if( sCount != null && Integer.parseInt(sCount,10) > 0  )
			{
				sbTips.append( "存在生效的预警信号；"+"\r\n" );
			}

			//设置参数
			//altsce.setArgValue("ApplyNo",sObjectNo);

			//处理措施不需要修改终批机构，只需要提示就可以
			if( !sDealMethod.equals("99") )
				sDealMethod = "81";
			
			//记录日志
			//根据返回结果，判断成功与否，并根据DealMethod判断是否处理
			if( sbTips.length() > 0 )
			{
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
