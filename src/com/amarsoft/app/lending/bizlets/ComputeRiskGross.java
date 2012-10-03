package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2009-08-04
Tester:
Describe: --测算客户授信风险总量
Input Param:
		sCustomerID：客户编号
Output Param:
		EvaluateScore:授信风险总量
HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class ComputeRiskGross extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sCustomerID = (String)this.getAttribute("CustomerID");
		if(sCustomerID == null) sCustomerID = "";
		
		//返回标志
		String EvaluateScore = "0.00";
		
		//定义变量：SQL语句、关联流水号1、关联流水号2、字段列值
		String sSql = "",sSql1 = "";
		//定义变量：查询结果集、查询结果集1
		ASResultSet rs = null,rs1 = null;
		//定义变量:
		String sSerialNo="";
		double dSum1=0.00,dSum2=0.00,dGuarantyValue=0.00,dTotalSum1=0.00,dTotalSum=0.00;
		int iTermYear=0;
		
		//定义变量:申请信息
	//1.可循环使用授信额度中单个品种额度风险总量
		//单个品种额度金额汇总
		sSql = " select SerialNo,year(date(substr(Maturity,1,4)||'-'||substr(Maturity,6,2)||'-'||substr(Maturity,9,2))- "+
			" date(substr(PutOutDate,1,4)||'-'||substr(PutOutDate,6,2)||'-'||substr(PutOutDate,9,2))) as TermYear "+
			" ,((case when BC.BusinessSum is null then 0 else BC.BusinessSum end) "+
			" -(case when BC.BailSum is null then 0 else BC.BailSum end))*geterate(BC.Businesscurrency,'01',BC.ERateDate) as Sum1"+
			" from BUSINESS_CONTRACT BC"+
			" where  BC.SerialNo in("+
			" select BCSerialNo  from CL_INFO"+  
			" Where LineEffDate <= '"+StringFunction.getToday()+"'"+  
			" and BeginDate <= '"+StringFunction.getToday()+"'  "+
			" and EndDate >= '"+StringFunction.getToday()+"'  "+
			" and BCSerialNo is not null "+
			" and BCSerialNo <> ''  "+
			" and (ParentLineID is null  or ParentLineID = '')"+  
			" and (FreezeFlag = '1'  or FreezeFlag = '3') "+
			" and CustomerID='"+sCustomerID+"') ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{	
			sSerialNo = rs.getString("SerialNo");
			iTermYear = rs.getInt("TermYear");
			dSum1 = rs.getDouble("Sum1");
			//存单、国债质押的无风险部分
			sSql1 = "select " +
					" (case when GI.ConfirmValue is not null then GI.ConfirmValue else 0 end)" +
					" *geterate(GI.EvalCurrency,'01','') as ConfirmValue" +
					" from  GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
					" where GR.GuarantyID=GI.GuarantyID  "+
					" and GR.ObjectType='BusinessContract' "+
					" and GI.GuarantyType in('020010','020040') "+
					" and GR.ObjectNo='"+sSerialNo+"' ";
			rs1 = Sqlca.getASResultSet(sSql1);
			if(rs1.next())
			{
				dGuarantyValue = rs.getDouble("ConfirmValue");
			}
			rs1.getStatement().close();
			dTotalSum1=dTotalSum1+(dSum1-dGuarantyValue)*getTermPara(iTermYear);
		}
		rs.getStatement().close();
		
	//2.单笔授信
		//单个品种额度金额汇总
		sSql = " select SerialNo,year(date(substr(Maturity,1,4)||'-'||substr(Maturity,6,2)||'-'||substr(Maturity,9,2))- "+
			" date(substr(PutOutDate,1,4)||'-'||substr(PutOutDate,6,2)||'-'||substr(PutOutDate,9,2))) as TermYear , "+
			" (nvl(BusinessSum,0)*geterate(Businesscurrency,'01',ERateDate) "+
			" -(case when BailSum is null then 0 else BailSum end))*geterate(Businesscurrency,'01',ERateDate) as Sum1"+
			" from BUSINESS_CONTRACT BC "+
			" where (BC.FinishDate = '' or BC.FinishDate is null)  "+
			" and (BC.RecoveryOrgID = '' or BC.RecoveryOrgID is null)  "+
			" and  BC.Balance >= 0   "+
			" and BC.ApplyType='IndependentApply' "+
			" and CustomerID='"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{	
			
			sSerialNo = rs.getString("SerialNo");
			iTermYear = rs.getInt("TermYear");
			dSum1 = rs.getDouble("Sum1");
			sSql1 = "select " +
					" (case when GI.ConfirmValue is not null then GI.ConfirmValue else 0 end)" +
					" *geterate(GI.GuarantyCurrency,'01','') " +
					" from  GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
					" where GR.GuarantyID=GI.GuarantyID  "+
					" and GR.ObjectType='BusinessContract' "+
					" and GI.GuarantyType in('020010','020040') "+
					" and GR.ObjectNo='"+sSerialNo+"' ";
			rs1 = Sqlca.getASResultSet(sSql1);
			if(rs1.next())
			{
				dGuarantyValue = rs.getDouble(1);
			}
			rs1.getStatement().close();
			dTotalSum1=dTotalSum1+(dSum1-dGuarantyValue)*getTermPara(iTermYear);
		}
		rs.getStatement().close();
		
	//3.向他人在我行授信业务提保证担保金额
		sSql = " select SUM(GuarantyValue*geterate(GuarantyCurrency,'01','')) as Sum2 "+ 
				" from GUARANTY_CONTRACT  where SerialNo in("+
				"  select GC.SerialNo from BUSINESS_CONTRACT BC,CONTRACT_RELATIVE CR,GUARANTY_CONTRACT GC "+
				" where BC.SerialNo=CR.SerialNo  "+
				" and CR.ObjectNo=GC.SerialNo  "+
				" and CR.ObjectType='GuarantyContract' "+
				" and(BC.FinishDate = '' or BC.FinishDate is null)  "+
				" and (BC.RecoveryOrgID = '' or BC.RecoveryOrgID is null)  "+
				" and BC.ApplyType in('IndependentApply','DependentApply') "+
				"  and GC.CustomerID<>GC.GuarantorID "+
				" and GC.GuarantorID='"+sCustomerID+"' )"; 
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{	
			dSum2 = rs.getDouble("Sum2");
		}
		rs.getStatement().close();
		System.out.println("dTotalSum1:"+dTotalSum1+"@dSum2:"+dSum2);
		dTotalSum=dTotalSum1+dSum2*0.5;
		if(dTotalSum<0)
		{
			dTotalSum = 0;
		}
		System.out.println("dTotalSum:"+dTotalSum);
		EvaluateScore = String.valueOf(dTotalSum);
		System.out.println("EvaluateScore:"+EvaluateScore);
		return EvaluateScore;
	}
	
	
	public double getTermPara(int iYear){
		double dPara=0.00;
		if(iYear<=1)
			dPara=1.0;
		else if(1<iYear && iYear<=3)
			dPara=1.1;
		else if(3<iYear && iYear<=5)
			dPara=1.2;
		else if(5<iYear)
			dPara=1.3;
			
		return dPara;
	}
}
