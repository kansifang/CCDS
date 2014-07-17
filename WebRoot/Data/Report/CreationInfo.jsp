<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: 创建授信额度申请
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
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号、发生方式、发生日期
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type")));
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	//定义变量：SQL语句
	String sSql = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String[][] sHeaders = {
							{"ReportConfigNo","查询类型"},							
							{"OneKey","报表日期"},
							{"EDocNo","报告模板"}
						  };
	sSql = 	" select SerialNo,ReportConfigNo,OneKey,Type,EDocNo"+	
			" from Batch_Report where 1 = 2 ";	
	//通过SQL产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//设置标题
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="Batch_Report";
	doTemp.setKey("SerialNo",true);
	//设置必输项
	doTemp.setRequired("ReportConfigNo,OneKey",true);
	//设置下拉框选择内容
	doTemp.setDDDWSql("ReportConfigNo", "select DocNo,DocTitle from Doc_Library where DocNo like 'QDT%'");
	doTemp.setDDDWSql("EDocNo", "select EDocNo,EDocName from EDoc_Define");
	//设置必输背景色
	doTemp.setHTMLStyle("OccurType,OccurDate","style={background=\"#EEEEff\"} ");
	//设置日期格式
	doTemp.setCheckFormat("OneKey","6");	
	//注意,先设HTMLStyle，再设ReadOnly，否则ReadOnly不会变灰
	doTemp.setHTMLStyle("InputDate"," style={width:80px}");
	doTemp.setReadOnly("InputOrgName,InputUserName,InputDate",true);
	doTemp.setVisible("SerialNo,Type", false);
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
		{"true","","Button","下一步","新增授信额度申请的下一步","saveRecord('doReturn()')",sResourcesPath},
		{"true","","Button","取消","取消新增授信额度申请","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
		/*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
		function doCancel(){		
			top.returnValue = "_CANCEL_";
			top.close();
		}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>	
	var bIsInsert = false; //标记DW是否处于“新增状态”
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
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
		
	}
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录	
			bIsInsert = true;

			setItemValue(0,0,"ReportConfigNo","b20140519000001");
			setItemValue(0,0,"OneKey","<%=DateUtils.getRelativeMonth(DateUtils.getToday(),0,0)%>");
			setItemValue(0,0,"Type","<%=sType%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");	
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");	
			setItemValue(0,0,"InputDate","<%=DateUtils.getToday()%>");			
		}
    }
	/*~[Describe=确认新增;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		var sSerialNo= getItemValue(0,0,"SerialNo");
		var sConfigNo= getItemValue(0,0,"ReportConfigNo");		
		var sKey = getItemValue(0,0,"OneKey");		
		self.returnValue = sSerialNo+"@"+sConfigNo+"@"+sKey;
		self.close();
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo()
	{
		var sTableName = "Batch_Report";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		//使用GetSerialNo.jsp来抢占一个流水号
		var sCodeNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sCodeNo);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();	
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化	
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>