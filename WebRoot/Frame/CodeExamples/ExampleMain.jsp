<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content:ʾ��ģ����ҳ��
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
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"δ����","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

		//������ͼ�ṹ
		String sFolder1=tviTemp.insertFolder("root","ʾ����Ϣ","",1);
		tviTemp.insertPage(sFolder1,"���е�ʾ����Ϣ","",1);
		tviTemp.insertPage(sFolder1,"�ҵ�ʾ����Ϣ","",2);
		tviTemp.insertPage(sFolder1,"����ʾ����Ϣ","",3);
		//String sFolder2=tviTemp.insertFolder("root","ʾ����Ϣ2","",2);
		//tviTemp.insertPage(sFolder2,"���е�ʾ����Ϣ","",1);
		
		
		//��һ�ֶ�����ͼ�ṹ�ķ�����SQL
		//String sSqlTreeView = "from EXAMPLE_INFO";
		//tviTemp.initWithSql("SortNo","ExampleName","ExampleID","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//tviTemp.initWithCode("BusinessInspectMain",Sqlca);
		//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
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
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/
%>
	<script language=javascript> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/

	function TreeViewOnClick()
	{
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=='���е�ʾ����Ϣ'){
			OpenComp("ExampleList","/Frame/CodeExamples/ExampleList.jsp","","right");

		}
		else if(sCurItemname=='�ҵ�ʾ����Ϣ'){
			OpenComp("LoadExcelFileList","/Test/zywei/LoadExcelFileList.jsp","","right");						
			//OpenComp("ExampleList","/Frame/CodeExamples/ExampleList.jsp","InputUser=<%=CurUser.UserID%>");						
		}
		else if(sCurItemname=='����ʾ����Ϣ'){
		alert("hello");

		}
		else{
			return;
		}
		setTitle(getCurTVItem().name);
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
	<script language="javascript">
	startMenu();
	expandNode('root');		
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
