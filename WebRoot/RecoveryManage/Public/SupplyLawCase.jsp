<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: slliu 2004-12-02
		Tester:
		Describe: 已代理案件信息列表;
		Input Param:
			QuaryName：名称
			QuaryValue：值
			Back：返回类型
		Output Param:
						
		HistoryLog:ndeng 2004-12-26
				   zywei 2005/09/07 重检代码
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "已代理案件信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数

	//获得页面参数	    
    String sQuaryName = DataConvert.toRealString(iPostChange,request.getParameter("QuaryName"));
    String sQuaryValue = DataConvert.toRealString(iPostChange,request.getParameter("QuaryValue"));
    String sBack = DataConvert.toRealString(iPostChange,request.getParameter("Back"));
	//将空值转化为空字符串
	if(sQuaryName == null) sQuaryName = "";
	if(sQuaryValue == null) sQuaryValue = "";
	if(sBack == null) sBack = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { 							
							{"SerialNo","内部案号"},
							{"LawCaseName","案件名称"},
							{"LawCaseTypeName","案件类型"},				
							{"LawsuitStatusName","我行的诉讼地位"},
							{"CaseBriefName","案由"},				
							{"CaseStatusName","当前诉讼进程"},
							{"CourtStatus","当前受理法院"},
							{"CognizanceResultName","受理结果"},
							{"CurrencyName","诉讼币种"},
							{"AimSum","诉讼总标的(元)"},				
							{"ManageUserName","案件管理人"},
							{"ManageOrgName","案件管理机构"},
							{"InputDate","登记日期"}				
						}; 	
	
	if(sQuaryName.equals("OrgNo"))
	{
		
		sSql = 	" select distinct LI.SerialNo,LI.LawCaseName,LI.LawCaseType, "+
				" getItemName('LawCaseType',LI.LawCaseType) as LawCaseTypeName, "+		  
				" getItemName('LawsuitStatus',LI.LawsuitStatus) as LawsuitStatusName, "+
				" LI.CaseBrief,getItemName('CaseBrief',LI.CaseBrief) as CaseBriefName," +
				" LI.CourtStatus,LI.LawsuitStatus,LI.CognizanceResult,LI.Currency, "+
				" LI.CaseStatus,getItemName('CaseStatus',LI.CaseStatus) as CaseStatusName," +
				" getItemName('CognizanceResult',LI.CognizanceResult) as CognizanceResultName," +
				" getItemName('Currency',LI.Currency) as CurrencyName,LI.AimSum,LI.ManageUserID, " +
				" getUserName(LI.ManageUserID) as ManageUserName,LI.ManageOrgID, " +
				" getOrgName(LI.ManageOrgID) as ManageOrgName,LI.InputDate"+
		        " from LAWCASE_INFO LI,LAWCASE_PERSONS LP " +
		        " where LI.SerialNo=LP.ObjectNo "+
		        " and LP.OrgNo = '"+sQuaryValue+"' ";
	}
	
	if(sQuaryName.equals("PersonNo"))
	{
		
		sSql = 	" select distinct LI.SerialNo,LI.LawCaseName,LI.LawCaseType, "+
				" getItemName('LawCaseType',LI.LawCaseType) as LawCaseTypeName, "+		  
				" getItemName('LawsuitStatus',LI.LawsuitStatus) as LawsuitStatusName, "+
				" LI.CaseBrief,getItemName('CaseBrief',LI.CaseBrief) as CaseBriefName, "+
				" LI.CaseStatus,getItemName('CaseStatus',LI.CaseStatus) as CaseStatusName, "+
				" getItemName('CognizanceResult',LI.CognizanceResult) as CognizanceResultName, "+
				" LI.Currency,getItemName('Currency',LI.Currency) as CurrencyName, "+
				" LI.LawsuitStatus,LI.AimSum,LI.CognizanceResult,LI.ManageUserID, "+
				" getUserName(LI.ManageUserID) as ManageUserName,LI.ManageOrgID, " +
				" getOrgName(LI.ManageOrgID) as ManageOrgName,LI.InputDate"+
		        " from LAWCASE_INFO LI,LAWCASE_PERSONS LP " +
		        " where  LI.SerialNo=LP.ObjectNo "+
		        " and LP.PersonNo ='"+sQuaryValue+"' ";
	}
			 
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAWCASE_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("SerialNo,LawsuitStatus,LawCaseType,CaseBrief,Currency,ManageUserID,ManageOrgID,PigeonholeDate,LawCaseTypeNo",false);	
	doTemp.setVisible("CaseStatus,CognizanceResult",false);	
	//设置金额格式
	doTemp.setCheckFormat("AimSum","2");	
	doTemp.setAlign("AimSum","3");	
	
	//设置选项行宽
	doTemp.setHTMLStyle("LawCaseName"," style={width:120px} ");
	doTemp.setHTMLStyle("LawCaseTypeName"," style={width:100px} ");	
	doTemp.setHTMLStyle("LawsuitStatusName"," style={width:100px} ");
	doTemp.setHTMLStyle("CaseBriefName"," style={width:80px} ");
	doTemp.setHTMLStyle("CaseStatusName"," style={width:80px} ");
	doTemp.setHTMLStyle("CognizanceResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");
	doTemp.setHTMLStyle("AimSum"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:250px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style = "1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页
	
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
				{"true","","Button","详情","详情","viewAndEdit()",sResourcesPath},
				{"true","","Button","返回","返回","goBack()",sResourcesPath}
			};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;
			sViewID = "002"
			openObject(sObjectType,sObjectNo,sViewID);
		}
	}

	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{		
		sBack = "<%=sBack%>";
		if(sBack == "1")
			OpenPage("/RecoveryManage/Public/AgencyList.jsp?rand="+randomNumber(),"_self","");
		if(sBack == "2")
			OpenPage("/RecoveryManage/Public/AgentList.jsp?rand="+randomNumber(),"_self","");
		if(sBack == "3")
			OpenPage("/RecoveryManage/Public/CourtList.jsp?rand="+randomNumber(),"_self","");
		if(sBack == "4")
			OpenPage("/RecoveryManage/Public/CourtPersonList.jsp?rand="+randomNumber(),"_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
