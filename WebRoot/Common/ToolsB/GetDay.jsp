<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>获得时间</title>

<%
	String	sReturn	= StringFunction.getToday();
%>

<script language=javascript>
	self.returnValue = "<%=sReturn%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
