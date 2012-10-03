/*
		Author: --lpzhang 2009-8-24
		Tester:
		Describe: --���ͻ��Ƿ��а����ҵ���Ȩ��
		Input Param:
				BusinessType:ҵ��Ʒ��
				CustomID���ͻ����
		Output Param:
				
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckCreditCondition extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{

		//��ÿͻ����
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//���ҵ��Ʒ��
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//��÷�����ʽ
		String sOccurType = (String)this.getAttribute("OccurType");
		//��ù���Э��
		String sRelativeAgreement = (String)this.getAttribute("RelativeAgreement");
		//��ȡ��������
		String sApplyType = (String) this.getAttribute("ApplyType");
		//����ֵת���ɿ��ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sRelativeAgreement == null) sRelativeAgreement = "";
		if(sApplyType == null) sApplyType = "";
		
		//���������Sql���
		String sSql = "";
		//�����������ѯ�����
		ASResultSet rs = null;
		//���巵�ر���
		String sReturn = "PASS";//ͨ��
		//�ͻ����,�Ƿ����û�
		String sIndRPRType = "",sFIsCredited ="";
		int NumTemp =0,iNum=0;
		
		if(sBusinessType.equals("1140130"))//�������ù�ͬ���������̻�����
		{
			String sGTTID = "";
			sSql = "select CustomerID from CUSTOMER_RELATIVE where RelationShip like '0701%'  and RelativeID='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				sGTTID = rs.getString(1);
			if(sGTTID == null) sGTTID =  "";
			rs.getStatement().close();
			
			if(sGTTID.equals("")){
				sReturn = "�ÿͻ����ǳ������ù�ͬ�壬���ܰ����ҵ��";
			}else
			{
				String sSuperCertType="";
				sSuperCertType = Sqlca.getString("select SuperCertType from ENT_INFO where CustomerID = '"+sGTTID+"' ");
				if(!sSuperCertType.equals("010"))
				{
					sReturn = "�ÿͻ����ǳ������ù�ͬ�壬���ܰ����ҵ��";
				}
			}
			String sCreditLevel = Sqlca.getString("select CGALevel from CUSTOMER_RELATIVE where CustomerID='"+sGTTID+"'and RelationShip like '0701%'");
			//sCreditLevel = Sqlca.getString("select CreditLevel from IND_INFO where CustomerID = '"+sCustomerID+"'");
			if(sCreditLevel == null) sCreditLevel="";
			if("".equals(sCreditLevel))
			{
				sReturn = "�ÿͻ�û���������������ܰ����ҵ��";
			}
				
		}
		
		//����ũ����ɫ����
		if(sBusinessType.startsWith("1150"))
		{
			//ȡ�øÿͻ��Ƿ�ũ��,�Ƿ����û�
			sSql ="select IndRPRType,FIsCredited from IND_INFO where CustomerID ='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sIndRPRType = rs.getString("IndRPRType");
				sFIsCredited = rs.getString("FIsCredited");
				if(sIndRPRType == null) sIndRPRType="";
				if(sFIsCredited == null) sFIsCredited="";
			}
			rs.getStatement().close();
			
			if("010".equals(sIndRPRType))//ũ��
			{
				if(sBusinessType.equals("1150050"))//ũ�����ù�ͬ����ũ������
				{
					sSql = "select count(*) from CUSTOMER_RELATIVE where RelationShip like '0701%'  and RelativeID='"+sCustomerID+"'";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next())
						 NumTemp = rs.getInt(1);
					
					rs.getStatement().close();
					
					if(NumTemp == 0)
						sReturn = "�ÿͻ��������ù�ͬ���Ա�����ܰ����ҵ��";
				}
				
				if(sBusinessType.equals("1150020"))//ũ����������
				{
					//sSql = "select count(*) from CUSTOMER_RELATIVE where RelationShip like '0501%'  and RelativeID='"+sCustomerID+"'";
					sSql = "select count(*) from CUSTOMER_RELATIVE where customerID in(select CustomerID from CUSTOMER_RELATIVE where RelationShip like '0501%'  and RelativeID='"+sCustomerID+"')";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next())
						 NumTemp = rs.getInt(1);
					
					rs.getStatement().close();
					
					if(NumTemp == 0)
					{
						sReturn = "�ÿͻ�����ũ������С���Ա�����ܰ����ҵ��";
					}
					if(!sFIsCredited.equals("1"))
					{
						sReturn = "�ÿͻ��������û������ܰ����ҵ��";
					}
				}
				
				
			}
		}
		//����,�Ѿ���������ͨ����ҵ��������
		if(sOccurType.equals("090")){
			sSql = " select count(*) from Business_Apply where RelativeAgreement='"+sRelativeAgreement+"'" +
				   " and OccurType = '090'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){	
				 NumTemp = rs.getInt(1);
			}
			rs.getStatement().close();
			
			if(NumTemp > 0){
				sReturn = "��ҵ���Ѿ������󣬲����ٴ�������";
			}else
			{
				sSql = " select count(*) from Business_Contract BC,Business_PutOut BP,Flow_Object FO" +
					   " where BC.SerialNo = BP.ContractSerialNo and FO.ObjectNo = BP.SerialNo and FO.ObjectType ='PutOutApply' " +
					   " and FO.PhaseType ='1040' and BC.RelativeSerialNo ='"+sRelativeAgreement+"'  ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
					 NumTemp = rs.getInt(1);
				
				rs.getStatement().close();
				
				if(NumTemp > 0)
					sReturn = "��Ҫ�����ҵ���Ѿ���������ͨ�������ܽ��и���";
			}
		}
		
		//------------�ÿͻ������ڽ���ͬ��������ҵ������ǷϢ�����ܰ���������ҵ������------------------
		if(sApplyType.equals("DependentApply"))
		{
			sSql = " select nvl(sum(nvl(NormalBalance,0) + nvl(OverDueBalance,0)+nvl(DullBalance,0)+nvl(InterestBalance1,0)+nvl(InterestBalance1,0) ),0) as SpecialBalance " +
				   " from Business_Contract where BusinessType not like '30%' and CustomerID ='"+sCustomerID+"' and (FinishDate = '' and FinishDate is null) ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum > 0)
				sReturn  += "�ÿͻ��������ڻ���ǷϢ�����ܰ���������ҵ��";
			
		}
	
		return sReturn;
	}
		
}
