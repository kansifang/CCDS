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
    <title>Ӧ�÷�������Ϣ</title>
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
  <h2>Ӧ�÷�������Ϣ<h2>
  <p>��ǰʱ��:<%=getTime() %> <p>
  <p>Ӧ�÷�����:<%=application.getServerInfo() %> <p>
  <p>Ӧ�÷�����WebApp�汾:<%=application.getMajorVersion() %>.<%=application.getMinorVersion() %><p>
  <p>Ӧ������:<%=application.getServletContextName() %> <p>
  <p>Ӧ���ļ�·��:<%=application.getRealPath("") %> <p>
  <p>����������·��:<%=request.getContextPath() %> <p>
  <p>����URL:<%=request.getRequestURL() %> <p>
  <p>Session״̬:<%=session.isNew() %> <p>
  </body>
</html>