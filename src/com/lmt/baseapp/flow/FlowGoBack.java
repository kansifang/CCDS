package com.lmt.baseapp.flow;

import java.sql.SQLException;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

/**
 * @authow ymwu 20131011
 * @describe  �˻�"��һ�׶�"������"��һ��" �� ��
 * 			     ��֧�пͻ�������֧���г��ύ�����е�ҵ�񣬵��˻ز�������ʱֱ���˵�֧�пͻ�����
 * 			     ֧�� �ͻ��������ϲ�����ɺ����ֱ���ύ���˻��ˣ� �����������������˻�ҵ��ʱ����Ҫ�˻ص�֧���г�
 * 			     ��ҵ���˻�ʱ�����˵���һ�׶ζ�������һ��
 * 
 * */
public class FlowGoBack {
	
	private String sObjectNo="",sSerialNo="",sPhaseNo="",sPhaseName="",sObjectType="",
		   sPhaseType="",sFirstSerialNo="";
	ASResultSet rs =null;
	Transaction Sqlca;
	
	public FlowGoBack(String SerialNo,String ObjectNo,String ObjectType,Transaction transaction) throws Exception{
		sFirstSerialNo =SerialNo;
		Sqlca = transaction;
		sObjectNo = ObjectNo;
		sObjectType = ObjectType;
	
		/**
		 * ��Flow_Task ���л�ȡ��һ�׶ε���Ϣ
		 * **/
		rs = Sqlca.getASResultSet(" Select SerialNo,PhaseNo,PhaseName,PhaseType From Flow_Task ft1 " +
								  " Where  objectno='"+sObjectNo+"' and objecttype='"+sObjectType+"' and phaseno<>'3000' and phaseno<> (  " +
								  " SELECT phaseno FROM flow_task ft2 where objectno='"+sObjectNo+"' and objecttype='"+sObjectType+"' and serialno='"+sFirstSerialNo+"') " +
								  " and serialno<'"+sFirstSerialNo+"' order by serialno desc  fetch first 1 rows only ") ;
		if(rs.next()){
			sSerialNo = rs.getString("SerialNo");
            sPhaseNo = rs.getString("PhaseNo");
            sPhaseName = rs.getString("PhaseName");
            sPhaseType = rs.getString("PhaseType");
		}
		rs.getStatement().close();
	}
	
	/**
	 * @throws SQLException 
	 * @describe �˻���һ�׶�,ɾ����ǰFlow_Task��Flow_Opinion��������һ�׶ε���Ϣ������Flow_Object
	 * **/
	public String cancel() throws SQLException{
		

		String sDeleteFlowTask = " Delete From Flow_Task where SerialNo = '"+sFirstSerialNo+"' ";
		String sUpdateFlowTask = " Update Flow_Task set EndTime='',PhaseAction='',PhaseOpinion=''  Where " +
								 " SerialNo = '"+sSerialNo+"' ";
		String sUpdateFlowObject = " Update Flow_Object set PhaseType='"+sPhaseType+"',PhaseNo='"+sPhaseNo+"'," +
								   " PhaseName='"+sPhaseName+"' where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' ";
		String sUpdateFlowOpinion = " Update Flow_Opinion set PhaseOpinion='' where SerialNo='"+sSerialNo+"' ";
		
		Boolean bool = Sqlca.conn.getAutoCommit();
		try {
			
			Sqlca.conn.setAutoCommit(false);
			Sqlca.executeSQL(sDeleteFlowTask);
			Sqlca.executeSQL(sUpdateFlowTask);
			Sqlca.executeSQL(sUpdateFlowObject);
			Sqlca.executeSQL(sUpdateFlowOpinion);
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(bool);
			return "�˻����";
		} catch (Exception e) {
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bool);
			e.printStackTrace();
			return "false$�˻���һ�׶�ʧ�ܣ�";
		}
	}
	
}
