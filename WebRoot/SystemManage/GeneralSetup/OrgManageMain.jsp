<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		~Author=byhu;
		~Tester=byhu;
		~Describe=����ҳ������;
		~InputParam=;
		~OutputParam=;
		~LastModifyTime=;
		~HistoryLog=;
		
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "300";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	//String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	//���ҳ�����	
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = " from ORG_INFO where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
	
	
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	tviTemp.initWithSql("SortNo","OrgName","OrgID","","",sSqlTreeView,"Order By SortNo",Sqlca);


	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
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
		var sOrgID = getCurTVItem().value;		
		if(sOrgID != "null" && sOrgID!='root')
		{
			OpenComp("OrgList","/SystemManage/GeneralSetup/OrgList.jsp","ComponentName=��������&OrgID="+sOrgID,"right");
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
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	click_change(1);
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
