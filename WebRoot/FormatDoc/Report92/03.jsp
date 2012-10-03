<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第?页
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
	int iDescribeCount = 3;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessSum = "";
	String sCurrency = "";
	String sBailRatio = "";
	String sBusinessRate = "";
	String sClassifyResult = "";
	String sVouchType = "";
	int sTermMonth = 0;
	String sCorpusPayMethod = "";
	String sMonthReturnSum = "";
	Double dRateFloat = 0.0;
	String sRateFloatType = "";
	
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,getBusinessName(BusinessType)as BusinessType,BusinessSum,"
										+"getitemname('Currency',BusinessCurrency) as CurrencyName ,BusinessRate,"
										+"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"
										+"getitemname('VouchType',VouchType) as VouchTypeName,purpose, "
										+"TermMonth,getItemname('CorpusPayMethod2',CorpusPayMethod) as CorpusPayMethod ,"
										+"RateFloat,getItemname('RateFloatType',RateFloatType) as RateFloatType , "
										+"getOrgName(OperateOrgID) as OperateOrgName,"
										+"getUserName(OperateUserID) as OperateUserName "
										+"from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "&nbsp;";
		
		sBusinessTypeName = rs2.getString("BusinessType");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum")/10000);
		
		sCurrency = rs2.getString("CurrencyName");
		if(sCurrency == null) sCurrency = " ";
		sTermMonth = rs2.getInt("TermMonth")/12;
		sBusinessRate = rs2.getString("BusinessRate");
		if(sBusinessRate  == null) sBusinessRate  = " ";
		dRateFloat = rs2.getDouble("RateFloat");
		if(dRateFloat <0) dRateFloat = 0-dRateFloat;
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = " ";
		
		sRateFloatType = rs2.getString("RateFloatType");
		if(sRateFloatType == null) sRateFloatType = " ";
		
		sVouchType = rs2.getString("VouchTypeName");
		if(sVouchType == null) sVouchType = " ";
		
		sCorpusPayMethod = rs2.getString("CorpusPayMethod");
		if(sCorpusPayMethod== null) sCorpusPayMethod = " ";
	
		}
		rs2.getStatement().close();	
		//sMonthReturnSum = DataConvert.toMoney(Sqlca.getString("select MonthReturnSum from IND_INFO where CustomerID='"+sCustomerID+"' "));
		//if(sMonthReturnSum == null) sMonthReturnSum = " ";
%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");

	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >三、调查结论和意见</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1  >7、经审核借款申请资料真实、齐全，申请人具有还款能力，符合个人贷款条件，拟同意：");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >（1）<u>"+sBusinessTypeName+"</u>（业务品种）贷款；担保方式为<u>"+sVouchType+"</u>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >（2）金额:<u>"+sBusinessSum+"</u>&nbsp;万元，币种:<u>");
	sTemp.append(sCurrency+"</u>&nbsp;，期限:<u>"+sTermMonth+"</u>&nbsp;年；");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >（3）年利率:<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:15%; height:25'",getUnitData("describe0",sData)));
	sTemp.append("</u>%（基准利率");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe7'",getUnitData("describe7",sData),"上浮@下浮"));
	//sTemp.append("&nbsp;<u>"+dRateFloat+"</u>&nbsp;浮动类型："+sRateFloatType+"(如果为浮动比率，是百分比)）；");
	sTemp.append("&nbsp;<u>"+dRateFloat+"&nbsp </u>%）</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >（4）还款方式:<u>"+sCorpusPayMethod+"&nbsp;&nbsp;&nbsp;</u>；");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >（5）月均还款额:<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' ",getUnitData("describe1",sData))+"&nbsp;</u>元。");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left class=td1 >签约见证人保证：");
	sTemp.append("   <br>");
	sTemp.append("   遵循真实、准确、完整、有效原则：<br>");
	sTemp.append("   （1）申请人所提供的资料复印件与其原件已经认真核对，保证其内容一致；<br>");
	sTemp.append("   （2）所有借款当事人在相关合同和文件上的签字均为亲笔签署，保证所有借款文件，不因签字无效而失去法律效力。");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   &nbsp;主办人签字： &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;协办人签字：");
	sTemp.append("   <br>");
	sTemp.append("   <br>");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日");
	sTemp.append("   </td>");
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

<script language=javascript>
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//客户化3
	var config = new Object();    
	//editor_generate('describe1');		//需要html编辑,input是没必要
	//editor_generate('describe2');
	//editor_generate('describe3');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
