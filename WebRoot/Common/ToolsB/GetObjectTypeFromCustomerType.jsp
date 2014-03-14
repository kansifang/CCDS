<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
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
<%
	/*~END~*/
%>

<%
	String sCustomerType = DataConvert.toRealString(iPostChange,request.getParameter("CustomerType"));
	String sObjectType = "";
	ASResultSet rs = Sqlca.getResultSet("select Attribute1 from CODE_LIBRARY where CodeNo='CustomerType' and ItemNo='"+sCustomerType+"'");
	if (rs.next())
	{
		sObjectType=rs.getString("Attribute1");
	}else
	{
%>
		<script language=javascript>
			alert("对不起,系统中无此客户类型[<%=sCustomerType%>]的记录信息，请核实！");
			self.close();
		</script>
	<%
		}
		if(sObjectType==null || sObjectType.equals("")){
	%>
		<script language=javascript>
			alert("请为[<%=sCustomerType%>]定义对象类型(CODE_LIBRARY.CustomerType.Attribute1)");
			self.close();
		</script>
	<%
		}
		rs.getStatement().close();
	%>
<script	language=javascript>
	self.returnValue = "<%=sObjectType%>";
	self.close();
</script>
<%@	include file="/IncludeEnd.jsp"%>
