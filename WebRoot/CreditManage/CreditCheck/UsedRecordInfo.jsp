<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 新增提款记录;
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "用款记录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得组件参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sItemNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sHeaders[][] = { {"AccountNo","客户账号"},
							{"Currency","币种"}, 
							{"ItemName","对方用户名"},
							{"ItemAccountNo","对方账号"},
							{"ItemDate","交易日期"},
							{"ItemSum","交易金额"},
							{"Balance","帐户余额"}, 
							{"ItemDescribe","摘要代码"},
							{"ItemContent","凭证号"}
						  };
	String sSql="select SerialNo,ItemNo,ObjectType,objectno,ItemType,AccountNo,Currency,ItemName,ItemAccountNO,"+
	            " ItemDate,ItemSum,Balance,ItemDescribe,ItemContent  "+
	            " from INSPECT_DETAIL where SerialNo='"+sSerialNo+
	            "' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' and ItemNo='"+sItemNo+"'";
    //sql生成doTemp对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置关键字
	doTemp.setKey("SerialNo,ItemNo,ObjectType,objectno",true);
	//设置可更新的表
	doTemp.UpdateTable = "INSPECT_DETAIL";
	
	doTemp.setType("ItemSum,Balance","Number");//设置列类型
	doTemp.setCheckFormat("ItemSum,Balance","2");//设置输入格式，带逗号的钱数d
	doTemp.setAlign("ItemSum,Balance","3");
	doTemp.setCheckFormat("ItemDate","3");//设置输入格式，日期选择按钮
	doTemp.setVisible("SerialNo,ItemNo,ObjectType,objectno,ItemType",false);
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setDefaultValue("Currency","01");
	doTemp.setDefaultValue("ItemDate",StringFunction.getToday());
	doTemp.setRequired("AccountNo,Currency,ItemName,ItemAccountNo,ItemDate,ItemSum",true);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
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
		{"true","","Button","保存并返回","保存提款记录并返回","saveRecord()",sResourcesPath}
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
		initSerialNo();//初始化流水号字段
		as_save("myiframe0","goBack()");
	}
	function goBack()
	{
		OpenPage("/CreditManage/CreditCheck/UsedRecordList.jsp?SerialNo=<%=sSerialNo%>&rand="+randomNumber(),"_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ItemType","02");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"objectno","<%=sObjectNo%>");
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");

		}
    }
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "INSPECT_DETAIL";//表名
		var sColumnName = "ItemNo";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntStockInfo.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
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

