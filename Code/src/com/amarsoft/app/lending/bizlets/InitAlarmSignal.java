package com.amarsoft.app.lending.bizlets;

/**
 * ��ʼ����
 * @history 
 */
import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.ASResultSet;


public class InitAlarmSignal extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//��������
		String sApplyType = (String)this.getAttribute("ApplyType");
		//���̱��
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//�׶α��
		String sPhaseNo = (String)this.getAttribute("PhaseNo");	
		//�û�����
		String sUserID = (String)this.getAttribute("UserID");
		//��������
		String sOrgID = (String)this.getAttribute("OrgID");
      
		//�������:�û����ơ��������ơ��������ơ��׶����ơ��׶����͡���ʼʱ�䡢������ˮ�š�SQL
		String sUserName = "";
		String sOrgName = "";
		String sFlowName = "";
		String sPhaseName = "";	
		String sPhaseType = "";
		String sBeginTime = "";
		String sSerialNo = "";
		String sSql = "";
		//�����������ѯ�����
		ASResultSet rs=null;
		
	
		sFlowNo = "RiskSignalFlow";
		//��ȡ��ʼ���׶�
		sSql = "select InitPhase from FLOW_CATALOG where FlowNo = '"+sFlowNo+"'";
		sPhaseNo = Sqlca.getString(sSql);
		//���û�г�ʼ�׶α�ţ��׳���ʾ��Ϣ
		if(sPhaseNo==null||sPhaseNo.trim().equals(""))
			throw new Exception("��������"+sFlowNo+"û�г�ʼ���׶α�ţ�");
		
		//��ȡ���û�����
		sSql = " select UserName from USER_INFO where UserID = '"+sUserID+"' ";
		sUserName = Sqlca.getString(sSql);
	   	    
	    //ȡ�û�������
		sSql = " select OrgName from ORG_INFO where OrgID = '"+sOrgID+"' ";
		sOrgName = Sqlca.getString(sSql);
	    	    
        //ȡ����������
		sSql = " select FlowName from FLOW_CATALOG where FlowNo = '"+sFlowNo+"' ";
		sFlowName = Sqlca.getString(sSql);
			    
        //ȡ�ý׶�����
		sSql = " select PhaseName,PhaseType from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			sPhaseName = rs.getString("PhaseName");
			sPhaseType = rs.getString("PhaseType");
			
			//����ֵת���ɿ��ַ���
			if(sPhaseName == null) sPhaseName = "";
			if(sPhaseType == null) sPhaseType = "";
		}
		rs.getStatement().close(); 
		
		//��ÿ�ʼ����
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();	 
	    
	    //����ֵת���ɿ��ַ���
	    if(sObjectType == null) sObjectType = "";
	    if(sObjectNo == null) sObjectNo = "";
	    if(sPhaseType == null) sPhaseType = "";
	    if(sApplyType == null) sApplyType = "";
	    if(sFlowNo == null) sFlowNo = "";
	    if(sFlowName == null) sFlowName = "";
	    if(sPhaseNo == null) sPhaseNo = "";
	    if(sPhaseName == null) sFlowName = "";
	    if(sUserID == null) sUserID = "";
	    if(sUserName == null) sUserName = "";
	    if(sOrgID == null) sOrgID = "";
	    if(sOrgName == null) sOrgName = "";
	   	    
	    //�����̶����FLOW_OBJECT������һ����Ϣ
	    String sSql1 =  " Insert into FLOW_OBJECT(ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName,PhaseNo, " +
			    	    " PhaseName,OrgID,OrgName,UserID,UserName,InputDate) " +
			            " values ('"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"', " +
			            " '"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sOrgName+"','"+sUserID+"', "+
			            " '"+sUserName+"','"+StringFunction.getToday()+"') ";
	    //�����������FLOW_TASK������һ����Ϣ
	    sSerialNo = DBFunction.getSerialNo("FLOW_TASK","SerialNo",Sqlca);
        String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
         				" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime) "+
         				" values ('"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"', " + 
         				" '"+sFlowNo+"','"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sUserID+"', " +
         				" '"+sUserName+"','"+sOrgName+"','"+sBeginTime+"' )";

	   
	    //ִ�в������
	    Sqlca.executeSQL(sSql1);
	    Sqlca.executeSQL(sSql2);
	    	    
	    return "1";
	    
	 }

}
