<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zrli
		Tester:
		Describe: 县乡村选择
		Input Param:
			无
		Output Param:
			ItemNo：条目编号
			ItemName：条目名称

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>请选择行业类型 </title>
</head>

<script language=javascript>

<%
	String sVillageValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("VillageValue"));
	String sVillage = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Village"));
	String sOpen = "";
	String sDefaultItem = "";
	//增加判断，防止出现 null错误 add by jbye 2009/03/30
	if(sVillage.length()>3) sDefaultItem = sVillage.substring(0,6);
	if(sVillage!=null&&sVillage.length()>6) sOpen = "YES";
%>

	//获取用户选择的行业种类
	function TreeViewOnClick(){

		var sVillage=getCurTVItem().id;
		var sVillageName=getCurTVItem().name;
		var sType = getCurTVItem().type;
		buff.Village.value=sVillage+"@"+sVillageName;
		<%
		//选择国标行业大类时可以自动触发右边节目
		if(sVillageValue == null)
		{
		%>
		newBusiness();
		<%
		}
		%>
	}
	
	function TreeViewOnDBClick()
	{
		newBusiness();
	}

	//新选一个行业种类
	function newBusiness(){
<%
	//选择国标行业大类时可以自动触发右边节目
	if(sVillageValue == null)
	{
%>
		if(buff.Village.value!=""){
			sReturnValue = buff.Village.value;
			parent.OpenPage("/Common/ToolsA/VillageSelect.jsp?VillageValue="+getCurTVItem().id,"frameright","");
		}
		else{
			alert(getBusinessMessage('247'));//请选择行业种类细项！
		}
<%	}
	else
	{	
%>
		var s,sValue,sName;
		var sReturnValue = "";
		s=buff.Village.value;
		s = s.split('@');
		sValue = s[0];
		sName = s[1];      
		if(buff.Village.value.length<3){
			alert(getBusinessMessage('247'));//请选择行业种类细项！
		}else{
			parent.returnValue = buff.Village.value;
			parent.close();
		}
<%
	}
%>
	}
	//返回
	function goBack()
	{
		self.close();
	}

	//将查询出的行业类型按照TreeView展示
	function startMenu()
	{
	<%

		HTMLTreeView tviTemp = new HTMLTreeView("县乡村列表","right");
		tviTemp.TriggerClickEvent=true;
		//选择行业类型一
		if(sVillageValue == null)
			tviTemp.initWithSql("SerialNo","RegionalismName","SerialNo","","from Village_Info where isinuse='1' and (length(SerialNo) between 6 and 8) ",Sqlca);
		else
			tviTemp.initWithSql("SerialNo","RegionalismName","SerialNo","","from Village_Info where SerialNo like '"+sVillageValue+"%'",Sqlca);
		
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		out.println(tviTemp.generateHTMLTreeView());

	%>

	}


</script>

<body bgcolor="#DCDCDC">
<center>
<form  name="buff">
<input type="hidden" name="Village" value="">
<table width="90%" align=center border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
        <td id="myleft"  colspan='3' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>



<tr height=4%>
<%
	if(sVillageValue == null){
%>
<span class="STYLE9"></span>
<p align="left" class="black9pt">县乡选择</p>
<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" >
</td>
<%
	}else{
%>
<span class="STYLE9"></span>
<p align="left" class="black9pt">村选择</p>
<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("确定","确定","javascript:newBusiness()",sResourcesPath)%>
</td>
<td nowrap bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("取消","取消","javascript:goBack()",sResourcesPath)%>
</td>
<%};%>

</tr>

</table>
</form>
</center>
</body>
</html>

<script language="JavaScript">
	startMenu();
	expandNode('root');
	selectItem('<%=sDefaultItem%>');//自动点击树图，目前写死，也可以设置到 code_library中进行设定
	selectItem('<%=sVillage%>');//自动点击树图，目前写死，也可以设置到 code_library中进行设定
	expandNode('<%=sVillageValue%>');
</script>

<%@ include file="/IncludeEnd.jsp"%>
