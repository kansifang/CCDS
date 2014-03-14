<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: --jytian 
			Tester:
			Describe: --文档管理主页面
			
			Input Param:
			Output Param:

			HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-24	fbkang	参数、格式	
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "文档管理主页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
		String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
		String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/
%>
	<%
		//定义变量
		String sSql = "";//存放sql语句	
		String sSynthesisInfoTemplet = "";//--打开页面的模板类型
		ASResultSet rs = null;//--存放结果集

		//获得页面参数
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/
%>
	<%
		//角色控制
		String sCondition ="";
		int i=0,i1=0,i2=0;
		//280－分行客户经理；480－支行客户经理；000－总行系统数据维护员
		if (CurUser.hasRole("080") || CurUser.hasRole("280") || CurUser.hasRole("480") || CurUser.hasRole("000")){
			i1 = 1;
		}
		//040－总行信贷风险贷后检查员；240－分行信贷风险贷后检查员；000－总行系统数据维护员
		if (CurUser.hasRole("040") || CurUser.hasRole("240")|| CurUser.hasRole("000")){
			i2 = 2;
		}
		i=i1+i2;
		if (i==3) sCondition ="";
		if (i==2) sCondition =" and Itemno like '02%'";
		if (i==1) sCondition =" and Itemno like '01%'"+" and (ItemAttribute= '"+CurUser.OrgID+"' or ItemAttribute is null or ItemAttribute='') and (Attribute1<> '"+CurUser.OrgID+"' or Attribute1 is null or Attribute1='')";
		if (i==0) sCondition =" and Itemno like '1%'";
		
		//取得视图模板类型	

		//定义Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"文档管理","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		tviTemp.TriggerClickEvent = true; //是否自动触发选中事件

		//定义树图结构
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'BCStatusMain' and IsInUse='1' and ItemNo in('010','020')"+sCondition;
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//参数从左至右依次为：
		//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/
%>
	<script language=javascript> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") 
			sParaStringTmp=sParameterString;
		else 
			sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview单击选中事件
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sCurItemDescribe3=sCurItemDescribe[2];
		if(sCurItemID!=='root'){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&Status="+sCurItemDescribe3,"right");
			setTitle(getCurTVItem().name);
		}
	}

	//置右面详情的标题
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
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
	expandNode('010');
	expandNode('020');
	selectItem('010');
	//selectItemByName('未完成导入');	
	</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
