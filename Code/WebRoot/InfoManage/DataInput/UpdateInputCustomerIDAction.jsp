<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.8
		Tester:
		Content: ���¿ͻ�����
		Input Param:
			                CustomerID:�ͻ����
			                CustomerType:�ͻ�����
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>���¿ͻ�����</title>
<%
	String sSql;
	ASResultSet rs = null;
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));	
	String SerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));	
	String sToday = StringFunction.getToday();

	sSql = 	" Update BUSINESS_CONTRACT set CustomerID = '"+sCustomerID+"',"+
			" UpdateDate ='"+sToday+"' "+
			" where SerialNo = '"+SerialNo+"'";
	Sqlca.executeSQL(sSql);
	
%>
<script language=javascript>
	self.returnValue = "succeed";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>