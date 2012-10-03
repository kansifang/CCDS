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
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 34;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	//sButtons[0][0] = "false";
	sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据

	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0101.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >一、借款人持股企业基本信息</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=3 align=left class=td1 width='120' > 组织机构代码 </td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 width='160' >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:20' ",getUnitData("describe1",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=3 align=center class=td1 width='120' > 企业名称 </td>");
    sTemp.append(" 		<td colspan=6 align=left class=td1 width='240' >");
    sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:20'  ",getUnitData("describe2",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=3 align=left class=td1 width='120'> 注册资本（万元） </td>");
    sTemp.append(" 		<td colspan=3 align=left class=td1 width='120'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:20'  ",getUnitData("describe3",sData))+"&nbsp;</td>");
    
    sTemp.append(" 		<td colspan=1 align=center class=td1 width='40'> 币种 </td>");
   
    sTemp.append(" 		<td colspan=1 align=left class=td1 width='40'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20' ",getUnitData("describe4",sData))+"&nbsp;</td>");
    
  	sTemp.append(" 		<td colspan=3 align=center class=td1 width='120'> 实收资本（万元）</td>");
  	
    sTemp.append(" 		<td colspan=3 align=left class=td1 width='120'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:20' ",getUnitData("describe5",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 width='40'> 币种 </td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 width='40'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:20' ",getUnitData("describe6",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");   
   
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=3 align=left class=td1 > 企业规模（按国家标准） </td>");
  	
    sTemp.append(" 		<td colspan=3 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20' ",getUnitData("describe7",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=1 align=center class=td1 > 成立时间 </td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20' ",getUnitData("describe8",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=center class=td1 > 行业分类 </td>");
    sTemp.append(" 		<td colspan=5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20' ",getUnitData("describe9",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=16 align=left class=td1 >主营业务:  ");
    sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:50'  ",getUnitData("describe10",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");
  
    sTemp.append("   <tr>");
	sTemp.append("     <td colspan=3 align=left class=td1 > 是否我行股东 </td>");
    sTemp.append("     <td colspan=4 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20'  ",getUnitData("describe11",sData))+"&nbsp;</td>");
    sTemp.append("     <td colspan=5 align=center class=td1 > 是否已被我行列为风险预警客户 </td>");
    sTemp.append("     <td colspan=4 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:20'  ",getUnitData("describe12",sData))+"&nbsp;</td>");
    sTemp.append("  </tr>");
   
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  colspan=3 align=left class=td1 >是否上市公司 </td>");
    sTemp.append(" 		<td colspan=13 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:20'  ",getUnitData("describe13",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");
   
    sTemp.append("   <tr>");
    sTemp.append(" 		<td  rowspan=8  align=left class=td1 >集团客户信息</td>");
    sTemp.append(" 		<td colspan=15 align=left class=td1 >借款人持股企业的前三大股东<br>币种：人民币</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=6.5 align=left class=td1 >出资人名称</td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >组织机构代码</td>");
    sTemp.append(" 		<td colspan=3.5 align=left class=td1 >出资方式</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >出资金额（万元）</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >占比</td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >出资时间</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=6.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:20'  ",getUnitData("describe14",sData))+"&nbsp;</td>"); 
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:20'  ",getUnitData("describe15",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=3.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:20'  ",getUnitData("describe16",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:20'  ",getUnitData("describe17",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%; height:20'  ",getUnitData("describe18",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:100%; height:20'  ",getUnitData("describe19",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");
   
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=6.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:100%; height:20'  ",getUnitData("describe20",sData))+"&nbsp;</td>"); 
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:100%; height:20'  ",getUnitData("describe21",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=3.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:100%; height:20'  ",getUnitData("describe22",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:100%; height:20'  ",getUnitData("describe23",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:100%; height:20'  ",getUnitData("describe24",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:100%; height:20'  ",getUnitData("describe25",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=6.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:100%; height:20'  ",getUnitData("describe26",sData))+"&nbsp;</td>"); 
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe27' style='width:100%; height:20'  ",getUnitData("describe27",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=3.5 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe28' style='width:100%; height:20'  ",getUnitData("describe28",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe29' style='width:100%; height:20'  ",getUnitData("describe29",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe30' style='width:100%; height:20'  ",getUnitData("describe30",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=1 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe31' style='width:100%; height:20'  ",getUnitData("describe31",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");
   
  
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=15 align=left class=td1 >借款人的其他集团客户信息</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=7 align=left class=td1 >集团关系企业名称</td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 >组织机构代码</td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 >与借款人关系</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=7 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe32' style='width:100%; height:20'  ",getUnitData("describe32",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe33' style='width:100%; height:20'  ",getUnitData("describe33",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe34' style='width:100%; height:20'  ",getUnitData("describe34",sData))+"&nbsp;</td>");
    sTemp.append("	 </tr>");

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
