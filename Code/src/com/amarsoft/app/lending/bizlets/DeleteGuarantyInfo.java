package com.amarsoft.app.lending.bizlets;
/*
		Author: --zywei 2005-12-10
		Tester:
		Describe: --ɾ��������ͬ;
		Input Param:
				ObjectType: --��������(ҵ��׶�)��
				ObjectNo: --�����ţ�����/����/��ͬ��ˮ�ţ���
				SerialNo:--������ͬ��
		Output Param:
				return������ֵ��SUCCEEDED --ɾ���ɹ���

		HistoryLog:
 */
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteGuarantyInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");

		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";
						
		
		//ɾ������Ѻ��
		String sSql = "";
		sSql = 	" delete from GUARANTY_INFO "+
				" where GuarantyID = '"+sGuarantyID+"' "+
				" and GuarantyStatus = '01' ";
		Sqlca.executeSQL(sSql);
		//ɾ������Ѻ���뵣����ͬ�Ĺ�����ϵ
		sSql = 	" delete from GUARANTY_RELATIVE "+
				" where ObjectType = '"+sObjectType+"' "+
				" and ObjectNo = '"+sObjectNo+"' "+
				" and ContractNo = '"+sContractNo+"' "+
				" and GuarantyID = '"+sGuarantyID+"' ";
		Sqlca.executeSQL(sSql);
		
		return "SUCCEEDED";
	}
}
