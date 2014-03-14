<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
		Author:   zywei  2006/06/21
		Tester: 
	  	Content: 选择附件框 
	  	Input Param:
	 			BoardNo:通知编号	    
	  	Output param:
	  	History Log:
		
		*/
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/
%>
	<%
		//定义变量
		
		//获得组件参数	

		//获得页面参数	
		String sBoardNo=  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BoardNo"));
	%>
<%
	/*~END~*/
%>


<html>
<head> 
<title>新增文件</title>

<script language=javascript>

	function checkItems(){
		//检查代码合法性
		
		var sFileName="",sDelay="";

		sFileName  = document.forms("SelectAttachment").AttachmentFileName.value;	
		document.forms("SelectAttachment").FileName.value=sFileName;		
		if (sFileName=="")			
		{
			alert("请选择一个文件名!");
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
		
		if(f1.size>3072*1024) {alert("文件大于3M，不能上传！");return false;}
		
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
	请选择一个文件作为附件上传： <p>
	
	<input type="file" size=40  name="AttachmentFileName"> <p>
	<!--
	请选择上传方式： 
	<select name="DelayTransform">
		<option value="1" selected> 即时发送
		<option value="0" > 晚上定时发送
	</select><p>
	-->
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type=hidden name="BoardNo" value="<%=sBoardNo%>" >
    <input type=hidden name="FileName" value="" >

	<input type="button" style="width:50px"  name="ok" value="确认" onclick="javascipt:if(checkItems()) { self.SelectAttachment.submit();} ">&nbsp;&nbsp; 
	<input type="button" style="width:50px"  name="Cancel" value="取消" onclick="javascript:self.returnValue='_none_';self.close()">
</form>
</td>
</tr>
</table>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>
