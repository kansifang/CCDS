/*
		Author: --zwhu 20100611
		Tester:
		Describe: --ǿ���ջ�����ҵ��
		Input Param:
				ObjectType: ��������
				ObjectNo: ������
				PhaseNo�����̽׶�
				sRelativeOrgID:��ǰ�����ϼ�����
		Output Param:
				sReturn��������ʾ
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class EnforceTakeBackBusiness extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//��ö�������
		String sObjectType = (String)this.getAttribute("ObjectType"); 
		//��ö�����
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//������̽׶�
		String sPhaseNo = (String)this.getAttribute("PhaseNo");
		//��õ�ǰ����
		String sOrgID = (String)this.getAttribute("OrgID");
		//��ȡ��ǰ������ˮ��
		String sSerialNo = (String)this.getAttribute("SerialNo");
		
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sPhaseNo == null) sPhaseNo = "";
		if(sSerialNo == null) sSerialNo = "";
		if(sOrgID == null) sOrgID = "";
		String sReturn = "";
		String sSql = "";
		ASResultSet rs = null;
		String sPhaseType= "",sPhaseName = "" ;
		double iCount = 0;
	
		iCount = Sqlca.getDouble("Select count(*) from FLOW_TASK Where ObjectType =  '"+sObjectType+"'"+
						" and ObjectNo = '"+sObjectNo+"' and PhaseNo = '1000'" );
		if(!"9900".equals(sOrgID) && iCount<1){
			String sRelativeOrgID = Sqlca.getString("Select RelativeOrgID from Org_Info where OrgID = '"+sOrgID+"'");
			iCount = Sqlca.getDouble("Select count(*) from FLOW_TASK Where ObjectType = '"+sObjectType+"'"+
							" and ObjectNo = '"+sObjectNo+"' and OrgID = '"+sRelativeOrgID+"'");
		}
		
		if(iCount>0&&!"ClassifyApply".equals(sObjectType)){
			sReturn = "ҵ�����ύ����һ����������׼������ǿ���ջأ�";
		}
		else{
			sSql = "Select PhaseType,PhaseName from FLOW_TASK Where ObjectType = '"+sObjectType+"' " +
					" and PhaseNo = '"+sPhaseNo+"' and ObjectNo = '"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				sPhaseType = rs.getString("PhaseType");
				sPhaseName = rs.getString("PhaseName");
				if(sPhaseType == null) sPhaseType = "";
				if(sPhaseName == null) sPhaseName = "";
			}
			rs.getStatement().close();
			iCount = Sqlca.getDouble("select count(*) from FLOW_Opinion where SerialNo in " +
					" (select Serialno from FLOW_TASK Where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' " +
					" and PhaseNo > '"+sPhaseNo+"' and SerialNo > '"+sSerialNo+"')");
			if(iCount>0)
			{	
				sSql = "delete from FLOW_Opinion where SerialNo in " +
						" (select Serialno from FLOW_TASK Where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' " +
						" and PhaseNo > '"+sPhaseNo+"' and SerialNo > '"+sSerialNo+"')";
				Sqlca.executeSQL(sSql); 
			}
			sSql = "delete from FLOW_TASK where SerialNo in " +
					" (select serialno from FLOW_TASK Where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' " +
					" and PhaseNo > '"+sPhaseNo+"' and SerialNo > '"+sSerialNo+"' )";
			Sqlca.executeSQL(sSql);
			
			sSql = "update FLOW_TASK set EndTime = null ,Phaseaction = null ,PhaseOpinion1 = null,PhaseChoice = null,"+
					" PhaseOpinion2 = null ,PhaseOpinion3 = null where serialno = '"+sSerialNo+"'";
			Sqlca.executeSQL(sSql);
			
			sSql = "update FLOW_OBJECT SET PhaseType = '"+sPhaseType+"',PhaseName = '"+sPhaseName+"',PhaseNo = '" +sPhaseNo+"'" +
					" where  ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"'";
			Sqlca.executeSQL(sSql); 
			
			sReturn = "ҵ��ǿ���ջسɹ���";
			//���շ�����²���
			if("ClassifyApply".equals(sObjectType))
			{
				sSql = "update CLASSIFY_RECORD SET finishdate = null "+
				" where  SerialNo = '"+sObjectNo+"'";
				Sqlca.executeSQL(sSql); 
			}
		}
		return sReturn;
	}

}
