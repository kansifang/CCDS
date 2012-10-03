<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-申请－0800－保证人信用评级检查
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
	String sCount="";
	String sSql="";
	String sGuarantorID="";	
	String sGuarantorName="";
	String sCustomerType="";
	StringBuffer sbTips = new StringBuffer("");		
	ASResultSet rs=null;
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
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
			String sVouchType = altsce.getArgValue("VouchType");
			
			if(sVouchType.length()>=3) 
			{
				//假如业务基本信息中的主要担保方式为保证,则查询出保证人客户代码
				if(sVouchType.substring(0,3).equals("010"))
				{
					sSql = 	" select GuarantorID,GuarantorName from GUARANTY_CONTRACT "+
							" where SerialNo in (select ObjectNo from APPLY_RELATIVE "+
							" where SerialNo = '"+sApplySerialNo+"' "+
							" and ObjectType = 'GuarantyContract') "+
							" and GuarantyType like '010%' ";
					rs = Sqlca.getASResultSet(sSql);
		        	while(rs.next())
		        	{
		            	sGuarantorID = rs.getString("GuarantorID");
		            	sGuarantorName = rs.getString("GuarantorName");
		            	sCustomerType=Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sGuarantorID+"'");
		            	if(sCustomerType == null) sCustomerType = "";
		            	//保证人为公司客户，其客户类型为“法人企业、非法人企业、事业单位”的
						if( sCustomerType.equals("0101") || sCustomerType.equals("0102") || sCustomerType.equals("0104") )
						{
							String sTodayMonth = StringFunction.getToday();
							String sBgMonth = String.valueOf(Integer.parseInt(sTodayMonth.substring(0,4),10)-1).concat(sTodayMonth.substring(4,7));
							
							sCount = Sqlca.getString("select count(SerialNo) from EVALUATE_RECORD where ObjectType='Customer' And ObjectNo='"+sGuarantorID+"' And AccountMonth >= '"+sBgMonth+"'");
							if( sCount == null || Integer.parseInt(sCount) <= 0 )
							{
								sbTips.append("保证人["+sGuarantorName+"]缺少一年内的信用评级；"+"\r\n");
							}
						}					
					}
					rs.getStatement().close();					
				}
			}			
			
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
