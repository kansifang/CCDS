<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2009/09/25
		Tester:
		Content: 抵债资产日常监控管理维护详情
		Input Param:
			sObjectNo    :对象类型(组件参数)
			sSerialNo    :取流水号
			DealType:树图节点号
		Output param:

		History Log: 

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产日常监控管理维护详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量 是否可编辑
	String sEditRight = "02";//默认不可编辑
	//抵债资产类型,资产名称,资产规格
	String sAssetType = "",sAssetName = "",sAccountDescribe = "",sAssetTypeName = "";
	//定义数据集
	String sSql="";
	ASResultSet rs=null;
	
	//获得组件参数	
	
	//获得页面参数:自身流水号,还款流水号,树图节点,完成时间,打开标记
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo")); 
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 
	String sDealType =  DataConvert.toRealString(iPostChange,(String)request.getParameter("DealType")); 
	String sFinishDate =  DataConvert.toRealString(iPostChange,(String)request.getParameter("FinishDate")); 
	String sOpenFlag =  DataConvert.toRealString(iPostChange,(String)request.getParameter("OpenFlag")); 
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sDealType == null) sDealType = "";
	if(sFinishDate == null) sFinishDate = "";
	if(sOpenFlag == null) sOpenFlag = "";
	
	//编辑权限
	if(sDealType.equals("020010020"))
	{	
		if(sFinishDate.equals("")||sFinishDate == null) //未生效
		sEditRight="01";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//获取抵债资产相关信息
	sSql =  "  select AssetType,getItemName('PDAAssetType',AssetType) as AssetTypeName,AssetName,AccountDescribe "+
	   	 	 " from ASSET_INFO  "+
	         " where SerialNo ='"+sObjectNo+"' ";     
   	rs = Sqlca.getASResultSet(sSql);   	
   	if(rs.next())
	{
   		sAssetType = DataConvert.toString(rs.getString("AssetType"));
   		sAssetTypeName = DataConvert.toString(rs.getString("AssetTypeName"));
		sAssetName = DataConvert.toString(rs.getString("AssetName"));
		sAccountDescribe = DataConvert.toString(rs.getString("AccountDescribe"));
	}
   	rs.getStatement().close();
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "VindicateReportInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
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
		{sEditRight.equals("01")?"true":"flase","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
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
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		if("<%=sOpenFlag%>" == "1")
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAssetList.jsp","_self","");
		}else
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/VindicateReportList.jsp","_self","");
		}
	}
	
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script language=javascript>

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{		
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");//以资抵债编号
			setItemValue(0,0,"ReportType","010");//报告类型
			setItemValue(0,0,"ReportDate","<%=StringFunction.getToday()%>");//报告日期
			setItemValue(0,0,"AssetType","<%=sAssetType%>");//资产类型
			setItemValue(0,0,"AssetTypeName","<%=sAssetTypeName%>");//资产类型名称
			setItemValue(0,0,"AssetName","<%=sAssetName%>");//资产名称
			setItemValue(0,0,"AccountDescribe","<%=sAccountDescribe%>");//资产规格	
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			
		}		
    }
    
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSET_REPORT";//表名
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
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
