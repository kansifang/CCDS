/**
		Author: --fhuang 2006-12-30
		Tester:
		Describe: --����Approve_Performance�������
				  --����Approve_Performance_D�е����ݣ����������ͳ����Approve_Performance_D��
				  --ÿ��������һ��
		Input Param:
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.performance;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
public class SumPerformanceData  extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception{
		String sSTATISTICDATE = (String)this.getAttribute("STATISTICDATE");//ͳ������ 
		//ͳ������Ϊ����������ʱ��,����Ϊ��ʱ���ǰһ��,��������趨
		if(sSTATISTICDATE ==null)
			sSTATISTICDATE = StringFunction.getToday();
		//�������
		String sUserID = "";//������Ա
		String sOrgID = "";//��������
		String sFlowNo = "";//���̱��
		String sPhaseNo = "";//�����׶�
		
		String sSql = "";
		ASResultSet rs = null;
		int iCount = 0;
		sSql = "select count(*) from Approve_Performance_D where STATISTICDATE='"+sSTATISTICDATE+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			iCount = rs.getInt(1);
		}
		rs.getStatement().close();
		if(iCount==0)
			throw new Exception("Approve_Performance_D��û��ͳ�����ڵ����ݣ�����");
		else
		{
			//�������ǰ����
			clearRecord(Sqlca,sSTATISTICDATE);
			//�Ȱ�UserID,OrgID,FlowNo,PhaseNo������ͳ��
			sSql = " select UserID,OrgID,FlowNo,PhaseNo,Count(*) from Approve_Performance_D "+
			       " where STATISTICDATE='"+sSTATISTICDATE+"' group by UserID,OrgID,FlowNo,PhaseNo ";
			rs = Sqlca.getASResultSet(sSql);
			//System.out.println(sSql);
			while(rs.next())
			{
				sUserID = rs.getString("UserID");//������Ա
				sOrgID = rs.getString("OrgID");//��������
				sFlowNo = rs.getString("FlowNo");//���̱��
				sPhaseNo = rs.getString("PhaseNo");//���̱��
				
				String sSql1 = "";
				sSql1 = "Insert into Approve_Performance ("+
						"STATISTICDATE,"+
						"ORGID,"+
						"USERID,"+
						"FLOWNO,"+
						"PHASENO,"+
						"CURRDEALCOUNT,"+
						"CURRDEALSUM,"+
						"MAGGREECOUNT,"+
						"MDISAGREECOUNT,"+
						"MAFLOATCOUNT,"+
						"MAGGREETIME,"+
						"MDISAGREETIME,"+
						"MAFLOATTIME,"+
						"MNAPPROVECOUNT,"+
						"MNAPPROVESUM,"+
						"MNCONTRACTCOUNT,"+
						"MNCONTRACTSUM,"+
						"MNPUTOUTCOUNT,"+
						"MNPUTOUTSUM,"+
						"MNORMALSUM,"+
						"MATTENTIONSUM,"+
						"MSECONDARYSUM,"+
						"MSHADINESSSUM,"+
						"MLOSSSUM,"+
						"MAPPLYSUM,"+
						"YAGGREECOUNT,"+
						"YDISAGREECOUNT,"+
						"YAFLOATCOUNT,"+
						"YAGGREETIME,"+
						"YDISAGREETIME,"+
						"YAFLOATTIME,"+
						"YNAPPROVECOUNT,"+
						"YNAPPROVESUM,"+
						"YNCONTRACTCOUNT,"+
						"YNCONTRACTSUM,"+
						"YNPUTOUTCOUNT,"+
						"YNPUTOUTSUM,"+
						"YNORMALSUM,"+
						"YATTENTIONSUM,"+
						"YSECONDARYSUM,"+
						"YSHADINESSSUM,"+
						"YLOSSSUM,"+
						"YAPPLYSUM,"+
						"CAGGREECOUNT,"+
						"CDISAGREECOUNT,"+
						"CAFLOATCOUNT,"+
						"CAGGREETIME,"+
						"CDISAGREETIME,"+
						"CAFLOATTIME,"+
						"CNAPPROVECOUNT,"+
						"CNAPPROVESUM,"+
						"CNCONTRACTCOUNT,"+
						"CNCONTRACTSUM,"+
						"CNPUTOUTCOUNT,"+
						"CNPUTOUTSUM,"+
						"CNORMALSUM,"+
						"CATTENTIONSUM,"+
						"CSECONDARYSUM,"+
						"CSHADINESSSUM,"+
						"CLOSSSUM,"+
						"CAPPLYSUM ) "+
						"select "+
						"STATISTICDATE,"+
						"ORGID,"+
						"USERID,"+
						"FLOWNO,"+
						"PHASENO,"+
						"sum(CURRDEALCOUNT),"+
						"sum(CURRDEALSUM),"+
						"sum(MAGGREECOUNT),"+
						"sum(MDISAGREECOUNT),"+
						"sum(MAFLOATCOUNT),"+
						"sum(MAGGREETIME),"+
						"sum(MDISAGREETIME),"+
						"sum(MAFLOATTIME),"+
						"sum(MNAPPROVECOUNT),"+
						"sum(MNAPPROVESUM),"+
						"sum(MNCONTRACTCOUNT),"+
						"sum(MNCONTRACTSUM),"+
						"sum(MNPUTOUTCOUNT),"+
						"sum(MNPUTOUTSUM),"+
						"sum(MNORMALSUM),"+
						"sum(MATTENTIONSUM),"+
						"sum(MSECONDARYSUM),"+
						"sum(MSHADINESSSUM),"+
						"sum(MLOSSSUM),"+
						"sum(MAPPLYSUM),"+
						"sum(YAGGREECOUNT),"+
						"sum(YDISAGREECOUNT),"+
						"sum(YAFLOATCOUNT),"+
						"sum(YAGGREETIME),"+
						"sum(YDISAGREETIME),"+
						"sum(YAFLOATTIME),"+
						"sum(YNAPPROVECOUNT),"+
						"sum(YNAPPROVESUM),"+
						"sum(YNCONTRACTCOUNT),"+
						"sum(YNCONTRACTSUM),"+
						"sum(YNPUTOUTCOUNT),"+
						"sum(YNPUTOUTSUM),"+
						"sum(YNORMALSUM),"+
						"sum(YATTENTIONSUM),"+
						"sum(YSECONDARYSUM),"+
						"sum(YSHADINESSSUM),"+
						"sum(YLOSSSUM),"+
						"sum(YAPPLYSUM),"+
						"sum(CAGGREECOUNT),"+
						"sum(CDISAGREECOUNT),"+
						"sum(CAFLOATCOUNT),"+
						"sum(CAGGREETIME),"+
						"sum(CDISAGREETIME),"+
						"sum(CAFLOATTIME),"+
						"sum(CNAPPROVECOUNT),"+
						"sum(CNAPPROVESUM),"+
						"sum(CNCONTRACTCOUNT),"+
						"sum(CNCONTRACTSUM),"+
						"sum(CNPUTOUTCOUNT),"+
						"sum(CNPUTOUTSUM),"+
						"sum(CNORMALSUM),"+
						"sum(CATTENTIONSUM),"+
						"sum(CSECONDARYSUM),"+
						"sum(CSHADINESSSUM),"+
						"sum(CLOSSSUM),"+
						"sum(CAPPLYSUM) "+
						"from Approve_Performance_D "+
						"where STATISTICDATE='" +sSTATISTICDATE+"' "+
						"and UserID='"+sUserID+"' "+
						"and OrgID='"+sOrgID+"' "+
						"and FlowNo='"+sFlowNo+"' "+
						"and PhaseNo='"+sPhaseNo+"' "+
						"group by "+
				        "STATISTICDATE,"+
				        "ORGID,"+
				        "USERID,"+
				        "FLOWNO,"+
				        "PHASENO";
				//System.out.println(sSql1);
				Sqlca.executeSQL(sSql1);
				System.out.println("����������"+",���̱��Ϊ"+sFlowNo+",�����׶�Ϊ"+sPhaseNo+",��������Ϊ"+sOrgID+",������ԱΪ"+sUserID);		
			}
			rs.getStatement().close();
			System.out.println("�������������");
		}
		return "Finish";
	}
	//����������еļ�¼
	 private void clearRecord(Transaction Sqlca,String sSTATISTICDATE) throws Exception
	 {
		 String sSql = "";
		 sSql = " delete from Approve_Performance where STATISTICDATE='"+sSTATISTICDATE+"'";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
}
