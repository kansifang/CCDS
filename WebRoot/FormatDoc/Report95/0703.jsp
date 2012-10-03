<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.22
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
	int iDescribeCount = 18;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0703.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（三）现金流</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td rowspan=2 align=center class=td1 > 项目 </td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"); 
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:20'  ",getUnitData("describe1",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan=2 align=center class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:20'  ",getUnitData("describe2",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan=2 align=center class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:20'  ",getUnitData("describe3",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[0]+"</td>");
	//sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[1]+"</td>");
	//sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[2]+"&nbsp;</td>");	
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=center class=td1 >数值(万元)</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >数值(万元)</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >数值(万元)</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 经营活动现金流入量 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20'  ",getUnitData("describe4",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:20'  ",getUnitData("describe5",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:20'  ",getUnitData("describe6",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[0]+"</td>");
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[0]+"</td>");
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[0]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 经营活动现金流出量 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20'  ",getUnitData("describe7",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20'  ",getUnitData("describe8",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20'  ",getUnitData("describe9",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[1]+"</td>");
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[1]+"</td>");
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 经营活动现金流净额 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:20'  ",getUnitData("describe10",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20'  ",getUnitData("describe11",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe612' style='width:100%; height:20'  ",getUnitData("describe12",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[2]+"</td>");
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[2]+"</td>");
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 投资活动现金流净额 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:20'  ",getUnitData("describe13",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:20'  ",getUnitData("describe14",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:20'  ",getUnitData("describe15",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[3]+"</td>");
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[3]+"</td>");
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 筹资活动现金流净额 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:20'  ",getUnitData("describe16",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:20'  ",getUnitData("describe17",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%; height:20'  ",getUnitData("describe18",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[4]+"</td>");
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[4]+"</td>");
	//sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[4]+"</td>");
	sTemp.append("</tr>");
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
	