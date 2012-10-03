<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-07
		Tester:
		Describe: 业务流水信息;
		Input Param:
			SerialNo:流水号
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = " 业务流水信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";

	//获得组件参数
	
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { {"SerialNo","流水号"},
	                        {"RelativeSerialNo","相关借据流水号"},
                            {"RelativeContractNo","相关合同流水号"},
                            {"TransactionFlag","交易标志"},
                            {"OccurType","发生类型"},
                            {"OccurDirection","发生方向"},
                            {"OccurDate","交易日期"},
                            {"BackType","回收方式"},
                            {"OccurSubject","发生摘要"},
                            {"ActualDebitSum","发放金额(元)"},
                            {"ActualCreditSum","回收金额(元)"},
                            {"OrgName","登记机构"},
                            {"UserName","登记人"},
                          };

		sSql=	" select SerialNo,RelativeContractNo,OccurDate,ActualCreditSum, "+
				" OccurType,TransactionFlag,OccurDirection,OccurSubject,BackType,OrgID,"+
				" getOrgName(OrgID) as OrgName,UserID,getUserName(UserID) as UserName "+
				" from BUSINESS_WASTEBOOK where SerialNo='"+sSerialNo+"'";
	//通过sql定义数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置可更新的表
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK";
	//设置关键字
	doTemp.setKey("SerialNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置只读选项
	doTemp.setReadOnly("SerialNo,RelativeContractNo,OrgID,UserID,OrgName,UserName",true);
	//设置不可见项
	doTemp.setVisible("OrgID,UserID",false);
	//设置不可更新字段
	doTemp.setUpdateable("OrgName,UserName",false);
	//设置必输项
	doTemp.setRequired("RelativeSerialNo,RelativeContractNo,OccurDate,ActualCreditSum,ActualDebitSum,OccurDirection,OccurType,TransactionFlag,OccurSubject,BackType",true);
	//设置下拉选项
	doTemp.setDDDWCode("OccurSubject","OccurSubjectName1");
	doTemp.setDDDWCode("OccurType","WasteOccurType");
	doTemp.setDDDWCode("OccurDirection","OccurDirection");
	doTemp.setDDDWCode("TransactionFlag","TransactionFlag");
	doTemp.setDDDWCode("BackType","ReclaimType");
	doTemp.setCheckFormat("OccurDate","3");
    doTemp.setType("ActualCreditSum,ActualDebitSum","Number");
	doTemp.setCheckFormat("ActualCreditSum,ActualDebitSum","2");
	doTemp.setAlign("ActualCreditSum,ActualDebitSum","3");
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform


	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
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
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};

	//假如为回收且数据来源不是628
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/InfoManage/QuickSearch/BusinessSerialInfoList.jsp","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	function beforeInsert()
	{		
		initSerialNo();//初始化流水号字段
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_WASTEBOOK";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"OccurDirection","1");
			setItemValue(0,0,"RelativeContractNo","<%=sObjectNo%>");
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
		}
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

