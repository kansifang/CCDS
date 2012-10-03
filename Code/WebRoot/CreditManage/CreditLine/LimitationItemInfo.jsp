<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:byhu 2005/07/27
		Tester:
		Content: 限制项信息
		Input Param:
			SubLineID：额度分配编号
			LimitationSetID：限制条件组编号
			LimitationID：限制条件编号
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	//获得页面参数	
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	String sLimitationSetID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LimitationSetID"));
	String sLimitationID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LimitationID"));
	
	//获取限制条件组的对象类型
	sSql =  " select CLT.ObjectType "+
			" from CL_LIMITATION_TYPE CLT,CL_LIMITATION_SET CLS "+
			" where CLS.LimitationType = CLT.TypeID "+
			" and CLS.LimitationSetID = '"+sLimitationSetID+"' ";	
	String sLimObjectType = Sqlca.getString(sSql);
	if(sLimObjectType == null) sLimObjectType = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过显示模版产生ASDataObject对象doTemp
	String[][] sHeaders = {
							{"LimitationID","限制项ID"},
							{"LimObjectType","限制对象类型"},
							{"LimObjectNo","限制对象编号"},
							{"LimObjectName","限制对象"},
							{"LineSum1","授信限额"},
							{"LineSum2","敞口限额"},
						};

	sSql =  " select LineID,LimitationSetID,LimitationID,LimObjectType, "+
			" LimObjectNo,LimObjectName,LineSum1,LineSum2,InputUser, "+
			" InputOrg,InputTime,UpdateTime "+
			" from CL_LIMITATION "+
			" where LineID = '"+sSubLineID+"' "+
			" and LimitationSetID = '"+sLimitationSetID+"' "+
			" and LimitationID = '"+sLimitationID+"' ";	
		
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_LIMITATION";
	doTemp.setVisible("LineID,LimitationSetID,LimitationID,LimObjectType,LimObjectNo,InputUser,InputOrg,InputTime,UpdateTime",false);
	//根据限制对象的不同定义不同的选择内容		
	if(sLimObjectType.equals("CurrencySet"))//选择币种组
	{
		doTemp.setUnit("LimObjectName","<input type=button value=... class=inputDate onClick=parent.selectCurrencySet()");
	}
	if(sLimObjectType.equals("Currency"))//选择币种
	{
		doTemp.setUnit("LimObjectName","<input type=button value=... class=inputDate onClick=parent.selectCodeType(\"Currency\")");
	}
	if(sLimObjectType.equals("VouchTypeSet"))//选择担保方式组
	{
		doTemp.setUnit("LimObjectName","<input type=button value=... class=inputDate onClick=parent.selectVouchTypeSet()");
	}
	if(sLimObjectType.equals("VouchType"))//选择担保方式
	{
		doTemp.setUnit("LimObjectName","<input type=button value=... class=inputDate onClick=parent.selectCodeType(\"VouchType\")");
	}
	
	doTemp.setUnit("LineSum1,LineSum2","元");
	doTemp.setType("LineSum1,LineSum2","Number");
	doTemp.setRequired("LimObjectName",true);
	doTemp.setHeader(sHeaders);
	doTemp.setReadOnly("LimObjectName",true);
	
	//设置授信限额范围
	doTemp.appendHTMLStyle("LineSum1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"授信限额必须大于等于0！\" ");
	//设置敞口限额范围
	doTemp.appendHTMLStyle("LineSum2"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"敞口限额必须大于等于0！\" ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","确定","保存并返回","saveAndGoBack()",sResourcesPath},
		{"true","","Button","取消","取消并关闭窗口","goBack()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
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
	function saveAndGoBack()
	{
		saveRecord("goBack()");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		top.close();
	}

	/*~[Describe=保存并新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function saveAndNew()
	{
		saveRecord("newRecord()");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sCurDate = PopPage("/Common/ToolsB/GetDay.jsp","","");		
		setItemValue(0,0,"UpdateTime",sCurDate);
	}
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{			
		return true;
	}
			
	/*~[Describe=弹出币种组限制对象选择窗口，并将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCurrencySet()
	{
		setObjectValue("SelectCurrencySet","","@LimObjectNo@0@LimObjectName@1",0,0,"");
	}
	
	/*~[Describe=弹出担保方式组限制对象选择窗口，并将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectVouchTypeSet()
	{
		setObjectValue("SelectVouchTypeSet","","@LimObjectNo@0@LimObjectName@1",0,0,"");
	}
		
	/*~[Describe=选择币种限制/担保方式限制;InputParam=无;OutPutParam=无;]~*/
	function selectCodeType(sCodeNo) {
		sParaString = "CodeNo"+","+	sCodeNo;	
		setObjectValue("SelectCode",sParaString,"@LimObjectNo@0@LimObjectName@1",0,0,"");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录			
			sCurDate = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"LineID","<%=sSubLineID%>");
			setItemValue(0,0,"LimitationSetID","<%=sLimitationSetID%>");
			setItemValue(0,0,"LimObjectType","<%=sLimObjectType%>");
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputTime",sCurDate);
			setItemValue(0,0,"UpdateTime",sCurDate);
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "CL_LIMITATION";//表名
		var sColumnName = "LimitationID";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
			
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
