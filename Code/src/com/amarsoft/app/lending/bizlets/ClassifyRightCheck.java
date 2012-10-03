package com.amarsoft.app.lending.bizlets;
/*
Author: --xlyu 2012-03-21
Tester:
Describe: --���շ���Ȩ���ж�
Input Param:
		ObjectNo��������ˮ��
		RoleID����ǰ��ɫID
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ClassifyRightCheck extends Bizlet{

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		
		String sObjectNo = (String)this.getAttribute("ObjectNo");//������ˮ��
		String sRoleID = (String)this.getAttribute("RoleID");
		String sLowRisk = "";//1�ͷ��գ�2һ�����
		String sCustomerid = "";//�ͻ����
		double dSumCreditBalance = 0;//�ǵͷ��ճ������
		double dLowSumCreditBalance = 0;//�ͷ��ճ������
		double dRiskSum = 0;//һ����ս��
		double dLowRiskSum = 0;//�ͷ��ս��
		String sCustomerType = "";//�ͻ����� 01����˾  03������
		String sClassifyResult = "";//���շ�����
		String result = "";
        //��ȡҵ���Ƿ��ǵͷ���
		String sSql = "select LowRisk, Customerid "+
		              " from Business_Contract where SerialNo=(select ObjectNo from CLASSIFY_RECORD where SerialNo='"+sObjectNo+"')";
		ASResultSet rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{
			sLowRisk = rs.getString("LowRisk");
			sCustomerid= rs.getString("Customerid");
			if(sLowRisk == null) sLowRisk="";
			if(sCustomerid == null) sCustomerid="";
		
		}
		rs.getStatement().close();
		//���շ�����
		sClassifyResult =Sqlca.getString("select ClassifyLevel from CLASSIFY_RECORD where SerialNo='"+sObjectNo+"' ");
		sClassifyResult=sClassifyResult.substring(0,2);
		//�ǵͷ��ճ������
		dSumCreditBalance=Sqlca.getDouble("select sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)) from Business_Contract where customerid='"+sCustomerid+"' "+"" +
				" and (LOWRISK <> '1' or LOWRISK is null) and (FinishDate = '' or FinishDate is null) ");
		//�ͷ��ճ������
		dLowSumCreditBalance=Sqlca.getDouble("select sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)) from Business_Contract where customerid='"+sCustomerid+"' "+"" +
				" and LOWRISK = '1' and (FinishDate = '' or FinishDate is null) ");
		//�ͻ�����
		sCustomerType=Sqlca.getString("select CustomerType from Customer_Info where customerid='"+sCustomerid+"' ");
		sCustomerType=sCustomerType.substring(0,2);
		//��ȡȨ�������н���ɫ
	   	sSql = "select LowRiskSum,RiskSum from Classify_Auth where ClassifyResult = '"+sClassifyResult+"'"+
	           " and  CustomerType='"+sCustomerType+"'"+
	    	   " and RoleID = '"+sRoleID+"'";
	    
		rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{
			dLowRiskSum = rs.getDouble("LowRiskSum");
			dRiskSum = rs.getDouble("RiskSum");
			
		}
		rs.getStatement().close();
        if(sLowRisk.equals("1"))
        {
        	if( dLowRiskSum >= dLowSumCreditBalance) result = "TRUE";
        }else if(dRiskSum >= dSumCreditBalance) result = "TRUE";
        else result = "FALSE";
        System.out.println("------------result:"+result);
        return result;
       
	}
}
