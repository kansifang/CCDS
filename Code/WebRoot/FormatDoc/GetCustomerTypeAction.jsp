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
	String sCustomerID="",sCustomerType="";
	String sReturn = "";
	String sSql = "select CustomerID from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerID = rs.getString("CustomerID");
		if(sCustomerID == null) sCustomerID = "";
	}
	rs.getStatement().close();
	
	sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'");
	
	if(sCustomerType == null) sCustomerType = "";
	
	
	else if (sCustomerType.startsWith("03"))  sReturn = "2";//���˿ͻ�����ҵ��
	else sReturn = "1";//��˾�ͻ�����ҵ��		
%>

<script language="JavaScript">
	self.returnValue="<%=sReturn%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>