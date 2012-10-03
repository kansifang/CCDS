<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: 获得客户编号
		Input Param:
			
		Output param:
			CustomerID：客户编号
		History Log: 
			
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>获得客户编号</title>

<%	
	//定义变量：客户编号
	String sCustomerID = DBFunction.getSerialNo("CUSTOMER_INFO","CustomerID",Sqlca);
%>

<script language=javascript>
	self.returnValue = "<%=sCustomerID%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
