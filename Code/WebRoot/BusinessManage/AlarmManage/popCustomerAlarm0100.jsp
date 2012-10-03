<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-客户－0100－客户信息完整性检查
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
	StringBuffer sbTips = new StringBuffer("");		
	boolean bContinue = true;
	
	//获得参数=
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//风险提示	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$模型编号未指定！";
		else{
			//获得参数
			String sCustomerID = altsce.getArgValue("CustomerID");
			if(sCustomerID==null)sCustomerID="";
			String sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'");
			if(sCustomerType==null)sCustomerType="";
						
			//处理过程
			String sMaxAccMonth = "";
			String sCount = "";
			String sTempSaveFlag = "";
			String sCurToday = StringFunction.getToday();
			// 申请人客户概况必须录入（必输字段已输入）
			if( sCustomerType.substring(0,2).equals("03") )
			{
				//申请人为个人客户，检查暂存标志是否为否
				sTempSaveFlag = Sqlca.getString("select TempSaveFlag from IND_INFO where CustomerID='"+sCustomerID+"'");
				if(sTempSaveFlag == null) sTempSaveFlag = "";
				if( sTempSaveFlag.equals("1") )
					sbTips.append("该客户的客户概况信息录入不完整；"+"\r\n");
				bContinue = false;
			}else if( sCustomerType.substring(0,2).equals("01") )
			{	
				//申请人为个人客户，检查暂存标志是否为否
				sTempSaveFlag = Sqlca.getString("select TempSaveFlag from ENT_INFO where CustomerID='"+sCustomerID+"'");
				if(sTempSaveFlag == null) sTempSaveFlag = "";
				if( sTempSaveFlag.equals("1") )
					sbTips.append("该客户的客户概况信息录入不完整；"+"\r\n");			
			}
			
			if( bContinue )
			{
				sCount = null;
				if( sCustomerType.substring(0,2).equals("01") )
				{
					//申请人客户类型为“公司客户的”，高管信息中必须有法人代表信息
					sCount = Sqlca.getString("select count(CustomerID) from CUSTOMER_RELATIVE where Relationship='0100' and CustomerID='"+sCustomerID+"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{	
						sbTips.append("该客户的高管信息中缺少法人代表信息；"+"\r\n");
					}	
					//检查：提示公司客户信息客户高管信息中必须录入实际控制人
					sCount = Sqlca.getString("select count(CustomerID) from CUSTOMER_RELATIVE where RelationShip = '0109' and CustomerID = '"+sCustomerID+"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{	
						sbTips.append("该客户的高管信息中缺少实际控制人信息；"+"\r\n");
					}
				}					
			}
		}
			
		//设置参数
		//altsce.setArgValue("ApplyNo",sObjectNo);
		
		//记录日志
		//根据返回结果，判断成功与否，并根据DealMethod判断是否处理
		if( sbTips.length() > 0 ){
			sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
			sTip = SpecialTools.real2Amarsoft(sbTips.toString());
		}
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
