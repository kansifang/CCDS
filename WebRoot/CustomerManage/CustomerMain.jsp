<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:	  BYao	  2004.12.07
		Content: �ͻ�������
		Input Param:
			                CustomerType���ͻ�����
			                				010	��˾�ͻ�
			                				020	��������
			                				030	���˿ͻ�
			                				035	���幤�̻�
			                				040	ũ��
			                				050	����С��
			                ComponentName:�������
			                CustomerListTemplet:�ͻ��б�ģ�����
			                ���ϲ���ͳһ�ɴ����:MainMenu���˵��õ�����
		Output param:
			                CustomerType���ͻ�����
			                ComponentName:�������
			                CustomerListTemplet:�ͻ��б�ģ�����
			                ���ϲ���ͳһ�ɴ����:MainMenu���˵��õ�����
		History Log: 
			2004-12-13	cchang	���Ӹ��幤�̻�����
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ͻ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	String sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
	String sCustomerListTemplet = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerListTemplet"));
	
	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script language=javascript> 
	
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language="JavaScript">
	//startMenu();
	//expandNode('root');
	sCustomerType = "<%=sCustomerType%>";
	sComponentName = "<%=sComponentName%>"
	sCustomerListTemplet = "<%=sCustomerListTemplet%>"
	myleft.width=1;
	OpenComp("CustomerList","/CustomerManage/CustomerList.jsp","ComponentName=��˾�ͻ��б�&OpenerFunctionName="+sComponentName+"&CustomerType="+sCustomerType+"&CustomerListTemplet="+sCustomerListTemplet,"right");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
