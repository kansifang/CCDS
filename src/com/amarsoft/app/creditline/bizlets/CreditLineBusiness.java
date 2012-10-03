/***********************************************************************
 * Module:  CreditLineBusiness.java
 * Author:  lpzhang 2009-9-3 for TJ
 * Modified: 
 * Purpose: Defines the Class CreditLineBusiness
 ***********************************************************************/

package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizobj.BizObject;
import com.amarsoft.biz.bizobj.BizObjectFactory;
import com.amarsoft.biz.bizobj.IBizObject;
import com.amarsoft.impl.tjnh_als.bizlets.CreditData;
import com.amarsoft.impl.tjnh_als.bizlets.Tools;
import com.amarsoft.impl.tjnh_als.bizlets.WhereClause;

public class CreditLineBusiness {
	
	 private String BusinessType = "";
	 //本笔业务
	 private IBizObject oApply = new BizObject();
	 //该客户历史业务
	 private ASValuePool oALLBusiness = new ASValuePool();

	 private Transaction Sqlca = null;
	 //对象编号
	 private String ObjectNo = "";
	 //额度编号
	 private String LineID = "";
	//额度类型
	 private String Style = "";
	//额度合同号
	 private String BCSerialNo = "";
	 //对象类型
	 private String ObjectType = "";
	 //定义该客户所有合同统计数据
	 private CreditData AllContract = null;
	 //该客户所有已提交未登记合同的业务统计数据
	 private CreditData AllApply = null;
	 //定义Sql
	 private String sSql ="";
	 //定义保证金条件
	 
	 public CreditLineBusiness(String ObjectType,String ObjectNo,String BusinessType,String sLineID,String sStyle,String sBCSerialNo,Transaction Sqlca) throws Exception {
		 
		 this.BusinessType = BusinessType;
		 this.ObjectType = ObjectType;
		 this.ObjectNo = ObjectNo;
		 this.LineID = sLineID;
		 this.Style = sStyle;
		 this.BCSerialNo = sBCSerialNo;
		 this.Sqlca =Sqlca;
		 //初始化本笔业务
		 initApply();
		 //初始化历史合同业务
		 initALLContract();
		//初始化所有提交的申请业务
		 initALLApply();
	    }
	 
	 //初始化本笔申请信息
	 public void initApply() throws Exception {
		 
		 IBizObject Applybiz  = BizObjectFactory.getInstance().createBizObject(Sqlca,this.ObjectType,this.ObjectNo);
		 sSql = "";
		 double dBusinessSum = Sqlca.getDouble("select nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum  from Business_Apply where SerialNo = '"+this.ObjectNo+"'").doubleValue();
		 Applybiz.setAttribute("BusinessSum",String.valueOf(dBusinessSum));
		 this.oApply = Applybiz;
	 }
	 
	 //初始化历史合同业务
	 public void initALLContract() throws Exception{
		 
		 //初始化Attributes
		 sSql = " Select SerialNo," +
		 		" nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum," +
		 		" (nvl(BusinessSum,0)-(nvl(ActualPutOutSum,0)-nvl(Balance,0)))*getERate(BusinessCurrency,'01',ERateDate) as BusinssSum1, "+
		 		" BusinessCurrency,nvl(BailSum,0) as BailSum,nvl(BailRatio,0) as BailRatio,nvl(ActualPutOutSum,0)*getERate(BusinessCurrency,'01',ERateDate) as ActualPutOutSum," +
			    " BusinessType,nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as Balance,VouchType,CustomerID,Maturity " +
			    " from Business_Contract Where CustomerID = '"+(String)oApply.getAttribute("CustomerID")+"' and " +
			    " Maturity <>'' and Maturity is not null and (FinishDate is null or FinishDate ='')";
		 if(this.Style.equals("AssureAgreement"))
		 {
			 sSql = sSql+" and AssureAgreement = '"+this.BCSerialNo+"'";
		 }else if(this.Style.equals("CommunityAgreement"))
		 {
			 sSql = sSql+" and CommunityAgreement = '"+this.BCSerialNo+"'";
		 }else if(this.Style.equals("CreditAggreement"))
		 {
			 sSql = sSql+" and CreditAggreement = '"+this.BCSerialNo+"'";
		 }
		 
		 this.AllContract = new CreditData(Sqlca,sSql);
		 
		 this.oALLBusiness.setAttribute("UnCycBCSum",Double.valueOf(getSum1()));
		 this.oALLBusiness.setAttribute("CycBCSum",Double.valueOf(getSum2()));
		 this.oALLBusiness.setAttribute("UnCycADBCSum",Double.valueOf(getSum11()));//银承
		 this.oALLBusiness.setAttribute("CycADBCSum",Double.valueOf(getSum12()));	//银承 
		 this.oALLBusiness.setAttribute("TotalBCSum",Double.valueOf(getSum3()));//总额可循环
		 this.oALLBusiness.setAttribute("TotalBCSum1",Double.valueOf(getSum6()));//总额不可循环
	 }

	 //初始化在途申请业务
	 public void initALLApply() throws Exception{
	 	 
		 //初始化Attributes
		  sSql = " Select BA.SerialNo," +
		  		" nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,BA.CustomerID as CustomerID," +
		 		" BA.BusinessCurrency,nvl(BailSum,0) as BailSum,BA.BailRatio," +
			    " BA.BusinessType,BA.VouchType " +
			    " from Business_Apply BA,Flow_Object FO Where BA.SerialNo = FO.ObjectNo and FO.ObjectType = 'CreditApply'" +
			    " and FO.PhaseType in ('1020','1040') " +
			    " and not exists (select 'X' from Business_Contract BC where BC.RelativeSerialNo = BA.SerialNo and Maturity <>'' and Maturity is not null )" +
			    " and BA.CustomerID = '"+(String)oApply.getAttribute("CustomerID")+"' and (PigeonholeDate = '' or PigeonholeDate is null) ";
		/* sSql = " select SerialNo,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01','') as BusinessSum,CustomerID," +
		 		" BusinessCurrency,nvl(BailSum,0) as BailSum,BailRatio,BusinessType,VouchType" +
		 		" from Business_Apply BA " +
		 		" where  exists (select 'X' from Flow_Object FO where BA.SerialNo = FO.ObjectNo and FO.ObjectType = 'CreditApply' and FO.PhaseType <> '1010' )" +
		 		" and (ContractExsitFlag ='' or ContractExsitFlag is null) and CustomerID = '"+(String)oApply.getAttribute("CustomerID")+"'";
		 */
	  	 if(this.Style.equals("AssureAgreement"))
		 {
			 sSql = sSql+" and BA.AssureAgreement = '"+this.BCSerialNo+"'";
		 }else if(this.Style.equals("CommunityAgreement"))
		 {
			 sSql = sSql+" and BA.CommunityAgreement = '"+this.BCSerialNo+"'";
		 }else if(this.Style.equals("CreditAggreement"))
		 {
			 sSql = sSql+" and BA.CreditAggreement = '"+this.BCSerialNo+"'";
		 }
		  
		 this.AllApply = new CreditData(Sqlca,sSql);
		 
		 this.oALLBusiness.setAttribute("TypeBASum",Double.valueOf(getSum4()));
		 this.oALLBusiness.setAttribute("TypeADBASum",Double.valueOf(getSum13()));
		 this.oALLBusiness.setAttribute("TotalBASum",Double.valueOf(getSum5()));

	 }
	 
    /**  ∑该客户品种业务合同占用总金额--该业务品种不可循环
	 */
	public double getSum1() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		WhereClause[] wc1 = new WhereClause[2];
		WhereClause[] wc2 = new WhereClause[2];
		wc1[0] = new WhereClause("BusinessType",Tools.EQUALS,this.BusinessType);
		wc1[1] = new WhereClause("Maturity",Tools.AFTER,StringFunction.getToday());
		TotalSum1 = this.AllContract.getSum("BusinessSum",wc1);//未到期
		
		wc2[0] = new WhereClause("BusinessType",Tools.EQUALS,this.BusinessType);
		wc2[1] = new WhereClause("Maturity",Tools.BEFORE,StringFunction.getToday());
		TotalSum2 = this.AllContract.getSum("ActualPutOutSum",wc2);//到期
		TotalSum = TotalSum1+TotalSum2;
		return TotalSum;
	}
		
	/** ∑该客户品种业务合同占用总金额--该业务品种可循环
	 */
	public double getSum2() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		WhereClause[] wc1 = new WhereClause[2];
		WhereClause[] wc2 = new WhereClause[2];
		wc1[0] = new WhereClause("BusinessType",Tools.EQUALS,this.BusinessType);
		wc1[1] = new WhereClause("Maturity",Tools.AFTER,StringFunction.getToday());
		TotalSum1 = this.AllContract.getSum("BusinssSum1",wc1);//未到期
		
		wc2[0] = new WhereClause("BusinessType",Tools.EQUALS,this.BusinessType);
		wc2[1] = new WhereClause("Maturity",Tools.BEFORE,StringFunction.getToday());
		TotalSum2 = this.AllContract.getSum("Balance",wc2);//到期
		TotalSum = 	TotalSum1+TotalSum2;
		return TotalSum;
	}
	
    /**  ∑该客户品种业务合同占用总金额--该业务品种不可循环
	 */
	public double getSum11() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		WhereClause[] wc1 = new WhereClause[2];
		WhereClause[] wc2 = new WhereClause[2];
		wc1[0] = new WhereClause("BusinessType",Tools.EQUALS,"2010");
		wc1[1] = new WhereClause("Maturity",Tools.AFTER,StringFunction.getToday());
		TotalSum1 = this.AllContract.getSum("BusinessSum",wc1);//未到期
		
		wc2[0] = new WhereClause("BusinessType",Tools.EQUALS,"2010");
		wc2[1] = new WhereClause("Maturity",Tools.BEFORE,StringFunction.getToday());
		TotalSum2 = this.AllContract.getSum("ActualPutOutSum",wc2);//到期
		TotalSum = TotalSum1+TotalSum2;
		return TotalSum;
	}
		
	/** ∑该客户品种业务合同占用总金额--该业务品种可循环
	 */
	public double getSum12() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		WhereClause[] wc1 = new WhereClause[2];
		WhereClause[] wc2 = new WhereClause[2];
		wc1[0] = new WhereClause("BusinessType",Tools.EQUALS,"2010");
		wc1[1] = new WhereClause("Maturity",Tools.AFTER,StringFunction.getToday());
		TotalSum1 = this.AllContract.getSum("BusinssSum1",wc1);//未到期
		
		wc2[0] = new WhereClause("BusinessType",Tools.EQUALS,"2010");
		wc2[1] = new WhereClause("Maturity",Tools.BEFORE,StringFunction.getToday());
		TotalSum2 = this.AllContract.getSum("Balance",wc2);//到期
		TotalSum = 	TotalSum1+TotalSum2;
		return TotalSum;
	}	
	
		
	/** ∑该客户合同占用总金额按照总可循环
	 */
	public double getSum3() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		TotalSum1 = this.AllContract.getSum("BusinessSum","Maturity",Tools.AFTER,StringFunction.getToday());//未到期
		TotalSum2 = this.AllContract.getSum("Balance","Maturity",Tools.BEFORE,StringFunction.getToday());//到期
		TotalSum = 	TotalSum1+TotalSum2;
		return TotalSum;
	}
	/** ∑该客户合同占用总金额按照总不可循环
	 */
	public double getSum6() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		TotalSum1 = this.AllContract.getSum("BusinessSum","Maturity",Tools.AFTER,StringFunction.getToday());//未到期
		TotalSum2 = this.AllContract.getSum("ActualPutOutSum","Maturity",Tools.BEFORE,StringFunction.getToday());//到期
		TotalSum = 	TotalSum1+TotalSum2;
		return TotalSum;
	}
	
	/** ∑该客户该业务品种申请占用总金额
	 */
	public double getSum4() throws Exception
	{
		double TotalSum = 0.0;
		TotalSum = this.AllApply.getSum("BusinessSum","BusinessType",Tools.EQUALS,this.BusinessType);
		return TotalSum;
	}

	public double getSum13() throws Exception
	{
		double TotalSum = 0.0;
		TotalSum = this.AllApply.getSum("BusinessSum","BusinessType",Tools.EQUALS,"2010");
		return TotalSum;
	}
	
	/** ∑该客户申请占用总金额
	 */
	public double getSum5() throws Exception
	{
		double TotalSum = 0.0;
		TotalSum = this.AllApply.getSum("BusinessSum","SerialNo",Tools.ISNOTNULL,"");
		return TotalSum;
	}
	
	/** ∑该客户申请占用合同与申请中的总金额
	 */
	public double getBusinessTotalSum(CreditLineCL CC) throws Exception
	{
		double dBusinessTotalSum = 0.0;
		Object[] sTmpContextKeys = CC.getSubpool().getKeys();
		
		for(int i=0;i<sTmpContextKeys.length;i++){
			String sTmpKey =(String)sTmpContextKeys[i];
			ASValuePool attribute1 = (ASValuePool) CC.getSubpool().getAttribute(sTmpKey);
			String sCycFlag = (String) attribute1.getAttribute("Rotative");
			ReSetALLBusiness(sTmpKey);
			
			dBusinessTotalSum  += (sCycFlag.equals("1")?((Double)getOALLBusiness().getAttribute("CycBCSum")).doubleValue():((Double)getOALLBusiness().getAttribute("UnCycBCSum")).doubleValue())
						   +  ((Double)getOALLBusiness().getAttribute("TypeBASum")).doubleValue();
		}	
		return dBusinessTotalSum;		
	}
	
	/** 修改业务品种
	 */
	public void setBusinessType(String BusinessType)
	{
		this.BusinessType = BusinessType;
	}
	
	/** 修改业务品种并重载业务统计数据缓存
	 * @throws Exception 
	 */
	public void ReSetALLBusiness(String BusinessType) throws Exception
	{
		this.BusinessType = BusinessType;
		this.oALLBusiness.setAttribute("UnCycBCSum",Double.valueOf(getSum1()));
		this.oALLBusiness.setAttribute("CycBCSum",Double.valueOf(getSum2()));
		this.oALLBusiness.setAttribute("TypeBASum",Double.valueOf(getSum4()));
	}
	
	/** 清空CreditData
	 * @throws Exception 
	 */
	public void CleanCreditData() throws Exception {
		
		AllContract.closeCreditData();
		AllApply.closeCreditData();
	}


	public IBizObject getOApply() {
		return this.oApply;
	}


	public ASValuePool getOALLBusiness() {
		return this.oALLBusiness;
	}

	
}
