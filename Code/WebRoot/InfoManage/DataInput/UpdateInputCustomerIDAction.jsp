<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.8
		Tester:
		Content: 更新客户类型
		Input Param:
			                CustomerID:客户编号
			                CustomerType:客户类型
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>更新客户类型</title>
<%
	String sSql;
	ASResultSet rs = null;
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));	
	String SerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));	
	String sToday = StringFunction.getToday();

	sSql = 	" Update BUSINESS_CONTRACT set CustomerID = '"+sCustomerID+"',"+
			" UpdateDate ='"+sToday+"' "+
			" where SerialNo = '"+SerialNo+"'";
	Sqlca.executeSQL(sSql);
	
%>
<script language=javascript>
	self.returnValue = "succeed";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>