<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: 报告的第02页
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
	int iDescribeCount = 25;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >二、借款人情况</td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >1.职业信息：说明借款人所在的企业、职务、收入等情况。 <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >2.用款企业情况（如有）：调查用款企业的经营范围，确认是否在我行有其他授信以及曾为我行对公条线否决，并尽量调查用款企业的其他情况，比如：注册资本、股权结构及经营业绩（包括年销售收入、净利润、资产、负债等财务情况）等。 <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >3.借款人负债、资产及资信情况<br>"
			+"借款人夫妻双方（含共同借款人）及抵押物共有人（如有）的个人征信记录中，是否存在产品管理办法规定的不良信用记录，对不良信用记录是否提供合理解释及合理性分析。<br>"
			+"说明借款人家庭资产情况，包括借款人家庭拥有的可提供证明材料的房产及资产情况。 <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >4.与我行以往业务合作情况（包括贷款、存款、理财等情况）。 <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >5.本笔业务的综合收益情况。 <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
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
	editor_generate('describe2');		//需要html编辑,input是没必要 
	editor_generate('describe3');		//需要html编辑,input是没必要 
	editor_generate('describe4');		//需要html编辑,input是没必要 
	editor_generate('describe5');		//需要html编辑,input是没必要 
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

