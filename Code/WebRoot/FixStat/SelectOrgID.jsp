<%
/* 
 * Copyright (c) 1999-2005 Amarsoft, Inc.
 * 3103 No.800 Quyang Rd. Shanghai,P.R. China 200437
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 *
 * FileName: SelectOrgID.java
 * Title: 选择查询机构列表
 * Description: 展列出当前用户所在的全辖机构
 *
 * @author zllin@amarsoft.com
 * @version 1.00 Mar 11,2005
 *          Date: 2005-05-16
 *          Time: 9:13:25
 *          HistoryLog: 1. 
 */
%>
<%@ page contentType="text/html; charset=gb2312"%>
<%@ include file="/IncludeBeginReportMD.jsp"%>
<%
/*
  String sOrg=DataConvert.toString(request.getParameter("OrgID"));
  if(sOrg == null ||sOrg.equals(""))
     sOrg="1";
	 */

%>
<html>
<head> 
<title>请选择机构</title>
<script language=javascript src="<%=sResourcesPath%>/expand.js"></script>

<script language=javascript>

	function TreeViewOnClick()
	{
		var sSortNo=getCurTVItem().id;
		var sVouchName=getCurTVItem().name;
		var sType = getCurTVItem().type;
		buff.SortNo.value=sSortNo+"@"+sVouchName;
	}
	
	function returnSelection()
	{
		if(buff.SortNo.value!="")
		{
			self.returnValue=buff.SortNo.value;
			self.close();
		}
		else
			alert("请选择一个有效的机构！");
	}
		
	
	function startMenu() 
	{
	<%
	
	String sOrgFrom = "";
	String UserRoleID = "";
	String sSortNO = "";
	String sTreeViewName = "机构列表";
	//HTMLTreeView tviTemp = new HTMLTreeView(sTreeViewName,"right");
	
	ASResultSet rs = Sqlca.getResultSet("select SortNO FROM Org_Info WHERE  OrgID = '"+CurOrg.OrgID+"' ");
	
	if(rs.next()) {
		sSortNO = rs.getString("SortNO");
	}
	rs.getStatement().close();
	if(sSortNO==null) sSortNO="";
	
		HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"机构列表","right");
		tviTemp.TriggerClickEvent=true;		

		//参数从左至右依次为：
		//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
		tviTemp.initWithSql("SortNo","OrgName","SortNo","","","from Org_Info where SortNo LIKE '"+sSortNO+"%' ","order by SortNo",Sqlca);		
		
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('root');		
	}	
	
	
	


</script>
<style>

.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}

</style>
</head>

<body class="pagebackground">
<center>
<form  name="buff">
<input type="hidden" name="SortNo" value="">
<table width="90%" border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr> 
        <td id="myleft"  align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>
    <tr>
     
      <td nowarp bgcolor="#F0F1DE" height="25" align=center> 
        <input type="button" name="ok" value="确认" onClick="javascript:returnSelection()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
		<input type="button" name="Cancel" value="清空" onClick="javascript:self.returnValue='_NONE_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
		<input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
</table>
</form>
</center>
</body>
<script>
startMenu();

</script></html>
<%@ include file="/IncludeEnd.jsp"%>