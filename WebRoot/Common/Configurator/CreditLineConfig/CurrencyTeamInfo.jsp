<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-29 
		Tester:
		Content: 币种分组信息详情
		Input Param:
			CLTeamID：币种分组编号
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "币种分组信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数

	//获得页面参数	
	String sCLTeamID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CLTeamID"));
	if(sCLTeamID == null) sCLTeamID = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][]={ 
						{"CLTeamID","币种分组编号"},
					    {"CLTeamName","币种分组名称"},
					    {"CLTeamContentName","币种分组内容"},
					    {"CLTeamLimit","币种分组限制条件"},
					    {"CLTeamRelaObj","币种分组关联对象"},
					    {"IsInUse","是否有效"},
					    {"InputUserName","登记人"},
					    {"InputOrgName","登记机构"},
					    {"InputTime","登记时间"},
					    {"UpdateTime","更新时间"}
					    };	
	
	String sSql = " select CLTeamID,CLTeamName,CLTeamType,CLTeamContentID,CLTeamContentName,CLTeamLimit, "+
	              " CLTeamRelaObj,IsInUse,InputUser,getUserName(InputUser) as InputUserName,InputOrg, "+
	              " getOrgName(InputOrg) as InputOrgName,InputTime,UpdateUser,UpdateTime "+	             
	              " from CL_TEAM "+
	              " where CLTeamID = '"+sCLTeamID+"' ";
	              
	//根据Sql生成数据对象DataObject 
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置标题
	doTemp.setHeader(sHeaders);
	//设置表名和主键
	doTemp.UpdateTable="CL_TEAM";
	doTemp.setKey("CLTeamID",true);
	//设置下拉框显示内容
	doTemp.setDDDWCode("IsInUse","IsInUse");
	//设置必输项
   	doTemp.setRequired("CLTeamName,CLTeamContentName,IsInUse",true);
	//设置不可见项	
	doTemp.setVisible("CLTeamID,CLTeamType,CLTeamContentID,InputUser,InputOrg,UpdateUser",false);
	//设置不可更新项
	doTemp.setUpdateable("InputUserName,InputOrgName",false);
	//设置只读项
	doTemp.setReadOnly("InputUserName,InputOrgName,InputTime,UpdateTime",true);
	//设置大文本框项
	doTemp.setEditStyle("CLTeamContentName,CLTeamLimit","3");
	doTemp.setHTMLStyle("CLTeamContentName,CLTeamLimit"," style={width:400px;height:200px;overflow:auto} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
	//设置弹出式选择窗口
	doTemp.setUnit("CLTeamContentName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectCurrency();\"> ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存所有修改,并返回列表页面","saveAndGoBack()",sResourcesPath},
		{"true","","Button","保存并新增","保存并新增一条记录","saveAndNew()",sResourcesPath}
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
		//获得币种分组内容(主要是保持分行显示标志)
		sCLTeamContentName = getItemValue(0,getRow(),"CLTeamContentName");
		sCLTeamContentName.replace("/r/n","//r//n");
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();		
		as_save("myiframe0",sPostEvents);
		
	}
	
	/*~[Describe=保存所有修改,并返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function saveAndGoBack()
	{
		saveRecord("goBack()");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/Common/Configurator/CreditLineConfig/CurrencyTeamList.jsp","_self","");
	}

	/*~[Describe=保存并新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function saveAndNew()
	{
		saveRecord("newRecord()");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/CreditLineConfig/CurrencyTeamInfo.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段		
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");		
		setItemValue(0,0,"UpdateTime",sNow);
	}
	
	/*~[Describe=选择币种;InputParam=无;OutPutParam=无;]~*/
	function selectCurrency()
	{
		sReturnValue = PopPage("/Common/Configurator/CreditLineConfig/AddCurrencyDialog.jsp?CLTeamID=<%=sCLTeamID%>","","dialogWidth=35;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "@" && sReturnValue != "_none_")
		{
		 	sReturnValue = sReturnValue.split("@");		 	
		 	setItemValue(0,getRow(),"CLTeamContentID",sReturnValue[0]);
		 	setItemValue(0,getRow(),"CLTeamContentName",sReturnValue[1]);		 	
		 	
		}		
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
			setItemValue(0,0,"CLTeamType","CurrencyTeam");
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime",sNow);
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CL_TEAM";//表名
		var sColumnName = "CLTeamID";//字段名
		
		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
