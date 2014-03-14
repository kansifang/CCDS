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
<title>«Î…‘∫Ú...</title>
</head>
<body>
<a id=mydownload name=mydownload href="<%=sWebRootPath%><%=sURLName%>" >œ¬‘ÿ</a>
</body>
</html>
<script language=javascript>

	mydownload.click();  //window.open("<%=sWebRootPath%><%=sURLName%>");	

	setTimeout('closeTop();',1000);	
	function closeTop()
	{
		//top.close();
		parent.myhide('myiframe0');
	}

</script>
<%@ include file="/IncludeEnd.jsp"%>