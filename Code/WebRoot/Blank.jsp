<%@page contentType="text/html; charset=GBK"%>
<%@page buffer="64kb" errorPage="/ErrorPage.jsp"%>
<%@page import="com.amarsoft.web.*"%>
<%@page import="com.amarsoft.web.config.ASConfigure"%> 
<%
	ASRuntimeContext CurARC= (ASRuntimeContext)session.getAttribute("CurARC");
	String sResourcesPath = (String)CurARC.getAttribute("ResourcesPath");
	String sPostChange = ASConfigure.getASConfigure().getConfigure("PostChange");
	int iPostChange = Integer.valueOf(sPostChange).intValue();

	String sTextToShow  = com.amarsoft.are.util.DataConvert.toRealString(iPostChange,(String)request.getParameter("TextToShow"));
	if(sTextToShow == null || sTextToShow.length() == 0) sTextToShow = "正在打开页面,请稍候...";
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
