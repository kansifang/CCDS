
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
	String sConfigNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ConfigNo")));
	//获得组件参数
%>
<%
	//保证金登记簿等币种更新及生成保证金质押合同
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
		//检查代码合法性	
		//对上传文件框进行校验
		//var Input= document.forms("SelectAttachment").getElementsByTagName("input");
		var sReturn=true;
		$(":input").each(function(index){
			if($(this).attr("name").indexOf("AttachmentFileName")!==-1){
				if($(this).attr("value")!=""){
					if("<%=sFileType%>"=="Text"){
						if((-1==$(this).attr("value").toUpperCase().indexOf(".TXT"))&&($(this).attr("value").toUpperCase().indexOf(".SQL")==-1))
						{
							alert("只允许上传文本文件！");
							sReturn=false;
						}
					}else if("<%=sFileType%>"=="Excel"){
						if(($(this).attr("value").toUpperCase().indexOf(".XLS")==-1))
						{
							alert("只允许上传Excel文件！");
							sReturn=false;
						}
					}
					if($(this).prev(":input").attr("value")==""){
						alert("选择数据文件情况下，报表日期必须输入！");
						sReturn=false;
					}
				}
			}
			//对报表日期进行校验   ReportDate 第一个框必填
			if($(this).attr("name").indexOf("ReportDate[0]")!==-1){
				if($(this).attr("value")==""){
					alert("第一个报表日期必填！");
					sReturn=false;
				}
			}
			//对报表日期进行校验   ReportDate 第一个框必填
			if($(this).attr("name").indexOf("ReportDate")!==-1){
				if($(this).attr("value")!=""&&$(':input:eq('+(index+1)+')').attr("value")==""){
					alert("报表日期输入情况下，必须选择对应数据文件！");
					sReturn=false;
				}
			}
		});
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
			ShowMessage("正在进行文档上传和数据处理,请耐心等待.......",true,false);
			//try{hideMessage();}catch(e) {};
		}
	}
	function addFile(groups){//每点击一下添加按钮就生成一个上传条 
		var row=document.getElementById("rows"+groups).value;
		var utv = document.getElementById("UploadType"+groups).value;
		var obj = document.getElementById("upfiletable"+groups);
		//table 插入一行tr
		var r = obj.insertRow(); 
		//插入第1个td
	    var c =r.insertCell();
		c.style.backgroundColor="#D8D8AF";
		c.align="right";
		var temp="报表日期"+groups+(++row)+"：";
		c.innerHTML+=temp;
		//插入第2个td
		c=r.insertCell(); 
		c.style.backgroundColor="#F0F1DE";
		var value=document.getElementsByName("ReportDate"+groups+"["+(row-1)+"]")[0].value;//每增加一个行，赋上上一行的值作为初始值
		var ivalue=parseFloat(value.substr(5))+1;
		value=value.substr(0,5)+(ivalue>12?"12":(ivalue<10?"0"+ivalue:""+ivalue));
		temp=" <input type=text value='"+value+"' name=ReportDate"+groups+"["+(row)+"] size=15 oncontextmenu='getDate(this);return false;' ondblclick=getMonth(this); style='display:"+(utv=="1"?"none":"block")+"'>";
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
		temp=" <input type=file name=AttachmentFileName"+groups+"["+(row)+"] size=68>";//这里命名的都是theFile开头 
	    c.innerHTML+=temp; 
	    document.getElementById("rows"+groups).value=row;
	} 
	var groups=0;
	function addGroupFile(){
		//手工增加一个报表类型 组
		var sHTML="<table border='0' align='center' id='upfiletable"+(++groups)+"'>";
			sHTML+="<input type='hidden' id='rows"+(groups)+"' name='rows"+(groups)+"' value='0'>";
			sHTML+="<tr>";
				sHTML+="<td colspan='4' class='black9pt' bgcolor='#D8D8AF'>";
					sHTML+="<input type='button' name='addAttachment' value='添加多个文件 ' onclick='addFile("+(groups)+")'>";
				sHTML+="</td>";
			sHTML+="</tr>";
			sHTML+="<tr>";
				sHTML+="<td class='black9pt' bgcolor='#D8D8AF'>报表类型";
				sHTML+="</td>";
				sHTML+="<td bgcolor='#F0F1DE'>";
					sHTML+="<select name='ConfigNo"+(groups)+"' style='width:150'>"; 
					sHTML+="<%=HTMLControls.generateDropDownSelect(Sqlca,"select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%' and CodeName<>'表配置' order by InputTime asc",1,2,"")%>";
					sHTML+="</select>";
				sHTML+="</td>";
				sHTML+="<td class='black9pt' bgcolor='#D8D8AF'>上传文件方式";
				sHTML+="</td>";
				sHTML+="<td bgcolor='#F0F1DE'>";
					sHTML+="<select id='UploadType"+(groups)+"' name='UploadType"+(groups)+"' onchange='setReportDateStyle(this)'>"; 
					sHTML+="<option value=2>多期多文件";
					sHTML+="</option>";
					sHTML+="<option value=1>一期多文件";
					sHTML+="</option>";
					sHTML+="</select>";
				sHTML+="</td>";
			sHTML+="</tr>";
			sHTML+="<tr>";
				sHTML+="<td class='black9pt' bgcolor='#D8D8AF'>报表日期";
				sHTML+="</td>";
				sHTML+="<td bgcolor='#F0F1DE'>";
					sHTML+="<input type=text size=15 value=<%=StringFunction.getRelativeAccountMonth(StringFunction.getToday(),"month", -1)%>  name='ReportDate"+(groups)+"[0]' oncontextmenu='getDate(this);return false;' ondblclick='getMonth(this)'>";
				sHTML+="</td>";
				sHTML+="<td class='black9pt' bgcolor='#D8D8AF'>数据文件";
				sHTML+="</td>";
				sHTML+="<td bgcolor='#F0F1DE'>";
					sHTML+="<input type='file' size=68 name='AttachmentFileName"+(groups)+"[0]' value=''/>"; 
				sHTML+="</td>";
			sHTML+="</tr>";
		sHTML+="</table>";
		var obj=document.getElementById("table11");
		//table 插入一行tr
		var r = obj.insertRow(); 
		//插入第1个td
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
表单中enctype="multipart/form-data"的意思，是设置 表单的MIME编码。
默认情况，这个编码格式是application/x-www-form-urlencoded，不能用于文件上传；
只有使用了 multipart/form-data，才能完整的传递文件数据
-->
<form name="SelectAttachment" method="post" ENCTYPE="multipart/form-data" action="FileUpload.jsp?CompClientID=<%=CurComp.ClientID%>" align="center">
<table id="table11" align="center" width="800" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>
		<td align="center" bgcolor="#D8D8AF"></td>
	</tr>
	<input type="hidden" name="groups" value="0"><!-- 传给后台，来判断有多少组，好拼接 -->
	<!-- 可以动态添加多组附件上传 -->
	<tr>
		<td colspan="4" class="black9pt" bgcolor="#D8D8AF">
			<input type="button" name="addAttachmentType" value="添加多组文件 " onclick="addGroupFile()">
		</td>
	</tr>
	<tr><!-- 一个报表类型 -->
		<td align="center"  bgcolor="#D8D8AF">
			<table border="0" align="center" id="upfiletable0">
				<input type="hidden" id="rows0" name="rows0" value="0">
				<!-- 可以动态添加多个附件上传 -->
				<tr>
					<td colspan="4" class="black9pt" bgcolor="#D8D8AF">
						<input type="button" name="addAttachment" value="添加多个文件 " onclick="addFile(0)">
					</td>
				</tr>
				<tr>
					<td class="black9pt" bgcolor="#D8D8AF">报表类型</td>
					<td bgcolor="#F0F1DE">
						<%if(sConfigNo.length()>0){
						%>
							<input name="ConfigNo0" style="width:150" value="<%=sConfigNo%>" readonly>
						<% 
						}else{
						%>
							<select name="ConfigNo0" style="width:150"> 
							<%=HTMLControls.generateDropDownSelect(Sqlca,"select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%' and CodeName<>'表配置' order by InputTime asc",1,2,"")%>
			        		</select>
						<%
						}
						%>
					</td>
					<td class="black9pt" bgcolor="#D8D8AF">上传文件方式</td>
					<td bgcolor="#F0F1DE">
						<select id="UploadType0" name="UploadType0" onchange='setReportDateStyle(this)'> 
						<option value=2>多期多文件</option>
						<option value=1>一期多文件</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="black9pt" bgcolor="#D8D8AF">报表日期</td>
					<td bgcolor="#F0F1DE">
						<input type=text size=15 value="<%=StringFunction.getRelativeAccountMonth(StringFunction.getToday(),"month", -1)%>" name="ReportDate0[0]" oncontextmenu="getDate(this);return false;" ondblclick="getMonth(this)"> 
					</td>
					<td class="black9pt" bgcolor="#D8D8AF">数据文件</td>
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
			<input type="button" name="Confirm" value="确  认" onClick="javascipt:myclick();" class="btn" border='1'>
			<input type="button" name="Cancel" value="取  消" onClick="javascript:window.top.returnValue='_CANCEL_';window.top.close();" class="btn" border='1'>
	</div>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>