<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: FMWu 2004-11-30
			Tester:
			Describe:
		ͨ���û�����Ŀͻ���CustomerID
		��CUSTOMER_INFO����ȡ�õ�֤������CertType��֤������CertId���ͻ�����CustomerName
		�������޴˿ͻ����ϣ�����������ֵ����NULL��

			Input Param:
		CustomerID: �ͻ����
			Output Param:
		CertType: ֤������
		CertID: ֤������
		CustomerName: �ͻ�����

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
