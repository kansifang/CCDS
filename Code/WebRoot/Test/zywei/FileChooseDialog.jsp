<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   jytian  2004/12/21
	Tester: 
  	Content: 选择附件框 
  	Input Param:
 			DocNo:文档编号	    
  	Output param:
  	History Log:
			
	*/
	%>
<%/*~END~*/%>


<html>
<head> 
<title>请输入附件信息</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	//获得页面参数	
	
	%>
<%/*~END~*/%>


<script language=javascript>

	function checkItems()
	{
		//检查代码合法性		
		try 
		{
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			var f1 = fso.GetFile(SelectFile.LoadFileName.value);						
		}catch(e) 
		{
			alert(e.name+" "+e.number+" :"+e.message);
		}
		
		if(f1.size>2048*1024) 
		{
			alert("文件大于2048k，不能上传！");
			return false;
		}
		
		var sFileName = "";

		sFileName  = document.forms("SelectFile").LoadFileName.value;
		document.forms("SelectFile").FileName.value = sFileName;	
		if (sFileName == "")			
		{
			alert("请选择一个文件名!");
			return false;
		}	
		return true;
	}	   

</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#D3D3D3">
<form name="SelectFile" method="post" ENCTYPE="multipart/form-data" action="LoadExcelFile.jsp?CompClientID=<%=CurComp.ClientID%>" align="center">
<table align="center">
	<tr>
    		<td class="black9pt"  align="left">
    			<font size="2">请选择一个文件作为附件上传:</font>
    		</td> 
    	</tr>
    	<tr>
    		<td>   
    			<input type="file" size=60  name="LoadFileName"> 
    		</td>
    	</tr>
      	<tr>
      		<td>      					
    			<input type=hidden name="FileName" value="" >
    		</td> 
    	</tr>
    	<tr>
      		<td>
      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="ok" value="确认" onclick="javascript:if(checkItems()) { self.SelectFile.submit();} ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="Cancel" value="取消" onclick="javascript:self.returnValue='_none_';self.close()">
		</td>
      		    
	</tr>
 </table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>