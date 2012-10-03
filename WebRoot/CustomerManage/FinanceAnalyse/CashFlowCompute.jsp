<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: 显示客户相关的现金流预测
		Input Param:
			CustomerID ： 当前客户编号
			BaseYear   : 基准年份:距离现在最近的一年  
			YearCount  : 预测年数:default=1
			ReportScope: 报表口径
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    新的版本的改写
	 */
  %>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户现金流测算"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    String sSql  = "";
	ASResultSet rs = null;
	
	double dSales=0;	//主营业务收入(万元)
	double dG=0;		//主营业务收入增长率(%)
	double dCost=0;		//主营业务成本/主营业务收入(%)
	double dOper_tax=0;		//主营业务税金及附加/主营业务收入(%)
	double dSale_fee=0;		//（营业费用+其他主营业务成本）/主营业务收入(%)
	double dGeneral_fee=0;		//管理费用/主营业务收入(%)
	double dOther_income=0;		//其他业务利润/主营业务收入(%)
	double dCurrA1=0;		//（流动资产－货币资金和短期投资）/主营业务收入(%)
	double dCurrA0=0;
	double dCurr_L1=0;		//（流动负债－短期借款和一年内到期的长期负债）/主营业务收入(%)
	double dCurr_L0=0;
	double dLong_asset1=0;		//固定资产净值和无形资产/主营业务收入(%)
	double dLong_asset0=0;
	double dD_A=0;		//本年折旧和摊销总额/年初年末平均(固定资产净值+无形资产)(%)
	double dTax=0;		//所得税率(%)
	double ddebt=0;		//有息债务总额(万元)
	double dinterest=0;		//平均利率(%)
    //获得页面参数
	String sCustomerID  = DataConvert.toRealString(CurPage.getParameter("CustomerID"));
	String sBaseYear    = DataConvert.toRealString(CurPage.getParameter("BaseYear"));
	String sYearCount   = DataConvert.toRealString(CurPage.getParameter("YearCount"));
	String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));
	//获得组件参数

%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=数据测算;]~*/%>

<%
	
	//除dSales,ddebt外，其他数据/100
	sSql = ("select parametercode,value0,value1 from CashFlow_Parameter "+
						"  where CustomerID = '" + sCustomerID + "' "+
						"    and BaseYear = " + sBaseYear+" "+
						"    and ReportScope = '" + sReportScope + "' " +
						"  order by parameterno");	
    rs = Sqlca.getResultSet(sSql);
    while(rs.next())
    {
    	if(rs.getString(1).equals("Sales")) dSales = rs.getDouble(2);
    	if(rs.getString(1).equals("G")) dG = rs.getDouble(2)/100;
    	if(rs.getString(1).equals("Cost")) dCost = rs.getDouble(2)/100;
    	if(rs.getString(1).equals("Oper_tax")) dOper_tax = rs.getDouble(2)/100;
    	if(rs.getString(1).equals("Sale_fee")) dSale_fee = rs.getDouble(2)/100;
    	if(rs.getString(1).equals("General_fee")) dGeneral_fee = rs.getDouble(2)/100;
    	if(rs.getString(1).equals("Other_income")) dOther_income = rs.getDouble(2)/100;
    	if(rs.getString(1).equals("CurrA")) {dCurrA1 = rs.getDouble(2)/100;dCurrA0 = rs.getDouble(3)/100;}
    	if(rs.getString(1).equals("Curr_L")) {dCurr_L1 = rs.getDouble(2)/100;dCurr_L0 = rs.getDouble(3)/100;}
    	if(rs.getString(1).equals("Long_asset")) {dLong_asset1 = rs.getDouble(2)/100;dLong_asset0 = rs.getDouble(3)/100;}
    	if(rs.getString(1).equals("D&A")) dD_A = rs.getDouble(2)/100;
    	if(rs.getString(1).equals("Tax")) dTax = rs.getDouble(2)/100;
    	if(rs.getString(1).equals("debt")) ddebt = rs.getDouble(2);
    	if(rs.getString(1).equals("interest")) dinterest = rs.getDouble(2)/100;
    }
    rs.getStatement().close();

	double d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13;
	
	d1 = dSales*(1+dG);		//销售收入
	d2 = d1*dCost;			//主营业务成本
	d3 = d1*dOper_tax;		//主营业务税金和附加
	d4 = d1*dSale_fee;		//营业费用和其他主营业务成本
	d5 = d1*dGeneral_fee;	//管理费用
	d6 = d1*dOther_income;	//其他业务利润
	d7 = d1-d2-d3-d4-d5+d6;	//EBIT
	d8 = d7*(1-dTax)+ddebt*dinterest*dTax;	//息前净利润
	d9 = 0.5*dD_A*d1*(dLong_asset1+dLong_asset0/(1+dG));	//折旧和摊销
	d10 = d1/(1+dG)*((1+dG)*dCurrA1-dCurrA0-(1+dG)*dCurr_L1+dCurr_L0);	//营运资金变化
	d11 = d8+d9-d10;		//经营活动产生的现金流
	d12 = d1*(dLong_asset1-dLong_asset0/(1+dG));		//资本支出增加
	d13 = d11-d12;
	
	boolean flag = false;
	try
    {
		flag = Sqlca.conn.getAutoCommit();
		if(!flag) Sqlca.conn.commit();
        else Sqlca.conn.setAutoCommit(false);        
		
		//先删除数据
		Sqlca.executeSQL("delete from CashFlow_Data "+
						"  where CustomerID = '" + sCustomerID + "' "+
						"    and BaseYear = " + sBaseYear+" "+
						"    and ReportScope = '" + sReportScope + "' " +
						"    and FCN = " + sYearCount);	

		//再插入数据
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",1,'销售收入',"+d1+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",2,'主营业务成本',"+d2+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",3,'主营业务税金和附加',"+d3+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",4,'营业费用和其他主营业务成本',"+d4+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",5,'管理费用',"+d5+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",6,'其他业务利润',"+d6+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",7,'EBIT',"+d7+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",8,'息前净利润',"+d8+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",9,'折旧和摊销',"+d9+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",10,'营运资金变化',"+d10+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",11,'经营活动产生的现金流',"+d11+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",12,'资本支出增加',"+d12+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",13,'自由现金流',"+d13+")");

		Sqlca.conn.commit();
        Sqlca.conn.setAutoCommit(flag);

    }
    catch(Exception exception)
    {
		Sqlca.conn.rollback();
		Sqlca.conn.setAutoCommit(flag);

        System.out.println(exception);
        //exception.printStackTrace();
    }	

%>
<%/*~END~*/%>
<body class="ListPage" leftmargin="0" topmargin="0" >
</body>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=返回页面;]~*/%>
<script  language=javascript>
	OpenPage("/CustomerManage/FinanceAnalyse/CashFlowDetail.jsp?CustomerID=<%=sCustomerID%>&YearCount=<%=sYearCount%>&ReportScope=<%=sReportScope%>&BaseYear=<%=sBaseYear%>","_self");
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
