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
	String sItemNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo")));
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
		String sSqlTreeView = null;
		ASCodeDefinition asd=(ASCodeDefinition)ASConfigure.getSysConfig("ASCodeSet", Sqlca).getAttribute(sCodeNo);
		String url="";
		if(sItemNo.length()>0){
			sSqlTreeView=asd.getItem(sItemNo).getString("Attribute2");
			sSqlTreeView =StringFunction.replace(sSqlTreeView, "#SortNo", CurOrg.SortNo);
			
			String sColumn=asd.getItem(sItemNo).getString("Attribute3");
			String[] sCS=sColumn.split("@");
			tviTemp.initWithSql(sCS[0],sCS[1],sCS[2],"","",sSqlTreeView,sCS[3],Sqlca);
			
			String para=asd.getItem(sItemNo).getString("Attribute5");
			url=asd.getItem(sItemNo).getString("Attribute4")+"?"+para;
		}else{
			sSqlTreeView = "from CODE_LIBRARY where CodeNo='"+sCodeNo+"' and IsInUse='1' ";
			sSqlTreeView += "and (nvl(RelativeCode,'')='' or exists(select 1 from User_Role where UserID='"+CurUser.UserID+"' and locate(RoleID,RelativeCode)>0 and Status='1')) ";//��ͼfilter
			sSqlTreeView += "and (nvl(Attribute1,'')='' or not exists(select 1 from User_Role where UserID='"+CurUser.UserID+"' and locate(RoleID,Attribute1)>0 and Status='1')) ";//��ͼfilter
			//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
			tviTemp.initWithSql("SortNo","ItemName","ItemNo","","",sSqlTreeView,"Order By SortNo",Sqlca);
		}
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
<!--���� include file="/Resources/CodeParts/Main04.jsp���������˵�-->
  <iframe name='left' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>
<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/
%>
	<script language=javascript> 
	<%
		if(sItemNo.length()>0){
			out.println("var _"+sItemNo+"='"+url+"';");
		}else{
			for(int i=0;i<asd.items.size();i++){
				ASValuePool ap=asd.getItem(i);
				String value=(String)ap.getAttribute("ItemNo");
				url=(String)ap.getAttribute("ItemDescribe");
				if(url==null||url.length()==0){
					continue;
				}
				url=url.split("@")[0];
				out.println("var _"+value+"='"+url+"';");
			}
		}
	%>
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sCurItemname = getCurTVItem().name;
		var sCurItemvalue = getCurTVItem().value;
		if("<%=sItemNo%>".length>0){
			sCurItemDescribe_url=eval("_<%=sItemNo%>");
			sCurItemDescribe_url=replaceAll(sCurItemDescribe_url,"#OrgID",sCurItemvalue);
		}else{
			sCurItemDescribe_url=eval("_"+sCurItemvalue);
		}
		if(sCurItemDescribe_url.lastIndexOf("~M")==sCurItemDescribe_url.length-2){
			PopPage(sCurItemDescribe_url.replace("~M",""),"_blank","dialogWidth:900px;dialogHeight:540px;status:no;center:yes;help:no;minimize:yes;maximize:yes;border:thin;statusbar:no");
		}else{
			parent.newTab(sCurItemname,sCurItemDescribe_url);
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
	parent.document.getElementById("myleft").style.display="block";
	//writeMsg(document.all("left").document.body.innerHTML);
	//var pWindow=window.dialogArguments;
	startMenu();
	expandNode('root');		
	expandNode('0200');	
	expandNode('0500');	
	//selectItem('<%=sExpandItemNo%>');	 �ڴ������������DefaultTVItemID=010 ���Դ˴�û��Ҫ���һ��Ĭ���ٴ�һ��
	
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>