<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
		
	ASResultSet rs=null;
	String sSql = "";
	String sSelBrowseMode = "";
	String sAttribute4 = "";
	String sTips = "";
		
	sSql = " select SelBrowseMode,Attribute4 from SELECT_CATALOG where SelName = '"+sSelName+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sSelBrowseMode = rs.getString("SelBrowseMode");	
		sAttribute4 = rs.getString("Attribute4");
		if(sSelBrowseMode == null) sSelBrowseMode = "";
		if(sAttribute4 == null) sAttribute4 = "";
	}
	rs.getStatement().close();
%>
<html>
<head> 
<!-- 为了页面美观,请不要删除下面 TITLE 中的空格 -->
<title>请选择所需信息
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
</title>
</head>
<body class="pagebackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
<table width="100%" border='1' height="98%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>

<%
	if(sSelBrowseMode.equals("")){
%>
	<tr> 
			<td id="selectPage" valign=top>
				<p>没有定义对象选择窗口。请在"对象类型选择设置"模块定义 SelBrowseMode 属性。</p>
			</td>
	</tr>
<%
	}else{
	if(sAttribute4.equals("1"))//需要根据检索条件进行查询，则进行提示。
	{
%>
	<tr style='width:100%; height:1'>
	<td><font style=' font-size: 9pt;FONT-FAMILY:宋体;color:red;'>请输入相应的查询条件，点击“查询”按钮获得查询结果！</font></td>
	</tr>
<%
	}
%>
	<tr> 
			<td id="selectPage">
				<iframe name="ObjectList" width=100% height=100% frameborder=0 =no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
			</td>
	</tr>
	
<%
		}
	%>
	<tr>
		<td nowarp bgcolor="" height="25" align=center  colspan="2"> 
			<input type="button" name="ok" value="确认" onClick="javascript:returnSelection()"  border='1'>
			<input type="button" name="ok" value="清空" onClick="javascript:clearAll()"  border='1'>
			<input type="button" name="Cancel" value="取消" onClick="javascript:doCancel();" border='1'>
		</td>
	</tr>
</form>
</table>

</body>
</html>
<script language=javascript>
	var sObjectInfo="";
	function returnSelection()
	{
		sSelBrowseMode = "<%=sSelBrowseMode%>";
		if(sSelBrowseMode == "Grid")
			ObjectList.returnValue();			
		if(sObjectInfo==""){
			if(confirm("您尚未进行选择，确认要返回吗？")){
				sObjectInfo="_NONE_";
			}else{
				return;
			}
		}
		self.returnValue=sObjectInfo;
		self.close();
	}

	function clearAll()
	{
		self.returnValue='_CLEAR_';
		self.close();
	
	}

	function doCancel()
	{
		self.returnValue='_CANCEL_';
		self.close();
	}
	
	<%if(sSelBrowseMode!=null && !sSelBrowseMode.equals(""))
	{
		if(sSelBrowseMode.equals("Grid"))
		{%>		
			OpenComp("SelectGridDialog","/Frame/SelectGridDialog.jsp","SelName=<%=sSelName%>&ParaString=<%=sParaString%>","ObjectList","");
		<%}else if(sSelBrowseMode.equals("TreeView"))
		{%>
			OpenComp("SelectTreeViewDialog","/Frame/SelectTreeViewDialog.jsp","SelName=<%=sSelName%>&ParaString=<%=sParaString%>","ObjectList","");
		<%}
	}%>
</script>

<%@ include file="/IncludeEnd.jsp"%>
