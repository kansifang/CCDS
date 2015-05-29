<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-28
			Tester:
			Content: 机构管理列表
			Input Param:
	                  
			Output param:
			                
			History Log: 王业罡 整理代码 2005-08-24

		 */
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "角色列表"; // 浏览器窗口标题
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	
	//获取组件参数
	
	//获取页面参数
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "RoleList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//增加过滤器	
	doTemp.setColumnAttribute("RoleID,RoleName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelRoleRight(#RoleID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
	<%
		//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
		String sButtons[][] = 
		{
			{(CurUser.hasRole("099")?"true":"false"),"","Button","新增角色","新增一种角色","newRecord()",sResourcesPath},
			//{(CurUser.hasRole("099")?"true":"false"),"","Button","角色权限","查看并修改角色权限","viewAndEditRight()",sResourcesPath},
			{"true","","Button","详情","查看机构情况","viewAndEdit()",sResourcesPath},
			{(CurUser.hasRole("099")?"true":"false"),"","Button","删除","删除该角色","deleteRecord()",sResourcesPath},
			//{"true","","Button","主菜单授权","给角色授权主菜单","my_AddMenu()",sResourcesPath},
			{(CurUser.hasRole("099")?"true":"false"),"","Button","变更生效","同步缓存中数据使数据库变更生效","reloadCacheRole()",sResourcesPath},
		};
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>

		/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
		function newRecord(){
			sReturn=popComp("RoleInfo","/SystemManage/GeneralSetup/RoleInfo.jsp","","");
			if (typeof(sReturn)!='undefined' && sReturn.length!=0) {
				reloadSelf();
			}
		}

		/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
		function viewAndEdit(){
			sRoleID   = getItemValue(0,getRow(),"RoleID");
			if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			sReturn=popComp("RoleInfo","/SystemManage/GeneralSetup/RoleInfo.jsp","RoleID="+sRoleID+"&rand="+amarRand(),"");
			//修改数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				reloadSelf();
			}
		}
    
		/*~[Describe=从当前机构中删除该人员;InputParam=无;OutPutParam=无;]~*/
		function deleteRecord(){   
			sRoleID = getItemValue(0,getRow(),"RoleID");
			if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			if(confirm(getBusinessMessage("902"))) //删除该角色的同时将删除该角色对应的权限，确定删除该角色吗？
			{
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
		}
	
		/*~[Describe=给角色授权主菜单;InputParam=无;OutPutParam=无;]~*/
		function my_AddMenu(){
			sRoleID   = getItemValue(0,getRow(),"RoleID");
			if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}

			PopPage("/SystemManage/GeneralSetup/AddRoleMenu.jsp?RoleID="+sRoleID,"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
		}
	
    	/*~[Describe=查看并可修改人员权限;InputParam=无;OutPutParam=无;]~*/
		function viewAndEditRight(){
			sRoleID=getItemValue(0,getRow(),"RoleID");
			if(typeof(sRoleID)=="undefined" ||sRoleID.length==0){ 
				alert(getHtmlMessage('1'));
			}
			else{
				popComp("RoleRightConfig","/SystemManage/GeneralSetup/RightView.jsp","ObjectNo=ROLE@"+sRoleID,"","");
			}    
		}

		/*~[Describe=生效变更;InputParam=无;OutPutParam=无;]~*/
		function reloadCacheRole(){
			var sReturn = PopPage("/Common/ToolsB/reloadCacheConfig.jsp?ConfigName=<%=ASConfigure.SYSCONFIG_ROLE%>","","dialogWidth=15;dialogHeight=8;center:yes;status:no;statusbar:no");
			if (typeof(sReturn)== 'undefined' || sReturn.length == 0) {
				alert(getBusinessMessage("903"));//系统错误，请通知管理员！
			}
			else if (sReturn == 1) {
				alert(getBusinessMessage("904"));//数据同步成功！
			}
			else if (sReturn == 2) {
				alert(getBusinessMessage("905"));//同步失败，请检查原因，再试试！
			}
		}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	function mySelectRow(){     
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
