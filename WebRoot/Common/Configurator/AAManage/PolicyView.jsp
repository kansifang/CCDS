
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/08/28
		Tester:
		Content:��Ȩ��������鿴
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��Ȩ��������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sPolicyID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sPolicyID == null) sPolicyID = "";
	
	//���ҳ�����	

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��Ȩ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	int iOrder = 1;	
	tviTemp.insertPage("root","��Ȩ����������Ϣ","",iOrder++);
	tviTemp.insertPage("root","��Ȩ���趨","",iOrder++);
	
	String sTestFolder = tviTemp.insertFolder("root","������Ȩ����","",iOrder++);
		tviTemp.insertPage(sTestFolder,"��Ȩ�����","",iOrder++);
		tviTemp.insertPage(sTestFolder,"��Ȩ����Ҳ���","",iOrder++);
	
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
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=="��Ȩ����������Ϣ")
		{
			OpenComp("PolicySettingInfo","/Common/Configurator/AAManage/PolicySettingInfo.jsp","PolicyID=<%=sPolicyID%>","right");
		}else if(sCurItemname=="��Ȩ���趨")
		{
			OpenComp("AuthPointSettingList","/Common/Configurator/AAManage/AuthPointSettingList.jsp","PolicyID=<%=sPolicyID%>","right");
		}else if(sCurItemname=="��Ȩ�����")
		{
			OpenComp("AAPointTest","/Common/Configurator/AAManage/AAPointTest.jsp","PolicyID=<%=sPolicyID%>","right");
		}else if(sCurItemname=="��Ȩ����Ҳ���")
		{
			//OpenComp("AAPointLookUpTest","/Common/Configurator/AAManage/AuthPointSettingList.jsp","PolicyID=<%=sPolicyID%>","right");
		}
		setTitle(getCurTVItem().name);
	}
		
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');	
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
