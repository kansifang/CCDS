
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
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
<%
	/*~END~*/
%>


<html>
<head>
<title>��ѡ��ģ���ļ�</title>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	
	//����������	
	String sFileType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FileType")));
	//����������
%>
<%
	//��֤��Ǽǲ��ȱ��ָ��¼����ɱ�֤����Ѻ��ͬ
%>
<%
	/*~END~*/
%>

<script language=javascript>
	function checkItems()
	{
		//������Ϸ���		
		var Input= document.forms("SelectAttachment").getElementsByTagName("input");
		for(var i=0;i<Input.length;i++){
			//���ϴ��ļ������У��
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
					var afobj=document.getElementsByName(Input[i].name.replace("AttachmentFileName","ReportDate"))[0];
					if(afobj.value==""){
						alert("ѡ�������ļ�����£��������ڱ������룡");
						return false;
					}
				}
			}
			//�Ա������ڽ���У��   ReportDate ��һ�������
			if(Input[i].name.indexOf("ReportDate[0]")!==-1){
				if(Input[i].value==""){
					alert("��һ���������ڱ��");
					return false;
				}
			}
			//�Ա������ڽ���У��   ReportDate ��һ�������
			if(Input[i].name.indexOf("ReportDate")!==-1){
				var afobj=document.getElementsByName(Input[i].name.replace("ReportDate","AttachmentFileName"))[0];
				if(Input[i].value!=""&&afobj.value==""){
					alert("����������������£�����ѡ���Ӧ�����ļ��أ�");
					return false;
				}
			}
		}
		try{
			//var fso = new ActiveXObject("Scripting.FileSystemObject");//����������Ǳ���automation ���������ܴ�������ûʲô�ã�ֱ��ע��
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
	var row=0; 
	function addFile(){//ÿ���һ����Ӱ�ť������һ���ϴ��� 
		var utv = document.getElementById("UploadType").value;
		var obj = document.getElementById("upfile");
		//table ����һ��tr
		var r = obj.insertRow(); 
		//�����1��td
	    var c =r.insertCell();
		c.style.backgroundColor="#D8D8AF";
		c.align="right";
		var temp="��������"+(++row)+"��";
		c.innerHTML+=temp;
		//�����2��td
		c=r.insertCell(); 
		c.style.backgroundColor="#F0F1DE";
		var value=document.getElementsByName("ReportDate["+(row-1)+"]")[0].value;//ÿ����һ���У�������һ�е�ֵ��Ϊ��ʼֵ
		var ivalue=parseFloat(value.substr(5))+1;
		value=value.substr(0,5)+(ivalue>12?"12":(ivalue<10?"0"+ivalue:""+ivalue));
		temp=" <input type=text value='"+value+"' name=ReportDate["+(row)+"] size=15 ondblclick=getMonth(this); style='display:"+(utv=="1"?"none":"block")+"'>";
	    c.innerHTML+=temp; 
		//�����һ3��td
		c =r.insertCell();
		c.style.backgroundColor="#D8D8AF";
		c.align="right";
		temp="�����ļ�"+(row)+"��";
		c.innerHTML+=temp;
		//�����4��td
		c=r.insertCell(); 
		c.style.backgroundColor="#F0F1DE";
		temp=" <input type=file name=AttachmentFileName["+(row)+"] size=68>";//���������Ķ���theFile��ͷ 
	    c.innerHTML+=temp; 
		
	} 
	function getMonth(obj){
		var sReturn=PopPage("/Common/ToolsA/SelectMonth.jsp","","dialogWidth=20;dialogHeight=10;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined"){
			obj.value="";
		}else{
			obj.value=sReturn;
		}
	}
	function setReportDateStyle(obj){
		var Input= document.forms("SelectAttachment").getElementsByTagName("input");
		if(obj.value=="1"){
			for(var i=0;i<Input.length;i++){
				if(Input[i].name.indexOf("ReportDate")!==-1&&Input[i].name.indexOf("ReportDate[0]")==-1){
					Input[i].style.display="none";
				}
			}
		}else if(obj.value="2"){
			for(var i=0;i<Input.length;i++){
				if(Input[i].name.indexOf("ReportDate")!==-1&&Input[i].name.indexOf("ReportDate[0]")==-1){
					Input[i].style.display="block";
				}
			}
		}
	}
	function myclick()
	{
		if(checkItems() ){ 
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
<!-- 
����enctype="multipart/form-data"����˼�������� ����MIME���롣
Ĭ���������������ʽ��application/x-www-form-urlencoded�����������ļ��ϴ���
ֻ��ʹ���� multipart/form-data�����������Ĵ����ļ�����
-->
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="FileUpload.jsp?CompClientID=<%=CurComp.ClientID%>" align="center">
<table align="center" width="800" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>
		<td colspan="2" align="center" bgcolor="#D8D8AF"></td>
	</tr>
	<tr>
		<td align="center" bgcolor="#D8D8AF">��������</td>
		<td bgcolor="#F0F1DE">
			<select name="ConfigNo" style="width=400"> 
           	<!--   <option value=''></option>-->   
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%' order by CodeName asc",1,2,"")%>
        	</select>
			</select>
		</td>
	</tr>
	<tr>
		<td align="center" bgcolor="#D8D8AF">�ϴ��ļ���ʽ</td>
		<td bgcolor="#F0F1DE">
			<select id="UploadType" name="UploadType" onchange='setReportDateStyle(this)'> 
			<option value=2>���ڶ��ļ�</option>
			<option value=1>һ�ڶ��ļ�</option>
			</select>
		</td>
	</tr>
	<tr>
	<td colspan="2" align="center">
	<table border="0" align="center" id="upfile">
	<tr>
		<td align="right" class="black9pt" bgcolor="#D8D8AF">�������ڣ�</td>
		<td bgcolor="#F0F1DE">
			<input type=text size=15 value='<%=StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", -1)%>' name="ReportDate[0]" ondblclick="getMonth(this)"> 
		</td>
		<td align="right" class="black9pt" bgcolor="#D8D8AF">�����ļ���</td>
		<td bgcolor="#F0F1DE">
			<input type="file" size=68 name="AttachmentFileName[0]"> 
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
		<input type="hidden" name="ClearTable" value="true">
		<input type="button" name="Confirm" value="ȷ  ��" onClick="javascipt:myclick();"class="btn" border='1'>
		<input type="button" name="Cancel" value="ȡ  ��" onClick="javascript:self.returnValue='_CANCEL_';self.close();" class="btn" border='1'>
		</td>
	</tr>
</table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>