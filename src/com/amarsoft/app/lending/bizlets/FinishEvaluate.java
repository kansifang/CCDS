/*
Author:   bwang
Tester:
Describe: ���õȼ��϶�����Ҫ�����õȼ���¼���и���
Input Param:
		ObjectNo: ������
		sObjectType:��������
Output Param:
HistoryLog: lpzhang 2009-8-27 ��˾���õȼ�����ҵ������һ������
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishEvaluate extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//������
		String sObjectNo = (String)this.getAttribute("sObjectNo");
		String sObjectType = (String)this.getAttribute("sObjectType");
		String sBASerialNo = (String)this.getAttribute("BASerialNo");//��ҵ��һ�����������õȼ�
		//add by hldu 2012/10/16
		String[] EvaluateSerialNos = sObjectNo.split("@");	
		sObjectNo = EvaluateSerialNos[0];
		String sNewObjectNo = EvaluateSerialNos[1];
		//add end
		
		//����ֵת��Ϊ�ַ���
		if(sBASerialNo==null) sBASerialNo="";
		String sFOSerialNo ="";//���������ˮ���
		double dUserScore=0;//�˹��϶�����
		String sUserResult="";//�˹��϶����
		String sCognReason="";//�˹��϶�����
		String sInputTime="";//�˹��϶�����
		String sInputUser="";//�˹��϶���
		String sInputOrg="";//�˹��϶�����
		String sCustomerID="";//�ͻ�ID
		String sCustomerType="";//�ͻ�����
		double dNewUserScore=0;//�����˹��϶�����
		String sNewUserResult="";//�����˹��϶����
		String sIsInuse = ""; //�Ƿ�ͣ�ò��пͻ����õȼ�����		

		String sSql = "";
		ASResultSet rs=null;
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sNewObjectNo == null || sNewObjectNo.equals("null")) sNewObjectNo = "";
		//ȡ�Ƿ�ͣ�ò������õȼ����� add by hldu
		sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
		if (sIsInuse== null) sIsInuse="" ;
		//add end
		//��ѯ�϶���ɺ������϶��˵���������������
		if("".equals(sBASerialNo))
		{
			sSql = 	" select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
					" where ObjectType='"+sObjectType+"'"+
					" and ObjectNo='"+sObjectNo+"'";
		}else
		{
			sSql = 	" select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
					" where ObjectType='"+sObjectType+"'"+
					" and ObjectNo='"+sBASerialNo+"'";
		}
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			sFOSerialNo=rs.getString("OpinionNo");
		}
		if(sFOSerialNo==null)sFOSerialNo="";
		rs.getStatement().close();

		//ȡ�����϶������
		sSql = 	" select CognScore as CognScore,CognResult as CognResult,"+//�˹����������
		" NewCognScore,NewCognResult,"+//���пͻ����õȼ��������������  add by hldu
		" InputTime,InputUser,InputOrg,"+//�˹��϶�����,�϶��� ���϶�����
		" PhaseOpinion as CognReason"+
		" from Flow_Opinion"+
		" where OpinionNo='"+sFOSerialNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			dUserScore =rs.getDouble("CognScore");//�˹��϶�����
			sUserResult=rs.getString("CognResult");//�˹��϶����
			sCognReason=rs.getString("CognReason");//�˹��϶�����
			sInputTime =rs.getString("InputTime");//�˹��϶�����
			sInputUser =rs.getString("InputUser");//�˹��϶���
			sInputOrg  =rs.getString("InputOrg");//�˹��϶�����
			dNewUserScore =rs.getDouble("NewCognScore");//�˹��϶�����(��ģ��) add by hldu
			sNewUserResult=rs.getString("NewCognResult");//�˹��϶����(��ģ��)add by hldu
		}
		if(sNewUserResult==null)sNewUserResult=""; // add by hldu
		if(sUserResult==null)sUserResult="";
		if(sCognReason==null)sCognReason="";
		if(sInputTime==null)sInputTime="";
		if(sInputUser==null)sInputUser="";
		if(sInputOrg==null)sInputOrg="";
		rs.getStatement().close();
		
		//add by xhyong 2009/08/25 �����õȼ�����������µ��ͻ���Ϣ��
		//ȡ�ÿͻ������Ϣ
		sSql = 	" select CI.CustomerID as CustomerID,CI.CustomerType as CustomerType " +
				"from EVALUATE_RECORD ER,CUSTOMER_INFO CI "+
				" where ER.ObjectNO=CI.CustomerID " +
				" and ObjectType='Customer'"+
				" and ER.SerialNo='"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			sCustomerID=rs.getString("CustomerID");
			sCustomerType=rs.getString("CustomerType");
		}
		rs.getStatement().close();
		
		//���ݿͻ�����ѡ����¿ͻ��������õȼ��������
		if(sCustomerType.substring(0,2).equals("01"))//��˾�ͻ�
		{
			Sqlca.executeSQL("UPDATE ENT_INFO SET CreditLevel='"+sUserResult+"',NewCreditLevel='"+sNewUserResult+"',EvaluateDate='"+StringFunction.getToday()+"' where CustomerID= '"+sCustomerID+"'");// change by hldu
		}
		else if(sCustomerType.substring(0,2).equals("03"))//���˿ͻ�
		{
			Sqlca.executeSQL("UPDATE IND_INFO SET CreditLevel='"+sUserResult+"',NewCreditLevel='"+sNewUserResult+"',EvaluateDate='"+StringFunction.getToday()+"' where CustomerID= '"+sCustomerID+"'");// change by hldu
		}
		//add end
		//add by hldu
		//�������������˹��϶��������BA.BASEEVALUATERESULT��,<ͳ�Ʋ�ѯʹ��>
		sSql = " update Business_apply set BASEEVALUATERESULT = '"+sUserResult+"' where serialno = '"+sBASerialNo+"' ";
		Sqlca.executeSQL(sSql);
		//add end
		
		//�������õȼ���¼��
		sSql=" UPDATE EVALUATE_RECORD SET CognDate='"+sInputTime+"',"+
		" CognScore="+dUserScore+",CognResult='"+sUserResult+"',"+
		" CognReason='"+sCognReason+"',"+
		" FinishDate='"+sInputTime+"',"+
		" CognOrgID='"+sInputOrg+"',CognUserID='"+sInputUser+"'"+
		" WHERE SerialNo='"+sObjectNo+"' AND ObjectType='Customer'";// change by hldu �޸�ObjectType='"+sObjectType+"'
		Sqlca.executeSQL(sSql);
		//�������õȼ���¼���С�����״̬��,��ǰ����ҵ������������������¼״̬����Ϊ��1��-��Ч���ÿͻ�����
		sSql=" UPDATE EVALUATE_RECORD SET EvaluateYesNo = case "+
			 " when SerialNo = '"+sObjectNo+"' then '1' "+
			 " when SerialNo <> '"+sObjectNo+"' AND  EvaluateYesNo = '1' then '2'"+
			 " else EvaluateYesNo end where ObjectNo = '"+sCustomerID+"' AND ObjectType='Customer' ";
		Sqlca.executeSQL(sSql);
		//add by hldu 2012/10/16
		if(sIsInuse.equals("2"))
		{
			sSql=" UPDATE EVALUATE_RECORD SET CognDate='"+sInputTime+"',"+
			" CognScore="+dNewUserScore+",CognResult='"+sNewUserResult+"',"+
			" CognReason='"+sCognReason+"',"+
			" FinishDate='"+sInputTime+"',"+
			" CognOrgID='"+sInputOrg+"',CognUserID='"+sInputUser+"'"+
			" WHERE SerialNo='"+sNewObjectNo+"' AND ObjectType='NewEvaluate'";
			Sqlca.executeSQL(sSql);
			//�������õȼ���¼���С�����״̬��,��ǰ����ҵ������������������¼״̬����Ϊ��1��-��Ч���ÿͻ�����
			sSql=" UPDATE EVALUATE_RECORD SET EvaluateYesNo = case "+
				 " when SerialNo = '"+sNewObjectNo+"' then '1' "+
				 " when SerialNo <> '"+sNewObjectNo+"' AND EvaluateYesNo = '1' then '2'"+
				 " else EvaluateYesNo end where ObjectNo = '"+sCustomerID+"' AND ObjectType='NewEvaluate' ";
			Sqlca.executeSQL(sSql);
		}
		//add end

		return "1";

	}

}

