<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: wwhe	2008-04-19
			Tester:
			Describe: 授权条件定义
			Input Param:
					ObjectNo:	授权方案编号
					MethodType:	控制条件类型
			Output Param:
			HistoryLog: 
				 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "授权条件定义"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	ASResultSet rs = null;//--查询结果集
	String sSql = "";
	
	//获得页面参数
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sMethodType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MethodType"));
	String sMethodName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MethodName"));
	
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sMethodType == null) sMethodType = "";
	if(sMethodName == null) sMethodName = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"ObjectNo","授权方案编号"},
						{"MethodType","控制条件类型"},
						{"MethodDescribe","控制条件说明"},
						{"ClassName","调用类方法类名"},
						{"MethodName","调用类方法方法名"},
						{"MethodStatus","状态"},
						{"InputDate","登记日期"},
						{"Remark","备注"},
						{"InputOrgName","录入机构"},
						{"InputUserName","录入人员"}
		   				};		   		
		
		sSql =  " select SerialNo,ObjectNo,MethodType,MethodDescribe,ClassName,MethodName,MethodStatus, "+
		" InputDate,InputOrgID,InputUserID, "+
		" getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,Remark"+
		" from AUTHORIZE_METHOD "+
		" where ObjectNo = '"+sObjectNo+"' "+
		" and MethodName = '"+sMethodName+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		
		doTemp.UpdateTable = "AUTHORIZE_METHOD";
		doTemp.setKey("SerialNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName",false);
		//doTemp.setDDDWCode("MethodType","AuthorizeMethodType");
		doTemp.setDDDWSql("MethodType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeMethodType' and ItemNo <> '01'");
		doTemp.setDDDWCode("MethodStatus","IsInUse");
		doTemp.setDDDWSql("MethodName","select MethodName,MethodName from Class_Method where ClassName = '授权管理'");
		doTemp.setReadOnly("SerialNo,ObjectNo,ClassName,InputDate,InputOrgName,InputUserName",true);
		doTemp.setVisible("SerialNo,InputOrgID,InputUserID,MethodType",false);
		doTemp.setRequired("ClassName,MethodName,MethodStatus",true);
		doTemp.setCheckFormat("InputDate","3");
		doTemp.setEditStyle("Remark,MethodDescribe","3");
		doTemp.setHTMLStyle("Remark,MethodDescribe"," style={height:100px;width:400px} ");
		doTemp.setHTMLStyle("ClassName,MethodName","style={width:200px}");
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置为Grid风格
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{"true","","Button","保存","保存信息","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","goBack()",sResourcesPath}
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
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{		
		if(bIsInsert){		
			beforeInsert();
		}

		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeControlList.jsp?SerialNo=<%=sObjectNo%>","_self","");
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "AUTHORIZE_METHOD";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "AM";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{	
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"ClassName","授权管理");

			bIsInsert = true;
		}
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
	initRow();
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
