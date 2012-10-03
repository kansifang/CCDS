<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2004-12-24
		Tester:
		Describe: 受理机关详细信息
		Input Param:
			CustomerID：当前客户编号
			SerialNo:	流水号
		Output Param:
			CustomerID：当前客户编号

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "受理机关详细信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数

	//获得页面参数	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	   String sHeaders[][] = { 							
				{"AgencyName","受理机关名称"},
				{"DepartType","受理机关类型"},
				{"LaunchDate","开办时间"},
				{"WorkDate","办公时间"},
				{"AgencyTel","联系电话"},
				{"PostNo","邮政编码"},
				{"FaxNo","传真号码"},				
				{"AgencyAdd","地址"},
				{"PrincipalName","负责人姓名"},
				{"UserName","登记人"},
				{"OrgName","登记机构"},				
				{"InputDate","登记日期"},
				{"UpdateDate","更新日期"},
				{"Remark","备注"}								
			}; 
	
	String sSql;
	sSql = 	" select SerialNo,AgencyName,AgencyType,DepartType,"+
		   	" LaunchDate,WorkDate, "+		   
		   	" AgencyTel,PostNo,FaxNo,AgencyAdd,PrincipalName,Remark,"+
		   	" InputUserID,getUserName(InputUserID) as UserName," +		
		   	" InputOrgID,getOrgName(InputOrgID) as OrgName," +	  		  
		   	" InputDate,UpdateDate" +
		   	" from  AGENCY_INFO " +
	       	" where SerialNo='"+sSerialNo+"'";
	       
	//out.println(sSql);
	
	//利用Sql生成窗体对象
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "AGENCY_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("SerialNo,InputUserID,InputOrgID,AgencyType",false);	
	
	
	//下拉框从代码中取得值
	doTemp.setDDDWCode("AgencyType","AgencyType1");
	doTemp.setDDDWCode("DepartType","DepartType");
	
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);
	
	//doTemp.setHTMLStyle("Remark"," style={height:150px;width:400px};overflow:scroll ");
	//doTemp.setHTMLStyle("BusinessBound"," style={height:150px;width:400px};overflow:scroll ");
	
	//设置长度
	doTemp.setLimit("Remark",100);
	doTemp.setLimit("AgencyName,FaxNo,AgencyAdd",80);
	doTemp.setLimit("AgencyTel,PrincipalName",32);
	doTemp.setLimit("PostNo",6);
	
	//设置编辑形式如大文本框
	
	doTemp.setEditStyle("Remark","3");
	
	doTemp.setHTMLStyle("InputDate,WorkDate,UpdateDate,OrgName,UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("AgencyAdd"," style={width:300px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	doTemp.setRequired("AgencyName,DepartType,AgencyTel,PrincipalName",true);
	
	doTemp.setCheckFormat("LaunchDate,WorkDate","3");
	
	
	//设置可更新字段
	doTemp.setUpdateable("OrgName,UserName",false);

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
		var sLaunchDate= getItemValue(0,0,"LaunchDate");
		var sWorkDate= getItemValue(0,0,"WorkDate");
		if(typeof(sLaunchDate) != "undefined" && sLaunchDate != "" && typeof(sWorkDate) != "undefined" && sWorkDate != "")
		{
			if (sLaunchDate > sWorkDate) 
			{
				alert("开办时间应小于等于办公时间！");
				return;
			}
		}
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
		OpenPage("/RecoveryManage/Public/CourtList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/Public/AgencyInfo.jsp","_self","");
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


	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"AgencyType","01");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "AGENCY_INFO";//表名
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
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
