<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
		Author:   zywei  2006/06/21
		Tester: 
	  	Content: ѡ�񸽼��� 
	  	Input Param:
	 			BoardNo:֪ͨ���	    
	  	Output param:
	  	History Log:
		
		*/
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
%>
	<%
		//�������
		
		//����������	

		//���ҳ�����	
		String sBoardNo=  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BoardNo"));
	%>
<%
	/*~END~*/
%>


<html>
<head> 
<title>�����ļ�</title>

<script language=javascript>

	function checkItems(){
		//������Ϸ���
		
		var sFileName="",sDelay="";

		sFileName  = document.forms("SelectAttachment").AttachmentFileName.value;	
		document.forms("SelectAttachment").FileName.value=sFileName;		
		if (sFileName=="")			
		{
			alert("��ѡ��һ���ļ���!");
			return false;
		}	

		try {
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			var f1 = fso.GetFile(SelectAttachment.AttachmentFileName.value);
			//f1 = fso.GetFile("d:\\1.xls");
			//alert(f1.size);
			
			
		}catch(e) {
			alert(e.name+" "+e.number+" :"+e.message);
		}
		
		if(f1.size>3072*1024) {alert("�ļ�����3M�������ϴ���");return false;}
		
		return true;
	}	   
</script>

<link rel="stylesheet" href="/sdb/jsp/style.css">
</head>
<body bgcolor="#EBF5FA">
<table align = "center">
<tr>
<td>
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="FileUpload.jsp?CompClientID=<%=CurComp.ClientID%>">
	��ѡ��һ���ļ���Ϊ�����ϴ��� <p>
	
	<input type="file" size=40  name="AttachmentFileName"> <p>
	<!--
	��ѡ���ϴ���ʽ�� 
	<select name="DelayTransform">
		<option value="1" selected> ��ʱ����
		<option value="0" > ���϶�ʱ����
	</select><p>
	-->
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type=hidden name="BoardNo" value="<%=sBoardNo%>" >
    <input type=hidden name="FileName" value="" >

	<input type="button" style="width:50px"  name="ok" value="ȷ��" onclick="javascipt:if(checkItems()) { self.SelectAttachment.submit();} ">&nbsp;&nbsp; 
	<input type="button" style="width:50px"  name="Cancel" value="ȡ��" onclick="javascript:self.returnValue='_none_';self.close()">
</form>
</td>
</tr>
</table>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>
