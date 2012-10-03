<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    财务报表记录信息详情
		Input Param:
                    ObjectType：    报表记录编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
	//获得组件参数	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType==null) sObjectType="";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {
			{"ObjectType","对象类型"},
			{"ObjectName","对象类型名称"},
			{"SortNo","排序号"},
			{"TreeCode","对象树图"},
			{"PagePath","调用页面"},
			{"ObjectAttribute","对象属性"},
			{"ObjectTable","对应数据表"},
			{"KeyCol","关键字段"},
			{"KeyColName","名称字段"},
			{"ViewType","对象视图组"},
			{"DefaultView","默认视图"},
			{"RightType","权限方法"},
			{"UsageDescribe","用途说明"},
			{"Attribute1","属性一"},
			{"Attribute2","属性二"},
			{"Attribute3","属性三"},
			{"Remark","备注"},
			{"CatalogSQL","导出列示SQL"},
			{"CatalogWhere1","导出列示UpdateTime Start条件子句"},
			{"CatalogWhere2","导出列示UpdateTime End条件子句"},
			{"CatalogWhere3","导出列示UpdateUser条件子句"},
			{"InputUserName","登记人"},
			{"InputUser","登记人"},
			{"InputOrgName","登记机构"},
			{"InputOrg","登记机构"},
			{"InputTime","登记时间"},
			{"UpdateUserName","更新人"},
			{"UpdateUser","更新人"},
			{"UpdateTime","更新时间"},
	};
	sSql = "select "+
			"ObjectType,"+
			"ObjectName,"+
			"SortNo,"+
			"TreeCode,"+
			"PagePath,"+
			"ObjectAttribute,"+
			"ObjectTable,"+
			"KeyCol,"+
			"KeyColName,"+
			"ViewType,"+
			"DefaultView,"+
			"RightType,"+
			"UsageDescribe,"+
			"Attribute1,"+
			"Attribute2,"+
			"Attribute3,"+
			"CatalogSQL,"+
			"CatalogWhere1,"+
			"CatalogWhere2,"+
			"CatalogWhere3,"+
			"Remark,"+
			"getUserName(InputUser) as InputUserName,"+
			"InputUser,"+
			"getOrgName(InputOrg) as InputOrgName,"+
			"InputOrg,"+
			"InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,"+
			"UpdateUser,"+
			"UpdateTime "+
		  	"from OBJECTTYPE_CATALOG Where ObjectType = '" +sObjectType+ "' order by ObjectType";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "OBJECTTYPE_CATALOG";
	doTemp.setKey("ObjectType,ObjectName",true);
	doTemp.setHeader(sHeaders);
	doTemp.setEditStyle("CatalogSQL,CatalogWhere1,CatalogWhere2,CatalogWhere3,Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Remark",200);

 	doTemp.setHTMLStyle("PagePath,ObjectAttribute,ObjectTable"," style={width:300px} ");
 	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:90px} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
	doTemp.setReadOnly("InputUser,UpdateUser,InputOrg,InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
  
	//filter过滤条件
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
        	// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回代码列表","doReturn('Y')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    var sCurObjectType=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
 		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","");
        
	}
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
 		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","doReturn('Y');");
        
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
	        as_save("myiframe0","newRecord()");
        
	}
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ObjectType");
	        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
	        OpenComp("ObjTypeCatalogInfo","/Common/Configurator/ObjectManage/ObjTypeCatalogInfo.jsp","","_self","");
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function initRow(){
	if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
	{
		as_add("myiframe0");//新增记录
		setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	bIsInsert = true;
	}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
