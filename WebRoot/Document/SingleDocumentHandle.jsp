<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=注释区;]~*/
%>
<%
	/* 
  author:  --ygao 2007-1-17
  Tester:
               
 */
%>
<%
	/*~END~*/
%>
<html>
<body>
	<table width=100% height=100%>
		<tr height=1%>
      		<td>
			<input type="button" style="width:50px"  name="ok" value="确认" onclick="javascript:if(checkItems()) { self.SelectAttachment.submit();} ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="Cancel" value="取消" onclick="javascript:self.returnValue='_none_';self.close()">
			</td>
      		    
		</tr>
		<tr height=99%>
	    	<td>
				<iframe name="myif" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="yes"></iframe>			 
	    	</td>
		</tr>
	</table>
</body>
</html>
<%
	//定义变量
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sSerialNo == null) sSerialNo = "";
	sSerialNo+="STRU";//新业务交易模式图文档号加个特别标识"STRU",每次新产品研发只有一条
	double dCount=Sqlca.getDouble("select count(1) from Doc_Attachment where DocNo ='"+sSerialNo+"'");
%>
<script language=javascript>
	var dCount=<%=dCount%>;
	var sSerialNo="<%=sSerialNo%>";
	if(dCount==0){
		popComp("AttachmentChooseDialog","/Common/Document/AttachmentChooseDialog.jsp","DocNo="+sSerialNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	openComp("AttachmentView","/Common/Document/AttachmentView.jsp","DocNo="+sSerialNo+"&AttachmentNo=001","myif","");
		
</script>

<%@ include file="/IncludeEnd.jsp"%>