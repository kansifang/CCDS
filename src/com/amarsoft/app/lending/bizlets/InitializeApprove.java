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

public class InitializeApprove extends Bizlet 
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
		//��ȡ��������
		String sApproveType = (String)this.getAttribute("ApproveType");
		//��ȡ������
		String sDisagreeOpinion = (String)this.getAttribute("DisagreeOpinion");
				
		String sSerialNo = "";
		
		//����ֵת��Ϊ���ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sApplyType == null) sApplyType = "";
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		if(sApproveType == null) sApproveType = "";
		if(sDisagreeOpinion == null) sDisagreeOpinion = "";
		
		/*
		 * 1�������ŷ�����ϸ���б��ݣ����� AddCLInfoLog.java		  
		*/
		
		Bizlet bzAddCLInfoLog = new AddCLInfoLog();
		bzAddCLInfoLog.setAttribute("ObjectType","CreditApply"); 
		bzAddCLInfoLog.setAttribute("ObjectNo",sObjectNo);
		bzAddCLInfoLog.setAttribute("Action","AddApprove");
		bzAddCLInfoLog.setAttribute("UserID",sUserID);
		bzAddCLInfoLog.setAttribute("OrgID",sOrgID);
		bzAddCLInfoLog.run(Sqlca);
		
		/*
		 * 2�������������������ʼ�������� InitializeFlow.java		  
		*/
		Bizlet bzAddApprove = new AddApproveInfo();
		bzAddApprove.setAttribute("ObjectType",sObjectType); 
		bzAddApprove.setAttribute("ObjectNo",sObjectNo);
		bzAddApprove.setAttribute("ApproveType",sApproveType);
		bzAddApprove.setAttribute("DisagreeOpinion",sDisagreeOpinion);
		bzAddApprove.setAttribute("UserID",sUserID);
		sSerialNo = (String)bzAddApprove.run(Sqlca);
		
		/*
		 * 3������ InitializeFlow.java��������������������̳�ʼ��		  
		*/
		Bizlet bzInitFlow = new InitializeFlow();
		bzInitFlow.setAttribute("ObjectType",sObjectType); 
		bzInitFlow.setAttribute("ObjectNo",sSerialNo); 
		bzInitFlow.setAttribute("ApplyType",sApplyType);
		bzInitFlow.setAttribute("FlowNo",sFlowNo);
		bzInitFlow.setAttribute("PhaseNo",sPhaseNo);
		bzInitFlow.setAttribute("UserID",sUserID);
		bzInitFlow.setAttribute("OrgID",sOrgID);
		bzInitFlow.run(Sqlca);
		  
	    return sSerialNo;
	    
	 }

}
