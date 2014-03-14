<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cyyu 2009-03-23
			Tester:
			Content:  主菜单项目信息详情
			Input Param:
	                    ItemNo：    代码表编号
	 		Output param:
			                
			History Log: 
	            
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "应用"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
	//获得组件参数	
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));
	if(sItemNo==null) sItemNo="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = {
	{"CodeNo","代码编号"},
	{"ItemNo","项目编号"},
	{"ItemName","项目名称"},
	{"SortNo","排序号"},
	{"IsInUse","是否可用"},
	{"ItemDescribe","项目描述"},
	{"ItemAttribute","项目属性"},
	{"RelativeCode","关联代码"},
	{"Attribute1","属性1"},
	{"Attribute2","属性2"},
	{"Attribute3","属性3"},
	{"Attribute4","属性4"},
	{"Attribute5","属性5"},
	{"Attribute6","属性6"},
	{"Attribute7","属性7"},
	{"Attribute8","属性8"},
	{"HelpText","帮助"},
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
	
	sSql = 	" select CodeNo,ItemNo,ItemName,SortNo,IsInUse," +
	" ItemDescribe,ItemAttribute,RelativeCode," +
	" Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8," +
	" HelpText,Remark," + 
	" getUserName(InputUser) as InputUserName,InputUser," + 
	" getOrgName(InputOrg) as InputOrgName,InputOrg," +
	" getUserName(UpdateUser) as UpdateUserName,UpdateUser," +
	" InputTime,UpdateTime " +
	" from CODE_LIBRARY " +
	" where CodeNo='MainMenu' " + 
	" and ItemNo='" + sItemNo + "'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CODE_LIBRARY";
	doTemp.setKey("CodeNo,ItemNo",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setUnit("RelativeCode"," <input class=\"inputdate\" type=button value=\"...\" onClick=parent.selectRight()> ");
	doTemp.setReadOnly("RelativeCode,InputUserName,InputOrgName,UpdateUserName,InputTime,UpdateTime",true);
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
	
  	doTemp.setVisible("CodeNo,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8,InputUser,UpdateUser,InputOrg",false);    	
	doTemp.setDDDWCode("IsInUse","IsInUse");
 	doTemp.setEditStyle("ItemDescribe,HelpText,Remark","3");
 	doTemp.setDefaultValue("IsInUse","1");
 	doTemp.setRequired("ItemNo,SortNo,IsInUse,RelativeCode",true);

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
		String sButtons[][] = {
			{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回代码列表","doReturn()",sResourcesPath}
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
    var sCurItemID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		setItemValue(0,0,"CodeNo","MainMenu");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","doReturn();");
	}
    
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function doReturn(){
		OpenPage("/Common/Configurator/MainMenuManage/MainMenuList.jsp","_self","");
	}
    
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	
	function selectRight()
	{
		sItemNo = getItemValue(0,getRow(),"ItemNo");
		sItemName = getItemValue(0,getRow(),"ItemName");
		sRelativeCode = getItemValue(0,getRow(),"RelativeCode");
		sReturn = PopComp("SelectRoleRight","/Common/Configurator/MainMenuManage/UserRoleList.jsp","ItemNo="+sItemNo+"&ItemName="+sItemName+"&RelativeCode="+sRelativeCode,"");
		if(typeof(sReturn) != "undefind" && sReturn.length != 0)
		{
			setItemValue(0,getRow(),"RelativeCode",sReturn);
		}
	}
	
	function initRow()
	{
		
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
	initRow();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
