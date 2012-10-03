/*
		Author: --xhyong 2012/08/23
		Tester:
		Describe: --̽���������
		Input Param:
				ObjectType: ��������
				ObjectNo: ������
		Output Param:
				Message��������ʾ��Ϣ
		HistoryLog: 
*/

package com.amarsoft.app.lending.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;



public class CheckBusinessRisk extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//System.out.println("sMiddleYear:"+sMiddleYear); 
		 
		//�����������ʾ��Ϣ��SQL��䡢��Ʒ���͡��ͻ�����
		String sMessage = "",sSql = "",sBusinessType = "";
		//�����������Ҫ������ʽ���ͻ����롢�����������������
		String sCustomerID = "",sMainTable = "",sRelativeTable = "";
		
		//����������������͡��������͡������˴��롢�������
		String sOccurType = "";
		//�����������ѯ�����
		ASResultSet rs = null;	
		
		if("CreditApply".equals(sObjectType))
		{
			//����Ӧ�Ķ���������л�ȡ����Ʒ���͡�Ʊ����������������
			sSql = 	" select CustomerID,BusinessType,OccurType from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) {
				sBusinessType = rs.getString("BusinessType");
				sCustomerID = rs.getString("CustomerID");
				sOccurType = rs.getString("OccurType");
				//����ֵת���ɿ��ַ���
				if (sBusinessType == null) sBusinessType = "";
				if (sCustomerID == null) sCustomerID = "";	
				if (sOccurType == null) sOccurType = "";
			}
			rs.getStatement().close();
			//------------��һ�ͻ�����������ܸ����ʱ����10��--------------
			if(sBusinessType.startsWith("1"))
			{
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =  interpreter.explain(Sqlca,"!��������.�Ƿ��ʱ���("+sObjectNo+","+sObjectType+",2)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sMessage  += "�ÿͻ���������+�����������ʱ���10����"+"@";
				}
		        
			}
		
			//--------------���ų�Ա����ҵ�񣬼�����������+����������ܴ����ʱ���15��---------------
			String JTCustomerID ="";
			sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
				   " and RelationShip like '04%' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				JTCustomerID = rs.getString("CustomerID");
				if(JTCustomerID == null) JTCustomerID ="";
			}
			rs.getStatement().close();
			if(!JTCustomerID.equals(""))
			{
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =  interpreter.explain(Sqlca,"!��������.�Ƿ��ʱ���("+sObjectNo+","+sObjectType+",4)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sMessage  += "�ñʴ���������+���������������ܴ��ڱ����ʱ����15����"+"@";
				}
			}
		}
		
		if("PutOutApply".equals(sObjectType))
		{
			//����Ӧ�Ķ���������л�ȡ����Ʒ���͡�Ʊ����������������
			sSql = 	" select BP.CustomerID,BP.BusinessType,BC.OccurType "+
			" from BUSINESS_CONTRACT BC,BUSINESS_PUTOUT BP "+
			" where BP.ContractSerialNo=BC.SerialNo "+
			" and BP.SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) {
				sBusinessType = rs.getString("BusinessType");
				sCustomerID = rs.getString("CustomerID");
				sOccurType = rs.getString("OccurType");
				//����ֵת���ɿ��ַ���
				if (sBusinessType == null) sBusinessType = "";
				if (sCustomerID == null) sCustomerID = "";	
				if (sOccurType == null) sOccurType = "";
			}
			rs.getStatement().close();
			
			//------------��һ�ͻ�����������ܸ����ʱ����10��--------------
			if(sBusinessType.startsWith("1"))
			{
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =  interpreter.explain(Sqlca,"!��������.�Ƿ��ʱ���("+sObjectNo+","+sObjectType+",2)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sMessage  += "�ÿͻ���������+�����������ʱ���10����"+"@";
				}
		        
			}
		
			//--------------���ų�Ա����ҵ�񣬼�����������+����������ܴ����ʱ���15��---------------
			String JTCustomerID ="";
			sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
				   " and RelationShip like '04%' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				JTCustomerID = rs.getString("CustomerID");
				if(JTCustomerID == null) JTCustomerID ="";
			}
			rs.getStatement().close();
			if(!JTCustomerID.equals(""))
			{
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =  interpreter.explain(Sqlca,"!��������.�Ƿ��ʱ���("+sObjectNo+","+sObjectType+",4)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sMessage  += "�ñʴ���������+���������������ܴ��ڱ����ʱ����15����"+"@";
				}
			}
		}
		
		return sMessage;
	 }
	

}
