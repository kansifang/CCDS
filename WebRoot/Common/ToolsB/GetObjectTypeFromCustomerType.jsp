<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
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
			alert("�Բ���,ϵͳ���޴˿ͻ�����[<%=sCustomerType%>]�ļ�¼��Ϣ�����ʵ��");
			self.close();
		</script>
	<%
		}
		if(sObjectType==null || sObjectType.equals("")){
	%>
		<script language=javascript>
			alert("��Ϊ[<%=sCustomerType%>]�����������(CODE_LIBRARY.CustomerType.Attribute1)");
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
