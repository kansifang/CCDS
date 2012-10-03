<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
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
	sButtons[1][0] = "false";
%>
<% 
	//获得调查报告数据

	
%>
   
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='05.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >五、借款人持股企业管理能力分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'> 职务 </td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>姓名</td>");
    sTemp.append(" 		<td colspan=2 align=center class=td1 width='80'> 年龄</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>身份证号码</td>");
  	sTemp.append(" 		<td colspan=2 align=center class=td1 width='80'> 加入公司时间</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>相关行业从业年限</td>");
    sTemp.append(" 		<td colspan=2 align=center class=td1 width='80'>担当该职务年限</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>持有本公司股份情况</td>");
    sTemp.append(" 	</tr>"); 
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:20' ",getUnitData("describe1",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:20' ",getUnitData("describe2",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:20' ",getUnitData("describe3",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20' ",getUnitData("describe4",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:20' ",getUnitData("describe5",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:20' ",getUnitData("describe6",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20' ",getUnitData("describe7",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20' ",getUnitData("describe8",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20' ",getUnitData("describe9",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:20' ",getUnitData("describe10",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20' ",getUnitData("describe11",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:20' ",getUnitData("describe12",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:20' ",getUnitData("describe13",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:20' ",getUnitData("describe14",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:20' ",getUnitData("describe15",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:20' ",getUnitData("describe16",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（一）管理能力分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16  >通过以下五个方面进行描述<br><br>");
	sTemp.append("   1、高级管理层的经验，如领导能力、专业水平、管理经验、开拓创新能力；<br>");
	sTemp.append("   2、高级管理层过往诚信状况及经营业绩；<br>");
	sTemp.append("   3、其他企业的兼职情况；<br>");
	sTemp.append("   4、高级管理层稳定性、近期有无重大人事变动等；<br>");
	sTemp.append("   5、企业文化、奖惩制度、革新创新的奖励、薪酬制度等。<br></td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left  colspan=16> ");
	sTemp.append(myOutPut("1",sMethod,"name='describe17' style='width:100%; height:100'",getUnitData("describe17",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=16 align=left bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（二）对管理机构、制度的简短文字描述</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16  >通过以下三个方面进行描述<br><br>");
	sTemp.append("   1、内部控制制度：描述企业是否有完整的内部控制的组织架构和规章制度（包括法律法规、监察、内部审计等）；<br>");
	sTemp.append("   2、公司治理结构：描述企业是否有全面的治理结构的架构，包括股东大会、董事会、监事会、总裁、相关办公室和相关委员会。；<br>");
	sTemp.append("   3、公司是否有成文的未来战略规划。若有，简单描述。<br></td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left  colspan=16> ");
	sTemp.append(myOutPut("1",sMethod,"name='describe18' style='width:100%; height:100'",getUnitData("describe18",sData)));
	sTemp.append("&nbsp;</td>");
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
	editor_generate('describe17');
	editor_generate('describe18');//需要html编辑,input是没必要
	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
