<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   zywei 2005-11-28
		Tester:
		Content: 查询树型信息详情
		Input Param:
               SelName：查询名称
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
	
	//获得页面参数	
	String sSelName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	if(sSelName == null) sSelName = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
   	String sHeaders[][] = {
				{"SelName","查询名称"},
				{"SelDescribe","查询说明"},
				{"SelType","查询类型"},
				{"SelTableName","查询表名"},
				{"SelPrimaryKey","主键"},
				{"SelBrowseMode","展现方式"},
				{"SelArgs","参数"},
				{"SelHideField","ID字段"},
				{"SelFieldDisp","Name字段"},	
				{"SelFieldName","Value字段"},			
				{"SelCode","From子句"},	
				{"SelReturnValue","返回域"},
				{"SelFilterField","OrderBy子句"},
				{"MutilOrSingle","选择模式"},
				{"Attribute1","展开节点值"},
				{"Attribute2","页节点是否可选"},
				{"IsInUse","是否有效"},
				{"Remark","备注"},
				{"InputUserName","输入人"},
				{"InputUser","输入人"},
				{"InputOrgName","输入机构"},
				{"InputOrg","输入机构"},
				{"InputTime","输入时间"},
				{"UpdateUserName","更新人"},
				{"UpdateUser","更新人"},
				{"UpdateTime","更新时间"}
			   };  

	String sSql = 	" Select SelName,SelDescribe,SelType,SelTableName,SelPrimaryKey,SelBrowseMode, "+
					" SelArgs,SelHideField,SelFieldDisp,SelFieldName,SelCode,SelReturnValue, "+
					" SelFilterField,MutilOrSingle,Attribute1,Attribute2,IsInUse,Remark, "+
					" getUserName(InputUser) as InputUserName,InputUser,InputOrg, "+
					" getOrgName(InputOrg) as InputOrgName,InputTime,UpdateUser, "+
					" getUserName(UpdateUser) as UpdateUserName,UpdateTime "+
					" From SELECT_CATALOG " +
					" Where SelName = '" + sSelName +"' ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="SELECT_CATALOG";
	doTemp.setKey("SelName",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setDDDWCode("Attribute2","YesNo");
	doTemp.setDDDWCode("IsInUse","IsInUse");
	doTemp.setHTMLStyle("SelDescribe,SelArgs,SelFieldName,SelReturnValue"," style={width:400px} ");
	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setEditStyle("SelCode,Remark","3");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
	doTemp.setHTMLStyle("SelCode,Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Remark",120);
	doTemp.setReadOnly("SelType,SelBrowseMode,MutilOrSingle,InputUserName,InputOrgName,UpdateUserName,InputTime,UpdateTime",true);
 	doTemp.setRequired("SelName,SelDescribe,SelHideField,SelFieldDisp,SelFieldName,SelCode,SelFilterField,SelReturnValue,IsInUse",true);
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
  			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSelName);
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
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    var sCurClassName=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndReturn()
	{
        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn();");        
	}
    
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","newRecord()");
	}

    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(){
		OpenPage("/Common/Configurator/SelectManage/TreeViewSelectList.jsp","_self","");
	}
    
    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{	        
		OpenPage("/Common/Configurator/SelectManage/TreeViewSelectInfo.jsp","_self","");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录		
			setItemValue(0,0,"SelType","Sql");
			setItemValue(0,0,"SelBrowseMode","TreeView");
			setItemValue(0,0,"MutilOrSingle","Single");
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