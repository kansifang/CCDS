<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FSGong  2005.01.26
		Tester:
		Content: 诉讼案件快速查询
		Input Param:
		Output param:
				 
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "诉讼案件快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;
	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","内部案号"},
							{"LawCaseName","案件名称"},
							{"LawCaseType","案件类型"},				
							{"LawCaseTypeName","案件类型"},
							{"LowCaseManageType","案件办理类型"},
							{"LowCaseManageTypeName","案件办理类型"},				
							{"LawCaseOrg","对方当事人名称"},				
							{"LawsuitStatus","我行诉讼地位"},
							{"LawsuitStatusName","我行诉讼地位"},
							{"CaseBriefName","案由"},
							{"CourtStatus","当前受理法院"},
							{"CaseStatus","当前诉讼进程"},
							{"CaseStatusName","当前诉讼进程"},
							{"CasePhaseName","当前阶段"},					
							{"CognizanceResultName","受理结果"},
							{"CurrencyName","诉讼币种"},
							{"AimSum","诉讼总标的"},				
							{"ManageUserName","案件管理人"},
							{"ManageOrgName","案件管理机构"},
							{"InputDate","登记日期"}				
			            }; 
	
	
	sSql = 		"  select  SerialNo,LawCaseName,"+
				"  LawCaseType,getItemName('LawCaseType',LawCaseType) as LawCaseTypeName, "+
				"  LowCaseManageType,getItemName('LowCaseManageType',LowCaseManageType) as LowCaseManageTypeName,"+		  
				"  LawCaseOrg,"+
				"  LawsuitStatus,getItemName('LawsuitStatus',LawsuitStatus) as LawsuitStatusName, "+
				"  CaseBrief,getItemName('CaseBrief',CaseBrief) as CaseBriefName,CourtStatus," +
				"  CaseStatus,getItemName('CaseStatus',CaseStatus) as CaseStatusName," +
				"  CasePhase,getItemName('CasePhase',CasePhase) as CasePhaseName," +
				"  CognizanceResult,getItemName('CognizanceResult',CognizanceResult) as CognizanceResultName," +
				
				"  Currency,getItemName('Currency',Currency) as CurrencyName," +
				"  AimSum,"+
				"  ManageUserID,getUserName(ManageUserID) as ManageUserName, " +
				"  ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName," +
				"  InputDate"+
				"  from LAWCASE_INFO where 1=1" ;
	  
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("SerialNo");
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAWCASE_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	doTemp.setVisible("LawsuitStatus,LawCaseType,LowCaseManageType,CaseBrief,Currency,CasePhase,CaseStatus,ManageUserID,ManageOrgID,PigeonholeDate,LawCaseTypeNo",false);	
	doTemp.setVisible("SerialNo,CaseStatus,CognizanceResult,CaseStatus,LawsuitStatus,LawCaseType",false);	

	doTemp.setCheckFormat("AimSum","2");
	
	//设置对齐方式	
	doTemp.setAlign("AimSum","3");	
	
	//设置选项行宽
	doTemp.setHTMLStyle("LawCaseName,LawCaseName"," style={width:120px} ");
	doTemp.setHTMLStyle("LawCaseTypeName"," style={width:100px} ");
	doTemp.setHTMLStyle("LowCaseManageTypeName"," style={width:100px} ");
	doTemp.setHTMLStyle("LawsuitStatusName"," style={width:100px} ");
	doTemp.setHTMLStyle("CaseBriefName"," style={width:80px} ");
	doTemp.setHTMLStyle("CaseStatusName"," style={width:80px} ");
	doTemp.setHTMLStyle("CognizanceResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");
	doTemp.setHTMLStyle("AimSum"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");
	
	//生成查询框
	doTemp.setDDDWCode("LawCaseType","LawCaseType");
	doTemp.setDDDWCode("LawsuitStatus","LawsuitStatus");
	doTemp.setDDDWCode("CaseStatus","CaseStatus");
	doTemp.setDDDWCode("LowCaseManageType","LowCaseManageType");
	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","LawCaseName","");
	doTemp.setFilter(Sqlca,"2","LawCaseType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"3","LawsuitStatus","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"4","CaseStatus","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","LawCaseOrg","");
	doTemp.setFilter(Sqlca,"6","ManageOrgName","");
	doTemp.setFilter(Sqlca,"7","ManageUserName","");
	doTemp.setFilter(Sqlca,"8","LowCaseManageType","");

	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

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
	
		//如果为诉前案件，则列表显示如下按钮
		String sButtons[][] = {					
					{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
					{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath}	
				};
%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sCasePhase =getItemValue(0,getRow(),"CasePhase");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;		
			sViewID = "002";			
			openObject(sObjectType,sObjectNo,sViewID);
		}
	}
	
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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