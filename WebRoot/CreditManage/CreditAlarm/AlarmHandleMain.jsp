<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jytian  2004/12/28
		Tester:
		Content: ҵ����Ϣ����
		Input Param:
			                
		Output param:
			              
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
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
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ����ʾ��Ԥ��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	//������ͼ�ṹ
	//add by lzhang 2011/04/12 ���Ӳ鿴��ɫ����
	String sSqlTreeView = "";
	if(CurUser.UserID.equals("9999999")||CurUser.hasRole("062")||CurUser.hasRole("262")||CurUser.hasRole("462")){
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ClewAndAlarmMain' and IsInUse='1' ";
	}else if("14".equals(CurUser.OrgID)){//΢С���ڲ�չʾ ����Ϣ������ǰ���족������ʾ bllou 20120413
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ClewAndAlarmMain' and IsInUse='1' and ItemNo not like '03%' ";
	}else{
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ClewAndAlarmMain' and IsInUse='1' and ItemNo not like '03%' and ItemNo not like '04%' ";
	}
	
	tviTemp.initWithSql("SortNo","ItemName","ItemNo","ItemDescribe","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
		
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;	
				
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
		
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script language="JavaScript">
		myleft.width=225;
		startMenu();
		expandNode('root');
		expandNode('01');	
		expandNode('02');
		expandNode('03');
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
