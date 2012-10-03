package com.amarsoft.app.lending.bizlets;
/*
		Author: --κ���� 2005-11-23
		Tester:
		Describe: --�������Ŷ�������¼ʱ����ͬʱ�ڶ����Ϣ��CL_INFO������һ�ʼ�¼
		Input Param:
				ObjectNo��������
				BusinessType��ҵ��Ʒ��
				CustomerID: �ͻ�����
				CustomerName: �ͻ�����				
		Output Param:

		HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReinforceCLInfo extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");	
		//ҵ��Ʒ��
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//�ͻ����
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//�ͻ�����		
		String sCustomerName = (String)this.getAttribute("CustomerName");		
		//�Ǽ���
		String sInputUser = (String)this.getAttribute("InputUser");
		//�Ǽǻ���
		String sInputOrg = (String)this.getAttribute("InputOrg");
		//������
		double dBusinessSum =0;
		
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sCustomerID == null) sCustomerID = "";
	    if(sCustomerName == null) sCustomerName = "";
	    if(sInputUser == null) sInputUser = "";
	    if(sInputOrg == null) sInputOrg = "";
	   	
	    //��õ�ǰʱ��
	    String sCurDate = StringFunction.getToday();
	    
	    //���������
	    String sSql1 = " select BusinessSum from BUSINESS_CONTRACT Where SerialNo= '"+sObjectNo+"'";
	    ASResultSet rs = Sqlca.getASResultSet(sSql1);
	    if(rs.next()){
	    	dBusinessSum = rs.getDouble("BusinessSum");
	    }
	    rs.getStatement().close();
	    
	    //���ҵ��Ʒ�����ۺ����Ŷ�ȣ�������ڶ����Ϣ��CL_INFO�в���һ����Ϣ
	    //modify by hlzhang 2008-08-07 ���������ۺ����Ŷ�ȣ����ڶ����Ϣ��CL_INFO�в�����Ӧ��Ϣ
	       if(sBusinessType.startsWith("3") && !sBusinessType.equals("3020"))
	    {
	        String sSerialNo = DBFunction.getSerialNo("CL_INFO","LineID",Sqlca);
	        String sClTypeName=Sqlca.getString("select TypeName from Business_Type where typeno='"+sBusinessType+"'");
	        String sSql =  " insert into CL_INFO(LineID,CLTypeID,ClTypeName,BCSerialNo,BusinessType,CustomerID,CustomerName, "+
	        	  		   " FreezeFlag,InputUser,InputOrg,InputTime,UpdateTime) "+
	                       " values ('"+sSerialNo+"','001','"+sClTypeName+"','"+sObjectNo+"','"+sBusinessType+"', '" + sCustomerID+"', " + 
	         			   " '"+sCustomerName+"','1','"+sInputUser+"','"+sInputOrg+"','"+sCurDate+"','"+sCurDate+"')";
        
	        //ִ�в������
		    Sqlca.executeSQL(sSql);
	    }
	   
	    
		return "1";
	 }
}
