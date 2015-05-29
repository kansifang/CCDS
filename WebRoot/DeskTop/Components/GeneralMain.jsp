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
	String sItemNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo")));
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
		String sSqlTreeView = null;
		ASCodeDefinition asd=(ASCodeDefinition)ASConfigure.getSysConfig("ASCodeSet", Sqlca).getAttribute(sCodeNo);
		String url="";
		if(sItemNo.length()>0){
			sSqlTreeView=asd.getItem(sItemNo).getString("Attribute2");
			sSqlTreeView =StringFunction.replace(sSqlTreeView, "#SortNo", CurOrg.SortNo);
			
			String sColumn=asd.getItem(sItemNo).getString("Attribute3");
			String[] sCS=sColumn.split("@");
			tviTemp.initWithSql(sCS[0],sCS[1],sCS[2],"","",sSqlTreeView,sCS[3],Sqlca);
			
			String para=asd.getItem(sItemNo).getString("Attribute5");
			url=asd.getItem(sItemNo).getString("Attribute4")+"?"+para;
		}else{
			sSqlTreeView = "from CODE_LIBRARY where CodeNo='"+sCodeNo+"' and IsInUse='1' ";
			sSqlTreeView += "and (nvl(RelativeCode,'')='' or exists(select 1 from User_Role where UserID='"+CurUser.UserID+"' and locate(RoleID,RelativeCode)>0 and Status='1')) ";//视图filter
			sSqlTreeView += "and (nvl(Attribute1,'')='' or not exists(select 1 from User_Role where UserID='"+CurUser.UserID+"' and locate(RoleID,Attribute1)>0 and Status='1')) ";//视图filter
			//参数从左至右依次为： ID字段,Name字段,Value字段,Script字段,Picture字段,From子句,OrderBy子句,Sqlca
			tviTemp.initWithSql("SortNo","ItemName","ItemNo","","",sSqlTreeView,"Order By SortNo",Sqlca);
		}
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
<!--代替 include file="/Resources/CodeParts/Main04.jsp来容纳树菜单-->
  <iframe name='left' width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>
<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/
%>
	<script language=javascript> 
	<%
		if(sItemNo.length()>0){
			out.println("var _"+sItemNo+"='"+url+"';");
		}else{
			for(int i=0;i<asd.items.size();i++){
				ASValuePool ap=asd.getItem(i);
				String value=(String)ap.getAttribute("ItemNo");
				url=(String)ap.getAttribute("ItemDescribe");
				if(url==null||url.length()==0){
					continue;
				}
				url=url.split("@")[0];
				out.println("var _"+value+"='"+url+"';");
			}
		}
	%>
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		var sCurItemname = getCurTVItem().name;
		var sCurItemvalue = getCurTVItem().value;
		if("<%=sItemNo%>".length>0){
			sCurItemDescribe_url=eval("_<%=sItemNo%>");
			sCurItemDescribe_url=replaceAll(sCurItemDescribe_url,"#OrgID",sCurItemvalue);
		}else{
			sCurItemDescribe_url=eval("_"+sCurItemvalue);
		}
		if(sCurItemDescribe_url.lastIndexOf("~M")==sCurItemDescribe_url.length-2){
			PopPage(sCurItemDescribe_url.replace("~M",""),"_blank","dialogWidth:900px;dialogHeight:540px;status:no;center:yes;help:no;minimize:yes;maximize:yes;border:thin;statusbar:no");
		}else{
			parent.newTab(sCurItemname,sCurItemDescribe_url);
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
	parent.document.getElementById("myleft").style.display="block";
	//writeMsg(document.all("left").document.body.innerHTML);
	//var pWindow=window.dialogArguments;
	startMenu();
	expandNode('root');		
	expandNode('0200');	
	expandNode('0500');	
	//selectItem('<%=sExpandItemNo%>');	 在传入参数中已有DefaultTVItemID=010 所以此处没必要多此一举默认再打开一次
	
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>