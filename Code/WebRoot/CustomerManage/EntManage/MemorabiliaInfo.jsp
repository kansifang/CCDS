<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --fbkang 2005-7-26
		Tester:
		Describe: --客户大事记
		Input Param:
			CustomerID：--当前客户编号
			SerialNo:	--流水号
			EditRight:  --编辑权限
		Output Param:
			CustomerID：--当前客户编号

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户大事记"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "CustomerMemoInfo";//--模板类型
	//获得组件参数，客户代码
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	
	//获得页面参数	，当前流水号、编辑权限
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sEditRight   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//根据客户编号获取客户类型
	String sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
	if(sCustomerType == null) sCustomerType = "";
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//设置事件类型
	if(sCustomerType.substring(0,2).equals("01")) //公司客户
		doTemp.setDDDWSql("EventType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'EventType' and ItemNo like '01%' and length(ItemNo)>2 ");
	else//个人
		doTemp.setDDDWSql("EventType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'EventType' and ItemNo like '02%' and length(ItemNo)>2 ");
    doTemp.setHTMLStyle("InputOrgName","style={width:250px}");   	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sSerialNo);
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
		{(sEditRight.equals("02")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
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
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		changeCustomerInfo();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/MemorabiliaList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=个人事记改变时,提示要改变个人信息;InputParam=无;OutPutParam=无;]~*/
	function changeCustomerInfo(){
		sEventType = getItemValue(0,0,"EventType");
		if(sEventType == "0201") 
		{
			alert("注意基本信息中进行婚姻状态修改!");
		}
		else if(sEventType == "0205"){
			alert("注意基本信息中进行健康状况修改!");
		}
	}
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/MemorabiliaInfo.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{			
		//校验发生日期是否大于当前日期
		sOccurDate = getItemValue(0,0,"OccurDate");//发生日期
		sToday = "<%=StringFunction.getToday()%>";//当前日期		
		if(typeof(sOccurDate) != "undefined" && sOccurDate != "" )
		{
			if(sOccurDate >= sToday)
			{		    
				alert(getBusinessMessage('151'));//发生日期必须早于当前日期！
				return false;		    
			}
		}
			
		return true;
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_MEMO";//--表名
		var sColumnName = "SerialNo";//--字段名
		var sPrefix = "";//--前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
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
