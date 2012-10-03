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
	int iDescribeCount = 9;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<% 
   Double dEvaluateScore = 0.0;
   dEvaluateScore = Sqlca.getDouble("select EvaluateScore from Evaluate_Record where ObjectType = 'Customer' and ObjectNo=(select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"') order by AccountMonth DESC fetch first 1 row only ");
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2、根据申请人借款期限计算</font></td>"); 	
	sTemp.append(" </tr>");	
	sTemp.append(" <tr>");
    sTemp.append(" <td colspan=10 align=left class=td1 > 借款到期时申请人年龄为<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:15%; height:25'",getUnitData("describe0",sData)));   
	sTemp.append("</u>周岁");
    sTemp.append(" </tr>"); 
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3、经查询个人资信资料，申请人、配偶、共有人资信情况如下：</font></td>"); 	
	sTemp.append(" </tr>");
    sTemp.append(" <tr>");
	sTemp.append(" <td colspan=10 align=left class=td1 >");
	sTemp.append(" (1)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"无不良信用记录"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"无其他贷款"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"在个人征信系统中无记录"));
    //sTemp.append(" </td>");
    //sTemp.append(" </tr>");   
    sTemp.append(" <br>"); 	
    //sTemp.append(" <tr>");
	//sTemp.append(" <td colspan=10 align=left class=td1 >");
	sTemp.append(" (2)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"有其他借款"));
	sTemp.append("，合计<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:15%; height:25'",getUnitData("describe5",sData)));
	sTemp.append("</u>笔，合计月还款<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:15%; height:25'",getUnitData("describe6",sData)));
	sTemp.append("</u>元 ");
    sTemp.append(" <br>"); 
	sTemp.append(" (3)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"有借款逾期"));
	sTemp.append("，逾期金额合计<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:15%; height:25'",getUnitData("describe8",sData)));
	sTemp.append("</u>元");
    sTemp.append(" <br>"); 
    sTemp.append("  (4)&nbsp申请人资信报告信用分数:<u>"+dEvaluateScore+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));	
	sTemp.append("  分");
	sTemp.append("  &nbsp;</td>");   
    sTemp.append("  </tr>"); 	    
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