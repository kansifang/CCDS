<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: --客户财务报表分析
		Input Param:
			  CustomerID：--当前客户编号
		Output Param:
			  CustomerID：--当前客户编号
			
		HistoryLog:
		--fbkang 2005.7.21,页面调整和修改
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "财务分析"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	
	//获得组件参数，客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
								{"CustomerID","客户号"},
								{"RecordNo","记录号"},
								{"ReportDate","报表截至日期"},
								{"ReportScopeName","报表口径"},
								{"ReportPeriodName","报表周期"},
								{"ReportCurrencyName","报表币种"},
								{"ReportUnitName","报表单位"},
								{"InputDate","登记日期"},
								{"OrgName","登记机构"},
								{"UserName","登记人"},
								{"UpdateDate","修改日期"}
						  };

	String 	sSql = " select CustomerID,RecordNo,ReportDate,ReportScope,ReportPeriod,ReportCurrency,ReportUnit,"+
					" getItemName('ReportScope',ReportScope) as ReportScopeName,"+
					" getItemName('ReportPeriod',ReportPeriod) as ReportPeriodName,"+
					" getItemName('Currency',ReportCurrency) as ReportCurrencyName,"+
					" getItemName('ReportUnit',ReportUnit) as ReportUnitName,"+
					" getUserName(UserID) as UserName,"+
					" getOrgName(OrgID) as OrgName,"+
					" InputDate,OrgID,UserID,UpdateDate "+
					" from CUSTOMER_FSRECORD "+
					" where CustomerID='"+sCustomerID+"' order by ReportDate DESC";


	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置修改表名
	doTemp.UpdateTable = "CUSTOMER_FSRECORD";
	doTemp.setKey("RecordNo",true);	
	//设置不可见项
	doTemp.setVisible("ReportScope,ReportPeriod,ReportCurrency,ReportUnit",false);
	doTemp.setVisible("CustomerID,RecordNo,OrgID,UserID,UpdateDate,Remark",false);
	//设置界面宽度
	doTemp.appendHTMLStyle("ReportScopeName,ReportPeriodName,ReportCurrencyName,ReportUnitName"," style={width=55px} ");
	doTemp.appendHTMLStyle("ReportDate,UserName,InputDate"," style={width=70px} ");
	doTemp.setCheckFormat("InputDate,UpdateDate","3");
    doTemp.setHTMLStyle("OrgName","style={width:200px}"); 	
	doTemp.setAlign("ReportScopeName,ReportPeriodName,ReportCurrencyName,ReportUnitName","2");
	//生成过滤器
	doTemp.setColumnAttribute("ReportDate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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

	String sButtons[][] = 
	  {
			{"true","","Button","杜邦分析","杜邦分析","dupondInfo()",sResourcesPath},
			{"true","","Button","结构分析","结构分析","structureInfo()",sResourcesPath},
			{"true","","Button","指标分析","指标分析","itemInfo()",sResourcesPath},
			{"true","","Button","趋势分析","趋势分析","trendInfo()",sResourcesPath}
	  };
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=杜邦分析;InputParam=客户代码;OutPutParam=无;]~*/
	function dupondInfo()
	{   
		//返回值：报表的年月
		sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=16;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;scrollbar:yes ");
		if(typeof(sMonth)=="undefined" || sMonth=='')
		return;
		PopPage("/CustomerManage/FinanceAnalyse/DBAnalyse.jsp?CustomerID=<%=sCustomerID%>&AccountMonth="+sMonth,"width=480,height=400,left=180,top=150,status=yes,center=yes ");
	}
	
	/*~[Describe=结构分析;InputParam=客户代码;OutPutParam=无;]~*/
	function structureInfo()
	{   
	    //返回值：报表的期数、报表的年月、报表范围
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm.jsp?CustomerID=<%=sCustomerID%>","","width=160,height=20,left=20,top=20,status=yes,center=yes ");
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
		return;
		PopPage("/CustomerManage/FinanceAnalyse/StructureMain.jsp?CustomerID=<%=sCustomerID%>&Term=" + sReturnValue + "","width=480,height=400,left=180,top=150,status=yes,center=yes ");
	
	}

	/*~[Describe=指标分析;InputParam=客户代码;OutPutParam=无;]~*/
	function itemInfo()
	{  
	    //返回值：报表的期数、报表的年月、报表范围
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm.jsp?CustomerID=<%=sCustomerID%>","","width=200,height=20,left=20,top=20,status=yes,center=yes ");
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
		 return;
		PopPage("/CustomerManage/FinanceAnalyse/ItemMain.jsp?CustomerID=<%=sCustomerID%>&Term="+sReturnValue+"","_blank","");
	}

	/*~[Describe=趋势分析;InputParam=客户代码;OutPutParam=无;]~*/
	function trendInfo()
	{
	    //返回值：报表的期数、报表的年月、报表范围
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm_Trend.jsp?CustomerID=<%=sCustomerID%>","","width=200,height=20,left=20,top=20,status=yes,center=yes ");
		
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
			return;
		PopPage("/CustomerManage/FinanceAnalyse/TrendMain.jsp?CustomerID=<%=sCustomerID%>&Term=" + sReturnValue + "","_blank","");
	}

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
