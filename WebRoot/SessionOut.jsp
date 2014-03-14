<%@ page contentType="text/html; charset=GBK"%>
<%@ page buffer="64kb" errorPage="/ErrorPage.jsp"%>
<html>
<head>
<title>ÏµÍ³×¢Ïú</title>
</head>
<%
	String sWebRootPath = request.getContextPath();	
	session.invalidate();
%>
<body>
	<script language=javascript>
		window.open("<%=sWebRootPath%>/index.html","_top","");
	</script>
</body>
</html>