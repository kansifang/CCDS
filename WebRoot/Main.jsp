<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Resources/Include/IncludeHead.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 主页面
		Input Param:
			          
		Output param:
			      
		History Log: syang 2009/09/27 工作台及日历挪到日常工作提示上。
		History Log: syang 2009/12/09 改写页面TAB生成方式。
		History Log: syang 2009/12/16 TAB支持自定义功能
	 */
	%>
<%/*~END~*/%>
<%
		String PG_TITLE = "模型配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;基础配置&nbsp;&nbsp;"; //默认的内容区标题
		String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
		String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>

<%
	//取系统名称
	PG_TITLE = CurConfig.getConfigure("ImplementationName");
	if (PG_TITLE == null) PG_TITLE = "";
%> 


<html>
<head>
<title><%=PG_TITLE%></title>
</head>
<body leftmargin="0" topmargin="0" class="windowbackground" style="{overflow:auto;overflow-x:scroll;overflow-y:visible}">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<!-- add by byhu: 用于刷新本页面 -->
<form name="DOFilter" method=post onSubmit="if(!checkDOFilterForm(this)) return false;">
		<input type=hidden name=CompClientID value="<%=CurComp.ClientID%>">
		<input type=hidden name=PageClientID value="<%=CurPage.ClientID%>">
</form>

	<tr>
		<td id=mytop class="mytop">
			<%@include file="/MainTop.jsp"%>
		</td>
	</tr>
	<tr>
		<td valign="top" id="mymiddle" class="mymiddle"></td>
	</tr>
	<tr>
		<td valign="top" id="mymiddleShadow" class="mymiddleShadow"></td>
	</tr>
	<tr>
		<td id="myall" valign="top" onMouseOver="showlayer(0,mymiddle)">
			<!-- 内容区域 -->
			<%@include file="/DeskTop/Components/MainContent.jsp"%>
			<!-- 内容区域 -->
		</td>
	</tr>
<!-----------------------------调试工具区----------------------------->
<%@ include file="/Resources/CodeParts/SourceDisplayTR.jsp"%>
<!-------------------------------->
</table>
</body>
</html>
<script language="JavaScript">
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	myleft.width=<%=PG_LEFT_WIDTH%>; 
	<%
	String sDefaultCompID = CurPage.getParameter("DefaultCompID");
	String sDefaultCompParas = CurPage.getParameter("DefaultCompParas");
	if(sDefaultCompParas!=null) sDefaultCompParas = StringFunction.replace(sDefaultCompParas,"~","&");
	else sDefaultCompParas="";
	if(sDefaultCompID!=null && !sDefaultCompID.equals("")){
	%>
	OpenComp("<%=sDefaultCompID%>","","<%=sDefaultCompParas%>","right","");
	<%}%>
</script>
<%@ include file="/IncludeEnd.jsp"%>