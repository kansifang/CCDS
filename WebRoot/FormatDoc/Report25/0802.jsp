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
	sTemp.append("   <td class=td1 align=left colspan=17 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >8.2、不确定性分析</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append(" <tr>");	
  	sTemp.append("<td colspan='6' align=left class=td1 "+myShowTips(sMethod)+" >"); 
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;从以下几个方面进行分析：</p>");
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;1、敏感性分析，指出对借款人收益和偿债能力影响最大的几个变量，论述这些变量在财务分析中取值的合理性，以及这些值发生不利变化时借款人的偿债能力是否能够接受。</p>");
  	sTemp.append("  <p>&nbsp;&nbsp;&nbsp;&nbsp;2、盈亏平衡点：<br/>&nbsp;&nbsp;&nbsp;&nbsp;它是根据项目正常生产年份的产品产量（销售量）、固定成本、可变成本、税金等，研究建设项目产量、成本、利润之间变化与平衡关系的方法。当项目的收益与成本相等时，即为盈亏平衡点（BEP）。</p>");
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
