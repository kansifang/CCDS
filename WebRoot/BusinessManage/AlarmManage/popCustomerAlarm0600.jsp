<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-客户－0200－黑名单客户检查
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
	String sResult;
	String sTip="校验通过！";
	String sDealMethod="99";
	StringBuffer sbTips = new StringBuffer("");
	String sShowScript=null;
	Any anyResult;
	String sToday = StringFunction.getToday();
	boolean bResult=true;
	boolean bContinue = true;
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
			String sCustomerName = altsce.getArgValue("CustomerName");
			String sCertType = altsce.getArgValue("CertType");
			String sCertID = altsce.getArgValue("CertID");
			
			String sCount = null;
			String[][] ssMatrix = null;
			String sMsg = null;
			int j=0;
			
			//检查该客户是否存在黑名单中
			sCount = Sqlca.getString("select count(SerialNo) from CUSTOMER_SPECIAL "+
									"where (CustomerID = '"+sCustomerID+"' or CustomerID = '"+sCustomerName+"' "+
									"or (CertType = '"+sCertType+"' and CertID = '"+sCertID+"')) and SectionType = '40' "+
									"and InListStatus='1' and (EndDate >='"+sToday+"' or EndDate is null)" );
			if( sCount != null && Integer.parseInt(sCount,10) > 0  )
			{
				sbTips.append( "属于黑名单客户；"+"\r\n" );
			}
			

			//设置参数
			//altsce.setArgValue("ApplyNo",sObjectNo);

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
