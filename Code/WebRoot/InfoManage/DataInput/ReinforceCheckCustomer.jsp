<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: zwhu
 * Tester:
 *
 * Content: ��ѯ�ͻ�
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
<title>��ѯ�ͻ�</title>

<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window.open
	
	String	sCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));

	if (sCustomerID == null) sCustomerID="";
	
	double dCount = Sqlca.getDouble(" select count(*) from CUSTOMER_INFO  where CustomerID = '"+sCustomerID+"'");
%>

<script language=javascript>
	self.returnValue = "<%=dCount%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
