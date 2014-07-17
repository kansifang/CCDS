<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList,java.util.Iterator" %>
<%@page import="com.lmt.app.crawler.dao.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GBK">
        <title>NewsDetail</title>
    </head>
    <body style="background-image:url(../../Resources/Public/green.jpg);">
    <%
	    String sSerialNo=request.getParameter("SerialNo");
    %>
        <table border="0">
            <thead>
                <tr>
                	<th></th>
                    <th></th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            	<%
            		HtmlDao news=new HtmlDao();
            	            	          			HtmlBean nb=news.getNews("SerialNo,NewsTitle,NewsAuthor,NewsContent,NewsURL,NewsDate"," from Batch_Html where SerialNo='"+sSerialNo+"'");
            	            	          			if(nb.getSerialNo().equals(sSerialNo)){
            	            	          				String Content=nb.getContent();
            	            	          				Content=StringFunction.replace(Content,"　　", "<p>");
            	%>
            	<tr>
                    <td align="center" ><span style="font-size:20px;cursor:hand;text-decoration:underline" onclick="window.open('<%=nb.getURL()%>','_blank','')"><%=nb.getTitle()%></strong></span></td>
                </tr>
                <tr>
                   <td><span style="COLOR:#000000; FONT-SIZE: 15px;"><%=Content%></span></td>
                </tr>
            	<%		
            		}
            	%>
            </tbody>
        </table>
     </body>
    <script>
    	var curRow=0;
    	function rowClick(obj){
    		var othertr=document.getElementsByTagName("tr");
    		for(var i=0;i<othertr.length;i++){
    			othertr[i].style.background="lightgrey";
    		}
    		obj.style.background="green";
    	}
    </script>
</html>
<%@	include file="/IncludeEnd.jsp"%>