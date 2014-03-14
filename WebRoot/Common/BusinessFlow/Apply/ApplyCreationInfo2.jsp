<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   byhu  2004.12.7
			Tester:
			Content: 创建授信额度项下/单笔授信业务申请
			Input Param:
		ObjectType：对象类型
		ApplyType：申请类型
		PhaseType：阶段类型
		FlowNo：流程号
		PhaseNo：阶段号
		OccurType：发生类型	
		OccurDate：发生日期		
			Output param:
			History Log: zywei 2005/07/28
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "授信方案新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号、发生方式、发生日期
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sOccurType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurType"));
	String sOccurDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDate"));

	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sOccurType == null) sOccurType = "";	
	if(sOccurDate == null) sOccurDate = "";	
//System.out.println("sFlowNo = " + sFlowNo);
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		//通过显示模版产生ASDataObject对象doTemp
		String sTempletNo = "CreditApplyCreationInfo";
		String sTempletFilter = "1=1";	
		//获取新增额度项下申请参数显示模板
		if(sApplyType.equals("DependentApply")) 
			sTempletFilter = " ColAttribute like '%Dependent%' ";
		//获取新增单笔授信业务申请参数显示模板
		if(sApplyType.equals("IndependentApply")) 
			sTempletFilter = " ColAttribute like '%Independent%' ";
		ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		//设置必输背景色
		doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
		//发生类型为展期，需设置展期相关属性
		if(sOccurType.equals("015"))
		{
			doTemp.setHeader("RelativeAgreement","关联展期业务");
			doTemp.setVisible("RelativeAgreement",true);				
			doTemp.setRequired("RelativeAgreement",true);
			doTemp.setReadOnly("RelativeAgreement",true);
			doTemp.setVisible("BusinessTypeName",false);
			doTemp.setRequired("BusinessTypeName",false);
			doTemp.setUnit("RelativeAgreement","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectExtendContract();\"> ");
		}
		//发生类型为借新还旧，需设置借新还旧相关属性
		if(sOccurType.equals("020"))
		{
			doTemp.setHeader("RelativeAgreement","关联借新还旧业务");
			doTemp.setVisible("RelativeAgreement",true);
			doTemp.setRequired("RelativeAgreement",true);
			doTemp.setReadOnly("RelativeAgreement",true);		
			doTemp.setUnit("RelativeAgreement","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectRelativeContract();\"> ");
		}
		//发生类型为资产重组，需设置资产重组相关属性
		if(sOccurType.equals("030"))
		{
			doTemp.setHeader("RelativeAgreement","关联重组方案");
			doTemp.setVisible("RelativeAgreement",true);
			doTemp.setRequired("RelativeAgreement",true);
			doTemp.setReadOnly("RelativeAgreement",true);		
			doTemp.setUnit("RelativeAgreement"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectNPARefrom()>");
		}
		//当客户类型发生改变时，系统自动清空已录入的信息
		doTemp.appendHTMLStyle("CustomerType"," onChange=\"javascript:parent.clearData()\" ");
		
		//--added by wwhe 2010-04-11 for:授信额度暂时不校验
		doTemp.setRequired("CreditAggreement",false);
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		
		/*	modified by wwhe 2009-06-09 for:将后续事件放在javascript用RunMethod方法执行,需要判断FlowNo
		//设置保存时操作关联数据表的动作
		if(sOccurType.equals("015") || sOccurType.equals("020") || sOccurType.equals("030"))
			dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative(#SerialNo,#RelativeObjectType,#RelativeAgreement,APPLY_RELATIVE) + !WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")");
		else
			dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")");
		*/
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		//out.println(doTemp.SourceSql);
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/
%>
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
		{"true","","Button","上一步","新增授信申请的上一步","beforeStep()",sResourcesPath},
		{"true","","Button","取消","取消新增授信申请","doCancel()",sResourcesPath}	
		};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
	<script language=javascript>

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		//--added by wwhe 2009.06.10 for:校验额度项下业务是否在额度分配范围内
		var sCustomerType = getItemValue(0,0,"CustomerType");
		var sCreditAggreement = getItemValue(0,0,"CreditAggreement");
		var sBusinessType = getItemValue(0,0,"BusinessType");
		
		if(typeof(sCreditAggreement) != "undefined" && sCreditAggreement != "" && sCustomerType == "01"){
			var sReturnValue = RunMethod("BusinessManage","ChechCreditLineBusinessType",sCreditAggreement+","+sBusinessType);
			if(sReturnValue == "false"){
				alert("授信额度项下未分配该业务品种，请重新选择业务品种");
				return false;
			}
		}else{//added by bllou 20120426 没有关联额度进行提示
			if("<%=sApplyType%>" == "DependentApply"&&!confirm("没有关联授信额度，确认继续吗？")){
				return false;
			}
		}
		//--finished adding wwhe 2009-06-10
		//add by bllou 2011/08/24微贷个人担保贷款 微贷个人抵押贷款 微贷三户联保贷款 微贷批量业务四个业务品种经办人（客户经理）置空以方便录入人手工选择
		if(sBusinessType.substr(0,4)=="1125"){		
			setItemValue(0,0,"OperateUserID"," ");
		}
		if("<%=sApplyType%>" == "DependentApply")
			setItemValue(0,0,"ContractFlag","1");//占用额度
		else
			setItemValue(0,0,"ContractFlag","2");//不占用额度
		initSerialNo();
		as_save("myiframe0","AfterInsert()");		
	}
	
	/*~[Describe=上一步;InputParam=无;OutPutParam=无;]~*/
	function beforeStep()
	{		
		OpenPage("/CreditManage/CreditApply/CreditApplyCreationInfo1.jsp?ObjectType=<%=sObjectType%>&ApplyType=<%=sApplyType%>&PhaseType=<%=sPhaseType%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>&OccurType=<%=sOccurType%>&OccurDate=<%=sOccurDate%>","_self","");
    }
    
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>

	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		sIsJGT = getItemValue(0,0,"isJGT");		
		sCreditAggreement = getItemValue(0,0,"CreditAggreement");		
		
		if(sIsJGT == "1" && sCreditAggreement.length == 0){
			alert("晋钢通业务，请选择额度协议号！");
			return 
		}
		//added by bllou 20120413 有受理渠道必须选受理流水号
		var sisAccept = getItemValue(0,0,"isAccept");		
		var sAcceptSerialNo = getItemValue(0,0,"AcceptSerialNo");		
		if(sisAccept == "1" && sAcceptSerialNo.length == 0){
			alert("基于受理渠道，请选择受理流水号！");
			return 
		}
		saveRecord("doReturn()");
	}
	
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");		
		top.returnValue = sObjectNo;
		top.close();
	}
	
	/*~[Describe=清空信息;InputParam=无;OutPutParam=申请流水号;]~*/
	function clearData(){
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		setItemValue(0,0,"BusinessType","");
		setItemValue(0,0,"BusinessTypeName","");
		setItemValue(0,0,"CreditAggreement","");
		setItemValue(0,0,"RelativeAgreement","");
		setItemValue(0,0,"RelativeObjectType","");
	}
		
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{			
		sCustomerType = getItemValue(0,0,"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert(getBusinessMessage('225'));//请先选择客户类型！
			return;
		}
		//具有业务申办权的客户信息
		sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType == "01")//公司客户
			setObjectValue("SelectApplyCustomer3",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		if(sCustomerType == "02")//关联集团
			setObjectValue("SelectApplyCustomer2",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		if(sCustomerType == "03")//个人客户
			setObjectValue("SelectApplyCustomer1",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectBusinessType(sType)
	{		
		if(sType == "ALL")
		{
			sCustomerType = getItemValue(0,0,"CustomerType");
			if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
			{
				alert(getBusinessMessage('225'));//请先选择客户类型！
				return;
			}
			
			sCustomerID = getItemValue(0,0,"CustomerID");
			if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
			{
				alert(getBusinessMessage('226'));//请先选择授信客户！
				return;
			}
			if(sCustomerType == "03")//个人客户
				setObjectValue("SelectIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
			else //公司客户
			{
				/*	modified by wwhe 2009.06.15 for:屏蔽，暂时没有区分中小企业客户与对工客户
				//求Status=1为中小企业客户
				sStatus = RunMethod("PublicMethod","GetColValue","Status,Customer_Info,String@CustomerID@"+sCustomerID);
				if( sStatus == "1")
				{ 
					setObjectValue("SelectEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
				}
				else
				{
					setObjectValue("SelectSMEBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
				}
				*/
				setObjectValue("SelectEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
			}
		}
	}
	
	/*~[Describe=弹出授信额度选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCreditLine()
	{		
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert(getBusinessMessage('225'));//请先选择客户！
			return;
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//请先选择客户！
			return;
		}
		//查找该客户的有效授信协议
		if(sCustomerType == "01")
		{
			sParaString = "CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract",sParaString,"@CreditAggreement@0@BusinessSubType@1",0,0,"");//--modified by wwhe 2009-06-08 for:获取授信额度分类字段信息
		}
		if(sCustomerType == "03")
		{
			sParaString = "PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract1",sParaString,"@CreditAggreement@0",0,0,"");
		}
	}
	
	/*~[Describe=弹出待展期的合同/借据选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectExtendContract()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//请先选择客户！
			return;
		}
		//按照合同展期
		//sParaString = "CustomerID"+","+sCustomerID+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
		//setObjectValue("SelectExtendContract",sParaString,"@RelativeAgreement@0@BusinessType@1",0,0,"");			
		//setItemValue(0,0,"RelativeObjectType","BusinessContract");
		//按照借据展期
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateOrgID"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectExtendDueBill",sParaString,"@RelativeAgreement@0@BusinessType@1",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","BusinessDueBill");
	}
	
	/*~[Describe=弹出待借新还旧的合同/借据选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectRelativeContract()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//请先选择客户！
			return;
		}
		//按照合同借新还旧
		/*
		sParaString = "CustomerID"+","+sCustomerID+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
		setObjectValue("SelectExtendContract",sParaString,"@RelativeAgreement@0",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","BusinessContract");
		*/
		//按照借据借新还旧
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateOrgID"+","+"<%=CurUser.OrgID%>";
		setObjectValue("SelectExtendDueBill",sParaString,"@RelativeAgreement@0",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","BusinessDueBill");				
	}
	
	/*~[Describe=弹出资产重组选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectNPARefrom()
	{				
		setObjectValue("SelectNPARefrom","","@RelativeAgreement@0",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","CapitalReform");		
	}
	//added by bllou 有受理渠道的业务申请，选择受理信息，以把受理信息和申请信息关联上
	/*~[Describe=弹出资产重组选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCreditAcceptInfo()
	{				
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(typeof(sBusinessType) == "undefined" || sBusinessType == "")
		{
			alert("请先选择业务品种");//请先选择客户！
			return;
		}
		setObjectValue("SelectCreditAcceptInfo","CustomerType,"+sCustomerType+",BusinessType,"+sBusinessType+",OrgID,<%=CurUser.OrgID%>,UserID,<%=CurUser.UserID%>","@AcceptSerialNo@0",0,0,"");	
	}		
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录	
			//客户类型
			setItemValue(0,0,"CustomerType","01");		
			//发生类型
			setItemValue(0,0,"OccurType","<%=sOccurType%>");
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
		var sPrefix = "";//前缀
								
		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[added by wwhe 2009-06-08 for:Describe=保存后续事件;InputParam=无;OutPutParam=无;]~*/
	function AfterInsert()
	{
		var sOccurType = "<%=sOccurType%>";
		var sObjectType = "<%=sObjectType%>";
		var sApplyType = "<%=sApplyType%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		var sUserID = "<%=CurUser.UserID%>";
		var sOrgID = "<%=CurOrg.OrgID%>";
		var sSerialNo = getItemValue(0,0,"SerialNo");
		var sRelativeObjectType = getItemValue(0,0,"RelativeObjectType");
		var sRelativeAgreement = getItemValue(0,0,"RelativeAgreement");
		var sCreditAggreement = getItemValue(0,0,"CreditAggreement");
		var sBusinessSubType = getItemValue(0,0,"BusinessSubType");
		var sCustomerType = getItemValue(0,0,"CustomerType");
		var sIsJGT = getItemValue(0,0,"isJGT");
		
		//sFlowNo = RunMethod("BusinessManage","SelectFlow","OrgID:"+sOrgID+"@ApplyType:"+sApplyType+"@CreditAggreement:"+sCreditAggreement+"@CustomerType:"+sCustomerType+"@BusinessSubType:"+sBusinessSubType+"@IsJGT:"+sIsJGT);
		//add by bllou 由上面的类改成下面的页面 不解释
		sFlowNo = PopPage("/Common/WorkFlow/SelectFlow.jsp?OrgID="+sOrgID+"&ApplyType="+sApplyType+"&CreditAggreement="+sCreditAggreement+"&CustomerType="+sCustomerType+"&BusinessSubType="+sBusinessSubType+"&IsJGT="+sIsJGT,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		//end by bllou 2012.02.07
		//added by bllou 20120411 如果申请业务经过了受理渠道，把当前业务流水号和受理流水号关联起来
		var isAccept = getItemValue(0,getRow(),"isAccept");
		var sAcceptSerialNo = getItemValue(0,getRow(),"AcceptSerialNo");
		if(isAccept==="1"){
			RunMethod("BusinessManage","InsertRelative",sSerialNo+",AcceptSource,"+sAcceptSerialNo+",APPLY_RELATIVE");
		}
		if(sOccurType == "015" || sOccurType == "020" || sOccurType == "030")
			RunMethod("BusinessManage","InsertRelative",sSerialNo+","+sRelativeObjectType+","+sRelativeAgreement+",APPLY_RELATIVE");
		RunMethod("WorkFlowEngine","InitializeFlow",sObjectType+","+sSerialNo+","+sApplyType+","+sFlowNo+","+sPhaseNo+","+sUserID+","+sOrgID);	

		doReturn();
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
	var bCheckBeforeUnload=false;	
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>