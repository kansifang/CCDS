<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.18
		Tester:
		Content: 调查报告主界面
		Input Param:
			SerialNo: 文档流水号
			ObjectNo：业务流水号
			Method:   其中 1:display;2:save;3:preview;4:export
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 7;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0701.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7.1、项目概况</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td width=20% align=center class=td1 >项目名称</td>");
  	sTemp.append("   <td width=15% align=center class=td1 > 规模  </td>");
    sTemp.append("   <td width=10% align=center class=td1 > 必要性 </td>");
    sTemp.append("   <td width=15% align=center class=td1 > 工期 </td>");
    sTemp.append("   <td width=20% align=center class=td1 > 主要承建单位 </td>");
    sTemp.append("   <td width=20% align=center class=td1 >投融资情况</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td width=20% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe2' style='width:100%; height:50'",getUnitData("describe2",sData)));
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe3' style='width:100%; height:50'",getUnitData("describe3",sData)));
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=10% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe4' style='width:100%; height:50'",getUnitData("describe4",sData)));
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe5' style='width:100%; height:50'",getUnitData("describe5",sData)));
	sTemp.append("&nbsp;</td>");	
  	sTemp.append("   <td width=20% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe6' style='width:100%; height:50'",getUnitData("describe6",sData)));
	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=20% align=left class=td1 >");
	sTemp.append(myOutPut("0",sMethod,"name='describe7' style='width:100%; height:50'",getUnitData("describe7",sData)));
	sTemp.append("&nbsp;</td>");	

	sTemp.append("   </tr>");
	
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='6' align=left class=td1 "+myShowTips(sMethod)+" >项目描述：对项目的整体情况进行概括性描述，包括项目内容、规模、必要性、工期、主要承建单位、投融资情况等。");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='6' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
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
		editor_generate('describe1');		//需要html编辑,input是没必要 

<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
