<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zrli
		Tester:
		Describe: �����ѡ��
		Input Param:
			��
		Output Param:
			ItemNo����Ŀ���
			ItemName����Ŀ����

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>��ѡ����ҵ���� </title>
</head>

<script language=javascript>

<%
	String sVillageValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("VillageValue"));
	String sVillage = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Village"));
	String sOpen = "";
	String sDefaultItem = "";
	//�����жϣ���ֹ���� null���� add by jbye 2009/03/30
	if(sVillage.length()>3) sDefaultItem = sVillage.substring(0,6);
	if(sVillage!=null&&sVillage.length()>6) sOpen = "YES";
%>

	//��ȡ�û�ѡ�����ҵ����
	function TreeViewOnClick(){

		var sVillage=getCurTVItem().id;
		var sVillageName=getCurTVItem().name;
		var sType = getCurTVItem().type;
		buff.Village.value=sVillage+"@"+sVillageName;
		<%
		//ѡ�������ҵ����ʱ�����Զ������ұ߽�Ŀ
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

	//��ѡһ����ҵ����
	function newBusiness(){
<%
	//ѡ�������ҵ����ʱ�����Զ������ұ߽�Ŀ
	if(sVillageValue == null)
	{
%>
		if(buff.Village.value!=""){
			sReturnValue = buff.Village.value;
			parent.OpenPage("/Common/ToolsA/VillageSelect.jsp?VillageValue="+getCurTVItem().id,"frameright","");
		}
		else{
			alert(getBusinessMessage('247'));//��ѡ����ҵ����ϸ�
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
			alert(getBusinessMessage('247'));//��ѡ����ҵ����ϸ�
		}else{
			parent.returnValue = buff.Village.value;
			parent.close();
		}
<%
	}
%>
	}
	//����
	function goBack()
	{
		self.close();
	}

	//����ѯ������ҵ���Ͱ���TreeViewչʾ
	function startMenu()
	{
	<%

		HTMLTreeView tviTemp = new HTMLTreeView("������б�","right");
		tviTemp.TriggerClickEvent=true;
		//ѡ����ҵ����һ
		if(sVillageValue == null)
			tviTemp.initWithSql("SerialNo","RegionalismName","SerialNo","","from Village_Info where isinuse='1' and (length(SerialNo) between 6 and 8) ",Sqlca);
		else
			tviTemp.initWithSql("SerialNo","RegionalismName","SerialNo","","from Village_Info where SerialNo like '"+sVillageValue+"%'",Sqlca);
		
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
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
<p align="left" class="black9pt">����ѡ��</p>
<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" >
</td>
<%
	}else{
%>
<span class="STYLE9"></span>
<p align="left" class="black9pt">��ѡ��</p>
<td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("ȷ��","ȷ��","javascript:newBusiness()",sResourcesPath)%>
</td>
<td nowrap bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("ȡ��","ȡ��","javascript:goBack()",sResourcesPath)%>
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
	selectItem('<%=sDefaultItem%>');//�Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	selectItem('<%=sVillage%>');//�Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	expandNode('<%=sVillageValue%>');
</script>

<%@ include file="/IncludeEnd.jsp"%>
