<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:	jjwang  2008-10-06
		Tester:
		Content:  �»��׼�򡶸���ҵ��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;����ҵ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
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
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"����ҵ��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "";
	if(CurUser.hasRole("604"))
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' and ItemNo in ('0020') ";
	else if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' and ItemNo in ('0010','0010010','0010011') ";
	else if(CurUser.hasRole("601"))
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' and ItemNo in ('0010','0010012','0010013') ";
	else if(CurUser.hasRole("602"))
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' and ItemNo in ('0010','0010014','0010015') ";
	else if(CurUser.hasRole("603"))
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' and ItemNo in ('0010','0010016','0010017') ";
	else 
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' ";//add by zrli 20091021 �������㣬�޽�ɫȫ��ʾ�����ߺ�������
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
		if(sCurItemID=="0010010" || sCurItemID=="0010012" || sCurItemID=="0010014" || sCurItemID=="0010016")
		{
			if(<%=CurUser.hasRole("601")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=UnFinished&Type=Confirm&Grade=02");
			}else if(<%=CurUser.hasRole("602")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=UnFinished&Type=Confirm&Grade=03");
			}else if(<%=CurUser.hasRole("603")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=UnFinished&Type=Confirm&Grade=04");
			}else if(<%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("080")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=UnFinished&Type=Input&Grade=01");
			}
		}else if(sCurItemID=="0010011" || sCurItemID=="0010013" || sCurItemID=="0010015" || sCurItemID=="0010017")
		{
			if(<%=CurUser.hasRole("601")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=Finished&Type=Confirm&Grade=02");
			}else if(<%=CurUser.hasRole("602")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=Finished&Type=Confirm&Grade=03");
			}else if(<%=CurUser.hasRole("603")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=Finished&Type=Confirm&Grade=04");
			}else if(<%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("080")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=Finished&Type=Input&Grade=01");
			}
		}
		else if(sCurItemID=="0020")
		{
			openChildComp("ResultConfirmIndList","/BusinessManage/ReserveManage/ResultConfirmIndList.jsp","Action=Finished&Type=Audit&Grade=05");
		}else if(sCurItemID=="0030")
		{
			openChildComp("ManualConfirmIndList","/BusinessManage/ReserveManage/ManualConfirmIndList.jsp","");
		}
		
		setTitle(getCurTVItem().name);
	}
	function startMenu() 
	{
		if((<%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("080")%>) && (<%=CurUser.hasRole("601")%> || <%=CurUser.hasRole("602")%> || <%=CurUser.hasRole("603")%>))
		{
			alert("���ڸ��û������Ŵ�������϶�Ա˫�ؽ�ɫ!�����Խ��м�ֵ׼������Ԥ����϶�.\n����ϵͳ����Ա��ϵ�����·����ɫ��");
			OpenComp("Main","/Main.jsp","","_self","");
		}
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
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
