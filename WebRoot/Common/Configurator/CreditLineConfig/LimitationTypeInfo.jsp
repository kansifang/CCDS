<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:          cjiang    2005-8-1 23:59
			Tester:
			Content:         限制类型详情
			Input Param:     sExampleID
			Output param:
			History Log: 

		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "限制类型详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	
	//获得组件参数

	//获得页面参数	
	String sTypeID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeID"));
	if(sTypeID==null) sTypeID="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][]={ {"TypeID","限制类型ID"},
			      {"TypeName","限制类型说明"},
			      {"CheckerClass","限制检查器类名"},
			      {"LimitationExpr","限制判断Script"},
			      {"CompileCheckExpr","限额设置校验Script"},
			      {"ControlType","控制方式"},
			      {"ObjectType","限制对象类型"},
			      {"CrossUsageEnabled","是否共享"},
			      {"LimitationComp","限制项设置组件ID"},
			      {"LimitationWizard","限制项设置Wizrd"}
			    };	
	//通过显示模版产生ASDataObject对象doTemp
	String sSql="select TypeID , TypeName , CheckerClass , LimitationExpr ,"+
	             " CompileCheckExpr , ControlType , ObjectType , " +
	             " CrossUsageEnabled , LimitationComp , LimitationWizard "+
	             " from CL_LIMITATION_TYPE where TypeID='"+sTypeID+"'" ;
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="CL_LIMITATION_TYPE";
	doTemp.setKey("TypeID",true);
	doTemp.setDDDWCode("ControlType","ControlType");
	doTemp.setDDDWCode("CrossUsageEnabled","YesNo");
	doTemp.setDDDWSql("ObjectType","select ObjectType , ObjectName from  objecttype_catalog");
	doTemp.setEditStyle("LimitationExpr","3");
	doTemp.setHTMLStyle("LimitationExpr","style={height=100px;width=400px;overflow=scroll}");
	doTemp.setLimit("LimitationExpr",1600);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//ASDataWindow dwTemp = new ASDataWindow("EntList",doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/
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
		String sButtons[][] = {
			{"true","","Button","保存并返回","保存所有修改,并返回列表页面","saveAndGoBack()",sResourcesPath},
			{"true","","Button","保存并新增","保存并新增一条记录","saveAndNew()",sResourcesPath},
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
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
		if(typeof(sPostEvents)!="undefined" && sPostEvents!="") sPostEvents = "reloadCache();parent."+sPostEvents;
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
		OpenPage("/Common/Configurator/CreditLineConfig/LimitationTypeList.jsp","_self","");
	}

	/*~[Describe=保存并新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function saveAndNew()
	{
		saveRecord("newRecord()");
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>
	function reloadCache(){
    	if(confirm("您已对额度限制类型进行了修改，现在刷新额度限制类型定义缓存吗？"))
    		PopPage("/Common/ToolsB/reloadCacheConfig.jsp?ConfigName=SYSCONF_LIMITATIONTYPE","","");
    }
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/CreditLineConfig/LimitationTypeInfo.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputTime",sNow);
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}

	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser(sParam,sUserID,sUserName,sOrgID,sOrgName)
	{
		setObjectInfo("User","OrgID="+sParam+"@"+sUserID+"@0@"+sUserName+"@1@"+sOrgID+"@2@"+sOrgName+"@3",0,0);
		/*
		* setObjectInfo()函数说明：---------------------------
		* 功能： 弹出指定对象对应的查询选择对话框，并将返回的对象设置到指定DW的域
		* 返回值： 形如“ObjectID@ObjectName”的返回串，可能有多段，例如“UserID@UserName@OrgID@OrgName”
		* sObjectType： 对象类型
		* sValueString格式： 传入参数 @ ID列名 @ ID在返回串中的位置 @ Name列名 @ Name在返回串中的位置
		* iArgDW:  第几个DW，默认为0
		* iArgRow:  第几行，默认为0
		* 详情请参阅 common.js -----------------------------
		*/
	}
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectOrg(sOrgID,sIDColumn,sNameColum)
	{
		setObjectInfo("Org","OrgID="+sOrgID+"@"+sIDColumn+"@0@"+sNameColum+"@1",0,0);
		/*
		* setObjectInfo()函数说明：---------------------------
		* 功能： 弹出指定对象对应的查询选择对话框，并将返回的对象设置到指定DW的域
		* 返回值： 形如“ObjectID@ObjectName”的返回串，可能有多段，例如“UserID@UserName@OrgID@OrgName”
		* sObjectType： 对象类型
		* sValueString格式： 传入参数 @ ID列名 @ ID在返回串中的位置 @ Name列名 @ Name在返回串中的位置
		* iArgDW:  第几个DW，默认为0
		* iArgRow:  第几行，默认为0
		* 详情请参阅 common.js -----------------------------
		*/
	}
	
	function selectAgency()
	{
		alert("1");
		sReturn=selectObjectInfo("Agency","@AuditUser@0@AuditUserName@1",0,0);
		alert(sReturn);
	}
	
	/*~[Describe=弹出示例选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectExample1()
	{
		setObjectInfo("Example","@ParentExampleID@0",0,0);
	}
	function selectExample()
	{
	setObjectInfo("code","code=YesOrNo@ParentExampleID@0",0,0);
	}


	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "EXAMPLE_INFO";//表名
		var sColumnName = "ExampleID";//字段名
		var sPrefix = "EP";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
