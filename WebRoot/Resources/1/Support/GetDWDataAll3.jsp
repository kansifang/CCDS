<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginDW.jsp"%>
<%
	String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
	String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("type"));
	if(sType==null || sType.equals("") || sType.equals("null")) sType = "export";   //print,export

	//Vector vTemp = null;
	//int i = 0;
	String sURLName = "";

	if(sDWName!=null && !sDWName.equals(""))
	{
		//modify by hxd in 2005/06/06
		//ASDataWindow dwTemp = (ASDataWindow) session.getAttribute(sDWName);
		ASDataWindow dwTemp = null;
		if(CurPage!=null)
			dwTemp = (ASDataWindow) CurPage.getAttribute(sSessionID);
		else
			dwTemp = (ASDataWindow) session.getAttribute(sSessionID);	

		dwTemp.Sqlca = Sqlca;

		//vTemp = dwTemp.genHTMLAll("",999999);
		sURLName = dwTemp.genHTMLAllEx(request,"",65535);		
	}
	
%>
<html>
<head>
<title>下载文件</title>
</head>
<body>
<!--  点击此链接<a id=mydownload name=mydownload href="<%=sWebRootPath%><%=sURLName%>" ><font size = 5pt color="ff0000"><b>下载>></b></font></a>
-->
<form name=form1 method=post action=<%=sWebRootPath%>/fileview>
	<div style="display:none">
		<input name=filename value="<%=sURLName%>">
		<input name=contenttype value="application/x-zip-compressed">
		<input name=viewtype value="view">		
	</div>
</form>
</body>
<script language=javascript>
	form1.submit();
	//self.close();
	//mydownload.click();
	setTimeout('closeTop();',2000);	
	function closeTop()
	{
		top.close();
	}

</script>
</html>
<%@ include file="/IncludeEnd.jsp"%>