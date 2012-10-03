<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zwhu  2010-05-31
		Tester:
		Describe: 不良贷款台帐申请详情;
		Input Param:

		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良贷款台帐详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "";//--模板号码
	String sSql = "";//Sql语句
	ASResultSet rs = null;//结果集
	String sPhaseNo="";
	String sEditRight="";
	//获得页面参数：
	//将空值转化为空字符串
	//获得组件参数
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sStateFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("StateFlag"));
	String sAccountType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AccountType"));
	String sRefromBAFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RefromBAFlag"));
	if(sRefromBAFlag == null) sRefromBAFlag="";	
	//将空值转化为字符串
	if(sObjectNo == null) sObjectNo="";
	if(sObjectType == null) sObjectType="";
	if(sSerialNo == null) sSerialNo="";
	if(sStateFlag == null) sStateFlag="";
	if(sAccountType == null) sAccountType="";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//取得状态
	sSql =  " select PhaseNo "+
		" from flow_object "+
		" where objectno in(select ObjectNo from BadBizApply_account where serialno='"+sSerialNo+"' )"+
		" and ObjectType='BadBizApply'  ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sPhaseNo = rs.getString("PhaseNo");
		if(sPhaseNo == null) sPhaseNo="";
		
	}
	rs.getStatement().close();
	
	if(!"0010".equals(sPhaseNo)&&!"3000".equals(sPhaseNo)&&!"".equals(sPhaseNo))
	{
		sEditRight="02";
	}
	//将空值转化为空字符串
	if(sTempletNo == null) sTempletNo = "";
	if("010".equals(sAccountType))
	{
		sTempletNo = "BadBizApplyAccountInfo1";
	}else if("020".equals(sAccountType))
	{
		sTempletNo = "BadBizApplyAccountInfo2";
	}else if("030".equals(sAccountType))
	{
		sTempletNo = "BadBizApplyAccountInfo3";
	}else if("040".equals(sAccountType))
	{
		sTempletNo = "BadBizApplyAccountInfo4";
	}else
	{
		sTempletNo = "BadBizApplyAccountInfo5";
	}
	//设置过滤条件	

	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if("2".equals(sRefromBAFlag))
	{
		doTemp.setRequired("FormerManageName,BadLoanType,loanAccountNo,ClassifyResult,ISLawFlag,LastDunDate",false);
	}
	//设置出质人选择框
	doTemp.setHTMLStyle("OwnerName"," style={width:400px} ");	
	doTemp.setUnit("EvalOrgName"," <input type=button value=.. onclick=parent.selectEvalOrgName()>");
	doTemp.appendHTMLStyle("EvalNetValue","onChange=\"javascript:parent.setGuarantyRate()\" ");	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	
	//设置setEvent
	//dwTemp.setEvent("AfterInsert","!BusinessManage.InsertGuarantyRelative("+sObjectType+","+sObjectNo+","+sContractNo+",#GuarantyID,New,Add)+!CustomerManage.AddCustomerInfo(#OwnerID,#OwnerName,#CertType,#CertID,#LoanCardNo,#InputUserID)");

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
		{"02".equals(sEditRight)?"false":"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
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
		as_save("myiframe0",sPostEvents);
	}
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		//initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{			
		//检查证件编号是否符合编码规则
		sCertType = getItemValue(0,0,"CertType");//--证件类型		
		sCertID = getItemValue(0,0,"CertID");//证件代码
		
		if(typeof(sCertType) != "undefined" && sCertType != "" )
		{
			//判断组织机构代码合法性
			if(sCertType =='Ent01')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if(!CheckORG(sCertID))
					{
						alert(getBusinessMessage('102'));//组织机构代码有误！						
						return false;
					}
				}
			}
			/*	
			//判断身份证合法性,个人身份证号码应该是15或18位！
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if (!CheckLisince(sCertID))
					{
						alert(getBusinessMessage('156'));//身份证号码有误！				
						return false;
					}
				}
			}
			*/
		}
		
		return true;
	}
	
	
	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/	
	function getBelongOrgName()
	{
		setObjectValue("SelectWholeOrg","","@BelongOrgID@0@BelongOrgName@1",0,0,"");
	}
		
	
	/*~[Describe=表内不良贷款台账;InputParam=无;OutPutParam=无;]~*/
	function getSum1()
	{		
		sInitializeBalance =  getItemValue(0,getRow(),"InitializeBalance");
		if(typeof(sInitializeBalance) == "undefined" || sInitializeBalance == "" )
		sInitializeBalance="0";
		sInitializeBalance=parseFloat(sInitializeBalance);
		
		sMoneyReturnSum =  getItemValue(0,getRow(),"MoneyReturnSum");
		if(typeof(sMoneyReturnSum) == "undefined" || sMoneyReturnSum == "" )
		sMoneyReturnSum="0";
		sMoneyReturnSum=parseFloat(sMoneyReturnSum);
		
		sReformUpSum =  getItemValue(0,getRow(),"ReformUpSum");
		if(typeof(sReformUpSum) == "undefined" || sReformUpSum == "" )
		sReformUpSum="0";
		sReformUpSum=parseFloat(sReformUpSum);
		
		sNotReformUpSum =  getItemValue(0,getRow(),"NotReformUpSum");
		if(typeof(sNotReformUpSum) == "undefined" || sNotReformUpSum == "" )
		sNotReformUpSum="0";
		sNotReformUpSum=parseFloat(sNotReformUpSum);
		
		sPayDebtSum =  getItemValue(0,getRow(),"PayDebtSum");
		if(typeof(sPayDebtSum) == "undefined" || sPayDebtSum == "" )
		sPayDebtSum="0";
		sPayDebtSum=parseFloat(sPayDebtSum);
		
		sCVSum =  getItemValue(0,getRow(),"CVSum");
		if(typeof(sCVSum) == "undefined" || sCVSum == "" )
		sCVSum="0";
		sCVSum=parseFloat(sCVSum);
		
		sMetathesisSum =  getItemValue(0,getRow(),"MetathesisSum");
		if(typeof(sMetathesisSum) == "undefined" || sMetathesisSum == "" )
		sMetathesisSum="0";
		sMetathesisSum=parseFloat(sMetathesisSum);
		
		sOtherReturnSum =  getItemValue(0,getRow(),"OtherReturnSum");
		if(typeof(sOtherReturnSum) == "undefined" || sOtherReturnSum == "" )
		sOtherReturnSum="0";
		sOtherReturnSum=parseFloat(sOtherReturnSum);
		//报告期清收处置本金合计=报告期货币资金收回+报告期重组上调+报告期非重组上调+报告期以资抵债+报告期核销+报告期资金置换+报告期其他方式收回
		//期末结欠本金余额=不良贷款初始本金-报告期清收处置本金合计
		sDisposeTotalSum = sMoneyReturnSum+sReformUpSum+sNotReformUpSum+sPayDebtSum+sCVSum+sMetathesisSum+sOtherReturnSum;
		setItemValue(0,0,"DisposeTotalSum",sDisposeTotalSum);
		setItemValue(0,0,"FinalBalance",sInitializeBalance-sDisposeTotalSum);
	}
	
	
	/*~[Describe=票据置换不良贷款台账;InputParam=无;OutPutParam=无;]~*/
	function getSum2()
	{		
		sInitializeBalance = getItemValue(0,getRow(),"InitializeBalance");
		if(typeof(sInitializeBalance) == "undefined" || sInitializeBalance == "" )
		sInitializeBalance="0";
		sInitializeBalance=parseFloat(sInitializeBalance);
		
		sMoneyReturnSum = getItemValue(0,getRow(),"MoneyReturnSum");
		if(typeof(sMoneyReturnSum) == "undefined" || sMoneyReturnSum == "" )
		sMoneyReturnSum="0";
		sMoneyReturnSum=parseFloat(sMoneyReturnSum);
		
		sPayDebtSum = getItemValue(0,getRow(),"PayDebtSum");
		if(typeof(sPayDebtSum) == "undefined" || sPayDebtSum == "" )
		sPayDebtSum="0";
		sPayDebtSum=parseFloat(sPayDebtSum);
		
		sOtherReturnSum = getItemValue(0,getRow(),"OtherReturnSum");
		if(typeof(sOtherReturnSum) == "undefined" || sOtherReturnSum == "" )
		sOtherReturnSum="0";
		sOtherReturnSum=parseFloat(sOtherReturnSum);
		//报告期清收处置本金合计=报告期货币资金收回+报告期以资抵债+报告期其他方式收回
		//期末结欠本金余额=已置换本金初始余额-报告期清收处置本金合计
		sDisposeTotalSum = sMoneyReturnSum+sPayDebtSum+sOtherReturnSum;
		setItemValue(0,0,"DisposeTotalSum",sDisposeTotalSum);
		setItemValue(0,0,"FinalBalance",sInitializeBalance-sDisposeTotalSum);
	}


	/*~[Describe=已核销不良贷款台账;InputParam=无;OutPutParam=无;]~*/
	function getSum3()
	{		
		sInitializeBalance = getItemValue(0,getRow(),"InitializeBalance");
		if(typeof(sInitializeBalance) == "undefined" || sInitializeBalance == "" )
		sInitializeBalance="0";
		sInitializeBalance=parseFloat(sInitializeBalance);
		
		sMoneyReturnSum = getItemValue(0,getRow(),"MoneyReturnSum");
		if(typeof(sMoneyReturnSum) == "undefined" || sMoneyReturnSum == "" )
		sMoneyReturnSum="0";
		sMoneyReturnSum=parseFloat(sMoneyReturnSum);
		
		sOtherReturnSum = getItemValue(0,getRow(),"OtherReturnSum");
		if(typeof(sOtherReturnSum) == "undefined" || sOtherReturnSum == "" )
		sOtherReturnSum="0";
		sOtherReturnSum=parseFloat(sOtherReturnSum);
		//报告期收回已核销呆账本金合计=报告期货币资金收回+报告期其他方式收回
		//期末已核销呆账本金余额=已核销呆账本金-报告期收回已核销呆账本金合计
		sDisposeTotalSum = sMoneyReturnSum+sOtherReturnSum;
		setItemValue(0,0,"DisposeTotalSum",sDisposeTotalSum);
		setItemValue(0,0,"FinalBalance",sInitializeBalance-sDisposeTotalSum);
	}
	
	
	/*~[Describe=资金置换不良贷款台账;InputParam=无;OutPutParam=无;]~*/
	function getSum4()
	{				
		sInitializeBalance = getItemValue(0,getRow(),"InitializeBalance");
		if(typeof(sInitializeBalance) == "undefined" || sInitializeBalance == "" )
		sInitializeBalance="0";
		sInitializeBalance=parseFloat(sInitializeBalance);
		
		sMoneyReturnSum = getItemValue(0,getRow(),"MoneyReturnSum");
		if(typeof(sMoneyReturnSum) == "undefined" || sMoneyReturnSum == "" )
		sMoneyReturnSum="0";
		sMoneyReturnSum=parseFloat(sMoneyReturnSum);
		
		sReformSBSum = getItemValue(0,getRow(),"ReformSBSum");
		if(typeof(sReformSBSum) == "undefined" || sReformSBSum == "" )
		sReformSBSum="0";
		sReformSBSum=parseFloat(sReformSBSum);
		
		sOtherReturnSum = getItemValue(0,getRow(),"OtherReturnSum");
		if(typeof(sOtherReturnSum) == "undefined" || sOtherReturnSum == "" )
		sOtherReturnSum="0";
		sOtherReturnSum=parseFloat(sOtherReturnSum);
		
		//报告期清收处置本金合计=报告期货币资金收回+报告期重组转回+报告期其他方式收回
		//期末结欠本金余额=资金置换不良贷款本金期初余额-报告期清收处置本金合计
		sDisposeTotalSum = sMoneyReturnSum+sReformSBSum+sOtherReturnSum;
		setItemValue(0,0,"DisposeTotalSum",sDisposeTotalSum);
		setItemValue(0,0,"FinalBalance",sInitializeBalance-sDisposeTotalSum);
	}
	
	
	/*~[Describe=抵债资产;InputParam=无;OutPutParam=无;]~*/
	function getSum5()
	{		
		sInitializeBalance = getItemValue(0,getRow(),"InitializeBalance");
		if(typeof(sInitializeBalance) == "undefined" || sInitializeBalance == "" )
		sInitializeBalance="0";
		sInitializeBalance=parseFloat(sInitializeBalance);
		
		sSaleSum = getItemValue(0,getRow(),"SaleSum");
		if(typeof(sSaleSum) == "undefined" || sSaleSum == "" )
		sSaleSum="0";
		sSaleSum=parseFloat(sSaleSum);
		
		sHireSum = getItemValue(0,getRow(),"HireSum");
		if(typeof(sHireSum) == "undefined" || sHireSum == "" )
		sHireSum="0";
		sHireSum=parseFloat(sHireSum);
		
		sOtherDisposeSum = getItemValue(0,getRow(),"OtherDisposeSum");
		if(typeof(sOtherDisposeSum) == "undefined" || sOtherDisposeSum == "" )
		sOtherDisposeSum="0";
		sOtherDisposeSum=parseFloat(sOtherDisposeSum);
		
		sLostSum = getItemValue(0,getRow(),"LostSum");
		if(typeof(sLostSum) == "undefined" || sLostSum == "" )
		sLostSum="0";
		sLostSum=parseFloat(sLostSum);
		//报告期抵债资产处置合计=报告期抵债资产出售+报告期抵债资产出租+报告期抵债资产其他方式处置+报告期抵债资产处置损失
		//期末结存抵债资产账面余额=抵债资产账面初始金额-报告期抵债资产处置合计
		sDisposeTotalSum = sSaleSum+sHireSum+sOtherDisposeSum+sLostSum;
		setItemValue(0,0,"DisposeTotalSum",sDisposeTotalSum);
		setItemValue(0,0,"FinalAccountBalance",sInitializeBalance-sDisposeTotalSum);
	}
	
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");
			setItemValue(0,0,"AccountType","<%=sAccountType%>");
			setItemValue(0,getRow(),"RefromBAFlag","<%=sRefromBAFlag%>");
			bIsInsert = true;			
		}
		
    }
	
	        
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BADBIZ_ACCOUNT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetGuarantyID.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		//将流水号置入对应字段
		setItemValue(0,getRow(),"SerialNo",sSerialNo);		
					
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
