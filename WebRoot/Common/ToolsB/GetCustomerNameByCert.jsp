<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: FMWu 2004-11-30
			Tester:
			Describe:
		通过用户输入的客户号CustomerID
		从CUSTOMER_INFO中提取得到证件类型CertType和证件号码CertId及客户名称CustomerName
		若表中无此客户资料，则上述变量值返回NULL。

			Input Param:
		CustomerID: 客户编号
			Output Param:
		CertType: 证件类型
		CertID: 证件号码
		CustomerName: 客户名称

			HistoryLog:
		*/
	%>
<%
	/*~END~*/
%>

<%
	String sCertType = DataConvert.toRealString(iPostChange,request.getParameter("CertType"));
	String sCertID = DataConvert.toRealString(iPostChange,request.getParameter("CertID"));
	ASResultSet rs = Sqlca.getResultSet("select CustomerName from CUSTOMER_INFO where CertType='"+sCertType+"' and CertID='"+sCertID+"'");
	String sCustomerName="";
	if (rs.next())
	{
		sCustomerName=rs.getString("CustomerName");
	}else
	{
%>
		<script language=javascript>
			self.close();
		</script>
	<%
		}
		rs.getStatement().close();
	%>
<script	language=javascript>
	self.returnValue = "<%=sCustomerName%>"
	self.close();
</script>
<%@	include file="/IncludeEnd.jsp"%>
