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
	int iDescribeCount =13;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%   
    String sCustomerName = "";
    sCustomerName = Sqlca.getString("select FullName from IND_INFO  where CustomerID =(select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"')");
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append(" <td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >个人工业厂房按揭贷款调查报告</font></td> ");	
	sTemp.append("   </tr>	");
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1、借款申请及相关资料</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append("   本人对借款人<u>"+sCustomerName+"</u>");
	sTemp.append("   的借款申请及有关资料已经审核，情况如实反映如下：");
	sTemp.append("   <br>");
    sTemp.append("   (1)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe0'",getUnitData("describe0",sData),"本地居民"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"非本市工作"));
	sTemp.append("   <br>");
    sTemp.append("   (2)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"外地居民"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"本市工作"));
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe5'",getUnitData("describe5",sData),"非本市工作"));	
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe6'",getUnitData("describe6",sData),"有本市居住证明"));
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"无本市居住证明"));
    sTemp.append("   <br>");
    sTemp.append("   (3)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"境外人士"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe9'",getUnitData("describe9",sData),"本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe10'",getUnitData("describe10",sData),"非本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe11'",getUnitData("describe11",sData),"有本市居住证明"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe12'",getUnitData("describe12",sData),"无本市居住证明"));
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
