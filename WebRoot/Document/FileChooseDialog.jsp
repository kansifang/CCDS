
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
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
<%
	/*~END~*/
%>


<html>
<head>
<title>请选择模板文件</title>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	
	//获得组件参数	
	String sFileType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FileType")));
	//获得组件参数
%>
<%
	//保证金登记簿等币种更新及生成保证金质押合同
%>
<%
	/*~END~*/
%>

<script language=javascript>
	function checkItems()
	{
		//检查代码合法性		
		var Input= document.forms("SelectAttachment").getElementsByTagName("input");
		for(var i=0;i<Input.length;i++){
			//对上传文件框进行校验
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
					var afobj=document.getElementsByName(Input[i].name.replace("AttachmentFileName","ReportDate"))[0];
					if(afobj.value==""){
						alert("选择数据文件情况下，报表日期必须输入！");
						return false;
					}
				}
			}
			//对报表日期进行校验   ReportDate 第一个框必填
			if(Input[i].name.indexOf("ReportDate[0]")!==-1){
				if(Input[i].value==""){
					alert("第一个报表日期必填！");
					return false;
				}
			}
			//对报表日期进行校验   ReportDate 第一个框必填
			if(Input[i].name.indexOf("ReportDate")!==-1){
				var afobj=document.getElementsByName(Input[i].name.replace("ReportDate","AttachmentFileName"))[0];
				if(Input[i].value!=""&&afobj.value==""){
					alert("报表日期输入情况下，必须选择对应数据文件必！");
					return false;
				}
			}
		}
		try{
			//var fso = new ActiveXObject("Scripting.FileSystemObject");//这个玩意总是报“automation 服务器不能创建对象，没什么用，直接注释
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
	var row=0; 
	function addFile(){//每点击一下添加按钮就生成一个上传条 
		var utv = document.getElementById("UploadType").value;
		var obj = document.getElementById("upfile");
		//table 插入一行tr
		var r = obj.insertRow(); 
		//插入第1个td
	    var c =r.insertCell();
		c.style.backgroundColor="#D8D8AF";
		c.align="right";
		var temp="报表日期"+(++row)+"：";
		c.innerHTML+=temp;
		//插入第2个td
		c=r.insertCell(); 
		c.style.backgroundColor="#F0F1DE";
		var value=document.getElementsByName("ReportDate["+(row-1)+"]")[0].value;//每增加一个行，赋上上一行的值作为初始值
		var ivalue=parseFloat(value.substr(5))+1;
		value=value.substr(0,5)+(ivalue>12?"12":(ivalue<10?"0"+ivalue:""+ivalue));
		temp=" <input type=text value='"+value+"' name=ReportDate["+(row)+"] size=15 ondblclick=getMonth(this); style='display:"+(utv=="1"?"none":"block")+"'>";
	    c.innerHTML+=temp; 
		//插入第一3个td
		c =r.insertCell();
		c.style.backgroundColor="#D8D8AF";
		c.align="right";
		temp="数据文件"+(row)+"：";
		c.innerHTML+=temp;
		//插入第4个td
		c=r.insertCell(); 
		c.style.backgroundColor="#F0F1DE";
		temp=" <input type=file name=AttachmentFileName["+(row)+"] size=68>";//这里命名的都是theFile开头 
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
<!-- 
表单中enctype="multipart/form-data"的意思，是设置 表单的MIME编码。
默认情况，这个编码格式是application/x-www-form-urlencoded，不能用于文件上传；
只有使用了 multipart/form-data，才能完整的传递文件数据
-->
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="FileUpload.jsp?CompClientID=<%=CurComp.ClientID%>" align="center">
<table align="center" width="800" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>
		<td colspan="2" align="center" bgcolor="#D8D8AF"></td>
	</tr>
	<tr>
		<td align="center" bgcolor="#D8D8AF">报表类型</td>
		<td bgcolor="#F0F1DE">
			<select name="ConfigNo" style="width=400"> 
           	<!--   <option value=''></option>-->   
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%' order by CodeName asc",1,2,"")%>
        	</select>
			</select>
		</td>
	</tr>
	<tr>
		<td align="center" bgcolor="#D8D8AF">上传文件方式</td>
		<td bgcolor="#F0F1DE">
			<select id="UploadType" name="UploadType" onchange='setReportDateStyle(this)'> 
			<option value=2>多期多文件</option>
			<option value=1>一期多文件</option>
			</select>
		</td>
	</tr>
	<tr>
	<td colspan="2" align="center">
	<table border="0" align="center" id="upfile">
	<tr>
		<td align="right" class="black9pt" bgcolor="#D8D8AF">报表日期：</td>
		<td bgcolor="#F0F1DE">
			<input type=text size=15 value='<%=StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", -1)%>' name="ReportDate[0]" ondblclick="getMonth(this)"> 
		</td>
		<td align="right" class="black9pt" bgcolor="#D8D8AF">数据文件：</td>
		<td bgcolor="#F0F1DE">
			<input type="file" size=68 name="AttachmentFileName[0]"> 
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
		<input type="hidden" name="ClearTable" value="true">
		<input type="button" name="Confirm" value="确  认" onClick="javascipt:myclick();"class="btn" border='1'>
		<input type="button" name="Cancel" value="取  消" onClick="javascript:self.returnValue='_CANCEL_';self.close();" class="btn" border='1'>
		</td>
	</tr>
</table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>