<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009/08/20
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
	int iDescribeCount = 117;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0701.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >七、借款人持股企业财务分析-财务简表</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（一）资产负债表结构与对比</font></td>");
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
    sTemp.append("<td rowspan=2 align=center class=td1 > 项目</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"); 
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:20'  ",getUnitData("describe1",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan=2 align=center class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:20'  ",getUnitData("describe2",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan=2 align=center class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:20'  ",getUnitData("describe3",sData))+"&nbsp;</td>"); 
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=15% align=center class=td1 > 数值（万元）</td>");
	sTemp.append("<td width=10% align=center class=td1 >%</td>");
	sTemp.append("<td width=15% align=center class=td1 > 数值（万元）</td>");
	sTemp.append("<td width=10% align=center class=td1 >%</td>");
	sTemp.append("<td width=15% align=center class=td1 >数值（万元）</td>");
	sTemp.append("<td width=10% align=center class=td1 >%</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 报表口径 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20'  ",getUnitData("describe4",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:20'  ",getUnitData("describe5",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:20'  ",getUnitData("describe6",sData))+"&nbsp;</td>"); 
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 是否已审计 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20'  ",getUnitData("describe7",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20'  ",getUnitData("describe8",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20'  ",getUnitData("describe9",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditFlag[1]+"&nbsp;</td>");
	//sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditFlag[2]+"&nbsp;</td>");
	//sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditFlag[3]+"&nbsp;</td>");	
	sTemp.append("</tr>");	
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 审计意见 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:20'  ",getUnitData("describe10",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20'  ",getUnitData("describe11",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe612' style='width:100%; height:20'  ",getUnitData("describe12",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOpinion[1]+"&nbsp;</td>");
	//sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOpinion[2]+"&nbsp;</td>");
	//sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOpinion[3]+"&nbsp;</td>");	
	sTemp.append("</tr>");	
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 审计事务所名称 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:20'  ",getUnitData("describe13",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:20'  ",getUnitData("describe14",sData))+"&nbsp;</td>"); 
	sTemp.append("<td colspan='2' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:20'  ",getUnitData("describe15",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td colspan='2' align=left class=td1 >"+sAuditOffice[1]+"&nbsp;</td>");
	//sTemp.append("<td colspan='2' align=left class=td1 >"+sAuditOffice[2]+"&nbsp;</td>");
	//sTemp.append("<td colspan='2' align=left class=td1 >"+sAuditOffice[3]+"&nbsp;</td>");	
	sTemp.append("</tr>");				
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 总资产 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:20'  ",getUnitData("describe16",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:20'  ",getUnitData("describe17",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%; height:20'  ",getUnitData("describe18",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:100%; height:20'  ",getUnitData("describe19",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:100%; height:20'  ",getUnitData("describe20",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:100%; height:20'  ",getUnitData("describe21",sData))+"&nbsp;</td>"); 
	//sTemp.append("<td align=right class=td1 nowrap>"+sValue1[0]+"</td>");
	///sTemp.append("<td align=right class=td1 nowrap>"+sProportion1[0]+"</td>");
	//sTemp.append("<td align=right class=td1 nowrap>"+sValue2[0]+"</td>");
	//sTemp.append("<td align=right class=td1 nowrap>"+sProportion2[0]+"</td>");
	//sTemp.append("<td align=right class=td1 nowrap>"+sValue3[0]+"</td>");
	//sTemp.append("<td align=right class=td1 nowrap>"+sProportion3[0]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 流动资产 </td>");
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
	//sTemp.append("<td align=right class=td1 >"+sValue1[1]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion1[1]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sValue2[1]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion2[1]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sValue3[1]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 货币资产 </td>");
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
	//sTemp.append("<td align=right class=td1 >"+sValue1[2]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion1[2]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sValue2[2]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion2[2]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sValue3[2]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 应收账款</td>");
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
	//sTemp.append("<td align=right class=td1 >"+sValue1[3]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion1[3]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sValue2[3]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion2[3]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sValue3[3]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 其他应收款 </td>");
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
	sTemp.append("<td align=right class=td1 >"+sValue1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[4]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 存货 </td>");
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
	sTemp.append("<td align=right class=td1 >"+sValue1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[5]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 长期投资 </td>");
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
	sTemp.append("<td align=right class=td1 >"+sValue1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[6]+"</td>");
	*/
	sTemp.append("</tr>");
	//sTemp.append("<tr>");
	//sTemp.append("<td align=left class=td1 > 在建工程 </td>");
	//sTemp.append("<td align=right class=td1 >"+sValue1[17]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion1[17]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sValue2[17]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion2[17]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sValue3[17]+"</td>");
	//sTemp.append("<td align=right class=td1 >"+sProportion3[17]+"</td>");
	//sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 固定资产净值 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe58' style='width:100%; height:20'  ",getUnitData("describe58",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe59' style='width:100%; height:20'  ",getUnitData("describe59",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe60' style='width:100%; height:20'  ",getUnitData("describe60",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe61' style='width:100%; height:20'  ",getUnitData("describe61",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe62' style='width:100%; height:20'  ",getUnitData("describe62",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe63' style='width:100%; height:20'  ",getUnitData("describe63",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+sValue1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[7]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 无形资产 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe64' style='width:100%; height:20'  ",getUnitData("describe64",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe65' style='width:100%; height:20'  ",getUnitData("describe65",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe66' style='width:100%; height:20'  ",getUnitData("describe66",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe67' style='width:100%; height:20'  ",getUnitData("describe67",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe68' style='width:100%; height:20'  ",getUnitData("describe68",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe69' style='width:100%; height:20'  ",getUnitData("describe69",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+sValue1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[8]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 流动负债 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe70' style='width:100%; height:20'  ",getUnitData("describe70",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe71' style='width:100%; height:20'  ",getUnitData("describe71",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe72' style='width:100%; height:20'  ",getUnitData("describe72",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe73' style='width:100%; height:20'  ",getUnitData("describe73",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe74' style='width:100%; height:20'  ",getUnitData("describe74",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe75' style='width:100%; height:20'  ",getUnitData("describe75",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+sValue1[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[9]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 短期借款及一年内到期的长期借款</td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe76' style='width:100%; height:20'  ",getUnitData("describe76",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe77' style='width:100%; height:20'  ",getUnitData("describe77",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe78' style='width:100%; height:20'  ",getUnitData("describe78",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe79' style='width:100%; height:20'  ",getUnitData("describe79",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe80' style='width:100%; height:20'  ",getUnitData("describe80",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe81' style='width:100%; height:20'  ",getUnitData("describe81",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+sValue1[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[10]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 应付票据 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe82' style='width:100%; height:20'  ",getUnitData("describe82",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe83' style='width:100%; height:20'  ",getUnitData("describe83",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe84' style='width:100%; height:20'  ",getUnitData("describe84",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe85' style='width:100%; height:20'  ",getUnitData("describe85",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe86' style='width:100%; height:20'  ",getUnitData("describe86",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe87' style='width:100%; height:20'  ",getUnitData("describe87",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+sValue1[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[11]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 应付账款 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe88' style='width:100%; height:20'  ",getUnitData("describe88",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe89' style='width:100%; height:20'  ",getUnitData("describe89",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe90' style='width:100%; height:20'  ",getUnitData("describe90",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe91' style='width:100%; height:20'  ",getUnitData("describe91",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe92' style='width:100%; height:20'  ",getUnitData("describe92",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe93' style='width:100%; height:20'  ",getUnitData("describe93",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+sValue1[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[12]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 长期借款 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe94' style='width:100%; height:20'  ",getUnitData("describe94",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe95' style='width:100%; height:20'  ",getUnitData("describe95",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe96' style='width:100%; height:20'  ",getUnitData("describe96",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe97' style='width:100%; height:20'  ",getUnitData("describe97",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe98' style='width:100%; height:20'  ",getUnitData("describe98",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe99' style='width:100%; height:20'  ",getUnitData("describe99",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+sValue1[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[13]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 所有者权益合计 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe100' style='width:100%; height:20'  ",getUnitData("describe100",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe101' style='width:100%; height:20'  ",getUnitData("describe101",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe102' style='width:100%; height:20'  ",getUnitData("describe102",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe103' style='width:100%; height:20'  ",getUnitData("describe103",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe104' style='width:100%; height:20'  ",getUnitData("describe104",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe105' style='width:100%; height:20'  ",getUnitData("describe105",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+sValue1[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[14]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 实收资本 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe106' style='width:100%; height:20'  ",getUnitData("describe106",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe107' style='width:100%; height:20'  ",getUnitData("describe107",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe108' style='width:100%; height:20'  ",getUnitData("describe108",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe109' style='width:100%; height:20'  ",getUnitData("describe109",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe110' style='width:100%; height:20'  ",getUnitData("describe110",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe111' style='width:100%; height:20'  ",getUnitData("describe111",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+sValue1[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[15]+"</td>");
	*/
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 未分配利润和赢余公积 </td>");
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe112' style='width:100%; height:20'  ",getUnitData("describe112",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe113' style='width:100%; height:20'  ",getUnitData("describe113",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe114' style='width:100%; height:20'  ",getUnitData("describe114",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe115' style='width:100%; height:20'  ",getUnitData("describe115",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe116' style='width:100%; height:20'  ",getUnitData("describe116",sData))+"&nbsp;</td>"); 
	sTemp.append("<td align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe117' style='width:100%; height:20'  ",getUnitData("describe117",sData))+"&nbsp;</td>"); 
	/*
	sTemp.append("<td align=right class=td1 >"+sValue1[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[16]+"</td>");
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
	