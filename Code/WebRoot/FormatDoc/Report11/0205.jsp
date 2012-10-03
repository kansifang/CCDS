<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   bqliu 2011-04-29
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   
				FirstSection: 
		Output param:

		History Log: pliu 2011.08.03
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
	//获得调查报告数据
	String sCustomerName = "";//被担保企业
	String sOccurOrg = "";//授信金融机构
	String sBusinessSum  = "";//合同金额
	String sMaturity = "";//到期日
	String sVouchType = "";//担保方式
	String Temp = "";//被担保企业设为空
	String sSql = "select '"+Temp+"' as CustomerName, OccurOrg,"+
	              "nvl(BusinessSum,0)*getERate(Currency,'01','') as BusinessSum,"+
	              "Maturity,getItemName('VouchType',VouchType) as VouchType "+
	              "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID = '"+sCustomerID+"'";
    
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0205.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=6 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >5、借款人在他行的对外担保情况</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" <td width=20% align=center class=td1 >被担保企业&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >授信金融机构&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >合同金额（万元）&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >担保方式&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >到期日&nbsp;</td>");
    sTemp.append(" </tr>");
    
    ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		sVouchType = rs2.getString("VouchType");
		sOccurOrg = rs2.getString("OccurOrg");
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum")/10000);;
		sMaturity = rs2.getString("Maturity");
		
		sTemp.append("   <tr>");
		sTemp.append(" <td width=20% align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
	  	sTemp.append(" <td width=20% align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sVouchType+"&nbsp;</td>");
	    sTemp.append(" <td width=20% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
	    sTemp.append(" </tr>");
	}
	rs2.getStatement().close();	
	
	sSql = "select sum(nvl(BusinessSum,0)*getERate(Currency,'01','')) "+
	    "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID = '"+sCustomerID+"'";
	rs2 = Sqlca.getResultSet(sSql);
	String sSum = "";
	if(rs2.next())
	{
		sSum = DataConvert.toMoney(rs2.getDouble(1)/10000); 
	}	
	rs2.getStatement().close();	
	
    sTemp.append("   <tr>");
    sTemp.append(" <td width=20% align=center class=td1 >合计&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+"/"+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sSum+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+"/"+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+"/"+"&nbsp;</td>");
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

