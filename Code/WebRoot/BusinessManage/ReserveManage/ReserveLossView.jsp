<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:	jjwang  2008-10-12
		Tester:
		Content:  �»��׼����ʧʶ��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ʧʶ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ʧʶ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount==null) sLoanAccount="";
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));
	if(sCustomerName==null) sCustomerName="";
	String sMClassifyResult = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MClassifyResult"));
	if(sMClassifyResult==null) sMClassifyResult="";
	String sBalance = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Balance"));
	if(sBalance==null) sBalance="";
	String sPutoutDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PutoutDate"));
	if(sPutoutDate==null) sPutoutDate="";
	String sMaturityDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MaturityDate"));
	if(sMaturityDate==null) sMaturityDate="";
	
	//���ҳ�����	
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��ʧʶ��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveLossView' and IsInUse='1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemName","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
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
		openChildComp("ReserveLossInfo","/BusinessManage/ReserveManage/ReserveLossInfo.jsp","AccountMonth=<%=sAccountMonth%>"+"&LoanAccount=<%=sLoanAccount%>"+"&CustomerName=<%=sCustomerName%>"+"&MClassifyResult=<%=sMClassifyResult%>"+"&Balance=<%=sBalance%>"+"&PutoutDate=<%=sPutoutDate%>"+"&MaturityDate=<%=sMaturityDate%>");
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
	openChildComp("ReserveLossInfo","/BusinessManage/ReserveManage/ReserveLossInfo.jsp","AccountMonth=<%=sAccountMonth%>"+"&LoanAccount=<%=sLoanAccount%>"+"&CustomerName=<%=sCustomerName%>"+"&MClassifyResult=<%=sMClassifyResult%>"+"&Balance=<%=sBalance%>"+"&PutoutDate=<%=sPutoutDate%>"+"&MaturityDate=<%=sMaturityDate%>");
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
