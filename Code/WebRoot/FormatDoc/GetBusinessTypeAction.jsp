<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.17
		Tester:
		Content: �������ݵ�FORMATDOC_DATA
		Input Param:
			DocID:    formatdoc_catalog�е��ĵ���𣨵��鱨�棬�����鱨�棬...)
			ObjectNo��ҵ����ˮ��
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<% 	
		
	//����������	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 		//ҵ����ˮ��
	String sBusinessType = "",sCreditAggreement = "",sCustomerID="",sCustomerType="";
	double dBailRatio = 0.0;
	String sReturn = "";
	String sSql = "select BusinessType,BailRatio,CreditAggreement,CustomerID from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{ 
		sBusinessType = rs.getString("BusinessType");
		dBailRatio = rs.getDouble("BailRatio");
		sCreditAggreement = rs.getString("CreditAggreement");
		sCustomerID = rs.getString("CustomerID");
		if(sBusinessType == null) sBusinessType = "";
		if(sCreditAggreement == null) sCreditAggreement = "";
		if(sCustomerID == null) sCustomerID = "";
	}
	rs.getStatement().close();

	sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'");
	if(sCustomerType == null) sCustomerType = "";
	
	sSql = "select CustomerScale from Customer_Info where CustomerID='"+sCustomerID+"'";
	String sCustomerScale = Sqlca.getString(sSql);
	if(sCustomerScale == null) sCustomerScale = "";

	if(dBailRatio == 100) sReturn = "1";//�ͷ���ҵ��
	else if(!sCreditAggreement.equals("")) sReturn = "2";//��������ҵ�� 
	else if(sBusinessType.equals("1020010")) sReturn = "3";//��Ʊ����ҵ��
	else if(sBusinessType.startsWith("3")) sReturn = "4";//����ҵ��
	else if (sCustomerType.equals("03"))  sReturn = "8";//���˿ͻ�
	else if (!sCustomerScale.equals("")&&sCustomerScale.startsWith("02")) sReturn = "9";
	else sReturn = "5";//������֮����Ŵ�ҵ��
		
%>

<script language="JavaScript">
	self.returnValue="<%=sReturn%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>