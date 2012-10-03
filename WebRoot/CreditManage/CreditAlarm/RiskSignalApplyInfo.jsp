<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: 预警信息_Info
		Input Param:	
			SignalType：预警类型（01：发起；02：解除）		
			SignalStatus：预警状态（10：待处理；15：待分发；20：审批中；30：批准；40：否决; 50:退回） 
			SerialNo：预警流水号    
		Output param:
		                
		History Log: 
		      bqliu 2011-06-10 调整基本信息要素           
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警发起"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
    ASResultSet rs = null;
    String sCreditLevel = "";//信用等级
    String sSumBusinessSum = "";//授信余额
	String sBailSum = "";//保证金金额
	String sSumCreditBalance = "";//敞口金额
	String sAlarmApplyDate = "";//预警报告日期
	String sPhaseNo = "";//流程阶段
	//获得组件参数		
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
    String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalStatus"));
	//将空值转化为空字符串	
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sSignalStatus == null) sSignalStatus = "";
	
	//信用等级
	sCreditLevel = Sqlca.getString("select EvaluateResult from EVALUATE_RECORD where ObjectNo = '"+sCustomerID+"'");
	if(sCreditLevel == null) sCreditLevel = "";
	
	//预警阶段
	sPhaseNo = Sqlca.getString("select PhaseNo from FLOW_OBJECT where ObjectNo = '"+sSerialNo+"' and ObjectType='RiskSignalApply'");
	
	
	//授信余额、保证金金额
	sSql = "select sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)),"+
		" sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)*BailRatio)/100 "+
	    " from BUSINESS_CONTRACT where customerID='"+sCustomerID+"'"+
	    "  and (FinishDate = '' or FinishDate is null) and BusinessType not like '3%' ";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{	
		sSumBusinessSum = DataConvert.toMoney((rs.getDouble(1)));
		sBailSum = DataConvert.toMoney((rs.getDouble(2)));
	    sSumCreditBalance = DataConvert.toMoney((rs.getDouble(1)-rs.getDouble(2)));
	    if(sSumBusinessSum == null) sSumBusinessSum="";
	    if(sBailSum == null) sBailSum="";
	    if(sSumCreditBalance == null) sSumCreditBalance="";
	}
	rs.getStatement().close();

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {							
							{"CustomerName","客户名称"},
							{"SignalLevel","预警级别"},
							{"CustomerBalance","授信余额"},
							{"BailSum","保证金金额"},
							{"CustomerOpenBalance","敞口金额"},
							{"MessageContent","预警说明"},
							{"ApproveDate","授信批准日期"},
							{"CreditLevel","信用等级"},
							{"AlarmApplyDate","预警报告日期"},
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记时间"},
							{"UpdateDate","更新时间"}
							};
		
	sSql =  " select SerialNo,ObjectType,ObjectNo,GetCustomerName(ObjectNo) as CustomerName, "+
			" SignalLevel,CustomerBalance,BailSum,CustomerOpenBalance,"+
			" MessageContent,ApproveDate,CreditLevel,AlarmApplyDate, "+
			" GetOrgName(InputOrgID) as InputOrgName,InputOrgID, "+
			" GetUserName(InputUserID) as InputUserName,InputUserID,InputDate,UpdateDate "+
			" from RISK_SIGNAL "+
			" where SerialNo = '"+sSerialNo+"' ";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("ApproveDate,AlarmApplyDate,SerialNo,ObjectType,SignalNo",false);
	
	//设置下拉框内容
	doTemp.setDDDWCode("SignalLevel","SignalLevel");
	
	//设置格式
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setEditStyle("MessageContent","3");
	doTemp.setCheckFormat("AlarmApplyDate","3");
	doTemp.setType("CustomerBalance,BailSum,CustomerOpenBalance","Number");
 	doTemp.setLimit("MessageContent",800);
 	if("3000".equals(sPhaseNo))
 	{
 		doTemp.setReadOnly("SignalLevel",true);
 	}
	doTemp.setReadOnly("ObjectNo,CustomerName,CustomerBalance,BailSum,CustomerOpenBalance,AlarmApplyDate,ApproveDate,CreditLevel,InputUserName,InputOrgName,InputDate,UpdateDate",true);
 	doTemp.setRequired("SignalLevel,CustomerName,MessageOrigin",true);
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,InputUserID,InputOrgID",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,CustomerName",false);
  	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly="0";
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//获取该批准的预警信息是否已被解除
	String sFreeFlag = "否";
	
	if(sSignalStatus.equals("30")) //批准
	{
		sSql = 	" select Count(SerialNo) from RISK_SIGNAL "+
				" where RelativeSerialNo = '"+sSerialNo+"' "+				
				" and SignalStatus = '30' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			int iCount = rs.getInt(1);
			if(iCount > 0) sFreeFlag = "是";
			else sFreeFlag = "否";		
		} 
		rs.getStatement().close();
	}
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath}
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
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

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
			setItemValue(0,0,"ObjectType","Customer");	
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}
		setItemValue(0,0,"CreditLevel","<%=sCreditLevel%>");	
		setItemValue(0,0,"CustomerBalance","<%=sSumBusinessSum%>");	
		setItemValue(0,0,"BailSum","<%=sBailSum%>");	
		setItemValue(0,0,"CustomerOpenBalance","<%=sSumCreditBalance%>");	
		setItemValue(0,0,"FreeFlag","<%=sFreeFlag%>");
		setItemValue(0,0,"AlarmApplyDate","<%=sAlarmApplyDate%>");
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