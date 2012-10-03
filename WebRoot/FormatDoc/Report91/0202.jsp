<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   wangdw 2012.05.21
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
	int iDescribeCount = 31;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
		//获得调查报告数据
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0202.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.5、企业财务分析（附件：财务分析简表）</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 >企业财务数据简表（以现场调查为主，无需出具书面证明，财务报表仅供参考）</td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 nowrap> 科目 </td>");
	sTemp.append("<td width=15% align=left class=td1 nowrap> 上年度 </td>");
	sTemp.append("<td width=30% align=left class=td1 nowrap> 期末/年末 </td>");
	sTemp.append("<td width=20% align=left class=td1 nowrap> 计算公式 </td>");
	sTemp.append("<td width=15% align=left class=td1 nowrap> 计算结果 </td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 存货 </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td align=right class=td1 >(期末数)");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:45%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td align=left class=td1 nowrap>&nbsp  </td>");
	sTemp.append("<td align=left class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:85%; height:25'",getUnitData("describe3",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 销售收入 </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(期末数)");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:45%; height:25'",getUnitData("describe5",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  rowspan=2  align=left class=td1 nowrap>产品销售利润率=[销售收入-<br>销售成本(含税费)] /销售收入=。。。</td>");
	sTemp.append("<td align=left rowspan=2 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:85%; height:25'",getUnitData("describe6",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 销售成本 </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:25'",getUnitData("describe7",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(期末数)");
  	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:45%; height:25'",getUnitData("describe8",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 应收账款余额 </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(期末数)");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:45%; height:25'",getUnitData("describe10",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  rowspan=2  align=left class=td1 nowrap>应收账款净额=应收账款余额<br>-预收账款余额=。。。</td>");
	sTemp.append("<td align=left rowspan=2 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:85%; height:25'",getUnitData("describe11",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 预收账款余额 </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:25'",getUnitData("describe12",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(期末数)");
  	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:45%; height:25'",getUnitData("describe13",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 应付账款余额 </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:25'",getUnitData("describe14",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(期末数)");
	sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:45%; height:25'",getUnitData("describe15",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  rowspan=2  align=left class=td1 nowrap>应付账款净额=应付账款<br>余额-预付账款余额=。。。</td>");
	sTemp.append("<td align=left rowspan=2 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:85%; height:25'",getUnitData("describe16",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 预付账款余额 </td>");
  	sTemp.append("   	<td  align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:25'",getUnitData("describe17",sData)));
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   	<td   align=right class=td1 >(期末数)");
  	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:45%; height:25'",getUnitData("describe18",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 预计当年末销售收入 </td>");
	sTemp.append("<td align=left class=td1 nowrap> --- </td>");  	
	sTemp.append("   	<td   align=right class=td1 >年末预计数");
	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:34%; height:25'",getUnitData("describe19",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>预计销售收入年增长率=（预计当年销售<br>收入-上年度销售收入）/上年度销售收入=。。。</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:85%; height:25'",getUnitData("describe20",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 目前自有资金量 </td>");
	sTemp.append("<td align=left class=td1 nowrap> --- </td>");  	
	sTemp.append("   	<td   align=right class=td1 >(期末数)");
	sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:45%; height:25'",getUnitData("describe21",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>用于本项目的</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:85%; height:25'",getUnitData("describe22",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 现有流动资金贷款 </td>");
	sTemp.append("<td align=left class=td1 nowrap> --- </td>");  	
	sTemp.append("   	<td   align=right class=td1 >(期末数)");
	sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:45%; height:25'",getUnitData("describe23",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>用于企业经营的全部流动资金贷款（含个人<br>和企业）</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:85%; height:25'",getUnitData("describe24",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 其他渠道提供的营运资金 </td>");
	sTemp.append("<td align=left class=td1 nowrap> --- </td>");  
	sTemp.append("   	<td   align=right class=td1 >(期末数)");
	sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:45%; height:25'",getUnitData("describe25",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>用于本项目融资的其他渠道资金（含个人<br>和企业）</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:85%; height:25'",getUnitData("describe26",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 营运资金量 </td>");
	sTemp.append("   	<td   align=right class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe27' style='width:100%; height:25'",getUnitData("describe27",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td   align=right class=td1 >公式结果");
	sTemp.append(myOutPut("2",sMethod,"name='describe28' style='width:45%; height:25'",getUnitData("describe28",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>[平均存货余额+（1-销售利润率）<br>*平均应收账款净额-平均应付账款净额]* <br>(1＋预计销售收入年增长率)</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe29' style='width:85%; height:25'",getUnitData("describe29",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 资金缺口 </td>");
	sTemp.append("<td align=left class=td1 nowrap> --- </td>"); 
	sTemp.append("   	<td   align=right class=td1 >公式结果");
	sTemp.append(myOutPut("2",sMethod,"name='describe30' style='width:45%; height:25'",getUnitData("describe30",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("<td  align=left class=td1 nowrap>营运资金量-借款人自有资金量-现有流动<br>资金贷款-其他渠道提供的营运资金=。。。</td>");
	sTemp.append("<td align=left rowspan=1 class=td1 nowrap>&nbsp;");
	sTemp.append(myOutPut("2",sMethod,"name='describe31' style='width:80%; height:25'",getUnitData("describe31",sData)));
	sTemp.append("</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td colspan=20 align=left class=td1 nowrap>&nbsp</td>");
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
	