<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
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
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;δ����ģ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ѺƷϵͳ���ݳ�ʼ��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	String sFolder1=tviTemp.insertFolder("root","���ݳ�ʼ��","",1);
	tviTemp.insertPage(sFolder1,"ѺƷ����ʼ����EXCEL��","",1);
	tviTemp.insertPage(sFolder1,"Ʊ�ݶ�Ӧ���κų�ʼ����TEXT��","",2);
	tviTemp.insertPage(sFolder1,"Ʊ�ݱ�֤���ʼ����EXCEL��","",3);
	tviTemp.insertPage(sFolder1,"�����Ϣ��ʼ����TEXT��","",4);
	tviTemp.insertPage(sFolder1,"���ɱ�֤���ͬ��Ϣ","",5);
	
	
	
	
	//��һ�ֶ�����ͼ�ṹ�ķ�����SQL
	//String sSqlTreeView = "from EXAMPLE_INFO";
	//tviTemp.initWithSql("SortNo","ExampleName","ExampleID","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
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
		if(sCurItemID==2){//ѺƷ����ʼ��
			OpenComp("FileChooseDialog","/ImpawnManage/DataInit/FileChooseDialog.jsp","ItemID="+sCurItemID+"&FileType=Excel","right");
		}else if(sCurItemID==3){//Ʊ�ݶ�Ӧ���κų�ʼ��
			OpenComp("FileChooseDialog","/ImpawnManage/DataInit/FileChooseDialog.jsp","ItemID="+sCurItemID+"&FileType=Text","right");					
		}else if(sCurItemID==4){//Ʊ�ݱ�֤����Ϣ��ʼ��
			OpenComp("FileChooseDialog","/ImpawnManage/DataInit/FileChooseDialog.jsp","ItemID="+sCurItemID+"&FileType=Excel","right");					
		}else if(sCurItemID==5){//�����Ϣ��ʼ��
			OpenComp("FileChooseDialog","/ImpawnManage/DataInit/FileChooseDialog.jsp","ItemID="+sCurItemID+"&FileType=Text","right");
		}else if(sCurItemID==6){//��֤��Ǽǲ��ȱ��ָ��¼����ɱ�֤����Ѻ��ͬ
			ShowMessage("���ڽ���ҵ���ύУ��,�����ĵȴ�.......",true,false);
			var sReturn = PopPage("/ImpawnManage/DataInit/FinalInfoHandler.jsp?SerialNo=","","dialogWidth=0;dialogHeight=0;minimize:yes");
			if(sReturn=="true") {
				try{hideMessage();}catch(e) {}
				alert("����ɹ���");
			}
			try{hideMessage();}catch(e) {}
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
	<script language="javascript">
	startMenu();
	expandNode('root');		
	expandNode('1');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
