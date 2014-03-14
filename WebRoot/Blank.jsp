<%@page contentType="text/html; charset=GBK"%>
<%@page buffer="64kb" errorPage="/ErrorPage.jsp"%>
<%@page import="com.lmt.frameapp.web.*"%>
<%@page import="com.lmt.frameapp.config.ASConfigure"%> 
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);

	ASRuntimeContext CurARC= (ASRuntimeContext)session.getAttribute("CurARC");
    if(CurARC == null) throw new Exception("------Timeout------");
	String sResourcesPath = (String)CurARC.getAttribute("ResourcesPath");
	String sPostChange = ASConfigure.getASConfigure().getConfigure("PostChange");
	int iPostChange = Integer.valueOf(sPostChange).intValue();

	String sTextToShow  = com.lmt.baseapp.util.DataConvert.toRealString(iPostChange,(String)request.getParameter("TextToShow"));
	if(sTextToShow == null || sTextToShow.length() == 0) sTextToShow = "正在打开页面,请稍候...";
	sTextToShow  = java.net.URLDecoder.decode(sTextToShow,"UTF-8");
%>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel="stylesheet" href="<%=sResourcesPath%>/Style.css">	
</head>

<body class="pagebackground" text="#000000">
<table>
<tr>
<td>
<%
if (sTextToShow!=null) 
{
	out.println(sTextToShow);
}
%>
</td>
</tr>
</table>
</body>
</html>
