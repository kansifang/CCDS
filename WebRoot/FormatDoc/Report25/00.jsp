<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.18
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
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据
	String sCustomerName = "";
	String sClassifyResult = "";
	String sOrgName = "";
	String sUserName = "";
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,"
										+"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"
										+"getOrgName(OperateOrgID) as OperateOrgName,"
										+"getUserName(OperateUserID) as OperateUserName "
										+"from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = " ";
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = " ";
		
		
		sOrgName = rs2.getString("OperateOrgName");
		if(sOrgName == null) sOrgName = "";
		
		sUserName = rs2.getString("OperateUserName");
		if(sUserName == null) sUserName = "";
		
	}
	
	rs2.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >固定资产投资贷款调查报告</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 >客户名称：</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 >业务品种：</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >固定资产投资贷款</td>");
    sTemp.append(" </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 >经办机构：</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+sOrgName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 >经办人员：</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+sUserName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 >协办人员：</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" </tr>");
    String sDay = StringFunction.getToday().replaceAll("/","");
	sTemp.append("  <tr>");
  	sTemp.append(" <td width=15% align=center class=td1 >调查日期：</td>");
    sTemp.append(" <td colspan='5' align=left class=td1 >"+DataConvert.toDate_YMD(sDay)+"&nbsp;</td>");
    sTemp.append(" </tr>");
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

