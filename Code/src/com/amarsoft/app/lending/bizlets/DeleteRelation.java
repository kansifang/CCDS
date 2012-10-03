package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;


public class DeleteRelation extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值		
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sRelativeID   = (String)this.getAttribute("RelativeID");
		String sRelationShip = (String)this.getAttribute("RelationShip");
		
		//定义变量
		int iCount = 0;
		ASResultSet rs = null;
		String sItemDescribe = null;
		String sSql = null;
		//根据参数获取需要的值
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
	    //执行删除语句
	    Sqlca.executeSQL(sSql);
	    //删除集团成员时，检验如果该成员不是其他集团的成员，将该成员对应的‘是否集团客户’标志置成2
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
