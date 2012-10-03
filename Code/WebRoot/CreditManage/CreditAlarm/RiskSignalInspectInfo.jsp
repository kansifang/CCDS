<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei 2006/03/27
		Tester:
		Content: 预警信号检查报告信息_info
		Input Param:
			  ObjectType:对象类型
			  ObjectNo：对象编号   
		Output param:
		       
		History Log: 
		       
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警信号检查报告信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	//获得组件参数

	//获得页面参数	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sEditRight =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sEditRight == null) sEditRight = "02";
	//	获取预警信号检查报告流水号
	String sSerialNo = Sqlca.getString("select SerialNo from INSPECT_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"'");
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%		
	String[][] sHeaders = {
							{"Opinion1","业务"},
							{"Opinion2","现状/问题"},
							{"Opinion3","紧急行动结果"},
							{"Opinion4","处理结果"},							
							{"Remark","备注"},
							{"InspectOrgName","检查机构"},
							{"InspectUserName","检查人"},
							{"InspectDate","检查时间"},
							{"UpdateDate","更新时间"}
						};
		
	sSql =  " select SerialNo,ObjectType,ObjectNo,InspectType,UptoDate, "+
			" Opinion1,Opinion2,Opinion3,Opinion4,Remark,InspectOrgID, "+
			" getOrgName(InspectOrgID) as InspectOrgName,InspectUserID, "+
			" getUserName(InspectUserID) as InspectUserName,InspectDate, "+
			" InputOrgID,InputUserID,InputDate,FinishDate "+
			" from INSPECT_INFO "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' ";
			
	//通过SQL语句产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="INSPECT_INFO";
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);

	//设置只读属性
	doTemp.setReadOnly("Opinion1,Opinion2,Opinion3,Opinion4,Remark,InspectOrgName,InspectUserName,InspectDate",true);
	//if(sSerialNo.equals(""))doTemp.setReadOnly("Opinion1,Opinion2,Opinion3,Opinion4,Remark",false);
	if(sEditRight.equals("01"))doTemp.setReadOnly("Opinion1,Opinion2,Opinion3,Opinion4,Remark",false);
	//设置必输属性
	doTemp.setRequired("Opinion1,Opinion2",true);
	//设置不可见属性
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,InspectType,UptoDate,InspectOrgID",false);
	doTemp.setVisible("InspectUserID,InputOrgID,InputUserID,InputDate,FinishDate",false);
	//设置不可更新
	doTemp.setUpdateable("InspectOrgName,InspectUserName",false);
	//设置格式
	doTemp.setHTMLStyle("InspectOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("InspectUserName,InspectDate,UpdateDate"," style={width:80px;} ");
	doTemp.setHTMLStyle("Opinion1,Opinion2,Opinion3,Opinion4,Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Opinion1,Opinion2,Opinion3,Opinion4,Remark",100);
 	doTemp.setEditStyle("Opinion1,Opinion2,Opinion3,Opinion4,Remark","3");
 	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//获取检查截止日期
	String sUpToDate = Sqlca.getString("select NextCheckDate from RISKSIGNAL_OPINION where SerialNo = '"+sObjectNo+"'");
	if(sUpToDate == null) sUpToDate = "";
	
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
			{(sEditRight.equals("01")?"true":"false"),"","Button","保存","保存预警检查报告的信息","saveRecord()",sResourcesPath},		
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
		if("<%=CurComp.ID%>"=="RiskSignalReport")
		{
			self.close();
		}
		else if("<%=CurComp.ID%>"=="RiskSignalCheckList")
		{
			OpenPage("/CreditManage/CreditAlarm/RiskSignalCheckList.jsp","_self","");
		}
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段				
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
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InspectType","05");  //01：首次检查；02：定期检查；03：不定期检查；04：专项检查；05：预警信号检查
			setItemValue(0,0,"UptoDate","<%=sUpToDate%>");			
			setItemValue(0,0,"InspectUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InspectUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InspectOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InspectOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");			
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InspectDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}		
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "INSPECT_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "AL";//前缀

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
