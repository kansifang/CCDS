<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.7
		Tester:
		Content: 创建补登合同信息
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "补登合同信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数
	String sItemNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	
	//sInputFlag=G表示新增合同进入，sInputFlag=Y表示新增额度进入
	String sInputFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sInputFlag==null) sInputFlag="";
	
	//sListFlag=CAVInputCreditList表示需补登核销列表的新增合同，否则为需补登信贷业务列表的新增合同
	String sListFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ListFlag"));
	if(sListFlag==null) sListFlag="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ReinforceContract";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 

	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20); 	//服务器分页
	
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
	String sButtons[][] = {};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”
	var sObjectNo = "";    //关联对象类型

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		var sSerialNo = getItemValue(0,0,"SerialNo");		
		var	sBusinessType = getItemValue(0,0,"BusinessType");
		var	sBusinessTypeName = getItemValue(0,0,"BusinessTypeName");

		if(bIsInsert)
		{
			sBusinessTypeName = getItemValue(0,0,"BusinessTypeName");
			sOccurType = getItemValue(0,0,"OccurType");
			sCustomerID = getItemValue(0,0,"CustomerID");
			sBusinessType = getItemValue(0,0,"BusinessType");

			//选取展期关联的合同号
			if (sOccurType=="015") 
			{
				alert("你选择的业务发生类型为展期，请选择展期关联的业务！");
				//选取合同号
				sReturn = selectObjectInfo("BusinessContract","UserID=<%=CurUser.UserID%>~Finished=N~CustomerID="+sCustomerID+"~BusinessType=='"+sBusinessType+"'");
				if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
				sReturn = sReturn.split("@");
				sObjectNo=sReturn[0];
			}

			//选取借新还旧关联的合同号
			if (sOccurType=="020") {
				alert("你选择的业务发生类型为借新还旧，请选择借新还旧关联的业务！");
				//选取合同号
				sReturn = selectObjectInfo("BusinessContract","UserID=<%=CurUser.UserID%>~Finished=N~CustomerID="+sCustomerID);
				if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
				sReturn = sReturn.split("@");
				sObjectNo=sReturn[0];
			}

			//选取关联的重组方案
			if (sOccurType=="030") {
				alert("你选择的业务发生类型为资产重组，请选择关联的重组方案！");
				sReturn = selectObjectInfo("NPARefromApply","");
				if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
				sReturn = sReturn.split("@");
				sObjectNo=sReturn[0];
			}

			//取得流水号后进行插入初始化工作
			beforeInsert();
			sSerialNo = getItemValue(0,0,"SerialNo");

			//关联展期和借新还旧关联的合同号
			if (sOccurType=="015" || sOccurType=="020") {
				var sRTableName="CONTRACT_RELATIVE";
				var sRelativeType="BusinessContract";
				//增加关联
				sReturnValue=PopPage("/CreditManage/CreditApply/AddBusinessRelativeAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&RTableName="+sRTableName+"&RelativeType="+sRelativeType,"","");
				if (sReturnValue!="ok") return;
			}

			//关联重组方案
			if (sOccurType=="030") {
				var sRTableName="CONTRACT_RELATIVE";
				var sRelativeType="NPARefromApply";
				//增加关联
				sReturnValue=PopPage("/CreditManage/CreditApply/AddBusinessRelativeAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&RTableName="+sRTableName+"&RelativeType="+sRelativeType,"","");
				if (sReturnValue!="ok") return;
			}

			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	</script>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~选择授信额度号和余额~*/
	function selectCreditLine()
	{
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(sBusinessType==""){
			alert("请先选择业务品种类型!");
			return;
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(sCustomerID==""){
			alert("请先选择客户!");
			return;
		}
		sReturn = setObjectInfo("CreditLineContract","BusinessType="+sBusinessType+"~CustomerID="+sCustomerID+"@CreditAggreement@0@TotalSum@1",0,0);
	}
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		saveRecord("doReturn()");
	}

	function doReturn(){
		sOccurType = getItemValue(0,0,"OccurType");
		sSerialNo = getItemValue(0,0,"SerialNo");

		//根据发生方式，拷贝相应的信息
		//选取展期和借新还旧关联的合同号
		if (sOccurType=="015" || sOccurType=="020") {
			//拷贝业务信息
			sReturnValue=PopPage("/CreditManage/CreditApply/ExetendApplyAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectTable=BUSINESS_CONTRACT&OccurType="+sOccurType,"","");
		}
		sBusinessTypeName = getItemValue(0,0,"BusinessTypeName");
		sCustomerName = getItemValue(0,0,"CustomerName");
		parent.sObjectInfo = sSerialNo+"@"+sCustomerName+"-"+sBusinessTypeName;
		parent.doReturn();
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段

		//资金来源(数据库字段FundSource) 参照代码表CapitalSource
		//businesstype为2060/3110时020
		//businesstype为like1070时030
		//其他都为010
		sBusinessType = getItemValue(0,0,"BusinessType");
		if (sBusinessType == "2060" || sBusinessType == "3110") {
			setItemValue(0,0,"FundSource","020");
		}
		else if (sBusinessType.substr(0,4) == "1070") {
			setItemValue(0,0,"FundSource","030");
		}
		else {
			setItemValue(0,0,"FundSource","010");
		}

		//操作方式(数据库字段OperateType) 参照代码表OperateType
		//businesstype为1060时030
		//其他都为010
		if (sBusinessType == "1060") {
			setItemValue(0,0,"OperateType","030");
		}
		else {
			setItemValue(0,0,"OperateType","010");
		}

		bIsInsert = false;
	}

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
	}

	/*~[Describe=弹出客户类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomerType()
	{
		sReturn = setObjectInfo("Code","CodeNo=CustomerType^客户类型^length(ItemNo)=3@CustomerType@0",0,0);
		if(sReturn!="_CANCEL_" && typeof(sReturn)!="undefined"){
			setItemValue(0,getRow(),"CustomerID","");
			setItemValue(0,getRow(),"CustomerName","");
			setItemValue(0,getRow(),"BusinessType","");
			setItemValue(0,getRow(),"BusinessTypeName","");
		}
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(sCustomerType==""){
			alert("请先选择客户类型!");
			return;
		}
		setObjectInfo("Customer","CustomerType=like '"+sCustomerType+"%'~CustomerBelong=All~CustomerFlag=00@CustomerID@0@CustomerName@1",0,0);
	}
	
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectBusinessType()
	{
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		sItemNo = "<%=sItemNo%>";
		sInputFlag = "<%=sInputFlag%>";
		//sInputFlag = "X";
		if(sCustomerType==""){
			alert("请先选择客户类型!");
			return;
		}
		if(sItemNo == '010')
		{
			if(sInputFlag=="G")
			{
				//表示新增合同进入
			    if("<%=sListFlag%>"=="CAVInputCreditList")//核销补登新增
			    {
			        //列出所有业务品种
			        setObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=N@BusinessType@0@BusinessTypeName@1",0,0);
			    }
			    else
			    {
			        //信贷补登新增,列出表外业务品种
			        setObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=G~SubTypeFlag=Y@BusinessType@0@BusinessTypeName@1",0,0);
			    }
			}
			else
			{
				//表示补登业务进入
				setObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=X@BusinessType@0@BusinessTypeName@1",0,0);
			}
		}else
		{
			//额度补登
			setObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=Y@BusinessType@0@BusinessTypeName@1",0,0);
		}
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CustomerType","010");

			//发生日期
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			//经办机构
			//经办人
			//登记机构
			//登记人
			//登记日期
			//更新日期
			
			setItemValue(0,0,"PutOutOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"ManageOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"ManageUserID","<%=CurUser.UserID%>");
			
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"PigeonholeDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"BailCurrency","01");
			
			if("<%=sItemNo%>"=="010")
			{
				setItemValue(0,0,"ReinforceFlag","010");
			}
			if("<%=sItemNo%>"=="110")
			{
				setItemValue(0,0,"ReinforceFlag","110");
			}
			
			//如果新增核销资产，则初始化终结类型=060核销
			if("<%=sListFlag%>"=="CAVInputCreditList")
			{
				setItemValue(0,0,"FinishType","060");
			}

			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "BC";//前缀

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