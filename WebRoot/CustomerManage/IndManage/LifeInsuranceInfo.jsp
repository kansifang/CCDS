<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: bliu 2004-12-02
		Tester:
		Describe: 人寿保险情况
		Input Param:
			CustomerID：当前客户编号
			SerialNo:	流水号
			EditRight:权限代码（01：查看权；02：维护权）
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "人寿保险情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得组件参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//获得页面参数	,流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sSerialNo == null ) sSerialNo = "";
	if(sEditRight == null) sEditRight = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "BusinessInsuranceInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//设置保障金额(元)范围
	doTemp.appendHTMLStyle("INSUREDSUM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保障金额(元)必须大于等于0！\" ");
	//设置现金价值(元)范围
	doTemp.appendHTMLStyle("CASHVALUE"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"现金价值(元)必须大于等于0！\" ");
	
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
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/IndManage/LifeInsuranceList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{			
		//校验统计截止日期是否大于当前日期
		sUpToDate = getItemValue(0,0,"UPTODATE");//统计截止日期
		sToday = "<%=StringFunction.getToday()%>";//当前日期		
		if(typeof(sUpToDate) != "undefined" && sUpToDate != "" )
		{
			if(sUpToDate >= sToday)
			{		    
				alert(getBusinessMessage('144'));//统计截止日期必须早于当前日期！
				return false;		    
			}
		}	
		
		//校验投保日期、到期日期、退保日期之间的业务逻辑关系
		sBeginDate = getItemValue(0,getRow(),"INSUREDATE");//投保日期			
		sEndDate = getItemValue(0,getRow(),"MATURITY");//到期日期	
		sCancelDate = getItemValue(0,getRow(),"CANCELDATE");//退保日期		
		if(typeof(sBeginDate) != "undefined" && sBeginDate != "" )
		{
			if(sBeginDate >= sToday)
			{
				alert(getBusinessMessage('213'));//投保日期必须早于当前日期！
				return false;	
			}
			
			if(typeof(sUpToDate) != "undefined" && sUpToDate != "" )
			{
				if(sUpToDate <= sBeginDate)
				{		    
					alert(getBusinessMessage('217'));//统计截止日期必须晚于投保日期！
					return false;		    
				}
			}
			
			if(typeof(sEndDate) != "undefined" && sEndDate != "" )
			{
				if(sEndDate <= sBeginDate)
				{
					alert(getBusinessMessage('214'));//到期日期必须晚于投保日期！
					return false;
				}
			}
			
			if(typeof(sCancelDate) != "undefined" && sCancelDate != "" )
			{
				if(sCancelDate <= sBeginDate)
				{
					alert(getBusinessMessage('215'));//退保日期必须晚于投保日期！
					return false;
				}
				
				if(sCancelDate >= sToday)
				{
					alert(getBusinessMessage('216'));//退保日期必须早于当前日期！
					return false;
				}
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
			setItemValue(0,0,"CUSTOMERID","<%=sCustomerID%>");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.UserID%>");
			setItemValue(0,0,"INPUTORGID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.UserName%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"BITYPE","02");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "IND_BI";//表名
		var sColumnName = "SERIALNO";//字段名
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
