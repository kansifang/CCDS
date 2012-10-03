package com.amarsoft.app.lending.bizlets;
/*
Author: --lpzhang
Tester:
Describe: --����ͻ����ʷ�������
Input Param:
		sCustomerID���ͻ����
Output Param:
		EvaluateScore:���ʷ�������
HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class ApplyRiskGross extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//�Զ���ô���Ĳ���ֵ
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(sSerialNo == null) sSerialNo = "";
		
		//���ر�־
		String EvaluateScore = "0.00";
		
		//���������SQL��䡢������ˮ��1��������ˮ��2���ֶ���ֵ
		String sSql = "",sSql1 = "";
		//�����������ѯ���������ѯ�����1
		ASResultSet rs = null,rs1 = null;
	
		double dSum1=0.00,dGuarantyValue=0.00,dTotalSum=0.00;
		int iTermYear=0;
		 
	//2.����������������  
		sSql = " select SerialNo,cast(TermMonth as decimal(24,2))/12  as TermYear , "+
			" ((case when BusinessSum is null then 0 else BusinessSum end) "+
			" -(case when BailSum is null then 0 else BailSum end))*geterate(Businesscurrency,'01',ERateDate) as Sum1"+
			" from Business_Apply BA "+
			" where  BA.ApplyType <> 'DependentApply' "+
			" and SerialNo='"+sSerialNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{	
			iTermYear = rs.getInt("TermYear");
			dSum1 = rs.getDouble("Sum1");
			sSql1 = "select " +
					" (case when GI.ConfirmValue is not null then GI.ConfirmValue else 0 end)*geterate(GI.GuarantyCurrency,'01','') as ConfirmValue" +
					" from  GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
					" where GR.GuarantyID=GI.GuarantyID  "+
					" and GR.ObjectType='CreditApply' "+
					" and GI.GuarantyType in('020010','020040') "+
					" and GR.ObjectNo='"+sSerialNo+"' ";
			rs1 = Sqlca.getASResultSet(sSql1);
			if(rs1.next())
			{
				dGuarantyValue = rs1.getDouble("ConfirmValue");
			}
			rs1.getStatement().close();
			dTotalSum=(dSum1-dGuarantyValue)*getTermPara(iTermYear);
			System.out.println("dTotalSum:"+dTotalSum);
		}
		rs.getStatement().close();
	
		
		EvaluateScore = String.valueOf(dTotalSum);
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
