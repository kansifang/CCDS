<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   jytian  2004/12/21
	Tester: 
  	Content: ѡ�񸽼��� 
  	Input Param:
 			DocNo:�ĵ����	    
  	Output param:
  	History Log:
			
	*/
	%>
<%/*~END~*/%>


<html>
<head> 
<title>�����븽����Ϣ</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	
	
	%>
<%/*~END~*/%>


<script language=javascript>

	function checkItems()
	{
		//������Ϸ���		
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
			alert("�ļ�����2048k�������ϴ���");
			return false;
		}
		
		var sFileName = "";

		sFileName  = document.forms("SelectFile").LoadFileName.value;
		document.forms("SelectFile").FileName.value = sFileName;	
		if (sFileName == "")			
		{
			alert("��ѡ��һ���ļ���!");
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
    			<font size="2">��ѡ��һ���ļ���Ϊ�����ϴ�:</font>
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
			<input type="button" style="width:50px"  name="ok" value="ȷ��" onclick="javascript:if(checkItems()) { self.SelectFile.submit();} ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style="width:50px"  name="Cancel" value="ȡ��" onclick="javascript:self.returnValue='_none_';self.close()">
		</td>
      		    
	</tr>
 </table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>