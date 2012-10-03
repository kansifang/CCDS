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
	sTemp.append("<form method='post' action='0703.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7.3、主要经营和财务比率</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td rowspan='2' width=30% align=left class=td1 > 项 目 </td>");
    sTemp.append(" 		<td width=30% align=left class=td1 > 2009 </td>");
    sTemp.append(" 		<td width=30% align=left class=td1 > 2008 </td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td width=30% align=left class=td1 > 比率 </td>");
    sTemp.append(" 		<td width=30% align=left class=td1 > 比率 </td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > 收入增长率（％）</td>");
    sTemp.append(" 		<td width=25% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td width=50% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > 收支差额增长率（％）</td>");
    sTemp.append(" 		<td width=25% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td width=50% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > 负债合计/收入合计（％）</td>");
    sTemp.append(" 		<td width=25% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td width=50% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=25% align=left class=td1 > 有息债务/事业基金（倍）</td>");
    sTemp.append(" 		<td width=25% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td width=50% align=left class=td1 >"+""+"&nbsp;</td>");
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
