<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   JBai  2005.12.20
		Tester:
		Content: ����ͻ����
		Input Param:
			
		Output param:
			CustomerID���ͻ����
		History Log: 
			
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>��ÿͻ����</title>

<%	
	//����������ͻ����
	String sCustomerID = DBFunction.getSerialNo("CUSTOMER_INFO","CertID",Sqlca);
	sCustomerID = "X"+sCustomerID;
%>

<script language=javascript>
	self.returnValue = "<%=sCustomerID%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
