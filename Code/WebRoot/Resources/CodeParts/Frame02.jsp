
<html>
<head>
<title>untitled</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<table border="1" width="100%" height="100%" cellspacing="0" cellpadding="0">
  <tr id=mytop> 
    <td>
	<iframe name="rightup" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>
  <tr id=mydown> 
    <td> 
	<div id=divDrag title='����ק�ı䴰�ڴ�С' ondrag="dragFrame(event);"><img class=imgsDrag src=<%=sResourcesPath%>/1x1.gif></div>
	<iframe name="rightdown" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp?TextToShow=�����Ϸ��б���ѡ��һ��" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>
</table>
</body>
</html>

<script language="JavaScript">
mytop.height=232;
function dragFrame(event) {
	if(event.y>100 && event.y<800) { 
		mytop.height=event.y-10;
	}
	if(event.y<100) {
		window.event.returnValue = false;
	}
}
</script>
