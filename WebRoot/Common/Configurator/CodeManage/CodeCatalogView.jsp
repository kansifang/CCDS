<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.06
		Tester:
		Content: ��������
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"����Ŀ¼","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSql = "select distinct CodeTypeOne from CODE_CATALOG";
	String sCodeTypeOne[][] = Sqlca.getStringMatrix(sSql);
	sSql = "select distinct CodeTypeOne,CodeTypeTwo from CODE_CATALOG";
	String sCodeTypeTwo[][] = Sqlca.getStringMatrix(sSql);

	int iTreeNode=1;
	String sFolders[][] = new String[sCodeTypeOne.length][2];
	for(int i=0;i<sFolders.length;i++){
		sFolders[i][0] = sCodeTypeOne[i][0];
		sFolders[i][1] =  tviTemp.insertFolder("root",sCodeTypeOne[i][0],"","",iTreeNode++);
		for(int j=0;j<sCodeTypeTwo.length;j++){
			if(sCodeTypeTwo[j][0]!=null && sCodeTypeTwo[j][0].equals(sCodeTypeOne[i][0])){
				tviTemp.insertPage(sFolders[i][1],sCodeTypeTwo[j][1],sCodeTypeTwo[j][0],"",iTreeNode++);
			}
		}	
	}
	tviTemp.insertPage("root","����","","",iTreeNode++);	
    %>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;Describe=��ͼ�¼�;]~*/%>
	<script language=javascript> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		var sCodeTypeOne="",sCodeTypeTwo="";
		sNodeValue = getCurTVItem().value;
		if(sNodeValue==""){
			sCodeTypeOne = getCurTVItem().name;
		}else{
			sCodeTypeOne = getCurTVItem().value;
			sCodeTypeTwo = getCurTVItem().name;
		}
		if(sCodeTypeOne=="����") sCodeTypeOne="";
		javascript:parent.OpenComp("CodeCatalog","/Common/Configurator/CodeManage/CodeCatalogList.jsp","CodeTypeOne="+sCodeTypeOne+"&CodeTypeTwo="+sCodeTypeTwo,"right","");	
        setTitle(getCurTVItem().name);
	}


	/*~[Describe=����������ı���;InputParam=sTitle:����;OutPutParam=��;]~*/
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');		
	selectItemByName("������Ϣ");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
