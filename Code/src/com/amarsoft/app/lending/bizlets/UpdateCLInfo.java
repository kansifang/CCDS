package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateCLInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//��������	
	 	String sObjectType = (String)this.getAttribute("ObjectType");
		//������
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//���Ž��
		String sBusinessSum = (String)this.getAttribute("BusinessSum");
		//���ű���
		String sBusinessCurrency = (String)this.getAttribute("BusinessCurrency");
		//���ʹ���������
		String sLimitationTerm = (String)this.getAttribute("LimitationTerm");
		//�����Ч��
		String sBeginDate = (String)this.getAttribute("BeginDate");
		//��ʼ��
		String sPutOutDate = (String)this.getAttribute("PutOutDate");
		//������
		String sMaturity = (String)this.getAttribute("Maturity");
		//�������ҵ����ٵ�������
		String sUseTerm = (String)this.getAttribute("UseTerm");
		//����
		String sTermMonth =  (String)this.getAttribute("TermMonth");
		//����ֵת��Ϊ���ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessSum == null || sBusinessSum.equals("")) sBusinessSum = "0";
		if(sTermMonth == null || sTermMonth.equals("")) sTermMonth = "0";
	    if(sBusinessCurrency == null) sBusinessCurrency = "";
	    if(sLimitationTerm == null) sLimitationTerm = "";
	    if(sBeginDate == null) sBeginDate = "";
	    if(sPutOutDate == null) sPutOutDate = "";
	    if(sMaturity == null) sMaturity = "";
	    if(sUseTerm == null) sUseTerm = "";
	   	    
		//�������
		String sSql = "";
		System.out.println("dTermMonth:"+sTermMonth+"sBusinessSum:"+sBusinessSum);
		//���ݶ������͸������Ŷ����Ϣ
		if(sObjectType.equals("CreditApply"))
			sSql = " update CL_INFO set LineSum1 = "+sBusinessSum+",Currency='"+sBusinessCurrency+"' ,TermMonth="+sTermMonth+" "+
	           	   " where ApplySerialNo = '"+sObjectNo+"' and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
		if(sObjectType.equals("ApproveApply"))
			sSql = " update CL_INFO set LineSum1 = "+sBusinessSum+",Currency='"+sBusinessCurrency+"' ,TermMonth="+sTermMonth+" "+
	           	   " where ApproveSerialNo = '"+sObjectNo+"' and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
		if(sObjectType.equals("BusinessContract"))
			sSql = " update CL_INFO set LineSum1 = "+sBusinessSum+",Currency='"+sBusinessCurrency+"', TermMonth="+sTermMonth+", "+
	           	   " PutOutDeadLine = '"+sLimitationTerm+"',LineEffDate = '"+sBeginDate+"', "+
	           	   " BeginDate = '"+sPutOutDate+"',EndDate = '"+sMaturity+"',MaturityDeadLine = '"+sUseTerm+"' "+
				   " where BCSerialNo = '"+sObjectNo+"' and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
		
	    //ִ�и������
	    Sqlca.executeSQL(sSql);
	   
	    return "1";
	    
	 }

}