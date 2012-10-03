<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2005-03-07
		Tester:
		Describe: 查询人员情况
		Input Param:
			
		Output Param:
			
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "人员情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	
	//获得组件参数


%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = 	{
								{"UserID","人员编号"},
								{"UserName","人员名称"},
								{"LoginID","登录名"},
								{"BelongOrgName","所属机构"},
                                {"Status","当前状态"}
							};

	String sSql =  "select UserID,UserName,LoginID,BelongOrg,getOrgName(BelongOrg) as BelongOrgName,Status" +
				   " from USER_INFO" +
				   " where (BelongOrg in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') or BelongOrg is null or BelongOrg='')";

	//out.println(sSql);
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
    doTemp.setVisible("BelongOrg,LoginID",false);
    doTemp.setHTMLStyle("UserID"," style={width:100px} ");
	doTemp.setHTMLStyle("UserName"," style={width:150px} ");
	doTemp.setHTMLStyle("LoginID"," style={width:100px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:200px} ");
	doTemp.setHTMLStyle("Status"," style={width:60px} ");
	//查询
	doTemp.setColumnAttribute("UserID,UserName,BelongOrgName,Status","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
    if(!doTemp.haveReceivedFilterCriteria())
	{
	 doTemp.WhereClause+=" and 1=2 ";
	}
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
							{"true","","Button","详情","查看人员情况","viewAndEdit()",sResourcesPath},
							{"true","","Button","角色","查看并可修改人员角色","my_role()",sResourcesPath},
							{"true","","Button","批量更新角色","批量更新角色","my_Addrole()",sResourcesPath},
							{"true","","Button","初始密码","初始化该用户密码","ClearPassword()",sResourcesPath},
							{"true","","Button","返回","返回","back()",sResourcesPath}
						};

	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{

		sUserID   = getItemValue(0,getRow(),"UserID");
		
		if (typeof(sUserID)=="undefined" || sUserID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/SystemManage/GeneralSetup/UserInfo.jsp?Back=find&UserID="+sUserID,"_self","");
		}
	}
    /*~[Describe=查看并可修改人员角色;InputParam=无;OutPutParam=无;]~*/
	function my_role()
	{
    	sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0)
    	{ 
		    alert("请选择一条记录！");
    	}
    	else
    	{
        	popComp("UserRole","/SystemManage/GeneralSetup/UserRole.jsp","UserID="+sUserID,"","");      	
    	}    
	}
	function my_Addrole()
	{
	    sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0)
    	{ 
		    alert("请选择一条记录！");
    	}
    	else
    	{
        	PopPage("/SystemManage/GeneralSetup/AddUserRole.jsp?UserID="+sUserID,"","dialogWidth=36;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
    	}
	}
	//初始化用户密码为1
	function ClearPassword()
	{
        sUserID = getItemValue(0,getRow(),"UserID");
        if (typeof(sUserID)=="undefined" || sUserID.length==0)
		{
		    alert("请选择一个用户！");
		}else if(confirm("该用户密码将被初始化，确定吗？")) 
		{
		    PopPage("/SystemManage/GeneralSetup/ClearPasswordAction.jsp?UserID="+sUserID,"","dialogWidth:320px;dialogHeight:270px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
		    alert("初始化用户密码成功！");
		    reloadSelf();
		}
	}
    function back()
    {
        OpenPage("/SystemManage/GeneralSetup/UserList.jsp","_self","");
    }
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
