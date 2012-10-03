
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2005/08/29
		Tester:
		Content: 授权点基本信息页面
		Input Param:
			PolicyID：授权方案ID
			FlowNo：流程号
			PhaseNo：阶段号
			AuthID：授权点ID
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权点信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","300");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数

	//获得页面参数	
	String sPolicyID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PolicyID"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sAuthID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthID"));
	//将空值转化为空字符串
	if(sPolicyID == null) sPolicyID = "";
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sAuthID == null) sAuthID = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//获取流程名称
	String sFlowName = Sqlca.getString("select FlowName from FLOW_CATALOG where FlowNo = '"+sFlowNo+"'");
	String sPhaseName = Sqlca.getString("select PhaseName from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'");
	//将空值转化为空字符串
	if(sFlowName == null) sFlowName = "";
	if(sPhaseName == null) sPhaseName = "";
	
	String[][] sHeaders = {							
							{"PolicyName","授权方案"},
							{"SortNo","排序号"},
							{"FlowName","流程"},
							{"PhaseName","阶段"},							
							{"OrgName","机构"},							
							{"ProductName","产品"},							
							{"GuarantyTypeName","担保方式"},
							{"EffDate","启用日期"},
							{"EffStatus","生效状态"},
							{"BizBalanceCeiling","终批单笔金额上限（元）"},
							{"BizExposureCeiling","终批单笔敞口授权上限（元）"},
							{"CustBalanceCeiling","终批单户金额授权上限（元）"},
							{"CustExposureCeilin","终批单户敞口授权上限（元）"},
							{"InterestRateFloor","终批利率下限（%）"}
						};
	String sSql = 	" select AuthID,PolicyID, "+
					" SortNo,FlowNo,getFlowName(FlowNo) as FlowName,PhaseNo, "+
					" getPhaseName(FlowNo,PhaseNo) as PhaseName, "+
					" OrgID,getOrgName(OrgID) as OrgName,ProductID, "+
					" getBusinessName(ProductID) as ProductName,GuarantyType, "+
					" getItemName('VouchType',GuarantyType) as GuarantyTypeName, "+
					" EffDate,EffStatus,BizBalanceCeiling,BizExposureCeiling, "+
					" CustBalanceCeiling,CustExposureCeilin,InterestRateFloor, "+
					" InputUser,InputTime, "+
					" UpdateUser,UpdateTime "+
					" from AA_AUTHPOINT "+
					" where AuthID = '"+sAuthID+"' "+
					" and PolicyID = '"+sPolicyID+"' ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_AUTHPOINT";
	doTemp.setKey("AuthID",true);	
	doTemp.setHeader(sHeaders);
	//设置不可见
	doTemp.setVisible("AuthID,PolicyID,FlowNo,PhaseNo,OrgLevel,OrgID,ProductID,GuarantyType,InputUser,InputTime,UpdateUser,UpdateTime",false);
	//设置下拉框（代码）
	//add by hxd in 2005/11/29
	doTemp.setDDDWCode("EffStatus","EffStatus");
	//doTemp.setHRadioCode("EffStatus","EffStatus");
	//doTemp.setVRadioCode("EffStatus","EffStatus");
	//doTemp.setPopCode("EffStatus","EffStatus");
		
	//设置下拉框（SQl）
	//doTemp.setDDDWSql("GuarantyCategory","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and length(ItemNo)=3 and ItemNo <>'000' and IsInUse = '1' ");
	//设置必输项
	doTemp.setRequired("PolicyName,EffDate,EffStatus",true);
	
	//设置数据输入项格式
	doTemp.setAlign("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin,InterestRateFloor","3");
	doTemp.setType("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin,InterestRateFloor","Number");
	doTemp.setCheckFormat("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin","2");
	doTemp.setCheckFormat("EffDate","3");
	doTemp.setHTMLStyle("OrgName","style={width:250px}");
	//设置不可更新
	doTemp.setUpdateable("PolicyName,FlowName,PhaseName,OrgName,ProductName,GuarantyTypeName",false);
	//设置只读
	doTemp.setReadOnly("PolicyName,FlowName,PhaseName",true);
	//设置弹出式窗口选择模式
	doTemp.setUnit("PolicyName","<input class=inputdate type=button value=\"...\" onClick=parent.getPolicyName()>");
	//doTemp.setUnit("FlowName","<input class=inputdate type=button value=\"...\" onClick=parent.getFlowName()>");
	//doTemp.setUnit("PhaseName","<input class=inputdate type=button value=\"...\" onClick=parent.getPhaseName()>");
	doTemp.setUnit("OrgName","<input class=inputdate type=button value=\"...\" onClick=parent.getOrgName()>");
	doTemp.setUnit("ProductName","<input class=inputdate type=button value=\"...\" onClick=parent.getProductName()>");
	doTemp.setUnit("GuarantyTypeName","<input class=inputdate type=button value=\"...\" onClick=parent.getGuarantyTypeName()>");
	
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","测试","测试","testAuthPoint()",sResourcesPath},
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
	function saveRecord()
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0");
		
	}	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/Common/Configurator/AAManage/AuthPointSettingList.jsp?PolicyID=<%=sPolicyID%>","_self","");
	}
	
	function testAuthPoint(){
		//授权点ID   
	    sAuthID = getItemValue(0,getRow(),"AuthID");			
		if (typeof(sAuthID) == "undefined" || sAuthID.length == 0)
		{
			alert(getBusinessMessage('001'));//请先保存审批授权信息，然后才能进行测试！
			return;
		}
		popComp("TestAuthPoint","/Common/Configurator/AAManage/AAPointTest.jsp","AuthID=<%=sAuthID%>&PolicyNo=<%=sPolicyID%>","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputTime",sNow);
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}	

	/*~[Describe=弹出授权方案选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getPolicyName(){
		sToday = "<%=StringFunction.getToday()%>";	
		sParaString = "Today,"+sToday;
		setObjectValue("SelectPolicy",sParaString,"@PolicyID@0@PolicyName@1",0,0,"");
	}
	
	/*~[Describe=弹出流程选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getFlowName(){
		setObjectValue("SelectFlow","","@FlowNo@0@FlowName@1",0,0,"");
	}
	
	/*~[Describe=弹出阶段选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getPhaseName(){
		//获得流程号
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sFlowNo) == "undefined" || sFlowNo == "")
		{
			alert(getBusinessMessage('002'));//请在选择阶段之前先选择流程！
			return;
		}
		sParaString = "FlowNo"+","+sFlowNo;
		setObjectValue("SelectPhase",sParaString,"@PhaseNo@0@PhaseName@1",0,0,"");
	}
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getOrgName(){
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
			
	/*~[Describe=弹出产品选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getProductName(){
		setObjectValue("SelectAllBusinessType","","@ProductID@0@ProductName@1",0,0,"");
	}
	
	/*~[Describe=弹出担保方式选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getGuarantyTypeName(){
		sParaString = "CodeNo"+",VouchType";		
		setObjectValue("SelectCode",sParaString,"@GuarantyType@0@GuarantyTypeName@1",0,0,"");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"FlowNo","<%=sFlowNo%>");
			setItemValue(0,0,"FlowName","<%=sFlowName%>");
			setItemValue(0,0,"PhaseNo","<%=sPhaseNo%>");
			setItemValue(0,0,"PhaseName","<%=sPhaseName%>");
			setItemValue(0,0,"PolicyID","<%=sPolicyID%>");
		}		
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "AA_AUTHPOINT";//表名
		var sColumnName = "AuthID";//字段名
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
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
	OpenPage("/Common/Configurator/AAManage/ExceptionSettingList.jsp","DetailFrame","");
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
