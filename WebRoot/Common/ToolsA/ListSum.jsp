<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zrli 20100118
		Tester:
		Describe: 授信业务汇总
		Input Param:
		Output Param:
			

		HistoryLog:
			DATE	CHANGER		CONTENT	
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "金额汇总"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Column1"));
	String[][] sListSumHeaders = (String [][])CurComp.compParentComponent.getAttribute("ListSumHeaders");
	String sListSumSql = CurComp.compParentComponent.getParameter("ListSumSql");
	//out.println("sListSumHeaders="+sListSumHeaders);
	//out.println("sListSumSql="+sListSumSql);
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = sListSumHeaders;

	String sSql =   sListSumSql;

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("0",false);
	//doTemp.setUpdateable("",false);
	doTemp.setAlign("Sum16,Sum15,Sum14,Sum13,Sum12,Sum11,Sum10,Sum9,Sum8,Sum7,Sum6,Sum5,Sum4,Sum3,Sum2,Sum1,BusinessSum,BalanceSum,InterestBalance1,InterestBalance2,Balance,BailSum,InvestSum,InvestRatio","3");
	doTemp.setAlign("BusinessCurrency","2");
	doTemp.setCheckFormat("Sum16,Sum15,Sum14,Sum13,Sum12,Sum11,Sum10,Sum9,Sum8,Sum7,Sum6,Sum5,Sum4,Sum3,Sum2,Sum1,GuarantyValue,BusinessSum,BalanceSum,InterestBalance1,InterestBalance2,Balance,BailSum,InvestSum,InvestRatio","2");
	doTemp.setDDDWCode("BusinessCurrency","Currency");
	doTemp.setDDDWCode("Currency","Currency");	
	doTemp.setVisible("FundSource,Currency",false);
	//设置html格式
	//doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	
   //生成过滤器
	doTemp.setColumnAttribute("BusinessTypeName,Currency","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10);
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
    };
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

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
	hideFilterArea();//默认关闭查询条件 add by zrli
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
