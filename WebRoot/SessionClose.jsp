<%@ page contentType="text/html; charset=GBK"%>
<%@ page buffer="64kb" errorPage="/ErrorPage.jsp"%>
<%
	String sWebRootPath = request.getContextPath();	
%>
<body class="pagebackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}" onBeforeUnload="onClose()">
</body>
<script>
	function onClose()
	{
		if(window.event.clientX>360 && window.event.clientY<0 || window.event.altKey) {
			window.open("<%=sWebRootPath%>/SessionOut.jsp","_top","");	
		}
	}
</script>