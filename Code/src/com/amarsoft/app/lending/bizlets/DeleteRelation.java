package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;


public class DeleteRelation extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ		
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sRelativeID   = (String)this.getAttribute("RelativeID");
		String sRelationShip = (String)this.getAttribute("RelationShip");
		
		//�������
		int iCount = 0;
		ASResultSet rs = null;
		String sItemDescribe = null;
		String sSql = null;
		//���ݲ�����ȡ��Ҫ��ֵ
		sSql="select ItemDescribe from CODE_LIBRARY where CODENO = 'RelationShip' and ITEMNO = '"+sRelationShip+"'";
		rs = Sqlca.getResultSet(sSql);
	    if(rs.next())
	    {
	    	sItemDescribe = rs.getString(1);
	    }
	    
	    rs.getStatement().close();
	    
	    sSql = 	" delete from CUSTOMER_RELATIVE where CUSTOMERID='"+sRelativeID+"'"+
	        	" and RELATIVEID='"+sCustomerID+"'"+
	        	" and RELATIONSHIP='"+sItemDescribe+"'";
	    //ִ��ɾ�����
	    Sqlca.executeSQL(sSql);
	    //ɾ�����ų�Աʱ����������ó�Ա�����������ŵĳ�Ա�����ó�Ա��Ӧ�ġ��Ƿ��ſͻ�����־�ó�2
	    if(sRelationShip.startsWith("04")) 
	    {
	    	iCount = Integer.parseInt(Sqlca.getString("select count(CustomerID) from CUSTOMER_RELATIVE where RelativeID = '"+sRelativeID+"' and RelationShip like '04%' "));
	    	if(iCount<1)
	    	{
	    		Sqlca.executeSQL("update ENT_INFO set ECGroupFlag = '2' where CustomerID = '"+sRelativeID+"'");
	    	}	
	    }
	    return "1";
	 }

}
