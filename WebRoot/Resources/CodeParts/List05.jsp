
<%
	String sPageHead = "";
	String sPageHeadPlacement = "";

if(PG_TITLE.indexOf("@")>=0){
	sPageHead = StringFunction.getSeparate(PG_TITLE,"@",1);
	sPageHeadPlacement = StringFunction.getSeparate(PG_TITLE,"@",2);
}

%>
<html>



<head>
<%@ include file="/Resources/CodeParts/progressSet.jsp"%>
<title><%=(sPageHeadPlacement.equals("WindowTitle")?sPageHead:"")%></title> 
</head>
<body class="ListPage" leftmargin="0" topmargin="0" >
<%@ include file="/Resources/CodeParts/CoverTip.jsp"%>
<table id="amarhidden" border="0" width="100%" height="100%" cellspacing="0" cellpadding="0"  id="ListTable">
	<%
	if(sPageHeadPlacement.equals("PageTitle")){
	%>
	<tr height=1>
	    <td id="ListTitle" class="ListTitle"><%=sPageHead%></td>
	</tr>
	<%
	}
	%>
	<%@ include file="/Resources/CodeParts/FilterArea.jsp"%>



<!-----------------------------按扭区----------------------------->
	<tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="ListButtonArea" valign=top>
			<%
			CurPage.setAttribute("Buttons1",sButtons);
			%>
			<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
	    </td>
	</tr>
	<script language="javascript">
		sButtonAreaHTML = document.all("ListButtonArea").innerHTML;
		if(sButtonAreaHTML.indexOf("hc_drawButtonWithTip")<0&&sButtonAreaHTML.indexOf("FONT title")<0){
			document.all("ButtonTR").style.display="none";
		}
	</script>
<!-------------------------------->
<!--add by conglee 2009-3-5 导出EXCEL方法-->
<script type="text/javascript">
	function exportAll()
	{
		amarExport("myiframe0");
	}
</script>

<!-----------------------------数据区----------------------------->
	<tr id="DWTR">
	    <td class="ListDWArea">
			<iframe name="myiframe0" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0></iframe>			 
	    </td>
	</tr>
<!-------------------------------->




<%
String ShowDetailArea = (String)CurPage.getAttribute("ShowDetailArea");
if(ShowDetailArea!=null && ShowDetailArea.equalsIgnoreCase("true")){
%>
	<tr>
	    <td id="ListHorizontalBar" class="ListHorizontalBar">
			<div id=divDrag title='可拖拽改变窗口大小'  ondrag='dragFrame(event);''><img class=imgsDrag src=<%=sResourcesPath%>/1x1.gif></div>
	    </td>
	</tr>
	<tr>
	    <td id="ListDetailAreaTD" class="ListDetailAreaTD" >
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
		//alert(event.y+"&&"+DWTR.offsetTop);
		DWTR.height=event.y - DWTR.offsetTop;
	}
	if(event.y<100) {
		window.event.returnValue = true;
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
<script>

</script>
