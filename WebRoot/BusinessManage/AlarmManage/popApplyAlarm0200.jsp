<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-申请－0200－生成申请主要担保方式、低风险担保金额、是否低风险业务
 *           
 * Input Param:
 *      altsce:			从Session中抓取预警对象
 *      sModelNo:		从requst中获取当前处理的模型编号
 *      
 * Output param:
 *      ReturnValue:    预警检查处理通过否，用'$'分割，前两位数字处理方式编号，后提示字符串
 * History Log:  lpzhang 2009-8-19 调整担保方式编号
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
			//获得参数u
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
			String sBusinessType = altsce.getArgValue("BusinessType");
			String sVouchType = altsce.getArgValue("VouchType");
			System.out.println("sApplySerialNo:"+sApplySerialNo+"sVouchType:"+sVouchType);
			if(sVouchType.length()>=3) {
				//假如业务基本信息中的主要担保方式为保证,必须输入保证担保信息
				if(sVouchType.substring(0,3).equals("010") && !sVouchType.equals("0105080"))
				{
					//检查担保合同信息中是否存在保证担保
					sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
							" from APPLY_RELATIVE where SerialNo='"+sApplySerialNo+"' and ObjectType = 'GuarantyContract') "+
							" and GuarantyType like '010%' having count(SerialNo) > 0 ";
					sCount = Sqlca.getString(sSql);
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("申请信息中主要担保方式为保证，可没有输入与保证有关的担保信息；\n\r");						
					}					
				}
				
				//假如业务基本信息中的主要担保方式为抵押,必须输入抵押担保信息，并且还需要有相应的抵押物信息
				if(sVouchType.substring(0,3).equals("020"))	{
					//检查担保合同信息中是否存在抵押担保
					sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
							" from APPLY_RELATIVE where SerialNo='"+sApplySerialNo+"' and ObjectType = 'GuarantyContract') "+
							" and GuarantyType like '050%' ";
					
					sCount = Sqlca.getString(sSql);
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("申请信息中主要担保方式为抵押，可没有输入与抵押有关的担保信息；\n\r");						
					}else 
					{							
						sSql = 	" select GuarantyID,GuarantyRate,EvalMethod,GuarantyType from GUARANTY_INFO where GuarantyID in (Select GuarantyID "+
								" from GUARANTY_RELATIVE where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"') "+
								" and GuarantyType like '010%' ";
						ASResultSet rs  = Sqlca.getASResultSet(sSql);
						int iCount = 0;
						while(rs.next()){
							double dGuarantyRate = rs.getDouble("GuarantyRate");
							String sEvalMethod = rs.getString("EvalMethod");
							if(sEvalMethod == null) sEvalMethod = "";
							String sGuarantyType = rs.getString("GuarantyType");
							if(sGuarantyType == null) sGuarantyType = "";
							if("01".equals(sEvalMethod) && "1050020".equals(sBusinessType) && "010020".equals(sGuarantyType) ){
								if(dGuarantyRate > 50 )
									sbTips.append("业务为土地储备贷款、抵押土地的抵押率不能大于50%；\n\r");
									iCount++;	
									break;	
							}
							else{
								if(dGuarantyRate>70){
									sbTips.append("抵押物信息中的抵押率不能有大于70%的抵押物；\n\r");
									iCount++;	
									break;
								}
							}
							iCount++;
						}
						rs.close();
						if(iCount < 1 )
						{
							sbTips.append("申请信息中主要担保方式为抵押，可输入的抵押担保信息没有抵押物信息；\n\r");						
						}
												
					}												
				}
				
				//假如业务基本信息中的主要担保方式为质押,必须输入质押担保信息，并且还需要有相应的质物信息
				if(sVouchType.substring(0,3).equals("040"))	{
					//检查担保合同信息中是否存在质押担保
					sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
							" from APPLY_RELATIVE where SerialNo='"+sApplySerialNo+"' and ObjectType = 'GuarantyContract') "+
							" and GuarantyType like '060%' ";
					sCount = Sqlca.getString(sSql);
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("申请信息中主要担保方式为质押，可没有输入与质押有关的担保信息；\n\r");						
					}else 
					{
						sSql = 	" select count(GuarantyID) from GUARANTY_INFO where GuarantyID in (Select GuarantyID "+
								" from GUARANTY_RELATIVE where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"') "+
								" and GuarantyType like '020%' ";
						sCount = Sqlca.getString(sSql);
						if( sCount == null || Integer.parseInt(sCount) <= 0 )
						{
							sbTips.append("申请信息中主要担保方式为质押，可输入的质押担保信息没有质物信息；\n\r");						
						}							
					}						
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
