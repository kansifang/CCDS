<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.18
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
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0401.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4、授信方案及历史授信信息</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4.1、借款人集团客户在我行授信情况</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 > 企业名称</td>");
    sTemp.append(" <td width=20% align=center class=td1 > 授信品种 </td>");
    sTemp.append(" <td width=10% align=center class=td1 > 币种 </td>");
    sTemp.append(" <td width=10% align=center class=td1 > 批复金额(万元)</td>");
    sTemp.append(" <td width=10% align=center class=td1 > 合同金额(万元)</td>");
    sTemp.append(" <td width=10% align=center class=td1 > 合同余额 (万元)</td>");
    sTemp.append(" <td width=10% align=center class=td1 > 五级分类 </td>");
    sTemp.append(" <td width=10% align=center class=td1 > 批复到期日 </td>");
    sTemp.append(" </tr>");
    String sCustomerName = "";//企业名称
    String sBusinessTypeName = "";    //业务品种
	String sCurrencyTypeName = "";    //币种				
	String sBusinessSum = "";    //批复金额
	double dBusinessSum=0.0;
	String sBalance= "";    //合同金额
	double dBalance=0.0;											
	String sClassifyResultName = "" ;		//五级分类
	String sMaturity ="" ;//到期日
			
	//申请人基本信息
	ASResultSet rs2 = Sqlca.getResultSet("select BUSINESSTYPE,getBusinessName(BUSINESSTYPE) as BusinessTypeName,"
					+" getItemName('Currency',BUSINESSCURRENCY) as CurrencyTypeName,"
					+" businessSum,BALANCE,CLASSIFYRESULT,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName, "
					+" Maturity,CustomerID,getCustomerName(CustomerID) as CustomerName "
					+" from BUSINESS_contract " 
					+" where CustomerID in "
					+" (select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"'" 
					+" and RelationShip like '04%' )");
	
	while(rs2.next()){
		
		sBusinessTypeName = rs2.getString(2);
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
		
		sCurrencyTypeName = rs2.getString(3);
		if(sCurrencyTypeName == null) sCurrencyTypeName=" ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(4)/10000);
		if(sBusinessSum == null) sBusinessSum="0";
		
		sBalance = DataConvert.toMoney(rs2.getDouble(5)/10000);
		if(sBalance == null) sBalance="0";
		
		sClassifyResultName = rs2.getString(7);
		if(sClassifyResultName == null) sClassifyResultName=" ";
		
		sMaturity = rs2.getString(8);
		if(sMaturity == null) sMaturity=" ";
		
		sCustomerName = rs2.getString(10);
		if(sCustomerName == null) sCustomerName="";
		
		sTemp.append("   <tr>");
		sTemp.append(" 		<td width=20% align=center class=td1 > "+sCustomerName+"&nbsp;</td>");
	    sTemp.append(" 		<td width=20% align=center class=td1 >  "+sBusinessTypeName+"&nbsp; </td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sCurrencyTypeName+"&nbsp;</td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sBusinessSum+"&nbsp;</td>");
	   	sTemp.append(" 		<td width=10% align=center class=td1 > "+sBusinessSum+"&nbsp;</td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sBalance+"&nbsp;</td>");
		sTemp.append(" 		<td width=10% align=center class=td1 > "+sClassifyResultName+"&nbsp; </td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sMaturity+"&nbsp;</td>");
	    sTemp.append(" 	</tr>");
	}
    rs2.getStatement().close();
    String sSumBusinessSum = "";    //	批复金额总和
	double dSumBusinessSum = 0.0;    //	批复金额总和	
	String sSumBalance = "";		//批复余额总和
	double dSumBalance = 0.0;		//批复余额总和
    rs2 = Sqlca.getASResultSet("select sum(nvl(BC.BusinessSum,0)*geterate(BC.Businesscurrency,'01',BC.ERateDate)) as SumBusinessSum,"+
    						" sum(nvl(BC.Balance,0)*geterate(BC.Businesscurrency,'01',BC.ERateDate)) as SumBalance "+
							" from BUSINESS_contract BC"+ 
							" where BC.CustomerID in  "+
							" (select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' and RelationShip like '04%' )");
	if(rs2.next()){
		sSumBusinessSum = DataConvert.toMoney(rs2.getDouble(1));
		if(sSumBusinessSum == null) sSumBusinessSum = "0";
		sSumBalance = DataConvert.toMoney(rs2.getDouble(2));
		if(sSumBalance == null) sSumBalance = "0";
	}						
	rs2.getStatement().close();						
	sTemp.append("  <tr>");
  	sTemp.append(" <td colspan='2' align=left class=td1 > 合计：</td>");
    sTemp.append(" <td width=10% align=center class=td1 > "+"人民币"+"&nbsp; </td>");
    sTemp.append(" <td width=10% align=center class=td1 > "+sSumBusinessSum+"&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 > "+sSumBusinessSum+"&nbsp;</td>");
    sTemp.append(" <td width=10% align=center class=td1 > "+sSumBalance+"&nbsp;</td>");
    sTemp.append(" <td colspan='2' align=center class=td1 > "+"/"+"&nbsp; </td>");
    sTemp.append(" </tr>");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

