<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>

</body>
</html>
<%
	String sBoardNo = DataConvert.toString((String)CurComp.getParameter("BoardNo"));

	
	String sqlString = "";
	if(sBoardNo!=null && !sBoardNo.equals(""))
		sqlString = "select ContentType,ContentLength,FileName,FilePath,FullPath,DocContent,BoardNo as DocNo,BoardNo as AttachmentNo from BOARD_LIST where BoardNo='"+sBoardNo+"'";
	else
		sqlString = "select ContentType,ContentLength,FileName,FilePath,FullPath,DocContent,BoardNo as DocNo,BoardNo as AttachmentNo from BOARD_LIST where iseject='1' order by BoardNo desc "; 	

	String sViewType="";
	
	sViewType = "view"; //"view" or "save"
	
	sqlString = sViewType+"@"+sqlString;
	if(sViewType.equals("view"))
	{
%>

<form name=form1 method=post action=<%=sWebRootPath%>/boardview>
	<div style="display:none">
		<input name=sqlString value="<%=sqlString%>">
	</div>
</form>

<script language=javascript>
	form1.submit();
</script>
	
<%
		}
		else
		{
	%>	
<form name=form1 method=post action=<%=sWebRootPath%>/boardview target=MyAtt>
	<div style="display:none">
		<input name=sqlString value="<%=sqlString%>">
	</div>
</form>

<script language=javascript>
	form1.submit();
	//if(confirm("关闭吗？")) self.close();
</script>
<%
	}
%>	
	
<%@ include file="/IncludeEnd.jsp"%>
