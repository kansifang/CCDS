<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: wwhe	2008-04-19
			Tester:
			Content:��Ȩ����
			Input Param:
			Output param:
			History Log: 

		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "��Ȩ����"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;��Ȩ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
		String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
		String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
%>
	<%
		//�������
		
		//����������	

		//���ҳ�����
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/
%>
	<%
		//����Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��Ȩ����","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

		//������ͼ�ṹ
		tviTemp.insertPage("root","��Ȩ������ҵ��Ʒ������","",1);
		//tviTemp.insertPage("root","��Ȩ�������㹫ʽ����","",1);
		tviTemp.insertPage("root","��Ȩ����������������","",1);
		tviTemp.insertPage("root","������Ȩά��","",1);
		tviTemp.insertPage("root","�����ر���Ȩά��","",1);
		//tviTemp.insertPage("root","����������Ȩά��","",1);
		//tviTemp.insertPage("root","������Ȩά��չʾ","",1);

		//��һ�ֶ�����ͼ�ṹ�ķ�����SQL
		//String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'MXQueryList' and Isinuse = '1'";
		//tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/
%>
	<script language=javascript>

	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/

	function TreeViewOnClick()
	{
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='��Ȩ������ҵ��Ʒ������')
			OpenComp("AuthorizePreceptList","/SystemManage/AuthorizeManage/AuthorizePreceptList.jsp","Type=Precept","right");
		else if(sCurItemname=='��Ȩ�������㹫ʽ����')
			OpenComp("AuthorizePreceptList","/SystemManage/AuthorizeManage/AuthorizePreceptList.jsp","Type=Condition&Type2=Balance","right");
		else if(sCurItemname=='��Ȩ����������������')
			OpenComp("AuthorizePreceptList","/SystemManage/AuthorizeManage/AuthorizePreceptList.jsp","Type=Condition","right");
		else if(sCurItemname=='������Ȩά��')
			OpenComp("AuthorizeOrgList","/SystemManage/AuthorizeManage/AuthorizeOrgList.jsp","","right");
		else if(sCurItemname=='�����ر���Ȩά��')
			OpenComp("AuthorizeOrgWithSpecialList","/SystemManage/AuthorizeManage/AuthorizeOrgWithSpecialList.jsp","AType=Special","right");
		else if(sCurItemname=='����������Ȩά��')
			OpenComp("AuthorizeEvaluateList2","/SystemManage/AuthorizeManage/AuthorizeEvaluateList.jsp","","right");
		//else if(sCurItemname=='������Ȩά��չʾ')
			//OpenComp("AuthorizeOrgList2","/SystemManage/AuthorizeManage/AuthorizeOrgList2.jsp","","right");
		else
			return;

		setTitle(getCurTVItem().name);
	}

	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/
%>
	<script language="javascript">
	startMenu();
	expandNode('root');	
	expandNode('root');		
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
