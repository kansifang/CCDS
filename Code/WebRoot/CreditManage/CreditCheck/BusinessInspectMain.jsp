<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ndeng  2005.01.17
		Tester:
		Content: ������������
		Input Param:
			                ComponentName:�������
		Output param:
		History Log:  
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
	String sTreeviewTemplet = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TreeviewTemplet"));

	//���ҳ�����	

	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	String sOrgFlag = Sqlca.getString("select OrgFlag from Org_Info where orgid = '"+CurOrg.OrgID+"'");
	if(sOrgFlag == null) sOrgFlag = "";
	//����
	String sCondition ="";
	int i=0,i1=0,i2=0,i3=0;
	//280�����пͻ�����480��֧�пͻ�����000������ϵͳ����ά��Ա 080���ſͻ�������ͻ����� 2A5����֧�и��˽��ڲ��ͻ�����,2D3��С��ҵ���ͻ�����
	if (CurUser.hasRole("280") || CurUser.hasRole("480") || CurUser.hasRole("080") || CurUser.hasRole("2A5") || CurUser.hasRole("2D3") || CurUser.hasRole("000")){
		i1 = 1;
	}
	//040�������Ŵ����մ�����Ա��240�������Ŵ����մ�����Ա��000������ϵͳ����ά��Ա
	if (CurUser.hasRole("040") || CurUser.hasRole("240")|| CurUser.hasRole("000")){
		i2 = 2;
	}
	if((CurUser.hasRole("210") && "030".equals(sOrgFlag)) || CurUser.hasRole("410")){
		i3=1;
	}
	i=i1+i2;
	if (i==3) sCondition ="  and isinuse = '1' ";
	if (i==2) sCondition =" and Itemno like '02%' and isinuse = '1' ";
	if (i==1) sCondition =" and Itemno like '01%' and isinuse = '1' ";
	if (i==0) sCondition =" and Itemno like '1%' and isinuse = '1' ";
	if (i3==1 && i>1)
		sCondition +=" and ItemNo in ('01040','01040020') ";
	else if(i3==1 &&i==0)
		sCondition =" and ItemNo in ('01040','01040020') ";	
	//080���ſͻ�������ͻ����� 2A5����֧�и��˽��ڲ��ͻ���������΢С��ҵ�����鱨��
	if(CurUser.hasRole("080") || CurUser.hasRole("2A5"))
	{
		sCondition =sCondition+" and Itemno not like '01040%'";
	}
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���ռ�����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sTreeviewTemplet+"'"+sCondition;
	
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script language=javascript> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		var sCurItemDescribe3=sCurItemDescribe[2];
		if(typeof(sCurItemID)!="undefined" && typeof(sCurItemDescribe2)!="undefined" && sCurItemDescribe2.length > 0 && sCurItemID !="root" && sCurItemID !="010" && sCurItemID !="020")
		{
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&InspectType="+sCurItemDescribe3,"right");
		}
		
		if(sCurItemDescribe1 != "null"&&sCurItemDescribe1!="root")
		{	
			setTitle(getCurTVItem().name);
		}
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




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');	
	expandNode('01');
	expandNode('02');
	expandNode('01030');
	expandNode('01010');	
	expandNode('01020');
	selectItem('01010010');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
