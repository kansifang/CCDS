
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
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�༭��Ȩ����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=false; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ

	
	//������Ŀ¼����ȡ������
	String sSql  = "select FLOWNO,FLOWNAME,FLOWTYPE,AAEnabled,AAPolicy from FLOW_CATALOG";
	String[][] sFlows = Sqlca.getStringMatrix(sSql);
	for(int i=0;i<sFlows.length;i++){
		if(sFlows[i][3]==null || !sFlows[i][3].equals("1")) continue;
		String sFolder3 = tviTemp.insertFolder("root",sFlows[i][1],"",1);

		//������ģ�ͱ���ȡ�����̶�Ӧ�Ľ׶�
		sSql  = "select FLOWNO,PHASENO,PHASETYPE,PHASENAME,AAEnabled,AAPointComp,AAPointCompURL from FLOW_MODEL where FlowNo='"+sFlows[i][0]+"'";
		String[][] sPhases = Sqlca.getStringMatrix(sSql);
		for(int j=0;j<sPhases.length;j++){
			if(sPhases[j][4]==null || !sPhases[j][4].equals("1")) continue;

			//��ȡ���̽׶ζ�Ӧ���б����
			String sCompID = "AuthPointSetting";
			String sCompURL = "/Common/Configurator/AAManage/AuthPointSettingList.jsp";

			if(sPhases[j][5]!=null && !sPhases[j][5].equals("")) sCompID = sPhases[j][5];
			if(sPhases[j][6]!=null && !sPhases[j][6].equals("")) sCompURL = sPhases[j][6];

			//�������̽׶νڵ�
			tviTemp.insertPage(sFolder3,sPhases[j][3],"javascript:parent.editPhaseAuth('"+sFlows[i][4]+"','"+sCompID+"','"+sCompURL+"','"+sPhases[j][0]+"','"+sPhases[j][1]+"')",1);
		}
	}
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
		
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	function editPhaseAuth(sPolicyID,sCompID,sCompURL,sFlowNo,sPhaseNo){
		if(sPolicyID=="" || sPolicyID=="null"){
			alert("��������δָ����Ȩ������\n\n ���ڡ���Ȩ�����趨��ģ�飬Ϊ�������ƶ���Ȩ������");
			return;
		}
		OpenComp(sCompID,sCompURL,"PolicyID="+sPolicyID+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,'right','');
	}
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');	
	try{
		expandNode('1');	
	}catch(e){
	}
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
