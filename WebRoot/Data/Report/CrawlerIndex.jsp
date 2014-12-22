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
        <form id="newsform" action="<%=sWebRootPath%>/GetNewsServlet" method="post" >
        <div align="center">
        <table>
        	<tr><td cospan=2>新闻期限：</td></tr> 
	        <tr><td>开始日</td>
	        <td>
	        	<input type=text size=15 value="<%=StringFunction.getRelativeMonth(StringFunction.getToday(),-1)%>" name="startDate" ondblclick="getMonth(this)">
	  		</td>
	  		</tr>      
	  		<tr><td> 截止日</td>
	        <td>
	        	<input type=text size=15 value="<%=StringFunction.getToday()%>" name="endDate" ondblclick="getMonth(this)">
	  		</td>
	  		</tr>    
	        <input name="CompClientID" type="hidden" value="<%=sCompClientID%>">
	        <tr><td cospan=2><input type="submit" id="newsSubmit" value="提交"></td></tr> 
	        </table>
        </div>
        </form>
        </body>
</html>
<script language=javascript>
function getMonth(obj){
	//SelectMonth
	var sReturn=PopPage("/Common/ToolsA/SelectDate.jsp","","dialogWidth:300px;dialogHeight:240px;center:yes;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	if(typeof(sReturn)=="undefined"){
		obj.value="";
	}else{
		obj.value=sReturn;
	}
}
</script>
<%@	include file="/IncludeEnd.jsp"%>