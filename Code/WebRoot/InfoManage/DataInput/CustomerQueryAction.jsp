<%
/* Copyright 2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xxge 2004-11-25
 * Tester:
 *
 * Content: ��ѯ�ͻ���Ϣ�Ƿ����,�ͻ������Ƿ�Ϊ��
 * Input Param:
 *	CustomerID���ͻ���
 *	
 * Output param:
 * History Log:  
 *	      
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	ASResultSet rs;
	int sCount=0;
	String sCustomerType = "NOEXSIT";
	
	//�ͻ���
	String sCustomerID = DataConvert.toRealString(iPostChange,request.getParameter("CustomerID")); 	
	String sSql =  "select CustomerType from Customer_Info where CustomerID ='"+sCustomerID+"' ";
	
   	rs = Sqlca.getASResultSet(sSql); 
   	if(rs.next()) {
		sCustomerType = rs.getString("CustomerType");
		if (sCustomerType == null) sCustomerType = "";
		if (sCustomerType.equals("")) sCustomerType="EMPTY";
	}	
	rs.getStatement().close();
%>
	<script language=javascript>
		self.returnValue="<%=sCustomerType%>";
		self.close();    
	</script>
<%@ include file="/IncludeEnd.jsp"%>
