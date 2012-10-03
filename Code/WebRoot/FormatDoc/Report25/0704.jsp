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
	int iDescribeCount = 1;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>


<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0704.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7.4、项目生产要素分析</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append(" <tr>");	
	sTemp.append("<td width=15% align=center >项目管理");
	sTemp.append("</td>");	
	sTemp.append("<td align=left >说明项目规划方案、建设内容、施工进度；项目设计、施工、监理单位资质及与类似项目的比较等。");
	sTemp.append("</td>");
    sTemp.append("   </tr>");
    sTemp.append(" <tr>");	
	sTemp.append("<td width=15% align=center >技术，原材料及市场要素");
	sTemp.append("</td>");	
	sTemp.append("<td align=left >&nbsp;&nbsp;&nbsp;&nbsp;1.技术要素：介绍项目建设期和生产期所需技术的先进性、可靠性及成熟度；<br/><br/>");
	sTemp.append(" &nbsp;&nbsp;&nbsp;&nbsp;2.原材料要素：介绍原材料来源的可靠性，是否受到制约（如进口关税、外汇管制、限制性政策等）；矿业能源项目的资源储量及可靠性；<br/><br/>");
	sTemp.append( "&nbsp;&nbsp;&nbsp;&nbsp;3项目市场:分析描述项目产品或服务的国内国际市场需求、价格和竞争性。<br/><br/>");
	sTemp.append("</td>");
    sTemp.append("   </tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append("   <td  colspan='2' align=left class=td1 >");
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
