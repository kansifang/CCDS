<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2006-8-18
		Tester:
		Describe: 抵质押物入库/出库信息详情;
		Input Param:
			SerialNo：流水号				
			GuarantyID：抵质押物编号
			GuarantyStatus：抵质押物状态
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵质押物入库/出库基本信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量	
	String sSql = "";//Sql语句
	ASResultSet rs = null;//结果集
	String sGuarantyName = "";//抵质押物名称
	String sGuarantyType = "";//抵质押物类型
	
	//获得组件参数：抵质押物编号、抵质押物状态
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));
	String sGuarantyStatus  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyStatus"));
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	//将空值转化为空字符串
	if(sGuarantyID == null) sGuarantyID = "";
	if(sGuarantyStatus == null) sGuarantyStatus = "";
	if(sSerialNo == null) sSerialNo = "";

			
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%		        
	//根据抵质押物编号取得抵质押物名称和抵质押物类型
	sSql = 	" select GuarantyName,GuarantyType from GUARANTY_INFO "+
		 	" where GuarantyID = '"+sGuarantyID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sGuarantyName = rs.getString("GuarantyName");
		sGuarantyType = rs.getString("GuarantyType");
		//将空值转化为空字符串
		if(sGuarantyName == null) sGuarantyName = "";
		if(sGuarantyType == null) sGuarantyType = "";
	}
	rs.getStatement().close();
	
	
	//显示标题	
	String[][] sHeaders = {
							{"GuarantyID","抵质押物编号"},							
							{"GuarantyName","抵质押物名称"},
							{"GuarantyType","抵质押物类型"},
							{"GuarantyStatus","抵质押物状态"},	
							{"LostDate","出库日期"},
							{"Reason","出库原因"},							
							{"PlanReturnDate","预计回库日期"},
							{"FactReturnDate","实际回库日期"},
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"}
						  };
	
	sSql = 	" select SerialNo,GuarantyID,GuarantyName,GuarantyType, "+		
			" GuarantyStatus,LostDate,Reason,PlanReturnDate,FactReturnDate, "+
			" InputOrg,getOrgName(InputOrg) as InputOrgName,InputUser, "+	
			" getUserName(InputUser) as InputUserName,InputDate,UpdateDate "+		
			" from GUARANTY_AUDIT "+
			" where SerialNo = '"+sSerialNo+"' ";
			
	//通过Sql产生ASDataObject对象doTemp	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_AUDIT";
	doTemp.setKey("SerialNo",true);
	
	//设置下拉框
	doTemp.setDDDWCode("GuarantyType","GuarantyList");
	doTemp.setDDDWCode("GuarantyStatus","GuarantyStatus");
	//设置不可更新
	doTemp.setUpdateable("InputOrgName,InputUserName",false);	
	//设置格式
	doTemp.setEditStyle("Reason","3");	
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("GuarantyName","  style={width:200px}  ");
	doTemp.setHTMLStyle("GuarantyStatus","  style={width:50px}  ");
	doTemp.setHTMLStyle("Reason","  style={height:150px;width:400px}  ");
	doTemp.setLimit("Reason",200);
	doTemp.setCheckFormat("LostDate,PlanReturnDate,FactReturnDate","3");
	//设置字段不可见属性
	doTemp.setVisible("SerialNo,InputOrg,InputUser",false);
	
	if(sGuarantyStatus.equals("03")) //临时出库
	{
		//设置必输项
		doTemp.setRequired("LostDate,Reason,PlanReturnDate",true);
		//设置只读
		doTemp.setReadOnly("GuarantyID,GuarantyNamem,GuarantyType,GuarantyStatus,InputOrgName,InputUserName,InputDate,UpdateDate",true);
		//设置字段不可见属性
		doTemp.setVisible("FactReturnDate",false);
	}else if(sGuarantyStatus.equals("01")) //再回库
	{
		//设置必输项
		doTemp.setRequired("FactReturnDate",true);
		//设置只读
		doTemp.setReadOnly("GuarantyID,GuarantyNamem,GuarantyType,GuarantyStatus,LostDate,Reason,PlanReturnDate,InputOrgName,InputUserName,InputDate,UpdateDate",true);
		//设置担保状态为已入库
		sGuarantyStatus="02";

	}
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	if(sGuarantyStatus.equals("00")) //仅查看信息
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	else
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//定义后续事件
	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateGuarantyStatus(#GuarantyID,"+sGuarantyStatus+")");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateGuarantyStatus(#GuarantyID,"+sGuarantyStatus+")");
			
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGuarantyID);
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
		{(!sGuarantyStatus.equals("00")?"true":"false"),"","Button","临时出库","保存所有修改","saveRecord('self.close();')",sResourcesPath},
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
		if (!checkDate()) return;
			if(confirm("确定要将该物品临时出库吗？"))
			{
				if(bIsInsert){		
					beforeInsert();
				}
	
				beforeUpdate();
				as_save("myiframe0",sPostEvents);
				
			}	
			alert("质押物临时出库成功！");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		if(<%=sGuarantyStatus%> != "00")
		{
			self.close();
		}else{
			OpenPage("/CreditManage/GuarantyManage/GuarantyAuditList.jsp","_self","");
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
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"GuarantyID","<%=sGuarantyID%>");
			setItemValue(0,0,"GuarantyName","<%=sGuarantyName%>");
			setItemValue(0,0,"GuarantyType","<%=sGuarantyType%>");			
			setItemValue(0,0,"GuarantyStatus","<%=sGuarantyStatus%>");
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");			
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;			
		}
		
    }
    //出库日期应该小于等于预计回库日期 
    function checkDate(){
    	var sLostDate= getItemValue(0,getRow(),"LostDate"); 
    	var sPlanReturnDate = getItemValue(0,getRow(),"PlanReturnDate");
    	if(sLostDate.length!=0 && typeof(sLostDate)!="undefined"){
			if(sPlanReturnDate!= 0 &&　typeof(sPlanReturnDate)!="undefined"){
				if(sLostDate > sPlanReturnDate){
					alert("其出库日期应该小于等于预计回库日期");
					return false;
				}
			}
		}else{
			alert("出库日期与预计回库日期不能为空！");
			return false;
		}
		return true;
    }
	        
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_AUDIT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		//将流水号置入对应字段
		setItemValue(0,getRow(),"SerialNo",sSerialNo);				
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
