<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: zywei 2006-08-11
			Tester:
			Describe:
		���ͻ��Ƿ��Ѿ������Ŵ���ϵ

			Input Param:					
		CertType: ֤������
		CertID:֤������
			Output Param:
		Message: ���ع����ͻ����RelativeID ���Ϊ�����ʾ��鲻ͨ��,����ʾ��Ϣ
			HistoryLog:
		*/
	%>
<%
	/*~END~*/
%>

<%
	//��ȡҳ�����	
	String sCertType = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertType"));
	String sCertID = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertID"));
	
	//�������
	String sRelativeID = "";
	String sSql = "";
	String sMessage = "";	
	ASResultSet rs = null;
	
	//����֤�����ͺ�֤����ţ���ͻ����ƻ�ȡ�ͻ����
	sSql = 	" select CustomerID from CUSTOMER_INFO "+
	" where CertType = '"+sCertType+"' "+
	" and CertID = '"+sCertID+"' ";
	rs = Sqlca.getResultSet(sSql);
	if (rs.next())
		sRelativeID = rs.getString("CustomerID");
	rs.getStatement().close();
	
	if(sRelativeID == null || sRelativeID.equals(""))
		sRelativeID = DBFunction.getSerialNo("CUSTOMER_INFO","CustomerID",Sqlca);
%>
<script	language=javascript>	
	self.returnValue = "<%=sRelativeID%>"
	self.close();
</script>
<%@	include file="/IncludeEnd.jsp"%>