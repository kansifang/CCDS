package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AlertCustomerRelationShip extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub		
		String sRelationShip = (String)this.getAttribute("RelationShip");
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");
		if(sRelationShip == null) sRelationShip = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		
		//�������
		String sSql = "";
		String sRelationName = "";
		
		String sReturnValue = "",CustomerDesc = "";
		ASResultSet rs = null;
				
		//ȡ������ϵ����
		sSql = 	" select ItemName from CODE_LIBRARY "+
				" where CodeNo = 'RelationShip' "+
				" and ItemNo = '"+sRelationShip+"' ";
		sRelationName = Sqlca.getString(sSql);
		if(sRelationName == null) sRelationName = "";
		
		//ȡ���ͻ��Լ��Ŀͻ����ƣ�֤�����ͣ�֤������
		sSql = 	" select getCustomerName(CustomerID) as ReltiveCustomerName,CustomerName "+
				" from CUSTOMER_RELATIVE "+
				" where CertType = '"+sCertType+"' "+
				" and CertID='"+sCertID+"' "+
				" and RelationShip='"+sRelationShip+"'";
		rs = Sqlca.getASResultSet(sSql);	
		while (rs.next()) 
		{	
			CustomerDesc = "��"+sRelationName+"["+rs.getString("CustomerName")+"]��";
			sReturnValue+="["+rs.getString("ReltiveCustomerName")+"]";
		}
		rs.getStatement().close();
		if(!"".equals(sReturnValue))
		sReturnValue=CustomerDesc+sReturnValue+"�Ѿ���["+sRelationName+"]��ϵ,��ȷ�Ϻ�Ǽ�!";
				
		return sReturnValue;
	}

}
