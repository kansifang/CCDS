<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   --fbkang 2005-7-28
			Tester:	  
			Content: --��Ʒ������
			Input Param:
		     --ComponentName���������    
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
		String PG_TITLE = "�Ŵ���Ʒ����"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;�Ŵ���Ʒ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
		String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
		String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���,����ʾ��ͼ
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
		 String sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
		//���ҳ�����	
		
		PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
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
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/
%>
   <script language="JavaScript">
	//myleft.width=1;
	OpenComp("BatchCatalogList","/BusinessManage/BatchCatalogList.jsp","ComponentName=����ģ������","right");
	setTitle("����ģ������");
	</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
