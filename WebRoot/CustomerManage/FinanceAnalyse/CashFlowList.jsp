<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<% 
	/*
		Author: jbye  2004-12-16 20:15
		Tester:
		Describe: --显示客户相关的现金流预测
		Input Param:
			CustomerID： --当前客户编号
		Output Param:
			CustomerID： --当前客户编号
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    新的版本的改写
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "现金流预测信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
     String sCustomerID = "";
     String sFinanceBelong = "";
	//获得组件参数
	sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//获得页面参数
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String[][] sHeaders =
	      {
			{"BaseYear","基准年份"},
			{"FCN","预测年数N"},
			{"ReportScopeName","报表口径"},
			{"Kn","主营业务收入增长率(预测)"},
			{"RecordDate","输入日期"},
			{"OrgName","登记机构"},
			{"UserName","登记人"}
	     };

	//获得客户财务报表类型：FinanceBelong，只有001(企业法人)才做现金流预测
	
	ASResultSet rsFB = Sqlca.getResultSet("select FinanceBelong from ent_info where  CustomerID = '" + sCustomerID + "'");
	if(rsFB.next())
		sFinanceBelong = DataConvert.toString(rsFB.getString("FinanceBelong"));
	rsFB.getStatement().close();

	String sSql = "  select BaseYear,ReportScope,getItemName('ReportScope',ReportScope) as ReportScopeName,FCN,Kn,RecordDate,getOrgName(OrgID) as OrgName,UserID,getUserName(UserID) as UserName " +
				  "  from CashFlow_Record " +
			      "  where CustomerID = '" + sCustomerID + "' order by BaseYear desc,FCN";

	//通过sql产生数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表

	//置是否可见
	doTemp.setVisible("FCN,ReportScope,Kn,UserID",false);

	//设置html格式
	doTemp.setHTMLStyle("OrgName,UserName"," style={width:120px} ");
	doTemp.setHTMLStyle("Kn"," style={width:220px} ");
	doTemp.setHTMLStyle("BaseYear,RecordDate"," style={width:80px} ");
	doTemp.setType("BaseYear","Integer");//by jgao
	doTemp.setAlign("ReportScopeName","2");
	//生成过滤器
	doTemp.setColumnAttribute("RecordDate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//生成ASDataWindow对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
			{"true","","Button","新增预测","新增现金流预测记录","addRecord()",sResourcesPath},
			{"true","","Button","删除预测","删除现金流预测记录","delRecord()",sResourcesPath},
			{"true","","Button","查看预测","查看现金流预测记录","viewRecord()",sResourcesPath},
		   };
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	var sMDStyle = "dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
	function addRecord()
	{
			var vReturn = PopPage("/CustomerManage/FinanceAnalyse/CashFlowAddTerm.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=20;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(vReturn == "_none_" || typeof(vReturn) == "undefined")
			   return;
			   
			OpenPage("/CustomerManage/FinanceAnalyse/CashFlowAddAction.jsp?CustomerID=<%=sCustomerID%>&"+vReturn+"","_self","");
	}

	function delRecord()
	{
		sUserID=getItemValue(0,getRow(),"UserID");
		var vBaseYear = getItemValue(0,getRow(),"BaseYear");
		var vYearCount = getItemValue(0,getRow(),"FCN");
		var vReportScope = getItemValue(0,getRow(),"ReportScope");

		if(vBaseYear == "" || typeof(vBaseYear) == "undefined")
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    			OpenPage("/CustomerManage/FinanceAnalyse/CashFlowDelAction.jsp?ReportScope="+vReportScope+"&CustomerID=<%=sCustomerID%>&BaseYear="+vBaseYear+"&YearCount="+vYearCount+"&rand="+randomNumber(),"_self","");
    	}else 
    		alert(getHtmlMessage('3'));
	}

	function viewRecord()
	{
		var vBaseYear = getItemValue(0,getRow(),"BaseYear");
		var vYearCount = getItemValue(0,getRow(),"FCN");
		var vReportScope = getItemValue(0,getRow(),"ReportScope");

		if(vBaseYear == "" || typeof(vBaseYear) == "undefined")
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowDetail.jsp?ReportScope="+vReportScope+"&CustomerID=<%=sCustomerID%>&BaseYear="+vBaseYear+"&YearCount="+vYearCount+"&rand="+randomNumber(),"_self");
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
