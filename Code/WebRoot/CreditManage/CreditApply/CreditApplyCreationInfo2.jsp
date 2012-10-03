<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   lpzhang 2009-9-3
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
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信方案新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号、发生方式、发生日期,重组方案编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sOccurType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurType"));
	String sOccurDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDate"));
	String sNPAReformNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NPAReformNo"));

	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sOccurType == null) sOccurType = "";	
	if(sOccurDate == null) sOccurDate = "";	
	if(sNPAReformNo == null) sNPAReformNo = "";	
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//获取相关客户信息
	
	
	
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
		doTemp.setVisible("BusinessTypeName,CommunityAgreement",false);
		doTemp.setRequired("BusinessTypeName",false);
		doTemp.setUnit("RelativeAgreement","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectExtendContract();\"> ");
	}
	//发生类型为借新还旧，需设置借新还旧相关属性
/*	if(sOccurType.equals("020"))
	{
		doTemp.setHeader("RelativeAgreement","关联借新还旧业务");
		doTemp.setVisible("RelativeAgreement",true);
		doTemp.setRequired("RelativeAgreement",true);
		doTemp.setReadOnly("RelativeAgreement",true);		
		doTemp.setUnit("RelativeAgreement","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectRelativeContract();\"> ");
	}
	//发生类型为还旧借新，需设置还旧借新相关属性
	if(sOccurType.equals("060"))
	{
		doTemp.setHeader("RelativeAgreement","关联还旧借新业务");
		doTemp.setVisible("RelativeAgreement",true);
		doTemp.setRequired("RelativeAgreement",true);
		doTemp.setReadOnly("RelativeAgreement",true);		
		doTemp.setUnit("RelativeAgreement","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectRelativeContract();\"> ");
	}*/
	//modify by xhyong 
	//发生类型为资产重组，需设置资产重组相关属性
	if(sOccurType.equals("030"))
	{
		doTemp.setHeader("RelativeAgreement","关联重组方案");
		doTemp.setVisible("RelativeAgreement",true);
		doTemp.setRequired("RelativeAgreement",true);
		doTemp.setReadOnly("RelativeAgreement",true);		
		//doTemp.setUnit("RelativeAgreement"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectNPARefrom()>");
	}
	//end
	//发生类型为复议，需设置复议业务
	if(sOccurType.equals("090"))
	{
		doTemp.setHeader("RelativeAgreement","关联复审业务");
		doTemp.setVisible("RelativeAgreement",true);
		doTemp.setRequired("RelativeAgreement",true);
		doTemp.setReadOnly("RelativeAgreement",true);		
		doTemp.setUnit("RelativeAgreement"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectReApply()>");
	}
	//发生类型为变更，需设置关联业务编号
	if(sOccurType.equals("120"))
	{
		doTemp.setHeader("RelativeAgreement","关联业务编号");
		doTemp.setVisible("RelativeAgreement",true);
		doTemp.setRequired("RelativeAgreement",true);
		doTemp.setReadOnly("RelativeAgreement",true);		
		doTemp.setUnit("RelativeAgreement"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectContractChange()>");
	}
	
	//当客户类型发生改变时，系统自动清空已录入的信息
	doTemp.appendHTMLStyle("CustomerType"," onChange=\"javascript:parent.clearData()\" ");
	if(sOccurType.equals("110"))
	{
		doTemp.setDDDWSql("CustomerType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='CustomerType' and ItemNo='01' and IsInUse='1'");
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置保存时操作关联数据表的动作
	if(sOccurType.equals("120"))
	{
		dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative(#SerialNo,#RelativeObjectType,#RelativeAgreement,APPLY_RELATIVE) + !WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")+ !BusinessManage.InitializeBusiness("+sObjectType+",#SerialNo)+!BusinessManage.BackUpContract(#RelativeObjectType,#SerialNo,#RelativeAgreement,#BusinessType,#ChangType)");
	}else if(sOccurType.equals("015") || sOccurType.equals("030")|| sOccurType.equals("090"))
	{
		dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative(#SerialNo,#RelativeObjectType,#RelativeAgreement,APPLY_RELATIVE) + !WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")+ !BusinessManage.InitializeBusiness("+sObjectType+",#SerialNo)");
	}	
	else
		dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")+!BusinessManage.InitializeBusiness("+sObjectType+",#SerialNo)");
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
			{"true","","Button","确认","确认新增授信申请","doCreation()",sResourcesPath},
			{"true","","Button","上一步","新增授信申请的上一步","beforeStep()",sResourcesPath},
			{"true","","Button","取消","取消新增授信申请","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{		
		if("<%=sApplyType%>" == "DependentApply")
			setItemValue(0,0,"ContractFlag","1");//占用额度
		else
			setItemValue(0,0,"ContractFlag","2");//不占用额度
		//办理权检查lpzhang
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sOccurType = getItemValue(0,getRow(),"OccurType");
		sRelativeAgreement = getItemValue(0,getRow(),"RelativeAgreement");
		sReturn = RunMethod("BusinessManage","CheckCreditCondition",sBusinessType+","+sCustomerID+","+sOccurType+","+sRelativeAgreement+",<%=sApplyType%>");
		if(sReturn != "PASS")
		{
			alert(sReturn);
			return;
		}
		
		//企业贷款默认值为客户自身国标行业分类；展期和个人没有行业投向
		/*
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(<%=sOccurType%> != "015" && "03".indexOf(sCustomerType)!=0)
		{
			sGetIndustryType = RunMethod("BusinessManage","GetIndustryType",sCustomerID);
			setItemValue(0,getRow(),"Direction",sGetIndustryType);
		}
		*/
		initSerialNo();
		as_save("myiframe0",sPostEvents);		
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
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
var ChangeObject = "";
	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		var sReturnValue ="";
		sBusinessType = getItemValue(0,0,"BusinessType");
		sRelativeAgreement = getItemValue(0,0,"RelativeAgreement");
		sApplyType = "<%=sApplyType%>";
		if((sBusinessType.substr(0,4) == "1080" || sBusinessType.substr(0,4) == "2050") && sApplyType =="IndependentApply"){//国际业务
			while(sReturnValue =="" || typeof(sReturnValue) == "undefined" || sReturnValue == "")
			{
				sReturnValue = PopPage("/CreditManage/CreditApply/CreditApplyNationRisk.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			}
			setItemValue(0,getRow(),"NationRisk",sReturnValue);
			setItemValue(0,getRow(),"LowRisk",sReturnValue);
		}
		
		//如果是，则关联借据如果为额度项下业务
		if(sApplyType =="IndependentApply" && "015,020,060".indexOf("<%=sOccurType%>") > -1 && (typeof(sRelativeAgreement) != "undefined" && sRelativeAgreement != ""))
		{
				sReturn = RunMethod("BusinessManage","GetRelativeApplyType",sRelativeAgreement);
				if(sReturn=="DependentApply")
				{
					alert("关联借据为额度项下业务，不能发起该业务申请！");
					return;
				}
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
		if("<%=sOccurType%>" != "030")
		{
			setItemValue(0,0,"RelativeAgreement","");
			setItemValue(0,0,"RelativeObjectType","");
		}
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
			if("<%=sOccurType%>" == "110")//修改(针对国际业务部门)
			{
				setObjectValue("SelectNationBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
			}
			else{
				if(sCustomerType == "03")//个人客户
				{
					var sReturn="";
					if("<%=sApplyType%>" == "IndependentApply")//单笔不做好易贷直易贷
					{
						sReturn=setObjectValue("SelectOtherIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
					}else{
						sReturn=setObjectValue("SelectIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
					}
					if(sReturn == "" || sReturn == "_CANCEL_" || typeof(sReturn) == "undefined") return;
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];
					//针对公积金:
					if(sBusinessType=="1110027")
					{
						var sReturnValue = "";	
						if("<%=sOccurType%>" == "120")
						{
							sReturnValue =PopPage("/CreditManage/CreditApply/AssembleBusinessDialogChange.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
							if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
							{
								sss2 = sReturnValue.split("@");
								setItemValue(0,getRow(),"AFALoanFlag","1");
								setItemValue(0,getRow(),"CommercialNo",sss2[0]);
								setItemValue(0,getRow(),"AccumulationNo",sss2[1]);
								setItemValue(0,getRow(),"ChangType",sss2[2]);
							}
							
						}
						else{
							sReturnValue =PopPage("/CreditManage/CreditApply/AssembleBusinessDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
							if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
							{
								sss2 = sReturnValue.split("@");
								setItemValue(0,getRow(),"AFALoanFlag","1");
								setItemValue(0,getRow(),"CommercialNo",sss2[0]);
								setItemValue(0,getRow(),"AccumulationNo",sss2[1]);
							}
						}
					}
					//纯公积金的变更不在信贷系统发起
					else if("<%=sOccurType%>" == "120" && sBusinessType=="2110020")
					{
						alert("纯公积金的变更不在信贷系统发起");
						setItemValue(0,getRow(),"BusinessTypeName","");
						setItemValue(0,getRow(),"BusinessType","");
						return;
					}
					//个人客户非公积金贷款变更
					else if("<%=sOccurType%>" == "120" && sBusinessType!="2110020")	
					{
					sReturnValue =PopPage("/CreditManage/CreditApply/AssembleBusinessDialogChangeOther.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
					if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
							{
								sss2 = sReturnValue.split("@");
								ChangeObject = sss2[0]
								setItemValue(0,getRow(),"ChangType",sss2[1]);
							}
						
					}
						
				}else //公司客户
				{
					var sReturnValue = "";
					//求Status=1为微小企业 modefied by lpzhang 2010-1-28
					sStatus = RunMethod("BusinessManage","GetSmallCustomerType",sCustomerID);
					if( sStatus == "1")
					{ 
						setObjectValue("SelectSMEBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
					}
					else
					{
						setObjectValue("SelectEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
					}
					//公司客户变更 
					if("<%=sOccurType%>" == "120")
					{
					sReturnValue =PopPage("/CreditManage/CreditApply/AssembleBusinessDialogChangeOther.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
					if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
							{
								sss2 = sReturnValue.split("@");
								ChangeObject = sss2[0]
								setItemValue(0,getRow(),"ChangType",sss2[1]);
							}
					}
				}
			}
			
			if("<%=sApplyType%>" == "IndependentApply")
			{
				sBusinessType = getItemValue(0,0,"BusinessType");
				if("1140130,1150060,1150050,1054,1056".indexOf(sBusinessType)>-1) 
				{
					setItemRequired(0,0,"CommunityAgreement",true);
				}else
				{
					setItemRequired(0,0,"CommunityAgreement",false);
					setItemValue(0,getRow(),"CommunityAgreement",'');
				}
				if(sBusinessType == "1150020"){
					sCustomerIDArr = RunMethod("CreditLine","AssureCustomerID",sCustomerID); //查询客户所在联保小组
					if(typeof(sCustomerIDArr) == "undefined" || sCustomerIDArr == "" || sCustomerIDArr == "Null" || sCustomerIDArr == "NULL")
					{
						alert("该客户不是农户联保小组成员！");
						setItemValue(0,getRow(),"BusinessType",'');
						setItemValue(0,getRow(),"BusinessTypeName",'');
						return;
					}
					//setItemRequired(0,0,"AssureAgreement",true);
					//setItemRequired(0,0,"CommunityAgreement",true);
				}else{
					//setItemRequired(0,0,"AssureAgreement",false);
					//setItemValue(0,getRow(),"AssureAgreement",'');
					//setItemRequired(0,0,"CommunityAgreement",false);
					//setItemValue(0,getRow(),"CommunityAgreement",'');	
				}
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
			setObjectValue("SelectCLContract",sParaString,"@CreditAggreement@0",0,0,"");
			CheckLineDate();
		}
		
		if(sCustomerType == "03")
		{
			sParaString = "CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract1",sParaString,"@CreditAggreement@0",0,0,"");
			CheckLineDate();
		}
	}
	
	function CheckLineDate(){
		sCreditAggreement = getItemValue(0,getRow(),"CreditAggreement");
		dReturn = RunMethod("CreditLine","CheckLineUse",sCreditAggreement);
		if(dReturn <= 0){//如果未做申请
			dReturn = RunMethod("CreditLine","CheckLineDate",sCreditAggreement);
			if(dReturn > 92){
				alert("额度批准超过了三个月不能做项下业务！");
				setItemValue(0,0,"CreditAggreement","");
			}
		}
	}
	/*~[Describe=弹出联保小组授信额度选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	/*function selectAssureAgreement()
	{		
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert(getBusinessMessage('225'));//请先选择客户！
			return;
		}
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(typeof(sBusinessType) == "undefined" || sBusinessType == "")
		{
			alert("请先选择业务品种！");
			return;
		}else if(sBusinessType !="1150020"){
			alert("不是农户联保贷款,不允许选择联保小组额度协议！");
			return;
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert("请先选择客户！");
			return;
		}
		if(sCustomerType != "03")
		{
			alert("非个人客户，不允许选择联保小组额度协议！");
			return;
		}
		sCustomerIDArr = RunMethod("CreditLine","AssureCustomerID",sCustomerID); //查询客户所在联保小组
		if(typeof(sCustomerIDArr) == "undefined" || sCustomerIDArr == "" || sCustomerIDArr == "Null" || sCustomerIDArr == "NULL")
		{
			alert("该客户不是农户联保小组成员！");
			return;
		}else
		{
			sParaString = "CustomerID"+","+sCustomerIDArr+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract2",sParaString,"@AssureAgreement@0",0,0,"");
		}
	}*/
	/*~[Describe=弹出信用共同体授信额度选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCommunityAgreement()
	{		
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert(getBusinessMessage('225'));//请先选择客户！
			return;
		}
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(typeof(sBusinessType) == "undefined" || sBusinessType == "")
		{
			alert("请先选择业务品种！");
			return;
		}
		/*if(sBusinessType == "1150020"){
			sAssureAgreement = getItemValue(0,getRow(),"AssureAgreement");
			if(typeof(sAssureAgreement) == "undefined" || sAssureAgreement == ""){
				alert("农户联保贷款必须先关联农户联保小组授信协议号！");
				return;
			}
		}*/
		else if("1140130,1150060,1150050,1054,1056".indexOf(sBusinessType) < 0) 
		{
			alert("不是信用共同体内贷款，不能选择信用共同体额度！");
			return;
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert("请先选择客户！");
			return;
		}
		if(sBusinessType == "1150020"){
			sCustomerID = RunMethod("CreditLine","AssureCustomerID",sCustomerID); //查询客户所在联保小组
		}
		sCustomerIDArr = RunMethod("CreditLine","CommunityCustomerID",sCustomerID); //查询客户所在信用共同体
		if(typeof(sCustomerIDArr) == "undefined" || sCustomerIDArr == "" || sCustomerIDArr == "Null" || sCustomerIDArr == "NULL")
		{
			alert("该客户不是信用共同体成员！");
			return;
		}else
		{
			sParaString = "CustomerID"+","+sCustomerIDArr+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract3",sParaString,"@CommunityAgreement@0",0,0,"");
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
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateOrgID"+","+"<%=CurUser.OrgID%>";
		setObjectValue("SelectExtendDueBill",sParaString,"@RelativeAgreement@0@BusinessType@1",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","BusinessDueBill");
	}
	
	/*~[Describe=弹出待借新还旧的合同/借据选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectRelativeContract()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sOccurType = "<%=sOccurType%>"
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//请先选择客户！
			return;
		}
		//按照合同借新还旧
		//sParaString = "CustomerID"+","+sCustomerID+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
		//setObjectValue("SelectExtendContract",sParaString,"@RelativeAgreement@0",0,0,"");			
		//setItemValue(0,0,"RelativeObjectType","BusinessContract");
		//按照借据借新还旧
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateOrgID"+","+"<%=CurOrg.OrgID%>";
		if(sOccurType == "015"){//展期
			setObjectValue("SelectExtendDueBill",sParaString,"@RelativeAgreement@0",0,0,"");	
		}else if(sOccurType == "020"){//借新还旧
			setObjectValue("SelectDueBill1",sParaString,"@RelativeAgreement@0",0,0,"");	
		}else if(sOccurType == "060"){//还旧借新
			setObjectValue("SelectDueBill2",sParaString,"@RelativeAgreement@0",0,0,"");	
		}
		setItemValue(0,0,"RelativeObjectType","BusinessDueBill");				
	}
	
	/*~[Describe=弹出资产重组选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectNPARefrom()
	{				
		setObjectValue("SelectNPARefrom","","@RelativeAgreement@0",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","CapitalReform");		
	}
	
	/*~[Describe=弹出资复议的申请，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectReApply()
	{	
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//请先选择客户！
			return;
		}			
		setObjectValue("SelectReApply","CustomerID,"+sCustomerID+","+"OperateUserID"+","+"<%=CurUser.UserID%>","@RelativeAgreement@0",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","BusinessReApply");		
	}
	/*~[Describe=弹出关联业务合同信息，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectContractChange()
	{
		CustomerType = getItemValue(0,0,"CustomerType");
		BusinessType = getItemValue(0,getRow(),"BusinessType");
		CustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//请先选择客户！
			return;
		}			
		if(typeof(BusinessType) == "undefined" || BusinessType == "")
		{
			alert("请选择业务品种！");//请先选择业务品种！
			return;
		}			
		//如果是公积金变更
		if(BusinessType=="1110027")	
		{
			setObjectValue("selectContractChange","UserID,"+"<%=CurUser.UserID%>","@RelativeAgreement@0",0,0,"");		
			setItemValue(0,0,"RelativeObjectType","ContractChange");	
		}	
		//如果是非公积金变更
		else
		{
			if(typeof(ChangeObject) == "undefined" || ChangeObject == "")
			{
				alert("请选择变更对象！");//请先选择变更对象！
				return;
			}
			//如果变更对象是申请信息
			if(ChangeObject=="01")
			{
			sParaString = "UserID,"+"<%=CurUser.UserID%>"+",CustomerID,"+CustomerID+",BusinessType,"+BusinessType;
			//alert(sParaString);
			setObjectValue("selectApplyChangeInfoById",sParaString,"@RelativeAgreement@0",0,0,"");
			setItemValue(0,0,"RelativeObjectType","ApplyChange");	
			}
			//如果变更对象是合同信息
			if(ChangeObject=="02")
			{
			sParaString = "UserID,"+"<%=CurUser.UserID%>"+",CustomerID,"+CustomerID+",BusinessType,"+BusinessType;
			setObjectValue("selectContractChangeInfoById",sParaString,"@RelativeAgreement@0",0,0,"");
			setItemValue(0,0,"RelativeObjectType","ContractChange");	
			}
		}
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
			if("<%=sOccurType%>" == "030")//重组
			{
				setItemValue(0,0,"RelativeAgreement","<%=sNPAReformNo%>");
				setItemValue(0,0,"RelativeObjectType","CapitalReform");		
			}
			//暂存标志
			setItemValue(0,0,"TempSaveFlag","1");//是否标志（1：是；2：否）
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_APPLY";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "BA";//前缀
								
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
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>