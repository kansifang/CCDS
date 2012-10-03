<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
	/*
	Author:   gxlin 2010/06/13
	Tester: 
  	Content: 选择附件框 
  	Input Param:
  	Output param:
  	History Log:
			
	*/
	%>
<%/*~END~*/%>


<html>
<head>
<title>请选择模板文件</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	
	//获得组件参数	

	String sItemID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID")));
	String sFileType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FileType")));
	//获得组件参数	
%>
<%//保证金登记簿等币种更新及生成保证金质押合同
%>
<%/*~END~*/%>

<script language=javascript>
	function checkItems()
	{
		//检查代码合法性		
		var isSelected=false;
		var Input= document.forms("SelectAttachment").getElementsByTagName("input");
		for(var i=0;i<Input.length;i++){
			if(Input[i].name.indexOf("AttachmentFileName")!==-1){
				var sFileName=Input[i].value;
				if(sFileName!=""){
					if("<%=sFileType%>"=="Text"){
						if((-1==sFileName.toUpperCase().indexOf(".TXT")) && (-1==sFileName.toUpperCase().indexOf(".SQL")))
						{
							alert("只允许上传文本文件！");
							return false;
						}
					}else if("<%=sFileType%>"=="Excel"){
						if((-1==sFileName.toUpperCase().indexOf(".XLS")))
						{
							alert("只允许上传Excel文件！");
							return false;
						}
					}	
					isSelected=true
				}
			}
		}
		if(!isSelected){
			alert("请至少选择一个'数据文件'!");
			return false;
		}
		if("<%=sItemID%>"=="2"){//入库初始化
			if(confirm("是否清空押品入库临时表？")){
				document.forms("SelectAttachment").ClearTable.value="true";
			}else{
				document.forms("SelectAttachment").ClearTable.value="false";
			}
		}else if("<%=sItemID%>"=="3"){//票据更新批次号及生成业务保证金信息
			if(confirm("是否清空业务号批次信息对照临时表？")){
				document.forms("SelectAttachment").ClearTable.value="true";
			}else{
				document.forms("SelectAttachment").ClearTable.value="false";
			}
		}else if("<%=sItemID%>"=="4"){//保证金初始化
			if(confirm("是否清空保证金信息表临时表？")){
				document.forms("SelectAttachment").ClearTable.value="true";
			}else{
				document.forms("SelectAttachment").ClearTable.value="false";
			}
		}else if("<%=sItemID%>"=="5"){//额度初始化
			if(confirm("是否清空放款信息表临时表？")){
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
	//		alert("文件大于2048k，不能上传！");//文件大于2048k，不能上传！
	//		return false;
	//	}
		return true;
	}	  
	var row=1; 
	function addFile(){//每点击一下添加按钮就生成一个上传条 
		var obj = document.getElementById("upfile"); 
		var r = obj.insertRow(); 
		var c =r.insertCell();
		c.style.backgroundColor="#D8D8AF";
		c.align="right";
		var temp="数据文件"+(row+1)+"：";
		c.innerHTML+=temp;
		c=r.insertCell(); 
		c.style.backgroundColor="#F0F1DE";
		temp=" <input type=file name=AttachmentFileName["+(row++)+"] size=30>";//这里命名的都是theFile开头 
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
			ShowMessage('正在进行初始化,请耐心等待.......',true,false);
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
		<td align="right" class="black9pt" bgcolor="#D8D8AF" width="70">数据文件1：</td>
		<td bgcolor="#F0F1DE">
			<input type="file" size=30 name="AttachmentFileName[0]"> 
		</td>
	</tr>
	</table>
	</td>
	</tr>
	<!-- 可以动态添加多个附件上传 -->
	<tr>
		<td colspan="2"><input type="button" name="addAttachment" value="添加多个文件 " onclick="addFile()"></td>
	</tr>
	<tr>
		<td align="right" class="black9pt" bgcolor="#D8D8AF" height="25">&nbsp;</td>
		<td bgcolor="#F0F1DE" height="25" align="center">
		<input type="hidden" name="ItemID" value="<%=sItemID%>">
		<input type="hidden" name="ClearTable" value="">
		<input type="button" name="Confirm" value="确  认" onClick="javascipt:myclick();"class="btn" border='1'>
		<input type="button" name="Cancel" value="取  消" onClick="javascript:self.returnValue='_CANCEL_';self.close();"
			class="btn" border='1'></td>
	</tr>
</table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>