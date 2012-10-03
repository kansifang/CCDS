<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.21
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
	int iDescribeCount = 42;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	
		
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='08.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >八、借款人持股企业财务分析-财务指标</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >指标内容</td>");
  	sTemp.append("   <td width=30% height='34' align=center class=td1 >指标名称</td>");
  	sTemp.append("<td width=20%  align=center class=td1 >"); 
	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20'  ",getUnitData("describe4",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=center class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:20'  ",getUnitData("describe5",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=center class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:20'  ",getUnitData("describe6",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=center class=td1 >"+sxjYearReportDate[0]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=center class=td1 >"+sxjYearReportDate[1]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=center class=td1 >"+sxjYearReportDate[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	//盈利能力分析
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='4' width=10% align=left class=td1 >盈利能力</td>");
  	sTemp.append("   <td width=30% align=left class=td1 > 主营业务利润率(%) </td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20'  ",getUnitData("describe7",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20'  ",getUnitData("describe8",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20'  ",getUnitData("describe9",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[0]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[0]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 > 税息前营业利润率(%) </td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:20'  ",getUnitData("describe10",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20'  ",getUnitData("describe11",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:20'  ",getUnitData("describe12",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[1]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[1]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[1]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 > 总资产收益率(%) </td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:20'  ",getUnitData("describe13",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:20'  ",getUnitData("describe14",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:20'  ",getUnitData("describe15",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[2]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[2]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 > 净资产收益率(%) </td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:20'  ",getUnitData("describe16",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:20'  ",getUnitData("describe17",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%; height:20'  ",getUnitData("describe18",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[3]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[3]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[3]+"&nbsp;</td>");
	sTemp.append("   </tr>");

	// 经营效率分析
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='4' width=10% align=left class=td1 >经营效率</td>");
  	sTemp.append("   <td width=30% align=left class=td1 > 存货周转天数(天) </td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:100%; height:20'  ",getUnitData("describe19",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:100%; height:20'  ",getUnitData("describe20",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:100%; height:20'  ",getUnitData("describe21",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[4]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[4]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[4]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >应收账款周转天数(天)</td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:100%; height:20'  ",getUnitData("describe22",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:100%; height:20'  ",getUnitData("describe23",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:100%; height:20'  ",getUnitData("describe24",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[5]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[5]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[5]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >应付账款周转天数(天)</td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:100%; height:20'  ",getUnitData("describe25",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:100%; height:20'  ",getUnitData("describe26",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe27' style='width:100%; height:20'  ",getUnitData("describe27",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[6]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[6]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[6]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >总资产周转率 (%)</td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe28' style='width:100%; height:20'  ",getUnitData("describe28",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe29' style='width:100%; height:20'  ",getUnitData("describe2",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe30' style='width:100%; height:20'  ",getUnitData("describe30",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[7]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[7]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[7]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	// 流动性和短期偿债能力	
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='3' width=10% align=left class=td1 >流动性和短期偿债能力</td>");
  	sTemp.append("   <td width=30% align=left class=td1 >长期资产适合率(倍)</td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe31' style='width:100%; height:20'  ",getUnitData("describe31",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe32' style='width:100%; height:20'  ",getUnitData("describe32",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe33' style='width:100%; height:20'  ",getUnitData("describe33",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[8]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[8]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[8]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >流动比率(倍)</td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe34' style='width:100%; height:20'  ",getUnitData("describe34",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe35' style='width:100%; height:20'  ",getUnitData("describe35",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe36' style='width:100%; height:20'  ",getUnitData("describe36",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[9]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[9]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[9]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >速动比率(倍)</td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe37' style='width:100%; height:20'  ",getUnitData("describe37",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe38' style='width:100%; height:20'  ",getUnitData("describe38",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe39' style='width:100%; height:20'  ",getUnitData("describe39",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[10]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[10]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[10]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	//长期偿债能力分析
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='2' width=10% align=left class=td1 >长期偿债能力</td>"); 
  	sTemp.append("   <td width=30% align=left class=td1 >资产负债率(%)</td>");
  	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe40' style='width:100%; height:20'  ",getUnitData("describe40",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe41' style='width:100%; height:20'  ",getUnitData("describe41",sData))+"&nbsp;</td>"); 
	sTemp.append("<td width=20%  align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe42' style='width:100%; height:20'  ",getUnitData("describe42",sData))+"&nbsp;</td>"); 
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[11]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[11]+"&nbsp;</td>");
	//sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[11]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >调整后资产负债率(%)</td>");
	sTemp.append("   	<td width=20%  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=20%  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=20%  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData)));
	sTemp.append("      &nbsp;</td>");
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