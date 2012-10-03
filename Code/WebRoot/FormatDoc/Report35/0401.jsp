<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   Author:   zwhu 2009.08.18
		Tester:
		Content: 报告的第?页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
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
	sTemp.append("<form method='post' action='0401.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4、授信方案及历史授信信息</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4.1、借款人现有授信</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=10% align=center class=td1 > 授信方式 </td>");
    sTemp.append(" 		<td width=10% align=center class=td1 > 授信品种 </td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >币种</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >批复金额（万元）</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >合同金额（万元）</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >合同余额（万元）</td>");
   	sTemp.append(" 		<td width=10% align=center class=td1 >保证金比例%</td>");
   	sTemp.append(" 		<td width=10% align=center class=td1 >最近到期日</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >担保方式</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >五级分类</td>");
    sTemp.append(" 	</tr>");
    
	String sBusinessTypeName = "";    //业务品种
	String sCurrencyType = "";    //币种					
	String sBusinessSum = "";    //金额
	double dBusinessSum=0.0;
	String sBalance= "";    //合同余额
	double dBalance=0.0;											
	String sBailRatio = "";   	//保证金比例
	double dBailRatio = 0.00;
	String sClassifyResultName = "" ;		//五级分类
	String sMaturity ="" ;//到期日
	String sVouchType = "" ;//担保方式
	String sApplyType = "";//授信方式				
	//申请人基本信息
	ASResultSet rs2 = Sqlca.getResultSet("select BUSINESSTYPE,getBusinessName(BUSINESSTYPE) as BusinessTypeName,getItemName('Currency',BUSINESSCURRENCY),"
								+" businessSum,BailRatio,Balance,CLASSIFYRESULT,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName, "
								+" Maturity,getItemName('VouchType',VouchType) as VouchType "
								+" ,getItemName('BusinessApplyType',ApplyType) as ApplyType "
								+" from BUSINESS_contract where customerID='"+sCustomerID+"'" );
	while(rs2.next()){
		sBusinessTypeName = rs2.getString(2);
		if(sBusinessTypeName == null) sBusinessTypeName=" ";
	
		sCurrencyType = rs2.getString(3);
		if(sCurrencyType == null) sCurrencyType=" ";
		
		sBusinessSum = rs2.getString(4);
		if(sBusinessSum == null) sBusinessSum="0";
		dBusinessSum = DataConvert.toDouble(sBusinessSum)/10000;
		
		sBailRatio = rs2.getString(5);
		if(sBailRatio == null) sBailRatio="0";
		dBailRatio = DataConvert.toDouble(sBailRatio);
		
		sBalance = rs2.getString(6);
		if(sBalance == null) sBalance="0";
		dBalance = DataConvert.toDouble(sBalance)/10000;
		
		sClassifyResultName = rs2.getString(8);
		if(sClassifyResultName == null) sClassifyResultName=" ";
		
		sMaturity = rs2.getString(9);
		if(sMaturity == null) sMaturity=" ";
		
		sVouchType = rs2.getString(10);
		if(sVouchType == null) sVouchType=" ";
		
		sApplyType = rs2.getString("ApplyType");
		if(sApplyType == null) sApplyType = "";	
		
		sTemp.append("   <tr>");
	  	sTemp.append(" 		<td width=10% align=center class=td1 > "+sApplyType+"&nbsp; </td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 >  "+sBusinessTypeName+"&nbsp; </td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sCurrencyType+"&nbsp;</td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+dBusinessSum+"&nbsp;</td>");
	   	sTemp.append(" 		<td width=10% align=center class=td1 > "+dBusinessSum+"&nbsp;</td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+dBalance+"&nbsp;</td>");
	    	sTemp.append(" 		<td width=10% align=center class=td1 > "+dBailRatio+"&nbsp;</td>");
		sTemp.append(" 		<td width=10% align=center class=td1 > "+sMaturity+"&nbsp; </td>");
		sTemp.append(" 		<td width=10% align=center class=td1 > "+sVouchType+"&nbsp; </td>");
	    sTemp.append(" 		<td width=10% align=center class=td1 > "+sClassifyResultName+"&nbsp;</td>");
	    sTemp.append(" 	</tr>");
	}
    rs2.getStatement().close();
	String sSql = "select sum(nvl(BusinessSum,0)*geterate(Businesscurrency,'01',ERateDate)),"+
		    " sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)) "+
            " from BUSINESS_CONTRACT where customerID='"+sCustomerID+"'";
    rs2 = Sqlca.getResultSet(sSql);
    String sSumBusinessSum = "";
    double dSumBusinessSum = 0.0;
    String sSumBalance = "";
    double dSumBalance = 0.0;
	while(rs2.next())
	{	sSumBusinessSum = rs2.getString(1);
		if(sSumBusinessSum == null) sSumBusinessSum="0";
		dSumBusinessSum = DataConvert.toDouble(sSumBusinessSum)/10000;
		sSumBalance = rs2.getString(2);
		if(sSumBalance == null) sSumBalance="0";
		dSumBalance = DataConvert.toDouble(sSumBalance)/10000;
	}
    rs2.getStatement().close();
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan='2' align=left class=td1 > 合计: </td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >人民币</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >"+dSumBusinessSum+"&nbsp;</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >"+dSumBusinessSum+"&nbsp;</td>");
    sTemp.append(" 		<td width=10% align=center class=td1 >"+dSumBalance+"&nbsp;</td>");
   	sTemp.append(" 		<td colspan='2' align=center class=td1 >授信敞口（万元）</td>");
    sTemp.append(" 		<td colspan='2' align=center class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
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
