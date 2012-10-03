package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong
Tester:
Describe: --�жϲ���ҵ������Ȩ��
Input Param:
		ObjectNo��������
		ObjectType:��������
Output Param:
		sReturnValue:����ֵ
HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class BadBizApproveRight extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		//System.out.println(sObjectNo+"@"+sObjectType);
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		//���������SQL��䡢������ˮ��1��������ˮ��2���ֶ���ֵ
		String sSql = "";
		//�����������ѯ���������ѯ�����1
		ASResultSet rs = null;
		//��������,����ֵ
		String sApplyType = "",sReturnValue = "2";
		double dBusinessSum = 0.0,dAuthSum2 = 0.0;
		//ȡ�������������Ϣ
		sSql =  " select ApplyType,BusinessSum from BadBiz_Apply where SerialNo='"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sApplyType = rs.getString("ApplyType");
			dBusinessSum = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();
		
		if("030".equals(sApplyType))//����
		{
			//ȡ��������Ȩ��
			sSql =  "select AuthSum2 from ORG_INFO "+
			" where OrgID in(select OrgID from FLOW_TASK "+
			" where (EndTime is null or EndTime = '') "+
			" and ObjectNO='"+sObjectNo+"' and ObjectType='"+sObjectType+"') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dAuthSum2 = rs.getDouble("AuthSum2");
			}
			rs.getStatement().close();
			if(dAuthSum2 >= dBusinessSum ) sReturnValue="1";
		}	
		return sReturnValue;
	}		
}
