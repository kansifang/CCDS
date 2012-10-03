/*
		Author: --zywei 2006-1-18
		Tester:
		Describe: --ȡ��ҵ��������
		Input Param:
				ObjectType����������
				RelaObjectType��������������
				ObjectNo��������
		Output Param:
				SerialNo��ҵ��������
		HistoryLog: lpzhang 2009-9-3 ��������ҵ��
					xhyong 2009/10/14 �޸����鷽����ǩ�ж�
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetRelativeSerialNo extends Bizlet 
{
	public Object run(Transaction Sqlca) throws Exception
	{
		//��ȡ����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sRelaObjectType = (String)this.getAttribute("RelaObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sRelaObjectType == null) sRelaObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//���������SQL���
		String sSerialNo = "";
		String sRelativeSerialNo = "";
		//��ѯ�������Ӧ��ҵ�������ˮ�ţ����Ŷ����ˮ�š��ʲ����鷽����
		if(sObjectType.equals("CreditApply"))
		{	
			//��������Ϊ���Ŷ�ȶ���
			if(sRelaObjectType.equals("CreditLine"))
			{
				//����������ˮ�Ż�����Ŷ����ˮ��
				sSerialNo =  Sqlca.getString("select CreditAggreement from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'"); 
			}

			//��������Ϊ�ʲ����鷽������
			if(sRelaObjectType.equals("NPAReformApply"))
			{
				//����������ˮ�Ż���ʲ����鷽����ˮ��
				sSerialNo =  Sqlca.getString("select ObjectNo from APPLY_RELATIVE where SerialNo = '"+sObjectNo+"' and ObjectType = 'CapitalReform'"); 
			}
			
			//��������Ϊ����
			if(sRelaObjectType.equals("BusinessReApply"))
			{
				//����������ˮ�Ż����Ҫ�����������ˮ��
				sSerialNo =  Sqlca.getString("select ObjectNo from APPLY_RELATIVE where SerialNo = '"+sObjectNo+"' and ObjectType = 'BusinessReApply'"); 
			}
			
			//��������Ϊ��ȵ���
			if(sRelaObjectType.equals("CLBusinessChange"))
			{
				//����������ˮ�Ż����Ҫ�����������ˮ��
				sSerialNo =  Sqlca.getString("select ObjectNo from APPLY_RELATIVE where SerialNo = '"+sObjectNo+"' and ObjectType = 'CLBusinessChange'"); 
			}
			//��������Ϊũ������С����
			if(sRelaObjectType.equals("AssureAgreement"))
			{
				//����������ˮ�Ż�����Ŷ����ˮ��
				sSerialNo =  Sqlca.getString("select AssureAgreement from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'");
			}
			//��������Ϊũ�����ö�ȹ�ͬ��
			if(sRelaObjectType.equals("CommunityAgreement"))
			{
				//����������ˮ�Ż�����Ŷ����ˮ��
				sSerialNo =  Sqlca.getString("select CommunityAgreement from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'");
			}
		}
		
		//��ѯ��������������Ӧ��ҵ�������ˮ�ţ����Ŷ����ˮ�š��ʲ����鷽����
		if(sObjectType.equals("ApproveApply") || sObjectType.equals("ApproveApplyNo"))
		{	
			//��������Ϊ�������
			if(sRelaObjectType.equals("CreditApply"))
			{
				//�����������������ˮ�Ż��������ˮ��
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo = '"+sObjectNo+"'"); 
			}
			
			if(sObjectType.equals("ApproveApply"))
			{			
				//��������Ϊ���Ŷ�ȶ���
				if(sRelaObjectType.equals("CreditLine"))
				{
					//�����������������ˮ�Ż�����Ŷ����ˮ��
					sSerialNo =  Sqlca.getString("select CreditAggreement from BUSINESS_APPROVE where SerialNo = '"+sObjectNo+"'"); 
				}
	
				//��������Ϊ�ʲ����鷽������
				if(sRelaObjectType.equals("NPAReformApply"))
				{
					//�����������������ˮ�Ż���ʲ����鷽����ˮ��
					sSerialNo =  Sqlca.getString("select ObjectNo from APPROVE_RELATIVE where SerialNo = '"+sObjectNo+"' and ObjectType = 'CapitalReform'"); 
				}
			}			
		}
		
		//��ѯ��ͬ���Ӧ��ҵ�������ˮ�ţ����Ŷ����ˮ�š��������������ˮ�š�������ˮ�š��ʲ����鷽����
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan"))
		{
			
			//��������Ϊ�������
			if(sRelaObjectType.equals("CreditApply"))
			{
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				sRelativeSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'"); 
				//�����������������ˮ�Ż��������ˮ��
				//sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo = '"+sRelativeSerialNo+"'");
				//�޸�Ϊȥ������������� modified by zrli 20090709
				sSerialNo = sRelativeSerialNo;
			}
			
			//��������Ϊ���������������
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'"); 
			}

			//��������Ϊ���Ŷ�ȶ���
			if(sRelaObjectType.equals("CreditLine"))
			{
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				sSerialNo =  Sqlca.getString("select CreditAggreement from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'"); 
			}

			//��������Ϊ�ʲ����鷽������
			if(sRelaObjectType.equals("NPAReformApply"))
			{
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				sSerialNo =  Sqlca.getString("select ObjectNo from CONTRACT_RELATIVE where SerialNo = '"+sObjectNo+"' and ObjectType = 'CapitalReform'"); 
			}
			
		}
				
		//��ѯ�������Ӧ��ҵ�������ˮ�ţ���ͬ�����������룩
		if(sObjectType.equals("PutOutApply"))
		{
			//��������Ϊ�������
			if(sRelaObjectType.equals("CreditApply"))
			{
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				sRelativeSerialNo =  Sqlca.getString("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'"); 
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sRelativeSerialNo+"'"); 
				
			}
			
			//��������Ϊ���������������
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				sRelativeSerialNo =  Sqlca.getString("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'"); 
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sRelativeSerialNo+"'"); 
			}
			
			//��������Ϊ��ͬ����
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				sSerialNo =  Sqlca.getString("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'"); 
			}		
			//��������Ϊ��ȶ���
			if(sRelaObjectType.equals("CreditLine"))
			{
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				sSerialNo =  Sqlca.getString("select CreditAggreement from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'"); 
			}
		}
							
		//��ѯ������Ӧ��ҵ�������ˮ�ţ���ͬ�����ʣ�
		if(sObjectType.equals("BusinessDueBill"))
		{
			//��������Ϊ�������
			if(sRelaObjectType.equals("CreditApply"))
			{
				//���ݽ����ˮ�Ż�ú�ͬ��ˮ��
				sRelativeSerialNo =  Sqlca.getString("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo = '"+sObjectNo+"'"); 
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				sRelativeSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sRelativeSerialNo+"'"); 
				//�����������������ˮ�Ż��������ˮ��
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo = '"+sRelativeSerialNo+"'"); 
			}
			
			//��ѯ������Ӧ�������������
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//���ݽ����ˮ�Ż�ú�ͬ��ˮ��
				sRelativeSerialNo =  Sqlca.getString("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo = '"+sObjectNo+"'"); 
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sRelativeSerialNo+"'"); 
			}
			
			//��������Ϊ��ͬ����
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo = '"+sObjectNo+"'"); 
			}
		}
			
		if(sObjectType.equals("ContractModifyApply")){
			if(sRelaObjectType.endsWith("BusinessContract")){
				sSerialNo = Sqlca.getString("select distinct RelativeNo from CONTRACT_MODIFY where SerialNo = '"+sObjectNo+"'");
			}
		}
		
		//add by hlzhang 20120808 ���������޸Ļ�ȡ������ͬ��
		if(sObjectType.equals("DataModifyApply")){
			if(sRelaObjectType.endsWith("BusinessContract")){
				sSerialNo = Sqlca.getString("select distinct RelativeNo from DATA_MODIFY where SerialNo = '"+sObjectNo+"'");
			}
		}
		
		return sSerialNo;
	}
}