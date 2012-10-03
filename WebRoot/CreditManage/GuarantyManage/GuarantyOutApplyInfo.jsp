<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   wangdw  2012.07.30
		Tester:
		Content: 抵质押品出库_Info
		Input Param:	
		Output param:
		History Log:         
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵质押品出库"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
    ASResultSet rs = null;
	//获得组件参数		
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    String sSignalStatus = "";
	//将空值转化为空字符串	
	if(sSerialNo == null) sSerialNo = "";
	
	

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {	
							{"reason","出库原因"}	,
							{"GUARANTYNAME","抵质押物名称"},
							{"GUARANTYTYPE","抵质押物类型"},
							{"OWNERNAME","权属人名称"},
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记时间"},
							{"UpdateDate","更新时间"}
							};
		
	sSql =  " select GA.SerialNo,GI.OWNERNAME,GI.GUARANTYTYPE,GI.GUARANTYNAME,GA.reason,GetOrgName(GA.InputOrgID) as InputOrgName,GA.InputOrgID,GetUserName(GA.InputUserID) as InputUserName,GA.InputUserID,GA.InputDate,GA.UpdateDate from Guaranty_Apply GA,GUARANTY_INFO GI where GA.Objectno=GI.GUARANTYID "+
			" and SerialNo = '"+sSerialNo+"' ";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="Guaranty_Apply";
	//设置关键字
	doTemp.setKey("SerialNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("ApproveDate,AlarmApplyDate,SerialNo,ObjectType,SignalNo",false);
	
	//设置下拉框内容
	doTemp.setDDDWCode("SignalLevel","SignalLevel");
	
	//设置格式
	doTemp.setDDDWCode("GUARANTYTYPE","GuarantyList");
	doTemp.setEditStyle("reason","3");
	doTemp.setHTMLStyle("reason"," style={height:100px;width:400px};overflow:scroll ");
	doTemp.setLimit("reason",800);
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setEditStyle("MessageContent","3");
	doTemp.setCheckFormat("AlarmApplyDate","3");
	doTemp.setType("CustomerBalance,BailSum,CustomerOpenBalance","Number");
 	doTemp.setLimit("MessageContent",800);
	doTemp.setReadOnly("GUARANTYNAME,GUARANTYTYPE,InputUserName,InputOrgName,InputDate,UpdateDate",true);
 	doTemp.setRequired("MessageContent,SignalLevel,CustomerName,MessageOrigin",true);
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,InputUserID,InputOrgID",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,CustomerName",false);
  	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly="0";
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//获取该批准的预警信息是否已被解除
	String sFreeFlag = "否";
	
	if(sSignalStatus.equals("30")) //批准
	{
		sSql = 	" select Count(SerialNo) from Guaranty_Apply "+
				" where RelativeSerialNo = '"+sSerialNo+"' "+				
				" and SignalStatus = '30' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			int iCount = rs.getInt(1);
			if(iCount > 0) sFreeFlag = "是";
			else sFreeFlag = "否";		
		} 
		rs.getStatement().close();
	}
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
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ObjectType","Customer");	
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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