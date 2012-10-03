<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: fxie 2005-2-18 
		Tester:
		Describe: 用户角色信息
		Input Param:
			BelongOrg：机构号
			UserID:	   用户号
		Output Param:
			CustomerID：当前客户编号

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "用户情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数	
	String sUserID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sRoleID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RoleID"));
	String sGrantor   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grantor"));
	String sBeginTime = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BeginTime"));

	if(sRoleID == null ) sRoleID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%       
    String sTempletNo = "UserRoleInfo";
	String sTempletFilter = "1=1";
	String sWhere = "";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable="USER_ROLE";
	//设置关键字
	doTemp.setKey("UserID,RoleID",true);
	//取得人员所在机构的级别
	String sOrgLevel = Sqlca.getString("select OrgLevel from ORG_INFO where OrgID ='"+CurOrg.OrgID+"' ");
	if(sOrgLevel.equals("0")) //总行人员配置角色
	   sWhere = " where length(roleid)>1 ";	
	else if(sOrgLevel.equals("3")) //分行人员配置角色
	   sWhere = " where roleid not like '0%' and length(roleid)>1  ";	
	else if(sOrgLevel.equals("6")) //支行人员配置角色
	    sWhere = " where (roleid like '4%' or roleid like '8%')  and length(roleid)>1 ";
    
    //新增时需排除用户已存在的角色
    if(sRoleID.equals(""))
		sWhere += " and roleid not in (select roleid from user_role where userid='"+sUserID+"')";

	//设置下拉框来源
	doTemp.setDDDWSql("RoleID","select RoleID,RoleID||' '||RoleName from Role_Info "+sWhere);	
   
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly="0";
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sRoleID+","+sGrantor+","+sBeginTime);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/GeneralSetup/UserRole.jsp?UserID=<%=sUserID%>","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%> <%=StringFunction.getNow()%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0"); //新增记录
			setItemValue(0,0,"UserID","<%=sUserID%>");
			setItemValue(0,0,"BeginTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Status","1");		
			setItemValue(0,0,"Grantor","<%=CurUser.UserID%>");
			setItemValue(0,0,"GrantorName","<%=CurUser.UserName%>");	
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%> <%=StringFunction.getNow()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%> <%=StringFunction.getNow()%>");
			
			bIsInsert = true;
		}		
    }
    
    /*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser()
	{			
		setObjectValue("SelectAllUser","","@Grantor@0@GrantorName@1",0,0,"");
	}
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
