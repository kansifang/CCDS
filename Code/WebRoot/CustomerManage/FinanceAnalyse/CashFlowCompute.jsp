<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: ��ʾ�ͻ���ص��ֽ���Ԥ��
		Input Param:
			CustomerID �� ��ǰ�ͻ����
			BaseYear   : ��׼���:�������������һ��  
			YearCount  : Ԥ������:default=1
			ReportScope: ����ھ�
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    �µİ汾�ĸ�д
	 */
  %>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��ֽ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    String sSql  = "";
	ASResultSet rs = null;
	
	double dSales=0;	//��Ӫҵ������(��Ԫ)
	double dG=0;		//��Ӫҵ������������(%)
	double dCost=0;		//��Ӫҵ��ɱ�/��Ӫҵ������(%)
	double dOper_tax=0;		//��Ӫҵ��˰�𼰸���/��Ӫҵ������(%)
	double dSale_fee=0;		//��Ӫҵ����+������Ӫҵ��ɱ���/��Ӫҵ������(%)
	double dGeneral_fee=0;		//�������/��Ӫҵ������(%)
	double dOther_income=0;		//����ҵ������/��Ӫҵ������(%)
	double dCurrA1=0;		//�������ʲ��������ʽ�Ͷ���Ͷ�ʣ�/��Ӫҵ������(%)
	double dCurrA0=0;
	double dCurr_L1=0;		//��������ծ�����ڽ���һ���ڵ��ڵĳ��ڸ�ծ��/��Ӫҵ������(%)
	double dCurr_L0=0;
	double dLong_asset1=0;		//�̶��ʲ���ֵ�������ʲ�/��Ӫҵ������(%)
	double dLong_asset0=0;
	double dD_A=0;		//�����۾ɺ�̯���ܶ�/�����ĩƽ��(�̶��ʲ���ֵ+�����ʲ�)(%)
	double dTax=0;		//����˰��(%)
	double ddebt=0;		//��Ϣծ���ܶ�(��Ԫ)
	double dinterest=0;		//ƽ������(%)
    //���ҳ�����
	String sCustomerID  = DataConvert.toRealString(CurPage.getParameter("CustomerID"));
	String sBaseYear    = DataConvert.toRealString(CurPage.getParameter("BaseYear"));
	String sYearCount   = DataConvert.toRealString(CurPage.getParameter("YearCount"));
	String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));
	//����������

%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=���ݲ���;]~*/%>

<%
	
	//��dSales,ddebt�⣬��������/100
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
	
	d1 = dSales*(1+dG);		//��������
	d2 = d1*dCost;			//��Ӫҵ��ɱ�
	d3 = d1*dOper_tax;		//��Ӫҵ��˰��͸���
	d4 = d1*dSale_fee;		//Ӫҵ���ú�������Ӫҵ��ɱ�
	d5 = d1*dGeneral_fee;	//�������
	d6 = d1*dOther_income;	//����ҵ������
	d7 = d1-d2-d3-d4-d5+d6;	//EBIT
	d8 = d7*(1-dTax)+ddebt*dinterest*dTax;	//Ϣǰ������
	d9 = 0.5*dD_A*d1*(dLong_asset1+dLong_asset0/(1+dG));	//�۾ɺ�̯��
	d10 = d1/(1+dG)*((1+dG)*dCurrA1-dCurrA0-(1+dG)*dCurr_L1+dCurr_L0);	//Ӫ���ʽ�仯
	d11 = d8+d9-d10;		//��Ӫ��������ֽ���
	d12 = d1*(dLong_asset1-dLong_asset0/(1+dG));		//�ʱ�֧������
	d13 = d11-d12;
	
	boolean flag = false;
	try
    {
		flag = Sqlca.conn.getAutoCommit();
		if(!flag) Sqlca.conn.commit();
        else Sqlca.conn.setAutoCommit(false);        
		
		//��ɾ������
		Sqlca.executeSQL("delete from CashFlow_Data "+
						"  where CustomerID = '" + sCustomerID + "' "+
						"    and BaseYear = " + sBaseYear+" "+
						"    and ReportScope = '" + sReportScope + "' " +
						"    and FCN = " + sYearCount);	

		//�ٲ�������
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",1,'��������',"+d1+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",2,'��Ӫҵ��ɱ�',"+d2+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",3,'��Ӫҵ��˰��͸���',"+d3+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",4,'Ӫҵ���ú�������Ӫҵ��ɱ�',"+d4+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",5,'�������',"+d5+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",6,'����ҵ������',"+d6+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",7,'EBIT',"+d7+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",8,'Ϣǰ������',"+d8+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",9,'�۾ɺ�̯��',"+d9+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",10,'Ӫ���ʽ�仯',"+d10+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",11,'��Ӫ��������ֽ���',"+d11+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",12,'�ʱ�֧������',"+d12+")");
		Sqlca.executeSQL("insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			" values('" + sCustomerID + "'," + sBaseYear + ",'"+sReportScope+"',"+sYearCount+",13,'�����ֽ���',"+d13+")");

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
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����ҳ��;]~*/%>
<script  language=javascript>
	OpenPage("/CustomerManage/FinanceAnalyse/CashFlowDetail.jsp?CustomerID=<%=sCustomerID%>&YearCount=<%=sYearCount%>&ReportScope=<%=sReportScope%>&BaseYear=<%=sBaseYear%>","_self");
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
