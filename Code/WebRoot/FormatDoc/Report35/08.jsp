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
	int iDescribeCount = 2;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='08.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > 第一还款来源分析<br/><br/>8、借款人总体评价</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left height='30' class=td1 "+myShowTips(sMethod)+" ><p>借款人的客户经理评级</p>");
	sTemp.append("</tr>");	
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >借款人财务分析总结</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" ><p>对借款申请人的财务状况进行分析总结：</p>");
  	sTemp.append("     <p>1、通过比较借款申请人3年的财务数据和指标，是否发现企业有异常（包括好和坏）情况，是哪些？原因是什么？</p>");
  	sTemp.append("     <p>2、借款申请人财务指标中哪些指标低于行业正常水准，原因是什么？企业的财务优势和弱点在哪里？</p>");
  	sTemp.append("     <p>3、借款申请人项目资金筹措情况、项目财务状况、项目效益预测；</p>");
  	sTemp.append("     <p>4、借款申请人现金流量是否充足？未来还款期内现金流量是否足以偿还到期债务，说明其对第一还款来源的影响；</p>");
  	sTemp.append("     <p>分析目前财务状况、项目综合回报和贷款金额是否匹配、用途是否合理。</p>");
  	sTemp.append("     通过以上分析，分析判断目前财务状况好坏。");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
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
	editor_generate('describe2');	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>