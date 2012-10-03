<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: bliu 2004-12-18
		Tester:
		Describe: 用户角色1
		Input Param:
			BelongOrg：机构号
			UserID:	   用户号
		Output Param:
			
			
		HistoryLog:
		jytian 2005/01/03
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "用户角色"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量		
	String sSql = "";

	//获得页面参数
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	if(sUserID == null) sUserID = "";
	//获得组件参数
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = 	{
								{"UserID","人员编号"},
								{"UserName","人员名称"},
                                {"RoleName","角色名称"},
    	                        {"Grantor","授予人编号"},
    	                        {"GrantorName","授予人名称"},
    							{"Status","状态"},
    	    					{"BeginTime","开始日期"}
							};
   
	sSql = 	" select UserID,getUserName(UserID) as UserName,getRoleName(RoleID) as RoleName, "+
			" Grantor,getUserName(Grantor) as GrantorName,getItemName('RoleStatus',Status) as Status, "+
			" BeginTime,RoleID " +
	       	" from USER_ROLE " +
	       	" where UserID ='"+sUserID+"' "+
	       	" order by RoleID ";

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "USER_ROLE";
	
	doTemp.setKey("UserID,RoleID,Grantor,BeginTime",true);	 
	doTemp.setRequired("RoleID,BeginTime",true);
	doTemp.setAlign("BeginTime","2");	
	doTemp.setHTMLStyle("UserID,UserName,Grantor,GrantorName,Status,BeginTime"," style={width:80px} ");
	doTemp.setVisible("RoleID",false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

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

	String sButtons[][] = 	{
				{"true","","Button","新增","新增角色","newRecord()",sResourcesPath},
				{"true","","Button","详情","查看角色","viewAndEdit()",sResourcesPath},
				{"true","","Button","删除","删除该角色","deleteRecord()",sResourcesPath},
				{"true","","Button","返回","返回用户列表","goBack()",sResourcesPath}
				};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	function newRecord()
	{
		OpenPage("/SystemManage/GeneralSetup/UserRoleInfo.jsp?UserID=<%=sUserID%>","_self","");
    }   
    
    /*~[Describe=从当前机构中删除该人员;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
    {   
		sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0)
		{
			alert(getHtmlMessage('1'));
            return;
		}

        if(confirm("确定删除该角色？")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sUserID = getItemValue(0,getRow(),"UserID");
		sUserName = getItemValue(0,getRow(),"UserName");
		sRoleID = getItemValue(0,getRow(),"RoleID");
		sGrantor= getItemValue(0,getRow(),"Grantor");
		sBeginTime = getItemValue(0,getRow(),"BeginTime");
		
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/SystemManage/GeneralSetup/UserRoleInfo.jsp?UserID="+sUserID+"&RoleID="+sRoleID+"&Grantor="+sGrantor+"&BeginTime="+sBeginTime+"&UserName="+sUserName,"_self","");
		}
	}
	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
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
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
