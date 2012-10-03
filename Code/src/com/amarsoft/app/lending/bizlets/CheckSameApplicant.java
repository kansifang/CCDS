package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckSameApplicant extends Bizlet{

	public Object run(Transaction Sqlca) throws Exception {
		// TODO Auto-generated method stub
		
		//��ȡ��������ˮ�ţ��������ͣ������ţ��͹�ͬ������ID
		String sSerialNo = (String)this.getAttribute("SerialNo");		
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sApplicantID = (String)this.getAttribute("ApplicantID");						
		
		//����ֵת���ɿ��ַ���
		if(sSerialNo == null) sSerialNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sApplicantID == null) sApplicantID = "";
		
		//���������SQL��䡢���ؽ����ҵ��������
		String sSql = "";
		String sReturn = "";
		String sCustomerID = "";
		boolean sFlag = false;
		//�����������ѯ�����
		ASResultSet rs = null;
		//�ж��Ƿ���ڹ�ͬ������
		sSql = " select SerialNo,ApplicantID  from BUSINESS_APPLICANT where SerialNo <> '"+sSerialNo+"' "+
			   " and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' ";
		rs = Sqlca.getResultSet(sSql);
		while(rs.next()) 
		{
			//ȡ���ݿ��д��ڵĹ�ͬ������ID
			String sApplicantID1 = rs.getString("ApplicantID");
			if(sApplicantID1 ==null) sApplicantID1 = "";
			//����ù�ͬ�������Ѿ��������˳�ѭ��
			if(sApplicantID.equals(sApplicantID1))
			{
				sFlag = true;	
				break;		
			}			
		}
		rs.getStatement().close();
			
		//�жϹ�ͬ�������Ƿ����������ͬ  
		if(!sFlag)
		{	
			String sTableName="";
			//��ͬ�׶��ڲ�ͬ���в�ѯCustomerID
			if(sObjectType.equalsIgnoreCase("BusinessContract"))
			{
				sTableName = "BUSINESS_CONTRACT";
			}else if(sObjectType.equalsIgnoreCase("ApproveApply"))
			{
				sTableName = "BUSINESS_APPROVE";
			}else if(sObjectType.equalsIgnoreCase("CreditApply"))
			{
				sTableName = "BUSINESS_APPLY";
			}
			//���ȡ�ñ�����ִ��sql
			if(!sTableName.equals(""))
			{
				sSql = "select CustomerID from " + sTableName + " where SerialNo='"+sObjectNo+"' ";			
				sCustomerID = Sqlca.getString(sSql);
			}
			
			if(sCustomerID == null) sCustomerID="";
		}
		//�жϷ�����Ϣ
		if(sFlag)
			sReturn = "�Բ��𣬸��������Ѿ����ڣ�";
		else if(sApplicantID.equals(sCustomerID))
			sReturn = "�Բ��𣬹�ͬ�����˺�ҵ�������˲�����ͬ��";
		else
			sReturn = "SUCCESS";
		//����ֵ
		return sReturn;
	}

}
