<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.lmt.frameapp.config.dal.ASCodeDefinition" %>

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
	String sCodeNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo")));
	String sComponentName =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName")));
	String sExpandItemNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DefaultTVItemID")));
	
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
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,sComponentName,"right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

		//������ͼ�ṹ
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo='"+sCodeNo+"' and IsInUse='1' ";
		sSqlTreeView += "and ItemNo not like '0020%' ";//��ͼfilter
		//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
		tviTemp.initWithSql("SortNo","ItemName","ItemNo","ItemDescribe","",sSqlTreeView,"Order By SortNo",Sqlca);
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
<!--zz-->
  <iframe name='left' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>


<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/
%>
	<script language=javascript> 
	<%
		ASCodeDefinition asd=(ASCodeDefinition)ASConfigure.getSysConfig("ASCodeSet", Sqlca).getAttribute(sCodeNo);
		if(asd!=null){
			for(int i=0;i<asd.items.size();i++){
				ASValuePool ap=asd.getItem(i);
				String id=(String)ap.getAttribute("ItemNo");
				String url=(String)ap.getAttribute("ItemAttribute");
				out.println("var _"+id+"='"+url+"';");
			}
		}
	%>
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		var url=eval("_"+sCurItemID);
		if(url!=='null'&&url.length>0){
			 parent.parent.newTab(sCurItemname,url);
		}
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
	//writeMsg(document.all("left").document.body.innerHTML);
	//var pWindow=window.dialogArguments;
	startMenu();
	expandNode('root');		
	selectItem('<%=sExpandItemNo%>');	
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
