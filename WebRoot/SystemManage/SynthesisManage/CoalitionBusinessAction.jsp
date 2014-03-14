<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:mfhu  2005-3-17
 * Tester:
 *
 * Content:   	ҵ��ϲ�
 * Input Param:
 *				
 * Output param:
 *			
 * 
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//��ȡ�������ϲ�ǰ�ͻ���š��ϲ�ǰ�ͻ����ơ��ϲ���Ŀͻ���š��ϲ���ͻ����ơ��ϲ���֤�����͡��ϲ���֤����š��ϲ��������
	String sFromCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromCustomerID"));	    
	String sFromCustomerName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromCustomerName"));
	String sToCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCustomerID"));	
	String sToCustomerName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCustomerName"));	
	String sToCertType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCertType"));	
	String sToCertID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCertID"));	
	String sToLoanCardNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToLoanCardNo"));	
	//����ֵת��Ϊ���ַ���
	if(sFromCustomerID == null) sFromCustomerID = "";
	if(sFromCustomerName == null) sFromCustomerName = "";
	if(sToCustomerID == null) sToCustomerID = "";
	if(sToCustomerName == null) sToCustomerName = "";
	if(sToCertType == null) sToCertType = "";
	if(sToCertID == null) sToCertID = "";
	if(sToLoanCardNo == null) sToLoanCardNo = "";
		
	//�������
	String sFlag = "";	
	String sSql = "";	
	//ת����־��Ϣ
	String sChangeReason = "ҵ��ϲ�������Ա����:"+CurUser.UserID+"   ������"+CurUser.UserName+"   �������룺"+CurOrg.OrgID+"   �������ƣ�"+CurOrg.OrgName;
	String sInputDate   = StringFunction.getToday();

	//���ﴦ��ʼ
	boolean bOld = Sqlca.conn.getAutoCommit();
	Sqlca.conn.setAutoCommit(false);
	try
	{
		//���������
		Sqlca.executeSQL("update BUSINESS_APPLY set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//����������
		Sqlca.executeSQL("update BUSINESS_APPROVE set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//���º�ͬ��
		Sqlca.executeSQL("update BUSINESS_CONTRACT set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//�������Ŷ�ȱ�
		Sqlca.executeSQL("update CL_INFO set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//���³��˱�
		Sqlca.executeSQL("update BUSINESS_PUTOUT set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//���½�ݱ�
		Sqlca.executeSQL("update BUSINESS_DUEBILL set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"',UpdateDate='"+StringFunction.getToday()+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//������ˮ��
		Sqlca.executeSQL("update BUSINESS_WASTEBOOK set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		
		//���µ�����ͬ�͵�����Ϣ
		Sqlca.executeSQL("update GUARANTY_CONTRACT set GuarantorID = '"+sToCustomerID+"',GuarantorName = '"+sToCustomerName+"',CertType = '"+sToCertType+"',CertID = '"+sToCertID+"',LoanCardNo = '"+sToLoanCardNo+"' where GuarantorID = '"+sFromCustomerID+"' ");
		Sqlca.executeSQL("update GUARANTY_INFO set OwnerID='"+sToCustomerID+"',OwnerName='"+sToCustomerName+"',CertType = '"+sToCertType+"',CertID = '"+sToCertID+"',LoanCardNo = '"+sToLoanCardNo+"' where OwnerID = '"+sFromCustomerID+"' ");
		
		//�����Ҫ�ϲ��������ݱ��еĿͻ������±���������������
		
		
		//��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
        String sSerialNo1 =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
        		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
                " VALUES('UniteBusiness','"+sFromCustomerID+"','"+sSerialNo1+"','"+sFromCustomerID+"','"+sFromCustomerName+"','"+sToCustomerID+"', "+
                " '"+sToCustomerName+"','','','','','"+sChangeReason+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
        Sqlca.executeSQL(sSql);
		sFlag = "TRUE";
		//�����ύ
		Sqlca.conn.commit();
		Sqlca.conn.setAutoCommit(bOld);
	}
	catch(Exception e)
	{
		//����ʧ�ܣ����ݻع�
		sFlag="FALSE";
		Sqlca.conn.rollback();
		Sqlca.conn.setAutoCommit(bOld);
		throw new Exception("������ʧ�ܣ�"+e.getMessage());
	}
%>
<script language=javascript>
	self.returnValue="<%=sFlag%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>