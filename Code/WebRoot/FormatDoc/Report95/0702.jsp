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
	int iDescribeCount = 57;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0702.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（二）损益表结构与对比</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td rowspan=2 align=center class=td1 > 项目 </td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"); 
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:20'  ",getUnitData("describe1",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan=2 align=center class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:20'  ",getUnitData("describe2",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan=2 align=center class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:20'  ",getUnitData("describe3",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[0]+"</td>");
	//sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[1]+"</td>");
	//sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[2]+"&nbsp;</td>");	
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=center class=td1 > 数值（万元）</td>");
	sTemp.append("<td align=center class=td1 >%</td>");
	sTemp.append("<td align=center class=td1 >数值（万元）</td>");
	sTemp.append("<td align=center class=td1 >%</td>");
	sTemp.append("<td align=center class=td1 >数值（万元）</td>");
	sTemp.append("<td align=center class=td1 >%</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 主营业务收入 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20'  ",getUnitData("describe4",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:20'  ",getUnitData("describe5",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:20'  ",getUnitData("describe6",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20'  ",getUnitData("describe7",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20'  ",getUnitData("describe8",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20'  ",getUnitData("describe9",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+ssyValue1[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[0]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 主营业务成本 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:20'  ",getUnitData("describe10",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20'  ",getUnitData("describe11",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:20'  ",getUnitData("describe12",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:20'  ",getUnitData("describe13",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:20'  ",getUnitData("describe14",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:20'  ",getUnitData("describe15",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+ssyValue1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[1]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 主营业务利润 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:20'  ",getUnitData("describe16",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:20'  ",getUnitData("describe17",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%; height:20'  ",getUnitData("describe18",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:100%; height:20'  ",getUnitData("describe19",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:20'  ",getUnitData("describe20",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:100%; height:20'  ",getUnitData("describe21",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+ssyValue1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[2]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 营业费用 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:100%; height:20'  ",getUnitData("describe22",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:100%; height:20'  ",getUnitData("describe23",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:100%; height:20'  ",getUnitData("describe24",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:100%; height:20'  ",getUnitData("describe25",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:100%; height:20'  ",getUnitData("describe26",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe27' style='width:100%; height:20'  ",getUnitData("describe27",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+ssyValue1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[3]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 管理费用 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe28' style='width:100%; height:20'  ",getUnitData("describe28",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe29' style='width:100%; height:20'  ",getUnitData("describe29",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe30' style='width:100%; height:20'  ",getUnitData("describe30",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe31' style='width:100%; height:20'  ",getUnitData("describe31",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe32' style='width:100%; height:20'  ",getUnitData("describe32",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe33' style='width:100%; height:20'  ",getUnitData("describe33",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+ssyValue1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[4]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 财务费用 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe34' style='width:100%; height:20'  ",getUnitData("describe34",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe35' style='width:100%; height:20'  ",getUnitData("describe35",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe36' style='width:100%; height:20'  ",getUnitData("describe36",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe37' style='width:100%; height:20'  ",getUnitData("describe37",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe38' style='width:100%; height:20'  ",getUnitData("describe38",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe39' style='width:100%; height:20'  ",getUnitData("describe39",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+ssyValue1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[5]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 营业利润 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe40' style='width:100%; height:20'  ",getUnitData("describe40",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe41' style='width:100%; height:20'  ",getUnitData("describe41",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe42' style='width:100%; height:20'  ",getUnitData("describe42",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe43' style='width:100%; height:20'  ",getUnitData("describe43",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe44' style='width:100%; height:20'  ",getUnitData("describe44",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe45' style='width:100%; height:20'  ",getUnitData("describe45",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+ssyValue1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[6]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 利润总额 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe46' style='width:100%; height:20'  ",getUnitData("describe46",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe47' style='width:100%; height:20'  ",getUnitData("describe47",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe48' style='width:100%; height:20'  ",getUnitData("describe48",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe49' style='width:100%; height:20'  ",getUnitData("describe49",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe50' style='width:100%; height:20'  ",getUnitData("describe50",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe51' style='width:100%; height:20'  ",getUnitData("describe51",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+ssyValue1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[7]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 净利润 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe52' style='width:100%; height:20'  ",getUnitData("describe52",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe53' style='width:100%; height:20'  ",getUnitData("describe53",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe54' style='width:100%; height:20'  ",getUnitData("describe54",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe55' style='width:100%; height:20'  ",getUnitData("describe55",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe56' style='width:100%; height:20'  ",getUnitData("describe56",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe57' style='width:100%; height:20'  ",getUnitData("describe57",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+ssyValue1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[8]+"</td>");
	*/
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
	