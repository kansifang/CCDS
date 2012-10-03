<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --zwhu  2009.11.18      
		Tester:	
		Content: 
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "常规性报告参数设置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//存放 sql语句
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InspectType"));
	if(sInspectType==null) sInspectType="";
	String sCustomerID = "";
	sSql = " select BC.CustomerID from Business_Contract BC,CHECK_Frequency CF where BC.CustomerID = CF.CustomerID "+
		   " and CF.FinishFrequencyDate < BC.OccurDate";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		
	}	   
	rs.getStatement().close();
	sSql = "";	   
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//获取客户信息表数据	
	String sHeaders[][] = {
				{"CustomerID","客户ID"},
				{"CustomerType","客户类型"},
				{"CustomerName","客户名称"},
				{"CheckFrequency","检查频率"},
			};
     if(sInspectType.equals("020001")){
	 //NEW
	 	sSql = " select CI.CustomerID,getItemName('CustomerType',CI.CustomerType) as CustomerType,CI.CustomerName from CUSTOMER_INFO CI "+
	 		   " left outer join CHECK_Frequency CF on CI.CustomerID=CF.CustomerID "+
	 		   " where CI.CustomerID in(Select CustomerID from Customer_Belong where BelongAttribute='1' and UserID='"+CurUser.UserID+"')"+
	 		   " and (FinishFrequencyDate = '' or FinishFrequencyDate is null )"+
	 		   " and(CustomerType like '01%' or CustomerType like '03%')";

	 }else
	 {
	 	sSql = " select CI.CustomerID,getItemName('CustomerType',CI.CustomerType) as CustomerType,CI.CustomerName,getItemName('CheckFrequency',CF.CheckFrequency) as CheckFrequency from CUSTOMER_INFO CI,CHECK_Frequency CF"+
	 		   " where CI.CustomerID = CF.CustomerID and CF.customerid in(Select CustomerID from Customer_Belong where BelongAttribute='1' and UserID='"+CurUser.UserID+"') and (CF.FinishFrequencyDate is not null and FinishFrequencyDate<>'')";
	 }       
	//out.println(sSql);
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="CUSTOMER_INFO";
    doTemp.setKey("CustomerID",true);
	doTemp.generateFilters(Sqlca);
 	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//设置在datawindows中显示的行数
	dwTemp.setPageSize(10); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1"; 
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //调试datawindow的Sql常用方法
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
		//6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"false","","Button","设置检查频率","设置检查频率","CheckFrequency()",sResourcesPath},
			{"true","","Button","详情","详情","viewAndEdit()",sResourcesPath},
			{"false","","Button","完成","完成","Finished()",sResourcesPath},
			{"false","","Button","撤回","撤回","ReEdit()",sResourcesPath}
		};	
	if(sInspectType.equals("020001")){
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
	}	
	else{
		sButtons[3][0] = "true";
	}
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	
<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=设置检查频率;InputParam=无;OutPutParam=无;]~*/
	function CheckFrequency()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条记录");
			return;
		}		
		
		var sReturnValue = PopPage("/CreditManage/CreditCheck/AddCheckFrequency.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(sReturnValue=="" || sReturnValue=="_CANCEL_" || sReturnValue=="_CLEAR_" || sReturnValue=="_NONE_" || typeof(sReturnValue)=="undefined")
		{
			return;
		}
		sSerialNo = PopPage("/CreditManage/CreditCheck/AddCheckFrequencyAction.jsp?ObjectNo="+sCustomerID+"&CheckFrequency="+sReturnValue,"","");
//		OpenPage("/CreditManage/CreditCheck/CheckFrequencyInfo.jsp?CustomerID="+sCustomerID+"&InspectType=<%=sInspectType%>", "_self","");
		

		reloadSelf();
	}


	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条记录");
			return;
		}
		sReturnValue=RunMethod("CustomerManage","QueryCheckFre",sCustomerID);			
		if(typeof(sReturnValue)=="undefined" || sReturnValue.length==0 ||sReturnValue=="0"){
			alert("这条记录没有设置检查频率");
			return;
		}	
		OpenPage("/CreditManage/CreditCheck/CheckFrequencyInfo.jsp?CustomerID="+sCustomerID+"&InspectType=<%=sInspectType%>", "_self","");
	}

  /*~[Describe=完成;InputParam=无;OutPutParam=无;]~*/
	function Finished()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sToDay = "<%=StringFunction.getToday()%>";
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条记录");
			return;
		}
		sReturnValue=RunMethod("CustomerManage","QueryCheckFre",sCustomerID);
		if(typeof(sReturnValue)=="undefined" || sReturnValue.length==0||sReturnValue=="0"){
			alert("这条记录没有设置检查频率");
			return;
		}	
		sReturnValue=RunMethod("CustomerManage","FinishCheckFre",sCustomerID+","+sToDay);
		if(typeof(sReturnValue)=="undefined" || sReturnValue.length==0)
		{
			alert("未完成参数设置");
		}
		reloadSelf();
	}
	
	function ReEdit()
	{
	    sSerialNo = getItemValue(0,getRow(),"CustomerID");
	    sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm("你确定要撤回吗？"))
		{
			sReturnValue=RunMethod("CustomerManage","ReEditCheckFre",sCustomerID);
			if(typeof(sReturnValue)=="undefined" || sReturnValue.length==0)
			{
				alert("撤回失败");
			}
			reloadSelf();
		}
	}
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