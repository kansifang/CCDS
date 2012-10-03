<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: 创建授信额度申请
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
			PhaseType：阶段类型
			FlowNo：流程号
			PhaseNo：阶段号		
		Output param:
		History Log: zywei 2005/07/28
					 zywei 2005/07/28 将授信额度新增页面单独处理	
					 lpzhang 2009-8-26 for TJ
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
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CreditLineApplyCreationInfo";
	
	//根据模板编号设置数据对象	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//设置必输背景色
	doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	doTemp.appendHTMLStyle("CustomerType"," onChange=\"javascript:parent.setCLBusinessType()\" ");
	doTemp.appendHTMLStyle("OccurType"," onChange=\"javascript:parent.setCLOccurType()\" ");
	if(CurUser.hasRole("0F8")){
		doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='OccurType' and ItemNo='010' order by SortNo");
		doTemp.setDDDWSql("CustomerType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='CustomerType' and ItemNo ='0107' and IsInUse='1' order by SortNo");
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置保存时操作关联数据表的动作
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+") + !WorkFlowEngine.InitializeCLInfo(#SerialNo,#BusinessType,#CustomerID,#CustomerName,#InputUserID,#InputOrgID)");
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
			{"true","","Button","确认","确认新增授信额度申请","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消新增授信额度申请","doCancel()",sResourcesPath}	
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
		setItemValue(0,0,"ContractFlag","2");//不占用额度
		as_save("myiframe0",sPostEvents);		
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
		initSerialNo();
		sObjectNo = getItemValue(0,0,"SerialNo");
		sOccurType = getItemValue(0,0,"OccurType");
		sBusinessType = getItemValue(0,0,"BusinessType");
		if(sOccurType == "100" || sOccurType == "090" )
		{
			if("3010" != sBusinessType && "3040" != sBusinessType && "3050" != sBusinessType && "3060" != sBusinessType)
			{
				alert("发生方式为调整或复审，业务品种只能为公司/个人综合授信、信用共同体/农户联保授信！");
				return;
			}
			sRelativeObjectType = getItemValue(0,0,"RelativeObjectType");
			sRelativeAgreement = getItemValue(0,0,"RelativeAgreement");
			RunMethod("BusinessManage","InsertRelative",sObjectNo+","+sRelativeObjectType+","+sRelativeAgreement+",APPLY_RELATIVE");	
		}
		//如果发生类型是 120变更 则先保存申请信息，然后调用BackUpContract方法，从申请信息或者合同信息获取变更申请信息。
		if(sOccurType == "120")
		{
			sRelativeObjectType = getItemValue(0,0,"RelativeObjectType");
			sRelativeAgreement = getItemValue(0,0,"RelativeAgreement");
			sChangType = getItemValue(0,0,"ChangType");
			saveRecord("doReturn()");
			//插入关系表
			RunMethod("BusinessManage","InsertRelative",sObjectNo+","+sRelativeObjectType+","+sRelativeAgreement+",APPLY_RELATIVE");
			//调用公用BackUpContract 备份变更信息到历史表
			RunMethod("BusinessManage","BackUpContract",sRelativeObjectType+","+sObjectNo+","+sRelativeAgreement+","+sBusinessType+","+sChangType+",APPLY_RELATIVE");
		}
		//如果发生类型不是120变更，则只调用保存申请信息。
		else
		{
			saveRecord("doReturn()");
		}
	}
	
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		top.returnValue = sObjectNo;
		top.close();
	}
	//设置域不可用
	function setFieldDisabled(sField)
	{
	  setItemDisabled(0,0,sField,true);
      getASObject(0,0,sField).style.background ="#efefef";
      setItemValue(0,0,sField,"");
	}
	
	//恢复域为可用
	function setFieldNotDisabled(sField)
	{ 
	   setItemDisabled(0,0,sField,false);
	  // getASObject(0,0,sField).style.background ="WHITE";
	  // setItemValue(0,0,sField,"");
	}
	//设置发生方式
	function setCLOccurType()
	{
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		sOccurType = getItemValue(0,0,"OccurType");
		if(sOccurType == "100" || sOccurType == "090" || sOccurType == "120")
		{
			setItemValue(0,0,"BusinessType","");
			setItemValue(0,0,"BusinessTypeName","");
			setItemRequired(0,0,"RelativeAgreement",true);
		}else{
			setItemRequired(0,0,"RelativeAgreement",false);
		}
		
	}
	
		
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{			
		sCustomerType = getItemValue(0,0,"CustomerType");
		sOccurType = getItemValue(0,0,"OccurType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert("请先选择客户类型!");
			return;
		}
		//具有业务申办权的客户信息
		if(sCustomerType == "0107")//同业
		{
			sParaString = "UserID"+","+"<%=CurUser.UserID%>";
			setObjectValue("SelectApplyCustomer7",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		}else if(sCustomerType == "04" || sCustomerType == "05")
		{
			sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+sCustomerType;
			setObjectValue("SelectApplyCustomer6",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		}
		else
		{
			sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+sCustomerType;
			setObjectValue("SelectApplyCustomer3",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		}
		//如果发生类型是120变更，则弹出选择变更对象、变更类型的页面 add by wangdw 2012-08-31
		if(sOccurType == "120"){
		sReturnValue =PopPage("/CreditManage/CreditApply/AssembleBusinessDialogChangeOther.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
		if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
				{
					sss2 = sReturnValue.split("@");
					ChangeObject = sss2[0];
					setItemValue(0,getRow(),"ChangType",sss2[1]);
					if(ChangeObject == "01")
					{
						setItemValue(0,getRow(),"RelativeObjectType","ApplyChange");	
					}else if(ChangeObject == "02")
					{
						setItemValue(0,getRow(),"RelativeObjectType","ContractChange");	
					}
				}
		}
		
	}
	
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectBusinessType(sType)
	{	
		if(sType == "CL") //授信额度的业务品种
		{
			sCustomerType = getItemValue(0,0,"CustomerType");
			sOccurType = getItemValue(0,0,"OccurType");
			if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
			{
				alert("请先选择客户类型!");
				return;
			}
			if(sCustomerType == "0107")
			{
				setItemValue(0,0,"BusinessType","3015");
				setItemValue(0,0,"BusinessTypeName","同业额度");
				alert("同业客户，业务品种只能是同业额度！");
				
			}else if(sCustomerType == "03")
			{
				setItemValue(0,0,"BusinessType","3040");
				setItemValue(0,0,"BusinessTypeName","个人综合授信额度");
				alert("个人客户，业务品种只能是个人综合授信额度！");
				
			}else if(sCustomerType == "04")
			{
				setItemValue(0,0,"BusinessType","3050");
				setItemValue(0,0,"BusinessTypeName","农户联保小组授信额度");
				alert("农户联保小组，业务品种只能是农户联保小组授信额度！");
				
			}else if(sCustomerType == "05")
			{
				setItemValue(0,0,"BusinessType","3060");
				setItemValue(0,0,"BusinessTypeName","信用共同体授信额度");
				alert("信用共同体，业务品种只能是信用共同体授信额度！");
				
			}else if(sCustomerType == "01" && (sOccurType == "100" || sOccurType == "090" ))
			{
				setItemValue(0,0,"BusinessType","3010");
				setItemValue(0,0,"BusinessTypeName","公司综合授信额度");
				alert("公司客户，只能对公司综合授信额度进行调整！");
				
			}else
			{
				setObjectValue("SelectEntEDBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
			}		
		}
	}
	
	//设置业务品种
	function setCLBusinessType()
	{
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		sCustomerType = getItemValue(0,0,"CustomerType");
		
		    if(sCustomerType == "0107")
			{
				setItemValue(0,0,"BusinessType","3015");
				setItemValue(0,0,"BusinessTypeName","同业额度");
				
			}else if(sCustomerType == "01")
			{
				setItemValue(0,0,"BusinessType","3010");
				setItemValue(0,0,"BusinessTypeName","公司综合授信额度");
				
			}else if(sCustomerType == "03")
			{
				setItemValue(0,0,"BusinessType","3040");
				setItemValue(0,0,"BusinessTypeName","个人综合授信额度");
				
			}else if(sCustomerType == "04")
			{
				setItemValue(0,0,"BusinessType","3050");
				setItemValue(0,0,"BusinessTypeName","农户联保小组授信额度");
				
			}else if(sCustomerType == "05")
			{
				setItemValue(0,0,"BusinessType","3060");
				setItemValue(0,0,"BusinessTypeName","信用共同体授信额度");
			}		
		
	}
	
	//关联调整的授信额度
	function selectCLBusiness(){
	    sCustomerID = getItemValue(0,0,"CustomerID");
	    sOccurType = getItemValue(0,0,"OccurType");
	    sBusinessType = getItemValue(0,0,"BusinessType");
	    sRelativeObjectType = getItemValue(0,0,"RelativeObjectType");   	//变更对象
	    if(sOccurType != "100" && sOccurType != "090"&& sOccurType != "120")
		{
			alert("发生方式并非额度或复审调整，不需要录入关联信息！");
			return;
		}
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//请先选择授信客户！
			return;
		}
		if(sOccurType == "090"){	
			setObjectValue("SelectLineReApply","CustomerID,"+sCustomerID+","+"OperateUserID"+","+"<%=CurUser.UserID%>","@RelativeAgreement@0",0,0,"");			
			setItemValue(0,0,"RelativeObjectType","BusinessReApply");	
		}
		//当发生类型是120变更的时候  add by wangdw 2012-09-06
		else if (sOccurType == "120"){
			if(sRelativeObjectType == "ApplyChange")
				{
					//申请变更
					sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerID"+","+sCustomerID+","+"BusinessType"+","+sBusinessType;
					setObjectValue("selectCLBusinessApplyChange",sParaString,"@RelativeAgreement@0",0,0,"");	
				}
			if(sRelativeObjectType == "ContractChange")
				{
					//合同变更
					sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerID"+","+sCustomerID+","+"BusinessType"+","+sBusinessType+","+"CurDate"+",<%=StringFunction.getToday()%>";
					setObjectValue("selectCLBusinessContractChange",sParaString,"@RelativeAgreement@0",0,0,"");	
				}
		}
		else{
			sBusinessType = getItemValue(0,0,"BusinessType");
			sParaString = "CustomerID"+","+sCustomerID+","+"BusinessType"+","+sBusinessType;
			setObjectValue("selectCLBusiness",sParaString,"@RelativeAgreement@0",0,0,"");			
			setItemValue(0,0,"RelativeObjectType","CLBusinessChange");	
		}	
		
	}
							
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录			
			//发生类型
			setItemValue(0,0,"OccurType","010");
			//客户类型
			setItemValue(0,0,"CustomerType","01");
			//产品种类名称
			setItemValue(0,0,"BusinessTypeName","公司综合授信额度");
			//产品种类
			setItemValue(0,0,"BusinessType","3010");	
			if(<%=CurUser.hasRole("0F8")%>){
				setItemValue(0,0,"CustomerType","0107");
				setItemValue(0,0,"BusinessTypeName","同业额度");
				setItemValue(0,0,"BusinessType","3015");
			}
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
			//客户类型默认为公司客户
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
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>