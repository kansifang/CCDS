<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: 判断对应的报表日期是否存在
		Input Param:
			                
		Output param:
		History Log: 
			利用改造过的类一次性新增或删除一套报表
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "报表更新操作判断"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<html>
<head>
<title>报表更新操作判断</title>
<%
    //定义变量
	String sSql = "",sObjectNo = "",sReportDate = "",sReportScope = "",sReturnValue = "pass";
	ASResultSet rs = null;
	//获得组件参数
	//对象编号 暂时为客户号
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//获得页面参数
	sReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportDate"));
	sReportScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportScope"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sReportScope == null) sReportScope = "";
	if(sReportDate == null)	sReportDate = "";
	
	//取得是否有当期的财务报表
	sSql = 	" select RecordNo from CUSTOMER_FSRECORD "+
			" where CustomerID = '"+sObjectNo+"' "+			
			" and ReportDate = '"+sReportDate+"' and ReportScope = '"+sReportScope+"' ";

	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sReturnValue = "refuse";
	}
	rs.getStatement().close();
	//out.println(sSql);
%>
<script language=javascript>
	self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>