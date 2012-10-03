<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/01
		Tester:
		Describe: 	农户特色信息
		Input Param:
			--CustomerID：当前客户编号
			--EditRight:权限代码（01：查看权；02：维护权）
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "农户特色信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "FarmerTraitInfo";
	//获得组件参数，客户代码
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//获得页面参数	,流水号
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sEditRight == null) sEditRight = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//设置月收入(元)范围
	//doTemp.appendHTMLStyle("MONTHLYWAGES"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"月收入(元)必须大于等于0！\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //--设置DW风格 1:Grid 2:Freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath}
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
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
	
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		//1：校验 若户籍类型选择为"农户"，则为必输项
		sIndRPRType = getItemValue(0,getRow(),"IndRPRType");//户籍类型
		sVillageCode = getItemValue(0,getRow(),"VillageCode");//农户所在地
		if(sIndRPRType == '010')
		{
			if (typeof(sVillageCode) == "undefined" || sVillageCode == "" )
			{
				alert("当户籍类型选择为农户时,农户所在地不能为空!"); 
				return false;	
			}
		}
		
		//2:校验 评为信用户时间及信用证发证日期不应晚于当前日期
		sFCreditedDate = getItemValue(0,getRow(),"FCreditedDate");
		sFLoanDate = getItemValue(0,getRow(),"FLoanDate");
		sToDay = "<%=StringFunction.getToday()%>";
		if(sFCreditedDate>sToDay){
			alert("评为信用户时间不能晚于当前日期!");
			return false;
		}
		if(sFLoanDate>sToDay){
			alert("信用证发证日期不应晚于当前日期!");
			return false;
		}
		return true;
	}
	
	/*~[Describe=弹出省份、直辖市、自治区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getVillageCode(flag)
	{
		var sVillageCode = getItemValue(0,getRow(),"VillageCode");
		//由于乡村有几百项，分两步显示
		sVillageInfo = PopComp("VillageVFrame","/Common/ToolsA/VillageVFrame.jsp","Village="+sVillageCode,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		if(sVillageInfo == "NO")
		{
			setItemValue(0,getRow(),"VillageCode","");
			setItemValue(0,getRow(),"VillageName","");
		}else if(typeof(sVillageInfo) != "undefined" && sVillageInfo != "")
		{
			sVillageInfo = sVillageInfo.split('@');
			sVillageCode = sVillageInfo[0];//-- 县乡村代码
			sVillageName = sVillageInfo[1];//--县乡村名称
			setItemValue(0,getRow(),"VillageCode",sVillageCode);
			setItemValue(0,getRow(),"VillageName",sVillageName);					
		}
	}	
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
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
