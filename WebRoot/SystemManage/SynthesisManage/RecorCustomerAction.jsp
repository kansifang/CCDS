<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  mjpeng 2011-1-19
		Tester:
		Content:  --�õ��ͻ�����
		Input Param:
	        CustomerID���ͻ�����
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ���ʷ�޸ļ�¼"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//����������,�ͻ����Ŵ��ţ�����˴��ţ���֯����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	//����ֵת��Ϊ���ַ���
	if(sCustomerID == null) sCustomerID = "";           
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ȡ����ֵ ;]~*/%>
<%     
	ASResultSet rs = null;
	String sSql = "select * From Customer_Info where CustomerID = '"+sCustomerID+"'";
	String sUserID = CurUser.UserID ;
	String sBelongOrg = CurOrg.OrgID ;
	String sEfficientDate =StringFunction.getToday() ;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		
		String sSql1 = "insert into CUSTOMER_CHANGELOG values('"+sCustomerID+"','"+DataConvert.toString(rs.getString("CUSTOMERNAME"))+"','"+DataConvert.toString(rs.getString("CUSTOMERTYPE"))+"','"+
						DataConvert.toString(rs.getString("CERTTYPE"))+"','"+DataConvert.toString(rs.getString("CERTID"))+"','"+DataConvert.toString(rs.getString("LOANCARDNO"))+"','"
						+sUserID+"','"+sBelongOrg+"','"+sEfficientDate+"')";
		Sqlca.executeSQL(sSql1);
	}
	rs.close();
    
%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>
