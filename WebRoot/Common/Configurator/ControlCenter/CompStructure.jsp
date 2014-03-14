<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content:显示组件结构
			Input Param:
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "组件结构"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;组件结构&nbsp;&nbsp;"; //默认的内容区标题
		String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
		String PG_LEFT_WIDTH = "350";//默认的treeview宽度
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/
%>
	<%
		//定义变量
		
		//获得组件参数	
		//获得页面参数
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/
%>
	<%
		//定义Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"组件结构","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

		//定义树图结构
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
		//tviTemp.insertFolder("root","出账管理","",1);
		//String tmp1=tviTemp.insertFolder(sPutOut,"出账申请列表","",2);
		//tviTemp.insertPage("tmp1","诉讼台账登记","javascript:parent.doAction(\"LawsuitRecord\")",3);
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/
%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/
%>
	<script language=javascript> 

	
	//treeview单击选中事件
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
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/
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
