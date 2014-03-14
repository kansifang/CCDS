package com.lmt.baseapp.flow;
import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.baseapp.util.DBFunction;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;


public class InitializeFlow extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = DataConvert.toString((String)this.getAttribute("ObjectType"));
		//������
		String sObjectNo = DataConvert.toString((String)this.getAttribute("ObjectNo"));
		//��������
		String sApplyType = DataConvert.toString((String)this.getAttribute("ApplyType"));
		//���̱��
		String sFlowNo = DataConvert.toString((String)this.getAttribute("FlowNo"));
		//�׶α��
		String sPhaseNo = DataConvert.toString((String)this.getAttribute("PhaseNo"));	
		//�û�����
		String sUserID = DataConvert.toString((String)this.getAttribute("UserID"));
		//��������
		String sOrgID = DataConvert.toString((String)this.getAttribute("OrgID"));
        		
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
				
		//��ȡ���û�����
		sSql = " select UserName from USER_INFO where UserID = '"+sUserID+"' ";
		sUserName = DataConvert.toString(Sqlca.getString(sSql));
	    //ȡ�û�������
		sSql = " select OrgName from ORG_INFO where OrgID = '"+sOrgID+"' ";
		sOrgName = DataConvert.toString(Sqlca.getString(sSql));
        //ȡ����������
		sSql = " select FlowName from FLOW_CATALOG where FlowNo = '"+sFlowNo+"' ";
		sFlowName = DataConvert.toString(Sqlca.getString(sSql));
        //ȡ�ý׶�����
		sSql = " select PhaseName,PhaseType from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			sPhaseName = DataConvert.toString(rs.getString("PhaseName"));
			sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
		}
		rs.getStatement().close(); 
		//��ÿ�ʼ����
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();	 
	    //�����̶����FLOW_OBJECT������һ����Ϣ
	    String sSql1 =  " Insert into FLOW_OBJECT("+
	    				" ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,"+
	    				" FlowName,PhaseNo,PhaseName,OrgID,OrgName," +
			    	    " UserID,UserName,InputDate) " +
			            " values ("+
			    	    "'"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"',"+
			            "'"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sOrgName+"',"+
			    	    "'"+sUserID+"','"+sUserName+"','"+StringFunction.getToday()+"')";
	    //�����������FLOW_TASK������һ����Ϣ
	    sSerialNo = DBFunction.getSerialNo("FLOW_TASK","SerialNo",Sqlca);
        String sSql2 =  " insert into FLOW_TASK("+
        				" SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,"+
        				" FlowNo,FlowName,PhaseNo,PhaseName,OrgID, " +
         				" UserID,UserName,OrgName,BegInTime) "+
         				" values ("+
         				"'"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"'," + 
         				"'"+sFlowNo+"','"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"',"+
         				"'"+sUserID+"','"+sUserName+"','"+sOrgName+"','"+sBeginTime+"')";
	    //ִ�в������
	    Sqlca.executeSQL(sSql1);
	    Sqlca.executeSQL(sSql2);
	    return "1";
	 }
}
