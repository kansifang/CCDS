<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --cwliu 2004-11-29
		Tester:
		Describe:  --项目投入产出概算
		Input Param:
			ProjectNo：--当前项目编号
		Output Param:
			ProjectNo：--当前项目编号
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "项目投入产出概算"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "",sProjectType = "";//--存放sql语句、项目类型
	
	//获得组件参数,当前项目编号

	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	//获得项目类型
	sSql = " select ProjectType  from PROJECT_INFO where ProjectNo='"+sProjectNo+"' ";
	sProjectType = Sqlca.getString(sSql); 
	if(sProjectType == null ) sProjectType = "";
	//获得页面参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "";
	if(sProjectType.equals("02"))
		sTempletNo = "HouseProjectBudgetInfo";
	else
		sTempletNo = "FixProjectBudgetInfo";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");		
	if(sProjectType.equals("02"))
	{

		//设置土地费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土地费（万元）必须大于等于0！\" ");
		//设置前期工程费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM2"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"前期工程费（万元）必须大于等于0！\" ");
		//设置土建工程开发费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM3"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土建工程开发费（万元）必须大于等于0！\" ");
		//设置建筑安装工程开发费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM4"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑安装工程开发费（万元）必须大于等于0！\" ");
		//设置附属工程开发费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM5"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"附属工程开发费（万元）必须大于等于0！\" ");
		//设置管理费用（万元）范围
		doTemp.appendHTMLStyle("EXESSUM6"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"管理费用（万元）必须大于等于0！\" ");
		//设置财务费用（万元）范围
		doTemp.appendHTMLStyle("EXESSUM7"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"财务费用（万元）必须大于等于0！\" ");
		//设置销售费用（万元）范围
		doTemp.appendHTMLStyle("EXESSUM8"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"销售费用（万元）必须大于等于0！\" ");
		//设置税费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM9"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"税费（万元）必须大于等于0！\" ");
		//设置不可预见费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM10"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"不可预见费（万元）必须大于等于0！\" ");
		//设置涨价预备费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM11"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"涨价预备费（万元）必须大于等于0！\" ");
		//设置其他费用（万元）范围
		doTemp.appendHTMLStyle("EXESSUM12"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"其他费用（万元）必须大于等于0！\" ");
		//设置费用金额13范围
		doTemp.appendHTMLStyle("EXESSUM13"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"费用金额13必须大于等于0！\" ");
		//设置费用金额14范围
		doTemp.appendHTMLStyle("EXESSUM14"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"费用金额14必须大于等于0！\" ");
		//设置住宅销售均价（元每平方米）范围
		doTemp.appendHTMLStyle("EXESSUM16"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"住宅销售均价（元每平方米）必须大于等于0！\" ");
		//设置住宅销售合计（万元）范围
		doTemp.appendHTMLStyle("EXESSUM17"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"住宅销售合计（万元）必须大于等于0！\" ");
		//设置商铺销售均价（元每平方米）范围
		doTemp.appendHTMLStyle("EXESSUM18"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"商铺销售均价（元每平方米）必须大于等于0！\" ");
		//设置商铺销售合计（万元）范围
		doTemp.appendHTMLStyle("EXESSUM19"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"商铺销售合计（万元）必须大于等于0！\" ");
		//设置写字间销售均价（元每平方米）范围
		doTemp.appendHTMLStyle("EXESSUM20"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"写字间销售均价（元每平方米）必须大于等于0！\" ");
		//设置写字间销售合计（万元）范围
		doTemp.appendHTMLStyle("EXESSUM21"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"写字间销售合计（万元）必须大于等于0！\" ");
		//设置车库销售均价（元每平方米）范围
		doTemp.appendHTMLStyle("EXESSUM22"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"车库销售均价（元每平方米）必须大于等于0！\" ");
		//设置车库销售合计（万元）范围
		doTemp.appendHTMLStyle("EXESSUM23"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"车库销售合计（万元）必须大于等于0！\" ");
		//设置土地销售均价（元每平方米）范围
		doTemp.appendHTMLStyle("EXESSUM24"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土地销售均价（元每平方米）必须大于等于0！\" ");
		//设置土地销售收入合计（万元）范围
		doTemp.appendHTMLStyle("EXESSUM25"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土地销售收入合计（万元）必须大于等于0！\" ");
		//设置其他收入（万元）范围
		doTemp.appendHTMLStyle("EXESSUM26"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"其他收入（万元）必须大于等于0！\" ");
		//设置投资回收期（月）范围
		doTemp.appendHTMLStyle("REDOUNDTERM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"投资回收期（月）必须大于等于0！\" ");
		//设置贷款回收期（月）范围
		doTemp.appendHTMLStyle("LOANTERM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款回收期（月）必须大于等于0！\" ");
	}else
	{
		//设置土地费用（万元）范围
		doTemp.appendHTMLStyle("EXESSUM1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土地费用（万元）必须大于等于0！\" ");
		//设置工程费用（万元）范围
		doTemp.appendHTMLStyle("EXESSUM2"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"工程费用（万元）必须大于等于0！\" ");
		//设置设备费用（万元）范围
		doTemp.appendHTMLStyle("EXESSUM3"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"设备费用（万元）必须大于等于0！\" ");
		//设置固定资产投资方向调节税（万元）范围
		doTemp.appendHTMLStyle("EXESSUM4"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"固定资产投资方向调节税（万元）必须大于等于0！\" ");
		//设置建设期利息（万元）范围
		doTemp.appendHTMLStyle("EXESSUM5"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建设期利息（万元）必须大于等于0！\" ");
		//设置流动资金（万元）范围
		doTemp.appendHTMLStyle("EXESSUM6"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"流动资金（万元）必须大于等于0！\" ");
		//设置其它费用（万元）范围
		doTemp.appendHTMLStyle("EXESSUM7"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"其它费用（万元）必须大于等于0！\" ");
		//设置销售费用（万元）范围
		doTemp.appendHTMLStyle("EXESSUM8"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"销售费用（万元）必须大于等于0！\" ");
		//设置税费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM9"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"税费（万元）必须大于等于0！\" ");
		//设置不可预见费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM10"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"不可预见费（万元）必须大于等于0！\" ");
		//设置涨价预备费（万元）范围
		doTemp.appendHTMLStyle("EXESSUM11"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"涨价预备费（万元）必须大于等于0！\" ");
		//设置其他费用（万元）范围
		doTemp.appendHTMLStyle("EXESSUM12"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"其他费用（万元）必须大于等于0！\" ");
		//设置费用金额13范围
		doTemp.appendHTMLStyle("EXESSUM13"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"费用金额13必须大于等于0！\" ");
		//设置费用金额14范围
		doTemp.appendHTMLStyle("EXESSUM14"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"费用金额14必须大于等于0！\" ");
		//设置住宅销售均价（元每平方米）范围
		doTemp.appendHTMLStyle("EXESSUM16"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"住宅销售均价（元每平方米）必须大于等于0！\" ");
		//设置住宅销售合计（万元）范围
		doTemp.appendHTMLStyle("EXESSUM17"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"住宅销售合计（万元）必须大于等于0！\" ");
		//设置商铺销售均价（元每平方米）范围
		doTemp.appendHTMLStyle("EXESSUM18"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"商铺销售均价（元每平方米）必须大于等于0！\" ");
		//设置商铺销售合计（万元）范围
		doTemp.appendHTMLStyle("EXESSUM19"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"商铺销售合计（万元）必须大于等于0！\" ");
		//设置写字间销售均价（元每平方米）范围
		doTemp.appendHTMLStyle("EXESSUM20"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"写字间销售均价（元每平方米）必须大于等于0！\" ");
		//设置写字间销售合计（万元）范围
		doTemp.appendHTMLStyle("EXESSUM21"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"写字间销售合计（万元）必须大于等于0！\" ");
		//设置车库销售均价（元每平方米）范围
		doTemp.appendHTMLStyle("EXESSUM22"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"车库销售均价（元每平方米）必须大于等于0！\" ");
		//设置车库销售合计（万元）范围
		doTemp.appendHTMLStyle("EXESSUM23"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"车库销售合计（万元）必须大于等于0！\" ");
		//设置土地销售均价（元每平方米）范围
		doTemp.appendHTMLStyle("EXESSUM24"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土地销售均价（元每平方米）必须大于等于0！\" ");
		//设置土地销售收入合计（万元）范围
		doTemp.appendHTMLStyle("EXESSUM25"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"土地销售收入合计（万元）必须大于等于0！\" ");
		//设置其他收入（万元）范围
		doTemp.appendHTMLStyle("EXESSUM26"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"其他收入（万元）必须大于等于0！\" ");
		//设置投资回收期（月）范围
		doTemp.appendHTMLStyle("REDOUNDTERM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"投资回收期（月）必须大于等于0！\" ");
		//设置贷款回收期（月）范围
		doTemp.appendHTMLStyle("LOANTERM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款回收期（月）必须大于等于0！\" ");
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo+","+sSerialNo);
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
		{"fasle","","Button","返回","返回列表页面","goBack()",sResourcesPath}
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
		OpenPage("/CustomerManage/EntManage/ProjectFundsList.jsp","_self","");
	}
	
	/*~[Describe=合计费用;InputParam=无;OutPutParam=无;]~*/
	function getSum(iStart,iEnd,iDes)
	{		
		var Sum=0;
		if(iStart == '16' && iEnd == '26' && iDes == '27')//合计（万元）
		{
			for(var i=iStart+1;i<iEnd+1;i=i+2)
			{
			//alert(getItemValue(0,getRow(),"EXESSUM"+i));
			if(typeof(getItemValue(0,getRow(),"EXESSUM"+i))=="undefined" || getItemValue(0,getRow(),"EXESSUM"+i).length==0)
				continue;
			else
			Sum+=getItemValue(0,getRow(),"EXESSUM"+i);
			}
			
		}else//总计(万元)
		{
			for(var i=iStart;i<iEnd+1;i=i+1)
			{
			//alert(getItemValue(0,getRow(),"EXESSUM"+i));
			if(typeof(getItemValue(0,getRow(),"EXESSUM"+i))=="undefined" || getItemValue(0,getRow(),"EXESSUM"+i).length==0)
				continue;
			else
			Sum+=getItemValue(0,getRow(),"EXESSUM"+i);
			}
		}
		//项目资本金比例（％）
		setItemValue(0,getRow(),"EXESSUM"+iDes,Sum);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{			
		return true;
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"PROJECTNO","<%=sProjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "PROJECT_BUDGET";//表名
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
