<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content:��ʾ����ṹ
			Input Param:
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "����ṹ"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;����ṹ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
		String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
		String PG_LEFT_WIDTH = "350";//Ĭ�ϵ�treeview���
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/
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
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/
%>
	<%
		//����Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"����ṹ","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

		//������ͼ�ṹ
		ASValuePool compFolders = new ASValuePool();
		
		
		for(int i=0;i<CurCompSession.ASComponents.size();i++){
			ASComponent tmpComp = (ASComponent)CurCompSession.ASComponents.get(i);
			if(i==0)
			{
		String sCompFolder = tviTemp.insertFolder(tmpComp.ClientID,"root",tmpComp.ID+" ["+tmpComp.ClientID,tmpComp.ClientID,"",i);
		compFolders.setAttribute(tmpComp.ID,sCompFolder);
			}else{
		String sParentFolder = null;
		if(tmpComp.compParentComponent!=null){
			sParentFolder = (String)compFolders.getAttribute(tmpComp.compParentComponent.ID);
		}else{
			sParentFolder = "root";
		}
		String sCompFolder1 = tviTemp.insertFolder(tmpComp.ClientID,sParentFolder,tmpComp.ID+" ["+tmpComp.ClientID+"]",tmpComp.ClientID,"",i);
		compFolders.setAttribute(tmpComp.ID,sCompFolder1);
			}
		
		}
		//tviTemp.insertFolder("root","���˹���","",1);
		//String tmp1=tviTemp.insertFolder(sPutOut,"���������б�","",2);
		//tviTemp.insertPage("tmp1","����̨�˵Ǽ�","javascript:parent.doAction(\"LawsuitRecord\")",3);
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/
%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/
%>
	<script language=javascript> 

	
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;

		OpenPage("/Common/Configurator/ControlCenter/CompDetail.jsp?ToShowClientID="+sCurItemID,"right","");

		setTitle(getCurTVItem().name);
	}


	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/
%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	expandNode('10');
	</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
