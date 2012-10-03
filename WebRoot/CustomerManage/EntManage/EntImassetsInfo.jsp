<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   XWu  2004.11.29
		Tester:
		Content: 客户无形资产信息
		Input Param:
            CustomerID：客户编号
            SerialNo：信息流水号
            EditRight:权限代码（01：查看权；02：维护权）
		Output param:

		History Log: 
             2003.08.20 CYHui
             2003.08.28 CYHui
             2003.09.08 CYHui 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户无形资产信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql ="";
	
	//获得组件参数:客户ID	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//取流水号
	String sSerialNo   =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sEditRight == null) sEditRight = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { 
							{"CustomerID","个人编号"},
							{"SerialNo","流水号"},
							{"AssetType","资产类型"},
							{"AuthNo","证书编号"},
							{"AssetDescribe","资产简述"},
							{"AuthOrg","认证机构"},
							{"AuthDate","认证日期"},
							{"EvaluateValue","评估价值"},
							{"EvaluateMethod","评估方法"},
							{"AccountValue","入帐价值"},
							{"UpToDate","统计截止日期"},
							{"InputOrgName","登记单位"},
							{"InputUserName","登记人"},
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"},
							{"Remark","备注"},
							{"AssetName","资产名称"}
						  };

		sSql =	" select CustomerID,SerialNo,AssetType,AssetName,AuthNo,AssetDescribe,AuthOrg,"+
				" AuthDate,EvaluateValue,EvaluateMethod,AccountValue,UpToDate,Remark,"+
				" InputOrgID,getOrgName(InputOrgID) as InputOrgName," +
				" InputUserID,getUserName(InputUserID) as InputUserName," +
				" InputDate,UpdateDate"+
				" from CUSTOMER_IMASSET"+
				" where CustomerID='"+sCustomerID+"' "+
				" and SerialNo='"+sSerialNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_IMASSET";

	doTemp.setKey("CustomerID,SerialNo",true);
	doTemp.setUpdateable("InputOrgName,InputUserName",false);
	doTemp.setUnit("EvaluateValue,AccountValue","元");
	doTemp.setLimit("AssetDescribe,Remark",200);
	
	doTemp.setVisible("CustomerID,SerialNo,InputOrgID,InputUserID",false);
	doTemp.setRequired("AssetType,AssetDescribe,,EvaluateMethod,AuthOrg,AccountValue,UpToDate",true);
	doTemp.setUpdateable("InputUserName",false);	
	doTemp.setReadOnly("InputUserName",true); 
	doTemp.setAlign("AuthDate,UpToDate,InputDate,UpdateDate","2");
	doTemp.setAlign("EvaluateValue,AccountValue","3");
	doTemp.setType("EvaluateValue,AccountValue","Number");

	doTemp.setCheckFormat("AuthDate,UpToDate,InputDate,UpdateDate","3");
	doTemp.setCheckFormat("EvaluateValue,AccountValue","2");
	doTemp.setHTMLStyle("AuthDate,UpToDate,InputDate,UpdateDate"," style={width:70px}");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setReadOnly("InputDate,UpdateDate,InputOrgName,InputUserName",true);
	doTemp.setDDDWCode("AssetType","ImmaterialAssetType");
	doTemp.setDDDWCode("EvaluateMethod","EvaluateMethod");
	doTemp.setEditStyle("Remark,AssetDescribe","3");
	doTemp.setHTMLStyle("Remark,AssetDescribe"," style={height:100px;width:400px} ");
	
	//设置评估价值(元)范围
	doTemp.appendHTMLStyle("EvaluateValue"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"评估价值(元)必须大于等于0！\" ");
	//设置入帐价值(元)范围
	doTemp.appendHTMLStyle("AccountValue"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"入帐价值(元)必须大于等于0！\" ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sSerialNo);
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
		{(sEditRight.equals("02")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
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
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntImassetsList.jsp","_self","");
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{		
		initSerialNo();//初始化流水号字段
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{					
		//校验统计截止日期是否大于当前日期
		sUpToDate = getItemValue(0,0,"UpToDate");//统计截止日期
		sToday = "<%=StringFunction.getToday()%>";//当前日期		
		if(typeof(sUpToDate) != "undefined" && sUpToDate != "" )
		{
			if(sUpToDate >= sToday)
			{		    
				alert(getBusinessMessage('144'));//统计截止日期必须早于当前日期！
				return false;		    
			}
		}
		
		//校验认证日期是否大于当前日期
		sAuthDate = getItemValue(0,0,"AuthDate");//认证日期
		sToday = "<%=StringFunction.getToday()%>";//当前日期		
		if(typeof(sAuthDate) != "undefined" && sAuthDate != "" )
		{
			if(sAuthDate >= sToday)
			{		    
				alert(getBusinessMessage('145'));//认证日期必须早于当前日期！
				return false;		    
			}
			//校验统计截止日期是否大于认证日期
			if(sUpToDate <= sAuthDate)
			{		    
				alert(getBusinessMessage('164'));//统计截止日期必须晚于认证日期！
				return false;		    
			}
		}
		
		
		
						
		return true;
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
   	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_IMASSET";//表名
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
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
