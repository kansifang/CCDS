<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-3
		Tester:
		Describe:
			通过用户输入的客户编号CustomerId从CUSTOMER_INFO中提取客户名称CustomerName。
			若表中无此客户资料，则上述变量值返回NULL。

		Input Param:
			CustomerID: 客户编号
		Output Param:
			CustomerName: 客户名称

		HistoryLog:
	*/
	%>
<%/*~END~*/%>

<%
	String sCustomerID = DataConvert.toRealString(iPostChange,request.getParameter("CustomerID"));
	ASResultSet rs = Sqlca.getResultSet("select CustomerName from CUSTOMER_INFO where CustomerID='"+sCustomerID+"'");
	String sCustomerName="";
	if (rs.next())
	{
		sCustomerName=rs.getString("CustomerName");
	}else
	{ %>
		<script language=javascript>
			alert("对不起,系统中无此客户编号[<%=sCustomerID%>]的记录信息，请核实！");
			self.close();
		</script>
	<%}
	rs.getStatement().close();
%>
<script	language=javascript>
	self.returnValue = "<%=sCustomerName%>";
	self.close();
</script>
<%@	include file="/IncludeEnd.jsp"%>
