<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  fbkang 2005.08.02
		Tester:
		Content: ���ͳ�Ʋ�ѯ������
		Input Param:			
		          --sComponentName���������                
		Output param:		        
		        
		History Log: 		wangyegang ɾ�������߼����������                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ͳ�Ʋ�ѯ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���ͳ�Ʋ�ѯ������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	//����������	
	String sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���ͳ�Ʋ�ѯ","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�


	//������ͼ�ṹ
	String sSqlTreeView = "" ;
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sDBName.startsWith("DB2")){
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'XQueryListnew' and IsInUse='1' "+
	          " and (nvl(Attribute1,'')='' or Attribute1='All' or  exists (select 1 from USER_ROLE UR where locate(CODE_LIBRARY.Attribute1,UR.RoleID)>0 and UR.UserID='"+CurUser.UserID+"' )) "+
	          " and (nvl(Attribute2,'')='' or Attribute2<>'All' and not exists (select 1 from USER_ROLE UR where locate(CODE_LIBRARY.Attribute2,UR.RoleID)>0 and UR.UserID='"+CurUser.UserID+"' ))" ;
	}else{
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'XQueryListnew' and IsInUse='1' "+
	          " and (exists (select UR.RoleID from USER_ROLE UR where (CODE_LIBRARY.Attribute1 like UR.RoleID||'%' or CODE_LIBRARY.Attribute1 like '%,'||UR.RoleID||'%') and UR.UserID='"+CurUser.UserID+"' )  or  Attribute1='' or Attribute1 is null or Attribute1='All' ) "+
	          " and not exists (select UR.RoleID from USER_ROLE UR where (CODE_LIBRARY.Attribute2  like UR.RoleID||'%' or CODE_LIBRARY.Attribute2 like '%,'||UR.RoleID||'%') and UR.UserID='"+CurUser.UserID+"' )  and (Attribute2<>'All' or Attribute2='' or Attribute2 is null) " ;	
	}
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
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];  //����������ֶ�����@�ָ��ĵ�1����
		sCurItemDescribe2=sCurItemDescribe[1];  //����������ֶ�����@�ָ��ĵ�2����
		sCurItemDescribe3=sCurItemDescribe[2];  //����������ֶ�����@�ָ��ĵ�3����

		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"&&sCurItemDescribe1 != ""){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,sCurItemDescribe3,"right");
			//OpenPage(sCurItemDescribe1,sCurItemDescribe3,"right");
			setTitle(getCurTVItem().name);
		}
	}
		
	/*~[Describe=����������ı���;InputParam=sTitle:����;OutPutParam=��;]~*/
	function setTitle(sTitle){
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() {
		<%=tviTemp.generateHTMLTreeView()%>
	}
</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
<script language="JavaScript">    
	startMenu();
	expandNode('root');
	expandNode('010');
	expandNode('020');
	expandNode('040');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>