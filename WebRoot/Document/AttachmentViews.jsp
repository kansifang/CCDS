<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<html>
<body>
<table>
  <tr>
    <td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","上一个","恢复","javascript:last()",sResourcesPath)%></td>
    <td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","下一个","恢复","javascript:next()",sResourcesPath)%></td>
  </tr>
</table>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
</html>
<%
	String sDocNo = DataConvert.toString((String)CurComp.getParameter("DocNo"));
	String sSql="select AttachmentNo from Doc_Attachment where DocNo='"+sDocNo+"'";
	ASResultSet rs=Sqlca.getASResultSet(sSql);
%>
<script language=javascript>var attachs=new Array();var i=0;</script>
<%
	while(rs.next()){
	String attach=DataConvert.toString(rs.getString(1));
%>
<script language=javascript>attachs[i]="<%=attach%>";i++</script>
<%
	}
	rs.getStatement().close();
%>
<script language=javascript>
	var j=0;
	function last(){
		if(j==0){
			j=attachs.length-1;
		}else{
			j--;
		}
		OpenComp("AttachmentView","/Common/Document/AttachmentView.jsp","DocNo=<%=sDocNo%>&AttachmentNo="+attachs[j],"MyAtt","");
	}
	function next(){
		if(j==attachs.length-1){
			j=0;
		}else{
			j++;
		}
		OpenComp("AttachmentView","/Common/Document/AttachmentView.jsp","DocNo=<%=sDocNo%>&AttachmentNo="+attachs[j],"MyAtt","");
	}	
	j=1;
	last();
</script>
<%@ include file="/IncludeEnd.jsp"%>
