<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-3
		Tester:
		Describe:
			ͨ���û�����Ŀͻ����CustomerId��CUSTOMER_INFO����ȡ�ͻ�����CustomerName��
			�������޴˿ͻ����ϣ�����������ֵ����NULL��

		Input Param:
			CustomerID: �ͻ����
		Output Param:
			CustomerName: �ͻ�����

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
			alert("�Բ���,ϵͳ���޴˿ͻ����[<%=sCustomerID%>]�ļ�¼��Ϣ�����ʵ��");
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
