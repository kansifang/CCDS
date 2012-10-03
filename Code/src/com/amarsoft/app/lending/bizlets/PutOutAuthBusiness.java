package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class PutOutAuthBusiness extends Bizlet{

	public Object run(Transaction Sqlca) throws Exception {
		//��ȡ�������������ͣ������ź͵�ǰ�û�
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sRoleID = (String)this.getAttribute("RoleID");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sRoleID == null) sRoleID = "";
		
		//������������ؽ����SQL���
		String result="FALSE",sSql = "";
		//����������������Ȩ���
		double dBusinessSum1 = 0,dAuBusinessSum1 = 0;
		//�����������ѯ�����
		ASResultSet rs = null;
		//��ȡ������,ҵ��Ʒ��
		sSql = "select BusinessSum from BUSINESS_PUTOUT "+
			   " where SerialNo='"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
		{ 
			dBusinessSum1 = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();
		
		if(!sRoleID.equals("")){
			//��ȡ������Ȩ���
			sSql = "select AuthSum from PutOut_Auth "+
				 " where RoleID = '"+sRoleID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			
			if (rs.next())
				dAuBusinessSum1 = rs.getDouble("AuthSum");		
			rs.getStatement().close();
		}
		//System.out.println(dBusinessSum1+"@"+dAuBusinessSum1);
		//������Ȩ�͵�����Ȩ��ͨ��
		if(dBusinessSum1 <= dAuBusinessSum1)
			result="TRUE";
		return result;
	}

}
