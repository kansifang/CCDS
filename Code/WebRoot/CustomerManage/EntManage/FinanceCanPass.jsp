<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: �ж϶�Ӧ�ı��������Ƿ����
		Input Param:
			                
		Output param:
		History Log: 
			���ø��������һ����������ɾ��һ�ױ���
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������²����ж�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<html>
<head>
<title>������²����ж�</title>
<%
    //�������
	String sSql = "",sObjectNo = "",sReportDate = "",sReportScope = "",sReturnValue = "pass";
	ASResultSet rs = null;
	//����������
	//������ ��ʱΪ�ͻ���
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//���ҳ�����
	sReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportDate"));
	sReportScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportScope"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sReportScope == null) sReportScope = "";
	if(sReportDate == null)	sReportDate = "";
	
	//ȡ���Ƿ��е��ڵĲ��񱨱�
	sSql = 	" select RecordNo from CUSTOMER_FSRECORD "+
			" where CustomerID = '"+sObjectNo+"' "+			
			" and ReportDate = '"+sReportDate+"' and ReportScope = '"+sReportScope+"' ";

	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
		sReturnValue = "refuse";
	}
	rs.getStatement().close();
	//out.println(sSql);
%>
<script language=javascript>
	self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>