<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.17
		Tester:
		Content: 插入数据到FORMATDOC_DATA
		Input Param:
			DocID:    formatdoc_catalog中的文档类别（调查报告，贷后检查报告，...)
			ObjectNo：业务流水号
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<% 	
		
	//获得组件参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 		//业务流水号
	String sBusinessType = "",sCreditAggreement = "",sCustomerID="",sCustomerType="";
	double dBailRatio = 0.0;
	String sReturn = "";
	String sSql = "select BusinessType,BailRatio,CreditAggreement,CustomerID from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{ 
		sBusinessType = rs.getString("BusinessType");
		dBailRatio = rs.getDouble("BailRatio");
		sCreditAggreement = rs.getString("CreditAggreement");
		sCustomerID = rs.getString("CustomerID");
		if(sBusinessType == null) sBusinessType = "";
		if(sCreditAggreement == null) sCreditAggreement = "";
		if(sCustomerID == null) sCustomerID = "";
	}
	rs.getStatement().close();

	sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'");
	if(sCustomerType == null) sCustomerType = "";
	
	sSql = "select CustomerScale from Customer_Info where CustomerID='"+sCustomerID+"'";
	String sCustomerScale = Sqlca.getString(sSql);
	if(sCustomerScale == null) sCustomerScale = "";

	if(dBailRatio == 100) sReturn = "1";//低风险业务
	else if(!sCreditAggreement.equals("")) sReturn = "2";//授信项下业务 
	else if(sBusinessType.equals("1020010")) sReturn = "3";//银票贴现业务
	else if(sBusinessType.startsWith("3")) sReturn = "4";//授信业务
	else if (sCustomerType.equals("03"))  sReturn = "8";//个人客户
	else if (!sCustomerScale.equals("")&&sCustomerScale.startsWith("02")) sReturn = "9";
	else sReturn = "5";//初上述之外的信贷业务
		
%>

<script language="JavaScript">
	self.returnValue="<%=sReturn%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>