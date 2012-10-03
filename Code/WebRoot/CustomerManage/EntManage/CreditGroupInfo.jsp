<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/10
		Tester:
		Describe: 信用共同体成员信息;
		Input Param:
			CustomerID：当前客户编号
			RelativeID：关联客户编号
			Relationship：关联关系
		Output Param:
			CustomerID：当前客户编号

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用共同体成员信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得组件参数

	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

	//获得页面参数
	String sRelativeID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = {
							{"CustomerName","信用共同体成员名称"},
							{"CertType","证件类型"},
							{"CertID","证件号码"},
							{"RelativeID","信用共同体成员编号"},
							{"CGALevel","信用共同体内评定级别"},
							{"AssureGroupID","该成员所在联保小组编号"},
							{"AssureGroupName","该成员所在联保小组名称"},
							{"Remark","备注"},
							{"OrgName","登记机构"},
							{"UserName","登记人"},
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"}
						   };

	String sSql =	" select CustomerID,RelativeID," +
					" CustomerName,CertType,CertID,RelationShip,CGALevel,"+
					" AssureGroupID,getCustomerName(AssureGroupID) as AssureGroupName,"+
					" Remark," +
					" InputUserId,getUserName(InputUserId) as UserName,InputDate,UpdateDate, "+
					" InputOrgId,getOrgName(InputOrgId) as OrgName "+
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"' " +
					" and RelativeID='"+sRelativeID+"' " +
					" and RelationShip ='"+sRelationShip+"'" ;

	//由sSql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头,更新表名,键值,必输项,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	doTemp.setRequired("CGALevel,RelativeID,CustomerName,RelationShip",true);
	doTemp.setVisible("RelationShip,CustomerID,RelativeID,AssureGroupID,InputUserId,InputOrgId",false);
	doTemp.setUpdateable("AssureGroupName,UserName,OrgName",false);

	//设置字段格式
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark","style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	//注意,先设HTMLStyle，再设ReadOnly，否则ReadOnly不会变灰
	doTemp.setHTMLStyle("OrgName","style={width:250px}");
	doTemp.setHTMLStyle("UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setReadOnly("AssureGroupName,CustomerName,CertType,CertID,OrgName,UserName,InputDate,UpdateDate",true);

	//设置下拉框
	//doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and ItemNo like 'I%'");
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWCode("CGALevel","AssessLevel");
	//设置默认值
	doTemp.setDefaultValue("RelationShip","0701");
	
	doTemp.setUnit("AssureGroupName"," <input type=button value=.. onclick=parent.selectAssureGroupID()>");
	//若关联客户编号为空，则出现选择客户提示框
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
	} else {
		doTemp.setReadOnly("RelationShip",true);
	}

	//生成数据窗体
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform格式

	//设置插入和更新事件，反方向插入和更新
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");

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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
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
		if(bIsInsert){
			//保存前进行检查,检查通过后继续保存,否则给出提示
		    if (!RetaiveCheck()) return;
			beforeInsert();
			//特殊增加,如果为新增保存,保存后页面刷新一下,防止主键被修改
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/CreditGroupList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");
		var sRelationShip   = getItemValue(0,getRow(),"RelationShip");
		OpenPage("/CustomerManage/EntManage/CreditGroupInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip, "_self","");
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		sParaString = "UserID"+","+"<%=CurUser.UserID%>";		
		setObjectValue("SelectCustomer1",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectAssureGroupID()
	{
		var sCustomerID   = getItemValue(0,getRow(),"RelativeID");
		sParaString = "RelativeID,"+sCustomerID
		setObjectValue("SelectFarmAssureGroup",sParaString,"@AssureGroupID@0@AssureGroupName@1",0,0,"");
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		if (getItemValue(0,getRow(),"RelativeID") ==  "") {
			//假如相关客户编号为空，初始化一个客户流水号
			initSerialNo();
		}
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}

	/*~[Describe=关联关系插入前检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function RetaiveCheck() 
	{
		sCustomerID   = getItemValue(0,0,"CustomerID");
		sCustomerName = getItemValue(0,0,"CustomerName");
		if (typeof(sCustomerName)=="undefined" || sCustomerName.length==0)
		{
			alert("<%=sHeaders[0][1]%>不能为空!");
			return false;
		}
		sCertType = getItemValue(0,0,"CertType");
		if (typeof(sCertType)=="undefined" || sCertType.length==0)
		{
			alert("<%=sHeaders[1][1]%>不能为空!");
			return false;
		}
		sCertID = getItemValue(0,0,"CertID");
		if (typeof(sCertID)=="undefined" || sCertID.length==0)
		{
			alert("<%=sHeaders[2][1]%>不能为空!");
			return false;
		}

		sRelationShip = getItemValue(0,0,"RelationShip");
		if (typeof(sRelationShip)=="undefined" || sRelationShip.length==0)
		{
			alert("<%=sHeaders[3][1]%>不能为空!");
			return false;
		}
		var sMessage = PopPage("/CustomerManage/EntManage/RelativeCheckAction.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
		if (typeof(sMessage)=="undefined" || sMessage.length==0) {
			return false;
		}
		setItemValue(0,0,"RelativeID",sMessage);
		return true;
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>