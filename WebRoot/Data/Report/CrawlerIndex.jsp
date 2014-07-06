<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GBK">
        <title>新闻抓取</title>
    </head>
    <body>
        <form action="<%=sWebRootPath%>/GetNewsServlet" method="post" id="newsform">
        <div align="center">
        	新闻首页地址： 
	        <input name="newsfield" id="newsfield" type="text" value="http://news.sohu.com/" style="border-width:inherit;width:1000px">
	        <input type="submit" id="newsSubmit" value="提交">
        </div>
        </form>
        </body>
</html>
<%@	include file="/IncludeEnd.jsp"%>