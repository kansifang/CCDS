<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
	/*
	Author:   gxlin 2010/06/13
	Tester: 
  	Content: ѡ�񸽼��� 
  	Input Param:
  	Output param:
  	History Log:
			
	*/
	%>
<%/*~END~*/%>


<html>
<head>
<title>��ѡ��ģ���ļ�</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	
	//����������	

	String sItemID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID")));
	String sFileType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FileType")));
	//����������	
%>
<%//��֤��Ǽǲ��ȱ��ָ��¼����ɱ�֤����Ѻ��ͬ
%>
<%/*~END~*/%>

<script language=javascript>
	function checkItems()
	{
		//������Ϸ���		
		var isSelected=false;
		var Input= document.forms("SelectAttachment").getElementsByTagName("input");
		for(var i=0;i<Input.length;i++){
			if(Input[i].name.indexOf("AttachmentFileName")!==-1){
				var sFileName=Input[i].value;
				if(sFileName!=""){
					if("<%=sFileType%>"=="Text"){
						if((-1==sFileName.toUpperCase().indexOf(".TXT")) && (-1==sFileName.toUpperCase().indexOf(".SQL")))
						{
							alert("ֻ�����ϴ��ı��ļ���");
							return false;
						}
					}else if("<%=sFileType%>"=="Excel"){
						if((-1==sFileName.toUpperCase().indexOf(".XLS")))
						{
							alert("ֻ�����ϴ�Excel�ļ���");
							return false;
						}
					}	
					isSelected=true
				}
			}
		}
		if(!isSelected){
			alert("������ѡ��һ��'�����ļ�'!");
			return false;
		}
		if("<%=sItemID%>"=="2"){//����ʼ��
			if(confirm("�Ƿ����ѺƷ�����ʱ��")){
				document.forms("SelectAttachment").ClearTable.value="true";
			}else{
				document.forms("SelectAttachment").ClearTable.value="false";
			}
		}else if("<%=sItemID%>"=="3"){//Ʊ�ݸ������κż�����ҵ��֤����Ϣ
			if(confirm("�Ƿ����ҵ���������Ϣ������ʱ��")){
				document.forms("SelectAttachment").ClearTable.value="true";
			}else{
				document.forms("SelectAttachment").ClearTable.value="false";
			}
		}else if("<%=sItemID%>"=="4"){//��֤���ʼ��
			if(confirm("�Ƿ���ձ�֤����Ϣ����ʱ��")){
				document.forms("SelectAttachment").ClearTable.value="true";
			}else{
				document.forms("SelectAttachment").ClearTable.value="false";
			}
		}else if("<%=sItemID%>"=="5"){//��ȳ�ʼ��
			if(confirm("�Ƿ���շſ���Ϣ����ʱ��")){
				document.forms("SelectAttachment").ClearTable.value="true";
			}else{
				document.forms("SelectAttachment").ClearTable.value="false";
			}
		}
		try{
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			//var f1 = fso.GetFile(SelectAttachment.AttachmentFileName.value);						
		}catch(e) 
		{
			alert(e.name+" "+e.number+" :"+e.message);
		}
		
	//	if(f1.size>2048*1024) 
	//	{
	//		alert("�ļ�����2048k�������ϴ���");//�ļ�����2048k�������ϴ���
	//		return false;
	//	}
		return true;
	}	  
	var row=1; 
	function addFile(){//ÿ���һ����Ӱ�ť������һ���ϴ��� 
		var obj = document.getElementById("upfile"); 
		var r = obj.insertRow(); 
		var c =r.insertCell();
		c.style.backgroundColor="#D8D8AF";
		c.align="right";
		var temp="�����ļ�"+(row+1)+"��";
		c.innerHTML+=temp;
		c=r.insertCell(); 
		c.style.backgroundColor="#F0F1DE";
		temp=" <input type=file name=AttachmentFileName["+(row++)+"] size=30>";//���������Ķ���theFile��ͷ 
	    c.innerHTML+=temp; 
	} 
	function myclick()
	{
		if(checkItems()) 
		{ 
			/*
			var sFileName="";
						
			sFileName  = document.forms("SelectAttachment").AttachmentFileName.value;	
	        var pos = 0;
	        var i = 0;
	        var start = 0;
	        var end = 0;
	        pos = sFileName.lastIndexOf("/");
	        if(pos != -1)
	            sFileName =  sFileName.substring(pos + 1, sFileName.length);
	        pos = sFileName.lastIndexOf("\\");
	        if(pos != -1)
	            sFileName = sFileName.substring(pos + 1, sFileName.length);

			window.opener.HtmlEdit.document.body.innerHTML = window.opener.HtmlEdit.document.body.innerHTML;
			*/
			self.SelectAttachment.submit();
			ShowMessage('���ڽ��г�ʼ��,�����ĵȴ�.......',true,false);
		}
	}
</script>
<style>
.black9pt {
	font-size: 9pt;
	color: #000000;
	text-decoration: none
}

.btn {
	font-size: 9pt;
	width: 45;
	padding-top: 3;
	padding-left: 5;
	padding-right: 5;
	background-image: url(../../Resources/functionbg.gif);
	border: #DEDFCE;
	border-style: outset;
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px
}
</style>
</head>

<body bgcolor="#D3D3D3">
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="FileUpload.jsp?CompClientID=<%=CurComp.ClientID%>" align="center">
<table align="center" width="350" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>
		<td colspan="2" align="center" bgcolor="#D8D8AF"></td>
	</tr>
	<tr>
	<td colspan="2" align="center">
	<table border="0" align="center" id="upfile">
	<tr>
		<td align="right" class="black9pt" bgcolor="#D8D8AF" width="70">�����ļ�1��</td>
		<td bgcolor="#F0F1DE">
			<input type="file" size=30 name="AttachmentFileName[0]"> 
		</td>
	</tr>
	</table>
	</td>
	</tr>
	<!-- ���Զ�̬��Ӷ�������ϴ� -->
	<tr>
		<td colspan="2"><input type="button" name="addAttachment" value="��Ӷ���ļ� " onclick="addFile()"></td>
	</tr>
	<tr>
		<td align="right" class="black9pt" bgcolor="#D8D8AF" height="25">&nbsp;</td>
		<td bgcolor="#F0F1DE" height="25" align="center">
		<input type="hidden" name="ItemID" value="<%=sItemID%>">
		<input type="hidden" name="ClearTable" value="">
		<input type="button" name="Confirm" value="ȷ  ��" onClick="javascipt:myclick();"class="btn" border='1'>
		<input type="button" name="Cancel" value="ȡ  ��" onClick="javascript:self.returnValue='_CANCEL_';self.close();"
			class="btn" border='1'></td>
	</tr>
</table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>