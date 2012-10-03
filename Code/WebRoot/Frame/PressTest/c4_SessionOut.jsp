<%@ page contentType="text/html; charset=GBK"%>
<%@ page buffer="64kb" errorPage="/ErrorPage.jsp"%>
<html>
<head>
<title>系统注销</title>
</head>
<%
	session.invalidate();
%>
<body>
<font color="red">退出成功！</font>
</body>
</html>