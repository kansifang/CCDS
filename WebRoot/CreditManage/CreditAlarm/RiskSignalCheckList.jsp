<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: 预警信号发起认定信息_List
		Input Param:			 
			FinishType：完成类型（Y：已完成；N：未完成）			    
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sClewDate = "";
	String sSql = "";
		
	//获得组件参数	
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));	
	//将空值转化为空字符串	
	if(sFinishType == null) sFinishType = "";
	//获得页面参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//提示日期
	sClewDate = StringFunction.getRelativeDate(StringFunction.getToday(),7);
	
	String[][] sHeaders = {							
							{"CustomerName","客户名称"},
							{"SignalName","预警信号"},
							{"SignalType","预警类型"},
							{"SignalStatus","预警状态"},													
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记时间"}
						};
		
	sSql =  " select RS.ObjectNo,GetCustomerName(RS.ObjectNo) as CustomerName, "+
			" RS.SignalName,getItemName('SignalType',RS.SignalType) as SignalType, "+
			" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus, "+
			" GetOrgName(RS.InputOrgID) as InputOrgName, "+
			" GetUserName(RS.InputUserID) as InputUserName,RS.InputDate,RS.SerialNo, "+
			" RS.ObjectType "+
			" from RISK_SIGNAL RS "+
			" where RS.ObjectType = 'Customer' "+
			" and RS.SignalType = '01' "+ 
			" and RS.SignalStatus = '30' "+
			" and RS.ObjectNo not in "+
			" (select ObjectNo from RISK_SIGNAL where ObjectType = 'Customer'  and SignalType = '02' and RS.SignalStatus <>'30')"+
			" and RS.InputUserID = '"+CurUser.UserID+"'";

	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	
	doTemp.setHTMLStyle("CustomerName,SignalName","style={width:200px}");
	doTemp.setHTMLStyle("SignalType,SignalStatus","style={width:50px}");
	doTemp.setHTMLStyle("InputDate","style={width:80px}");
	//设置格式
	doTemp.setAlign("SignalType,SignalStatus","2");
	//设置过滤器
	doTemp.setColumnAttribute("SignalName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{(sFinishType.equals("N")?"true":"false"),"","Button","预警检查详情","填写该笔预警信息的预警检查报告","newReport()",sResourcesPath},		
			{(sFinishType.equals("Y")?"true":"false"),"","Button","查看预警检查报告","查看/修改预警检查报告详情","viewReport()",sResourcesPath},
			{"true","","Button","预警详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{(sFinishType.equals("N")?"true":"false"),"","Button","完成检查","提交所选中的记录","commitRecord()",sResourcesPath}		
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=预警检查;InputParam=无;OutPutParam=无;]~*/
	function newReport()
	{		
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		OpenPage("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp?ObjectType=RiskSignal&ObjectNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=查看预警检查详情;InputParam=无;OutPutParam=无;]~*/
	function viewReport()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		PopComp("RiskSignalReports","/CreditManage/CreditAlarm/RiskSignalInspectList.jsp","CustomeID="+sObjectNo,"");
	
	}
					
	/*~[Describe=查看及修改预警详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		OpenPage("/CreditManage/CreditAlarm/RiskSignalCheckInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=提交记录;InputParam=无;OutPutParam=无;]~*/
	function commitRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		//提交操作
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishDate@<%=StringFunction.getToday()%>,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("所选记录提交失败！");
			return;
		}else
		{
			reloadSelf();
			alert("所选记录提交成功！");
		}					
	}
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
