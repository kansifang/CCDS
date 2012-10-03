
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   zywei  2005.07.26
	Tester:
	Content: 审批授权管理_Main
	Input Param:	
		               
	Output param:
	             
	History Log: 	 
	                
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "审批授权管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;审批授权管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"编辑授权方案","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=false; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构

	
	//从流程目录表中取出流程
	String sSql  = "select FLOWNO,FLOWNAME,FLOWTYPE,AAEnabled,AAPolicy from FLOW_CATALOG";
	String[][] sFlows = Sqlca.getStringMatrix(sSql);
	for(int i=0;i<sFlows.length;i++){
		if(sFlows[i][3]==null || !sFlows[i][3].equals("1")) continue;
		String sFolder3 = tviTemp.insertFolder("root",sFlows[i][1],"",1);

		//从流程模型表中取出流程对应的阶段
		sSql  = "select FLOWNO,PHASENO,PHASETYPE,PHASENAME,AAEnabled,AAPointComp,AAPointCompURL from FLOW_MODEL where FlowNo='"+sFlows[i][0]+"'";
		String[][] sPhases = Sqlca.getStringMatrix(sSql);
		for(int j=0;j<sPhases.length;j++){
			if(sPhases[j][4]==null || !sPhases[j][4].equals("1")) continue;

			//读取流程阶段对应的列表组件
			String sCompID = "AuthPointSetting";
			String sCompURL = "/Common/Configurator/AAManage/AuthPointSettingList.jsp";

			if(sPhases[j][5]!=null && !sPhases[j][5].equals("")) sCompID = sPhases[j][5];
			if(sPhases[j][6]!=null && !sPhases[j][6].equals("")) sCompURL = sPhases[j][6];

			//插入流程阶段节点
			tviTemp.insertPage(sFolder3,sPhases[j][3],"javascript:parent.editPhaseAuth('"+sFlows[i][4]+"','"+sCompID+"','"+sCompURL+"','"+sPhases[j][0]+"','"+sPhases[j][1]+"')",1);
		}
	}
	%>
<%/*~END~*/%>
 

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script language=javascript> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick()
	{
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	function editPhaseAuth(sPolicyID,sCompID,sCompURL,sFlowNo,sPhaseNo){
		if(sPolicyID=="" || sPolicyID=="null"){
			alert("该流程尚未指定授权方案。\n\n 请在“授权基础设定”模块，为该流程制定授权方案。");
			return;
		}
		OpenComp(sCompID,sCompURL,"PolicyID="+sPolicyID+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,'right','');
	}
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
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
