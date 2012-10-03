<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2009/09/21
		Tester:
		Content: 不良资产日常管理监控报告详情
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
	String PG_TITLE = "不良资产日常管理监控报告详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量 是否可编辑
	String sEditRight="02";//默认不可编辑
	//合同编号、客户ID,客户名称,合同号
	String  sCustomerID = "",sCustomerName = "",sContractSerialNo = "";
	String sBusinessType = "",sBusinessCurrency = "",sOriginalPutoutDate = "";
	String sMaturity = "",sReportType = "",sBadType = "";
	double dBalance = 0.00,dInterestBalance1 = 0.00,dInterestBalance2 = 0.00;
	//获取数据
	//定义数据集
	String sSql="";
	ASResultSet rs=null;
	
	//获得组件参数	
	
	//获得页面参数:自身流水号,还款流水号,树图节点
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo")); 
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 
	String sDealType =  DataConvert.toRealString(iPostChange,(String)request.getParameter("DealType")); 
	String sFinishDate =  DataConvert.toRealString(iPostChange,(String)request.getParameter("FinishDate")); 
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sDealType == null) sDealType = "";
	if(sFinishDate == null) sFinishDate = "";
	//获取合同相关信息
	sSql =  "  select SerialNo,CustomerID,"+
			 " CustomerName,BusinessType,BusinessCurrency,"+
			 " Balance,InterestBalance1,InterestBalance2,"+
			 " OriginalPutoutDate,Maturity "+
	   	 	 " from BUSINESS_CONTRACT  "+
	         " where SerialNo ='"+sObjectNo+"' ";     
   	rs = Sqlca.getASResultSet(sSql);   	
   	if(rs.next())
	 {
   		sContractSerialNo = DataConvert.toString(rs.getString("SerialNo"));
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
		sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
		sBusinessCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
		dBalance = rs.getDouble("Balance");
		dInterestBalance1 = rs.getDouble("InterestBalance1");
		dInterestBalance2 = rs.getDouble("InterestBalance2");
		sOriginalPutoutDate = DataConvert.toString(rs.getString("OriginalPutoutDate"));
		sMaturity = DataConvert.toString(rs.getString("Maturity"));
	}
	rs.getStatement().close();
	//取报告类型:
	if(sDealType.length()>=12){
		//账面,股经置换,央行票据置换,已核销不良
		if(sDealType.substring(0,9).equals("020030010"))
		{  
		    sBadType="010";
		}else if(sDealType.substring(0,9).equals("020030020"))
		{
			sBadType="020";
		}else if(sDealType.substring(0,9).equals("020030030"))
		{
			sBadType="030";
		}else if(sDealType.substring(0,9).equals("020030040"))
		{
			sBadType="040";
		}
		//一般监控,重点监控
		if(sDealType.substring(9,12).equals("010"))
		{
			sReportType="010";
		}else if(sDealType.substring(9,12).equals("020")){
			sReportType="020";
		}
	}
	//编辑权限
	if(sDealType.equals("020030010010010")||sDealType.equals("020030010020010")||
			sDealType.equals("020030020010010")||sDealType.equals("020030020020010")||
			sDealType.equals("020030030010010")||sDealType.equals("020030030020010")||
			sDealType.equals("020030040010010")||sDealType.equals("020030040020010"))
	{	
		if(sFinishDate.equals("")||sFinishDate == null) //未生效
		sEditRight="01";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "MonitorReportInfo";
	if(sDealType.equals("020030040010010")||sDealType.equals("020030040010020"))//核销不良贷款使用核销监控报告模板
	{
		sTempletNo = "MonitorReportInfo1";
	}
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
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/MonitorReportList.jsp","_self","");
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
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");//客户ID
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");//客户名称
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");//合同编号
			setItemValue(0,0,"ReportType","<%=sReportType%>");//报告类型
			setItemValue(0,0,"BadType","<%=sBadType%>");//不良类型
			setItemValue(0,0,"ReportDate","<%=StringFunction.getToday()%>");//报告日期
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");//客户ID
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");//客户名称
			setItemValue(0,0,"ContractSerialNo","<%=sContractSerialNo%>");//合同编号
			setItemValue(0,0,"BusinessType","<%=sBusinessType%>");//业务品种
			setItemValue(0,0,"BusinessCurrency","<%=sBusinessCurrency%>");//币种
			setItemValue(0,0,"Balance","<%=dBalance%>");//贷款本金余额
			setItemValue(0,0,"InterestBalance1","<%=dInterestBalance1%>");//表内欠息
			setItemValue(0,0,"InterestBalance2","<%=dInterestBalance2%>");//表外欠息
			if("<%=sDealType%>"=="020030040010010"||"<%=sDealType%>"=="020030040010020")//核销相关信息录入
			{
				setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
				setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
				setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
				setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			}else
			{
				setItemValue(0,0,"RecoveryUserID","<%=CurUser.UserID%>");
				setItemValue(0,0,"RecoveryUserName","<%=CurUser.UserName%>");
				setItemValue(0,0,"RecoveryOrgID","<%=CurOrg.OrgID%>");
				setItemValue(0,0,"RecoveryOrgName","<%=CurOrg.OrgName%>");
			}
		}		
    }
    
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "MONITOR_REPORT";//表名
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
