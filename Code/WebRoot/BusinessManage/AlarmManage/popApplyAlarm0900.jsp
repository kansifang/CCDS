<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-申请－0900－保证人本行授信业务检查
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
	String sDealMethod="99";	
	String sCount="";
	String sSql="";
	String sGuarantorID="";	
	String sGuarantorName="";	
	StringBuffer sbTips = new StringBuffer("");		
	ASResultSet rs=null;
	ASResultSet rs1=null;
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
		            	//全行范围内	
						sSql = 	" select count(*) from BUSINESS_CONTRACT "+
								" where CustomerID = '"+sGuarantorID+"' "+
								" and BusinessType not like '3%' "+
								" and (FinishDate is null "+
								" or FinishDate = '') ";	
						sCount = Sqlca.getString(sSql);
						if( sCount != null && Integer.parseInt(sCount,10) > 0 )
						{	
							sbTips.append("保证人["+sGuarantorName+"]在全行范围内未结清的授信业务笔数："+sCount+";\n\r");
							sSql = 	" select sum(BusinessSum*getERate(BusinessCurrency,'01',ERateDate)) as BusinessSum, "+
									" sum(Balance*getERate(BusinessCurrency,'01',ERateDate)) as BalanceSum "+
									" from BUSINESS_CONTRACT "+
									" where CustomerID = '"+sGuarantorID+"' "+
									" and BusinessType not like '3%' "+
									" and (FinishDate is null "+
									" or FinishDate = '') ";
							rs1 = Sqlca.getResultSet(sSql);
							if(rs1.next())
							{
								String sBusinessSum = rs1.getString("BusinessSum");
								String sBalanceSum = rs1.getString("BalanceSum");
								if(sBusinessSum == null) sBusinessSum = "0.00";
								if(sBalanceSum == null) sBalanceSum = "0.00";
								sbTips.append("保证人["+sGuarantorName+"]在全行范围内未结清的授信业务发放总金额（折人民币）："+DataConvert.toMoney(sBusinessSum)+";\n\r");
								sbTips.append("保证人["+sGuarantorName+"]在全行范围内未结清的授信业务总余额（折人民币）："+DataConvert.toMoney(sBalanceSum)+";\n\r");
							}
							rs1.getStatement().close();
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
