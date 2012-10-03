<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: 新增授信额度页面
		Input Param:
			
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数
		
	//获得页面参数	
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%	
	//设置显示标题				
	String[][] sHeaders = {					
					{"CLTypeID","额度类型编号"},
					{"CLTypeName","额度类型名称"},					
					{"CustomerID","客户编号"},
					{"CustomerName","客户名称"},
					{"LineSum1","额度金额（元）"},
					{"Currency","币种"},
					{"LineEffDate","生效日"},
					{"BeginDate","起始日"},
					{"EndDate","到期日"},
					{"InputOrgName","登记机构"},
					{"InputUserName","登记人"},
					{"InputTime","登记日期"},
					{"UpdateTime","更新日期"}															
					};
	String sSql = 	" select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName, "+
					" LineSum1,Currency,LineEffDate,BeginDate,EndDate,LineEffFlag, "+
					" FreezeFlag,GetOrgName(InputOrg) as InputOrgName,InputOrg,InputUser, "+
					" GetUserName(InputUser) as InputUserName,InputTime,UpdateTime "+
					" from CL_INFO Where 1=2 ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setDDDWCode("LineEffFlag","EffStatus");
	
	//设置不可见属性
	doTemp.setVisible("LineID,CLTypeID,BCSerialNo,LineEffDate,LineEffFlag,FreezeFlag,InputUser,InputOrg",false);
	//设置只读属性
	doTemp.setReadOnly("LineID,CLTypeID,CLTypeName,CustomerID,CustomerName,InputUserName,InputOrgName,InputTime,UpdateTime",true);
	//设置必输项
	doTemp.setRequired("LineID,CLTypeName,CustomerName,LineSum1,Currency,BeginDate,EndDate",true);
	//设置不可更新属性
	doTemp.setUpdateable("InputUserName,InputOrgName",false);
	//设置格式
	doTemp.setType("LineSum1","Number");
	doTemp.setCheckFormat("LineEffDate,BeginDate,EndDate","3");	
	doTemp.setHTMLStyle("InputUserName,InputTime,UpdateTime"," style={width:80px;} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
	doTemp.setUnit("CustomerName","<input type=button value=\"...\" onClick=parent.selectCustomer()>");
	doTemp.setUnit("CLTypeName","<input type=button value=\"...\" onClick=parent.setCLType()>");
	
	//设置额度金额（元）范围
	doTemp.appendHTMLStyle("LineSum1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"额度金额（元）必须大于等于0！\" ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.AddCLContractInfo(#BCSerialNo,#CustomerID,#CustomerName,#LineSum1,#Currency,#BeginDate,#EndDate,#InputUser)");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.AddCLContractInfo(#BCSerialNo,#CustomerID,#CustomerName,#LineSum1,#Currency,#BeginDate,#EndDate,#InputUser)");
		
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
		{"true","","Button","确定","保存所有修改并返回","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","取消","返回","cancel()",sResourcesPath},
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
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	
	/*~[Describe=保存所有修改,并返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function saveRecordAndReturn()
	{
		saveRecord("goBack()");
	}
	
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	function goBack(){
		var sLineID = getItemValue(0,0,"LineID");
		var sLineName = getItemValue(0,0,"LineName");
		top.returnValue = sLineID + "@" + sLineName;
		top.close();
	}
	
	function cancel(){
		top.close();
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段（CL_INFO）
		initBCSerialNo();//初始化流水号字段（BUSINESS_CONTRACT）		
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetDay.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{			
		//校验生效日是否早于当前日期		
		sLineEffDate = getItemValue(0,getRow(),"LineEffDate");//生效日
		sInputTime = getItemValue(0,getRow(),"InputTime");//登记日期
		if (typeof(sLineEffDate)!="undefined" && sLineEffDate.length > 0)
		{			
			if(sLineEffDate < sToday && sInputTime == sToday)
			{		    
				alert(getBusinessMessage('409'));//生效日必须晚于或等于当前日期！
				return false;		    
			}
		}
		
		//检验生效日、起始日和到期日之间的业务逻辑关系
		sBeginDate = getItemValue(0,getRow(),"BeginDate");//起始日			
		sEndDate = getItemValue(0,getRow(),"EndDate");//到期日	
		sToday = "<%=StringFunction.getToday()%>";//当前日期
		if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
		{			
			if(sBeginDate < sToday  && sInputTime == sToday)
			{		    
				alert(getBusinessMessage('410'));//起始日必须晚于或等于当前日期！
				return false;		    
			}
						
			if(typeof(sEndDate)!="undefined" && sEndDate.length > 0)
			{
				if(sEndDate <= sBeginDate)
				{		    
					alert(getBusinessMessage('172'));//到期日必须晚于起始日！
					return false;		    
				}
				
				if (typeof(sLineEffDate)!="undefined" && sLineEffDate.length > 0)
				{
					if(sEndDate <= sLineEffDate)
					{		    
						alert(getBusinessMessage('411'));//到期日必须晚于生效日！
						return false;		    
					}
				}
			}	
		}
						
		return true;
	}
	
	/*~[Describe=弹出额度类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function setCLType(){
		setObjectValue("SelectCreditLineType","","@CLTypeID@0@CLTypeName@1",0,0,"");		
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{			
		//具有业务申办权的客户信息
		sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+"01";
		setObjectValue("SelectApplyCustomer1",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{		
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"LineEffFlag","1");
			setItemValue(0,0,"FreezeFlag","1");//FreezeFlag(1:正常;2:冻结;3:解冻;4:终止)
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");			
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CL_INFO";//表名
		var sColumnName = "LineID";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initBCSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),"BCSerialNo",sSerialNo);
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
