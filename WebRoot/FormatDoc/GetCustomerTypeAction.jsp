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
	String sCustomerID="",sCustomerType="";
	String sReturn = "";
	String sSql = "select CustomerID from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerID = rs.getString("CustomerID");
		if(sCustomerID == null) sCustomerID = "";
	}
	rs.getStatement().close();
	
	sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'");
	
	if(sCustomerType == null) sCustomerType = "";
	
	
	else if (sCustomerType.startsWith("03"))  sReturn = "2";//个人客户办理业务
	else sReturn = "1";//公司客户办理业务		
%>

<script language="JavaScript">
	self.returnValue="<%=sReturn%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>