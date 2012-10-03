<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu  2009.08.18
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

<%
	//获得调查报告数据
	//获得编号
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,i=0;
	String sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '07__' and ObjectType = '"+sObjectType+"'";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(i=0;i<sNo.length;i++)
	{		
		sNo1[i] = "7."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(i=0;i<sNo.length;i++)
	{
		if(sNo[i].equals(sTreeNo.substring(0,4)))  break;
	}	
	
	sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";//担保客户ID号
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();

	sSql = "select OccurOrg,BusinessSum,Maturity,"+
	              "getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,getItemName('Currency',CURRENCY) as currencyType "+
	              "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID = '"+sGuarangtorID+"'";
	String sOccurOrg = "";
	String sCurrencyType ="";
	String sMaturity = "";
	String sBusinessSum  = "";
	String sClassifyResult = "";
	double dBusinessSum = 0.0;
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='070208.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sNo1[i]+".8、担保人在他行的对外担保情况</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=20% align=center class=td1 > 行名  </td>");
  	sTemp.append("   <td width=20% align=center class=td1 > 被担保的企业  </td>");
  	sTemp.append("   <td width=10% align=center class=td1 > 币种 </td>");
    sTemp.append("   <td width=14% align=center class=td1 > 担保金额(万元) </td>");
    sTemp.append("   <td width=18% align=center class=td1 > 担保到期日 </td>");
	sTemp.append("   <td width=18% align=center class=td1 > 主债权五级分类 </td>");
	sTemp.append("   </tr>");
	
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sOccurOrg = rs2.getString(1);
		dBusinessSum += rs2.getDouble(2);
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(2)/10000);
		sMaturity = rs2.getString(3);
		sClassifyResult = rs2.getString(4);
		sCurrencyType =rs2.getString(5);
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=20% align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
	    sTemp.append("   <td width=20% align=right class=td1 >"+""+"&nbsp;</td>");
	    sTemp.append("   <td width=10% align=center class=td1 >"+sCurrencyType+"&nbsp;</td>");
	   	sTemp.append("   <td width=10% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
	    sTemp.append("   <td width=14% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
		sTemp.append("   <td width=18% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	rs2.getStatement().close();	
	sSql = "select getitemname('Currency',Currency) as CurrencyName,sum(nvl(BusinessSum,0)*getERate('CurrencyType','01','')) "+
           "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID = '"+sCustomerID+"' group by Currency";
    rs2 = Sqlca.getResultSet(sSql);
    String sSum = "";
	while(rs2.next())
	{
		sSum += DataConvert.toMoney(rs2.getDouble(2)/10000)+"<br>"; 
	}	
	rs2.getStatement().close();	
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=2 align=center class=td1 > 合计：  </td>");
  	sTemp.append("   <td align=center class=td1 > 人民币 </td>");
    sTemp.append("   <td align=center class=td1 >"+sSum+"&nbsp;</td>");
    sTemp.append("   <td colspan=2 align=left class=td1 >"+"/ "+"</td>");
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

