
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
	String sConfigNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ConfigNo")));
	//����������
%>
<%
	//��֤��Ǽǲ��ȱ��ָ��¼����ɱ�֤����Ѻ��ͬ
%>
<%
	/*~END~*/
%>

<script language=javascript>
	function getMonth(obj){
		var sReturn=PopPage("/Common/ToolsA/SelectMonth.jsp","","dialogWidth=420px;dialogHeight=160px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined"){
			obj.value="";
		}else{
			obj.value=sReturn;
		}
	}
	function getDate(obj){
		var sReturn=PopPage("/Common/ToolsA/SelectDate.jsp","","dialogWidth:20;dialogheight:15;resizable:yes;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
	function checkItems()
	{
		//������Ϸ���	
		//���ϴ��ļ������У��
		//var Input= document.forms("SelectAttachment").getElementsByTagName("input");
		var sReturn=true;
		$(":input").each(function(index){
			if($(this).attr("name").indexOf("AttachmentFileName")!==-1){
				if($(this).attr("value")!=""){
					if("<%=sFileType%>"=="Text"){
						if((-1==$(this).attr("value").toUpperCase().indexOf(".TXT"))&&($(this).attr("value").toUpperCase().indexOf(".SQL")==-1))
						{
							alert("ֻ�����ϴ��ı��ļ���");
							sReturn=false;
						}
					}else if("<%=sFileType%>"=="Excel"){
						if(($(this).attr("value").toUpperCase().indexOf(".XLS")==-1))
						{
							alert("ֻ�����ϴ�Excel�ļ���");
							sReturn=false;
						}
					}
					if($(this).prev(":input").attr("value")==""){
						alert("ѡ�������ļ�����£��������ڱ������룡");
						sReturn=false;
					}
				}
			}
			//�Ա������ڽ���У��   ReportDate ��һ�������
			if($(this).attr("name").indexOf("ReportDate[0]")!==-1){
				if($(this).attr("value")==""){
					alert("��һ���������ڱ��");
					sReturn=false;
				}
			}
			//�Ա������ڽ���У��   ReportDate ��һ�������
			if($(this).attr("name").indexOf("ReportDate")!==-1){
				if($(this).attr("value")!=""&&$(':input:eq('+(index+1)+')').attr("value")==""){
					alert("����������������£�����ѡ���Ӧ�����ļ���");
					sReturn=false;
				}
			}
		});
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
		return sReturn;
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
			document.getElementById("groups").value=groups;
			self.SelectAttachment.submit();
			ShowMessage("���ڽ����ĵ��ϴ������ݴ���,�����ĵȴ�.......",true,false);
			//try{hideMessage();}catch(e) {};
		}
	}
	function addFile(groups){//ÿ���һ����Ӱ�ť������һ���ϴ��� 
		var row=document.getElementById("rows"+groups).value;
		var utv = document.getElementById("UploadType"+groups).value;
		var obj = document.getElementById("upfiletable"+groups);
		//table ����һ��tr
		var r = obj.insertRow(); 
		//�����1��td
	    var c =r.insertCell();
		c.style.backgroundColor="#D8D8AF";
		c.align="right";
		var temp="��������"+groups+(++row)+"��";
		c.innerHTML+=temp;
		//�����2��td
		c=r.insertCell(); 
		c.style.backgroundColor="#F0F1DE";
		var value=document.getElementsByName("ReportDate"+groups+"["+(row-1)+"]")[0].value;//ÿ����һ���У�������һ�е�ֵ��Ϊ��ʼֵ
		var ivalue=parseFloat(value.substr(5))+1;
		value=value.substr(0,5)+(ivalue>12?"12":(ivalue<10?"0"+ivalue:""+ivalue));
		temp=" <input type=text value='"+value+"' name=ReportDate"+groups+"["+(row)+"] size=15 oncontextmenu='getDate(this);return false;' ondblclick=getMonth(this); style='display:"+(utv=="1"?"none":"block")+"'>";
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
		temp=" <input type=file name=AttachmentFileName"+groups+"["+(row)+"] size=68>";//���������Ķ���theFile��ͷ 
	    c.innerHTML+=temp; 
	    document.getElementById("rows"+groups).value=row;
	} 
	var groups=0;
	function addGroupFile(){
		//�ֹ�����һ���������� ��
		var sHTML="<table border='0' align='center' id='upfiletable"+(++groups)+"'>";
			sHTML+="<input type='hidden' id='rows"+(groups)+"' name='rows"+(groups)+"' value='0'>";
			sHTML+="<tr>";
				sHTML+="<td colspan='4' class='black9pt' bgcolor='#D8D8AF'>";
					sHTML+="<input type='button' name='addAttachment' value='��Ӷ���ļ� ' onclick='addFile("+(groups)+")'>";
				sHTML+="</td>";
			sHTML+="</tr>";
			sHTML+="<tr>";
				sHTML+="<td class='black9pt' bgcolor='#D8D8AF'>��������";
				sHTML+="</td>";
				sHTML+="<td bgcolor='#F0F1DE'>";
					sHTML+="<select name='ConfigNo"+(groups)+"' style='width:150'>"; 
					sHTML+="<%=HTMLControls.generateDropDownSelect(Sqlca,"select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%' and CodeName<>'������' order by InputTime asc",1,2,"")%>";
					sHTML+="</select>";
				sHTML+="</td>";
				sHTML+="<td class='black9pt' bgcolor='#D8D8AF'>�ϴ��ļ���ʽ";
				sHTML+="</td>";
				sHTML+="<td bgcolor='#F0F1DE'>";
					sHTML+="<select id='UploadType"+(groups)+"' name='UploadType"+(groups)+"' onchange='setReportDateStyle(this)'>"; 
					sHTML+="<option value=2>���ڶ��ļ�";
					sHTML+="</option>";
					sHTML+="<option value=1>һ�ڶ��ļ�";
					sHTML+="</option>";
					sHTML+="</select>";
				sHTML+="</td>";
			sHTML+="</tr>";
			sHTML+="<tr>";
				sHTML+="<td class='black9pt' bgcolor='#D8D8AF'>��������";
				sHTML+="</td>";
				sHTML+="<td bgcolor='#F0F1DE'>";
					sHTML+="<input type=text size=15 value=<%=StringFunction.getRelativeAccountMonth(StringFunction.getToday(),"month", -1)%>  name='ReportDate"+(groups)+"[0]' oncontextmenu='getDate(this);return false;' ondblclick='getMonth(this)'>";
				sHTML+="</td>";
				sHTML+="<td class='black9pt' bgcolor='#D8D8AF'>�����ļ�";
				sHTML+="</td>";
				sHTML+="<td bgcolor='#F0F1DE'>";
					sHTML+="<input type='file' size=68 name='AttachmentFileName"+(groups)+"[0]' value=''/>"; 
				sHTML+="</td>";
			sHTML+="</tr>";
		sHTML+="</table>";
		var obj=document.getElementById("table11");
		//table ����һ��tr
		var r = obj.insertRow(); 
		//�����1��td
	    var c =r.insertCell();
		c.style.backgroundColor="#D8D8AF";
		c.align="center";
		c.innerHTML+=sHTML;
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
<table id="table11" align="center" width="800" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>
		<td align="center" bgcolor="#D8D8AF"></td>
	</tr>
	<input type="hidden" name="groups" value="0"><!-- ������̨�����ж��ж����飬��ƴ�� -->
	<!-- ���Զ�̬��Ӷ��鸽���ϴ� -->
	<tr>
		<td colspan="4" class="black9pt" bgcolor="#D8D8AF">
			<input type="button" name="addAttachmentType" value="��Ӷ����ļ� " onclick="addGroupFile()">
		</td>
	</tr>
	<tr><!-- һ���������� -->
		<td align="center"  bgcolor="#D8D8AF">
			<table border="0" align="center" id="upfiletable0">
				<input type="hidden" id="rows0" name="rows0" value="0">
				<!-- ���Զ�̬��Ӷ�������ϴ� -->
				<tr>
					<td colspan="4" class="black9pt" bgcolor="#D8D8AF">
						<input type="button" name="addAttachment" value="��Ӷ���ļ� " onclick="addFile(0)">
					</td>
				</tr>
				<tr>
					<td class="black9pt" bgcolor="#D8D8AF">��������</td>
					<td bgcolor="#F0F1DE">
						<%if(sConfigNo.length()>0){
						%>
							<input name="ConfigNo0" style="width:150" value="<%=sConfigNo%>" readonly>
						<% 
						}else{
						%>
							<select name="ConfigNo0" style="width:150"> 
							<%=HTMLControls.generateDropDownSelect(Sqlca,"select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%' and CodeName<>'������' order by InputTime asc",1,2,"")%>
			        		</select>
						<%
						}
						%>
					</td>
					<td class="black9pt" bgcolor="#D8D8AF">�ϴ��ļ���ʽ</td>
					<td bgcolor="#F0F1DE">
						<select id="UploadType0" name="UploadType0" onchange='setReportDateStyle(this)'> 
						<option value=2>���ڶ��ļ�</option>
						<option value=1>һ�ڶ��ļ�</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="black9pt" bgcolor="#D8D8AF">��������</td>
					<td bgcolor="#F0F1DE">
						<input type=text size=15 value="<%=StringFunction.getRelativeAccountMonth(StringFunction.getToday(),"month", -1)%>" name="ReportDate0[0]" oncontextmenu="getDate(this);return false;" ondblclick="getMonth(this)"> 
					</td>
					<td class="black9pt" bgcolor="#D8D8AF">�����ļ�</td>
					<td bgcolor="#F0F1DE">
						<input type="file" size=68 name="AttachmentFileName0[0]" value=""/> 
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
</table>
	<div style="position:absolute;left:expression((body.clientWidth-50)/2);visibility:visible">
			<input type="hidden" name="ClearTable" value="true">
			<input type="button" name="Confirm" value="ȷ  ��" onClick="javascipt:myclick();" class="btn" border='1'>
			<input type="button" name="Cancel" value="ȡ  ��" onClick="javascript:window.top.returnValue='_CANCEL_';window.top.close();" class="btn" border='1'>
	</div>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>