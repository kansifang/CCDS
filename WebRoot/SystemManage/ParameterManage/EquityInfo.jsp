<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zrli 
		Tester:
		Content: 资本净额管理
		Input Param:
		       --SerialNO:流水号
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "资本净额管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSerialNo="";//--流水号码
	String sArgumentType="";//参数类型
	String sSql="";//--存放sql语句
	//获得组件参数

	//获得页面参数	,流水号
    sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    sArgumentType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ArgumentType"));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { 		
								{"SerialNo","流水号"},		                   
			                    {"ArgumentType","参数类型"},	
			                    {"BelongOrg","所属机构"},	
			                    {"BelongOrgName","所属机构"},	
			                    {"ArgumentValue","资本净额"},		
							    {"InputUser","登记人员"},		
						        {"InputUserName","登记人员"},
						        {"InputDate","登记日期"},
						        {"InputOrg","登记机构"},
						        {"InputOrgName","登记机构"},
						        {"UpdateUser","更新人员"},
						        {"UpdateUserName","更新人员"},
						        {"UpdateDate","更新日期"},
						        {"UpdateOrg","更新机构"},
						        {"UpdateOrgName","更新机构"}
			               };   				   		
	
	sSql = " select SerialNo,ArgumentType,BelongOrg,getOrgName(BelongOrg) as BelongOrgName,ArgumentValue,"+
		   " InputUser,getUserName(InputUser) as "+
		   " InputUserName,InputDate,InputOrg,getOrgName(InputOrg) as InputOrgName,UpdateUser,getUserName(UpdateUser) as UpdateUserName,"+
		   " UpdateDate,UpdateOrg,getOrgName(UpdateOrg) as UpdateOrgName from Parameter_CFG "+	            
		    " where SerialNo = '"+sSerialNo+"' ";
    //sql产生datawindows
	ASDataObject doTemp = new ASDataObject(sSql);
	//头名称
	doTemp.setHeader(sHeaders);
	//修改表
	doTemp.UpdateTable = "PARAMETER_CFG";
    //设置主键
	doTemp.setKey("SerialNo",true);
	//设置字段的不可见
	doTemp.setVisible("SerialNo,ArgumentType,InputUser,InputOrg,UpdateUser,UpdateOrg,BelongOrg",false);
	//设置number列
	doTemp.setCheckFormat("ArgumentValue","5");
	//置字段是否可更新，主要是外部函数产生的，类似UserName\OrgName	    
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName,UpdateOrgName,BelongOrgName",false);
	doTemp.setReadOnly("ArgumentModel,BelongOrgName",true);
	doTemp.setHTMLStyle("BelongOrgName,InputOrgName,UpdateOrgName"," style={width:250px} ");
	//设置必输项
	doTemp.setRequired("ArgumentValue,BelongOrg",true);
	doTemp.setUnit("ArgumentValue","万元");
	doTemp.setUnit("BelongOrgName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getOrgName();\"> ");
	doTemp.setHTMLStyle("BelongOrgName","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getOrgName()\" ");
	
	//设置只读列
	
	//设置日期的格式
	//doTemp.setCheckFormat("InputDate,UpdateDate","3");

	//下拉窗口
    //设置number值类型
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

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
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getOrgName()
	{
		sOrgID = "<%=CurOrg.OrgID%>";
		sOrgLevel = "<%=CurOrg.OrgLevel%>";
		
		if (typeof(sOrgID) == 'undefined' || sOrgID.length == 0) 
        {
        	alert(getBusinessMessage("900"));//请输入机构编号！
        	return;
        }
		if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0) 
        {
        	alert(getBusinessMessage("901"));//请选择级别！
        	return;
        }
		sParaString = "OrgID"+","+sOrgID+","+"OrgLevel"+","+sOrgLevel;		
		setObjectValue("SelectOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");
		
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert)
		{
			beforeInsert();
			//特殊增加,如果为新增保存,保存后页面刷新一下,防止主键被修改
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
			return;
		}else{	
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
		}
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/ParameterManage/EquityList.jsp","_self","");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

		/*~[Describe=保存后进行页面刷新动作;InputParam=无;OutPutParam=无;]~*/
	function pageReload()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--重新获得流水号
		OpenPage("/SystemManage/ParameterManage/EquityInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
	}
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
       initSerialNo();//初始化流水号字段
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sDay = "<%=StringFunction.getToday()%>";//--获得当前日期
		setItemValue(0,0,"UpdateDate",sDay);
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateOrg","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
	}
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
	    //返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码		
		setObjectValue("SelectOwner","","@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");	    
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;

			sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"UpdateOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
			setItemValue(0,0,"ArgumentType","<%=sArgumentType%>");//--管理参数
		}
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "PARAMETER_CFG";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
       
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
