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
 * Title: ѡ���ѯ�����б�
 * Description: չ�г���ǰ�û����ڵ�ȫϽ����
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
<title>��ѡ�����</title>
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
			alert("��ѡ��һ����Ч�Ļ�����");
	}
		
	
	function startMenu() 
	{
	<%
	
	String sOrgFrom = "";
	String UserRoleID = "";
	String sSortNO = "";
	String sTreeViewName = "�����б�";
	//HTMLTreeView tviTemp = new HTMLTreeView(sTreeViewName,"right");
	
	ASResultSet rs = Sqlca.getResultSet("select SortNO FROM Org_Info WHERE  OrgID = '"+CurOrg.OrgID+"' ");
	
	if(rs.next()) {
		sSortNO = rs.getString("SortNO");
	}
	rs.getStatement().close();
	if(sSortNO==null) sSortNO="";
	
		HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"�����б�","right");
		tviTemp.TriggerClickEvent=true;		

		//����������������Ϊ��
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
		tviTemp.initWithSql("SortNo","OrgName","SortNo","","","from Org_Info where SortNo LIKE '"+sSortNO+"%' ","order by SortNo",Sqlca);		
		
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
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
        <input type="button" name="ok" value="ȷ��" onClick="javascript:returnSelection()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
		<input type="button" name="Cancel" value="���" onClick="javascript:self.returnValue='_NONE_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
		<input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
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