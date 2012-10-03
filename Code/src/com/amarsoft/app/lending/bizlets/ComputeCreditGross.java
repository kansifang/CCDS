package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2009-08-18
Tester:
Describe: --������������
Input Param:
		sCustomerID���ͻ����
Output Param:
		EvaluateScore:���ŷ�������
HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class ComputeCreditGross extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//�Զ���ô���Ĳ���ֵ
		String sCustomerID = (String)this.getAttribute("CustomerID");
		if(sCustomerID == null) sCustomerID = "";
		
		//���ر�־
		String sReturnValue="";
		//���������SQL��䡢��Ա�������������ų�Ա����
		String sSql = "",sEvaluateScore = "0.00",sCognScore = "0.00";
		//�����������ѯ���������ѯ�����1
		ASResultSet rs = null;
		
	//1.���ų�Ա��������
		sSql = " select  "+
			" SUM((case when BC.BusinessSum is null then 0 else BC.BusinessSum end) "+
			" *geterate(BC.Businesscurrency,'01',ERateDate)) as EvaluateScore "+
			" from BUSINESS_CONTRACT BC"+
			" where  BC.SerialNo in("+
			" select BCSerialNo  from CL_INFO"+  
			" Where LineEffDate <= '"+StringFunction.getToday()+"'"+  
			" and BeginDate <= '"+StringFunction.getToday()+"'  "+
			" and EndDate >= '"+StringFunction.getToday()+"'  "+
			" and BCSerialNo is not null "+
			" and BCSerialNo <> ''  "+
			" and (ParentLineID is null  or ParentLineID = '')"+  
			" and (FreezeFlag = '1'  or FreezeFlag = '3')) "+
			" and exists(select 1 from CUSTOMER_RELATIVE where  RelativeID=BC.CustomerID and RelationShip like '04%' " +
			" and length(RelationShip)>2 and CustomerID='"+sCustomerID+"') ";
		
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{	
			sEvaluateScore = rs.getString("EvaluateScore");
		}
		rs.getStatement().close();
		
	//2.���ų�Ա����
		sSql = " select Sum((case when Balance is null then BusinessSum else Balance end) " +
			" *geterate(Businesscurrency,'01',ERateDate)) as CognScore "+
			" from BUSINESS_CONTRACT BC "+
			" where (BC.FinishDate = '' or BC.FinishDate is null)  "+
			" and (BC.RecoveryOrgID = '' or BC.RecoveryOrgID is null)  "+
			" and  BC.Balance >= 0   "+
			" and BC.ApplyType in('IndependentApply','DependentApply') "+
			" and exists(select 1 from CUSTOMER_RELATIVE where  RelativeID=BC.CustomerID and RelationShip like '04%' " +
			" and length(RelationShip)>2 and CustomerID='"+sCustomerID+"') ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sCognScore = rs.getString("CognScore");
		}
		rs.getStatement().close();
		sReturnValue=sEvaluateScore+"@"+sCognScore;
		return sReturnValue;
	}
	
}
