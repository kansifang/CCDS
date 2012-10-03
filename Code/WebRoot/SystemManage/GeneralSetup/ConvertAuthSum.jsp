<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: zwhu
 * Tester:
 *
 * Content: 设置授权
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
<title>更新授权</title>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window.open
	
	String	sAuthSum = DataConvert.toRealString(iPostChange,(String)request.getParameter("AuthSum"));
	if (sAuthSum == null) sAuthSum="0";
	sAuthSum = DataConvert.toMoney(sAuthSum);
%>

<script language=javascript>
	self.returnValue = "<%=sAuthSum%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
