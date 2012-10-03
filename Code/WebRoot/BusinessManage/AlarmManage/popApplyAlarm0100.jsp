<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理-申请－0100－业务申请信息完整性检查
 *           
 * Input Param:
 *      altsce:			从Session中抓取预警对象
 *      sModelNo:		从requst中获取当前处理的模型编号
 *      
 * Output param:
 *      ReturnValue:    预警检查处理通过否，用'$'分割，前两位数字处理方式编号，后提示字符串
 * History Log:  lpzhang 2009-8-19 关闭风险度探测，将其单独作为一个大项
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//定义变量
	String sResult="";
	String sTip="校验通过！";
	String sDealMethod="99";	
	String sCount="",sHasIERight="",sNum="";
	StringBuffer sbTips = new StringBuffer("");	
	boolean bContinue = true;
	double dBusinessSum = 0.0;
	int iBillNum = 0;
	//获得参数
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//风险提示	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$模型编号未指定！";
		else{
			//获得参数
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
			String sCustomerID = altsce.getArgValue("CustomerID");				
			String sBusinessType = altsce.getArgValue("BusinessType");
			String sOccurType = altsce.getArgValue("OccurType");			
			String sTempSaveFlag = altsce.getArgValue("TempSaveFlag");			
			String sBusinessSum = altsce.getArgValue("BusinessSum");
			String sObjectType = altsce.getArgValue("ObjectType");
			String sApplyType = altsce.getArgValue("ApplyType");
			if(sBusinessSum != null && !sBusinessSum.equals(""))
				dBusinessSum = Double.parseDouble(sBusinessSum);
			String sBillNum = altsce.getArgValue("BillNum");
			if(sBillNum != null && !sBillNum.equals(""))
				iBillNum = Integer.parseInt(sBillNum);
				
			System.out.println("sCustomerID="+sCustomerID);
			System.out.println("sOccurType="+sOccurType);
			//处理过程			
			//1、暂存标志为必输项是否录入完整的检查标志
			if( sTempSaveFlag != null && sTempSaveFlag.equals("1"))
			{
				sbTips.append("申请基本信息必输项未录入完整！\n\r");
				bContinue = false;
			}
			
			if( bContinue )
			{
				//发生类型为展期，则必须关联展期业务
				if(sOccurType.equals("015"))
				{
					sCount = Sqlca.getString("select count(SerialNo) from Apply_RELATIVE where SerialNo='"+sApplySerialNo +"' and ObjectType='BusinessDueBill'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("发生类型为展期，必须有相关的展期业务信息；\n\r");						
					}
				}
				//发生类型为借新还旧，则必须关联借新还旧的业务
				if(sOccurType.equals("020"))
				{
					sCount = Sqlca.getString("select count(SerialNo) from Apply_RELATIVE where SerialNo='"+sApplySerialNo +"' and ObjectType='BusinessDueBill'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("发生类型为借新还旧，必须有相关的借新还旧业务信息；\n\r");						
					}
				}
				System.out.println("3333333");
				//发生类型为还旧借新，则必须关联还旧借新的业务
				if(sOccurType.equals("060"))
				{
					sCount = Sqlca.getString("select count(SerialNo) from Apply_RELATIVE where SerialNo='"+sApplySerialNo +"' and ObjectType='BusinessDueBill'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("发生类型为还旧借新，必须有相关的还旧借新业务信息；\n\r");						
					}
				}
				//发生类型为新增(续作)，则必须关联新增(续作)的业务
				if(sOccurType.equals("065"))
				{
					sCount = Sqlca.getString("select count(SerialNo) from Apply_RELATIVE where SerialNo='"+sApplySerialNo +"' and ObjectType='BusinessDueBill'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("发生类型为新增(续作)，必须有相关的新增(续作)业务信息；\n\r");						
					}
				}
				//发生类型为资产重组，则必须关联资产重组方案
				if(sOccurType.equals("030"))
				{
					sCount = Sqlca.getString("select count(SerialNo) from Apply_RELATIVE where SerialNo='"+sApplySerialNo +"' and ObjectType='CapitalReform'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("发生类型为资产重组，必须有相关的资产重组方案信息；\n\r");						
					}
				}
				System.out.println("sBusinessType="+sBusinessType);
				//业务品种为项目贷款，必须关联相应的项目信息
				if("1030010,1030015,1030020,1030030,1050010,1050020".indexOf(sBusinessType) >-1)
				{					
					sCount = Sqlca.getString("select count(PR.ProjectNo) from PROJECT_RELATIVE PR,BUSINESS_APPLY BA where PR.ObjectNo=BA.SerialNo and PR.ObjectType='CreditApply' and PR.ObjectNo='"+sApplySerialNo +"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("业务品种为项目贷款，必须关联相应的项目信息；\n\r");
					}
				}
				//--------------是否有进出口经营权---------------
		        if (sBusinessType.substring(0, 4).equals("1080"))
		        {
		        	sHasIERight = Sqlca.getString("select HasIERight from ENT_INFO where CustomerID = '"+sCustomerID+"' ");
		        	if(sHasIERight==null) sHasIERight="";
		        	if(sHasIERight.equals("2"))
		        		sbTips.append("业务品种为国际融资，必须有进出口经营权；\n\r");
		                
		        } 
		        System.out.println("555555555555");
		        
				//风险度检查
				//remarked by lpzhang 2009-8-19 风险度作为单独探测项
				/*String sSql = " select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
				String sCustomerType = Sqlca.getString(sSql);
				if (sCustomerType == null) sCustomerType = "";	
						
				if (sCustomerType.substring(0,2).equals("01")) //公司客户
				{
					sCount = Sqlca.getString("select Count(SerialNo) from EVALUATE_RECORD where ObjectType='CreditApply' and ObjectNo='"+sApplySerialNo +"' and EvaluateScore >=0 ");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("该申请还未进行风险度测评；\n\r");
					}
				}
				*/
							
				if (sBusinessType.equals("1080020"))	{
					sCount = Sqlca.getString("select count(SerialNo) from LC_INFO where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("业务品种为信用证项下打包贷款业务，没有相关信用证信息；\n\r");
					}					
				}
				
				if(sBusinessType.length()>=4) {
					//如果产品类型为贴现业务
					if(sBusinessType.substring(0,4).equals("1020"))	{
						sCount = Sqlca.getString("select count(SerialNo) from BILL_INFO  where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"' having sum(BillSum) = "+dBusinessSum+" ");
						if( sCount == null || Integer.parseInt(sCount) <= 0 )
						{
							sbTips.append("业务品种为贴现业务，业务金额和票据金额总和不符；\n\r");
						}
										
						sCount = Sqlca.getString("select count(SerialNo) from BILL_INFO  where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"' having count(SerialNo) = "+iBillNum+" ");
						if( sCount == null || Integer.parseInt(sCount) <= 0 )
						{
							sbTips.append("业务品种为贴现业务，业务中输入的票据张数和输入的票据张数不符；\n\r");
						}									
					}
				}
				
				//出口信用证打包贷款、出口信用证押汇与贴现、出口托收押汇与贴现、出口商业发票融资、进口信用证押汇,检查相关信用证信息
				if (sBusinessType.equals("1080020") || sBusinessType.equals("1080080") || sBusinessType.equals("1080090") || sBusinessType.equals("1080030") ||sBusinessType.equals("1080035") )	{
					sNum = 	Sqlca.getString(" select count(SerialNo) from LC_INFO where ObjectType = 'CreditApply'  and ObjectNo = '"+sApplySerialNo+"' ");
					if( sNum == null || Integer.parseInt(sNum) <= 0 )
						sbTips.append("出口托收押汇与贴现、出口商业发票融资或信用证相关业务，没有相关信用证信息；\n\r");
				}

				if ( sBusinessType.equals("1080010")) {
					sCount = Sqlca.getString("select count(SerialNo) from CONTRACT_INFO where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("出口合同打包贷款业务，没有相关贸易合同信息；\n\r");
					}					
				}

				if (sBusinessType.equals("1090020") ||  sBusinessType.equals("1090030")) {
					sCount = Sqlca.getString("select count(SerialNo) from INVOICE_INFO where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("业务品种为进口保理业务或出口保理业务，没有增值税发票信息；\n\r");
					}					
				}
				//额度项下不检查调查报告 add by zrli
				if (!"DependentApply".equals(sApplyType)){
					sCount = Sqlca.getString("select count(SerialNo) from FORMATDOC_DATA where ObjectType='CreditApply' and ObjectNo='"+sApplySerialNo +"' ");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("该申请还未填写调查报告信息；\n\r");
					}
				}
										
			}
			
			//设置参数
			//altsce.setArgValue("CustomerID",sCustomerID);			
									
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
