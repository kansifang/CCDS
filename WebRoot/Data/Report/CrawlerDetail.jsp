<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList,java.util.Iterator" %>
<%@page import="com.sohu.bean.NewsBean,com.sohu.SohuNews" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GBK">
        <title>NewsDetail</title>
    </head>
    <body>
        <h2>新闻内容</h2>
        <table border="0">
            <thead>
                <tr>
                	<th>行号</th>
                    <th>新闻标题</th>
                    <th>新闻内容</th>
                </tr>
            </thead>
            <tbody>
            	<%
            		String pageIndex=request.getParameter("PageIndex");
            		int pIndex=0;
            		if(pageIndex!=null)pIndex=Integer.valueOf(pageIndex);
            		ArrayList<NewsBean> newList=(ArrayList)session.getAttribute("newsList");
            		if(newList==null){
            			SohuNews news=new SohuNews();
            			newList=news.getNewsList("NewsTitle,NewsAuthor,NewsContent,NewsDate"," from Batch_Html where 1=1 order by num asc",pIndex,8);
            		}
            		Iterator<NewsBean> it=newList.iterator();
            		while(it.hasNext()){
            			NewsBean nb=it.next();
            			System.out.println(nb.getNum());
            			System.out.println(nb.getNewsTitle());
            			System.out.println(nb.getNewsContent());
            	%>
            	<tr>
            		<td><%=nb.getNum()%></td>
                    <td><%=nb.getNewsTitle()%></td>
                    <td><%=nb.getNewsContent().substring(0, 50)%></td>
                </tr>
            	<%		
            		}
            	%>
            </tbody>
        </table>
        <input type="button" value="上一页" onclick="OpenPage('/Data/Report/CrawlerDetail.jsp?PageIndex=<%=pIndex-1%>','_self','')">
	    <input type="button" value="下一页" onclick="OpenPage('/Data/Report/CrawlerDetail.jsp?PageIndex=<%=pIndex+1%>','_self','')">
    </body>
</html>
<%@	include file="/IncludeEnd.jsp"%>