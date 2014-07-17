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
        <style>
			.black9pt{font-size: 9pt; color: #000000; text-decoration: none}
		</style>
    </head>
    <body>
    <%
	    String pageIndex=request.getParameter("PageIndex");
		int pIndex=0;
		if(pageIndex!=null)pIndex=Integer.valueOf(pageIndex);
    %>
        <h2>新闻内容</h2>
        <table border="0">
            <thead>
            	<tr>当前页：<%=(pIndex+1) %></tr>
                <tr>
                	<th>&nbsp;</th>
                	<th>流水号</th>
                    <th>新闻标题</th>
                    <th>新闻内容</th>
                </tr>
            </thead>
            <tbody>
            	<%
            		HtmlDao news=new HtmlDao();
            	            	          			ArrayList<HtmlBean> newList=news.getNewsList("SerialNo,NewsTitle,NewsAuthor,NewsContent,NewsURL,NewsDate"," from Batch_Html where 1=1 order by num asc",pIndex,20);
            	            	           			Iterator<HtmlBean> it=newList.iterator();
            	            	           			while(it.hasNext()){
            	            	           				HtmlBean nb=it.next();
            	            	           			//System.out.println(nb.getNum());
            	            	           			//System.out.println(nb.getNewsTitle());
            	            	           			//System.out.println(nb.getNewsContent());
            	%>
            	<tr id="<%=nb.getNum()%>" style="LINE-HEIGHT: 40px;background:lightgray" onclick="rowClick(this)" onDBLClick="DisplayDetail(this)">
            		<td class="black9pt">
            			<span><%=nb.getNum()%></span></td>
            		<td class="black9pt" id="td<%=nb.getNum()%>" value="<%=nb.getSerialNo()%>">
            			<%=nb.getSerialNo()%></td>
                    <td class="black9pt">
                    	<span style="COLOR: #000000; FONT-SIZE: 22px; TEXT-DECORATION: none;"><%=nb.getTitle()%></span></td>
                    <td class="black9pt">
                    	<span style="COLOR: #000000; FONT-SIZE: 13px; TEXT-DECORATION: none;"><%=nb.getContent().substring(0, 100).replaceAll("　　","")%></span></td>
                </tr>
            	<%		
            		}
            	%>
            </tbody>
        </table>
        <input type="button" value="上一页" onclick="OpenPage('/Data/Report/CrawlerList.jsp?PageIndex=<%=pIndex-1%>','_self','')">
	    <input type="button" value="下一页" onclick="OpenPage('/Data/Report/CrawlerList.jsp?PageIndex=<%=pIndex+1%>','_self','')">
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
    	function DisplayDetail(obj){
    		var objtds=document.getElementById('td'+obj.id);
    		var sSerialNo=objtds.value;
    		OpenPage('/Data/Report/CrawlerDetail.jsp?SerialNo='+sSerialNo,'_self','');
    	}
    </script>
</html>
<%@	include file="/IncludeEnd.jsp"%>