package com.amarsoft.app.creditline.bizlets;
/*
Author: --lpzhang 2009-9-9
Tester:
Describe: --新额度生效
Input Param:
		SerialNo：额度合同号
		CustomerID：客户号
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.app.lending.bizlets.DeleteBusiness;
import com.amarsoft.are.util.StringFunction;

public class ChangeAgreementInuse extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值
		String sSerialNo  = (String)this.getAttribute("SerialNo");//--额度合同号
		String sCustomerID   = (String)this.getAttribute("CustomerID");//--客户号
		String sBusinessType   = (String)this.getAttribute("BusinessType");//--业务品种
		String sOccurType   = (String)this.getAttribute("OccurType");//--业务品种
		if(sSerialNo==null) sSerialNo="";
		if(sCustomerID==null) sCustomerID="";
		if(sBusinessType==null) sBusinessType="";
		if(sOccurType==null) sOccurType="";
		//定义变量
		String sSql= "";
		
		if(sBusinessType.equals("3020"))//工程机械
		{
			String sEntAgreementNo = Sqlca.getString("select ObjectNo from Contract_Relative where SerialNo ='"+sSerialNo+"' and ObjectType ='ProjectAgreement' ");
			if(sEntAgreementNo == null) sEntAgreementNo="";
			if(!"".equals(sEntAgreementNo))
			{
				Sqlca.executeSQL("update Ent_Agreement set FreezeFlag ='1' where SerialNo ='"+sEntAgreementNo+"' and  AgreementType ='ProjectAgreement' and (FreezeFlag is null or FreezeFlag ='') ");
			}
		}
		
		if(sOccurType.equals("100"))//调整
		{
			String sRelativeSerialNo = Sqlca.getString("select ObjectNo from Contract_Relative where SerialNo ='"+sSerialNo+"' and ObjectType = 'CLBusinessChange' ");
			if(sRelativeSerialNo == null) sRelativeSerialNo="";
			
			sSql = " update CL_INFO CL set FreezeFlag = '4' where BCSerialNo is not null  and BCSerialNo <> '' " +
				   " and (ParentLineID is null  or ParentLineID = '')  and " +
				   " exists (select 'X' from Business_Contract BC where BC.SerialNo =CL.BCSerialNo and BC.SerialNo = '"+sRelativeSerialNo+"'  )";
			Sqlca.executeSQL(sSql); 
			
			Sqlca.executeSQL("update Business_Contract set  FreezeFlag = '4',FinishDate = '"+StringFunction.getToday()+"' where  SerialNo = '"+sRelativeSerialNo+"'");
			
			if(sBusinessType.equals("3010") || sBusinessType.equals("3040"))
			{
				Sqlca.executeSQL("update Business_Contract set CreditAggreement = '"+sSerialNo+"' where ApplyType='DependentApply' and CreditAggreement = '"+sRelativeSerialNo+"' and (FinishDate is null or FinishDate ='' )");
			}else if(sBusinessType.equals("3060"))
			{
				Sqlca.executeSQL("update Business_Contract set CommunityAgreement = '"+sSerialNo+"' where  CommunityAgreement = '"+sRelativeSerialNo+"' and (FinishDate is null or FinishDate ='' )");
			}
			
		
		}
		
		Sqlca.executeSQL("update Business_Contract set InUseFlag='01' where SerialNo ='"+sSerialNo+"'");
		
		return "1";
	 }
}
