<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:     cwzhan 2005-02-02
			Tester:
			Content:    �û�������ͼ
			Input Param:
	                  
			Output param:
			                
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "����������ͼ"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;��������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
		String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
		String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/
%>
	<%
		//�������
		
		//����������	
		//��ȡ�������ObjectNo��ȷ���Ǹ����û��鿴Ȩ�޻��Ǹ��ݽ�ɫ�鿴Ȩ��
	    String sPara = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
		String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/
%>
	<%
		//����Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��������","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

		//������ͼ�ṹ
		String sSqlTreeView = " from ORG_INFO where OrgID like '"+CurOrg.OrgID+"%' ";
		
		
		//����������������Ϊ��
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
		tviTemp.initWithSql("SortNo","OrgName","OrgName","","",sSqlTreeView,"Order By SortNo",Sqlca);
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/
%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/
%>
	<script language=javascript> 

   function openChildComp(sCompID,sURL,sParameterString)
	{
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sOrgID = getCurTVItem().id;
		//alert(sOrgID+"ss");
		if(sOrgID != "null" && sOrgID!='root')
		{
			OpenPage("/Common/Configurator/OrgManage/OrgList.jsp?ComponentName=��������&OrgID="+sOrgID,"right","");
			setTitle(getCurTVItem().name);
		}
	}


	//����������ı���
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
    function closeAndReturn()
    {
        parent.reloadOpener();
        parent.close();
    }
	</script> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/
%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	expandNode(1);
	selectItemByName("������Ϣ");
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
