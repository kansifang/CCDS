<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: ������²���
		Input Param:
             ObjectNo ��   ������ ĿǰĬ��Ϊ�ͻ����
             ObjectType �� �������� ĿǰĬ��CustomerFS
             ReportDate �� �����ֹ����    
		Output param:
		History Log: 
			���ø��������һ����������ɾ��һ�ױ���
			�Զ��������������� zywei 2007/10/10
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>������²���</title>
<%
	String sObjectType = "",sObjectNo = "",sWhere = "",sReportDate = "",sOrgID = "",sUserID = "",sActionType = "";
	String sReportScope = "",sSql = "",sSql1 = "",sSql2 = "",sNewReportDate = "";
	//zywei 2007/10/10 �����������־
	String sDealFlag = "";
	//������ ��ʱΪ�ͻ���
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//�������� ��ʱ��ΪCustomerFS
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	sReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportDate"));
	sReportScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportScope"));
	sWhere = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Where"));
	sNewReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NewReportDate"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null)	sObjectType = "";
	if(sReportDate == null)	sReportDate = "";
	if(sReportScope == null) sReportScope = "";
	if(sWhere == null)	sWhere = "";
	if(sNewReportDate == null)	sNewReportDate = "";
	sWhere = StringFunction.replace(sWhere,"^","=");
	
	//�����������
	sActionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ActionType"));
	if(sActionType==null)	sActionType = "";	
	
	sOrgID = CurOrg.OrgID;
	sUserID = CurUser.UserID;
	
	//��������
	boolean bOld = Sqlca.conn.getAutoCommit();
    Sqlca.conn.setAutoCommit(false);

    try
    {
		if(sActionType.equals("AddNew"))
		{
			// ����ָ��MODEL_CATALOG��where��������һ���±���		
			Report.newReports(sObjectType,sObjectNo,sReportScope,sWhere,sReportDate,sOrgID,sUserID,Sqlca);
		}else if(sActionType.equals("Delete"))
		{
			// ɾ��ָ��������������ڵ�һ������ 
			Report.deleteReports(sObjectType,sObjectNo,sReportScope,sReportDate,Sqlca);	
			sSql2 = " delete from CUSTOMER_FSRECORD "+
					" where CustomerID = '"+sObjectNo+"' "+
					" and ReportDate = '"+sReportDate+"' "+
					" and ReportScope = '"+sReportScope+"' ";
			Sqlca.executeSQL(sSql2);
		}else if(sActionType.equals("ModifyReportDate"))
		{
			// ����ָ������Ļ���·� 
			sSql = 	" update CUSTOMER_FSRECORD "+
					" set ReportDate='"+sNewReportDate+"' "+
					" where CustomerID='"+sObjectNo+"' "+
					" and ReportDate='"+sReportDate+"' "+
					" and ReportScope = '"+sReportScope+"' ";
			Sqlca.executeSQL(sSql);
			
			// ����ָ������Ļ���·�
			sSql1 = " update REPORT_RECORD "+
					" set ReportDate='"+sNewReportDate+"' "+
					" where ObjectNo='"+sObjectNo+"' "+
					" and ReportDate='"+sReportDate+"'"+
					" and ReportScope = '"+sReportScope+"' ";    	
	    	Sqlca.executeSQL(sSql1);
		}
		
		//�����ύ
		Sqlca.conn.commit();
		Sqlca.conn.setAutoCommit(bOld);
		sDealFlag = "ok";		
    }catch(Exception e)
    {
        Sqlca.conn.rollback();
        Sqlca.conn.setAutoCommit(bOld);
        sDealFlag = "error";        
        throw new Exception("������ʧ�ܣ�"+e.getMessage());
    }
%>

<script language=javascript>
	self.returnValue = "<%=sDealFlag%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>