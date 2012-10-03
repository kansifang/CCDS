<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   lpzhang 2009-7-30
		Tester:
		Content: 业务基本信息
		Input Param:
				 ObjectType：对象类型
				 ObjectNo：对象编号
		Output param:
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：对象主表名、对应关联表名、SQL语句、产品类型、客户代码、显示属性
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "",sThirdParty="0.0";
	//定义变量：查询列名、显示模版名称、申请类型、发生类型、暂存标志、项下业务关联的额度申请流水
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sBAAgreement = "";
	//定义变量：关联业务币种、关联业务到期日、关联流水号
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "";
	//定义变量：客户类型,客户信息表名,行业投向
	String sCustomerType = "",sCustomerTable="",sIndustryType="",sApproveDate="",sCreditAggreement="",sChangType = "" ;
	//定义变量：关联业务金额、关联业务利率、关联业务余额
	double dOldBusinessSum = 0.0,dOldBusinessRate = 0.0,dOldBalance = 0.0,dThirdPartyRatio=0.0,dThirdParty=0.0;
	//定义变量：展期次数、借新还旧次数、还旧借新次数、债务重组次数
	int iExtendTimes = 0,iLNGOTimes = 0,iGOLNTimes = 0,iDRTimes = 0,dTermDay=0 ,dOldTermMonth=0,dOldTermDay=0;
	//定义变量：查询结果集
	ASResultSet rs = null;
	
	//获得页面参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	/*
	String sObjectTypeUsed = "";//额度补登时要使用的ObjectType add by zrli 
	if(sObjectType.equals("ReinforceContract"))
		sObjectTypeUsed = "BusinessContract";
	else
		sObjectTypeUsed = sObjectType;
	*/
%>
<%/*~END~*/%>

	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%	
	//根据对象类型从对象类型定义表中查询到相应对象的主表名
	sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sMainTable = DataConvert.toString(rs.getString("ObjectTable"));
		sRelativeTable = DataConvert.toString(rs.getString("RelativeTable"));
				
		//将空值转化成空字符串
		if(sMainTable == null) sMainTable = "";
		if(sRelativeTable == null) sRelativeTable = "";		
	}
	rs.getStatement().close(); 
	
	//从业务表中获得业务品种
	sSql = "select CustomerID,BAAgreement,ApplyType,RelativeSerialNo,CustomerID,BusinessType,OccurType,TempSaveFlag,ApproveDate,changtype from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sBAAgreement = DataConvert.toString(rs.getString("BAAgreement"));
		sApplyType = DataConvert.toString(rs.getString("ApplyType"));
		sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
		sOccurType = DataConvert.toString(rs.getString("OccurType"));
		sTempSaveFlag = DataConvert.toString(rs.getString("TempSaveFlag")); 
		sApproveDate = DataConvert.toString(rs.getString("ApproveDate")); 
		sChangType = DataConvert.toString(rs.getString("changtype"));
		
		//将空值转化成空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sBAAgreement == null) sBAAgreement = "";
		if(sApplyType == null) sApplyType = "";
		if(sRelativeSerialNo == null) sRelativeSerialNo = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sTempSaveFlag == null) sTempSaveFlag = "";
		if(sApproveDate == null) sApproveDate = "";
		if(sChangType == null) sChangType = "";
	
	}
	rs.getStatement().close(); 
	System.out.println("sApproveDate:"+sApproveDate);
	
	sSql= "select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerType = rs.getString("CustomerType");
		if(sCustomerType == null) sCustomerType = "";
	}
	rs.getStatement().close(); 

	//如果业务品种为空,则显示短期流动资金贷款
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//在业务对象为申请时才执行如下业务逻辑
	if(sObjectType.equals("CreditApply"))
	{
		//根据发生类型（系统暂处理 展期、借新还旧、还旧借新、债务重组四种类型）获取相应的关联业务信息
		if(sOccurType.equals("015") || sOccurType.equals("020") || sOccurType.equals("060") || sOccurType.equals("065")) //展期、借新还旧、还旧借新、新增(续作)
		{
			//获取展期合同（/借据）的金额、余额、利率、币种、到期日、展期次数、借新还旧次数、还旧借新次数、债务重组次数等信息
			//sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //按照合同
			String sContractNo = "";
			sSql = 	" select relativeserialno2, BusinessSum,Balance,ActualBusinessRate,BusinessCurrency,Maturity,ExtendTimes,RenewTimes as LNGOTimes,GOLNTimes,ReorgTimes as DRTimes "+ //按照借据
					//" from BUSINESS_CONTRACT "+ //按照合同
					" from BUSINESS_DUEBILL "+ //按照借据
					" where SerialNo in (select ObjectNo "+
					" from "+sRelativeTable+" "+
					//" where ObjectType = 'BusinessContract' "+ //按照合同
					" where ObjectType = 'BusinessDueBill' "+ //按照借据
					" and SerialNo = '"+sObjectNo+"') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{ 
				sContractNo= rs.getString("relativeserialno2");
				dOldBusinessSum = rs.getDouble("BusinessSum");
				dOldBalance = rs.getDouble("Balance");
				dOldBusinessRate = rs.getDouble("ActualBusinessRate");			
				sOldBusinessCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
				sOldMaturity = DataConvert.toString(rs.getString("Maturity"));
				iExtendTimes = rs.getInt("ExtendTimes");
				iLNGOTimes = rs.getInt("LNGOTimes");
				iGOLNTimes = rs.getInt("GOLNTimes");
				iDRTimes = rs.getInt("DRTimes");
							
				//将空值转化成空字符串					
				if(sOldBusinessCurrency == null) sOldBusinessCurrency = "";
				if(sOldMaturity == null) sOldMaturity = "";
			}
			rs.getStatement().close(); 		
			if(sOccurType.equals("015")){
				sSql = "select TermMonth,TermDay from BUSINESS_CONTRACT where SerialNo = '"+sContractNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					dOldTermMonth = rs.getInt("TermMonth");
					dOldTermDay = rs.getInt("TermDay");
				}
				rs.getStatement().close();
			}
		}else if(sOccurType.equals("030")) //债务重组
		{
			//获取资产重组方案编号
			sSql = 	" select ObjectNo from "+sRelativeTable+" "+
					" where ObjectType = 'CapitalReform' "+
					" and SerialNo = '"+sObjectNo+"' ";
			String sCapitalReformNo = Sqlca.getString(sSql);
			/*
			//获取重组合同的金额、债务重组合同余额、利率、币种、到期日、展期次数、借新还旧次数、还旧借新次数、债务重组次数等信息
			sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //按照合同
					" from BUSINESS_CONTRACT "+ //按照合同
					" where SerialNo = (select ObjectNo "+
					//" from APPLY_RELATIVE "+
					" from Reform_RELATIVE "+
					" where ObjectType = 'BusinessContract' "+ 				
					" and SerialNo = '"+sCapitalReformNo+"') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{ 
				dOldBusinessSum = rs.getDouble("BusinessSum");
				dOldBalance = rs.getDouble("Balance");
				dOldBusinessRate = rs.getDouble("BusinessRate");			
				sOldBusinessCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
				sOldMaturity = DataConvert.toString(rs.getString("Maturity"));
				iExtendTimes = rs.getInt("ExtendTimes");
				iLNGOTimes = rs.getInt("LNGOTimes");
				iGOLNTimes = rs.getInt("GOLNTimes");
				iDRTimes = rs.getInt("DRTimes");
							
				//将空值转化成空字符串					
				if(sOldBusinessCurrency == null) sOldBusinessCurrency = "";
				if(sOldMaturity == null) sOldMaturity = "";
			}
			rs.getStatement().close(); 	
			*/
		}
		//这些关联业务需要再进行关联一次（展期/借新还旧/还旧借新/债务重组），因此需要在原来的次数上增加一次
		iExtendTimes = iExtendTimes + 1;
		iLNGOTimes = iLNGOTimes + 1;
		iGOLNTimes = iExtendTimes + 1;
		iDRTimes = iDRTimes + 1;
	}else{//除申请外
		//展期取原借款合同期限月、日
		if(sOccurType.equals("015"))
		{
			//获取展期合同（/借据） 合同号
			//sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //按照合同
			String sContractNo = "";
			sSql = 	" select relativeserialno2 "+ 
					//" from BUSINESS_CONTRACT "+ //按照合同
					" from BUSINESS_DUEBILL "+ //按照借据
					" where SerialNo in (select ObjectNo "+
					" from "+sRelativeTable+" "+
					//" where ObjectType = 'BusinessContract' "+ //按照合同
					" where ObjectType = 'BusinessDueBill' "+ //按照借据
					" and SerialNo = '"+sObjectNo+"') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{ 
				sContractNo= rs.getString("relativeserialno2");	
				//将空值转化成空字符串					
				if(sContractNo == null) sContractNo = "";
			}
			rs.getStatement().close(); 		
			sSql = "select TermMonth,TermDay from BUSINESS_CONTRACT where SerialNo = '"+sContractNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				dOldTermMonth = rs.getInt("TermMonth");
				dOldTermDay = rs.getInt("TermDay");
			}
			rs.getStatement().close();
		}
	}
	
	//根据产品类型从产品信息表BUSINESS_TYPE中获得显示模版名称
	//发生类型为展期，需要调用展期信息模板
	if(sOccurType.equals("015"))
	{
		if(sObjectType.equals("CreditApply")) //申请对象
			sDisplayTemplet = "ApplyInfo0000";
		if(sObjectType.equals("ApproveApply")) //最终审批意见对象
			sDisplayTemplet = "ApproveInfo0000";
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //合同对象
			sDisplayTemplet = "ContractInfo0000";					
	}else
	{
		if(sObjectType.equals("CreditApply")) //申请对象
			sFieldName = "ApplyDetailNo";
		if(sObjectType.equals("ApproveApply")) //最终审批意见对象
			sFieldName = "ApproveDetailNo";
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //合同对象
			sFieldName = "ContractDetailNo";

		sSql = " select "+sFieldName+" as DisplayTemplet from BUSINESS_TYPE where TypeNo = '"+sBusinessType+"' ";
		sDisplayTemplet = Sqlca.getString(sSql);
	
		//区分同一模板在不同阶段显示不同的内容	
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //合同对象
			sColAttribute = " ColAttribute like '%"+sObjectType+"%' ";
	}
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,sColAttribute,Sqlca);
	//设置更新表名和主键
	doTemp.UpdateTable = sMainTable;
	doTemp.setKey("SerialNo",true);
	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"基准年利率必须大于等于0,小于等于100！\" ");
	//------申请-----------add by wangdw 2012-06-05
	if(sObjectType.equals("CreditApply"))
	{
		if("120".equals(sOccurType))
		{
			//doTemp.setReadOnly("",true);
			//doTemp.setReadOnly("ChangeReason",false);
			
		}
	}
	//如果是用途变更则设置用途可输
	if(sChangType.equals("05"))
	{
		doTemp.setReadOnly("Purpose",false);
	}
	
	if(sBusinessType.equals("1110010")|| sBusinessType.equals("1110020") || sBusinessType.equals("1110030") || sBusinessType.equals("1110040")||sBusinessType.equals("1110025") )
	{
		doTemp.appendHTMLStyle("ThirdPartyZIP3"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"公积金贷款利率必须大于等于0,小于等于1000！\" ");
		doTemp.appendHTMLStyle("ThirdPartyZIP2"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"按揭贷款成数必须大于等于0,小于等于100！\" ");
		doTemp.appendHTMLStyle("ThirdPartyAdd1"," myvalid=\"parseFloat(myobj.value,10)>=0  \" mymsg=\"首付金额必须大于等于0 \" ");
		//doTemp.appendHTMLStyle("ThirdPartyZIP1"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"首付比例必须大于等于0,小于等于100！\" ");
		
	}
	
	if( sBusinessType.equals("1110027"))
	{
		//doTemp.appendHTMLStyle("ThirdParty3"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"首付比例必须大于等于0,小于等于100！\" ");
		doTemp.appendHTMLStyle("ThirdPartyID3"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"按揭贷款成数必须大于等于0,小于等于100！\" ");
		doTemp.appendHTMLStyle("ThirdPartyID2"," myvalid=\"parseFloat(myobj.value,10)>=0  \" mymsg=\"首付金额必须大于等于0 \" ");
	}
	if( sBusinessType.equals("1080070"))
	{
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"开证保证金比例必须大于等于0,小于等于100！\" ");
	}
	//国家助学贷款
	if( sBusinessType.equals("1110150"))
	{
		doTemp.appendHTMLStyle("ThirdPartyID1"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贴息比例必须大于等于0,小于等于100！\" ");
	}
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例必须大于等于0,小于等于100！\" ");
	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率必须大于等于0,小于等于1000！\" ");
	
	//农户联保贷款
	if(sBusinessType.equals("1150020"))
	{
		doTemp.setVisible("BailRatio,BailSum",true);
		doTemp.setRequired("BailRatio",true);
	}
	if(sBusinessType.equals("3010")){
		doTemp.setVisible("BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate,SelfUseFlag",true);
		doTemp.setRequired("RateFloatType,RateFloat,BusinessRate,SelfUseFlag",true);
	}
	
	//自动获取利率类型和利率值
	if(!sBusinessType.startsWith("3") || sBusinessType.startsWith("3010")){
		if("2110020".equals(sBusinessType))
		{
			doTemp.appendHTMLStyle("TermMonth,TermDay","onBlur=\"javascript:parent.getAFBaseRateType()\" ");
		}else{
			doTemp.appendHTMLStyle("TermMonth,TermDay","onBlur=\"javascript:parent.getBaseRateType()\" ");
		}
	}
	doTemp.appendHTMLStyle("VouchCorpFlag","onBlur=\"javascript:parent.setVouchAggreement()\" ");
	//针对保函业务手续费金额为可修改
	if(sBusinessType.startsWith("2030")||sBusinessType.startsWith("2040"))
	{
		doTemp.setReadOnly("PdgSum",false);
		doTemp.setReadOnly("PdgRatio",false);
	}else{
		doTemp.setReadOnly("PdgSum",true);
	}
	//设置字段的可见属性
	/* 关闭by zrli 2010-8-12
	if(sOccurType.equals("020")) //借新还旧时显示借新还旧次数字段
		doTemp.setVisible("LNGOTimes",true);
	if(sOccurType.equals("060")) //还旧借新显示还旧借新次数字段
		doTemp.setVisible("GOLNTimes",true);
	if(sOccurType.equals("030")) //债务重组显示债务重组次数字段
		doTemp.setVisible("DRTimes",true);	
	*/
	if(sOccurType.equals("015"))
		doTemp.setCheckFormat("TotalSum,BusinessSum","2");
	//if(sOccurType.equals("120")&&sBusinessType.equals("1110027"))
	if(sOccurType.equals("120"))	
	{
		System.out.println("设置显示模板=====================================>>>起");
		doTemp.setVisible("ChangType",true); 	//设置变更类型可见
		doTemp.setVisible("ChangeReason",true); //设置变更原因可见
		doTemp.setRequired("ChangType",true);	//设置变更类型必输
		doTemp.setReadOnly("ChangType",true);	//设置变更类型为只读
		doTemp.setUnit("AccumulationNo","<input type=button value=\"发送\" onClick=parent.SendGDTrade6030()>");	
		System.out.println("设置显示模板=====================================>>>止");
	}
	
	//设置利率格式,后面小数点6位
	doTemp.setCheckFormat("BusinessRate,OldBusinessRate,OverdueRate,TARate","16");
	//当业务品种类型为出口信用证押汇时设置利率浮动值,后面小数点6位	
	if(sBusinessType.equals("1080030"))   //出口信用证押汇
	{doTemp.setCheckFormat("RateFloat","16");}
	
	//根据申请对象不同，设置显示要素的不同属性
	if(sApplyType.equals("DependentApply")){//额度项下业务
		doTemp.setVisible("CreditAggreement",true);
		if(sCustomerType.startsWith("03")){
			doTemp.setReadOnly("CycleFlag",true);  
		}
	}
	//------合同登记-----------
	if(sObjectType.equals("BusinessContract"))
	{
		doTemp.setReadOnly("BusinessCurrency",true);
		doTemp.setUnit("VouchTypeName","");
		
	}
	if(sObjectType.equals("AfterLoan"))
	{
		if(sCustomerType.startsWith("03")){//个人五级
			doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from code_library where codeno='ClassifyResult' and length(ItemNo)=2");  
		}else{//公司十级
			doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from code_library where codeno='ClassifyResult' and length(ItemNo)=4"); 
		}
	}
	
	//合同补登时将合同详情中字段只读项打开 added by zrli
	if(sObjectType.equals("ReinforceContract"))
	{
		doTemp.setReadOnly("",false);
		doTemp.setReadOnly("SerialNo,CustomerID,CustomerName,BusinessTypeName,ArtificialNo,PutOutOrgName,ExposureSum",true);
		doTemp.setReadOnly("BusinessCurrency,BusinessSum,TermMonth,TermDay,BusinessRate,PutOutDate,VouchTypeName",true);
		doTemp.setReadOnly("Maturity,Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,DirectionName",true);
		doTemp.setReadOnly("OverdueDays,FinishType,FinishDate,ManageUserName,ManageOrgName,OperateUserName",true);
		doTemp.setReadOnly("OperateOrgName,InputUserName,InputOrgName,InputDate,UpdateDate,PigeonholeDate,AgriLoanClassifyName",true);
		//如果是个贷

		if(sBusinessType.startsWith("1110") || sBusinessType.startsWith("1140") || sBusinessType.startsWith("1150")){

			doTemp.setReadOnly("VouchAggreement,VouchCorpName,ThirdParty3,BuildAgreement",true);
			if(sBusinessType.equals("1110020") || sBusinessType.equals("1140020") || sBusinessType.equals("1110040")) 
			{
				doTemp.setReadOnly("ThirdParty3",false);
			}

		}
		//补登业务不进行利率计算
		doTemp.setHTMLStyle("BusinessRate,TermMonth,TermDay","");
		//设置为可见,必输,可修改
		doTemp.setReadOnly("OccurType,ClassifyResult",false);
		doTemp.setVisible("OccurType,ClassifyResult",true);
		doTemp.setRequired("OccurType,ClassifyResult",true);
		doTemp.setRequired("InputUserName,InputOrgName",false);
		if(sCustomerType.startsWith("03")){//个人五级
			doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from code_library where codeno='ClassifyResult' and length(ItemNo)=2");  
		}else{//公司十级
			doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from code_library where codeno='ClassifyResult' and length(ItemNo)=4"); 
		}
		if(sBusinessType.startsWith("3"))
		{
			doTemp.setReadOnly("",false);
			doTemp.setReadOnly("VouchTypeName,ManageUserName,ManageOrgName,DirectionName,AgriLoanClassifyName,SerialNo,CustomerID,CustomerName,BusinessTypeName,PutOutOrgName,ExposureSum,OccurType,OperateOrgName,OperateUserName,InputUserName,InputOrgName,InputDate,UpdateDate,PigeonholeDate",true);
		}
		if("2010".equals(sBusinessType) || "2070".equals(sBusinessType)){
			doTemp.setReadOnly("",false);
			doTemp.setReadOnly("VouchTypeName,FinishDate,DirectionName,PutOutOrgName,FinishType,AgriLoanClassifyName,ManageUserName,ManageOrgName,SerialNo,CustomerID,CustomerName,BusinessTypeName,ExposureSum,OccurType,OperateOrgName,OperateUserName,InputUserName,InputOrgName,InputDate,UpdateDate,PigeonholeDate",true);
		}
		if(sBusinessType.startsWith("2030") || sBusinessType.startsWith("2040") || sBusinessType.startsWith("2050") 
			|| sBusinessType.startsWith("1020") || sBusinessType.startsWith("1080") || sBusinessType.startsWith("2110")){
			doTemp.setReadOnly("",false);
			doTemp.setReadOnly("VouchTypeName,FinishDate,VouchFlagName,DirectionName,FinishType,PutOutOrgName,AgriLoanClassifyName,ManageUserName,ManageOrgName,SerialNo,CustomerID,CustomerName,BusinessTypeName,ExposureSum,OccurType,OperateOrgName,OperateUserName,InputUserName,InputOrgName,InputDate,UpdateDate,PigeonholeDate",true);
			if("2110020".equals(sBusinessType) || "1080070".equals(sBusinessType))
			{
				doTemp.setReadOnly("OccurType",false);
			}
		}
		if("1110010".equals(sBusinessType)){
			doTemp.setReadOnly("",false);
			doTemp.setReadOnly("OverdueDays,Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,VouchTypeName,FinishDate,DirectionName,PutOutOrgName,FinishType,AgriLoanClassifyName,ManageUserName,ManageOrgName,SerialNo,CustomerID,CustomerName,BusinessTypeName,ExposureSum,OccurType,OperateOrgName,OperateUserName,InputUserName,InputOrgName,InputDate,UpdateDate,PigeonholeDate",true);
		}
		doTemp.setRequired("PutOutOrgName",false);
	}
	
%>
	<%@include file="CheckBusinessDataValidity.jsp"%>	
<%
	//生成DataWindow对象	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "0"; 
	

	//只有业务品种是额度时需要更新CL_Info
	if(sBusinessType.startsWith("30") && !sBusinessType.equals("3020"))
	{
		if("ReinforceContract".equals(sObjectType))
		{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateCLInfo(BusinessContract,#SerialNo,#BusinessSum,#BusinessCurrency,#LimitationTerm,#BeginDate,#PutOutDate,#Maturity,#UseTerm,#TermMonth)");
		}else{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateCLInfo("+sObjectType+",#SerialNo,#BusinessSum,#BusinessCurrency,#LimitationTerm,#BeginDate,#PutOutDate,#Maturity,#UseTerm,#TermMonth)");
		}
		
	}
	if(sBusinessType.equals("3020"))
	{
		if("ReinforceContract".equals(sObjectType))
		{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateEntAgreementInfo(#SerialNo,BusinessContract)");
		}else{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateEntAgreementInfo(#SerialNo,"+sObjectType+")");
		}
	}
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//获取校验数据信息
	double dCheckBusinessSum = 0.0,dCheckBaseRate = 0.0,dCheckRateFloat = 0.0,dCheckBusinessRate = 0.0;
	double dCheckPdgRatio = 0.0,dCheckPdgSum = 0.0,dCheckBailSum = 0.0,dCheckBailRatio = 0.0,dCognScore=0.0;
	String sCheckRateFloatType = "",sCognResult="";
	int iCheckTermYear = 0,iCheckTermMonth = 0,iCheckTermDay = 0;
	//当对象类型为合同所对应的批复信息时，获取最终审批意见所对应的申请信息
	if(sObjectType.equals("BusinessContract")||sObjectType.equals("ApproveApply") )
	{
		//获取最后终审的任务流水号
		sSql = 	" select max(SerialNo) "+
				" from FLOW_Task "+
				" where ObjectType = 'CreditApply' "+
				" and ObjectNo ='"+sRelativeSerialNo+"' ";
		String sTaskSerialNo = Sqlca.getString(sSql);
		
		//根据最后终审的任务流水号和对象编号获取相应的业务信息
		sSql = 	" select BA.BusinessSum,BA.BaseRate,BA.RateFloatType,BA.RateFloat, "+
				" BA.BusinessRate,BA.BailSum,BA.BailRatio,BA.PdgRatio,BA.PdgSum, "+
				" BA.TermYear,BA.TermMonth,BA.TermDay,BA.CognScore,BA.CognResult "+
				" from FLOW_OPINION BA "+
				" where BA.SerialNo =  (select RelativeSerialNo from Flow_Task where Serialno = '"+sTaskSerialNo+"') ";
	}
	
	if(sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract"))
	{
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			dCheckBusinessSum = rs.getDouble("BusinessSum");
			dCheckBaseRate = rs.getDouble("BaseRate");
			dCheckRateFloat = rs.getDouble("RateFloat");
			dCheckBusinessRate = rs.getDouble("BusinessRate");
			dCheckPdgRatio = rs.getDouble("PdgRatio");
			dCheckPdgSum = rs.getDouble("PdgSum");
			dCheckBailSum = rs.getDouble("BailSum");
			dCheckBailRatio = rs.getDouble("BailRatio");
			sCheckRateFloatType = rs.getString("RateFloatType");
			iCheckTermYear = rs.getInt("TermYear");
			iCheckTermMonth = rs.getInt("TermMonth");
			iCheckTermDay = rs.getInt("TermDay");
			dCognScore = rs.getDouble("CognScore");
			sCognResult = rs.getString("CognResult");
		}
		rs.getStatement().close(); 
		if(sCheckRateFloatType == null) sCheckRateFloatType = "";
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
				{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
				{"true","","Button","暂存","暂时保存所有修改内容","saveRecordTemp()",sResourcesPath}
		};
	//当暂存标志为否，即已保存，暂存按钮应隐藏
	if(sTempSaveFlag.equals("2"))
		sButtons[1][0] = "false";
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		//录入数据有效性检查
						
		if(vI_all("myiframe0"))
		{
			if("2110020" != "<%=sBusinessType%>" )
			{
				if(!ValidityCheck()) return;
			}
			if("BusinessContract" == "<%=sObjectType%>" ){
				getNewBaseRate();
			}else if("CreditApply" == "<%=sObjectType%>" ){
				if("2110020" == "<%=sBusinessType%>"){
					getAFBaseRateType();
				}else{
					getBaseRateType();
				}
			}
			beforeUpdate();
			setItemValue(0,getRow(),"TempSaveFlag","2"); //暂存标志（1：是；2：否）			
			as_save("myiframe0");
		}
	}
	
	/*~[Describe=暂存;InputParam=无;OutPutParam=无;]~*/
	function saveRecordTemp()
	{
		//0：表示第一个dw
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（1：是；2：否）
		as_save("myiframe0");   //再暂存
		setNeedCheckRequired(0);//最后再将必输项设置回来		
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{	
		sBusinessType = "<%=sBusinessType%>";	
		sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//获取保证金币种
		if(sBusinessType != "2050030")//进口信用证
		{
			getBailSum1();
		}
		if(sBusinessType.substring(0,4) != "2030" && sBusinessType.substring(0,4) != "2040" )//保函
		{
			getpdgsum1();
		}
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");			
	}
	
	/*~[Describe=进口信用证期限类型和远期信用证付款期限关联关系代码;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function checkBusinessSubType()
	{
	   sBusinessSubType = getItemValue(0,getRow(),"BusinessSubType");
	   if(sBusinessSubType == "01")
	   { 
	     setItemRequired(0,0,"GracePeriod",false);
	   }
	   else {setItemRequired(0,0,"GracePeriod",true); }
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{		
		//发生类型
		sOccurType = "<%=sOccurType%>";
		//余额
		dOldBalance = "<%=dOldBalance%>";
		//对象类型
		sObjectType = "<%=sObjectType%>";
		//对象编号
		sObjectNo = "<%=sObjectNo%>";
		//业务品种
		sBusinessType = "<%=sBusinessType%>";
		//批准金额
		dCheckBusinessSum = "<%=dCheckBusinessSum%>";

		//申请金额
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		//保证金金额
		dBailSum = getItemValue(0,getRow(),"BailSum");
		//手续费金额
		dPdgSum = getItemValue(0,getRow(),"PdgSum");
		//币种
		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
		//最高贷款金额
		dPromisesfeeSum = getItemValue(0,getRow(),"PromisesfeeSum");
		//最高期限
		dDealfee = getItemValue(0,getRow(),"Dealfee");
		//最高贷款比例
		dPromisesfeeRatio = getItemValue(0,getRow(),"PromisesfeeRatio");
		//期限
		dTermMonth = getItemValue(0,getRow(),"TermMonth");
		//贷款行业投向
		sDirection = getItemValue(0,getRow(),"Direction");
		//是否钢铁类授信
		sCreditSteel = getItemValue(0,getRow(),"CreditSteel");
		if(sDirection == "C3110" || sDirection == "C3120" || sDirection == "C3130" || sDirection == "C3140" || sDirection == "C3150" )
		{    
		     if(sCreditSteel == "2")
		     {
			    alert("此类贷款行业投向不能对应'是否钢铁类授信'类型为否！");
			    return;
			 }  
		}else if(sDirection != "F5165" && sDirection != "F5164")
		{
		     if(sCreditSteel == "1")
		     {
			    alert("此类贷款行业投向不能对应'是否钢铁类授信'类型为是！");
			    return;
			 } 
		}  				
		if(sBusinessType == "1110010" || sBusinessType == "1110025"){
			dThirdPartyID2 = getItemValue(0,getRow(),"ThirdPartyID2"); //房屋总价
			dThirdPartyAdd1 = getItemValue(0,getRow(),"ThirdPartyAdd1"); //首付金额 
			dThirdPartyZIP1 = getItemValue(0,getRow(),"ThirdPartyZIP1");//首付比例
			if(parseFloat(dThirdPartyID2-dBusinessSum) - parseFloat(dThirdPartyAdd1)>0.1||parseFloat(dThirdPartyID2-dBusinessSum) - parseFloat(dThirdPartyAdd1)<-0.1){
				alert("申请金额加首付金额不等于房屋总价！");
				return;
			}
			if(dThirdPartyZIP1<20){
				alert("首付比例不能小于20% ！");
				return;
			}
		}
		
		if("3010,3020,3015,3050,3060,3040".indexOf(sBusinessType)>-1)
		{
			//检查更改授信总额后，只允许增大，不允许缩小，缩小时，提示信息，并做更改
			sReturn = RunMethod("CreditLine","CheckCreditLineSum",sObjectNo+","+dBusinessSum+","+sObjectType+","+sBusinessCurrency+","+dPromisesfeeSum+","+dDealfee+","+dPromisesfeeRatio+","+dTermMonth+","+sBusinessType);
			if(sReturn == "01")	
			{
				alert("请先更改授信配额后再更改授信总额！");
				return false;					
			}
			if(sReturn == "02")	
			{
				alert("请先更改授信分配期限后再更改总授信期限！");
				return false;					
			}
			if(sReturn == "03")	
			{
				alert("请先更改从协议配额后再更改总额！");
				return false;					
			}
			if(sReturn == "04")	
			{
				alert("请先更改从协议最高贷款金额后再更改总授信最高贷款金额！");
				return false;					
			}
			if(sReturn == "05")	
			{
				alert("请先更改从协议最高贷款期限后再更改总授信最高贷款期限！");
				return false;					
			}
			if(sReturn == "06")	
			{
				alert("请先更改从协议最高贷款比例后再更改总授信最高贷款比例！");
				return false;					
			}
			
		}
		//期限控制		
		if(sObjectType == "CreditApply") //申请对象
		{
			//期限
			dTermMonth = getItemValue(0,getRow(),"TermMonth");
			if(sBusinessType=="1050020")
			{
				if(dTermMonth<0 || dTermMonth>24)
				{
					alert("期限必须大于等于0,小于等于24！");
					return false;
				}
			}else if(sBusinessType=="1050010")
			{
				if(dTermMonth<0 || dTermMonth>36)
				{
					alert("期限必须大于等于0,小于等于36！");
					return false;
				}
			}else if(sBusinessType=="1030040")
			{
				if(dTermMonth<0 || dTermMonth>96)
				{
					alert("期限必须大于等于0,小于等于96！");
					return false;
				}
			}else
			{
				if(dTermMonth<0)
				{
					alert("期限必须大于等于0！");
					return false;
				}
			}
		}
		
		
		
		if(sObjectType == "CreditApply") //申请对象
		{
			if(sOccurType == "015") //展期业务
			{
				dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
				if(dBusinessSum != dOldBalance)
				{
					alert(getBusinessMessage('511'));//展期金额必须等于展期前的业务余额！
					return false;
				}
			}
			
			//流动资金贷款 行业投向不能为房地产
			if(sBusinessType.substring(0,4) == "1010" && sOccurType !="015"&&sOccurType !="020"&&sOccurType !="060"&&sOccurType !="065")
			{
				var sIndustryType = getItemValue(0,getRow(),"Direction");
				if(sIndustryType.substring(0,1) == "K")
				{
					alert("流动资金贷款行业投向不能为房地产业！");
					return false;
				}
			}
			
			//在进口信用证业务品种下，校验保证金缴存金额不低于实际用信金额*保证金比例
			//if("<%=sBusinessType%>" == "2050030")//进口信用证
			if(sBusinessType == "2050030")//进口信用证
			{
			  dPracticeSum = getItemValue(0,getRow(),"PracticeSum");//实际用信金额
			  dBailSum = getItemValue(0,getRow(),"BailSum");//保证金金额
			  dBailRatio = getItemValue(0,getRow(),"BailRatio");//保证金比例
			  if(parseFloat(dBailSum) < parseFloat(dPracticeSum)*parseFloat(dBailRatio)/100)
			   {
					alert("保证金金额必须大于等于实际用信金额*保证金比例");
					return false;
			    }      
			}
			
			//在出口信用证打包贷款业务品种下，校验申请金额不得大于信用证金额和打包成数的乘积
			if(sBusinessType == "1080020")//出口信用证打包贷款
           {
             dOldLCSum = getItemValue(0,getRow(),"OldLCSum");//信用证金额
             dBusinessSum = getItemValue(0,getRow(),"BusinessSum");//申请金额
             dBusinessProp = getItemValue(0,getRow(),"BusinessProp");//打包成数
             if(parseFloat(dOldLCSum) * parseFloat(dBusinessProp)/100 < parseFloat(dBusinessSum))
              {
                alert("申请金额不得大于信用证金额*打包成数");
                return false;
              }
            }
			
			//校验申请金额与保证金金额之间的业务逻辑关系
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0)
			{	
				sBusinessType = "<%=sBusinessType%>";	        	
	        	//没有保证金币种 和保证金币种不可见
	        	if(sBusinessType == "2050020" || sBusinessType == "2050040" || sBusinessType == "1110070" ||  sBusinessType == "1150020" 
	        		|| sBusinessType == "2010" || sBusinessType == "2020" || sBusinessType.indexOf("2080") == 0 
	        		|| sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0 
	        		|| sBusinessType.indexOf("3030") == 0 || sBusinessType.indexOf("2090") == 0)
	        	{
					if(parseFloat(dBailSum) > parseFloat(dBusinessSum))
					{
						alert("保证金金额必须小于等于申请金额");
						return false;
					}
	        	}
	        	else
	        	{
	        		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//获取申请币种
		    		sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//获取保证金币种
		    		if(sBusinessCurrency != sBailCurrency)
		    		{
		    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
		            	if(parseFloat(dBailSum) > parseFloat(dBusinessSum*dERateRatio))
		            	{
		            		alert("保证金金额必须小于等于申请金额");
							return false;
						}
		            }
		            else
		            {
				        if(parseFloat(dBailSum) > parseFloat(dBusinessSum))
						{
							alert("保证金金额必须小于等于申请金额");
							return false;
						}
		            }
		        } 
			}
			
			//“出口信用证押汇”品种下，“发票金额”应大于“申请押汇金额”
			if("<%=sBusinessType%>" == "1080030" || "<%=sBusinessType%>" == "1080035")//出口信用证押汇
			  {	
				dInvoiceSum = getItemValue(0,getRow(),"InvoiceSum");//发票金额
			  	sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//获取申请币种
		    	sInvoiceCurrency = getItemValue(0,getRow(),"InvoiceCurrency");//获取发票币种
	    		if(sBusinessCurrency != sInvoiceCurrency)
	    		{
	    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sInvoiceCurrency+",''");
	            	if(parseFloat(dInvoiceSum) < parseFloat(dBusinessSum*dERateRatio))
	            	{
	            		alert("发票金额应大于申请金额！");
						return false;
					}
	            }else
	            {
			        if(parseFloat(dInvoiceSum) < parseFloat(dBusinessSum))
					{
						alert("发票金额应大于申请金额！");
						return false;
					}
	            }
			  }
			  //进口信用证押汇 申请金额”应小于等于“到单金额”*（1-“保证金比例
			if("<%=sBusinessType%>" == "1080070")//进口信用证押汇
			  {	
				dOldLCSum = getItemValue(0,getRow(),"OldLCSum");//到单金额
			  	sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//获取申请币种
		    	sOldLCCurrency = getItemValue(0,getRow(),"OldLCCurrency");//获取到单币种
		    	dBusinessProp = getItemValue(0,getRow(),"BusinessProp");//开证保证金比例
	    		if(sBusinessCurrency != sOldLCCurrency)
	    		{
	    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sOldLCCurrency+",''");
	            	if(parseFloat(dBusinessSum*dERateRatio) > dOldLCSum*(1-dBusinessProp/100))
	            	{
	            		alert("申请金额应小于等于到单金额*（1-保证金比例%)！");
						return false;
					}
	            }else
	            {
			        if(parseFloat(dBusinessSum) > dOldLCSum*(1-dBusinessProp/100))
					{
						alert("申请金额应小于等于到单金额*（1-保证金比例%)！");
						return false;
					}
	            }
			  }
			//校验申请金额与手续费金额之间的业务逻辑关系
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dPdgSum) >= 0)
			{
				if("<%=sBusinessType%>" == "2050020")//备用信用证
			    {	
			        sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
			    	sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
			    	dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");			
			      	if(parseFloat(dPdgSum) > parseFloat(dBusinessSum*dERateRatio))
					{
						alert("手续费金额必须小于或等于申请金额");
						return false;
					}
			    }else
			    {
					if(parseFloat(dPdgSum) > parseFloat(dBusinessSum))
					{
						alert("手续费金额必须小于或等于申请金额");
						return false;
					}
				}
			}
			 //个人工程机械贷款业务控制：1、贷款金额不得超过设备购买净值的70%。2、年限不得超过4年
			if("<%=sBusinessType%>" == "1140060")//个人工程机械贷款
			  {	
				dBusinessSum = getItemValue(0,getRow(),"BusinessSum");//申请金额
			  	dEquipmentSum = getItemValue(0,getRow(),"EquipmentSum");//设备购买净值
		    	dTermMonth = getItemValue(0,getRow(),"TermMonth");//期限
		    	if(parseFloat(dBusinessSum)>parseFloat(dEquipmentSum)*0.7)
		    	{
		    		alert("贷款金额不得超过设备购买净值的70%");
					return false;
		    	}
		    	if(parseFloat(dTermMonth)>48)
		    	{
		    		alert("年限不得超过4年");
					return false;
		    	}
			  }				 		
		}
		
		if(sObjectType == "CreditApply" || sObjectType == 'ApproveApply')
		{
			//检查提款方式和提款说明的关系
			sDrawingType = getItemValue(0,getRow(),"DrawingType");//提款方式（01：一次提款；02：分次提款）
			sContextInfo = getItemValue(0,getRow(),"ContextInfo");
			//业务品种为短期流动资金贷款、中期流动资金贷款、出口退税帐户托管贷款、
			//商业承兑汇票保贴、基本建设项目贷款、技术改造项目贷款、其他类项目贷款
			//银团贷款时
			if(sBusinessType == '1010010' || sBusinessType == '1010020'
			 || sBusinessType == '1010040' || sBusinessType == '1020040'
			 || sBusinessType == '1030010' || sBusinessType == '1030020'
			 || sBusinessType == '1030030' || sBusinessType == '1060'
			 || sBusinessType == '1030015' ) 
			{				
				if(typeof(sDrawingType) != "undefined" && sDrawingType != ""
				&& sDrawingType == "02" && (typeof(sContextInfo) == "undefined" 
				|| sContextInfo == ""))
				{
					alert(getBusinessMessage('490'));//如果提款方式为分次提款时，需输入提款说明！
					return false;
				}
			}
			
			//检查还款方式和还款说明的关系
			sCorpusPayMethod = getItemValue(0,getRow(),"CorpusPayMethod");//还款方式（1：一次还款；2：分次还款）
			sPaySource = getItemValue(0,getRow(),"PaySource");
			//业务品种为短期流动资金贷款、中期流动资金贷款、法人帐户透支、出口退税帐户托管贷款、
			//银行承兑汇票贴现、商业承兑汇票贴现、协议付息票据贴现、商业承兑汇票保贴、
			//基本建设项目贷款、技术改造项目贷款、其他类项目贷款、房地产开发贷款、银团贷款、
			//出口合同打包贷款、出口信用证打包贷款、出口信用证押汇与贴现、出口托收押汇与贴现、
			//出口商业发票融资、福费庭、进口信用证押汇、国内保理、进口保理、出口保理、黄金租赁业务、
			//转贷外国政府贷款、转贷国际金融组织贷款、国家外汇储备转贷款、发行债券转贷款、
			//其他转贷款、委托贷款时
			if(sBusinessType == '1010010' || sBusinessType == '1010020'
			 || sBusinessType == '1010030' || sBusinessType == '1010040'
			 || sBusinessType == '1020010' || sBusinessType == '1020020'
			 || sBusinessType == '1020030' || sBusinessType == '1020040'
			 || sBusinessType == '1030010' || sBusinessType == '1030020'
			 || sBusinessType == '1030030' || sBusinessType == '1050'
			 || sBusinessType == '1060' || sBusinessType == '1080010'
			 || sBusinessType == '1080020' || sBusinessType == '1080030'
			 || sBusinessType == '1080035' || sBusinessType == '1080045'
			 || sBusinessType == '1080040' || sBusinessType == '1080050'
			 || sBusinessType == '1080060' || sBusinessType == '1080070'
			 || sBusinessType == '1090010' || sBusinessType == '1090020'
			 || sBusinessType == '1090030' || sBusinessType == '1100010'
			 || sBusinessType == '2060010' || sBusinessType == '2060020'
			 || sBusinessType == '2060030' || sBusinessType == '2060040'
			 || sBusinessType == '2060050' || sBusinessType == '2060060'
			 || sBusinessType == '2070'|| sBusinessType == '1030015') 
			{
				if(typeof(sCorpusPayMethod) != "undefined" && sCorpusPayMethod != ""
				&& sCorpusPayMethod == "2" && (typeof(sPaySource) == "undefined" 
				|| sPaySource == ""))
				{
					alert(getBusinessMessage('491'));//如果还款方式为分次还款时，需输入还款说明！
					return false;
				}
			}
			
			
		}
		
		if(sObjectType == "BusinessContract")//合同对象
		{			
			//合同金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			if(parseFloat(dCheckBusinessSum) >= 0 && parseFloat(dBusinessSum) >= 0)
			{
				if(dBusinessSum > dCheckBusinessSum)
				{
					if(sOccurType == "015") //展期业务
					{
						alert(getBusinessMessage('552'));//展期金额(元)必须等于最终审批意见中的批准展期金额(元)！
						return false;
					}else
					{
						if(sBusinessType == '1020030') //协议付息票据贴现
						{
							alert(getBusinessMessage('553'));//票据总金额(元)必须小于或等于最终审批意见中的批准票据总金额(元)！
							return false;
						}else if(sBusinessType == '2050030' || sBusinessType == '2020' || sBusinessType == '2050020') //进口信用证、国内信用证、备用信用证
						{
							
							alert(getBusinessMessage('554'));//信用证金额(元)必须小于或等于最终审批意见中的批准信用证金额(元)！
							return false;
						}else if(sBusinessType == '2050010') //提货担保
						{
							alert(getBusinessMessage('555'));//单据金额(元)必须小于或等于最终审批意见中的批准单据金额(元)！
							return false;
						}else if(sBusinessType == '1100010') //黄金租赁业务
						{
							alert(getBusinessMessage('556'));//租赁黄金克数必须小于或等于最终审批意见中的批准租赁黄金克数！
							return false;
						}else if(sBusinessType == '3030010' || sBusinessType == '3030030' || sBusinessType == '3030020') //个人房屋贷款合作项目、个贷其它合作商、汽车消费贷款合作经销商
						{
							alert(getBusinessMessage('557'));//敞口总额度(元)必须小于或等于最终审批意见中的批准敞口总额度(元)！
							return false;
						}else
						{
							alert(getBusinessMessage('558'));//合同金额(元)必须小于或等于最终审批意见中的批准金额(元)！
							return false;
						}	
					}
				}
	
			}
	
			//合同起始日
			sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
			//合同到期日
			sMaturity = getItemValue(0,getRow(),"Maturity");			
			if(typeof(sPutOutDate) != "undefined" && sPutOutDate != ""
			&& typeof(sMaturity) != "undefined" && sMaturity != "")
			{
				if(sMaturity <= sPutOutDate)
				{
					if(sOccurType == "015") //展期业务
					{
						alert(getBusinessMessage('578'));//展期到期日必须晚于展期起始日！
						return false;
					}else
					{
						if(sBusinessType == '2050030') //进口信用证
						{
							alert(getBusinessMessage('579'));//到期日必须晚于开证日！
							return false;
						}else if(sBusinessType == '2020') //国内信用证
						{
							alert(getBusinessMessage('580'));//信用证有效期必须晚于开证日！
							return false;
						}else if(sBusinessType == '2050010' || sBusinessType == '2050020' 
						|| sBusinessType == '2090010' || sBusinessType == '2080030'
						|| sBusinessType == '2080020') 
						//提货担保、备用信用证、贷款担保、银行信贷证明、贷款意向书
						{
							alert(getBusinessMessage('581'));//到期日必须晚于发放日！
							return false;
						}else if(sBusinessType == '2050040') //对外保函
						{
							alert(getBusinessMessage('582'));//到期付款日必须晚于签发日！
							return false;
						}else if(sBusinessType == '2010') //银行承兑汇票
						{
							alert(getBusinessMessage('583'));//到期日必须晚于出票日！
							return false;
						}else if(sBusinessType == '2030010' || sBusinessType == '2030020'
						|| sBusinessType == '2030030' || sBusinessType == '2030040'
						|| sBusinessType == '2030050' || sBusinessType == '2030060'
						|| sBusinessType == '2030070' || sBusinessType == '2040010'
						|| sBusinessType == '2040020' || sBusinessType == '2040030'
						|| sBusinessType == '2040040' || sBusinessType == '2040050'
						|| sBusinessType == '2040060' || sBusinessType == '2040070'
						|| sBusinessType == '2040080' || sBusinessType == '2040090'
						|| sBusinessType == '2040100' || sBusinessType == '2040110') 
						//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、
						//付款保函、其他融资性保函、投标保函、履约保函、预付款保函、承包工程保函
						//质量维修保函、海事保函、补偿贸易保函、诉讼保函、留置金保函、
						//加工装配业务进口保函、其他非融资性保函
						{
							alert(getBusinessMessage('584'));//失效日期必须晚于生效日期！
							return false;
						}else if(sBusinessType == '2080010' || sBusinessType == '3010' 
						|| sBusinessType == '1110090' || sBusinessType == '1110110'
						|| sBusinessType == '3030020') 
						//贷款承诺函、综合授信额度、个人质押贷款、个人抵押贷款、汽车消费贷款合作经销商
						{
							alert(getBusinessMessage('585'));//到期日必须晚于起始日！
							return false;
						}else if(sBusinessType == '3030030') //个贷其它合作商
						{
							alert(getBusinessMessage('586'));//到期日必须晚于项下业务起始日！
							return false;
						}else
						{
							alert(getBusinessMessage('587'));//合同到期日必须晚于合同起始日！
							return false;
						}						
					}
				}else{
					if("<%=sApplyType%>" == "DependentApply"){
						sCreditAggreement =  getItemValue(0,getRow(),"CreditAggreement");
						//取得协议的到期日
						sAggreementMaturity = RunMethod("BusinessManage","GetMaturity",sCreditAggreement);
				
						dReturn = RunMethod("WorkFlowEngine","DateExcute",sAggreementMaturity+",5,-1");
		                dReturn1 = RunMethod("WorkFlowEngine","DateExcute",sAggreementMaturity+",11,-1");
						if(sMaturity > dReturn && sBusinessType == "2010")
						{
							alert("额度项下业务(银行承兑汇票）到期日不得超过额度后延6个月-1天！");
							return false;
                        }else if(sPutOutDate > sAggreementMaturity && sBusinessType != "2010"){
	                        alert("额度项下业务起始日不得超过额度到期日！");
	                        return false;
                        }else if(sMaturity > dReturn1 && sBusinessType != "2010"){
	                        alert("额度项下业务到期日不得超过额度后延1年-1天！");
	                        return false;
                        }
					}else if("CreditLineApply" == "<%=sApplyType%>"){
						dReturn = RunMethod("WorkFlowEngine","DateExcute","<%=sApproveDate%>,2,-1");
						if(sPutOutDate > dReturn)
						{
							alert("合同起始日超过了额度批准日后延3个月-1天！");
							return false;
						}
						/*remarked by lpzhang 2010-5-8 
						dReturn = RunMethod("CreditLine","CheckLineDate1",sSerialNo+","+sPutOutDate);
						if(dReturn > 92){
							alert("合同起始日与额度批准日超过了92天不能登记合同！");
							return false;
						}*/
					}	
					if(sOccurType == "015"){
						sTermDate1 = getItemValue(0,getRow(),"TermDate1");
						dReturn = RunMethod("BusinessManage","CheckExtendTime",sPutOutDate+","+sTermDate1);
						if(dReturn !=1){
							alert("“展期起始日”为“展期前到期日”的转天（第二天）!");
							return false;
						}
					}
				}
				
				//检验授信协议的额度生效日、额度使用最迟日期、额度项下业务最迟到期日期与起始日、到期日的逻辑关系
				sBeginDate = getItemValue(0,getRow(),"BeginDate");
				sLimitationTerm = getItemValue(0,getRow(),"LimitationTerm");
				sUseTerm = getItemValue(0,getRow(),"UseTerm");
				if(typeof(sBeginDate) != "undefined" && sBeginDate != "")
				{
					if(typeof(sPutOutDate) != "undefined" && sPutOutDate != "")
					{
						if(sBeginDate < sPutOutDate)
						{
							alert(getBusinessMessage('612'));//额度生效日必须晚于或等于起始日！
							return false;
						}
					}
					
					if(typeof(sMaturity) != "undefined" && sMaturity != "")
					{					
						if(sBeginDate >= sMaturity)
						{
							alert(getBusinessMessage('613'));//额度生效日必须早于到期日！
							return false;
						}
					}
					
					if(typeof(sLimitationTerm) != "undefined" && sLimitationTerm != "")
					{
						if(sLimitationTerm <= sBeginDate)
						{
							alert(getBusinessMessage('614'));//额度使用最迟日期必须晚于额度生效日！
							return false;
						}
					}
					
					if(typeof(sLimitationTerm) != "undefined" && sLimitationTerm != ""
					&& typeof(sMaturity) != "undefined" && sMaturity != "")
					{
						if(sLimitationTerm >= sMaturity)
						{
							alert(getBusinessMessage('615'));//额度使用最迟日期必须早于到期日！
							return false;
						}
					}
					
					if(typeof(sUseTerm) != "undefined" && sUseTerm != "")
					{
						if(sUseTerm <= sBeginDate)
						{
							alert(getBusinessMessage('616'));//额度项下业务最迟到期日期必须晚于额度生效日！
							return false;
						}
					}
					
					if(typeof(sUseTerm) != "undefined" && sUseTerm != ""
					&& typeof(sLimitationTerm) != "undefined" && sLimitationTerm != "")
					{
						if(sUseTerm <= sLimitationTerm)
						{
							alert(getBusinessMessage('617'));//额度项下业务最迟到期日期必须晚于额度使用最迟日期！
							return false;
						}
					}
				}
				
				
				//校验合同到期日与合同起始日之间的期限是否超过了批准的期限
				iCheckTermMonth = "<%=iCheckTermMonth%>";
				iCheckTermDay =  "<%=iCheckTermDay%>";
				if((typeof(iCheckTermDay) != "undefined" && iCheckTermDay != "") || (typeof(iCheckTermMonth) != "undefined" && iCheckTermMonth != ""))	
				{	/*
					var sPutOutYear = sPutOutDate.substring(0,4);
					var sPutOutMonth = sPutOutDate.substring(5,7);
					var sPutOutDate1 = sPutOutDate.substring(8,10);
					var sMaturityYear = sMaturity.substring(0,4);
					var sMaturityMonth = sMaturity.substring(5,7);
					var sMaturityDate = sMaturity.substring(8,10);	
					var iCheckTermMonth1 = (parseInt(sMaturityYear*12)+parseInt(sMaturityMonth*10)/10)-(parseInt(sPutOutYear*12)+parseInt(sPutOutMonth*10)/10);			
					if(typeof(iCheckTermDay) != "undefined" && iCheckTermDay != "" && iCheckTermDay>0){
						iCheckTermMonth1 = parseInt(iCheckTermMonth1)-1;
					}
					if(parseInt(iCheckTermMonth)<parseInt(iCheckTermMonth1)){
						alert("合同期限必须小于或等于最终审批意见中的期限（仅控制整月）");
						return;
					}
					*/
					//合同期限月(日)
					var dTermMonth = getItemValue(0,getRow(),"TermMonth");
					var dTermDay = getItemValue(0,getRow(),"TermDay");
					//修改为以下方式计算合同起始日和到期日
					var sCheckTermMonth = parseInt(iCheckTermMonth)-1;
					var iCheckTermDay1 =0;
					if(typeof(iCheckTermDay) != "undefined" && iCheckTermDay != "" && iCheckTermDay>0){
						iCheckTermDay1 =iCheckTermDay;
					}
					dReturn = RunMethod("WorkFlowEngine","DateExcute",sPutOutDate+","+sCheckTermMonth+","+iCheckTermDay1);
					if(sMaturity > dReturn && sBusinessType!='2050020' && sBusinessType!='2050030' && sBusinessType!='2050010')
					{
						alert("合同起始日到期日期限必须小于或等于最终审批意见中的期限！");
						return false;
					}
					if(dTermMonth==iCheckTermMonth)
					{
						if(dTermDay > iCheckTermDay1)
						{
							alert("合同期限必须小于或等于最终审批意见中的期限！");
							return false;
						}
					}else{
						if(dTermMonth > iCheckTermMonth)
						{
							alert("合同期限必须小于或等于最终审批意见中的期限！");
							return false;
						}
					}
					/*				
					a = new Date(sPutOutDate);
					b = new Date(sMaturity);			
					if(parseInt((b-a)/1000/24/60/60/30) > (parseInt(iCheckTermMonth)+parseInt(iCheckTermYear)*12))
					{
						alert(getBusinessMessage('591'));//合同期限必须小于或等于最终审批意见中的期限（仅控制整月）！
						return;
					}
					*/
				}			
			}
			
			
			
			//合同金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//保证金金额
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//手续费金额
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
			
			if("3010,3020,3015".indexOf(sBusinessType)>-1)
			{
				//检查更改授信总额后，只允许增大，不允许缩小，缩小时，提示信息，并做更改
				sReturn = RunMethod("CreditLine","CheckCreditLineSum",sObjectNo+","+dBusinessSum+","+sObjectType+","+sBusinessCurrency+","+dPromisesfeeSum+","+dDealfee+","+dPromisesfeeRatio+","+dTermMonth+","+sBusinessType);
				if(sReturn == "01")	
				{
					alert("请先更改授信配额后再更改授信总额！");
					return false;					
				}
				if(sReturn == "02")	
				{
					alert("请先更改授信分配期限后再更改总授信期限！");
					return false;					
				}
				if(sReturn == "03")	
				{
					alert("请先更改从协议配额后再更改总额！");
					return false;					
				}
				if(sReturn == "04")	
				{
					alert("请先更改从协议最高贷款金额后再更改总授信最高贷款金额！");
					return false;					
				}
				if(sReturn == "05")	
				{
					alert("请先更改从协议最高贷款期限后再更改总授信最高贷款期限！");
					return false;					
				}
				if(sReturn == "06")	
				{
					alert("请先更改从协议最高贷款比例后再更改总授信最高贷款比例！");
					return false;					
				}
				
			}
			sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
			dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+",01,''");
			if(sBusinessType == "2050010" || sBusinessType == "2050020" || sBusinessType == "2050040" || sBusinessType == "1110070" 
	        		|| sBusinessType == "2010" || sBusinessType == "2020" || sBusinessType.indexOf("2080") == 0 
	        		|| sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0 
	        		|| sBusinessType.indexOf("3030") == 0 || sBusinessType.indexOf("2090") == 0)
	        {
	        	dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+",01,''");
	        }
	        else
	        {
		    	sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//获取保证金币种
		    	if(!(typeof(sBailCurrency) != "undefined" && sBailCurrency != "")){
		    		sBailCurrency = "01";
		    	}
		    	dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
		    }	
			//校验合同金额与保证金金额之间的业务逻辑关系
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0)
			{
				if(parseFloat(dBailSum) > parseFloat(dBusinessSum*dErateRatio))
				{
					if(sBusinessType == '2050030' || sBusinessType == '2020' 
					|| sBusinessType == '2050020') //进口信用证、国内信用证、备用信用证
					{
						alert(getBusinessMessage('564'));//保证金金额(元)必须小于或等于信用证金额(元)！
						return false;
					}if(sBusinessType == '2050010') //提货担保
					{
						alert(getBusinessMessage('566'));//保证金金额(元)必须小于或等于单据金额(元)！
						return false;
					}if(sBusinessType == '3030010' || sBusinessType == '3030020' 
					|| sBusinessType == '3030030') //个人房屋贷款合作项目、汽车消费贷款合作经销商、个贷其它合作商
					{
						alert(getBusinessMessage('569'));//保证金金额(元)必须小于或等于敞口总额度(元)！
						return false;
					}else
					{
						alert("保证金金额(元)必须小于或等于合同金额(元)！");//保证金金额(元)必须小于或等于合同金额(元)！
						return false;
					}
				}
			}
			
			sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
			dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+",01,''");
			if("<%=sBusinessType%>" == "2050020")
	        {	
	        	sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
				dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
	        }
	        else
	        {
				dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+",01,''");
		    }				
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dPdgSum) >= 0)
			{
				if(parseFloat(dPdgSum) > parseFloat(dBusinessSum*dERateRatio))
				{
					if(sBusinessType == '2050030' || sBusinessType == '2020' 
					|| sBusinessType == '2050020') //进口信用证、国内信用证、备用信用证
					{
						alert(getBusinessMessage('565'));//手续费金额(元)必须小于或等于信用证金额(元)！
						return false;
					}if(sBusinessType == '2050010') //提货担保
					{
						alert(getBusinessMessage('567'));//手续费金额(元)必须小于或等于单据金额(元)！
						return false;
					}else if(sBusinessType != '1110170' && sBusinessType != '3030010' 
					&& sBusinessType != '3030020' && sBusinessType != '3030030' 
					&& sBusinessType != '1110027' && sBusinessType != '1110140' 
					&& sBusinessType != '1110150') //不为个人经营贷款、个人房屋贷款合作项目、
					//汽车消费贷款合作经销商、个贷其它合作商、个人住房公积金贷款、商业助学贷款、国家助学贷款
					{
						alert(getBusinessMessage('574'));//手续费金额(元)必须小于或等于合同金额(元)！
						return false;
					}
				}
			}
			
			//批准的基准利率
			sCheckBaseRate = "<%=dCheckBaseRate%>";
			//批准的利率浮动方式
			sCheckRateFloatType = "<%=sCheckRateFloatType%>";
			//批准的利率浮动值
			sCheckRateFloat = "<%=dCheckRateFloat%>";
			//基准利率
			sBaseRate = getItemValue(0,getRow(),"BaseRate");
			//利率浮动方式
			sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
			//利率浮动值
			sRateFloat = getItemValue(0,getRow(),"RateFloat");

			if(typeof(sRateFloatType) != "undefined" && sRateFloatType != ""
			&& typeof(sCheckRateFloatType) != "undefined" && sCheckRateFloatType != "")
			{
				if(sRateFloatType == sCheckRateFloatType)
				{
					if(parseFloat(sRateFloat) >= 0 && parseFloat(sCheckRateFloat) >= 0)
					{
						if(parseFloat(sRateFloat) < parseFloat(sCheckRateFloat))
						{
							alert(getBusinessMessage('560'));//利率浮动值必须大于或等于最终审批意见中的利率浮动值！
							return false;
						}
					}
				}
			}			
		}
		
		if(sBusinessType == '1020030') //协议付息票据贴现
		{
			//贴现利息
			sDiscountInterest = getItemValue(0,getRow(),"DiscountInterest");
			//买方应付贴现利息
			sPurchaserInterest = getItemValue(0,getRow(),"PurchaserInterest");
			if(parseFloat(sDiscountInterest) >= 0 && parseFloat(sPurchaserInterest) >= 0)
			{
				if(parseFloat(sPurchaserInterest) > parseFloat(sDiscountInterest))
				{
					alert(getBusinessMessage('561'));//买方应付贴现利息(元)必须小于或等于贴现利息(元)！
					return false;
				}
			}
		}
		
		//判断远期是否输入[出口信用证打包贷款]
		if(sBusinessType == "1080020") 
		{
		    var sGracePeriod = getItemValue(0,getRow(),"GracePeriod");
		    var sOldLCTermType = getItemValue(0,getRow(),"OldLCTermType");
		    if(sOldLCTermType != "01" && sOldLCTermType != "" && typeof(sOldLCTermType) != "undefined")
		    {
    		    if(typeof(sGracePeriod) == "undefined" || sGracePeriod == "")
    		    {
    		        alert(getBusinessMessage('494')); //选择远期信用证类型时，需输入远期信用证付款期限！
    		        return;
    		    }
		    }
		}
		
		//判断远期是否输入[国内信用证]
		if(sBusinessType == "2020") 
		{		
			//校验开证行邮编
			sThirdPartyZIP2 = getItemValue(0,getRow(),"ThirdPartyZIP2");//开证行邮编
			if(typeof(sThirdPartyZIP2) != "undefined" && sThirdPartyZIP2 != "" )
			{	
				if(!CheckPostalcode(sThirdPartyZIP2))
				{
					alert(getBusinessMessage('489'));//开证行邮编有误！
					return false;
				}
			}
			
			//校验受益人邮编
			sThirdPartyZIP1 = getItemValue(0,getRow(),"ThirdPartyZIP1");//受益人邮编
			if(typeof(sThirdPartyZIP1) != "undefined" && sThirdPartyZIP1 != "" )
			{	
				if(!CheckPostalcode(sThirdPartyZIP1))
				{
					alert(getBusinessMessage('488'));//受益人邮编有误！
					return false;
				}
			}
		
		    var sTermDay = getItemValue(0,getRow(),"TermDay");		    
		    var sBusinessSubType = getItemValue(0,getRow(),"BusinessSubType");		    		    
		    if(sBusinessSubType != "01" && sBusinessSubType != "" && typeof(sBusinessSubType)!= "undefined")
		    {
    		    if(sTermDay == "")
    		    {
    		        alert(getBusinessMessage('494')); //选择远期信用证类型时，需输入远期信用证付款期限！
    		        return;
    		    }
		    }
		}
		
		//银团贷款
		if(sBusinessType=="1060")
		{
			var sApplyDate  =  "<%=StringFunction.getToday()%>";
			var sFirstDrawingDate = getItemValue(0,getRow(),"FirstDrawingDate");
			var sPromisesFeeBegin = getItemValue(0,getRow(),"PromisesFeeBegin");
			
			if(sFirstDrawingDate < sApplyDate)
			{	
				alert("首次提款日必须大于申请日期!");
				return;
			}
			if(sPromisesFeeBegin < sApplyDate)
			{	
				alert("承诺费计收起始日必须大于申请日期!");
				return;
			}
		
		}
		//判断有其他担保方式的时候，不能以信用担保做主要担保方式
		var sVouchType = getItemValue(0,getRow(),"VouchType");
		var sVouchClass = getItemValue(0,getRow(),"VouchClass");
		var sVouchFlag = getItemValue(0,getRow(),"VouchFlag");
		if(sVouchFlag == "1") //010有其他担保方式
		{
		    if(sVouchType == "005") //005信用担保
		    {
		        alert(getBusinessMessage('551'));//有其他担保方式时，主要担保方式不能用信用担保！
		        return false;
		    }		    
		}
		
		//二手房资金协议号 2009-11-20alert("@@@@@@"+"<%=sBusinessType%>");  	
		if(sBusinessType=="1110020" || sBusinessType=="1140020" )
		{
			var sThirdParty1  = getItemValue(0,getRow(),"ThirdParty1");
			
			if(typeof(sThirdParty1) == "undifined" || sThirdParty1 == "")
			{
				if(confirm("是否需要输入资金协议号?"))
				{
					getASObject(0,0,"ThirdParty1").focus();
					return false;
				}
			}
		}
		
		//银行承兑汇票 申请金额不能大于贸易背景合同金额验证
		if(sBusinessType == "2010"){
			var dTradeSum = getItemValue(0,getRow(),"TradeSum");
			if(dBusinessSum>dTradeSum){
				alert("申请金额不能大于贸易背景合同金额");
				return false;
			}
			var sCycleFlag = getItemValue(0,getRow(),"CycleFlag");
			var sTermMonth = getItemValue(0,getRow(),"TermMonth");
			if(sCycleFlag == "2" && sTermMonth > 6){
				alert("此笔业务不可循环，期限不能大于6个月！");
				return false;
			} 	
		}
		//中期流动资金贷款控制期限必须为12个月以上 lpzhang 2009-12-30
		if(sBusinessType == "1010020")
		{
			var dTermMonth = getItemValue(0,getRow(),"TermMonth");
			var dTermDay = getItemValue(0,getRow(),"TermDay");
			if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			{
				dTermMonth = dTermMonth+1;
			}
			/*if(dTermMonth<=12)
			{
				alert("中期流动资金贷款期限必须是12个月以上！");
				return false;
			}*/
		}
		//短期流动资金贷款控制期限必须为12个月以下 lpzhang 2010-1-5 
		if(sBusinessType == "1010010")
		{
			var dTermMonth = getItemValue(0,getRow(),"TermMonth");
			var dTermDay = getItemValue(0,getRow(),"TermDay");
			if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			{
				dTermMonth = dTermMonth+1;
			}
			/*if(dTermMonth>12)
			{
				alert("短期流动资金贷款期限必须是12个月以下！");
				return false;
			}*/
		}
		
		if(sBusinessType == "1140110" && "<%=sObjectType%>" == "BusinessContract" ){
			var sContextInfo = getItemValue(0,getRow(),"ContextInfo");
			var sPaySource = getItemValue(0,getRow(),"PaySource");	
			if((typeof(sContextInfo) == "undefined" || sContextInfo == "") && (typeof(sPaySource) == "undefined" || sPaySource == "")){
				alert("核保人必须填写一个！");
				return false;
			}		
		}
		//其他公职人员贷款控制是否是本行员工，如果不是本行员工就不能选择员工消费贷款
		if(sBusinessType == "1110190"){
			var  sFlag1 = getItemValue(0,getRow(),"Flag1");
			if("020" == sFlag1){
				sReturn = RunMethod("BusinessManage","SelectStaff","<%=sCustomerID%>");
				if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "2"){
					alert("该客户不是本行员工，不能选择员工消费贷款！");
					setItemValue(0,getRow(),"Flag1","");
					getASObject(0,0,"Flag1").focus();
					return false;
				}
			}
		}
		
		if(sBusinessType.indexOf("1110") == 0 || sBusinessType.indexOf("1140") == 0 ){
			sICType = getItemValue(0,getRow(),"ICType");
			sPayCyc = getItemValue(0,getRow(),"PayCyc");
			sCorPusPayMethod = getItemValue(0,getRow(),"CorPusPayMethod");
			sPaySource = getItemValue(0,getRow(),"PaySource");
			if((sICType == "060" || sPayCyc == "060" || sCorPusPayMethod == "080") && (typeof(sPaySource) == "undefined" || sPaySource == "")){
				alert("您选择了“按约还本”、“约定还款法”、“按约还本”中的一项或几项，请填写还款说明！");
				return false;
			}
		}
		//“主要担保方式”选择“担保公司保证”的，则“是否有担保公司担保”必须选择“是”
		sVouchCorpFlag =  getItemValue(0,getRow(),"VouchCorpFlag");
		if(sVouchType.indexOf("01030") == 0 && sVouchCorpFlag!='1' && sBusinessType.indexOf("3")!=0)
		{
			alert("“主要担保方式”选择“担保公司保证”，“是否有担保公司担保”请选择“是”！");
			return false;
		}
		//查询提示当前是否有最新的外币利率信息
		if(sObjectType == "CreditApply") //申请对象
		{
			//利率类型
			sBaseRateType =  getItemValue(0,getRow(),"BaseRateType");
			if(sBusinessCurrency!="01" && typeof(sBaseRateType)!="undefined" && sBaseRateType.length!=0)
			{
				sReturn=RunMethod("PublicMethod","GetColValue","count(RateID),RATE_INFO,String@RateID@"+sBaseRateType+"@String@Currency@"+sBusinessCurrency+"@String@EfficientDate@<%=StringFunction.getToday()%>");
				sReturnInfo=sReturn.split("@")
				if(typeof(sReturnInfo[1])=="undefined" || sReturnInfo[1].length==0||sReturnInfo[1] == ""  || sReturnInfo[1] == "null" || sReturnInfo[1]=="0") 
				{	
					alert("提示:当前不是最新的外币利率!");
				}
			}
		}
		/*if("<%=sApplyType%>" =="DependentApply"){
			var dTermMonth = getItemValue(0,getRow(),"TermMonth");
			var dTermDay = getItemValue(0,getRow(),"TermDay");
			if(typeof(dTermMonth) == "undefined" && dTermMonth == ""){
				dTermMonth = 0;
			}
			if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			{
				dTermMonth = dTermMonth+1;
			}
			dBailRatio = 0;
			if(sBusinessType == "2010"){
				dBailRatio = getItemValue(0,getRow(),"BailRatio"); //获取保证金比例
			}
			sReturn=RunMethod("BusinessManage","ControlCreditLine","<%=sBAAgreement%>"+","+sBusinessType+","+dTermMonth+","+dBailRatio+","+dBusinessSum+","+"<%=sObjectNo%>"+","+"<%=sObjectType%>");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				PopPage("/Common/WorkFlow/CheckLineView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
				return;  //该“return”是否有效视具体业务需求而定
			}
		}*/
		return true;
	}
	
	/*~[Describe=弹出授信额度选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCreditLine()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//请先选择客户！
			return;
		}
		//查找该客户的有效授信协议
		sParaString = "CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
		setObjectValue("SelectCLContract",sParaString,"@CreditAggreement@0",0,0,"");
	}
			
	/*~[Describe=选择主要担保方式;InputParam=无;OutPutParam=无;]~*/
	function selectVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	/*~[Describe=选择敞口部分反担保方式;InputParam=无;OutPutParam=无;]~*/
	function selectOpenVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchFlag@0@VouchFlagName@1",0,0,"");		
	}
	
	//抵押和质押担保
	function selectVouchType1() {
		ssBusinessType = "<%=sBusinessType%>";
		sParaString = "CodeNo"+","+"VouchType";
		if(ssBusinessType == "1140110")
		setObjectValue("SelectImpawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");
		else 
		setObjectValue("SelectPawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");	
			
	}
	
	//保证担保
	function selectVouchType2() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectAssureCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	//抵押质押担保
	function selectVouchType3() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectPawnImpawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	/*~[Describe=弹出经办人选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser(sType)
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.OrgID%>";
		if(sType == "OperateUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0,"");		
		if(sType == "ManageUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@ManageUserID@0@ManageUserName@1@ManageOrgID@2@ManageOrgName@3",0,0,"");	
		if(sType == "RecoveryUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@RecoveryUserID@0@RecoveryUserName@1@RecoveryOrgID@2@RecoveryOrgName@3",0,0,"");			
	}
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectOrg(sType)
	{		
		if(sType == "StatOrg")
			setObjectValue("SelectAllOrg","","@StatOrgID@0@StatOrgName@1",0,0,"");		
	}
	
	/*~[Describe=弹出保函类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectAssureType()
	{		
		sParaString = "CodeNo"+","+"AssureType";
		setObjectValue("SelectCode",sParaString,"@SafeGuardType@0@SafeGuardTypeName@1",0,0,"");		
	}

	/*~[Describe=选择行业投向（国标行业类型）;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"Direction");
		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
			sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
			setItemValue(0,getRow(),"Direction",sIndustryTypeValue);
			setItemValue(0,getRow(),"DirectionName",sIndustryTypeName);				
		}
		//根据‘贷款行业投向’动态设置‘是否钢铁类授信’是否为只读及取值
		var sDirection = getItemValue(0,getRow(),"Direction");
		if(sDirection == "F5165" || sDirection == "F5164")
		{
		     setItemDisabled(0,0,"CreditSteel",false);
		    // setItemValue(0,getRow(),"CreditSteel","0"); //（1：是；2：否；0:需选择）		
		}else if(sDirection == "C3110" || sDirection == "C3120" || sDirection == "C3130" || sDirection == "C3140" || sDirection == "C3150")
		{
			 setItemDisabled(0,0,"CreditSteel",true);
			 setItemValue(0,getRow(),"CreditSteel","1");
		}else 
		{
		     setItemDisabled(0,0,"CreditSteel",true);
			 setItemValue(0,getRow(),"CreditSteel","2");
		}  			
	}
	
	/*~[Describe=根据自定义小数位数四舍五入,参数object为传入的数值,参数decimal为保留小数位数;InputParam=基数，四舍五入位数;OutPutParam=四舍五入后的数据;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
    	
	}
	
	/*~[Describe=根据基准利率、利率浮动方式、利率浮动值计算执行年(月)利率;InputParam=无;OutPutParam=无;]~*/
	function getBusinessRate(sFlag)
	{
		if("<%=sObjectType%>" == "ReinforceContract")
		{
			return;
		}
	
		//业务类型
		sBusinessType = "<%=sBusinessType%>";
		//基准利率
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//利率浮动方式
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//利率浮动值
		dRateFloat = getItemValue(0,getRow(),"RateFloat");
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 )
		{			
			if(sRateFloatType=="0")	//浮动百分比
			{
				if(sFlag == 'Y') //执行年利率
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
				if(sFlag == 'M') //执行月利率
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else	//1:浮动点数
			{
				if(sFlag == 'Y') //执行年利率
					dBusinessRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				if(sFlag == 'M') //执行月利率
					dBusinessRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
			}
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);
		}else
		{
			setItemValue(0,getRow(),"BusinessRate","");
		}
		if(sBusinessType == "1020010" || sBusinessType == "1020020")
		{
			dBusinessRate = parseFloat(dBaseRate)/1.2;
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);
		}
	}
	
	/*~[Describe=计算贴现利息和实付贴现金额;InputParam=无;OutPutParam=无;]~*/
	function getDiscountInterest()
	{
		//月利率
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//票据总金额
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		//获取贴现利息
		if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBusinessRate) >= 0)
		{
			//贴现利息＝票据总金额×月利率
			dDiscountInterst = roundOff(parseFloat(dBusinessSum) * parseFloat(dBusinessRate)/1000,2);
			//贴现实付金额＝票据总金额－贴现利息
			dDiscountSum = parseFloat(dBusinessSum) - parseFloat(dDiscountInterst);
			setItemValue(0,getRow(),"DiscountInterest",dDiscountInterst);
			setItemValue(0,getRow(),"DiscountSum",dDiscountSum);
		}
	}
	
	/*~[Describe=计算卖方应付贴现利息;InputParam=无;OutPutParam=无;]~*/
	function getBargainorInterest()
	{
		//贴现利息
		dDiscountInterest = getItemValue(0,getRow(),"DiscountInterest");
		//买方应付贴现利息
		dPurchaserInterest = getItemValue(0,getRow(),"PurchaserInterest");
		//获取卖方应付贴现利息
		if(parseFloat(dDiscountInterest) >= 0 && parseFloat(dPurchaserInterest) >= 0)
		{
			//卖方应付贴现利息＝贴现利息－买方应付贴现利息
			dBargainorInterest = parseFloat(dDiscountInterest) - parseFloat(dPurchaserInterest);
			setItemValue(0,getRow(),"BargainorInterest",dBargainorInterest);
		}
	}
	
	/*~[Describe=计算逾期利率;InputParam=无;OutPutParam=无;]~*/
	function getOverdueRate()
	{
		//逾期浮动比例
		dOverdueRateFloat = getItemValue(0,getRow(),"OverdueRateFloat");
		//执行月利率
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//逾期利率＝执行利率*（1+逾期浮动比例）
		dOverdueRate = parseFloat(dBusinessRate)*(1+parseFloat(dOverdueRateFloat)/100.00);
		setItemValue(0,getRow(),"OverdueRate",roundOff(dOverdueRate,6));
	}
	
	/*~[Describe=挤占/挪用利率InputParam=无;OutPutParam=无;]~*/
	function getTARate()
	{
		//挤占/挪用浮动比例
		dTARateFloat = getItemValue(0,getRow(),"TARateFloat");
		//执行月利率
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//挤占/挪用利率＝执行利率*（1+挤占/挪用浮动比例）
		dTARate = parseFloat(dBusinessRate)*(1+parseFloat(dTARateFloat)/100.00);
		setItemValue(0,getRow(),"TARate",roundOff(dTARate,6));
	}
	
	/*~[Describe=银团贷款中“我行贷款份额占比”计算;InputParam=无;OutPutParam=无;]~*/	
	function setBusinessProp()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    dTradeSum = getItemValue(0,getRow(),"TradeSum");
        dBusinessProp = roundOff(parseFloat(dBusinessSum)/parseFloat(dTradeSum)*100,2);
		if(dBusinessProp>0)
		{
			 setItemValue(0,getRow(),"BusinessProp",dBusinessProp);
		}
    }
	
	/*~[Describe=根据手续费率计算手续费;InputParam=无;OutPutParam=无;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //获取申请金额
	    if(parseFloat(dBusinessSum) >= 0)
	    {
			dPdgRatio = getItemValue(0,getRow(),"PdgRatio");//获取手续费比例
	    	if(parseFloat(dPdgRatio) >= 0)
	    	{
	    		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");		
	    		sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
	    		if(typeof(sFeeCurrency) == "undefined" || sFeeCurrency == "" ){
		        	sFeeCurrency = "01";
		        }
	        	dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
		    	dPdgRatio = roundOff(dPdgRatio,2);
			    dPdgSum = (parseFloat(dBusinessSum)*dErateRatio)*parseFloat(dPdgRatio)/1000;
			    dPdgSum = roundOff(dPdgSum,2);
			    if(dPdgSum<300 && ("<%=sBusinessType%>" == "2050030" || "<%=sBusinessType%>" == "2050010"))
					dPdgSum = 300.00;	
			    setItemValue(0,getRow(),"PdgSum",dPdgSum);
			}
		}
	}
	
	/*~[Describe=根据手续费计算手续费率;InputParam=无;OutPutParam=无;]~*/
	function getPdgRatio()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    sBusinessType = getItemValue(0,getRow(),"BusinessType");
	    //保函业务不进行反算
	    if(parseFloat(dBusinessSum) >= 0 && sBusinessType.substring(0,4)!="2040" && sBusinessType.substring(0,4)!="2030")
	    {
	        dPdgSum = getItemValue(0,getRow(),"PdgSum");
	        dPdgSum = roundOff(dPdgSum,2);
	        if(parseFloat(dPdgSum) >= 0)
	        {	       
	            dPdgRatio = parseFloat(dPdgSum)/parseFloat(dBusinessSum)*1000;
	            dPdgRatio = roundOff(dPdgRatio,2);
	            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
	        }
	    }
	}
	
	/*~[Describe=检查"零"天数是否合法;InputParam=无;OutPutParam=无;]~*/
	function getTermDay()
	{
	    dTermDay = getItemValue(0,getRow(),"TermDay");
	    if(parseInt(dTermDay) > 30 )
	    {
	    	if(!(sBusinessType=="2050030") && !(sBusinessType=="2020"))
	        alert("零(天)必须小于等于30！");
	    }
	}
	
	/*~[Describe=根据首付金额计算首付比例;InputParam=无;OutPutParam=无;]~*/
	function getThirdPartyRatio()
	{
	    //dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    sBusinessType = "<%=sBusinessType%>";
	    //取房屋总价@jlwu
	    sThirdPartyID2 = getItemValue(0,getRow(),"ThirdPartyID2");
	    dThirdPartyID2 = parseFloat(sThirdPartyID2);
	    sThirdParty = getItemValue(0,getRow(),"ThirdPartyAdd1");
	    dThirdParty = parseFloat(sThirdParty);
	    if(parseFloat(sThirdPartyID2) >= 0)
	    {
	        dThirdParty = roundOff(dThirdParty,2);
	        
	        if(parseFloat(dThirdParty) >= 0)
	        {	     
	            dThirdPartyRatio = parseFloat(dThirdParty)/parseFloat(dThirdPartyID2)*100;
	            dThirdPartyRatio = roundOff(dThirdPartyRatio,2);
	            dThirdPartyRatio+="";
	            setItemValue(0,getRow(),"ThirdPartyZIP1",dThirdPartyRatio);
	            setItemValue(0,getRow(),"ThirdPartyZIP2",100-dThirdPartyRatio);//按揭贷款成数
	        }
	    }
	}
	
	/*~[Describe=根据保证金比例计算保证金金额;InputParam=无;OutPutParam=无;]~*/
	function getBailSum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //获取申请金额
	    if(parseFloat(dBusinessSum) >= 0)
	    {	
	    	dBailRatio = getItemValue(0,getRow(),"BailRatio"); //获取保证金比例
	        if(parseFloat(dBailRatio) >= 0)
	        {	
	        	dBailRatio = roundOff(dBailRatio,2);	        	
	        	sBusinessType = "<%=sBusinessType%>";
		        sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//获取申请币种
		        sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//获取保证金币种
		        ddBailSum = 0.00;
		        dERateRatio = 1.00;
		        if(typeof(sBailCurrency) == "undefined" || sBailCurrency == "" ){
		        	sBailCurrency = "01";
		        }
		        if(sBusinessCurrency == sBailCurrency){
		           	dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
		        }
	 			else{
	    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
	            	dBailSum = parseFloat(dBusinessSum*dERateRatio)*parseFloat(dBailRatio)/100;
	            }		        
           		dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	            //银行承兑汇票、融资性保函、非融资性保函
			    if(sBusinessType == "2010" || sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0)
			    {	
			    	setItemValue(0,getRow(),"ExposureSum",roundOff((dBusinessSum-dBailSum/dERateRatio),2));
			    }
	        }
	    }	  
	}
	
	/*~[Describe=根据保证金金额计算保证金比例;InputParam=无;OutPutParam=无;]~*/
	function getBailRatio()
	{
	    /*默认与当前币种一样
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
		*/
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailSum = getItemValue(0,getRow(),"BailSum");
	        if(parseFloat(dBailSum) >= 0)
	        {	        
				dBailSum = roundOff(dBailSum,2);
	            dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;
	            dBailRatio = roundOff(dBailRatio,2);
	            setItemValue(0,getRow(),"BailRatio",dBailRatio);
				if (dBailRatio=="100") {
					setItemValue(0,getRow(),"VouchType",'005');
					setItemValue(0,getRow(),"VouchTypeName",'信用');
				}
	        }
	    }
	}
	
	/*--------------------- add by zwhu -----------------*/
	
	/*~[Describe=根据手续费率计算手续费;InputParam=无;OutPutParam=无;]~*/
	function getpdgsum1()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //获取申请金额
	    if(parseFloat(dBusinessSum) >= 0)
	    {
			dPdgRatio = getItemValue(0,getRow(),"PdgRatio");//获取手续费比例
	    	if(parseFloat(dPdgRatio) >= 0)
	    	{
	    		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");		
	    		sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
	    		if(typeof(sFeeCurrency) == "undefined" || sFeeCurrency == "" ){
		        	sFeeCurrency = "01";
		        }
	        	dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
		    	dPdgRatio = roundOff(dPdgRatio,2);
			    dPdgSum = (parseFloat(dBusinessSum)*dErateRatio)*parseFloat(dPdgRatio)/1000;
			    dPdgSum = roundOff(dPdgSum,2);
			    if(dPdgSum<300 && ("<%=sBusinessType%>" == "2050030" || "<%=sBusinessType%>" == "2050010"))
					dPdgSum = 300.00;	
			    setItemValue(0,getRow(),"PdgSum",dPdgSum);
			}
		}
	}
	
	/*~[Describe=根据手续费计算手续费率;InputParam=无;OutPutParam=无;]~*/
	function getPdgRatio1()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {	
	    	if("<%=sBusinessType%>" == "2050020")//备用信用证
	    	{	
	    		dPdgSum = getItemValue(0,getRow(),"PdgSum");
	    		if(parseFloat(dPdgSum) >= 0)
		        {	
		        	dPdgSum = roundOff(dPdgSum,2);
		    		sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
			    	sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
			    	dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
			    	dPdgRatio = parseFloat(dPdgSum)/(parseFloat(dBusinessSum)*dERateRatio)*1000
			    	dPdgRatio = roundOff(dPdgRatio,2);
			    	setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
		    	}
	    	}
	    	else
	    	{
		        dPdgSum = getItemValue(0,getRow(),"PdgSum");
		        if(parseFloat(dPdgSum) >= 0)
		        {	     
		        	dPdgSum = roundOff(dPdgSum,2);  
		            dPdgRatio = parseFloat(dPdgSum)/parseFloat(dBusinessSum)*1000;
		            dPdgRatio = roundOff(dPdgRatio,2);
		            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
		        }
	        }
	    }
	}
	
	/*~[Describe=根据保证金比例计算保证金金额;InputParam=无;OutPutParam=无;]~*/
	function getBailSum1()
	{	
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //获取申请金额
	    if(parseFloat(dBusinessSum) >= 0)
	    {	
	    	dBailRatio = getItemValue(0,getRow(),"BailRatio"); //获取保证金比例
	        if(parseFloat(dBailRatio) >= 0)
	        {	
	        	dBailRatio = roundOff(dBailRatio,2);	        	
	        	sBusinessType = "<%=sBusinessType%>";
		        sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//获取申请币种
		        sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//获取保证金币种
		        ddBailSum = 0.00;
		        dERateRatio = 1.00;
		        if(typeof(sBailCurrency) == "undefined" || sBailCurrency == "" ){
		        	sBailCurrency = "01";
		        }
		        if(sBusinessCurrency == sBailCurrency){
		           	dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
		        }
	 			else{
	    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
	            	dBailSum = parseFloat(dBusinessSum*dERateRatio)*parseFloat(dBailRatio)/100;
	            }		        
           		dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	            //银行承兑汇票、融资性保函、非融资性保函
			    if(sBusinessType == "2010" || sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0)
			    {	
			    	setItemValue(0,getRow(),"ExposureSum",roundOff((dBusinessSum-dBailSum/dERateRatio),2));
			    }
	        }
	    }	    
	}
	
	
	/*~[Describe=发送公积金系统获取相关信息;InputParam=无;OutPutParam=无;]~*/
	function SendGDTrade6020()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");//申请流水号
		sAFALoanFlag = getItemValue(0,getRow(),"AFALoanFlag"); //是否组合贷款
		sCommercialNo = getItemValue(0,getRow(),"CommercialNo"); //商贷贷款号
		sAccumulationNo = getItemValue(0,getRow(),"AccumulationNo"); //委贷贷款号
		sPhaseNo = "";
		//取该笔申请对应的流程阶段号
		sReturn = RunMethod("PublicMethod","GetColValue","PhaseNo,FLOW_OBJECT,String@ObjectType@CreditApply@String@ObjectNO@"+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			sReturnValue = sReturn.split('@');
			sPhaseNo = sReturnValue[1];
		}
		if(sPhaseNo!="0010" && sPhaseNo!="3000")
		{
			alert("不是申请阶段不能发送！");
			return;
		}
		sTradeType = "6020";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+"CreditApply"+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000")
		{
			alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else
		{
			alert("发送个贷成功！"+sReturn[1]);
			sReturn = RunMethod("BusinessManage","UpdateTrade6020",sObjectNo+","+sCommercialNo+","+sAccumulationNo);
			if(typeof(sReturn)!="undefined" && sReturn.length!=0)
			{
				alert(sReturn);
			}
			reloadSelf();
		}
		return;
	}
	
		
	/*~[Describe=发送公积金系统获取相关变更信息;InputParam=无;OutPutParam=无;]~*/
	function SendGDTrade6030()
	{
		//alert("变更");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");//申请流水号
		sAFALoanFlag = getItemValue(0,getRow(),"AFALoanFlag"); //是否组合贷款
		sCommercialNo = getItemValue(0,getRow(),"CommercialNo"); //商贷贷款号
		sAccumulationNo = getItemValue(0,getRow(),"AccumulationNo"); //委贷贷款号
		sChangType = getItemValue(0,getRow(),"ChangType"); //变更类型
		sPhaseNo = "";
		//取该笔申请对应的流程阶段号
		sReturn = RunMethod("PublicMethod","GetColValue","PhaseNo,FLOW_OBJECT,String@ObjectType@CreditApply@String@ObjectNO@"+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			sReturnValue = sReturn.split('@');
			sPhaseNo = sReturnValue[1];
		}
		if(sPhaseNo!="0010" && sPhaseNo!="3000")
		{
			alert("不是申请阶段不能发送！");
			return;
		}
		sTradeType = "6030";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+"CreditApply"+","+sTradeType+","+sChangType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000")
		{
			alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else
		{
			alert("发送个贷成功！"+sReturn[1]);
			sReturn = RunMethod("BusinessManage","UpdateTrade6030",sObjectNo+","+sCommercialNo+","+sAccumulationNo);
			if(typeof(sReturn)!="undefined" && sReturn.length!=0)
			{
				alert(sReturn);
			}
			reloadSelf();
		}
		return;
	}

	
	/*~[Describe=根据保证金金额计算保证金比例;InputParam=无;OutPutParam=无;]~*/
	function getBailRatio1()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailSum = getItemValue(0,getRow(),"BailSum");
	        if(parseFloat(dBailSum) >= 0)
	        {	 
	        	dBailSum = roundOff(dBailSum,2);	        	
	        	dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;	        	
	        	sBusinessType = "<%=sBusinessType%>" ;
	            if(sBusinessType == "2050010" || sBusinessType == "2050020" || sBusinessType == "2050040" || sBusinessType == "1110070" 
	        		|| sBusinessType == "2010" || sBusinessType == "2020" || sBusinessType.indexOf("2080") == 0 
	        		|| sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0 
	        		|| sBusinessType.indexOf("3030") == 0 || sBusinessType.indexOf("2090") == 0)
	        	{
	        		dBailRatio = roundOff(dBailSum,2);
	        		setItemValue(0,getRow(),"BailRatio",dBailRatio);
	        	}
	        	else
	        	{
	        		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//获取申请币种
		    		sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//获取保证金币种
		    		dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;
		    		if(sBusinessCurrency != sBailCurrency)
		    		{
		    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
		    			dBailRatio = parseFloat(dBailSum)/(parseFloat(dBusinessSum)*dERateRatio)*100;
		    		}
		    		 dBailRatio = roundOff(dBailRatio,2);
		    		 setItemValue(0,getRow(),"BailRatio",dBailRatio);
				}
				if (dBailRatio=="100") {
					setItemValue(0,getRow(),"VouchType",'005');
					setItemValue(0,getRow(),"VouchTypeName",'信用');
				}
				//银行承兑汇票、融资性保函、非融资性保函
			    if(sBusinessType == "2010" || sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0)
			    {	
			    	setItemValue(0,getRow(),"ExposureSum",roundOff((dBusinessSum-dBailSum/dERateRatio),2));
			    }
	        }
	    }
	}
	
	/*~[Describe=根据溢短装比例和信用证金额计算实际用信金额;InputParam=无;OutPutParam=无;]~*/
		function getPracticeSum()
		  {
		    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");//获取申请时的信用证金额
		    dFlowover = getItemValue(0,getRow(),"Flowover");//获取申请时的溢装比例
		    var PracticeSum1=dBusinessSum *(1+dFlowover/100);
		    setItemValue(0,getRow(),"PracticeSum",roundOff(PracticeSum1,2));
		   
		   }
	
	
	/*~[Describe=初始化数据;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		sOccurType = "<%=sOccurType%>";
		sObjectType = "<%=sObjectType%>";
		sBusinessType = "<%=sBusinessType%>";

		if(sBusinessType == "1100010" && sObjectType == "CreditApply" )
		{
			setItemValue(0,getRow(),"BusinessSum",0);
		}
		if(sOccurType == "015" && sObjectType == "CreditApply") //展期业务
		{
			setItemValue(0,getRow(),"TotalSum","<%=DataConvert.toMoney(dOldBusinessSum)%>");
			setItemValue(0,getRow(),"BusinessSum","<%=DataConvert.toMoney(dOldBalance)%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sOldBusinessCurrency%>");
			setItemValue(0,getRow(),"TermDate1","<%=sOldMaturity%>");
			setItemValue(0,getRow(),"OldBusinessRate","<%=dOldBusinessRate%>");
			setItemValue(0,getRow(),"ExtendTimes","<%=iExtendTimes%>");
		}
			//setItemValue(0,getRow(),"BusinessCurrency","01");
		if(sOccurType == "020") //借新还旧
		{
			setItemValue(0,getRow(),"LNGOTimes","<%=iLNGOTimes%>");
		}
		if(sOccurType == "060" ||sOccurType == "065") //还旧借新||新增续作
		{
			setItemValue(0,getRow(),"GOLNTimes","<%=iGOLNTimes%>");
		}
		if(sOccurType == "030") //债务重组
		{
			setItemValue(0,getRow(),"DRTimes","<%=iDRTimes%>");
		}
		if("<%=sApplyType%>"== "DependentApply" && "<%=sCustomerType%>".substr(0,2)=="03"){//个人额度项下业务
			setItemValue(0,getRow(),"CycleFlag",2);
		}
		
		//add by zrli 增加初始化贷后管理员
		if(sObjectType == "ReinforceContract"){
			sManageUserID = getItemValue(0,getRow(),"ManageUserID");
			if(typeof(sManageUserID) == "undefined" || sManageUserID == "")
			{
				setItemValue(0,getRow(),"ManageUserID","<%=CurUser.UserID%>");
				setItemValue(0,getRow(),"ManageUserName","<%=CurUser.UserName%>");
			}
			sOperateUserID = getItemValue(0,getRow(),"OperateUserID");
			if(typeof(sOperateUserID) == "undefined" || sOperateUserID == "")
			{
				setItemValue(0,getRow(),"OperateUserID","<%=CurUser.UserID%>");
				setItemValue(0,getRow(),"OperateUserName","<%=CurUser.UserName%>");
			}
		}
		
		//add by zwhu 补登初始化放款机构
		if(sBusinessType == "2010" || sBusinessType == "2070" || sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0
			|| sBusinessType.indexOf("2050") == 0 || sBusinessType.indexOf("1020") == 0 || sBusinessType.indexOf("1080") == 0 
			|| sBusinessType == "3010" || sBusinessType == "3040" || sBusinessType == "3060"){
			setItemValue(0,getRow(),"PutOutOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"PutOutOrgName","<%=CurOrg.OrgName%>");
		}
	}
	//检测数据类型
	function CreditColumnCheck(sColumnName,sCheckType)
	{
		sCheckWord = getItemValue(0,getRow(),sColumnName);
		if(typeof(sCheckWord) != "undefined" && sCheckWord != "")	
		{
			if(!CheckTypeScript(sCheckWord,sCheckType))	
			{
				alert("数据类型不正确，请重新输入！");
				setItemValue(0,getRow(),sColumnName,"");
				return false;
			}
			return true;
		}
	}
	//检测是否是浮点数
	function isDigit(s)
	{
		var patrn=/^(-?\d+)(\.\d+)?$/;
		if (!patrn.exec(s)) 
		{
			alert(s+"数据格式错误！");
			return false;
		}
		return true;
	}
	//查找该客户的担保协议
	function VouchAgreement()
	{
		sParaString = "";//
		sReturn = selectObjectValue("SelectVouchAgreement",sParaString,"",0,0,"");
		if( sReturn=="_CLEAR_" ){
			setItemValue(0,0,"VouchAggreement","");
			setItemValue(0,0,"VouchCorpName","");
			return;
		}else if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined"){
		 	return;
		}else{
			sReturn= sReturn.split('@');
			sSerialNo = sReturn[0];
			sCustomerName = sReturn[1];
			sPutOutDate = sReturn[2];
			sMaturity = sReturn[3];
			if("<%=StringFunction.getToday()%>" < sPutOutDate || sMaturity < "<%=StringFunction.getToday()%>")
			{
				alert("申请日期在协议有效期外，不能引入该笔协议！");
				return;
			}
			setItemValue(0,0,"VouchAggreement",sSerialNo);
			setItemValue(0,0,"VouchCorpName",sCustomerName);
		}
	}
	
	//查找工程机械经销商协议
	function DealerAgreement()
	{
		sParaString = "";		
	    sReturn = setObjectValue("SelectDealerAgreement",sParaString,"",0,0,"");
	    if(sReturn == sReturn=="_CLEAR_" ){
	    	setItemValue(0,0,"ConstructContractNo","");
			setItemValue(0,0,"TradeName","");
			setItemValue(0,0,"CropName","");
			return;
	    }
	    else if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined"){
	    	return;
	    }else{
			sReturn= sReturn.split('@');
			sSerialNo = sReturn[0];
			sTradeName = sReturn[1];
			sCustomerName = sReturn[2];
			sPutOutDate = sReturn[3];
			sMaturity = sReturn[4];
			if("<%=StringFunction.getToday()%>" < sPutOutDate || sMaturity < "<%=StringFunction.getToday()%>")
			{
				//add by xhyong 增加初始化贷后管理员数据补登不需要控制
				if(sObjectType != "ReinforceContract"){
					alert("申请日期在协议有效期外，不能引入该笔协议！");
					return;
				}
			}
			setItemValue(0,0,"ConstructContractNo",sSerialNo);
			setItemValue(0,0,"TradeName",sTradeName);
			setItemValue(0,0,"CropName",sCustomerName);
		}
	}
	//查找开发商楼宇按揭协议
	function selectProjectCoop()
	{
		sParaString = "";		
	    sReturn = setObjectValue("selectProjectCoop",sParaString,"",0,0,"");
	    if(sReturn=="_CLEAR_" ){
	    	setItemValue(0,0,"BuildAgreement","");
			setItemValue(0,0,"ThirdParty3","");
	    }else if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined"){
	    	return;
	    }else{
	    	sReturn= sReturn.split('@');
			sSerialNo = sReturn[0];
			sCustomerName = sReturn[1];
			sPutOutDate = sReturn[2];
			sMaturity = sReturn[3];
			if("<%=StringFunction.getToday()%>" < sPutOutDate || sMaturity < "<%=StringFunction.getToday()%>")
			{
				alert("申请日期在协议有效期外，不能引入该笔协议！");
				return;
			}
			setItemValue(0,0,"BuildAgreement",sSerialNo);
			setItemValue(0,0,"ThirdParty3",sCustomerName);
		}
	}
	
	//取得基准年利率
	function selectBaseRateType(){
		sCurDate = "<%=StringFunction.getToday()%>"
		sParaString = "CurDate"+","+sCurDate;
	    sReturn = setObjectValue("selectBaseRateType",sParaString,"@BaseRateType@0@BaseRate@1",0,0,"");
		getBusinessRate("M");
	}
	//自动获取利率类型 2009-12-24 
	function getBaseRateType(){
		 var sOccurType = "<%=sOccurType%>";
		 dTermDay = getItemValue(0,getRow(),"TermDay");
		 dTermMonth = getItemValue(0,getRow(),"TermMonth");
		 sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//币种
		 sBaseRateID = "";
		 if(typeof(sBusinessCurrency)=="undefined" || sBusinessCurrency.length==0)
		 {
		 	alert("请先选择币种!");
		 	return ;
		 }
		 if(sBusinessCurrency=="01")//人民币
		 {
			 if(sOccurType == "015"){
			 	if(typeof(dTermDay) == "undefined" && dTermDay == "" ){
			 		dTermDay = 0;
			 	}
			 	dTermDay = dTermDay + <%=dOldTermDay%>;
			 	if(dTermDay/30 >1){
			 		dTermMonth = dTermMonth + 2;
			 	}
			 	else if(dTermDay>0){
			 		dTermMonth = dTermMonth + 1;
			 	}
			 	dTermMonth = dTermMonth + <%=dOldTermMonth%>;
			 }
			 else if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			 {
			 	dTermMonth = dTermMonth+1; 
			 }
			 if(dTermMonth <= 6){
			 	sBaseRateID = "10010";
			 }else if(dTermMonth > 6 && dTermMonth <= 12){
			 	sBaseRateID = "10020";
			 }else if(dTermMonth > 12 && dTermMonth <= 36){
			 	sBaseRateID = "10040";
			 }else if(dTermMonth > 36 && dTermMonth <= 60){
			 	sBaseRateID = "10050";
			 }else{
			 	sBaseRateID = "10030";
			 }
		}else{//外币
			 if(dTermDay < 7 && dTermMonth==0){
			 	sBaseRateID = "20010";//隔夜
			 }else if(dTermDay < 14 && dTermMonth==0){
			 	sBaseRateID = "20020";//一周
			 }else if(dTermMonth==0 ){
			 	sBaseRateID = "20030";//二周
			 }else if(dTermMonth <3){
			 	sBaseRateID = "20040";//一个月
			 }else if(dTermMonth <6){
			 	sBaseRateID = "20050";//三个月
			 }else if(dTermMonth <12){
			 	sBaseRateID = "20060";//六个月
			 }else{
			 	sBaseRateID = "20070";//十二个月
			 }
		}
		 setItemValue(0,0,"BaseRateType",sBaseRateID);
		 
		// sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
		sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    } 	    
		getBusinessRate("M");
	}
	
	//自动获取公积金利率类型 2011/08/17 
	function getAFBaseRateType(){
		 dTermDay = getItemValue(0,getRow(),"TermDay");
		 dTermMonth = getItemValue(0,getRow(),"TermMonth");
		 sBaseRateID = "";
		 if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
		 {
		 	dTermMonth = dTermMonth+1; 
		 }
		 if(dTermMonth <= 60){
		 	sBaseRateID = "10010";
		 }else{
		 	sBaseRateID = "10020";
		 }
		 setItemValue(0,0,"BaseRateType",sBaseRateID);
		 
		 sReturn = RunMethod("BusinessManage","getAFBaseRate",sBaseRateID);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    }  
		getBusinessRate("M");
	}
	//验证“经营性物业抵押贷款业务”中的出租率
	function verifyRentRatio(){
		dOperateYears = getItemValue(0,getRow(),"OperateYears");
		dRentRatio = getItemValue(0,getRow(),"RentRatio");
		if(dOperateYears >= 2 && dRentRatio<80){
			alert("出租率需大于等于80%");
			setItemValue(0,0,"RentRatio","");
		}else if(dOperateYears < 2 && dRentRatio<70){
			alert("出租率需大于等于70%");
			setItemValue(0,0,"RentRatio","");	
		}
	}
	//验证“个人一手、二手汽车贷款业务”中的贷款成数率
	function getBusinessProp(){
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//获取申请币种
		dThirdPartyID2 = getItemValue(0,getRow(),"ThirdPartyID2");
	    dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+",01,''");
	    dBusinessProp = (dBusinessSum*dERateRatio/dThirdPartyID2)*100
		dBusinessProp = roundOff(dBusinessProp,2);
		setItemValue(0,getRow(),"BusinessProp",dBusinessProp);
	}
	
	//是否有担保公司担保，担保协议清空
	function setVouchAggreement(){
		sVouchCorpFlag = getItemValue(0,getRow(),"VouchCorpFlag");
		if(sVouchCorpFlag == "2"){
			setItemValue(0,getRow(),"VouchAggreement","");
			setItemValue(0,getRow(),"VouchCorpName","");
		}
	}
	
	/*~~~~~~~~~~~~~~~~~~选择涉农贷款分类~~~~~~~~~~~~~~~~~~~*/
	function selectInvolveAgriculture(){
		sCustomerType = "<%=sCustomerType%>";
		if(sCustomerType.substring(0,3) == "03"){
			sParaString = "CodeNo"+","+"AgriLoanClassify1"+","+"ItemAttribute"+","+"1";
			setObjectValue("SelectInvolveAgriculture",sParaString,"@AgriLoanClassify@0@AgriLoanClassifyName@1",0,0,"");
		}else{
			sParaString = "CodeNo"+","+"AgriLoanClassify1"+","+"ItemAttribute"+","+"2";
			setObjectValue("SelectInvolveAgriculture",sParaString,"@AgriLoanClassify@0@AgriLoanClassifyName@1",0,0,"");
		}
	}
	//合同阶段，重新获取基准利率 added by zrli 2010-10-20
	function getNewBaseRate(){
		sBaseRateID = getItemValue(0,getRow(),"BaseRateType");
		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//币种
		if("2110020" == "<%=sBusinessType%>"){//如果是纯公积金贷款
			sReturn = RunMethod("BusinessManage","getAFBaseRate",sBaseRateID);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    }
		}else{
			//sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
			sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				setItemValue(0,0,"BaseRate",sReturn);
			} 	
		}    
		getBusinessRate("M");
		getTARate();
		getOverdueRate();
	}
	
	function setRequiredAndUpdate(BailRatio,VouchFlagName)
	{
		getBailSum();
		sBailRatio = getItemValue(0,getRow(),BailRatio);
		if(sBailRatio == 100)
		{
	 	  	setItemRequired(0,0,VouchFlagName,false);	 
		    
		}else
		{
			setItemRequired(0,0,VouchFlagName,true);	 
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
	initRow();	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
