<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:	jjwang  2008-10-06
		Tester:
		Content:  �»��׼�����ݲɼ���
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ݲɼ�"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���ݲɼ�&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	//String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	//if(sCustomerID==null) sCustomerID="";
	//���ҳ�����	
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���ݲɼ�","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	String sSqlTreeView = "";
	//������ͼ�ṹ
	if(CurUser.hasRole("608") && CurUser.hasRole("611")){
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='PrepareView' and IsInUse='1'";
	}else if(CurUser.hasRole("611")){
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='PrepareView' and IsInUse='1' and itemno like '0030%' ";
	}else{
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='PrepareView' and IsInUse='1' and itemno not like '0030%'";
	}
	tviTemp.initWithSql("SortNo","ItemName","ItemName","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�--�����ͻ��ڱ��е�ҵ����Ϣ
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemID=="0010010")
		{
			openChildComp("ReserveDataEntList","/BusinessManage/ReserveDataPrepare/ReserveDataEntList.jsp","");
		}else if(sCurItemID=="0010020")
		{
			openChildComp("ReserveDataIndList","/BusinessManage/ReserveDataPrepare/ReserveDataIndList.jsp","");
		}else if(sCurItemID=="0010030")
		{
			openChildComp("ReserveDataList","/BusinessManage/ReserveDataPrepare/ReserveDataList.jsp","");
		}else if(sCurItemID=="0010040")
		{
			openChildComp("ReserveDataWithDrawList","/BusinessManage/ReserveDataPrepare/ReserveDataWithDrawList.jsp","");
		}else if(sCurItemID=="0020")
		{
			openChildComp("ReportList","/BusinessManage/ReserveDataPrepare/ReportList.jsp","");
		}else if(sCurItemID=="0030010")
		{
			openChildComp("DataBaseList","/BusinessManage/ReserveDataPrepare/DataBaseList.jsp","");
		}else if(sCurItemID=="0030020")
		{
			openChildComp("DataBaseIndList","/BusinessManage/ReserveDataPrepare/DataBaseIndList.jsp","");
		}else if(sCurItemID=="0040010")
		{
			openChildComp("ReserveDataBaseList","/BusinessManage/ReserveDataPrepare/ReserveDataBaseList.jsp","Type=Ent");
		}else if(sCurItemID=="0040020")
		{
			openChildComp("ReserveDataBaseList","/BusinessManage/ReserveDataPrepare/ReserveDataBaseList.jsp","Type=Ind");
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
	expandNode('0010');
	expandNode('0030');
	expandNode('0040');
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
