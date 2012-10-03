<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2009/08/14
		Tester:
		Content: 同业客户定量信息详情
		Input Param:
                CustomerID：客户编号
                SerialNo：信息流水号
                EditRight：权限代码（01：查看权；02：维护权）
                ReportDate:报表月份
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "同业客户定量信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    String sSql = "";//--存放sql语句
    String sCreditBelong = "";//--存放信用等级评估模板编号
	ASResultSet rs = null;//-- 存放结果集
	//获得组件参数：
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerType == null) sCustomerType = "";
	//获得页面参数：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sEditRight == null) sEditRight = "";
	String sReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportDate"));
	if(sEditRight == null) sReportDate = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CustomerFSRationInfo";
	//设置模板条件
	String sTempletFilter = " (ColAttribute like '%000%' ) ";
	//取得客户信用等级评估模板
	sSql = "select (Case when CreditBelong is null then '' else CreditBelong end) as CreditBelong "+
		   " from ENT_INFO where CustomerID = '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCreditBelong = rs.getString("CreditBelong");	
	}
	rs.getStatement().close();
	//根据信用等级评估模板确定模板条件
	if(sCreditBelong.equals("200"))
	{
		//商业银行信用等级评估表
		sTempletFilter = " (ColAttribute like '%200%' ) ";
	}else if(sCreditBelong.equals("201")){
		//城市、农村信用社信用等级评估表
		sTempletFilter = " (ColAttribute like '%201%' ) ";
	}else if(sCreditBelong.equals("202")){
		//证券公司信用等级评估表
		sTempletFilter = " (ColAttribute like '%202%' ) ";
	}else if(sCreditBelong.equals("203")){
		//保险公司信用等级评估表
		sTempletFilter = " (ColAttribute like '%203%' ) ";
	}else if(sCreditBelong.equals("204")){
		//金融租赁公司信用等级评估表
		sTempletFilter = " (ColAttribute like '%204%' ) ";
	}else if(sCreditBelong.equals("205")){
		//信托投资公司信用等级评估表
		sTempletFilter = " (ColAttribute like '%205%' ) ";
	}else if(sCreditBelong.equals("206")){
		//新成立银行类金融机构第一年信用等级评估表
		sTempletFilter = " (ColAttribute like '%206%' ) ";
	}
	//微小企业财务定量指标模板
	if(!"0107".equals(sCustomerType))
	{
		sTempletFilter = "";
		sTempletNo = "CustomerMEntRationInfo";
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//设置购买总价格(元)范围
	//doTemp.appendHTMLStyle("BondSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"购买总价格(元)必须大于等于0！\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform	
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}

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
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/CustomerFSRationList.jsp","_self","");
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script language=javascript>


	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{		
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=计算流动资产合计;InputParam=无;OutPutParam=无;]~*/
	function getSum1()
	{		
		sRetCapital =  getItemValue(0,getRow(),"RetCapital");
		sTotalAsset =  getItemValue(0,getRow(),"TotalAsset");
		sRetLoanCallRate =  getItemValue(0,getRow(),"RetLoanCallRate");
		sTotalDeposit =  getItemValue(0,getRow(),"TotalDeposit");
		sTotalLoan =  getItemValue(0,getRow(),"TotalLoan");
		sTaking =  getItemValue(0,getRow(),"Taking");
		sLongInvestRate =  getItemValue(0,getRow(),"LongInvestRate");
		sCapitalFullRate = sRetCapital+sTotalAsset+sRetLoanCallRate+sTotalDeposit+sTotalLoan+sTaking+sLongInvestRate;
		setItemValue(0,0,"CapitalFullRate",sCapitalFullRate);
	}
	
	/*~[Describe=计算固定资产合计;InputParam=无;OutPutParam=无;]~*/
	function getSum2()
	{		
		sCoreCapitalRate =  getItemValue(0,getRow(),"CoreCapitalRate");
		sOneLoanRate =  getItemValue(0,getRow(),"OneLoanRate");
		sTenLoanRate =  getItemValue(0,getRow(),"TenLoanRate");
		sBadLoanRate = sCoreCapitalRate+sOneLoanRate+sTenLoanRate;
		setItemValue(0,0,"BadLoanRate",sBadLoanRate);
	}
	
	/*~[Describe=计算资产总计;InputParam=无;OutPutParam=无;]~*/
	function getSum3()
	{		
		sBadLoanRate =  getItemValue(0,getRow(),"BadLoanRate");
		sPeculateCapital =  getItemValue(0,getRow(),"PeculateCapital");
		sLiquidityRate = sBadLoanRate+sPeculateCapital;
		setItemValue(0,0,"LiquidityRate",sLiquidityRate);
	}
	
	/*~[Describe=计算流动负债合计;InputParam=无;OutPutParam=无;]~*/
	function getSum4()
	{		
		sAssetIncomeRate =  getItemValue(0,getRow(),"AssetIncomeRate");
		sRetIncomeRate =  getItemValue(0,getRow(),"RetIncomeRate");
		sTakeCashFluxRate =  getItemValue(0,getRow(),"TakeCashFluxRate");
		sFactRetAsset =  getItemValue(0,getRow(),"FactRetAsset");
		sSlackDistillRate =  getItemValue(0,getRow(),"SlackDistillRate");
		sBadLoanFallRate =  getItemValue(0,getRow(),"BadLoanFallRate");
		sExcessPrePayRate = sAssetIncomeRate+sRetIncomeRate+sTakeCashFluxRate+sFactRetAsset+sSlackDistillRate+sBadLoanFallRate;
		setItemValue(0,0,"ExcessPrePayRate",sExcessPrePayRate);
	}
	
	/*~[Describe=计算负债总额;InputParam=无;OutPutParam=无;]~*/
	function getSum5()
	{		
		sExcessPrePayRate =  getItemValue(0,getRow(),"ExcessPrePayRate");
		sCostinComeRate =  getItemValue(0,getRow(),"CostinComeRate");
		sHoldBondRate = sExcessPrePayRate+sCostinComeRate;
		setItemValue(0,0,"HoldBondRate",sHoldBondRate);
	}
	
	/*~[Describe=计算流动负债合计;InputParam=无;OutPutParam=无;]~*/
	function getSum6()
	{		
		sAssetIncomeRate =  getItemValue(0,getRow(),"AssetIncomeRate");
		sRetIncomeRate =  getItemValue(0,getRow(),"RetIncomeRate");//短期借款
		sTakeCashFluxRate =  getItemValue(0,getRow(),"TakeCashFluxRate");
		sFactRetAsset =  getItemValue(0,getRow(),"FactRetAsset");
		sSlackDistillRate =  getItemValue(0,getRow(),"SlackDistillRate");
		sBadLoanFallRate =  getItemValue(0,getRow(),"BadLoanFallRate");
		sInterestBackRate =  getItemValue(0,getRow(),"InterestBackRate");//销售收入
		sExcessPrePayRate = sAssetIncomeRate+sRetIncomeRate+sTakeCashFluxRate+sFactRetAsset+sSlackDistillRate+sBadLoanFallRate;
		setItemValue(0,0,"CapitalFullRate",sExcessPrePayRate);
		if(typeof(sInterestBackRate)!="undefined" && sInterestBackRate.length!=0)
		{
			setItemValue(0,0,"InterestMultiple",roundOff(sRetIncomeRate*100/sInterestBackRate,2));
		}
	}
	
	/*~[Describe=计算短期借款/销售收入;InputParam=无;OutPutParam=无;]~*/
	function getSum7()
	{		
		sRetIncomeRate =  getItemValue(0,getRow(),"RetIncomeRate");//短期借款
		sInterestBackRate =  getItemValue(0,getRow(),"InterestBackRate");//销售收入
		sRetCapitalRate=  getItemValue(0,getRow(),"RetCapitalRate");//主营业务利润
		if(typeof(sInterestBackRate)!="undefined" && sInterestBackRate.length!=0)
		{
			setItemValue(0,0,"InterestMultiple",roundOff(sRetIncomeRate*100/sInterestBackRate,2));
			setItemValue(0,0,"RetassetFareRate",roundOff(sRetCapitalRate*100/sInterestBackRate,2));
		}
	}
	
	/*~[Describe=计算资产负债率;InputParam=无;OutPutParam=无;]~*/
	function getSum8()
	{		
		sHoldBondRate =  getItemValue(0,getRow(),"HoldBondRate");//负债总额
		sLiquidityRate =  getItemValue(0,getRow(),"LiquidityRate");//资产总计
		if(typeof(sHoldBondRate)!="undefined" && sHoldBondRate.length!=0)
		{
			setItemValue(0,0,"AssetOwesRate",roundOff(sLiquidityRate*100/sHoldBondRate,2));
		}
	}
	
	/*~[Describe=计算销售利润率;InputParam=无;OutPutParam=无;]~*/
	function getSum9()
	{		
		sInterestBackRate =  getItemValue(0,getRow(),"InterestBackRate");//销售收入
		sRetCapitalRate=  getItemValue(0,getRow(),"RetCapitalRate");//主营业务利润
		if(typeof(sInterestBackRate)!="undefined" && sInterestBackRate.length!=0)
		{
			setItemValue(0,0,"RetassetFareRate",roundOff(sRetCapitalRate*100/sInterestBackRate,2));
		}
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{		
		return true;
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ReportDate","<%=sReportDate%>");//报表月份
			setItemValue(0,0,"UpdateDate","<%=sCreditBelong%>");
		
		}
    }
    
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_FSRATION";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=日期选择;InputParam=无;OutPutParam=无;]~*/
	function getMonth(sObject)
	{
		sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
		if(typeof(sReturnMonth) != "undefined")
		{
			setItemValue(0,0,sObject,sReturnMonth);
		}
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
