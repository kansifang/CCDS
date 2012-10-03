/*
		Author: jgao1 2008-09-27
		Tester:
		Describe: �������ܶ����ʱ�������С�ܶ�ʱ������Ƿ�����Ҫ��
		Input Param:
				ObjectNo: ������
				BusinessSum: �����ܶ�
		Output Param:
				1."00":��ʾ������
				2."01":�����ܶ����ʱ����С������£���������ģ�
		HistoryLog: lpzhang for tj �ؼ���� 2009-9-11
*/

package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;



public class CheckCreditLineSum extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
	 	//�������ͣ�
	 	String sObjectType = (String)this.getAttribute("ObjectType");
	 	//�����ţ��������������ܶ�
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//��������������ܶ�
	 	String sBusinessSum = (String)this.getAttribute("BusinessSum");
	 	String sBusinessCurrency = (String)this.getAttribute("BusinessCurrency");
	 	//��ߴ�����
	 	String sPromisesfeeSum = (String)this.getAttribute("PromisesfeeSum");
	 	//�������
	 	String sDealfee = (String)this.getAttribute("Dealfee");
	 	//��ߴ������
	 	String sPromisesfeeRatio = (String)this.getAttribute("PromisesfeeRatio");
	 	//����
		String sTermMonth = (String)this.getAttribute("TermMonth");
		//ҵ��Ʒ��
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
		//���ŷ�����ParentLineID
		String sParentLineID = "";
		ASResultSet rs = null;
		
		//��ͬ�Ķ�����������ȡֵҲ��ͬ
		if(sObjectType.equals("CreditApply"))
		{
			//���ڻ������ڴ���ҵ�����,������ȡֵ
			dBBusinessSum = Sqlca.getDouble("select BusinessSum*getERate(BusinessCurrency,'01',ErateDate) from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'  ").doubleValue();
			sSql = " select LineID from CL_INFO where ApplySerialNo = '"+sObjectNo+"' and (ParentLineID is null or ParentLineID='') order by LineID";
			//���滻sCreditLineID = Sqlca.getString(sSql);
			//ԭ������Ǹ�LineID��������ParentLineIDΪ�գ�����rs.next()Ϊfalse�����Եõ�sCreditLineIDΪ�գ������洫�ݲ���ʱ����Ϊ��
			//���rs.next()��ֵ���������Ǹ�ParentLineID����ȡ����һ��ֵ��������ParentLineID
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
			//���ڻ������ڴ���ҵ�����,������ȡֵ
			dBBusinessSum = Sqlca.getDouble("select BusinessSum*getERate(BusinessCurrency,'01',ErateDate) from BUSINESS_CONTRACT where SerialNo='"+sObjectNo+"'  ").doubleValue();
			sSql = " select LineID from CL_INFO where BCSerialNo = '"+sObjectNo+"'  and (ParentLineID is null or ParentLineID='') order by LineID";
			//���滻sCreditLineID = Sqlca.getString(sSql);
			//ԭ������Ǹ�LineID��������ParentLineIDΪ�գ�����rs.next()Ϊfalse�����Եõ�sCreditLineIDΪ�գ������洫�ݲ���ʱ����Ϊ��
			//���rs.next()��ֵ���������Ǹ�ParentLineID����ȡ����һ��ֵ��������ParentLineID
			rs=Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sParentLineID=rs.getString("LineID"); 
			}
			rs.getStatement().close();
		}
		if("3010,3015,3040,3050,3060".indexOf(sBusinessType)>-1)
		{
			//�����Ѿ��������޶��ܺ�sLineSum
			double sLineSum = 0.0,dTerm = 0.0;
			sSql = "select nvl(sum(LineSum1*getERate(Currency,'01',ERateDate)),0) from CL_INFO where ParentLineID='"+sParentLineID+"'";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
			{
				sLineSum = Double.parseDouble(rs.getString(1));
				
			}
			rs.getStatement().close();
			//�������������ܶ�С�ڷ����֮�ͣ����������
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
				flag = "03"; //�����ܶ�����
			}
			if(dLimitSum >dBPromisesfeeSum)//������߽������
			{
				flag ="04";
			}
			if(dLimitLoanTerm>dBDealfee)//���������������
			{
				flag ="05";
			}
			if(dLimitLoanRatio>dBPromisesfeeRatio)//������ߴ������
			{
				flag ="06";
			}
			
			
		}
		
		return flag;

	}
}
