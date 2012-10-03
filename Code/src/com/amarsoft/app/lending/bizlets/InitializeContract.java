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

public class InitializeContract extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//�û�����
		String sUserID = (String)this.getAttribute("UserID");
		//��������
		String sOrgID = (String)this.getAttribute("OrgID");
				
		String sSerialNo = "";
		
		//����ֵת��Ϊ���ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
				
		/*
		 * 1�������ŷ�����ϸ���б��ݣ����� AddCLInfoLog.java		  
		*/
		
		/*Bizlet bzAddCLInfoLog = new AddCLInfoLog();
		bzAddCLInfoLog.setAttribute("ObjectType",sObjectType); 
		bzAddCLInfoLog.setAttribute("ObjectNo",sObjectNo);
		bzAddCLInfoLog.setAttribute("Action","AddContract");
		bzAddCLInfoLog.setAttribute("UserID",sUserID);
		bzAddCLInfoLog.setAttribute("OrgID",sOrgID);
		bzAddCLInfoLog.run(Sqlca);*/
		
		/*
		 * 2�������������������ʼ�������� InitializeFlow.java		  
		*/
		Bizlet bzAddContract = new AddContractInfo();
		bzAddContract.setAttribute("ObjectType",sObjectType); 
		bzAddContract.setAttribute("ObjectNo",sObjectNo);
		bzAddContract.setAttribute("UserID",sUserID);
		sSerialNo = (String)bzAddContract.run(Sqlca);
		  
	    return sSerialNo;
	    
	 }

}
