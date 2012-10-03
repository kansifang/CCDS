<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2009/09/28
		Tester:
		Content: 诉讼案件监控列表
		Input Param:
		Output param:
				 
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "诉讼案件监控列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";		
	
	
	//获得组件参数	：树图节点号	
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";	
			
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
				{"SerialNo","内部案号"},
				{"LawCaseOrg","破产人名称"},
				{"LowApplySubjectName","破产申请主体"},
				{"Claim","破产申请人"},
				{"ApplyDate","破产宣告时间"},				
				{"BankruptSum","破产财产金额"},				
				{"IsGuaranty","是否抵（质）押"},
				{"DeclareDate","债权申报时间"},
				{"LegalCost","债权申报额"}
			}; 
	
	sSql = 	" select  LI.SerialNo as SerialNo,"+
			" LI.LawCaseOrg as LawCaseOrg,"+
			" getItemName('ApplySubject',LI.LowApplySubject) as LowApplySubjectName,"+
			" LI.Claim as Claim,"+
			" LI.ApplyDate as ApplyDate,LI.BankruptSum as BankruptSum ,"+
			" getItemName('YesNo',LI.IsGuaranty) as IsGuaranty, "+
			" LI.DeclareDate as DeclareDate,LI.LegalCost as LegalCost " +
			" from LAWCASE_INFO LI"+		
			" where  ApplyStatus='020' and days(replace(DeclareDate,'/','-'))<days(current date) ";
		
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAWCASE_INFO";	
	doTemp.setKey("SerialNo",true);	 //设置关键字
	
	//设置共用格式
	//doTemp.setVisible("LawsuitStatus,LawCaseType,CaseBrief,Currency,ManageUserID,ManageOrgID,PigeonholeDate,LawCaseTypeNo",false);	
	//doTemp.setVisible("SerialNo,CaseStatus,CognizanceResult,CasePhase",false);	
	//设置金额格式
	doTemp.setCheckFormat("BankruptSum,LegalCost","2");	
	//设置对齐方式	
	doTemp.setAlign("BankruptSum,LegalCost","3");	
	
	//设置选项行宽
	//doTemp.setHTMLStyle("Counter"," style={width:60px} ");
	
	//生成查询框
	doTemp.setColumnAttribute("LawCaseOrg","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
 
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
					{"true","","Button","案件详情","查看/修改案件详情","viewAndEdit()",sResourcesPath},
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
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			sViewID = "001"
			
			openObject(sObjectType,sObjectNo,sViewID);	
			reloadSelf();		
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
