<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  hlzhang 2011-10-28
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
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "";
	//定义变量：查询列名、显示模版名称、申请类型、发生类型、暂存标志、项下业务关联的额度申请流水
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sBAAgreement = "",sRelativeSerialNo = "";
	//定义变量：客户类型,客户信息表名,行业投向
	String sCustomerType = "",sApproveDate="";
	//定义变量：展期次数、借新还旧次数、还旧借新次数、债务重组次数
	int dOldTermMonth=0,dOldTermDay=0;
	//定义变量：查询结果集
	ASResultSet rs = null;
	
	//获得页面参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
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
	sSql = "select CustomerID,BAAgreement,ApplyType,RelativeSerialNo,CustomerID,BusinessType,OccurType,TempSaveFlag,ApproveDate from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
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
	
	//根据产品类型从产品信息表BUSINESS_TYPE中获得显示模版名称
	//发生类型为展期，需要调用展期信息模板
	if(sOccurType.equals("015"))
	{
		sDisplayTemplet = "ContractInfo0000"; //合同对象					
	}else
	{
		sFieldName = "ContractDetailNo"; //合同对象
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

	if(sBusinessType.equals("1110010")|| sBusinessType.equals("1110020") || sBusinessType.equals("1110030") || sBusinessType.equals("1110040")||sBusinessType.equals("1110025") )
	{
		doTemp.appendHTMLStyle("ThirdPartyZIP3"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"公积金贷款利率必须大于等于0,小于等于1000！\" ");
		doTemp.appendHTMLStyle("ThirdPartyZIP2"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"按揭贷款成数必须大于等于0,小于等于100！\" ");
		doTemp.appendHTMLStyle("ThirdPartyAdd1"," myvalid=\"parseFloat(myobj.value,10)>=0  \" mymsg=\"首付金额必须大于等于0 \" ");		
	}
	
	if( sBusinessType.equals("1110027"))
	{
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
	
	doTemp.appendHTMLStyle("VouchCorpFlag","onBlur=\"javascript:parent.setVouchAggreement()\" ");
	
	doTemp.setReadOnly("PdgSum",true);

	if(sOccurType.equals("015"))
		doTemp.setCheckFormat("TotalSum,BusinessSum","2");
	
	//设置利率格式,后面小数点6位
	doTemp.setCheckFormat("BusinessRate,OldBusinessRate,OverdueRate,TARate","16");

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
	
	if(sObjectType.equals("BusinessContract"))
	{
		doTemp.setUnit("VouchTypeName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectVouchType()>");
		doTemp.setUpdateable("VouchTypeName",false);
		doTemp.setReadOnly("",false);
		doTemp.setReadOnly("SerialNo,CustomerID,CustomerName,BusinessTypeName,OccurDate,PutOutOrgName",true);
		doTemp.setRequired("",false);
	}
	
%>
<%@include file="/CreditManage/CreditApply/CheckBusinessDataValidity.jsp"%>	
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
	
	dwTemp.setEvent("AfterUpdate","!BusinessManage.DeleteBusinessContractBak(#SerialNo,BusinessContract)");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
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
				{"true","","Button","关闭","关闭当前页面","closeSelf()",sResourcesPath}
		};
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
		if(confirm("您确认将对合同详情信息做修改吗？确定请点击“确定”按钮！")){
		
			if(vI_all("myiframe0"))
			{
				beforeUpdate();	
				
				//业务详情时将当前合同记录插入到BC_B备份表中
				sBCBSerialNo = initSerialNo();
				sObjectNo = getItemValue(0,getRow(),"SerialNo");
				sReturn = RunMethod("BusinessManage","AddBusinessContractBak",sBCBSerialNo+","+sObjectNo+","+"<%=CurOrg.OrgID%>"+","+"<%=CurUser.UserID%>"+",BusinessContract");
				if(sReturn == 1){
					as_save("myiframe0");
				}else{
					alert("保存历史数据失败！");
					return;
				}	
				
			}
		}
	}
	
	/*~[Describe=关闭;InputParam=无;OutPutParam=无;]~*/
	function closeSelf()
	{
		self.close();  //关闭当前页面

	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{	

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
		//手工录入
	}
	
	/*~[Describe=计算贴现利息和实付贴现金额;InputParam=无;OutPutParam=无;]~*/
	function getDiscountInterest()
	{
		//手工录入
	}
	
	/*~[Describe=计算卖方应付贴现利息;InputParam=无;OutPutParam=无;]~*/
	function getBargainorInterest()
	{
		//手工录入
	}
	
	/*~[Describe=计算逾期利率;InputParam=无;OutPutParam=无;]~*/
	function getOverdueRate()
	{
		//手工录入
	}
	
	/*~[Describe=挤占/挪用利率InputParam=无;OutPutParam=无;]~*/
	function getTARate()
	{
		//手工录入
	}
	
	/*~[Describe=银团贷款中“我行贷款份额占比”计算;InputParam=无;OutPutParam=无;]~*/	
	function setBusinessProp()
	{
	    //手工录入
    }
	
	/*~[Describe=根据手续费率计算手续费;InputParam=无;OutPutParam=无;]~*/
	function getpdgsum()
	{
	    //手工录入
	}
	
	/*~[Describe=根据手续费计算手续费率;InputParam=无;OutPutParam=无;]~*/
	function getPdgRatio()
	{
	    //手工录入
	}
	
	/*~[Describe=检查"零"天数是否合法;InputParam=无;OutPutParam=无;]~*/
	function getTermDay()
	{
	    dTermDay = getItemValue(0,getRow(),"TermDay");
	    sBusinessType = "<%=sBusinessType%>";
	    if(parseInt(dTermDay) > 30 )
	    {
	    	if(!(sBusinessType=="2050030") && !(sBusinessType=="2020"))
	        alert("零(天)必须小于等于30！");
	    }
	}
	
	/*~[Describe=根据首付金额计算首付比例;InputParam=无;OutPutParam=无;]~*/
	function getThirdPartyRatio()
	{
	    //手工录入
	}
	
	/*~[Describe=根据保证金比例计算保证金金额;InputParam=无;OutPutParam=无;]~*/
	function getBailSum()
	{
	    //手工录入  
	}
	
	/*~[Describe=根据保证金金额计算保证金比例;InputParam=无;OutPutParam=无;]~*/
	function getBailRatio()
	{
	    //手工录入
	}
	
	/*--------------------- add by zwhu -----------------*/
	
	/*~[Describe=根据手续费率计算手续费;InputParam=无;OutPutParam=无;]~*/
	function getpdgsum1()
	{
	    //手工录入
	}
	
	/*~[Describe=根据手续费计算手续费率;InputParam=无;OutPutParam=无;]~*/
	function getPdgRatio1()
	{
	    //手工录入
	}
	
	/*~[Describe=根据保证金比例计算保证金金额;InputParam=无;OutPutParam=无;]~*/
	function getBailSum1()
	{	
	    //手工录入	    
	}	
	
	/*~[Describe=根据保证金金额计算保证金比例;InputParam=无;OutPutParam=无;]~*/
	function getBailRatio1()
	{
	    //手工录入
	}
	
	
	/*~[Describe=初始化数据;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		//手工录入
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
		 //手工录入
	}
	
	//自动获取公积金利率类型 2011/08/17 
	function getAFBaseRateType(){
		//手工录入
	}
	//验证“经营性物业抵押贷款业务”中的出租率
	function verifyRentRatio(){
		//手工录入
	}
	//验证“个人一手、二手汽车贷款业务”中的贷款成数率
	function getBusinessProp(){
		//手工录入
	}
	
	//是否有担保公司担保，担保协议清空
	function setVouchAggreement(){
		//手工录入
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
		//手工录入
	}
	
	function setRequiredAndUpdate(BailRatio,VouchFlagName)
	{
		//手工录入
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT_BAK";//表名
		var sColumnName = "BCSerialNo";//字段名
		var sPrefix = "BCB";//前缀
       
		//使用GetSerialNo.jsp来抢占一个流水号
		var sBCBSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		//将流水号返回
		return sBCBSerialNo;
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
