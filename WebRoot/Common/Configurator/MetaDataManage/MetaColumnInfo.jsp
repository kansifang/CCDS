<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   CYHui  2003.8.18
			Tester:
			Content: 企业债券发行信息_List
			Input Param:
		                CustomerID：客户编号
		                CustomerRight:权限代码----01查看权，02维护权，03超级维护权
			Output param:
			                CustomerID：当前客户对象的客户号
			              	Issuedate:发行日期
			              	BondType:债券类型
			                CustomerRight:权限代码
			                EditRight:编辑权限代码----01查看权，02编辑权
			History Log: 
			                 2003.08.20 CYHui
			                 2003.08.28 CYHui
			                 2003.09.08 CYHui 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql;
	//获得组件参数

	//获得页面参数	
	String sDatabaseID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DatabaseID"));
	String sTableID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TableID"));
	String sColumnID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColumnID"));
	if(sDatabaseID==null) sDatabaseID="";
	if(sTableID==null) sTableID="";
	if(sColumnID==null) sColumnID="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		//通过显示模版产生ASDataObject对象doTemp
	   	String sHeaders[][] = {
			{"DatabaseID","数据库ID"},	
			{"TableID","表ID"},
			{"ColID","字段名"},
			{"ColName","字段中文名"},
			{"IsInUse","有效"},
			{"SortNo","排序号"},
			{"ColType","字段类型"},
			{"DomainID","域类型"},
			{"DefaultValue","缺省值"},
			{"CheckFormat","检查格式"},
			{"ValidationType","校验类型"},
			{"ValidationCode","校验代码"},
			{"ColLimit","长度限制"},
			{"ColKey","是否关键字"},
			{"IsForeignKey","是否外键"},
			{"DataPrecision","有效位数"},
			{"DataScale","小数点后位数"},
			{"Attribute1","属性1"},
			{"Attribute2","属性2"},
			{"Attribute3","属性3"},
			{"Attribute4","属性4"},
			{"Attribute5","属性5"},
		       };  

		sSql = " Select  "+
			"DatabaseID,"+
			"TableID,"+
			"ColID,"+
			"ColName,"+
			"IsInUse,"+
			"SortNo,"+
			"ColType,"+
			"DomainID,"+
			"DefaultValue,"+
			"CheckFormat,"+
			"ValidationType,"+
			"ValidationCode,"+
			"ColLimit,"+
			"ColKey,"+
			"IsForeignKey,"+
			"DataPrecision,"+
			"DataScale,"+
			"Attribute1,"+
			"Attribute2,"+
			"Attribute3,"+
			"Attribute4,"+
			"Attribute5 "+
			"From META_COLUMN Where DatabaseID='"+sDatabaseID+"' and TableID='"+sTableID+"' and ColID='"+sColumnID+"'";
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.UpdateTable="META_COLUMN";
		doTemp.setKey("DatabaseID,TableID,ColID",true);
		doTemp.setHeader(sHeaders);

		//必输项
	 	doTemp.setRequired("DatabaseID,TableID,ColID,ColName",true);

		doTemp.setDDDWCode("IsInUse","IsInUse");
		doTemp.setDDDWSql("DatabaseID","select distinct DatabaseID,DatabaseName from META_DATABASE");
		doTemp.setDDDWSql("TableID","select distinct TableID,TableName from META_TABLE");

		doTemp.setHTMLStyle("DatabaseID"," style={width:360px} ");
		doTemp.setHTMLStyle("TableID"," style={width:360px} ");
		doTemp.setHTMLStyle("ColID"," style={width:360px} ");
		doTemp.setHTMLStyle("ColName"," style={width:360px} ");
		doTemp.setHTMLStyle("IsInUse"," style={width:360px} ");
		doTemp.setHTMLStyle("SortNo"," style={width:360px} ");
		doTemp.setHTMLStyle("ColType"," style={width:360px} ");
		doTemp.setHTMLStyle("DomainID"," style={width:360px} ");
		doTemp.setHTMLStyle("DefaultValue"," style={width:360px} ");
		doTemp.setHTMLStyle("CheckFormat"," style={width:360px} ");
		doTemp.setHTMLStyle("ValidationType"," style={width:360px} ");
		doTemp.setHTMLStyle("ValidationCode"," style={width:360px} ");
		doTemp.setHTMLStyle("ColLimit"," style={width:360px} ");
		doTemp.setHTMLStyle("ColKey"," style={width:360px} ");
		doTemp.setHTMLStyle("IsForeignKey"," style={width:360px} ");
		doTemp.setHTMLStyle("DataPrecision"," style={width:360px} ");
		doTemp.setHTMLStyle("DataScale"," style={width:360px} ");
		doTemp.setHTMLStyle("Attribute1"," style={width:260px} ");
		doTemp.setHTMLStyle("Attribute2"," style={width:260px} ");
		doTemp.setHTMLStyle("Attribute3"," style={width:260px} ");
		doTemp.setHTMLStyle("Attribute4"," style={width:260px} ");
		doTemp.setHTMLStyle("Attribute5"," style={width:260px} ");

		//设置小数显示状态,
		doTemp.setAlign("DataPrecision,DataScale","3");
		doTemp.setType("DataPrecision,DataScale","Number");
		//小数为2，整数为5
		doTemp.setCheckFormat("DataPrecision,DataScale","2");

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sDatabaseID+","+sTableID+","+sColumnID);
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
			// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
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
		self.close();
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

	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/Frame/CodeExamples/ExampleInfo.jsp","_self","");
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
