package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2009-09-03
Tester:
Describe: --�����ʲ������϶�����״̬��Ϣ�������ʷ��Ϣ����
Input Param:
		ObjectNo: ��ͬ���
		BadAssetLCFlag: ״̬��ʶ 010 �϶���� 020 �������
		UserID:��ǰ�û�
		OrgID:��ǰ����
Output Param:
		ReturnValue :���ر�ʶ
HistoryLog:
*/
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateBadAssetCogniz extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ ��ͬ���,���±�ʶ,��ǰ�û�ID,��ǰ����ID	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sBadAssetLCFlag = (String)this.getAttribute("BadAssetLCFlag");
		String sUserID = (String)this.getAttribute("UserID");
		String sOrgID = (String)this.getAttribute("OrgID");
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sBadAssetLCFlag == null) sBadAssetLCFlag = "" ;
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "" ;
		
		String sSql = "";
		String sRoleId= "",sUserName="";
		ASResultSet rs = null;
		//���º�ͬ״̬
		sSql="update BUSINESS_CONTRACT set BadAssetLcFlag  = '"+sBadAssetLCFlag+"' where SerialNo = '"+sObjectNo+"'";		
		Sqlca.executeSQL(sSql);
		if(sBadAssetLCFlag.equals("010"))//�϶����
		{
			//�����϶�ʱ��
			sSql="update DUTY_INFO set CognizeDate  = '"+StringFunction.getToday()+"' where ObjectType='BusinessContract' and ObjectNo = '"+sObjectNo+"'";		
			Sqlca.executeSQL(sSql);
		}else if(sBadAssetLCFlag.equals("020"))//�������
		{
			//�����϶�ʱ��,������,��������,����ʱ��
			sSql="update DUTY_INFO set CognizeExamID = '"+sUserID+"',CognizeExamOrgID = '"+sOrgID+"',CognizeExamDate  = '"+StringFunction.getToday()+"' where ObjectType='BusinessContract' and ObjectNo = '"+sObjectNo+"'";		
			Sqlca.executeSQL(sSql);
		}
		
		return "Success";
	}	

}
