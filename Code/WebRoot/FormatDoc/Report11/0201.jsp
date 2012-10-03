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
	//获得调查报告数据
	String sBasicBank = "";//基本账户开户行
    String sBasicAccount = "";//账号
    String sMybankAccount = "";//账号
    String sAccountDate = "";//我行开户时间
	ASResultSet rs2 = Sqlca.getResultSet("select BasicBank,BasicAccount,MybankAccount,AccountDate from Ent_Info where CustomerID = '"+sCustomerID+"'");
    if(rs2.next()){
    	sBasicBank = rs2.getString("BasicBank");
    	if(sBasicBank == null) sBasicBank=" ";
    	
    	sBasicAccount = rs2.getString("BasicAccount");
    	if(sBasicAccount == null) sBasicAccount=" ";
    	
    	sMybankAccount = rs2.getString("MybankAccount");
    	if(sMybankAccount == null) sMybankAccount=" ";
    	
    	sAccountDate = rs2.getString("AccountDate");
    	if(sAccountDate == null) sAccountDate=" ";
    }
    rs2.getStatement().close();
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=4 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >1.借款人开户情况</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td colspan=4 align=center class=td1 >币种：人民币&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单位：万元</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=25% align=center class=td1 >基本账户开户行&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+sBasicBank+"&nbsp;</td>");
  	sTemp.append(" <td width=15% align=center class=td1 >账号&nbsp;</td>");
    sTemp.append(" <td width=35% align=center class=td1 >"+sBasicAccount+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=25% align=center class=td1 >我行开户时间&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >"+sAccountDate+"&nbsp;</td>");
  	sTemp.append(" <td width=15% align=center class=td1 >账号&nbsp;</td>");
    sTemp.append(" <td width=35% align=center class=td1 >"+sMybankAccount+"&nbsp;</td>");
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

