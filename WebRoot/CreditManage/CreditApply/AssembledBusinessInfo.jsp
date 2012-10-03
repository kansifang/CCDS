<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2010/11/10
		Tester:
		Content: 关联委贷贷款信息
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联委贷贷款信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	
	//获得页面参数
	
	//获得页面参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sOccurType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurType"));
	String sOccurDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDate"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeAssembledNo"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sCustomerName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sOccurType == null) sOccurType = "";	
	if(sOccurDate == null) sOccurDate = "";	
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";	
	if(sCustomerName == null) sCustomerName = "";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	//String sTempletNo = "NPAReformCreationInfo";
	String sTempletNo = "AssembledBusinessInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "BUSINESS_APPLY";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")+!BusinessManage.InitializeBusiness("+sObjectType+",#SerialNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
			{"true","","Button","确认","确认新增授信申请","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消新增授信申请","doCancel()",sResourcesPath}	
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
		if("<%=sApplyType%>" == "DependentApply")
			setItemValue(0,0,"ContractFlag","1");//占用额度
		else
			setItemValue(0,0,"ContractFlag","2");//不占用额度
		sAFALoanFlag = getItemValue(0,0,"AFALoanFlag");
		if(sAFALoanFlag=="1")
		{
			if("<%=sSerialNo%>"=="") 
			{
				initSerialNo();
			}
			as_save("myiframe0",sPostEvents);	
		}else{
			doReturn();
		}
	
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
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		saveRecord("doReturn()");
	}
	
		
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sAFALoanFlag = getItemValue(0,0,"AFALoanFlag");
		sCommercialNo = getItemValue(0,0,"CommercialNo");
		sAccumulationNo = getItemValue(0,0,"AccumulationNo");
		sRelativeAssembledNo = getItemValue(0,0,"SerialNo");
		top.returnValue = sAFALoanFlag+"@"+sCommercialNo+"@"+sAccumulationNo+"@"+sRelativeAssembledNo;
		top.close();
	}
			
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录	
			//客户类型
			setItemValue(0,0,"CustomerType","03");		
			//发生类型
			setItemValue(0,0,"OccurType","<%=sOccurType%>");
			//客户ID
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			//客户名称
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			//业务品种
			setItemValue(0,0,"BusinessType","1110027");//个人住房公积金贷款
			//发生日期
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			//申请类型
			setItemValue(0,0,"ApplyType","<%=sApplyType%>");
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
			
			//暂存标志
			setItemValue(0,0,"TempSaveFlag","1");//是否标志（1：是；2：否）
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_APPLY";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "BA";//前缀
								
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
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>