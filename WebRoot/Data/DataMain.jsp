<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
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
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "ģ������"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;��������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
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
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���ݹ���","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

		//������ͼ�ṹ
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo='DataMain' and IsInUse='1' ";
		sSqlTreeView += "and ItemNo not like '0020%' ";//��ͼfilter
		tviTemp.initWithSql("SortNo","ItemName","ItemNo","ItemDescribe","",sSqlTreeView,"Order By SortNo",Sqlca);
		//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/
%>
	
<%
	/*~END~*/
%>
<!---->
  <iframe name='left' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>


<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/
%>
	<script language=javascript> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
        //setTitle(getCurTVItem().name);
        parent.parent.newTab("ReportList","/Data/Report/ReportList.jsp","&Type=Query");
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
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/
%>
	<script language="JavaScript">
	//var pWindow=window.dialogArguments;
	startMenu();
	expandNode('root');		
	expandNode('0200');
	expandNode('0300');
	expandNode('0400');
	expandNode('0500');
	selectItem('0300002');	
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
