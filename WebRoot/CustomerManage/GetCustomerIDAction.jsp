<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: ��ÿͻ����
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
	String sCustomerID = DBFunction.getSerialNo("CUSTOMER_INFO","CustomerID",Sqlca);
%>

<script language=javascript>
	self.returnValue = "<%=sCustomerID%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
