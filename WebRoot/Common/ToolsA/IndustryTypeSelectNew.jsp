<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: zytan 2011-03-22 
			Tester:
			Describe: ���ұ�׼��ҵѡ��(֧��ѡ�����)
			Input Param:
		��
			Output Param:
		ItemNo����Ŀ���
		ItemName����Ŀ����

			HistoryLog:
		
		 */
	%>
<%
	/*~END~*/
%>

<html>
<head>
<title>��ѡ����ҵ���� </title>
</head>

<script language=javascript>

<%String sIndustryTypeValue = DataConvert.toRealString(iPostChange,(String)request.getParameter("IndustryTypeValue"));%>

	//��ȡ�û�ѡ�����ҵ����
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

	//��ѡһ����ҵ����
	function newBusiness(){
<%if(sIndustryTypeValue == null)
	{%>
		if(buff.IndustryType.value!=""){
			self.returnValue=buff.IndustryType.value;
			self.close();
		}
		else{
			alert(getBusinessMessage('247'));//��ѡ����ҵ����ϸ�
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
			alert(getBusinessMessage('248'));//��ѡ�����ҵ��Ҫϸ�ֵ�С�࣡
		}else{
			if(buff.IndustryType.value.length<3){
				alert(getBusinessMessage('247'));//��ѡ����ҵ����ϸ�
			}else{
				if(sValue.length==5){
					self.returnValue=buff.IndustryType.value;
					self.close();
				}
				else{
					alert(getBusinessMessage('247'));//��ѡ����ҵ����ϸ�
				}
			}
		}

<%}%>
	}
	//����
	function goBack()
	{
		self.close();
	}

	//����ѯ������ҵ���Ͱ���TreeViewչʾ
	function startMenu()
	{
	<%HTMLTreeView tviTemp = new HTMLTreeView("��ҵ�����б�","right");
		tviTemp.TriggerClickEvent=true;
		//ѡ����ҵ����һ
		if(sIndustryTypeValue == null)
			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","","from Code_Library where CodeNO='IndustryType' and length(ItemNo) <= 3 and Isinuse = '1' ",Sqlca);
		else
			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","","from Code_Library where CodeNO='IndustryType' and ItemNo like '"+sIndustryTypeValue+"%' and Isinuse = '1' ",Sqlca);
		
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		out.println(tviTemp.generateHTMLTreeView());%>

	}


	//��ѡһ����ҵ����
	function newBusiness1(){
		var id = getCurTVItem().id;
		var name = getCurTVItem().name
		
		if(typeof(id) != "undefined" && id != "" && id != "root"){
			self.returnValue=id+"@"+name+"@OK";
			self.close();
		}else{
			alert("��ѡ����ҵ���࣡");//��ѡ����ҵ����ϸ�
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
	<%=HTMLControls.generateButton("ȷ��","ȷ��","javascript:newBusiness1()",sResourcesPath)%>
</td>
<%
	if(sIndustryTypeValue == null)
{
%>
<td nowrap align="center" class="black9pt" bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("��һ��","��һ��","javascript:newBusiness()",sResourcesPath)%>
</td>
<%
	}
%>
<td nowrap bgcolor="#F0F1DE" >
	<%=HTMLControls.generateButton("ȡ��","ȡ��","javascript:goBack()",sResourcesPath)%>
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
