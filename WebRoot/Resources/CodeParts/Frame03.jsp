<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<title>untitled</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<table border="1" width="100%" height="100%" cellspacing="0" cellpadding="0">
  <tr> 
    <td id=myleft>
	<iframe name="frameleft" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0></iframe> 
    </td>
    <td id=myright> 
	<iframe name="frameright" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp?TextToShow=请在上方列表中选择一项" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>
<!-----------------------------调试工具区----------------------------->
<!-------------------------------->
</table>
</body>
</html>

<script language="JavaScript">
myleft.width=480;
function dragFrame(event) {
	if(event.x>100 && event.x<600) { 
		myleft.width=event.x-10;
	}
	if(event.x<100) {
		window.event.returnValue = false;
	}
}
</script>
