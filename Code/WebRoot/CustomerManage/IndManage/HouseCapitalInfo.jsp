<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: bliu 2004-12-02
		Tester:
		Describe: 房屋资产情况
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
	String PG_TITLE = "房屋资产情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sTempletNo = "HouseCaptialInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//设置房屋面积（平方米）范围
	doTemp.appendHTMLStyle("REALTYAREA"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房屋面积（平方米）必须大于等于0！\" ");
	//设置建构价格(元)范围
	doTemp.appendHTMLStyle("BUILDPRICE"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建构价格(元)必须大于等于0！\" ");
	//设置评估价格(元)范围
	doTemp.appendHTMLStyle("EVALUATEPRICE"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"评估价格(元)必须大于等于0！\" ");
	//设置所占份额(%)范围
    doTemp.appendHTMLStyle("SHAREPROP"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"所占份额(%)的范围为[0,100]\" ");
	
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
		OpenPage("/CustomerManage/IndManage/HouseCapitalList.jsp","_self","");
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
		
		//校验买入日期、卖出日期之间的业务逻辑关系
		sPurchaseDate = getItemValue(0,getRow(),"PURCHASEDATE");//买入日期			
		sSaleDate = getItemValue(0,getRow(),"SALEDATE");//卖出日期			
		if(typeof(sPurchaseDate) != "undefined" && sPurchaseDate != "" )
		{
			if(sPurchaseDate >= sToday)
			{
				alert(getBusinessMessage('218'));//买入日期必须早于当前日期！
				return false;	
			}
			
			if(typeof(sUpToDate) != "undefined" && sUpToDate != "" )
			{
				if(sUpToDate <= sPurchaseDate)
				{		    
					alert(getBusinessMessage('220'));//统计截止日期必须晚于买入日期！
					return false;		    
				}
			}
			
			if(typeof(sSaleDate) != "undefined" && sSaleDate != "" )
			{
				if(sSaleDate <= sPurchaseDate)
				{
					alert(getBusinessMessage('219'));//卖出日期必须晚于买入日期！
					return false;
				}
				
			}
		}
		return true;
	}	
	
	/*~[Describe=规则校验;InputParam=无;OutPutParam=无;]~*/
	function checkRules()
	{
		sBeginDate = getItemValue(0,getRow(),"PURCHASEDATE");//买入日期			
		sEndDate = getItemValue(0,getRow(),"SALEDATE");//卖出日期
		
		if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
		{
			if(typeof(sEndDate)!="undefined" && sEndDate.length > 0)
			{
				if(sEndDate <= sBeginDate)
				{		    
					alert("卖出日期必须大于买入日期，请核对！");
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
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_REALTY";//表名
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
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
