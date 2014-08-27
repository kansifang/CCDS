<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
</html>
<%
	String sViewType = DataConvert.toString((String)CurComp.getParameter("ViewType"));//"view" or "save"
	String sSerialNo = DataConvert.toString((String)CurComp.getParameter("SerialNo"));

    String sFullPath = Sqlca.getString("select FullPath from EDOC_PRINT where SerialNo='"+sSerialNo+"'");
    String sContentType = Sqlca.getString("select ContentType from EDOC_PRINT where SerialNo='"+sSerialNo+"'");
%>

<form name=form1 method=post action=<%=sWebRootPath%>/fileview>
	<%=sFullPath%>
	<div style="display:none">
		<input name=filename value="<%=sFullPath%>">
		<input name=contenttype value="<%=sContentType%>">
		<input name=viewtype value="<%=sViewType%>">		
	</div>
</form>

<script language=javascript>
	document.all.filename.value=encodeURIComponent(document.all.filename.value,'UTF-8');
	form1.submit();
	setTimeout("top.close();",4000);
</script>
<%@ include file="/IncludeEnd.jsp"%>