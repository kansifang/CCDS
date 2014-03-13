<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:		ljtao	2008/12/08
			Tester:
			Content: 用户审批授权管理主界面
			Input Param:
			Output param:
			ObjectType:Special/Normal -- 特殊授权/一般授权
			Type:1/2/3 -- 总行授权/分行授权/支行授权
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
		String PG_TITLE = "审批授权管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;审批授权管理&nbsp;&nbsp;"; //默认的内容区标题
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
		String sFolder1 = "",sFolder2 = "",sFolder3 = "";
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/
%>
	<%
		//定义Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"审批授权管理","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

		//定义树图结构
		//sFolder1 = tviTemp.insertFolder("root","特殊授权","",1);
		//tviTemp.insertPage(sFolder1,"市行授权","",2);
		//tviTemp.insertPage(sFolder1,"分行授权","",3);
		//tviTemp.insertPage(sFolder1,"支行授权","",4);
		
		//sFolder2 = tviTemp.insertFolder("root","一般授权","",5);
		//tviTemp.insertPage(sFolder3,"市行授权","",6);
		//tviTemp.insertPage(sFolder3,"分行授权","",7);
		//tviTemp.insertPage(sFolder3,"支行授权","",8);
		
		sFolder3 = tviTemp.insertFolder("root","授权","",1);
		tviTemp.insertPage(sFolder3,"总行授权","",2);
		tviTemp.insertPage(sFolder3,"分行(直属支行)授权","",3);
		tviTemp.insertPage(sFolder3,"支行授权","",4);
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
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/
%>
	<script language=javascript> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/

	function TreeViewOnClick()
	{
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		//if(sCurItemID=='2'){
		//	OpenComp("UserSpecialList","/Common/Configurator/UserAuthManage/UserSpecialList.jsp","ObjectType=Special&Type=1","right");
		//}
		//if(sCurItemID=='3'){
		//	OpenComp("UserSpecialList","/Common/Configurator/UserAuthManage/UserSpecialList.jsp","ObjectType=Special&Type=2","right");
		//}
		//if(sCurItemID=='4'){
		//	OpenComp("UserSpecialList","/Common/Configurator/UserAuthManage/UserSpecialList.jsp","ObjectType=Special&Type=3","right");
		//}
		if(sCurItemID=='2'){
			OpenComp("UserAuthList","/Common/Configurator/UserAuthManage/UserAuthList.jsp","ObjectType=Normal&Type=1","right");
		}
		if(sCurItemID=='3'){
			OpenComp("UserAuthList","/Common/Configurator/UserAuthManage/UserAuthList.jsp","ObjectType=Normal&Type=2","right");
		}
		if(sCurItemID=='4'){
			OpenComp("UserAuthList","/Common/Configurator/UserAuthManage/UserAuthList.jsp","ObjectType=Normal&Type=3","right");
		}
		setTitle(getCurTVItem().name);
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
	<script language="javascript">
	startMenu();
	expandNode('root');	
	//expandNode("<%//=sFolder1%>");
	//expandNode("<%//=sFolder2%>");
	expandNode("<%=sFolder3%>");
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
