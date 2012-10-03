<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hldu  20120731
		Tester:
		Content: 授信及担保信息
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
    //定义变量
    ASResultSet rs = null;            // 结果集
	String sRelativeID = "";          // 借款人配偶客户编号
	String sCustomerName = "";        // 借款人或配偶姓名
	String sBusinessTypeName = "";    // 品种
	int iMoneyUnit = 10000;           // 单位万元
	String sBalance = "";             // 余额
	double dBalance = 0.0;            // 余额
	String sCurrencyName = "";        // 币种
	String sTermMonth = "";           // 期限月
	String sBailRatio = "";           // 保证金比例
	String sBusinessRate = "";        // 月利率
	String sClassifyResult = "";      // 五级分类
	String sBalanceSum = "";
	double dBalanceSum = 0.0;
	String whereClause = "''";
	String sSql3 = "";
	String sGuarantorID = "";
	String sBusinessSum = "";
	double dBusinessSum = 0.0;
	String sVouchType = "";
	String sMaturity = "" ; 
	
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='a.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table class=table1 width='640'  align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >借款人及配偶在我行授信及对外担保情况</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >借款人及配偶在我行授信业务信息</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >姓名</td>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >授信业务品种</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >余额（万元）</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >币种</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >授信期限（月）</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >保证金比例%</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >月利率‰</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >五级分类</td>");
	sTemp.append("   </tr>");
	sCustomerID = Sqlca.getString(" select CustomerID from Business_Apply where SerialNo = '"+sObjectNo+"' ");
	sRelativeID = Sqlca.getString(" select RelativeID from Customer_Relative where CustomerID = '"+sCustomerID+"' and RelationShip = '0301'");
	if(sRelativeID == null) sRelativeID = "";
	sSql3 = " select getCustomerName(CustomerID) as CustomerName,getBusinessName(BusinessType) as BusinessTypeName, "
	       + " Balance,getItemName('Currency',BusinessCurrency) as CurrencyName,TermMonth,BailRatio,BusinessRate,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult "
	       + " from Business_Contract where CustomerID in ('"+sCustomerID+"','"+sRelativeID+"') order by CustomerID ";
	rs = Sqlca.getASResultSet(sSql3);
	while (rs.next())
	{
		sCustomerName = rs.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "";
		sBusinessTypeName = rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		dBalance = rs.getDouble("Balance");
		sBalance = DataConvert.toMoney(dBalance/iMoneyUnit);
		sCurrencyName = rs.getString("CurrencyName");
		if(sCurrencyName == null) sCurrencyName = "";
		sTermMonth = rs.getString("TermMonth");
		if(sTermMonth == null) sTermMonth = "";
		sBailRatio = rs.getString("BailRatio");
		if(sBailRatio == null) sBailRatio = "";
		sBusinessRate = rs.getString("BusinessRate");
		if(sBusinessRate == null) sBusinessRate = "";
		sClassifyResult = rs.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = "";
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   <td  colspan=2 align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sBalance+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sCurrencyName+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sTermMonth+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sBailRatio+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs.getStatement().close();	
	dBalanceSum = Sqlca.getDouble(" select sum(Balance) from Business_Contract where CustomerID in ('"+sCustomerID+"','"+sRelativeID+"')");
	sBalanceSum = DataConvert.toMoney(dBalanceSum/iMoneyUnit);
	sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >总计：</td>");
	sTemp.append("   <td  colspan=8 align=left class=td1 >&nbsp;人民币&nbsp;"+sBalanceSum+"</td>");
	sTemp.append("   </tr>");
    sSql3 = " select getCustomerName(GC.GuarantorID) as CustomerName,getBusinessName(BC.BusinessType) as BusinessTypeName, "
          + " BC.Balance as Balance,getItemName('Currency',GC.GuarantyCurrency) as CurrencyName,BC.TermMonth as TermMonth, "
          + " BC.BailRatio as BailRatio,BC.BusinessRate as BusinessRate,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult "
          + " from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR "
          + " where CR.ObjectNo = GC.serialNo and CR.ObjectType = 'GuarantyContract' and BC.SerialNo=CR.SerialNo and GC.GuarantorID in ('"+sCustomerID+"','"+sRelativeID+"') and ContractStatus = '020' order by GC.GuarantorID ";
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >借款人及配偶在我行对外担保信息</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >姓名</td>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >授信业务品种</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >余额（万元）</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >币种</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >授信期限（月）</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >保证金比例%</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >月利率‰</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >五级分类</td>");
	sTemp.append("   </tr>");
	rs = Sqlca.getASResultSet(sSql3);
	while (rs.next())
	{
		sCustomerName = rs.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "";
		sBusinessTypeName = rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		dBalance = rs.getDouble("Balance");
		sBalance = DataConvert.toMoney(dBalance/iMoneyUnit);
		sCurrencyName = rs.getString("CurrencyName");
		if(sCurrencyName == null) sCurrencyName = "";
		sTermMonth = rs.getString("TermMonth");
		if(sTermMonth == null) sTermMonth = "";
		sBailRatio = rs.getString("BailRatio");
		if(sBailRatio == null) sBailRatio = "";
		sBusinessRate = rs.getString("BusinessRate");
		if(sBusinessRate == null) sBusinessRate = "";
		sClassifyResult = rs.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = "";
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   <td  colspan=2 align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sBalance+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sCurrencyName+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sTermMonth+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sBailRatio+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sBusinessRate+"&nbsp;</td>");
		sTemp.append("   <td  colspan=1 align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs.getStatement().close();
	dBalanceSum = Sqlca.getDouble(" select sum(BC.Balance) from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR where CR.ObjectNo = GC.serialNo and CR.ObjectType = 'GuarantyContract' and BC.SerialNo=CR.SerialNo and GC.GuarantorID in ('"+sCustomerID+"','"+sRelativeID+"') and ContractStatus = '020' ");
	sBalanceSum = DataConvert.toMoney(dBalanceSum/iMoneyUnit);
	sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >总计：</td>");
	sTemp.append("   <td  colspan=8 align=left class=td1 >&nbsp;人民币&nbsp;"+sBalanceSum+"</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >借款人及配偶在他行未结清授信</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >行名</td>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >授信业务品种</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >授信额度（万元）</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >余额（万元）</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >起始日</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >到期日</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >担保方式</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >五级分类</td>");
	sTemp.append("   </tr>");
	String sSql = "select OccurOrg,BusinessType,getItemName('OtherBusinessType',BusinessType) as BusinessTypeName, "+
    "Balance,BeginDate,Maturity,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,BusinessSum ,getItemName('VouchType',VouchType) "+
    "from CUSTOMER_OACTIVITY where CustomerID in ('"+sCustomerID+"','"+sRelativeID+"') and BusinessType <>'08' and Balance >0" ;
	String sOccurOrg = "";
	String sBusinessType = "";

	String sBeginDate = "";

	String sGuarantyTypeName = "";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sOccurOrg = rs2.getString(1);
		if(sOccurOrg == null) sOccurOrg = " ";
		sBusinessType = rs2.getString(2);
		sBusinessTypeName = rs2.getString(3);
		if(sBusinessTypeName == null) sBusinessTypeName = " ";
		sBalance = DataConvert.toMoney(rs2.getDouble(4)/10000);
		sBeginDate = rs2.getString(5);
		if(sBeginDate == null) sBeginDate = " ";
		sMaturity = rs2.getString(6);
		if(sMaturity == null) sMaturity = " ";
		sClassifyResult = rs2.getString(7);
		if(sClassifyResult == null) sClassifyResult = " ";
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(8)/10000);
		sGuarantyTypeName = rs2.getString(9);
		if(sGuarantyTypeName == null) sGuarantyTypeName = " ";
		sTemp.append("   <tr>");
	  	sTemp.append("   <td colspan=2  align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
	    sTemp.append("   <td colspan=2 align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	    sTemp.append("   <td colspan=1 align=center class=td1 >"+sBusinessSum+"&nbsp; </td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >"+sBalance+"&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >"+sBeginDate+"&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >"+sMaturity+"&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >"+sGuarantyTypeName+"/&nbsp;</td>");    
	    sTemp.append("   <td colspan=1  align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
    }  
    rs2.getStatement().close();	
	sSql = "select sum(BusinessSum),sum(Balance) "+
    "from CUSTOMER_OACTIVITY where CustomerID = '"+sCustomerID+"' and BusinessType <>'08' and Balance >0";
	rs2 = Sqlca.getResultSet(sSql);
	String sSum = "";
	String sSum1 = "" ;
	while(rs2.next())
	{
	sSum += DataConvert.toMoney(rs2.getDouble(1)/10000); 
	sSum1 +=DataConvert.toMoney(rs2.getDouble(2)/10000);
	}	
	rs2.getStatement().close();
	sTemp.append("   <tr>");
	sTemp.append("   	<td colspan=2 align=center class=td1 > 合计: </td>");
	sTemp.append("   	<td colspan=2 align=center class=td1 > 人民币 </td>");
	sTemp.append("   	<td colspan=1 align=center class=td1 >"+sSum+"&nbsp</td>");
	sTemp.append("   	<td colspan=1 align=center class=td1 >"+sSum1+"&nbsp</td>");
	sTemp.append("   	<td colspan=4 align=left class=td1 >"+"/"+"&nbsp;</td>");
	sTemp.append("</tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >借款人及配偶在他行对外担保情况</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >行名</td>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >被担保人</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >币种</td>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >担保金额（万元）</td>");
	sTemp.append("   <td  colspan=1 align=center class=td1 >担保到期日</td>");
	sTemp.append("   <td  colspan=2 align=center class=td1 >主债权五级分类</td>");
	sTemp.append("   </tr>");
    sSql3 = "select OccurOrg,BusinessSum,Maturity,"+
    "getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,getItemName('Currency',CURRENCY) as currencyType "+
    "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID in ('"+sCustomerID+"','"+sRelativeID+"')";
    rs = Sqlca.getResultSet(sSql3);

	String sCurrencyType ="";
	while(rs.next())
	{
		sOccurOrg = rs.getString(1);
		dBusinessSum += rs.getDouble(2);
		sBusinessSum = DataConvert.toMoney(rs.getDouble(2)/10000);;
		sMaturity = rs.getString(3);
		sClassifyResult = rs.getString(4);
		if(sClassifyResult == null) sClassifyResult = " ";
		sCurrencyType =rs.getString(5);
		sTemp.append("   <tr>");
	  	sTemp.append("   <td colspan=2 align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
	    sTemp.append("   <td colspan=2 align=right class=td1 >"+""+"&nbsp;</td>");
	    sTemp.append("   <td colspan=1 align=center class=td1 >"+sCurrencyType+"&nbsp;</td>");
	   	sTemp.append("   <td colspan=2 align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
	    sTemp.append("   <td colspan=1 align=center class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs.getStatement().close();	

	sSql3 = "select sum(nvl(BusinessSum,0)) "+
           "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID in ('"+sCustomerID+"','"+sRelativeID+"')";
    rs = Sqlca.getResultSet(sSql3);
   //s String sSum = "";
	if(rs.next())
	{
		sSum = DataConvert.toMoney(rs.getDouble(1)/10000); 		
	}	
	rs.getStatement().close();	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=2 align=left class=td1 > 合计：</td>");
  	sTemp.append("   <td colspan=8 align=center class=td1 > 人民币"+sSum+"&nbsp;</td>");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
