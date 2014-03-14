<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: zytan 2011-03-22 
			Tester:
			Describe: 国家标准行业选择(支持选择大类)
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

<%String sIndustryTypeValue = DataConvert.toRealString(iPostChange,(String)request.getParameter("IndustryTypeValue"));%>

	//获取用户选择的行业种类
	function TreeViewOnClick(){

		var sIndustryType=getCurTVItem().id;
		var sIndustryTypeName=getCurTVItem().name;
		var sType = getCurTVItem().type;
<%if(sIndustryTypeValue == null) 
	{%>
		if(sType == "page"){
			buff.IndustryType.value=sIndustryType+"@"+sIndustryTypeName;
		}
		else{
			buff.IndustryType.value="";
		}
<%}
	else
	{%>
		buff.IndustryType.value=sIndustryType+"@"+sIndustryTypeName;
<%}%>
	}

	function TreeViewOnDBClick()
	{
		newBusiness();
	}

	//新选一个行业种类
	function newBusiness(){
<%if(sIndustryTypeValue == null)
	{%>
		if(buff.IndustryType.value!=""){
			self.returnValue=buff.IndustryType.value;
			self.close();
		}
		else{
			alert(getBusinessMessage('247'));//请选择行业种类细项！
		}
<%}
	else
	{%>
		var s,sValue,sName;
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
					self.returnValue=buff.IndustryType.value;
					self.close();
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
			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","","from Code_Library where CodeNO='IndustryType' and length(ItemNo) <= 3 and Isinuse = '1' ",Sqlca);
		else
			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","","from Code_Library where CodeNO='IndustryType' and ItemNo like '"+sIndustryTypeValue+"%' and Isinuse = '1' ",Sqlca);
		
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		out.println(tviTemp.generateHTMLTreeView());%>

	}


	//新选一个行业种类
	function newBusiness1(){
		var id = getCurTVItem().id;
		var name = getCurTVItem().name
		
		if(typeof(id) != "undefined" && id != "" && id != "root"){
			self.returnValue=id+"@"+name+"@OK";
			self.close();
		}else{
			alert("请选择行业分类！");//请选择行业种类细项！
		}
	}

</script>

<body bgcolor="#DEDFCE">
<center>
<form  name="buff">
<input type="hidden" name="IndustryType" value="">
<table width="90%" align=center border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
        <td id="myleft"  colspan='3' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>



<tr height=4%>
<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("确定","确定","javascript:newBusiness1()",sResourcesPath)%>
</td>
<%
	if(sIndustryTypeValue == null)
{
%>
<td nowrap align="center" class="black9pt" bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("下一步","下一步","javascript:newBusiness()",sResourcesPath)%>
</td>
<%
	}
%>
<td nowrap bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("取消","取消","javascript:goBack()",sResourcesPath)%>
</td>
</tr>

</table>
</form>
</center>
</body>
</html>

<script language="JavaScript">
	startMenu();
	expandNode('root');
</script>

<%@ include file="/IncludeEnd.jsp"%>
