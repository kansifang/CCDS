<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: zwhu
 * Tester:
 *
 * Content: ������Ȩ
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
<title>������Ȩ</title>

<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window.open
	
	String	sAuthSum = DataConvert.toRealString(iPostChange,(String)request.getParameter("AuthSum"));
	if (sAuthSum == null) sAuthSum="0";
	sAuthSum = DataConvert.toMoney(sAuthSum);
%>

<script language=javascript>
	self.returnValue = "<%=sAuthSum%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
