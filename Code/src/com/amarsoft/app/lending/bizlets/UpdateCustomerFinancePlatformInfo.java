package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateCustomerFinancePlatformInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ	
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sFinancePlatformFlag   = (String)this.getAttribute("FinancePlatformFlag");//�Ƿ�����ƽ̨
		String sFinancePlatformType = (String)this.getAttribute("PlatformType");		 // ����ƽ̨����
		String sDealClassify = (String)this.getAttribute("DealClassify"); 				 // ���÷���
		
		if(sCustomerID == null) sCustomerID = "";
		if(sFinancePlatformFlag == null) sFinancePlatformFlag = "";
		if(sFinancePlatformType == null) sFinancePlatformType = "";
		if(sDealClassify == null) sDealClassify = "";
		
		//�������
		ASResultSet rs = null;
		String sSql = "";
	   
	    //��������ƽ̨���ֵ
	    sSql= " update ENT_INFO set FinancePlatformFlag='"+sFinancePlatformFlag+"',FinancePlatformType='"+sFinancePlatformType+"',"+
	          " DealClassify='"+sDealClassify+"'"+
	          " where CUSTOMERID='"+sCustomerID+"'" ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);
	    return "1";
	    
	 }

}
