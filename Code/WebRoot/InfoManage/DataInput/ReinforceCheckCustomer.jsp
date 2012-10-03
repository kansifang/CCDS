<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: zwhu
 * Tester:
 *
 * Content: 查询客户
 * Input Param:
 *			
 *
 * History Log:
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>查询客户</title>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window.open
	
	String	sCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));

	if (sCustomerID == null) sCustomerID="";
	
	double dCount = Sqlca.getDouble(" select count(*) from CUSTOMER_INFO  where CustomerID = '"+sCustomerID+"'");
%>

<script language=javascript>
	self.returnValue = "<%=dCount%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
