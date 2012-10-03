package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.finance.Report;

public class InitFinanceReport extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sReportDate = (String)this.getAttribute("ReportDate");
		String sReportScope = (String)this.getAttribute("ReportScope");
		String sWhere = (String)this.getAttribute("Where");
		String sNewReportDate = (String)this.getAttribute("NewReportDate");
		String sActionType = (String)this.getAttribute("ActionType");
		String sOrgID = (String)this.getAttribute("OrgID");
		String sUserID = (String)this.getAttribute("UserID");
		
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null)	sObjectType = "";
		if(sReportDate == null)	sReportDate = "";
		if(sReportScope == null) sReportScope = "";
		if(sWhere == null)	sWhere = "";
		if(sNewReportDate == null)	sNewReportDate = "";
		if(sActionType==null)	sActionType = "";	
		sWhere = StringFunction.replace(sWhere,"^","=");

		String sSql = "";
		if(sActionType.equals("AddNew"))
		{
			// ����ָ��MODEL_CATALOG��where��������һ���±���		
			Report.newReports(sObjectType,sObjectNo,sReportScope,sWhere,sReportDate,sOrgID,sUserID,Sqlca);
		}else if(sActionType.equals("Delete"))
		{
			// ɾ��ָ��������������ڵ�һ������ 
			Report.deleteReports(sObjectType,sObjectNo,sReportScope,sReportDate,Sqlca);	
			sSql = " delete from CUSTOMER_FSRECORD "+
					" where CustomerID = '"+sObjectNo+"' "+
					" and ReportDate = '"+sReportDate+"' "+
					" and ReportScope = '"+sReportScope+"' ";
			Sqlca.executeSQL(sSql);
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
			sSql = " update REPORT_RECORD "+
					" set ReportDate='"+sNewReportDate+"' "+
					" where ObjectNo='"+sObjectNo+"' "+
					" and ReportDate='"+sReportDate+"'"+
					" and ReportScope = '"+sReportScope+"' ";    	
	    	Sqlca.executeSQL(sSql);
		}
				
		return "ok";
	}		
}
