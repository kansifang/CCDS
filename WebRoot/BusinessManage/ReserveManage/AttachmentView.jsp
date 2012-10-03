
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>

</body>
</html>
<%
	String sDocNo = DataConvert.toString((String)CurComp.getParameter("DocNo"));
	String sAttachmentNo = DataConvert.toString((String)CurComp.getParameter("AttachmentNo"));

	if(session.getValueNames().length == 0) throw new Exception("------Timeout------"); 
	//out.println(sWebRootPath);
	String WebRootPath = (String) session.getValue("WebRootPath");
	
	
	
	String sViewType="";
	
	sViewType = "view"; //"view" or "save"
	
	String sqlString = "select DocNo,AttachmentNo,ContentType,ContentLength,FileName,Begintime from DOC_ATTACHMENT1 where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'";

  
    System.out.println("sqlString"+sqlString);
	
	

%>

<form name=form1 method=post action=<%=sWebRootPath%>/View1>
	<div style="display:none">
		<input name=sqlString value="<%=sqlString%>">
	</div>
</form>

<script language=javascript>
	form1.submit();
</script>
	


<%@ include file="/IncludeEnd.jsp"%>
