<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2009/11/16
		Tester:
		Content: 风险分类认定报告
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
	int iDescribeCount =10 ;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader1.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%	
	ASResultSet rs = null;
	String sSql = "";
	String sContractNo = "",sGuarantyTypeName = "";//合同号
	String sCustomerName = "";//借款人名称
	String sCustomerTypeName = "";//客户类别
	String sSetupDate = "";//企业成立日
	String sRegisterAdd = "";//注册地址
	double dRegisterCapital = 0.00,dGuarantyRate = 0.00,dEvalNetValue=0.00;//注册资本,抵质押率,抵质评估价值
	String sMostBusiness = "";//主营业务
	String sBasicBank = "";//基本开户行
	String sCreditLevel = "";//信用等级
	String sLegalName = "";//法定代表人
	String sBusinessTypeName = "";//授信品种
	double dBalance = 0.00;//金额
	String sPutOutDate = "";//起始日
	String sMaturity = "";//到期日
	String sPMDate = "";//起止日期
	String sPutpose = "";//用途
	String sGuarantorName = "";//保证人
	double dInterestBalance = 0.00;//欠息
	String sClassifyResultName = "";//风险分类结果
	String sActualBusiness = ""; //
	
	//获得关联合同号
	sSql = "select ObjectNo from CLASSIFY_RECORD where  serialno='"+sObjectNo+"'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sContractNo = rs.getString("ObjectNo");
	}
	rs.getStatement().close();
	
	//获得客户号
	sSql = "select CustomerID from BUSINESS_CONTRACT  where  serialno='"+sContractNo+"'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
	}
	rs.getStatement().close();
	
	//获得客户基本信息
	sSql = " select CI.CustomerName as CustomerName,"+
				 " getItemName('CustomerType',CI.CustomerType) as CustomerTypeName,"+
				 " EI.SetupDate as SetupDate,EI.RegisterAdd as RegisterAdd,"+
				 " EI.RegisterCapital as RegisterCapital,EI.ActualBusiness as ActualBusiness,"+
				 " nvl(EI.BasicBank,'') as BasicBank,EI.CreditLevel as CreditLevel"+
				" from customer_info CI,ENT_INFO EI "+
				" where CI.CUSTOMERID=EI.CUSTOMERID "+
				 " and CI.CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sCustomerName = rs.getString("CustomerName");
		sCustomerTypeName = rs.getString("CustomerTypeName");
		sSetupDate = rs.getString("SetupDate");
		sRegisterAdd = rs.getString("RegisterAdd");
		dRegisterCapital = rs.getDouble("RegisterCapital");
		sActualBusiness = rs.getString("ActualBusiness");
		if(sActualBusiness == null) sActualBusiness = "";
		sBasicBank = rs.getString("BasicBank");
		sCreditLevel = rs.getString("CreditLevel");
		
 	}
	rs.getStatement().close();
	
	//取法定代表人
	sSql = " select getCustomerName(RelativeID) as LegalName"+
		" from customer_relative "+
		" where  CustomerID='"+sCustomerID+"' and RelationShip='0100'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sLegalName = rs.getString("LegalName");
	}
	rs.getStatement().close();
	
	//取合同相关信息
	sSql = " select BC.SerialNo as ContractNo,"+
			" getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.Balance/10000 as Balance,BC.PutOutDate as PutOutDate,"+
			" BC.Maturity as Maturity,'',BC.Purpose as Putpose,'',"+
			" (BC.InterestBalance1+BC.InterestBalance2)/10000 as InterestBalance,"+
			" getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName "+
		" from BUSINESS_CONTRACT BC "+
		" where BC.SerialNo='"+sContractNo+"' ";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sBusinessTypeName = rs.getString("BusinessTypeName");
		dBalance = rs.getDouble("Balance")/10000;
		sPutOutDate = rs.getString("PutOutDate");
		sMaturity = rs.getString("Maturity");
		sPutpose = rs.getString("Putpose");
		dInterestBalance = rs.getDouble("InterestBalance")/10000;
		sClassifyResultName = rs.getString("ClassifyResultName");
		if(sPutOutDate != null)
		{
			sPMDate = sPutOutDate+"—"+sMaturity;
		}
	}
	rs.getStatement().close();

	//取担保信息
	sSql = " select nvl(GC.GuarantorName,'') as GuarantorName,"+
			" nvl(GI.GuarantyRate,0) as GuarantyRate,"+
			" nvl(GI.EvalNetValue,0) as EvalNetValue, "+
			" getItemName('GuarantyList',GI.GuarantyType) as GuarantyTypeName "+
		" from GUARANTY_RELATIVE GR,GUARANTY_CONTRACT GC,GUARANTY_INFO GI "+
		" where GR.contractNo=GC.SERIALNO and GR.GUARANTYID=GI.GUARANTYID "+
		" and GR.objectType='BusinessContract' "+
		" and GR.ObjectNo='"+sContractNo+"' ";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sGuarantorName = rs.getString("GuarantorName");
		dGuarantyRate = rs.getDouble("GuarantyRate");
		dEvalNetValue = rs.getDouble("EvalNetValue")/10000;
		sGuarantyTypeName = rs.getString("GuarantyTypeName");
	}
	rs.getStatement().close();
	String sNation = "";
	double dTotalBalance = Sqlca.getDouble("select sum(balance) from business_contract where customerid = '"+sCustomerID+"'");
	if(dTotalBalance > 5000000){
		sNation = "一般企业";
	}else{
		sNation = "小企业";
	}
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0101.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=center colspan=15 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >公司类客户信贷资产风险分类认定表</font></td> ");	
	sTemp.append("   </tr>");	
	
    sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >填报单位</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+CurOrg.OrgName+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >分类日期</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >"+""+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >币种：人民币</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >单位：万元</td>");
	sTemp.append("   </tr>");
		
    sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >借款人名称</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+sCustomerName+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >注册资本</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+dRegisterCapital+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >法人代表</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+sLegalName+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
    sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >主营业务</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+sActualBusiness+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >适用分类标准</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+sNation+"&nbsp;</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >信用等级</td>");	
	sTemp.append("   <td  colspan=2 align=left class=td1 >"+sClassifyResultName+"&nbsp;</td>");
	sTemp.append("   </tr>");	
	
    sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >借款合同号</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >授信产品种类</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >金额</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >发放日期</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >到期日</td>");	
	sTemp.append("   <td  colspan=1 align=left class=td1 >是否低风险业务</td>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >担保方式</td>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >本息逾期情况</td>");
	sTemp.append("   <td  colspan=1 align=left class=td1 >分类结果</td>");
	sTemp.append("   </tr>");		

	String sBusinessType = "";
	String sBusinessSum = "";
	//String sPutOutDate = "";
	//String sMaturity = "";
	String sLowRisk = "";
	String sVouchType = "";
	String sClassifyResult = "";
	sSql = " select getBusinessName(BusinessType) as BusinessType,BusinessSum,PutOutDate,Maturity,"+
		   " getItemName('YesNo',LowRisk) as LowRisk,getItemName('VouchType',VouchType) as VouchType,"+
		   " getItemName('ClassifyResult',ClassifyResult) as ClassifyResult "+
		   " from Business_Contract where SerialNo = '"+sContractNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		 sBusinessType = rs.getString("BusinessType");
		 sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum")/10000);
		 sPutOutDate = rs.getString("PutOutDate");
		 sMaturity = rs.getString("Maturity");
		 sLowRisk = rs.getString("LowRisk");
		 sVouchType = rs.getString("VouchType");
		 sClassifyResult = rs.getString("ClassifyResult");
		 if(sBusinessType == null) sBusinessType = "";
		 if(sBusinessSum == null) sBusinessSum = "";
		 if(sPutOutDate == null) sPutOutDate = "";
		 if(sMaturity == null) sMaturity = "";
		 if(sLowRisk == null) sLowRisk = "";
		 if(sVouchType == null) sVouchType = "";
		 if(sClassifyResult == null) sClassifyResult = "";
		 
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sContractNo+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sBusinessType+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sPutOutDate+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sMaturity+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sLowRisk+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sVouchType+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+""+"&nbsp;</td>");
		 sTemp.append("   <td  colspan=1 align=left class=td1 >"+sClassifyResult+"&nbsp;</td>");
	}
	rs.getStatement().close(); 
	 
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1  colspan=9 align=left  ><font style=' font-size: 10pt;FONT-FAMILY:宋体;'>客户经理风险评级理由及初步分类意见:</font></td>"); 	
	sTemp.append("   </tr>");	
  	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=15 class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   </tr>");
  	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1  colspan=9 align=left  ><font style=' font-size: 10pt;FONT-FAMILY:宋体;'>支行、营业部负责人意见:</font></td>"); 	
	sTemp.append("   </tr>");	
  	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=9 class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   </tr>");
     
  	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1  colspan=9 align=left  ><font style=' font-size: 10pt;FONT-FAMILY:宋体;'>风险管控部门认定员分类认定意见:</font></td>"); 	
	sTemp.append("   </tr>");	
  	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=9 class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:100'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   </tr>");   
     
	
	sTemp.append("</table>");	
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

<%@include file="/FormatDoc/IncludeFDFooter.jsp"%>

<script language=javascript >
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//客户化3
	var config = new Object();  
	editor_generate('describe1');		//需要html编辑,input是没必要
	editor_generate('describe2');		//需要html编辑,input是没必要
	editor_generate('describe3');		//需要html编辑,input是没必要
<%
	}
%>	
</script>
	
<%@ include file="/IncludeEnd.jsp"%>