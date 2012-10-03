<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2011/04/30
		Tester:
		Content: 授信业务通知书第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//获得调查报告数据
	
	String sSql = "select ContractSerialNo,DuebillSerialNo,BP.CustomerID,BP.CustomerName,getBusinessName(BusinessType),"+
				  "getitemname('Currency',BusinessCurrency) as BusinessCurrency,LoanType,getItemName('CreditLineFlag',CreditLineFlag),CreditAggreement,"+
				  "getItemName('CreditKind',CreditKind),PutOutDate,Maturity,ContractSum,BusinessSum,Purpose,getItemName('AdjustRateType',AdjustRateType),"+
				  "AdjustRateTerm,getItemName('ICCyc',ICCyc),FixCyc,BusinessRate,getItemName('AcceptIntType',AcceptIntType),getItemName('PreIntType',PreIntType),"+
				  "getItemName('ResumeIntType',ResumeIntType),AccountNo,LoanAccountNo,SecondPayAccount,getItemName('OverIntType',OverIntType),"+
				  "getItemName('RateAdjustCyc',RateAdjustCyc),getItemName('RateFloatType',RateFloatType),GuarantyNo,RiskRate,getOrgName(OperateOrgID),GatheringName,RateFloat, "+
				  " CI.MFCustomerID,getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID,BP.BaseRate,BP.ApprovalNo as ApprovalNo,BP.BillAmount as BillAmount, "+
				  " BP.BusinessType as BusinessType "+
				  " from BUSINESS_PUTOUT BP,CUSTOMER_INFO CI where SerialNo = '"+sObjectNo+"' and BP.CustomerID = CI.CustomerID";
	
	String sContractSerialNo = "";
	String sDuebillSerialNo = "";
	String sCustomerID = "";
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessCurrency = "";
	String sLoanType = "";
	String sCreditLineFlag = "";
	String sCreditAggreement = "";
	String sCreditKind = "";
	String sPutOutDate = "";
	String sMaturity = "";
	String sContractSum = "";
	String sBusinessSum = "";
	String sPurpose = "";
	String sAdjustRateType = "";
	String sAdjustRateTerm = "";
	String sICCyc = "";
	String sFixCyc = "";
	String sBusinessRate = "";
	String sAcceptIntType = "";
	String sPreIntType = "";
	String sResumeIntType = "";
	String sAccountNo = "";
	String sLoanAccountNo = "";
	String sSecondPayAccount = "";
	String sOverIntType = "";
	String sRateAdjustCyc = "";
	String sRateFloatType = "";
	String sRateFloat = "";
	String sGuarantyNo = "";
	String sRiskRate = "";
	String sOperateOrgID = "";
	String sGatheringName = "";
	String sApprovalNo = "";
	String[] sGuarantor = null;
	String sTemp1 = getGuarantyNameByBP(sObjectNo,Sqlca);
	if(sTemp1==null || sTemp1.length()==0) sTemp1=" , ";
	sGuarantor = sTemp1.split(",");
	String sMFCustomerID = "";
	String sCertTypeName = "";
	String sCertID = "";
	String sBaseRate = "";
	String sBillAmount = "";
	String sBusinessType = "";
	double dBaseRate = 0.00;
	double dBusinessRate = 0.00;
	double dRateFloat = 0.00;
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='6002.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);

	if(rs2.next())
	{
		sContractSerialNo = rs2.getString(1);
		if(sContractSerialNo == null) sContractSerialNo = "";
		
		sDuebillSerialNo = rs2.getString(2);
		if(sDuebillSerialNo == null) sDuebillSerialNo = "";
		
		sCustomerID = rs2.getString(3);
		if(sCustomerID == null) sCustomerID = "";
		
		sCustomerName = rs2.getString(4);
		if(sCustomerName == null) sCustomerName = "";
		
		sBusinessTypeName = rs2.getString(5);
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		
		sBusinessCurrency = rs2.getString(6);
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		
		sLoanType = rs2.getString(7);
		if(sLoanType == null) sLoanType = "";
		
		sCreditLineFlag = rs2.getString(8);
		if(sCreditLineFlag == null) sCreditLineFlag = "";
		
		sCreditAggreement = rs2.getString(9);
		if(sCreditAggreement == null) sCreditAggreement = "";
		
		sCreditKind = rs2.getString(10);
		if(sCreditKind == null) sCreditKind = "";
		
		sPutOutDate = rs2.getString(11);
		if(sPutOutDate == null) sPutOutDate = "";
		
		sMaturity = rs2.getString(12);
		if(sMaturity == null) sMaturity = "";
		
		sContractSum = DataConvert.toMoney(rs2.getDouble(13));
		
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(14));
		
		sPurpose = rs2.getString(15);
		if(sPurpose == null) sPurpose = "";
		
		sAdjustRateType = rs2.getString(16);
		if(sAdjustRateType == null) sAdjustRateType = "";
		
		sAdjustRateTerm = rs2.getString(17);
		if(sAdjustRateTerm == null) sAdjustRateTerm = "";
		
		sICCyc = rs2.getString(18);
		if(sAcceptIntType == null) sAcceptIntType = "";
		
		sFixCyc = rs2.getString(19);
		if (sFixCyc == null){ 
			sFixCyc = "";
		}else{
			sFixCyc = String.valueOf(Integer.parseInt(sFixCyc));
		}
		
		NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
        dBusinessRate = rs2.getDouble(20);
		if(dBusinessRate == 0.00)
		{
			sBusinessRate="/";
		}else{
			sBusinessRate = String.valueOf(dBusinessRate);
		}
		dRateFloat = rs2.getDouble(34);
		if(dRateFloat == 0.00)
		{
			sRateFloat="/";
		}else{
			sRateFloat = String.valueOf(dRateFloat);
		}
		//sRateFloat = nf.format(rs2.getDouble(34));
		//sBusinessRate = nf.format(rs2.getDouble(20));
		sAcceptIntType = rs2.getString(21);
		if(sAcceptIntType == null) sAcceptIntType = "";
		
		sPreIntType = rs2.getString(22);
		if(sPreIntType == null) sPreIntType = "";
		
		sResumeIntType = rs2.getString(23);
		if(sResumeIntType == null) sResumeIntType = "";
		
		sAccountNo = rs2.getString(24);
		if(sAccountNo == null) sAccountNo = "";
		
		sLoanAccountNo = rs2.getString(25);
		if(sLoanAccountNo == null) sLoanAccountNo = "";
		
		sSecondPayAccount = rs2.getString(26);
		if(sSecondPayAccount == null) sSecondPayAccount = "";
		
		sOverIntType = rs2.getString(27);
		if(sOverIntType == null) sOverIntType = "";
		
		sRateAdjustCyc = rs2.getString(28);
		if(sRateAdjustCyc == null) sRateAdjustCyc = "";
		
		sRateFloatType = rs2.getString(29);
		if(sRateFloatType == null) sRateFloatType = "";
		
		sGuarantyNo = rs2.getString(30);
		if(sGuarantyNo == null) sGuarantyNo = "";
		
		nf.setMinimumFractionDigits(0);
        nf.setMaximumFractionDigits(7);
		sRiskRate = nf.format(rs2.getDouble(31));
		
		sOperateOrgID = rs2.getString(32);
		if(sOperateOrgID == null) sOperateOrgID = "";
		sOperateOrgID=sOperateOrgID.replace("天津农商银行","");
		
		sGatheringName = rs2.getString(33);
		if(sGatheringName == null) sGatheringName = "";
		sMFCustomerID = rs2.getString("MFCustomerID");
		if(sMFCustomerID == null) sMFCustomerID = "";
		
		sCertTypeName = rs2.getString("CertTypeName");
		if(sCertTypeName == null) sCertTypeName = "";
		sBusinessType = rs2.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = "";
		sCertID = rs2.getString("CertID");
		if(sCertID == null) sCertID="";			
		dBaseRate = rs2.getDouble("BaseRate");
		if(dBaseRate == 0.00)
		{
			sBaseRate="/";
		}else{
			sBaseRate = String.valueOf(dBaseRate);
		}
		sApprovalNo = rs2.getString("ApprovalNo");
		if(sApprovalNo == null) sApprovalNo="";
		sBillAmount = String.valueOf(rs2.getInt("BillAmount"));
		if(sBillAmount == null) sBillAmount="";
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white>	");
		sTemp.append("   <font style=' font-size: 22pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:white' ><br><center>天津农商银行授信业务通知书</center><br>&nbsp;</font>");
		sTemp.append("   <p align=right>信贷系统出账流水号："+sObjectNo+"&nbsp;</p> ");
		sTemp.append("   <p align=right>&nbsp;&nbsp;&nbsp;&nbsp;批复编号："+("".equals(sApprovalNo)?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;":(sApprovalNo+"&nbsp;&nbsp;&nbsp;&nbsp;"))+"</p> ");
		sTemp.append("<p >&nbsp;</p> ");
		sTemp.append("   <p align=left>天津农商银行<u>&nbsp;"+sOperateOrgID+"</u>：</p> ");
		sTemp.append("   <p >");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;经我部门对<u>&nbsp;"+sCustomerName+"</u>（借款人）向贵行提交的编号为： <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>");
		sTemp.append("《提款申请》/《承兑申请书》中所涉及授信业务的审核确认，同意贵行办理编号为：<u>"+("".equals(sApprovalNo)?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;":sApprovalNo)+"</u>");
		sTemp.append("《天津农商银行授信审批管理委员会批复/天津农商银行授信业务批复》项下授信额度内业务，具体情况如下：<br>");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;1、业务品种：<u>&nbsp;"+sBusinessTypeName+"</u>；币种：<u>&nbsp;"+sBusinessCurrency+"</u>；");
		sTemp.append("金额：<u>&nbsp;"+sBusinessSum+"</u>（元）；基准利率（%）：<u>&nbsp;"+sBaseRate+"</u>；");
		sTemp.append("浮动比率（%）：<u>&nbsp;"+sRateFloat+"</u>； 执行月利率（‰）：<u>&nbsp;"+sBusinessRate+"</u>。");
		sTemp.append("<br> ");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;2、贷款日(签发日)：<u>"+sPutOutDate.substring(0,4)+"</u>年<u>"+sPutOutDate.substring(5,7)+"</u>月 <u>"+sPutOutDate.substring(8,10)+"</u>日；");
		sTemp.append("到期日：<u>"+sMaturity.substring(0,4)+"</u>年<u>"+sMaturity.substring(5,7)+"</u>月 <u>"+sMaturity.substring(8,10)+"</u>日。");
		sTemp.append("<br> ");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;3、银行承兑汇票<u>&nbsp;"+("2010".equals(sBusinessType)?sBillAmount:"/")+"</u>张，票面金额共计 <u>&nbsp;"+("2010".equals(sBusinessType)?sContractSum:"/")+"</u>元，出票明细以《银行承兑协议》附件1“银行承兑汇票清单”为准。");
		sTemp.append("<br> ");
		sTemp.append("<p >");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;请会计人员凭此通知书办理相关出账（出票）手续。");
		sTemp.append("</p> ");
		sTemp.append("<p >&nbsp;</p> ");
		sTemp.append("<p >&nbsp;</p> ");
		sTemp.append("<p >&nbsp;</p> ");
		sTemp.append("<p align=left>&nbsp;&nbsp;&nbsp;&nbsp;放款审核员：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;有权审批人：</p> ");
		sTemp.append("<p align=left>&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：</p> ");
		sTemp.append("<p align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（部门公章）：</p> ");
		sTemp.append("<p >&nbsp;</p> ");
		sTemp.append("<p >&nbsp;</p> ");
		sTemp.append("<p >&nbsp;</p> ");
		sTemp.append("<p >&nbsp;</p> ");
		sTemp.append("<p >&nbsp;</p> ");
		sTemp.append("</table>");		
	}
	rs2.getStatement().close();	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='"+CurComp.ClientID+"'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='"+CurPage.ClientID+"'>");
	sTemp.append("</form>");	

	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludePOFooter.jsp"%>

<script language=javascript>
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//客户化3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

