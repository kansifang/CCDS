/*
		Author: --xhyong 2011/07/14
		Tester:
		Describe: --�ж������������Ƿ����ĳһ��ɫ
		Input Param:
				ObjectType����������
				ObjectNo��������
				RoleID:��ɫID
		Output Param:
				ReturnValue��1 ��,2 ��
		HistoryLog: 
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishCreditHaseThisRole extends Bizlet 
{
	public Object run(Transaction Sqlca) throws Exception
	{
		//��ȡ����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sRoleID = (String)this.getAttribute("RoleID");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sRoleID == null) sRoleID = "";
		
		//���������SQL���
		String sApplySerialNo = "";
		String sContractSerialNo = "";
		String sReturnValue="2";
		String sCreditAggreement = "";
		//��ѯ�������Ӧ��ҵ�������ˮ�ţ���ͬ�����������룩
		if("PutOutApply".equals(sObjectType))
		{
			//���ݳ�����ˮ�Ż�ö�Ⱥ�ͬ��ˮ��
			sCreditAggreement =  Sqlca.getString("select distinct CreditAggreement from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'");
			if(sCreditAggreement == null) sCreditAggreement = "";
			if(!"".equals(sCreditAggreement))
			{
				//��ͬ��ˮ��Ϊ��Ⱥ�ͬ��ˮ��
				sContractSerialNo =  sCreditAggreement;
			}else
			{
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				sContractSerialNo =  Sqlca.getString("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'");
			}
			//���ݺ�ͬ��ˮ�Ż��������ˮ��
			sApplySerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sContractSerialNo+"'");
			//����������ˮ���жϸ����������������Ƿ����ĳһ��ɫ
			sReturnValue = Sqlca.getString("select distinct 1 from USER_ROLE where UserID in (select ApproveUserID from BUSINESS_APPLY where Serialno = '"+sApplySerialNo+"') and RoleID like '%"+sRoleID+"'");
		}else if("CreditApproveApply".equals(sObjectType))
		{
			//����������ˮ���жϸ����������������Ƿ����ĳһ��ɫ
			sReturnValue = Sqlca.getString("select distinct 1 from USER_ROLE where UserID in (select ApproveUserID from BUSINESS_APPLY where Serialno = '"+sObjectNo+"') and RoleID like '%"+sRoleID+"'");
		}
		return sReturnValue;
	}
}