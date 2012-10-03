/*
		Author: --xhyong 2012/03/28
		Tester:
		Describe: --���շ������̳�ʼ��
		Input Param:
				ObjectType: ��������
				ObjectNo: ������
				TaskNo: ���̱��
		Output Param:
				Message����ʾ��Ϣ
		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import java.util.Hashtable;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;


public class ReinitClassifyFlow extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sTaskNo = (String)this.getAttribute("TaskNo");
		
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sTaskNo == null) sTaskNo = "";
				
		
		//�����������ʾ��Ϣ��SQL���,�ͻ�����
		String sMessage = "",sSql = "";
		//�����������ѯ�����
		ASResultSet rs = null;
		//�������:���̱��
		String FlowNo="";
		
		//�жϷ��շ����Ƿ��ѵ���
		sSql = 	"select count(*) from BUSINESS_CONTRACT BC,Classify_Record CR2 where BC.SerialNo = CR2.ObjectNO and BC.ClassifyResult = CR2.ClassifyLevel and CR2.SerialNo = '"+sObjectNo+"' ";
		double iCount = Sqlca.getDouble(sSql);	
		if(iCount>0)
		{
			FlowNo="ClassifyFlow01";//δ����
		}else{
			FlowNo="ClassifyFlow";//�ѵ���
		}
		String sFlowName = "";
		String sInitPhase="";
		String sPhaseType = "";
		String sPhaseName = "";
		//��ʼ��CATALOG
		sSql = "select InitPhase,FlowName from FLOW_CATALOG where FlowNo = '"+FlowNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sFlowName = rs.getString("FlowName"); //��������
			sInitPhase = rs.getString("InitPhase"); //��ʼ���׶�
			if(sFlowName == null) sFlowName ="";
			if(sInitPhase == null) sInitPhase ="";
		}
		rs.getStatement().close();
		
		
		if( sInitPhase.trim().equals(""))
			throw new Exception("��������"+FlowNo+"û�г�ʼ���׶α�ţ�");
		//��ʼ��CATALOG
		sSql = "select PhaseType,PhaseName from FLOW_MODEL where FlowNo = '"+FlowNo+"' and PhaseNo='"+sInitPhase+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sPhaseType = rs.getString("PhaseType"); //��������
			sPhaseName = rs.getString("PhaseName"); //��ʼ���׶�
			if(sPhaseType == null) sPhaseType ="";
			if(sPhaseName == null) sPhaseName ="";
		}
		rs.getStatement().close();
		
		
		String sSql1 = " Update FLOW_OBJECT set PhaseType  ='"+sPhaseType+"',FlowNo ='"+FlowNo+"'," +
				       " FlowName ='"+sFlowName+"',PhaseNo='"+sInitPhase+"',PhaseName='"+sPhaseName+"'" +
				       " where ObjectNo = '"+sObjectNo+"' and ObjectType ='"+sObjectType+"'";
		
		String sSql2 = " Update FLOW_TASK set PhaseType  ='"+sPhaseType+"',FlowNo ='"+FlowNo+"'," +
				       " FlowName ='"+sFlowName+"',PhaseNo='"+sInitPhase+"',PhaseName='"+sPhaseName+"'" +
				       " where ObjectNo = '"+sObjectNo+"' and ObjectType ='"+sObjectType+"' and SerialNo ='"+sTaskNo+"'";

		
		
	   
	    //ִ�в������
	    Sqlca.executeSQL(sSql1);
	    Sqlca.executeSQL(sSql2);
		
		return sMessage;
	 }
	 

}
