
<html>
<head>
<title><%=PG_TITLE%></title> 
</head>
<body class="InfoPage" leftmargin="0" topmargin="0" >

<%@ include file="/Resources/CodeParts/CoverTip.jsp"%>

<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" id=InfoTable>
	<tr>
	    <td id="InfoTitle" class="InfoTitle">
	    </td>
	</tr>
	<%@ include file="/Resources/CodeParts/FilterArea.jsp"%>

<!-----------------------------按扭区----------------------------->
	<tr id="ButtonTR">
		<td id="InfoButtonArea" class="InfoButtonArea">
			<%
			CurPage.setAttribute("Buttons1",sButtons);
			%>
			<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
	    </td>
	</tr>
	<script language="javascript">
		sButtonAreaHTML = document.all("InfoButtonArea").innerHTML;
		if(sButtonAreaHTML.indexOf("hc_drawButtonWithTip")<0){
			document.all("ButtonTR").style.display="none";
		}
	</script>
<!-------------------------------->




<!-----------------------------数据区----------------------------->
	<tr id="DWTR">
	    <td class="InfoDWArea">
			<iframe name="myiframe0" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0></iframe>			 
	    </td>
	</tr>
<!-------------------------------->






<%
String ShowDetailArea = (String)CurPage.getAttribute("ShowDetailArea");
if(ShowDetailArea!=null && ShowDetailArea.equalsIgnoreCase("true")){
%>
	<tr>
	    <td id="InfoHorizontalBar" class="InfoHorizontalBar">
		<div id=divDrag title='可拖拽改变窗口大小' ondrag="dragFrame(event);"><img class=imgsDrag src=<%=sResourcesPath%>/1x1.gif></div>
	    </td>
	</tr>
	<tr>
	    <td id="InfoDetailAreaTD" class="InfoDetailAreaTD" >
		<table height=100% width=100% cellpadding=5>
		<tr>
		<td>
		<div class="groupboxmaxcontent">
			<iframe name="DetailFrame" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=<%=DataConvert.toString((String)CurPage.getAttribute("DetailFrameInitialText"))%>" width=100% height=100% frameborder=0></iframe>
		</div>
		</td>
		</tr>
		</table>
		</td>
	</tr>
<script language="JavaScript">
<%
String DetailAreaHeight = (String)CurPage.getAttribute("DetailAreaHeight");
if(DetailAreaHeight!=null && !DetailAreaHeight.equals(""))
{
	%>
	DWTR.height=<%=DetailAreaHeight%>;
	<%
}else{
	%>
	DWTR.height=232;	
	<%
}
%>
//DWTR.height=232;
function dragFrame(event) {
	if(event.y>100 && event.y<800) { 
		DWTR.height=event.y - DWTR.offsetTop - 5;
	}
	if(event.y<100) {
		window.event.returnValue = false;
	}
}
</script>

<%
}
%>



<!-----------------------------调试工具区----------------------------->
<%@ include file="/Resources/CodeParts/SourceDisplayTR.jsp"%>
<!-------------------------------->



</table>
</body>
</html>
<script language=javascript>
if(screen.availWidth<1000) bFreeFormMultiCol=false;
</script>