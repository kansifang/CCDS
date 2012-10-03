<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-申请－0500－保证人客户信息完整性检查
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
	String sSql="";
	String sGuarantorID="";
	String sGuarantorName="";
	String sCustomerType="";
	StringBuffer sbTips = new StringBuffer("");	
	boolean bContinue = true;
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
		            	//根据查询得出的保证人客户代码，查询他们的客户概况是否录入完整
		            	if (sCustomerType.substring(0,2).equals("01")) //公司客户
							sSql =  " select Count(CustomerID) from ENT_INFO "+
									" where CustomerID = '"+sGuarantorID+"' "+
									" and TempSaveFlag = '1' ";
		            	if (sCustomerType.substring(0,2).equals("03")) //相关个人
		            		sSql =  " select Count(CustomerID) from IND_INFO "+
		            				" where CustomerID = '"+sGuarantorID+"' "+
		            				" and TempSaveFlag = '1' ";
		            	
						sCount = Sqlca.getString(sSql);
						if( sCount == null || Integer.parseInt(sCount) <= 0 )
						{												
						}else
						{
						 	sbTips.append("保证人["+sGuarantorName+"]的客户概况信息录入不完整；\n\r");
						 	bContinue = false;
						}
						
						if( bContinue )
						{
							sCount = null;
							//申请人客户类型为“公司客户的”，高管信息中必须有法人代表信息
							if( sCustomerType.substring(0,2).equals("01") )
							{
								sCount = Sqlca.getString("select count(CustomerID) from CUSTOMER_RELATIVE where Relationship='0100' and CustomerID='"+sGuarantorID+"'");
								if( sCount == null || Integer.parseInt(sCount) <= 0 )
									sbTips.append("保证人["+sGuarantorName+"]的高管信息中缺少法人代表信息；"+"\r\n");
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