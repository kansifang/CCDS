<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: wwhe	2008-04-19
			Tester:
			Describe: 授权方案定义
			Input Param:
					SerialNo:	流水号
					Type:		Precept(授权方案定义)
								Condition(授权条件定义)
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
		String PG_TITLE = "授权方案定义"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sType == null) sType = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"SerialNo","授权方案编号"},
						{"AuthorizeClass","授权方案优先级"},
						{"AuthorizeName","授权方案名称"},
						{"AuthorizeDescribe","授权方案描述"},
						{"BeginDate","启用日期"},
						{"EndDate","终结日期"},
						{"Remark","备注"},
						{"InputOrgName","录入机构"},
						{"InputUserName","录入人员"},
						{"AuthorizeStatus","授权状态"},
						{"InputDate","登记日期"},
						{"AuthorizeType","授权类型"}
		   				};		   		
		
		sSql =  " select SerialNo,AuthorizeClass,AuthorizeName,AuthorizeDescribe,AuthorizeType,BeginDate,EndDate,AuthorizeStatus,InputOrgID,InputUserID, "+
		" Remark,InputDate,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName "+
		" from AUTHORIZE_ROLE "+
		" where SerialNo = '"+sSerialNo+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		
		doTemp.UpdateTable = "AUTHORIZE_ROLE";
		doTemp.setKey("SerialNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName",false);
		doTemp.setReadOnly("SerialNo,InputOrgName,InputUserName,InputDate",true);
		doTemp.setRequired("AuthorizeClass,AuthorizeName,AuthorizeDescribe,BeginDate,EndDate,AuthorizeStatus",true);
		doTemp.setVisible("InputOrgID,InputUserID,AuthorizeType",false);
		doTemp.setCheckFormat("BeginDate,EndDate,InputDate","3");
		doTemp.setEditStyle("Remark,AuthorizeDescribe","3");
		doTemp.setDDDWCode("AuthorizeStatus","IsInUse");
		doTemp.setDDDWCode("AuthorizeType","AuthorizeType");
		doTemp.setHTMLStyle("Remark,AuthorizeDescribe"," style={height:100px;width:400px} ");
		doTemp.setHTMLStyle("AuthorizeName"," style={width:250px} ");
		doTemp.setCheckFormat("AuthorizeClass","5");
		doTemp.setHTMLStyle("AuthorizeClass"," style={width:30px} ");
		
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
			{(sType.equals("Precept")?"true":"false"),"","Button","保存","保存信息","saveRecord()",sResourcesPath},
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

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizePreceptList.jsp","_self","");
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
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "AUTHORIZE_ROLE";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "AR";//前缀

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
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");

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
