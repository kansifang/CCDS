<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content:�������쿴
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ŷ������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sCreditLineID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	//���ҳ�����	

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���Ŷ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	int iOrder = 1;
	//tviTemp.insertPage("root","����","",iOrder++);
	tviTemp.insertPage("root","���Ŷ�Ȼ�����Ϣ","",iOrder++);
	tviTemp.insertPage("root","���Ŷ�ȷ���","",iOrder++);
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	var sCreditLineID="<%=sCreditLineID%>";

	
	//treeview����ѡ���¼�
	
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=="���Ŷ�Ȼ�����Ϣ")
		{
			OpenComp("CreditLineInfo","/CreditManage/CreditLine/CreditLineInfo.jsp","ToInheritObj=y&LineID=<%=sCreditLineID%>","right");
		}
		
		if(sCurItemname=="���Ŷ�ȷ���")
		{
			OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ToInheritObj=y&ParentLineID=<%=sCreditLineID%>","right");
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
	selectItemByName("���Ŷ�Ȼ�����Ϣ");
	expandNode('root');	
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
