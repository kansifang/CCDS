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
	sTemp.append("<form method='post' action='0801.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >8.1、经营性收益分析</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='6' align=left class=td1 "+myShowTips(sMethod)+" >"); 
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;从以下几个方面进行分析：</p>");
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;1、固定资产项目建成后，对借款人的各类产品产销量、市场价格、销售收入进行分析，并确定这些变量在财务分析时的基础值,重点论述这些取值的合理性。</p>");
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;2、生产成本分析分析，即主要原材料、辅助材料、动力、能源、人工成本及其他成本取值依据及其合理性，单位产品的经营成本、总成本费用及合理性。</p>");
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;3、利润分析，对借款人的盈利状况进行描述，并与本项目投产之前的盈利状况和行业盈利状况对比，分析其合理性。</p>");
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
