<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jytian  2004/12/12
		Tester:
		Content: 业务基本信息
		Input Param:
				 ObjectType：对象类型
				 ObjectNo：对象编号
		Output param:
		History Log: zywei 2005/08/03 重检页面
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
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "";
	//定义变量：查询列名、显示模版名称、申请类型、发生类型、暂存标志
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "";
	//定义变量：关联业务币种、关联业务到期日
	String sOldBusinessCurrency = "",sOldMaturity = "";
	//定义变量：关联业务金额、关联业务利率、关联业务余额
	double dOldBusinessSum = 0.0,dOldBusinessRate = 0.0,dOldBalance = 0.0;
	//定义变量：展期次数、借新还旧次数、还旧借新次数、债务重组次数
	int iExtendTimes = 0,iLNGOTimes = 0,iGOLNTimes = 0,iDRTimes = 0;
	//定义变量：查询结果集
	ASResultSet rs = null;
	
	//获得页面参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>

	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//根据对象类型和对象编号从流程对象表中查询到相应的申请类型
	sSql = " select ApplyType from FLOW_OBJECT where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
	sApplyType = Sqlca.getString(sSql);	
	if(sApplyType == null) sApplyType = "";
	
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
	sSql = "select CustomerID,BusinessType,OccurType,TempSaveFlag from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
		sOccurType = DataConvert.toString(rs.getString("OccurType"));
		sTempSaveFlag = DataConvert.toString(rs.getString("TempSaveFlag"));
		
		//将空值转化成空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sTempSaveFlag == null) sTempSaveFlag = "";
	}
	rs.getStatement().close(); 
		
	//如果业务品种为空,则显示短期流动资金贷款
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//在业务对象为申请时才执行如下业务逻辑
	if(sObjectType.equals("CreditApply"))
	{
		//根据发生类型（系统暂处理展期、借新还旧、还旧借新、债务重组四种类型）获取相应的关联业务信息
		if(sOccurType.equals("015") || sOccurType.equals("020") || sOccurType.equals("060")) //展期、借新还旧、还旧借新
		{
			//获取展期合同（/借据）的金额、余额、利率、币种、到期日、展期次数、借新还旧次数、还旧借新次数、债务重组次数等信息
			//sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //按照合同
			sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,RenewTimes as LNGOTimes,GOLNTimes,ReorgTimes as DRTimes "+ //按照借据
					//" from BUSINESS_CONTRACT "+ //按照合同
					" from BUSINESS_DUEBILL "+ //按照借据
					" where SerialNo = (select ObjectNo "+
					" from "+sRelativeTable+" "+
					//" where ObjectType = 'BusinessContract' "+ //按照合同
					" where ObjectType = 'BusinessDueBill' "+ //按照借据
					" and SerialNo = '"+sObjectNo+"') ";
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
		}else if(sOccurType.equals("030")) //债务重组
		{
			//获取资产重组方案编号
			sSql = 	" select ObjectNo from "+sRelativeTable+" "+
					" where ObjectType = 'CapitalReform' "+
					" and SerialNo = '"+sObjectNo+"' ";
			String sCapitalReformNo = Sqlca.getString(sSql);
			
			//获取重组合同的金额、债务重组合同余额、利率、币种、到期日、展期次数、借新还旧次数、还旧借新次数、债务重组次数等信息
			sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //按照合同
					" from BUSINESS_CONTRACT "+ //按照合同
					" where SerialNo = (select ObjectNo "+
					" from APPLY_RELATIVE "+
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
		}
		//这些关联业务需要再进行关联一次（展期/借新还旧/还旧借新/债务重组），因此需要在原来的次数上增加一次
		iExtendTimes = iExtendTimes + 1;
		iLNGOTimes = iLNGOTimes + 1;
		iGOLNTimes = iExtendTimes + 1;
		iDRTimes = iDRTimes + 1;
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
	
	//设置字段的可见属性	
	if(sOccurType.equals("020")) //借新还旧时显示借新还旧次数字段
		doTemp.setVisible("LNGOTimes",true);
	if(sOccurType.equals("060")) //还旧借新显示还旧借新次数字段
		doTemp.setVisible("GOLNTimes",true);
	if(sOccurType.equals("030")) //债务重组显示债务重组次数字段
		doTemp.setVisible("DRTimes",true);	
		
	//设置利率格式,后面小数点6位
	doTemp.setCheckFormat("BusinessRate","16");
	
	//根据申请对象不同，设置显示要素的不同属性
	if(sApplyType.equals("IndependentApply"))
		doTemp.setVisible("CreditAggreement",false);
%>
	<%@include file="CheckBusinessDataValidity.jsp"%>	
<%
	//生成DataWindow对象	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "0"; 
	
	//设置保存时操作流程对象表的动作
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateCLInfo("+sObjectType+",#SerialNo,#BusinessSum,#BusinessCurrency)");
				
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//获取校验数据信息
	double dCheckBusinessSum = 0.0,dCheckBaseRate = 0.0,dCheckRateFloat = 0.0,dCheckBusinessRate = 0.0;
	double dCheckPdgRatio = 0.0,dCheckPdgSum = 0.0,dCheckBailSum = 0.0,dCheckBailRatio = 0.0;
	String sCheckRateFloatType = "";
	int iCheckTermYear = 0,iCheckTermMonth = 0,iCheckTermDay = 0;
	//当对象类型为最终审批意见时，获取最终审批意见所对应的申请信息
	if(sObjectType.equals("ApproveApply"))
	{
		sSql = 	" select BA.BusinessSum,BA.BaseRate,BA.RateFloatType,BA.RateFloat, "+
				" BA.BusinessRate,BA.PdgRatio,BA.PdgSum,BA.BailSum,BA.BailRatio, "+
				" BA.TermYear,BA.TermMonth,BA.TermDay "+
				" from BUSINESS_APPLY BA"+
				" where exists (select BAP.RelativeSerialNo from BUSINESS_APPROVE BAP "+
				" where BAP.SerialNo = '"+sObjectNo+"' "+
				" and BAP.RelativeSerialNo = BA.SerialNo) ";
	}
	//当对象类型为合同时，获取合同所对应的批复信息
	if(sObjectType.equals("BusinessContract"))
	{
		sSql = 	" select BA.BusinessSum,BA.BaseRate,BA.RateFloatType,BA.RateFloat, "+
				" BA.BusinessRate,BA.PdgRatio,BA.PdgSum,BA.BailSum,BA.BailRatio, "+
				" BA.TermYear,BA.TermMonth,BA.TermDay "+
				" from BUSINESS_APPROVE BA"+
				" where exists (select BC.RelativeSerialNo from BUSINESS_CONTRACT BC "+
				" where BC.SerialNo = '"+sObjectNo+"' "+
				" and BC.RelativeSerialNo = BA.SerialNo) ";
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
		if (!ValidityCheck()) return;									
		if(vI_all("myiframe0"))
		{
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
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");			
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
		//业务品种
		sBusinessType = "<%=sBusinessType%>";
				
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
			
			//申请金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//保证金金额
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//手续费金额
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
			
			//校验申请金额与保证金金额之间的业务逻辑关系
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0)
			{
				if(parseFloat(dBailSum) > parseFloat(dBusinessSum))
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
						alert(getBusinessMessage('568'));//保证金金额(元)必须小于或等于申请敞口总额度(元)！
						return false;
					}else
					{
						alert(getBusinessMessage('562'));//保证金金额(元)必须小于或等于申请金额(元)！
						return false;
					}
				}
			}
			
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dPdgSum) >= 0)
			{
				if(parseFloat(dPdgSum) > parseFloat(dBusinessSum))
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
					&& sBusinessType != '2110010' && sBusinessType != '1110140' 
					&& sBusinessType != '1110150') //不为个人经营贷款、个人房屋贷款合作项目、
					//汽车消费贷款合作经销商、个贷其它合作商、个人住房公积金贷款、商业助学贷款、国家助学贷款
					{
						alert(getBusinessMessage('563'));//手续费金额(元)必须小于或等于申请金额(元)！
						return false;
					}
				}
			}				 		
		}
		
		if(sObjectType == "ApproveApply")//最终审批意见对象
		{
			//申请金额
			dCheckBusinessSum = <%=dCheckBusinessSum%>;
			//批准金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			if(parseFloat(dCheckBusinessSum) >= 0 && parseFloat(dBusinessSum) >= 0)
			{
				if(dBusinessSum > dCheckBusinessSum)
				{
					if(sOccurType == "015") //展期业务
					{
						alert(getBusinessMessage('512'));//批准展期金额(元)必须等于申请中的展期金额(元)！
						return false;
					}else
					{					
						if(sBusinessType == '1020030') //协议付息票据贴现
						{
							alert(getBusinessMessage('513'));//批准票据总金额(元)必须小于或等于申请中的票据总金额(元)！
							return false;
						}else if(sBusinessType == '2050030' || sBusinessType == '2020' || sBusinessType == '2050020') //进口信用证、国内信用证、备用信用证
						{
							alert(getBusinessMessage('514'));//批准信用证金额(元)必须小于或等于申请中的信用证金额(元)！
							return false;
						}else if(sBusinessType == '2050010') //提货担保
						{
							alert(getBusinessMessage('515'));//批准单据金额(元)必须小于或等于申请中的单据金额(元)！
							return false;
						}else if(sBusinessType == '1100010') //黄金租赁业务
						{
							alert(getBusinessMessage('516'));//批准租赁黄金克数必须小于或等于申请中的租赁黄金克数！
							return false;
						}else if(sBusinessType == '3030010' || sBusinessType == '3030030' || sBusinessType == '3030020') //个人房屋贷款合作项目、个贷其它合作商、汽车消费贷款合作经销商
						{
							alert(getBusinessMessage('517'));//批准敞口总额度(元)必须小于或等于申请中的申请敞口总额度(元)！
							return false;
						}else
						{
							alert(getBusinessMessage('518'));//批准金额(元)必须小于或等于申请中的金额(元)！
							return false;
						}						
					}
				}
			}
			
			//校验期限，统一折算成天数（总天数＝期限月*30＋期限天（系统暂没有使用期限年））
			//申请的期限月			
			dCheckTermMonth = "<%=iCheckTermMonth%>";
			//申请的期限天
			dCheckTermDay = "<%=iCheckTermDay%>";
			//申请的总天数
			dCheckTotalDay = parseInt(dCheckTermMonth)*30 + parseInt(dCheckTermDay);
			//批准的期限月
			dTermMonth = getItemValue(0,getRow(),"TermMonth");
			//批准的期限天
			dTermDay = getItemValue(0,getRow(),"TermDay");
			//批准的总天数
			dTotalDay = parseInt(dTermMonth)*30 + parseInt(dTermDay);
			if(parseFloat(dCheckTotalDay) >= 0 && parseFloat(dTotalDay) >= 0)
			{
				if(dTotalDay > dCheckTotalDay)
				{
					alert(getBusinessMessage('550'));//批准的期限必须小于或等于申请的期限！
					return false;
				}
			}
			
			//批准金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//保证金金额
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//手续费金额
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
			
			//校验批准金额与保证金金额之间的业务逻辑关系
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0)
			{
				if(parseFloat(dBailSum) > parseFloat(dBusinessSum))
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
						alert(getBusinessMessage('570'));//保证金金额(元)必须小于或等于批准金额(元)！
						return false;
					}
				}
			}
			
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dPdgSum) >= 0)
			{
				if(parseFloat(dPdgSum) > parseFloat(dBusinessSum))
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
					&& sBusinessType != '2110010' && sBusinessType != '1110140' 
					&& sBusinessType != '1110150') //不为个人经营贷款、个人房屋贷款合作项目、
					//汽车消费贷款合作经销商、个贷其它合作商、个人住房公积金贷款、商业助学贷款、国家助学贷款
					{
						alert(getBusinessMessage('571'));//手续费金额(元)必须小于或等于批准金额(元)！
						return false;
					}
				}
			}	
		}
		
		if(sObjectType == "CreditApply" || sObjectType == 'ApproveApply')
		{
			//检查提款方式和提款说明的关系
			sDrawingType = getItemValue(0,getRow(),"DrawingType");//提款方式（01：一次提款；02：分次提款）
			sContextInfo = getItemValue(0,getRow(),"ContextInfo");
			//业务品种为短期流动资金贷款、中期流动资金贷款、出口退税账户托管贷款、
			//商业承兑汇票保贴、基本建设项目贷款、技术改造项目贷款、其他类项目贷款
			//银团贷款时
			if(sBusinessType == '1010010' || sBusinessType == '1010020'
			 || sBusinessType == '1010040' || sBusinessType == '1020040'
			 || sBusinessType == '1030010' || sBusinessType == '1030020'
			 || sBusinessType == '1030030' || sBusinessType == '1060') 
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
			//业务品种为短期流动资金贷款、中期流动资金贷款、法人账户透支、出口退税账户托管贷款、
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
			 || sBusinessType == '1080040' || sBusinessType == '1080050'
			 || sBusinessType == '1080060' || sBusinessType == '1080070'
			 || sBusinessType == '1090010' || sBusinessType == '1090020'
			 || sBusinessType == '1090030' || sBusinessType == '1100010'
			 || sBusinessType == '2060010' || sBusinessType == '2060020'
			 || sBusinessType == '2060030' || sBusinessType == '2060040'
			 || sBusinessType == '2060050' || sBusinessType == '2060060'
			 || sBusinessType == '2070') 
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
			//批准金额
			dCheckBusinessSum = <%=dCheckBusinessSum%>;
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
				}
				
				//校验合同到期日与合同起始日之间的期限是否超过了批准的期限
				iCheckTermYear = "<%=iCheckTermYear%>";
				iCheckTermMonth = "<%=iCheckTermMonth%>";
				if(typeof(iCheckTermYear) != "undefined" && iCheckTermYear != ""
				&& typeof(iCheckTermMonth) != "undefined" && iCheckTermMonth != "")	
				{						
					a = new Date(sPutOutDate);
					b = new Date(sMaturity);			
					if(parseInt((b-a)/1000/24/60/60/30) > (parseInt(iCheckTermMonth)+parseInt(iCheckTermYear)*12))
					{
						alert(getBusinessMessage('591'));//合同期限必须小于或等于最终审批意见中的期限（仅控制整月）！
						return;
					}
				}			
			}
			
			//合同金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//保证金金额
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//手续费金额
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
			
			//校验合同金额与保证金金额之间的业务逻辑关系
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0)
			{
				if(parseFloat(dBailSum) > parseFloat(dBusinessSum))
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
						alert(getBusinessMessage('573'));//保证金金额(元)必须小于或等于合同金额(元)！
						return false;
					}
				}
			}
			
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dPdgSum) >= 0)
			{
				if(parseFloat(dPdgSum) > parseFloat(dBusinessSum))
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
					&& sBusinessType != '2110010' && sBusinessType != '1110140' 
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
			if(parseFloat(sBaseRate) >= 0 && parseFloat(sCheckBaseRate) >= 0)
			{
				if(parseFloat(sBaseRate) < parseFloat(sCheckBaseRate))
				{
					alert(getBusinessMessage('559'));//基准利率必须大于或等于最终审批意见中的基准利率！
					return false;
				}
			}
			
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
		return true;
	}
			
	/*~[Describe=选择主要担保方式;InputParam=无;OutPutParam=无;]~*/
	function selectVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
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
		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}
		else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];
			sIndustryTypeName = sIndustryTypeInfo[1];

			sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue="+sIndustryTypeValue,"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
			if(sIndustryTypeInfo == "NO")
			{
				setItemValue(0,getRow(),"Direction","");
				setItemValue(0,getRow(),"DirectionName","");
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];
				sIndustryTypeName = sIndustryTypeInfo[1];
				setItemValue(0,getRow(),"Direction",sIndustryTypeValue);
				setItemValue(0,getRow(),"DirectionName",sIndustryTypeName);				
			}
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
		//基准利率
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//利率浮动方式
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//利率浮动值
		dRateFloat = getItemValue(0,getRow(),"RateFloat");
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 && parseFloat(dRateFloat) >= 0)
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
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgRatio = getItemValue(0,getRow(),"PdgRatio");
	        dPdgRatio = roundOff(dPdgRatio,2);
	        if(parseFloat(dPdgRatio) >= 0)
	        {
	            dPdgSum = parseFloat(dBusinessSum)*parseFloat(dPdgRatio)/1000;
	            dPdgSum = roundOff(dPdgSum,2);
	            setItemValue(0,getRow(),"PdgSum",dPdgSum);
	        }
	    }
	}
	
	/*~[Describe=根据手续费计算手续费率;InputParam=无;OutPutParam=无;]~*/
	function getPdgRatio()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgSum = getItemValue(0,getRow(),"PdgSum");
	        dPdgSum = roundOff(dPdgSum,2);
	        if(parseFloat(dPdgSum) >= 0)
	        {	       
	            dPdgRatio = parseFloat(sPdgSum)/parseFloat(dBusinessSum)*1000;
	            dPdgRatio = roundOff(dPdgRatio,2);
	            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
	        }
	    }
	}
	
	/*~[Describe=根据保证金比例计算保证金金额;InputParam=无;OutPutParam=无;]~*/
	function getBailSum()
	{
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailRatio = getItemValue(0,getRow(),"BailRatio");
	        dBailRatio = roundOff(dBailRatio,2);
	        if(parseFloat(dBailRatio) >= 0)
	        {	        
	            dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
	            dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	        }
	    }
	}
	
	/*~[Describe=根据保证金金额计算保证金比例;InputParam=无;OutPutParam=无;]~*/
	function getBailRatio()
	{
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
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
	
	/*~[Describe=初始化数据;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		sOccurType = "<%=sOccurType%>";
		sObjectType = "<%=sObjectType%>";
		if(sOccurType == "015" && sObjectType == "CreditApply") //展期业务
		{
			setItemValue(0,getRow(),"TotalSum","<%=dOldBusinessSum%>");
			setItemValue(0,getRow(),"BusinessSum","<%=dOldBalance%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sOldBusinessCurrency%>");
			setItemValue(0,getRow(),"TermDate1","<%=sOldMaturity%>");
			setItemValue(0,getRow(),"BaseRate","<%=dOldBusinessRate%>");
			setItemValue(0,getRow(),"ExtendTimes","<%=iExtendTimes%>");
		}
		if(sOccurType == "020") //借新还旧
		{
			setItemValue(0,getRow(),"LNGOTimes","<%=iLNGOTimes%>");
		}
		if(sOccurType == "060") //还旧借新
		{
			setItemValue(0,getRow(),"GOLNTimes","<%=iGOLNTimes%>");
		}
		if(sOccurType == "030") //债务重组
		{
			setItemValue(0,getRow(),"DRTimes","<%=iDRTimes%>");
		}
		
	}
			
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();	
</script>	
<%/*~END~*/%>


<%@ include file="IncludeEnd.jsp"%>