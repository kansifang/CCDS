<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  fbkang 2005.08.02
		Tester:
		Content: 灵活统计查询主界面
		Input Param:			
		          --sComponentName：组件名称                
		Output param:		        
		        
		History Log: 		wangyegang 删除复杂逻辑，整理程序                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "灵活统计查询主界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;灵活统计查询主界面&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	//获得组件参数	
	String sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"灵活统计查询","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件


	//定义树图结构
	String sSqlTreeView = "" ;
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sDBName.startsWith("DB2")){
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'XQueryListnew' and IsInUse='1' "+
	          " and (nvl(Attribute1,'')='' or Attribute1='All' or  exists (select 1 from USER_ROLE UR where locate(CODE_LIBRARY.Attribute1,UR.RoleID)>0 and UR.UserID='"+CurUser.UserID+"' )) "+
	          " and (nvl(Attribute2,'')='' or Attribute2<>'All' and not exists (select 1 from USER_ROLE UR where locate(CODE_LIBRARY.Attribute2,UR.RoleID)>0 and UR.UserID='"+CurUser.UserID+"' ))" ;
	}else{
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'XQueryListnew' and IsInUse='1' "+
	          " and (exists (select UR.RoleID from USER_ROLE UR where (CODE_LIBRARY.Attribute1 like UR.RoleID||'%' or CODE_LIBRARY.Attribute1 like '%,'||UR.RoleID||'%') and UR.UserID='"+CurUser.UserID+"' )  or  Attribute1='' or Attribute1 is null or Attribute1='All' ) "+
	          " and not exists (select UR.RoleID from USER_ROLE UR where (CODE_LIBRARY.Attribute2  like UR.RoleID||'%' or CODE_LIBRARY.Attribute2 like '%,'||UR.RoleID||'%') and UR.UserID='"+CurUser.UserID+"' )  and (Attribute2<>'All' or Attribute2='' or Attribute2 is null) " ;	
	}
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>

<script language=javascript> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];  //代码表描述字段中用@分隔的第1个串
		sCurItemDescribe2=sCurItemDescribe[1];  //代码表描述字段中用@分隔的第2个串
		sCurItemDescribe3=sCurItemDescribe[2];  //代码表描述字段中用@分隔的第3个串

		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"&&sCurItemDescribe1 != ""){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,sCurItemDescribe3,"right");
			//OpenPage(sCurItemDescribe1,sCurItemDescribe3,"right");
			setTitle(getCurTVItem().name);
		}
	}
		
	/*~[Describe=置右面详情的标题;InputParam=sTitle:标题;OutPutParam=无;]~*/
	function setTitle(sTitle){
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() {
		<%=tviTemp.generateHTMLTreeView()%>
	}
</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
<script language="JavaScript">    
	startMenu();
	expandNode('root');
	expandNode('010');
	expandNode('020');
	expandNode('040');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>