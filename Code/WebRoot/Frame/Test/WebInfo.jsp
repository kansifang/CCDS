<%@ page language="java" import="java.util.*" pageEncoding="GBK"%>
<jsp:directive.page import="java.text.SimpleDateFormat"/>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>应用服务器信息</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
  </head>
<%!
String getTime() {
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
	return sdf.format(cal.getTime());
}
%> 
  <body>
  <h2>应用服务器信息<h2>
  <p>当前时间:<%=getTime() %> <p>
  <p>应用服务器:<%=application.getServerInfo() %> <p>
  <p>应用服务器WebApp版本:<%=application.getMajorVersion() %>.<%=application.getMinorVersion() %><p>
  <p>应用名称:<%=application.getServletContextName() %> <p>
  <p>应用文件路径:<%=application.getRealPath("") %> <p>
  <p>请求上下文路径:<%=request.getContextPath() %> <p>
  <p>请求URL:<%=request.getRequestURL() %> <p>
  <p>Session状态:<%=session.isNew() %> <p>
  </body>
</html>