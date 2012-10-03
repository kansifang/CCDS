/*
		Author: --zywei 2005-08-09
		Tester:
		Describe: --��ʼ�������������������
		Input Param:
				ObjectType: ��������
				ObjectNo: ������
				ApplyType����������
				FlowNo�����̱��
				PhaseNo���׶α��
				UserID���û�����
				OrgID���û�����
				ApproveType����������
				DisagreeOpinion��������
		Output Param:
				SerialNo��������ˮ��
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializeCustomerInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//��������
		String sApplyType = (String)this.getAttribute("ApplyType");
		//���̱��
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//�׶α��
		String sPhaseNo = (String)this.getAttribute("PhaseNo");	
		//�û�����
		String sUserID = (String)this.getAttribute("UserID");
		//��������
		String sOrgID = (String)this.getAttribute("OrgID");

		//��������ͻ���Ϣ�������ͻ����͡��ͻ����ơ�֤�����͡�֤����š�����״̬���ͻ����
		String sCustomerType = (String)this.getAttribute("CustomerType");
		String sCustomerName = (String)this.getAttribute("CustomerName");	
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");	
		String sReturnStatus = (String)this.getAttribute("Status");
		String sCustomerID = (String)this.getAttribute("CustomerID");	
		String sCustomerScale = (String)this.getAttribute("CustomerScale");	
		
		String sSerialNo = "";
		
		//����ֵת��Ϊ���ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sApplyType == null) sApplyType = "";
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		
		if(sCustomerType == null) sCustomerType = "";
		if(sCustomerName == null) sCustomerName = "";	
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";	
		if(sReturnStatus == null) sReturnStatus = "";
		if(sCustomerID == null) sCustomerID = "";	
		if(sCustomerScale == null) sCustomerScale = "";	
		
		
		/*
		 * 1�����Ӷ�Ӧ�Ŀͻ���Ϣ		  
		*/
		
		Bizlet bzAddCusInfoLog = new AddCustomerAction();
		bzAddCusInfoLog.setAttribute("CustomerType",sCustomerType);
		bzAddCusInfoLog.setAttribute("CustomerName",sCustomerName);	
		bzAddCusInfoLog.setAttribute("CertType",sCertType);
		bzAddCusInfoLog.setAttribute("CertID",sCertID);	
		bzAddCusInfoLog.setAttribute("ReturnStatus",sReturnStatus);
		bzAddCusInfoLog.setAttribute("CustomerID",sCustomerID);	
		bzAddCusInfoLog.setAttribute("CustomerScale",sCustomerScale);	
		bzAddCusInfoLog.setAttribute("UserID",sUserID);	
		bzAddCusInfoLog.setAttribute("OrgID",sOrgID);	
		bzAddCusInfoLog.run(Sqlca);
		
		/*
		 * 3������ InitializeFlow.java��������������������̳�ʼ��		  
		*/
		Bizlet bzInitFlow = new InitializeFlow();
		bzInitFlow.setAttribute("ObjectType",sObjectType); 
		bzInitFlow.setAttribute("ObjectNo",sCustomerID); 
		bzInitFlow.setAttribute("ApplyType",sApplyType);
		bzInitFlow.setAttribute("FlowNo",sFlowNo);
		bzInitFlow.setAttribute("PhaseNo",sPhaseNo);
		bzInitFlow.setAttribute("UserID",sUserID);
		bzInitFlow.setAttribute("OrgID",sOrgID);
		bzInitFlow.run(Sqlca);
		  
	    return sSerialNo;
	    
	 }

}
