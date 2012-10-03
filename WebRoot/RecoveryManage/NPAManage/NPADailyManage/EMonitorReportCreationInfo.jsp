<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu  2009.09.21
		Tester:
		Content: 创建重点监控报告
		Input Param:
			ObjectNo：对象编号
			DealType:树图节点号
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "重点监控报告新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//自定义变量
	String sCustomerName = "";
	String sCustomerID = "";
	String sBadType = "";//不良类型
	String sReportType = "";//报告类型
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DealType"));
	
	//将空值转化成空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";	
	if(sDealType == null) sDealType = "";	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//取报告类型
	if(sDealType.length()>=12){
		//账面,股经置换,央行票据置换,已核销不良
		if(sDealType.substring(0,9).equals("020030010"))
		{  
		    sBadType="010";
		}else if(sDealType.substring(0,9).equals("020030020"))
		{
			sBadType="020";
		}else if(sDealType.substring(0,9).equals("020030030"))
		{
			sBadType="030";
		}else if(sDealType.substring(0,9).equals("020030040"))
		{
			sBadType="040";
		}
		//一般监控,重点监控
		if(sDealType.substring(9,12).equals("010"))
		{
			sReportType="010";
		}else if(sDealType.substring(9,12).equals("020")){
			sReportType="020";
		}
	}
	
	String sSql = "select CustomerID,CustomerName from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerName = rs.getString("CustomerName");
		sCustomerID = rs.getString("CustomerID");
	}
	rs.getStatement().close();
	//通过sql产生ASDataObject对象doTemp
	String sHeaders[][] = {
							{"CustomerName","客户名称"},
							{"ObjectNo","合同流水号"},
							{"ReportDate","报告日期"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"}
						  };

	sSql =   " select SerialNo,ObjectNo,ReportDate,ReportType,BadType,"+
					" CustomerID,CustomerName,"+
					" InputUserID,getUserName(InputUserID) as InputUserName,"+
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName,InputDate"+
					" from MONITOR_REPORT where SerialNo = '"+sSerialNo+"'";
	
	//根据模板编号设置数据对象	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//设置主键,可更新表
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "MONITOR_REPORT";
	doTemp.setUpdateable("InputUserName,InputOrgName",false);
	//设置必输背景色
	doTemp.setHTMLStyle("CustomerName","style={background=\"#EEEEff\"} ");
	doTemp.setHTMLStyle("ObjectNo","style={background=\"#EEEEff\"} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setVisible("SerialNo,CustomerID,ReportType,BadType,InputUserID,InputOrgID,InputDate",false);
	//设置只读
	doTemp.setReadOnly("CustomerName,ReportDate,InputUserName,InputOrgName,InputDate",true);
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置保存时操作关联数据表的动作
	
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
			{"true","","Button","确认","确认新增","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消新增","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{		
		initSerialNo();
		as_save("myiframe0",sPostEvents);		
	}
		   
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		saveRecord("doReturn()");
	}
	
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		top.returnValue = sObjectNo;
		top.close();
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录
			//合同编号
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");			
			//客户名称
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			//报告日期
			setItemValue(0,0,"ReportDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ReportType","<%=sReportType%>");//报告类型
			setItemValue(0,0,"BadType","<%=sBadType%>");//不良类型
			//登记机构
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			//登记人
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			//登记日期			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "MONITOR_REPORT";//表名
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