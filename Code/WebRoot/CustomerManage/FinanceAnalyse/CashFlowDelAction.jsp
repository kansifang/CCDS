<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: �ֽ���Ԥ��
		Input Param:
			CustomerID �� ��ǰ�ͻ����
			BaseYear   : ��׼���:�������������һ��  
			YearCount  : Ԥ������:default=1
			ReportScope: ����ھ�	           
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    �µİ汾�ĸ�д
	 */
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��ֽ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    //���ҳ�����
 	String sCustomerID = DataConvert.toRealString(CurPage.getParameter("CustomerID"));
	String sBaseYear = DataConvert.toRealString(CurPage.getParameter("BaseYear"));
	String sYearCount = DataConvert.toRealString(CurPage.getParameter("YearCount"));
	String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));   
    //����������

%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=ִ��SQL���;]~*/%>

<%
	Sqlca.executeSQL("delete from CashFlow_Parameter where CustomerID = '" + sCustomerID + "' and BaseYear = " + sBaseYear+" and ReportScope='"+sReportScope+"'");
	Sqlca.executeSQL("delete from CashFlow_Data where CustomerID = '" + sCustomerID + "' and BaseYear = " + sBaseYear +" and ReportScope='"+sReportScope+"' and FCN = " + sYearCount);
	Sqlca.executeSQL("delete from CashFlow_Record where CustomerID = '" + sCustomerID + "' and BaseYear = " + sBaseYear +" and ReportScope='"+sReportScope+"' and FCN = " + sYearCount);
%>
<%/*~END~*/%>
<body class="ListPage" leftmargin="0" topmargin="0" >
</body>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����ҳ��;]~*/%>

<script language="JavaScript">
	alert(getBusinessMessage('187'));//�ֽ���Ԥ���¼ɾ����ϣ�
	OpenPage("/CustomerManage/FinanceAnalyse/CashFlowList.jsp?","_self","");
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
