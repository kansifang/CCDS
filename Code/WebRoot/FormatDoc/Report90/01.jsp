<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: 报告的第02页
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
	int iDescribeCount = 10;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable style=' FONT-FAMILY:宋体; '>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >对借款人评价</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >1.借款人谈话内容与前期调查情况是否一致：</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe1'",getUnitData("describe1",sData),"是@否&nbsp;"));
	sTemp.append("</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >2.借款人谈话内容是否有自相矛盾之处：</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe2'",getUnitData("describe2",sData),"有@无&nbsp;"));
	sTemp.append("</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >3.借款人的联系地址、电话是否属实：</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe3'",getUnitData("describe3",sData),"是@否&nbsp;"));
	sTemp.append("</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >4.借款人对贷款资金具体用途是否明确：</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe4'",getUnitData("describe4",sData),"是@否&nbsp;"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >对贷款用途评价</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >1.借款人的贷款用途是否真实、合规：</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe5'",getUnitData("describe5",sData),"是@否"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >2.借款人的贷款用途是否合理：</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe6'",getUnitData("describe6",sData),"是@否"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >对还款来源评价</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=6 align=left class=td1 >1.借款人的还款来源是否明确：</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe7'",getUnitData("describe7",sData),"是@否"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >2.借款人的还款来源是否稳定：</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe8'",getUnitData("describe8",sData),"是@否"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=6 align=left class=td1 >3.借款人是否有其他还款来源：</td>");
	sTemp.append("<td colspan=4 align=center class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe9'",getUnitData("describe9",sData),"是@否"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("<td colspan=10 align=left class=td1 >4.其他还款来源为：<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:52%; height:25'",getUnitData("describe10",sData)));
	sTemp.append("</u></td>");
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

