<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: bliu 2004-12-02 
		Tester:
		Describe: 代理人详细信息
		Input Param:
			SerialNo:	流水号
		Output Param:

		HistoryLog:	slliu 2004.12.17
					ndeng 2004.12.23
					zywei 2005/09/07 重检代码
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "代理人"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数

	//获得页面参数	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	  
    String sHeaders[][] = { 							
							{"AgentName","代理人名称"},				
							{"PersonType","代理人类型"},
							{"BelongAgency","所属代理机构"},
							{"SelfOrgName","所属本行代理机构"},					
							{"PractitionerTime","从业时间"},				
							{"CompetenceNo","资格证编号"},
							{"PersistNo","执业证编号"},
							{"Age","年龄"},
							{"Degree","学历"},
							{"Specialty","专长"},
							{"TypicalCase","典型案例"},
							{"RelationMode","联系方式"},
							{"OrgName","曾任职的代理机构"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"},				
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"},
							{"Remark","备注"}								
						}; 
	
	String sSql =  " select SerialNo,AgentName,AgentType,PersonType,BelongAgency,BelongNo,SelfOrgName, "+
				   " PractitionerTime,CompetenceNo,PersistNo,Age,Degree,Specialty,TypicalCase,RelationMode, "+		   	  
				   " OrgName,Remark,InputUserID,getUserName(InputUserID) as InputUserName,InputOrgID, " +   
				   " getOrgName(InputOrgID) as InputOrgName,InputDate,UpdateDate" +
				   " from AGENT_INFO "+
				   " where SerialNo = '"+sSerialNo+"'";
	
	//利用Sql生成窗体对象	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "AGENT_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("SerialNo,BelongNo,InputUserID,InputOrgID,AgentType,SelfOrgName",false);
	//设置整数
	doTemp.setType("Age","Number");
	doTemp.setCheckFormat("Age","5");
	//下拉框从代码中取得值
	doTemp.setDDDWCode("AgentType","AgentType1");
	doTemp.setDDDWCode("PersonType","PersonType1");
	doTemp.appendHTMLStyle("PractitionerTime"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
	doTemp.setUnit("PractitionerTime","月");
	doTemp.setAlign("PractitionerTime","3");
	//选择所属代理机构名称
	doTemp.setUnit("BelongAgency"," <input type=button class=inputDate  value=... name=button onClick=\"javascript:parent.getAgencyName()\">");
	doTemp.appendHTMLStyle("BelongAgency","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getAgencyName()\" ");
	//设置只读属性
	doTemp.setReadOnly("InputOrgName,InputUserName,InputDate,UpdateDate,BelongAgency",true);
	
	//设置长度
	doTemp.setLimit("Remark,RelationMode",200);
	doTemp.setLimit("TypicalCase",100);
	doTemp.setLimit("OrgName",100);
	doTemp.setLimit("CompetenceNo,PersistNo,AgentName",32);
	//设置编辑形式如大文本框
	doTemp.setEditStyle("TypicalCase","3");
	doTemp.setEditStyle("Remark","3");
	doTemp.setEditStyle("OrgName","3");
	
	doTemp.setHTMLStyle("InputDate,UpdateDate,InputOrgName,InputUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("RelationMode,Specialty"," style={width:300px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	doTemp.setRequired("SerialNo,PersonType,AgentName,AgentType",true);
	
	doTemp.setCheckFormat("UpdateDate","3");
	//设置可更新字段
	doTemp.setUpdateable("InputOrgName,InputUserName",false);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
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
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/Public/AgentList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=选择代理机构名称;InputParam=无;OutPutParam=无;]~*/
	function getAgencyName()
	{
		var sParaString = "AgencyType"+","+"02";
		setObjectValue("SelectAgency",sParaString,"@BelongNo@0@BelongAgency@1",0,0,"");	
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
			bIsInsert = true;
			
			setItemValue(0,0,"AgentType","02");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");			
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "AGENT_INFO";//表名
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
