
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   zywei  2005.07.26
	Tester:
	Content: ������Ȩ����_Main
	Input Param:	
		               
	Output param:
	             
	History Log: 	 
	                
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ȩ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������Ȩ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"������Ȩ����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	String sFolder0 = tviTemp.insertFolder("root","�����趨","",1);	
	tviTemp.insertPage(sFolder0,"���������趨","",1);
	String sFolder1 = tviTemp.insertFolder("root","��Ȩ�����趨","",1);	
	tviTemp.insertPage(sFolder1,"��ɾ��Ȩ����","",1);
	tviTemp.insertPage(sFolder1,"Ϊ����ָ����Ȩ����","",1);
	
	%>
<%/*~END~*/%>
 

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script language=javascript> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=='��Ȩ�������趨'){
			OpenComp("AjudicatorSettingList","/Common/Configurator/AAManage/AjudicatorSettingList.jsp","","right");
		}else if(sCurItemname=='���������趨'){
			OpenComp("ExceptionTypeSettingList","/Common/Configurator/AAManage/ExceptionTypeSettingList.jsp","","right");
		}else if(sCurItemname=='��ɾ��Ȩ����'){
			OpenComp("PolicySettingList","/Common/Configurator/AAManage/PolicySettingList.jsp","","right");
		}else if(sCurItemname=='Ϊ����ָ����Ȩ����'){
			OpenComp("FlowPolicySettingList","/Common/Configurator/AAManage/FlowPolicySettingList.jsp","","right");
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
			
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');	
	expandNode('<%=sFolder0%>');
	expandNode('<%=sFolder1%>');

	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
