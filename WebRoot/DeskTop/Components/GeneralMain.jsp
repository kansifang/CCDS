<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.lmt.frameapp.config.dal.ASCodeDefinition" %>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   byhu  2004.12.06
			Tester:
			Content: 基础配置
			Input Param:
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "模型配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;基础配置&nbsp;&nbsp;"; //默认的内容区标题
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
		
		//获得组件参数	
	String sCodeNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo")));
	String sComponentName =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName")));
	String sExpandItemNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DefaultTVItemID")));
	
		//获得页面参数
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/
%>
	<%
		//定义Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,sComponentName,"right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

		//定义树图结构
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo='"+sCodeNo+"' and IsInUse='1' ";
		sSqlTreeView += "and ItemNo not like '0020%' ";//视图filter
		//参数从左至右依次为： ID字段,Name字段,Value字段,Script字段,Picture字段,From子句,OrderBy子句,Sqlca
		tviTemp.initWithSql("SortNo","ItemName","ItemNo","ItemDescribe","",sSqlTreeView,"Order By SortNo",Sqlca);
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/
%>
	
<%
	/*~END~*/
%>
<!--zz-->
  <iframe name='left' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>


<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/
%>
	<script language=javascript> 
	<%
		ASCodeDefinition asd=(ASCodeDefinition)ASConfigure.getSysConfig("ASCodeSet", Sqlca).getAttribute(sCodeNo);
		if(asd!=null){
			for(int i=0;i<asd.items.size();i++){
				ASValuePool ap=asd.getItem(i);
				String id=(String)ap.getAttribute("ItemNo");
				String url=(String)ap.getAttribute("ItemAttribute");
				out.println("var _"+id+"='"+url+"';");
			}
		}
	%>
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		var url=eval("_"+sCurItemID);
		if(url!=='null'&&url.length>0){
			 parent.parent.newTab(sCurItemname,url);
		}
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
	//writeMsg(document.all("left").document.body.innerHTML);
	//var pWindow=window.dialogArguments;
	startMenu();
	expandNode('root');		
	selectItem('<%=sExpandItemNo%>');	
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
