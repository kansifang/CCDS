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
	int iDescribeCount = 21;	//这个是页面需要输入的个数，必须写对：客户化1
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
	sTemp.append("<form method='post' action='04.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >四、借款人持股企业经营情况分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（一）经营情况总体描述</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left  colspan=16 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:100'",getUnitData("describe1",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=16 align=left bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（二）重大事项</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=16 align=left class=td1 > 描述企业已经或将要发生的重大事项，及其对企业资金、效益以及竞争力等方面的影响。重大事项包括重大重组改制、重大建设项目、重大或有项目或对外担保责任风险、重大法律诉讼、重大事故与赔偿等。</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td align=left colspan=16 class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（三）供应渠道分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td   width=5% class=td1 >&nbsp;</td>");
	sTemp.append(" 		<td   width=45% class=td1 >前三名供应商（按金额大小排名）</td>");
    sTemp.append(" 		<td   width=25% class=td1 > 金额（万元）</td>");
    sTemp.append(" 		<td   width=25% class=td1 >占全部采购比例%</td>");
    sTemp.append("   </tr>");
   
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 1 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:20' ",getUnitData("describe3",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20' ",getUnitData("describe4",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:20' ",getUnitData("describe5",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
   
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 2 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:20' ",getUnitData("describe6",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20' ",getUnitData("describe7",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20' ",getUnitData("describe8",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 3 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20' ",getUnitData("describe9",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:20' ",getUnitData("describe10",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20' ",getUnitData("describe11",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
   
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left  colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（四）销售渠道分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1>&nbsp;</td>");
	sTemp.append(" 		<td width=45% class=td1>前三名销售商（按金额大小排名）</td>");
    sTemp.append(" 		<td width=25% class=td1> 金额（万元）</td>");
    sTemp.append(" 		<td width=25% class=td1>占全部销售比例%</td>");
    sTemp.append("   </tr>");
   
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 1 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:20' ",getUnitData("describe12",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:20' ",getUnitData("describe13",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:20' ",getUnitData("describe14",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 2 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:20' ",getUnitData("describe15",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:20' ",getUnitData("describe16",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:20' ",getUnitData("describe17",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td width=5% class=td1> 3 </td>");
  	sTemp.append(" 		<td width=45% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%; height:20' ",getUnitData("describe18",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:100%; height:20' ",getUnitData("describe19",sData))+"&nbsp;</td>");
  	sTemp.append(" 		<td width=25% class=td1>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:100%; height:20' ",getUnitData("describe20",sData))+"&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=16 align=left class=td1 > 销售商总体评价:<br>从销售价格、稳定性、付款条件等方面对销售商进行描述。</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=16 align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:100%; height:50' ",getUnitData("describe21",sData))+"&nbsp;</td>");
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
	editor_generate('describe1');
	editor_generate('describe2');//需要html编辑,input是没必要
	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
