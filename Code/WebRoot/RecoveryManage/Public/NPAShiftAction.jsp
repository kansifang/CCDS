<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xxge 2004-11-25
 * Tester:
 *
 * Content:  �������ʲ��ƽ���ȫ���������º�ͬ��
 * Input Param:
 *		SerialNo����ͬ��ˮ��
 *		TraceOrgID����ȫ����
 *		ShiftType: �ƽ����ͣ�01�������ƽ���02���˻��ƽ���
 *		Type���ƽ�����1�������ƽ���2�������ƽ���
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//�������
	String sSql = "";    
	ASResultSet rs = null;
	double sBalance = 0;
	
	//��ͬ��ˮ�š���ȫ�������ƽ����͡��ƽ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 	
	String sTraceOrgID = DataConvert.toRealString(iPostChange,CurPage.getParameter("TraceOrgID"));
	String sShiftType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ShiftType"));
	String sType = DataConvert.toRealString(iPostChange,CurPage.getParameter("Type"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sTraceOrgID == null) sTraceOrgID = "";
	if(sShiftType == null) sShiftType = "";
	if(sType == null) sType = "";
	
   	if(sType.equals("1"))//���Ŵ����ƽ���ȫ��
   	{	        
        sSql = " select Balance from BUSINESS_CONTRACT where SerialNo='"+sSerialNo+"' ";
  		rs = Sqlca.getASResultSet(sSql);    
   		if(rs.next())
   		 	sBalance = rs.getDouble("Balance");        
		 rs.getStatement().close();
		       
        //���º�ͬ��
        sSql = " update BUSINESS_CONTRACT set ShiftBalance = "+sBalance+",ShiftType = '"+sShiftType+"',RecoveryOrgID = '"+sTraceOrgID+"' where SerialNo = '"+sSerialNo+"' ";
       	Sqlca.executeSQL(sSql);	 	
	%>
		<script language=javascript>
		    self.returnValue="true";
		    self.close();    
		</script>	
	<%
	}else //�ӱ�ȫ���˻ص��Ŵ���
	{	
		//���º�ͬ��
        sSql= " update BUSINESS_CONTRACT set ShiftBalance = 0.0,ShiftType = null,RecoveryOrgID = null where SerialNo = '"+sSerialNo+"' ";
       	Sqlca.executeSQL(sSql);	 	
	%>
		<script language=javascript>
		    self.returnValue="true";
		    self.close();    
		</script>
	<%
	}
	%>
	
<%@ include file="/IncludeEnd.jsp"%>
