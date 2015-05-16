<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.lmt.frameapp.config.dal.ASCodeDefinition" %>
<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
		Author:   zywei  2005.07.26
		Tester:
		Content: 授信业务方案调查_Main
		Input Param:
			ApplyType：申请类型
		—CreditLineApply/授信额度申请
		—DependentApply/额度项下申请	
		—IndependentApply/单笔授信业务申请	
		—ApproveApplyList/待提交复核最终审批意见
		—PutOutApply/待提交审核出账               
		Output param:
			ApplyType：申请类型
			PhaseType：阶段类型              
		History Log: 	
			zywei 2007/10/10 高亮显示第一个树型菜单项
		*/
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;未命名模块&nbsp;&nbsp;"; //默认的内容区标题
		String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
		String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/
%>
	<%
		//定义变量
		String sItemName = "";//存放申请类型名称
		String sTreeMain = "";//存放ApplyMain页面左边树图的CodeNo
		String sCompID = "";//组件编号
		String sCompName = "";//组件名称
		String sSql = "";//存放SQL语句
		ASResultSet rs = null;//存放查询结果集	
		
		//获得组件参数	:申请类型
		String sApplyType = DataConvert.toString(DataConvert.toRealString(iPostChange,(CurComp.getParameter("ApplyType"))));
		String sCodeNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo")));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/
%>
	<%
		//根据申请类型从代码表CODE_LIBRARY中查询出
		//ApplyMain的树图、申请类型名称、组件ID，组件Name路径
		sSql = 	" select ItemDescribe,ItemName,Attribute7,Attribute8 "+
		" from CODE_LIBRARY "+
		" where CodeNo = '"+sCodeNo+"'"+
		" and ItemNo = '"+sApplyType+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sTreeMain = DataConvert.toString(rs.getString("ItemDescribe"));
			sItemName = DataConvert.toString(rs.getString("ItemName"));
			sCompID = DataConvert.toString(rs.getString("Attribute7"));
			sCompName = DataConvert.toString(rs.getString("Attribute8"));
			//设置窗口标题
			PG_TITLE = sItemName;
			PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
		}else{
			throw new Exception("没有找到相应的申请类型定义（CODE_LIBRARY.ApplyType:"+sApplyType+"）！");
		}
		rs.getStatement().close();

		//定义Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,sItemName,"right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

		//定义树图结构：从代码表CODE_LIBRARY中查询出ApplyMain页面左边有效的树型菜单信息
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo = '"+sTreeMain+"'  and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","Attribute5","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//参数从左至右依次为： ID字段,Name字段,Value字段,Script字段,Picture字段,From子句,OrderBy子句,Sqlca
	%>
<%
	/*~END~*/
%>
 

<%
 	/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/
 %>
	<!--代替 include file="/Resources/CodeParts/Main04.jsp来容纳树菜单-->
  <iframe name='left' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/
%>
	<script language=javascript> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick11(){
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1 = sCurItemDescribe[0];
		sCurItemDescribe2 = sCurItemDescribe[1];
		sApplyType = "<%=sApplyType%>";
		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "" && sCurItemDescribe1 != "root")
		{
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName=授信申请列表","right");
			setTitle(getCurTVItem().name);
		}
	}
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick()
	{
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		var sCurItemDescribe_url = sCurItemDescribe[0]+"?ApplyType=<%=sApplyType%>&PhaseType="+getCurTVItem().id;
		//var sCurItemDescribe_compID = sCurItemDescribe[1];
		var sCurItemname = getCurTVItem().name;
		parent.newTab(sCurItemname,sCurItemDescribe_url);
	}
	/*~[Describe=置右面详情的标题;InputParam=sTitle:标题;OutPutParam=无;]~*/
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}		
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/
%>
	<script language="JavaScript">
	parent.document.getElementById("myleft").style.display="block";
	startMenu();
	expandNode('root');
    selectItem('1010');	   
	sApplyType = "<%=sApplyType%>";
	//根据申请类型设置右边页面标题名称
	if(sApplyType == 'CreditLineApply' || sApplyType == 'DependentApply' || sApplyType == 'IndependentApply')
		setTitle("待处理申请");
	else if(sApplyType == 'PutOutApply')
		setTitle("待提交审核放贷");
	else if(sApplyType == 'ApproveApply')
		setTitle("待提交复核最终审批意见");	
	</script>
<%
	/*~END~*/
%>

<%@ include file="/IncludeEnd.jsp"%>
