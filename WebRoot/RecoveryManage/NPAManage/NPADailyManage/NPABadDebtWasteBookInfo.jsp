<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-07
		Tester:
		Describe: 业务流水信息;
		Input Param:
			SerialNo:流水号
		Output Param:			

		HistoryLog:zywei 2005/09/04 重检代码
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = " 业务流水信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";

	//获得组件参数
	
	//获得页面参数(记录流水号、标识Flag-Y表示从还款方式补登进入该页面)
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sFlag == null) sFlag = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { 
	                        {"OccurType","发生类型"},
	                        {"OccurDirection","发生方向"},
	                        {"OccurDate","交易日期"},
	                        {"BackType","回收方式"},
	                        {"OccurSubject","发生摘要"},
	                        {"ActualDebitSum","发放金额(元)"},
	                        {"ActualCreditSum","回收金额(元)"},
	                        {"UserName","登记人"},
	                        {"OrgName","登记机构"}     
                          };	
	
	sSql=	" select SerialNo,OccurDate,ActualDebitSum,ActualCreditSum,OccurType, "+
			" OccurDirection,OccurSubject,BackType,getUserName(UserID) as UserName,"+
			" getOrgName(OrgID) as OrgName "+
			" from BUSINESS_WASTEBOOK where SerialNo='"+sSerialNo+"' ";	

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK";
	doTemp.setKey("SerialNo",true);

	doTemp.setHeader(sHeaders);
	doTemp.setReadOnly("OrgName,UserName,OccurSubject,BackType",true);
	doTemp.setReadOnly("OccurDate,ActualDebitSum,ActualCreditSum,OccurType,OrgName,OccurDirection",true);
	
	doTemp.setVisible("SerialNo",false);
	doTemp.setUpdateable("OrgName,UserName",false);
	
	doTemp.setDDDWCode("OccurSubject","OccurSubjectName");
	doTemp.setDDDWCode("OccurType","WasteOccurType");
	doTemp.setDDDWCode("OccurDirection","OccurDirection");
	doTemp.setDDDWCode("BackType","ReclaimType");
    doTemp.setType("ActualCreditSum,ActualDebitSum","Number");
	doTemp.setCheckFormat("ActualCreditSum,ActualDebitSum","2");
	doTemp.setAlign("ActualCreditSum,ActualDebitSum","3");
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	
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
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		var sFlag="<%=sFlag%>";
		if(sFlag=="Y")
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPAReturnWayList.jsp","_self","");
		else
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPABadDebtList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

