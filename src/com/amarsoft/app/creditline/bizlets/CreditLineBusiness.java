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
	 //����ҵ��
	 private IBizObject oApply = new BizObject();
	 //�ÿͻ���ʷҵ��
	 private ASValuePool oALLBusiness = new ASValuePool();

	 private Transaction Sqlca = null;
	 //������
	 private String ObjectNo = "";
	 //��ȱ��
	 private String LineID = "";
	//�������
	 private String Style = "";
	//��Ⱥ�ͬ��
	 private String BCSerialNo = "";
	 //��������
	 private String ObjectType = "";
	 //����ÿͻ����к�ͬͳ������
	 private CreditData AllContract = null;
	 //�ÿͻ��������ύδ�ǼǺ�ͬ��ҵ��ͳ������
	 private CreditData AllApply = null;
	 //����Sql
	 private String sSql ="";
	 //���屣֤������
	 
	 public CreditLineBusiness(String ObjectType,String ObjectNo,String BusinessType,String sLineID,String sStyle,String sBCSerialNo,Transaction Sqlca) throws Exception {
		 
		 this.BusinessType = BusinessType;
		 this.ObjectType = ObjectType;
		 this.ObjectNo = ObjectNo;
		 this.LineID = sLineID;
		 this.Style = sStyle;
		 this.BCSerialNo = sBCSerialNo;
		 this.Sqlca =Sqlca;
		 //��ʼ������ҵ��
		 initApply();
		 //��ʼ����ʷ��ͬҵ��
		 initALLContract();
		//��ʼ�������ύ������ҵ��
		 initALLApply();
	    }
	 
	 //��ʼ������������Ϣ
	 public void initApply() throws Exception {
		 
		 IBizObject Applybiz  = BizObjectFactory.getInstance().createBizObject(Sqlca,this.ObjectType,this.ObjectNo);
		 sSql = "";
		 double dBusinessSum = Sqlca.getDouble("select nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum  from Business_Apply where SerialNo = '"+this.ObjectNo+"'").doubleValue();
		 Applybiz.setAttribute("BusinessSum",String.valueOf(dBusinessSum));
		 this.oApply = Applybiz;
	 }
	 
	 //��ʼ����ʷ��ͬҵ��
	 public void initALLContract() throws Exception{
		 
		 //��ʼ��Attributes
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
		 this.oALLBusiness.setAttribute("UnCycADBCSum",Double.valueOf(getSum11()));//����
		 this.oALLBusiness.setAttribute("CycADBCSum",Double.valueOf(getSum12()));	//���� 
		 this.oALLBusiness.setAttribute("TotalBCSum",Double.valueOf(getSum3()));//�ܶ��ѭ��
		 this.oALLBusiness.setAttribute("TotalBCSum1",Double.valueOf(getSum6()));//�ܶ��ѭ��
	 }

	 //��ʼ����;����ҵ��
	 public void initALLApply() throws Exception{
	 	 
		 //��ʼ��Attributes
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
	 
    /**  �Ƹÿͻ�Ʒ��ҵ���ͬռ���ܽ��--��ҵ��Ʒ�ֲ���ѭ��
	 */
	public double getSum1() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		WhereClause[] wc1 = new WhereClause[2];
		WhereClause[] wc2 = new WhereClause[2];
		wc1[0] = new WhereClause("BusinessType",Tools.EQUALS,this.BusinessType);
		wc1[1] = new WhereClause("Maturity",Tools.AFTER,StringFunction.getToday());
		TotalSum1 = this.AllContract.getSum("BusinessSum",wc1);//δ����
		
		wc2[0] = new WhereClause("BusinessType",Tools.EQUALS,this.BusinessType);
		wc2[1] = new WhereClause("Maturity",Tools.BEFORE,StringFunction.getToday());
		TotalSum2 = this.AllContract.getSum("ActualPutOutSum",wc2);//����
		TotalSum = TotalSum1+TotalSum2;
		return TotalSum;
	}
		
	/** �Ƹÿͻ�Ʒ��ҵ���ͬռ���ܽ��--��ҵ��Ʒ�ֿ�ѭ��
	 */
	public double getSum2() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		WhereClause[] wc1 = new WhereClause[2];
		WhereClause[] wc2 = new WhereClause[2];
		wc1[0] = new WhereClause("BusinessType",Tools.EQUALS,this.BusinessType);
		wc1[1] = new WhereClause("Maturity",Tools.AFTER,StringFunction.getToday());
		TotalSum1 = this.AllContract.getSum("BusinssSum1",wc1);//δ����
		
		wc2[0] = new WhereClause("BusinessType",Tools.EQUALS,this.BusinessType);
		wc2[1] = new WhereClause("Maturity",Tools.BEFORE,StringFunction.getToday());
		TotalSum2 = this.AllContract.getSum("Balance",wc2);//����
		TotalSum = 	TotalSum1+TotalSum2;
		return TotalSum;
	}
	
    /**  �Ƹÿͻ�Ʒ��ҵ���ͬռ���ܽ��--��ҵ��Ʒ�ֲ���ѭ��
	 */
	public double getSum11() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		WhereClause[] wc1 = new WhereClause[2];
		WhereClause[] wc2 = new WhereClause[2];
		wc1[0] = new WhereClause("BusinessType",Tools.EQUALS,"2010");
		wc1[1] = new WhereClause("Maturity",Tools.AFTER,StringFunction.getToday());
		TotalSum1 = this.AllContract.getSum("BusinessSum",wc1);//δ����
		
		wc2[0] = new WhereClause("BusinessType",Tools.EQUALS,"2010");
		wc2[1] = new WhereClause("Maturity",Tools.BEFORE,StringFunction.getToday());
		TotalSum2 = this.AllContract.getSum("ActualPutOutSum",wc2);//����
		TotalSum = TotalSum1+TotalSum2;
		return TotalSum;
	}
		
	/** �Ƹÿͻ�Ʒ��ҵ���ͬռ���ܽ��--��ҵ��Ʒ�ֿ�ѭ��
	 */
	public double getSum12() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		WhereClause[] wc1 = new WhereClause[2];
		WhereClause[] wc2 = new WhereClause[2];
		wc1[0] = new WhereClause("BusinessType",Tools.EQUALS,"2010");
		wc1[1] = new WhereClause("Maturity",Tools.AFTER,StringFunction.getToday());
		TotalSum1 = this.AllContract.getSum("BusinssSum1",wc1);//δ����
		
		wc2[0] = new WhereClause("BusinessType",Tools.EQUALS,"2010");
		wc2[1] = new WhereClause("Maturity",Tools.BEFORE,StringFunction.getToday());
		TotalSum2 = this.AllContract.getSum("Balance",wc2);//����
		TotalSum = 	TotalSum1+TotalSum2;
		return TotalSum;
	}	
	
		
	/** �Ƹÿͻ���ͬռ���ܽ����ܿ�ѭ��
	 */
	public double getSum3() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		TotalSum1 = this.AllContract.getSum("BusinessSum","Maturity",Tools.AFTER,StringFunction.getToday());//δ����
		TotalSum2 = this.AllContract.getSum("Balance","Maturity",Tools.BEFORE,StringFunction.getToday());//����
		TotalSum = 	TotalSum1+TotalSum2;
		return TotalSum;
	}
	/** �Ƹÿͻ���ͬռ���ܽ����ܲ���ѭ��
	 */
	public double getSum6() throws Exception
	{
		double TotalSum = 0.0,TotalSum1 = 0.0,TotalSum2 = 0.0;
		TotalSum1 = this.AllContract.getSum("BusinessSum","Maturity",Tools.AFTER,StringFunction.getToday());//δ����
		TotalSum2 = this.AllContract.getSum("ActualPutOutSum","Maturity",Tools.BEFORE,StringFunction.getToday());//����
		TotalSum = 	TotalSum1+TotalSum2;
		return TotalSum;
	}
	
	/** �Ƹÿͻ���ҵ��Ʒ������ռ���ܽ��
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
	
	/** �Ƹÿͻ�����ռ���ܽ��
	 */
	public double getSum5() throws Exception
	{
		double TotalSum = 0.0;
		TotalSum = this.AllApply.getSum("BusinessSum","SerialNo",Tools.ISNOTNULL,"");
		return TotalSum;
	}
	
	/** �Ƹÿͻ�����ռ�ú�ͬ�������е��ܽ��
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
	
	/** �޸�ҵ��Ʒ��
	 */
	public void setBusinessType(String BusinessType)
	{
		this.BusinessType = BusinessType;
	}
	
	/** �޸�ҵ��Ʒ�ֲ�����ҵ��ͳ�����ݻ���
	 * @throws Exception 
	 */
	public void ReSetALLBusiness(String BusinessType) throws Exception
	{
		this.BusinessType = BusinessType;
		this.oALLBusiness.setAttribute("UnCycBCSum",Double.valueOf(getSum1()));
		this.oALLBusiness.setAttribute("CycBCSum",Double.valueOf(getSum2()));
		this.oALLBusiness.setAttribute("TypeBASum",Double.valueOf(getSum4()));
	}
	
	/** ���CreditData
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
