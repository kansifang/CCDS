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
		History Log: zywei 2005/09/10 �ؼ����
	 */
	%>
<%/*~END~*/%>


<html>
<head>
<title>���¿ͻ�����</title>
<%
	String sSql = "",sReturnValue = "";
	ASResultSet rs = null;
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerType"));	
	String sToday = StringFunction.getToday();
	try
	{
		sSql = 	" update CUSTOMER_INFO set CustomerType = '"+sCustomerType+"',"+
				" InputDate ='"+sToday+"', "+
				" InputOrgID ='"+CurOrg.OrgID+"', "+
				" InputUserID ='"+CurUser.UserID+"' "+
				" where CustomerID = '"+sCustomerID+"'";
		Sqlca.executeSQL(sSql);
		
		sSql = 	" update ENT_INFO set OrgNature = '"+sCustomerType+"', "+
				" UpdateDate ='"+sToday+"', "+
				" UpdateOrgID ='"+CurOrg.OrgID+"', "+
				" UpdateUserID ='"+CurUser.UserID+"' "+
				" where CustomerID = '"+sCustomerID+"'";
		Sqlca.executeSQL(sSql);
		sReturnValue = "_TRUE_";
	}catch(Exception e)
	{
		sReturnValue = "_FALSE_";
	}
%>


<script language=javascript>
	self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>