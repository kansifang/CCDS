<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.lmt.frameapp.config.dal.ASCodeDefinition" %>
<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
		Author:   zywei  2005.07.26
		Tester:
		Content: ����ҵ�񷽰�����_Main
		Input Param:
			ApplyType����������
		��CreditLineApply/���Ŷ������
		��DependentApply/�����������	
		��IndependentApply/��������ҵ������	
		��ApproveApplyList/���ύ���������������
		��PutOutApply/���ύ��˳���               
		Output param:
			ApplyType����������
			PhaseType���׶�����              
		History Log: 	
			zywei 2007/10/10 ������ʾ��һ�����Ͳ˵���
		*/
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;δ����ģ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
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
		String sItemName = "";//���������������
		String sTreeMain = "";//���ApplyMainҳ�������ͼ��CodeNo
		String sCompID = "";//������
		String sCompName = "";//�������
		String sSql = "";//���SQL���
		ASResultSet rs = null;//��Ų�ѯ�����	
		
		//����������	:��������
		String sApplyType = DataConvert.toString(DataConvert.toRealString(iPostChange,(CurComp.getParameter("ApplyType"))));
		String sCodeNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo")));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/
%>
	<%
		//�����������ʹӴ����CODE_LIBRARY�в�ѯ��
		//ApplyMain����ͼ�������������ơ����ID�����Name·��
		sSql = 	" select ItemDescribe,ItemName,Attribute7,Attribute8 "+
		" from CODE_LIBRARY "+
		" where CodeNo = '"+sCodeNo+"'"+
		" and ItemNo = '"+sApplyType+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sTreeMain = DataConvert.toString(rs.getString("ItemDescribe"));
			sItemName = DataConvert.toString(rs.getString("ItemName"));
			sCompID = DataConvert.toString(rs.getString("Attribute7"));
			sCompName = DataConvert.toString(rs.getString("Attribute8"));
			//���ô��ڱ���
			PG_TITLE = sItemName;
			PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
		}else{
			throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApplyType:"+sApplyType+"����");
		}
		rs.getStatement().close();

		//����Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,sItemName,"right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

		//������ͼ�ṹ���Ӵ����CODE_LIBRARY�в�ѯ��ApplyMainҳ�������Ч�����Ͳ˵���Ϣ
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo = '"+sTreeMain+"'  and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","Attribute5","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
	%>
<%
	/*~END~*/
%>
 

<%
 	/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/
 %>
	<!--���� include file="/Resources/CodeParts/Main04.jsp���������˵�-->
  <iframe name='left' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/
%>
	<script language=javascript> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick11(){
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1 = sCurItemDescribe[0];
		sCurItemDescribe2 = sCurItemDescribe[1];
		sApplyType = "<%=sApplyType%>";
		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "" && sCurItemDescribe1 != "root")
		{
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName=���������б�","right");
			setTitle(getCurTVItem().name);
		}
	}
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		var sCurItemDescribe_url = sCurItemDescribe[0]+"?ApplyType=<%=sApplyType%>&PhaseType="+getCurTVItem().id;
		//var sCurItemDescribe_compID = sCurItemDescribe[1];
		var sCurItemname = getCurTVItem().name;
		parent.newTab(sCurItemname,sCurItemDescribe_url);
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
	parent.document.getElementById("myleft").style.display="block";
	startMenu();
	expandNode('root');
    selectItem('1010');	   
	sApplyType = "<%=sApplyType%>";
	//�����������������ұ�ҳ���������
	if(sApplyType == 'CreditLineApply' || sApplyType == 'DependentApply' || sApplyType == 'IndependentApply')
		setTitle("����������");
	else if(sApplyType == 'PutOutApply')
		setTitle("���ύ��˷Ŵ�");
	else if(sApplyType == 'ApproveApply')
		setTitle("���ύ���������������");	
	</script>
<%
	/*~END~*/
%>

<%@ include file="/IncludeEnd.jsp"%>
