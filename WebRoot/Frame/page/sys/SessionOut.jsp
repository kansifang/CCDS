<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>SessionOut</title>
</head>
<%	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	session.invalidate(); %>
<script type="text/javascript">
if(navigator.userAgent.toLowerCase().indexOf("msie 6")>-1)
{
	window.opener = null;
	window.close();
}
else
	window.open("<%=request.getContextPath()%>/index.html","_top","");
</script>
<body>
</body>
</html>