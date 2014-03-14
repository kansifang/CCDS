<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: jytian 2004-12-04 
			Tester:
			Describe: 国家标准行业选择
			Input Param:
		无
			Output Param:
		ItemNo：条目编号
		ItemName：条目名称

			HistoryLog:
		
		 */
	%>
<%
	/*~END~*/
%>

<html>
<head>
<title>请选择行业类型 </title>
</head>

<script language=javascript>

<%String sIndustryTypeValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IndustryTypeValue"));
	String sIndustryType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IndustryType"));
	String sOpen = "";
	String sDefaultItem = "";
	//增加判断，防止出现 null错误 add by jbye 2009/03/30
	if(sIndustryType.length()>3) sDefaultItem = sIndustryType.substring(0,3);
	if(sIndustryType!=null&&sIndustryType.length()>3) sOpen = "YES";%>

	//获取用户选择的行业种类
	function TreeViewOnClick(){

		var sIndustryType=getCurTVItem().id;
		var sIndustryTypeName=getCurTVItem().name;
		var sType = getCurTVItem().type;
		buff.IndustryType.value=sIndustryType+"@"+sIndustryTypeName;
		<%//选择国标行业大类时可以自动触发右边节目
		if(sIndustryTypeValue == null)
		{%>
		newBusiness();
		<%}%>
	}
	
	function TreeViewOnDBClick()
	{
		newBusiness();
	}

	//新选一个行业种类
	function newBusiness(){
<%//选择国标行业大类时可以自动触发右边节目
	if(sIndustryTypeValue == null)
	{%>
		if(buff.IndustryType.value!=""){
			sReturnValue = buff.IndustryType.value;
			parent.OpenPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue="+getCurTVItem().id,"frameright","");
		}
		else{
			alert(getBusinessMessage('247'));//请选择行业种类细项！
		}
<%}
	else
	{%>
		var s,sValue,sName;
		var sReturnValue = "";
		s=buff.IndustryType.value;
		s = s.split('@');
		sValue = s[0];
		sName = s[1];
               
		if((sValue=="C371")||(sValue=="C372")||(sValue=="C375")||(sValue=="C376")||(sValue=="F553")||(sValue=="L741"))
		{
			alert(getBusinessMessage('248'));//您选择的行业需要细分到小类！
		}else{
			if(buff.IndustryType.value.length<3){
				alert(getBusinessMessage('247'));//请选择行业种类细项！
			}else{
				if(sValue.length==5){
					parent.returnValue = buff.IndustryType.value;
					parent.close();
				}
				else{
					alert(getBusinessMessage('247'));//请选择行业种类细项！
				}
			}
		}

<%}%>
	}
	//返回
	function goBack()
	{
		self.close();
	}

	//将查询出的行业类型按照TreeView展示
	function startMenu()
	{
	<%HTMLTreeView tviTemp = new HTMLTreeView("行业类型列表","right");
		tviTemp.TriggerClickEvent=true;
		//选择行业类型一
		if(sIndustryTypeValue == null)
			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","","from Code_Library where CodeNO='IndustryType' and length(ItemNo) <= 3",Sqlca);
		else
			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","","from Code_Library where CodeNO='IndustryType' and ItemNo like '"+sIndustryTypeValue+"%'",Sqlca);
		
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		out.println(tviTemp.generateHTMLTreeView());%>

	}


</script>

<body bgcolor="#DCDCDC">
<center>
<form  name="buff">
<input type="hidden" name="IndustryType" value="">
<table width="90%" align=center border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
        <td id="myleft"  colspan='3' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>



<tr height=4%>
<%
	if(sIndustryTypeValue == null){
%>
<span class="STYLE9"></span>
<p align="left" class="black9pt">行业类型大类</p>
<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" >
</td>
<%
	}else{
%>
<span class="STYLE9"></span>
<p align="left" class="black9pt">行业类型子类</p>
<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("确定","确定","javascript:newBusiness()",sResourcesPath)%>
</td>
<td nowrap bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("取消","取消","javascript:goBack()",sResourcesPath)%>
</td>
<%
	};
%>

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
	selectItem('<%=sIndustryType%>');//自动点击树图，目前写死，也可以设置到 code_library中进行设定
	expandNode('<%=sIndustryTypeValue%>');
</script>

<%@ include file="/IncludeEnd.jsp"%>
