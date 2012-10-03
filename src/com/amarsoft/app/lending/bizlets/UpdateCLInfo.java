package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateCLInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//对象类型	
	 	String sObjectType = (String)this.getAttribute("ObjectType");
		//对象编号
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//授信金额
		String sBusinessSum = (String)this.getAttribute("BusinessSum");
		//授信币种
		String sBusinessCurrency = (String)this.getAttribute("BusinessCurrency");
		//额度使用最迟日期
		String sLimitationTerm = (String)this.getAttribute("LimitationTerm");
		//额度生效日
		String sBeginDate = (String)this.getAttribute("BeginDate");
		//起始日
		String sPutOutDate = (String)this.getAttribute("PutOutDate");
		//到期日
		String sMaturity = (String)this.getAttribute("Maturity");
		//额度项下业务最迟到期日期
		String sUseTerm = (String)this.getAttribute("UseTerm");
		//期限
		String sTermMonth =  (String)this.getAttribute("TermMonth");
		//将空值转化为空字符串
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
	   	    
		//定义变量
		String sSql = "";
		System.out.println("dTermMonth:"+sTermMonth+"sBusinessSum:"+sBusinessSum);
		//根据对象类型更新授信额度信息
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
		
	    //执行更新语句
	    Sqlca.executeSQL(sSql);
	   
	    return "1";
	    
	 }

}