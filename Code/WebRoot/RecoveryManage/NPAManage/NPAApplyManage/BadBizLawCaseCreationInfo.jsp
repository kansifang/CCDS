<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  	xhyong 2009/09/11
		Tester:
		Content: 创建诉讼案件申请
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
			PhaseType：阶段类型
			FlowNo：流程号
			PhaseNo：阶段号		
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "创建诉讼案件申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sObjectNo == null ) sObjectNo = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "BadBizLawCaseCreationInfo";
	
	//根据模板编号设置数据对象	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","确认","确认新增诉讼案件详情","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消新增诉讼案件详情","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{	
		initSerialNo();
		as_save("myiframe0",sPostEvents);
	}
		   
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{			
		sCustomerType = getItemValue(0,0,"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert(getBusinessMessage('225'));//请先选择客户类型！
			return;
		}
		//具有业务申办权的客户信息
		sParaString = "CustomerType"+","+sCustomerType;
		setObjectValue("SelectApplyCustomer6",sParaString,"@LawCaseOrgID@0@LawCaseOrg@1",0,0,"");
	}
	
	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		saveRecord("doReturn()");
	}
	
	/*~[Describe=确认新增不良业务申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){	
		top.returnValue = "true";
		top.close();
	}
		
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录	
			//关联对象类型
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");		
			//关联对象编号
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");		
			//申请日期
			setItemValue(0,0,"ApplyDate","<%=StringFunction.getToday()%>");		
			//经办机构
			setItemValue(0,0,"OperateOrgID","<%=CurUser.OrgID%>");
			//经办人
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			//经办日期
			setItemValue(0,0,"OperateDate","<%=StringFunction.getToday()%>");
			//登记机构
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			//登记人
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			//登记日期			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//更新日期
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "LAWCASE_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
								
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