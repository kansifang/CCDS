/*
		Author: jgao1 2008-09-27
		Tester:
		Describe: 在授信总额更改时，检查缩小总额时，配额是否满足要求
		Input Param:
				ObjectNo: 对象编号
				BusinessSum: 申请总额
		Output Param:
				1."00":表示正常；
				2."01":授信总额更改时，缩小的情况下，不允许更改；
		HistoryLog: lpzhang for tj 重检代码 2009-9-11
*/

package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;



public class CheckCreditLineSum extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
	 	//对象类型，
	 	String sObjectType = (String)this.getAttribute("ObjectType");
	 	//对象编号，用来查找授信总额
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//输入的申请授信总额
	 	String sBusinessSum = (String)this.getAttribute("BusinessSum");
	 	String sBusinessCurrency = (String)this.getAttribute("BusinessCurrency");
	 	//最高贷款金额
	 	String sPromisesfeeSum = (String)this.getAttribute("PromisesfeeSum");
	 	//最高期限
	 	String sDealfee = (String)this.getAttribute("Dealfee");
	 	//最高贷款比例
	 	String sPromisesfeeRatio = (String)this.getAttribute("PromisesfeeRatio");
	 	//期限
		String sTermMonth = (String)this.getAttribute("TermMonth");
		//业务品种
		String sBusinessType = (String)this.getAttribute("BusinessType");
		
	 	if(sObjectType==null) sObjectType = "";
	 	if(sObjectNo==null) sObjectNo = "";
	 	if(sBusinessSum==null || "".equals(sBusinessSum)) sBusinessSum = "0";
	 	if(sObjectType==null) sObjectType = "";
	 	
	 	double dTempBusinessSum =0.0,dBPromisesfeeSum=0.0,dBBusinessSum=0.0,dBTermMonth=0.0,Dealfee=0.0,dBDealfee=0.0,dBPromisesfeeRatio=0.0;
	 	dTempBusinessSum = Double.parseDouble(sBusinessSum);
	 	dBTermMonth = Double.parseDouble(sTermMonth);
	 	
	 	dBBusinessSum = Sqlca.getDouble("select "+dTempBusinessSum+"*getERate('"+sBusinessCurrency+"','01','') from (values 1) as a  ").doubleValue();
	 	
		String flag = "00";
		
		String sSql = "";
		//授信分配额的ParentLineID
		String sParentLineID = "";
		ASResultSet rs = null;
		
		//不同的对象类型它的取值也不同
		if(sObjectType.equals("CreditApply"))
		{
			//由于汇率日期存于业务表中,故重新取值
			dBBusinessSum = Sqlca.getDouble("select BusinessSum*getERate(BusinessCurrency,'01',ErateDate) from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'  ").doubleValue();
			sSql = " select LineID from CL_INFO where ApplySerialNo = '"+sObjectNo+"' and (ParentLineID is null or ParentLineID='') order by LineID";
			//做替换sCreditLineID = Sqlca.getString(sSql);
			//原因：如果是父LineID，则它的ParentLineID为空，所以rs.next()为false，所以得到sCreditLineID为空，在下面传递参数时，就为空
			//如果rs.next()有值，则它就是父ParentLineID，则取到第一个值就是它的ParentLineID
			rs=Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sParentLineID=rs.getString("LineID"); 
			}
			rs.getStatement().close();
			System.out.println("sParentLineID:::"+sParentLineID);
		}
		if(sObjectType.equals("BusinessContract"))
		{
			//由于汇率日期存于业务表中,故重新取值
			dBBusinessSum = Sqlca.getDouble("select BusinessSum*getERate(BusinessCurrency,'01',ErateDate) from BUSINESS_CONTRACT where SerialNo='"+sObjectNo+"'  ").doubleValue();
			sSql = " select LineID from CL_INFO where BCSerialNo = '"+sObjectNo+"'  and (ParentLineID is null or ParentLineID='') order by LineID";
			//做替换sCreditLineID = Sqlca.getString(sSql);
			//原因：如果是父LineID，则它的ParentLineID为空，所以rs.next()为false，所以得到sCreditLineID为空，在下面传递参数时，就为空
			//如果rs.next()有值，则它就是父ParentLineID，则取到第一个值就是它的ParentLineID
			rs=Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sParentLineID=rs.getString("LineID"); 
			}
			rs.getStatement().close();
		}
		if("3010,3015,3040,3050,3060".indexOf(sBusinessType)>-1)
		{
			//所有已经子授信限额总和sLineSum
			double sLineSum = 0.0,dTerm = 0.0;
			sSql = "select nvl(sum(LineSum1*getERate(Currency,'01',ERateDate)),0) from CL_INFO where ParentLineID='"+sParentLineID+"'";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
			{
				sLineSum = Double.parseDouble(rs.getString(1));
				
			}
			rs.getStatement().close();
			//如果输入的授信总额小于分配额之和，则不允许更改
			if(dBBusinessSum < sLineSum) flag = "01";
			
			sSql = "select Max(TermMonth) from CL_INFO where ParentLineID='"+sParentLineID+"'";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
			{
				dTerm = rs.getDouble(1);
				
			}
			rs.getStatement().close();
			if(dBTermMonth<dTerm)
				flag = "02";
		}
		
		if(sBusinessType.equals("3020"))
		{
			dBPromisesfeeSum = Double.parseDouble(sPromisesfeeSum);
		 	dBDealfee = Double.parseDouble(sDealfee);
		 	dBPromisesfeeRatio = Double.parseDouble(sPromisesfeeRatio);
		 	
			String sProjectAgreement = Sqlca.getString("select ObjectNo from Apply_Relative where SerialNo ='"+sObjectNo+"' and ObjectType ='ProjectAgreement' ");
			if(sProjectAgreement == null) sProjectAgreement="";
			
			double dTatalCreditSum=0.0,dLimitSum=0.0,dLimitLoanTerm=0.0,dLimitLoanRatio=0.0;
			
			sSql = " select nvl(Sum(CreditSum*getERate(Currency,'01','')),0) as TatalCreditSum from Dealer_Agreement where ObjectNo ='"+sProjectAgreement+"'";
			rs= Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dTatalCreditSum = rs.getDouble("TatalCreditSum");
			}
			rs.getStatement().close();
			
			sSql = " select max(LimitSum) as LimitSum, " +
				   " max(LimitLoanTerm) as LimitLoanTerm, max(LimitLoanRatio) as LimitLoanRatio" +
				   " from Dealer_Agreement where ObjectNo ='"+sProjectAgreement+"'";
			
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dLimitSum = rs.getDouble("LimitSum");
				dLimitLoanTerm = rs.getDouble("LimitLoanTerm");
				dLimitLoanRatio = rs.getDouble("LimitLoanRatio");
			}
			rs.getStatement().close();
			
			if(dTatalCreditSum>dBBusinessSum)
			{
				flag = "03"; //超过总额限制
			}
			if(dLimitSum >dBPromisesfeeSum)//超过最高金额限制
			{
				flag ="04";
			}
			if(dLimitLoanTerm>dBDealfee)//超过最高期限限制
			{
				flag ="05";
			}
			if(dLimitLoanRatio>dBPromisesfeeRatio)//超过最高贷款比例
			{
				flag ="06";
			}
			
			
		}
		
		return flag;

	}
}
