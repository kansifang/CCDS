<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第0页
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
	int iDescribeCount = 10;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader1.jsp"%>

<%
	//获得调查报告数据

	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >账面不良贷款重点监控报告</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >一、客户基本情况监控</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >1、客户现状");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>分析填报重组后客户主体资格有效性；生产经营及资产、负债、所有者权益等财务变动情况；观察期内信用状况、有无逃废债、高管人员调整、涉诉事项等影响重组结果的重大事项。（500汉字）<font color='red'>(*必须)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:80'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >2、担保及时效现状");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>分析填报重组后抵（质）押、保证担保及时效的有效性。（500汉字）<font color='red'>(*必须)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:80'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >3、重组方案执行情况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报重组方案执行进度，执行中遇到的实际问题及下一步拟采取的措施。（500汉字）<font color='red'>(*必须)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:80'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >4、重组方案调整情况");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>填报对重组方案的调整情况。其中：涉及以下重大变更的需重新发起审批申请：原一般重组项目调整为扩盘重组项目；原扩盘重组项目需再增加授信额度；涉及主体、担保、利率、期限的重大调整。<font color='red'>(*必须)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:80'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >5、新增授信现状");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>按照五级分类核心定义分析新增授信的风险状况。<font color='red'>(*必须)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:80'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan='4' align=left class=td1 >6、重组贷款风险现状");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append(" <tr>");	
		sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>综合以上情况，按照五级分类核心定义分析重组贷款的风险状况。<font color='red'>(*必须)</font></p>");
		sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
		sTemp.append("   <td  colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:80'",getUnitData("describe6",sData)));
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

