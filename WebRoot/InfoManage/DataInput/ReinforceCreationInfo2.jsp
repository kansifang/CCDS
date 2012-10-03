<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2011/06/14
		Tester:
		Content: 分次放款补登业务信息
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
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信方案新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
//	String sBusinessType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	
	if(sObjectType == null) sObjectType = "";	
	//if(sBusinessType == null) sBusinessType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ReinforceCreationInfo2";
	String sTempletFilter = "1=1";	
	//获取新增额度项下申请参数显示模板
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//设置必输背景色
	//设置必输背景色
	doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//doTemp.setReadOnly("OccurType",true);
	doTemp.setDDDWSql("CustomerType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='CustomerType' and ItemNo in('01','03') and IsInUse='1' order by SortNo");
	doTemp.setRequired("RelativeAgreement",false);
	doTemp.setVisible("RelativeAgreement",false);
	//doTemp.setReadOnly("CustomerType",true);
	//当客户类型发生改变时，系统自动清空已录入的信
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置保存时操作关联数据表的动作
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
		initSerialNo();
		sSerialNo = getItemValue(0,0,"SerialNo");
		sBusinessType = getItemValue(0,0,"BusinessType");
		sCustomerType = getItemValue(0,0,"CustomerType");
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

	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	//add by hlzhang 2008-08-01 在选择业务品种时加入票据项下贴现种类的选择 ---Modify by bma 2008-10-24
	function doCreation()
	{
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sDiscountCategory = getItemValue(0,getRow(),"DiscountCategory");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sCreditAggreement = getItemValue(0,getRow(),"CreditAggreement");
		saveRecord("doReturn()");
	}
	
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		top.returnValue = sObjectNo;
		top.close();
	}
	
	//设置发生方式
	function setCLOccurType()
	{
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		sOccurType = getItemValue(0,0,"OccurType");
		if(sOccurType == "100")
		{
			setItemValue(0,0,"BusinessType","");
			setItemValue(0,0,"BusinessTypeName","");
			setItemRequired(0,0,"RelativeAgreement",true);
		}else{
			setItemRequired(0,0,"RelativeAgreement",false);
		}
		
	}
	/*~[Describe=清空信息;InputParam=无;OutPutParam=申请流水号;]~*/
	function clearData(){
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
	}
	
	
	/*~[Describe=弹出记账机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectPutOutOrg()
	{		
		sParaString = "SortNo"+","+"<%=CurOrg.SortNo%>";
		setObjectValue("SelectBelongOrgCode",sParaString,"@PutOutOrgID@0@PutOutOrgName@1",0,0,"");		
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
		clearData();
		//具有业务申办权的客户信息
		sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+sCustomerType;
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
	function selectBusinessType()
	{		
		sCustomerType = getItemValue(0,0,"CustomerType");
		if(sCustomerType == "01")
			//setObjectValue("SelectRFBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
			setObjectValue("SelectEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
		else{
			//setObjectValue("SelectRFBusinessType1","","@BusinessType@0@BusinessTypeName@1",0,0,"");
			sReturn=setObjectValue("SelectIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
		}			
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录		
			//发生类型
			//发生日期
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			//申请类型
			setItemValue(0,0,"ApplyType","IndependentApply");
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
			//登记机构
			setItemValue(0,0,"ManageOrgID","<%=CurUser.OrgID%>");
			//登记人
			setItemValue(0,0,"ManageUserID","<%=CurUser.UserID%>");
			//登记日期			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//更新日期
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//归档日期
			//setItemValue(0,0,"PigeonholeDate","<%=StringFunction.getToday()%>");
			//暂存标志
			setItemValue(0,0,"TempSaveFlag","1");//是否标志（1：是；2：否）
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "FC";//前缀
								
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
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>