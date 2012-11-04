/*
Author:   xhyong 2009/08/24
Tester:
Describe: ���շ����϶��Ժ�������Ϣ���и���
Input Param:
		SerialNo: ������ˮ��
		ObjectNo: ������
		sObjectType:��������
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishClassify extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//��ȡ����
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		
		//����ֵת���ɿ��ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		//�������
		String sFOSerialNo = "";//�����϶��˵���������������
		String sFinallyResult = "";//�˹��϶����
		String sBaseClassifyResult = "";//�˹��϶����(ʵ��)
		String sClassifyUserID = "";//�˹��϶���
		String sClassifyOrgID = "";//�˹��϶�����
		String sContractNo = "";//��ͬ��ˮ��
		String sBCClassifyResult = "";//��ͬ������
		String sCustomerID = "";//�ͻ����
		String sCustomerType = "";//�ͻ�����
		int iCount = 0;//���������ļ�¼����
		double dBusinessBalance = 0.00;//��ͬ���
		double dSUM1=0.00,dSUM2=0.00,dSUM3=0.00,dSUM4=0.00,dSUM5=0.00;
		//�������ݼ�
		String sSql = "";
		ASResultSet rs=null;
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		//��ѯ�϶���ɺ������϶��˵���������������
		sSql = 	" select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
		" where ObjectType='"+sObjectType+"'"+
		" and ObjectNo='"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			sFOSerialNo=rs.getString("OpinionNo");
		}
		if(sFOSerialNo==null)sFOSerialNo="";
		rs.getStatement().close();

		//ȡ�����϶������
		sSql = 	" select PhaseOpinion1 as FinallyResult,"+//�˹����������
		" PhaseOpinion5 as BaseClassifyResult,"+//�˹��϶����(ʵ��)
		" InputUser,InputOrg,"+//�϶��� ���϶�����
		" PhaseOpinion as CognReason"+
		" from Flow_Opinion"+
		" where OpinionNo='"+sFOSerialNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			sFinallyResult =rs.getString("FinallyResult");//�˹��϶����
			sBaseClassifyResult =rs.getString("BaseClassifyResult");//�˹��϶����(ʵ��)
			sClassifyUserID =rs.getString("InputUser");//�˹��϶���
			sClassifyOrgID  =rs.getString("InputOrg");//�˹��϶�����
		}
		if(sFinallyResult==null)sFinallyResult="";
		if(sClassifyUserID==null)sClassifyUserID="";
		if(sClassifyOrgID==null)sClassifyOrgID="";
		rs.getStatement().close();
		
		//��ѯ��ͬ���
		sSql = 	" select BC.SerialNo as ContractNo,nvl(BC.Balance,0) as Balance,BC.ClassifyResult "+
		"from Classify_Record CR,Business_Contract BC "+
		" where BC.SerialNo=CR.ObjectNo and " +
		" CR.ObjectType='BusinessContract' "+
		" and CR.SerialNo='"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			sContractNo=rs.getString("ContractNo");//��ͬ��ˮ��
			dBusinessBalance=rs.getDouble("Balance");//��ͬ���
			sBCClassifyResult=rs.getString("ClassifyResult");//��ͬ������
		}
		rs.getStatement().close();
		//��Է�����Ϊ�յ�
		if("".equals(sFinallyResult))
		{
			sFinallyResult=sBCClassifyResult;
		}
		//���º�ͬ�еķ��շ�����
		sSql=" UPDATE BUSINESS_CONTRACT SET ClassifyResult='"+sFinallyResult+"', "+
			" BaseClassifyResult='"+sBaseClassifyResult+"' "+
			" WHERE SerialNo='"+sContractNo+"'";
		Sqlca.executeSQL(sSql);
			
		//���½���еķ��շ�����
		sSql=" UPDATE BUSINESS_DUEBILL SET ClassifyResult='"+sFinallyResult+"' "+
			" WHERE RelativeSerialNo2='"+sContractNo+"'";
		Sqlca.executeSQL(sSql);
			
		//���·��շ����¼�����Ϣ
		if(sFinallyResult.substring(0,2).equals("01"))
			dSUM1=dBusinessBalance;
		if(sFinallyResult.substring(0,2).equals("02"))
			dSUM2=dBusinessBalance;
		if(sFinallyResult.substring(0,2).equals("03"))
			dSUM3=dBusinessBalance;
		if(sFinallyResult.substring(0,2).equals("04"))
			dSUM4=dBusinessBalance;
		if(sFinallyResult.substring(0,2).equals("05"))
			dSUM5=dBusinessBalance;
	
		sSql=" UPDATE CLASSIFY_RECORD SET FinallyResult='"+sFinallyResult+"', " +
			" FinallyBaseResult='"+sBaseClassifyResult+"',"+
			" SUM1="+dSUM1+",SUM2="+dSUM2+",SUM3="+dSUM3+",SUM4="+dSUM4+",SUM5="+dSUM5+", "+
			" BusinessBalance="+dBusinessBalance+",FinishDate='"+StringFunction.getToday()+"', "+
			" ClassifyUserID='"+sClassifyUserID+"',ClassifyOrgID='"+sClassifyOrgID+"' "+
			" WHERE SerialNo='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
		//add by hldu 2012/10/16
		//ȡ�ÿͻ����
		sSql = " select CustomerID ,getCustomerType(CustomerID) as CustomerType from Business_Contract where serialno = '"+sContractNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sCustomerID = rs.getString("CustomerID");
			if(sCustomerID == null) sCustomerID = "";
			sCustomerType = rs.getString("CustomerType");
			if(sCustomerType == null) sCustomerType = "";
		}
		rs.getStatement().close();
		//����ÿͻ��з��շ���Ϊ�μ������ɡ���ʧ���μ�1���μ�2�ļ�¼ʱ�����¿ͻ���Ϣ�� ���м������õȼ�ΪD
		iCount = DataConvert.toInt(Sqlca.getString(" select count(*) from CLASSIFY_RECORD where ObjectNo in "+
				                                   "(select serialno from Business_Contract where CustomerID = '"+sCustomerID+"' ) and (finallyresult like '03%' or   finallyresult like '04%'  or  finallyresult like '05%') "));
		if(iCount > 0)
		{
			if(sCustomerType.substring(0, 2).equals("01"))
			{
				Sqlca.executeSQL(" update Ent_Info set CreditLevel = 'D' where CustomerID = '"+sCustomerID+"' ");
			}else
			{
				Sqlca.executeSQL(" update Ind_Info set CreditLevel = 'D' where CustomerID = '"+sCustomerID+"' ");
			}
		}
		//add end 
		return "1";

	}

}

