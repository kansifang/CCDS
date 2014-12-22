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
			.black9pt{font-size: 9pt; color: #000000; text-decoration: none;height:18px }
		</style>
    </head>
    <body>
    <%
	    String pageIndex=request.getParameter("PageIndex");
		int pIndex=0;
		if(pageIndex!=null)
			pIndex=Integer.valueOf(pageIndex);
    %>
        <h2>新闻内容</h2>
        <input type="button" value="上一页" onclick="OpenPage('/Data/Report/CrawlerList.jsp?PageIndex=<%=pIndex-1%>','_self','')">
	    	当前页：<%=(pIndex+1) %>
	    <input type="button" value="下一页" onclick="OpenPage('/Data/Report/CrawlerList.jsp?PageIndex=<%=pIndex+1%>','_self','')">
        
        <div style="position:relative;width:100%;height:85%; overflow:scroll; border:1px solid;">
        <table border="0" style="width:100%;height:100%;">
                <tr>
                	<th>序号</th>
                	<th>流水号</th>
                	<th>新闻时间</th>
                    <th>新闻标题</th>
                    <th>新闻内容</th>
                </tr>
            	<%
            		HtmlDao news=new HtmlDao();
          			ArrayList<HtmlBean> newList=news.getNewsList("SerialNo,NewsTitle,NewsAuthor,NewsContent,NewsURL,NewsDate"," from Batch_Html where 1=1 order by num asc",pIndex,20);
           			Iterator<HtmlBean> it=newList.iterator();
           			while(it.hasNext()){
           				HtmlBean nb=it.next();
           				String content=nb.getContent().replaceAll("　　","").replaceAll("\"", "'");
            	%>
	            	<tr id="<%=nb.getNum()%>" style="HEIGHT: 10px;background:lightgray" onclick="rowClick(this)" onDBLClick="DisplayDetail(this)">
            		<td class="black9pt"><%=nb.getNum()%></td>
            		<td class="black9pt" id="td<%=nb.getNum()%>" value="<%=nb.getSerialNo()%>">
            			<%=nb.getSerialNo()%>
            		</td>
            		<td class="black9pt">
            			<%=nb.getLastUpdateTime()%></td>	
                    <td class="black9pt">
                    	<%=nb.getTitle()%>
                    </td>
                    <!-- 临时保存当前新闻内容 -->
                    <input id= '<%=nb.getSerialNo()%>' value="<%=content%>" type="hidden"/>
                    <td class="black9pt" style='CURSOR:Hand' onMouseOver=showTipOfToday(1,this,'<%=nb.getSerialNo()%>') onMouseOut='showlayerforCP(0,this)'>
                    	概要
                    </td>
                </tr>
            	<%		
            		}
            	%>
        </table>
        </div>
        <div id="sMenu0" style="position:absolute; left:0px; top:0px; visibility:hidden">
		</div>
        <div id="sMenu1" style="overflow:auto;position:absolute; visibility:hidden;background:grey" onMouseOver='showlayerforCP(0,this)'>
		</div>
    </body>
    <script language="javascript">
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
    		PopModelessPage('/Data/Report/CrawlerDetail.jsp?SerialNo='+sSerialNo,'_blank','resizable=yes;dialogWidth:60;dialogHeight:40;center:no;status:no;statusbar:no');
    	}
    	//下面两个函数加上 上面两个 div构成了展示和不展示的一个小功能
    	function showlayerforCP(id,e){  
    		document.all('sMenu'+id).style.left=getRealLeft(e);
    		document.all('sMenu'+id).style.top=getRealTop(e)+e.offsetHeight;
    	    //document.all('sMenu'+id).style.width=e.offsetWidth;
    	    if(getRealLeft(e)+ e.offsetWidth + document.all('sMenu'+id).offsetWidth >document.body.offsetWidth)
    	    	document.all('sMenu'+id).style.left = getRealLeft(e) - document.all('sMenu'+id).offsetWidth;
    	    if(getRealTop(e)+ e.offsetHeight + document.all('sMenu'+id).offsetHeight >document.body.offsetHeight)
    	    	document.all('sMenu'+id).style.top = getRealTop(e) - document.all('sMenu'+id).offsetHeight;
    	    document.all('sMenu'+id).style.visibility="visible";
    	    for(var i=0;i<2;i++){
    	        if(i!=id)
    	        	document.all('sMenu'+i).style.visibility="hidden";
    	    }
    	}
    	//展示概要信息
    	function showTipOfToday(id,e,serialno){
    	    sHtmlTmp = "";
    	    sHtmlTmp += "<table  border=1 cellspacing=0 cellpadding=3 bordercolorlight=#99999 bordercolordark=#FFFFFF width=110 ><tr><td class=sMenuTd2>";
    	    sHtmlTmp += $("#"+serialno).attr("value");
    	    sHtmlTmp += "</td></tr></table>";
    	    document.all('sMenu'+id).innerHTML = sHtmlTmp;
    	    showlayerforCP(id,e);
    	}
    </script>
</html>
<%@	include file="/IncludeEnd.jsp"%>