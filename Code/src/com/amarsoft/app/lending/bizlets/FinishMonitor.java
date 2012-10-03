/*
Author:   xhyong 2009/09/22
Tester:
Describe: �����ʲ��ճ�������ɼ����ز���
Input Param:
		ContractSerialNo: ��ͬ��ˮ��
		ReportType: ��������
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishMonitor extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//��ȡ����:��ͬ��,��������
		String sContractSerialNo = (String)this.getAttribute("ContractSerialNo");
		String sReportType = (String)this.getAttribute("ReportType");
		
		//����ֵת���ɿ��ַ���
		if(sContractSerialNo == null) sContractSerialNo = "";
		if(sReportType == null) sReportType = "010";//Ĭ��Ϊһ����
		
		//�������:���뷽ʽ
		String sApplyType = "",sReturnMessage = "";
		String sBadType = "",sFactUser = "",sBorrowerManageStatus = "";
		String sBorrowerAssetStatus = "",sBorrowerAttitude = "",sDebtInstance = "";
		String sFactVouchDegree = "" ,sVouchEffectDate = "",sLawEffectDate = "";
		String sExistNewType = "",sTextDocStatus = "",sBadLoanCaliber = "";
		int dCount = 0;
		//�������ݼ�
		String sSql = "";
		ASResultSet rs=null;
		//��ѯ�Ƿ��н����м�ر���
		sSql = "select count(SerialNo) as Count  from MONITOR_REPORT "+
				" where ObjectNo='"+sContractSerialNo+"'"+
				" and (FinishDate is null or FinishDate ='') "+
				" and ReportType='"+sReportType+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			dCount=rs.getInt("Count");
		}
		rs.getStatement().close();
		if(dCount >0)//����м�¼
		{
			//��ѯ��ر����¼��Ϣ
			sSql = "select BadType,FactUser,BorrowerManageStatus,BorrowerAssetStatus," +
					" BorrowerAttitude,DebtInstance,FactVouchDegree,VouchEffectDate," +
					" LawEffectDate,ExistNewType,TextDocStatus,BadLoanCaliber " +
					" from MONITOR_REPORT where SerialNo " +
					" in(select Max(SerialNo)  from MONITOR_REPORT "+
					" where ObjectNo='"+sContractSerialNo+"'"+
					" and (FinishDate is null or FinishDate ='') "+
					" and ReportType='010')";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){	
				sBadType = rs.getString("BadType");//��������
				sFactUser = rs.getString("FactUser");//ʵ���ÿ���
				sBorrowerManageStatus = rs.getString("BorrowerManageStatus");//����˾�Ӫ״��
				sBorrowerAssetStatus = rs.getString("BorrowerAssetStatus");//������ʲ�״��
				sBorrowerAttitude = rs.getString("BorrowerAttitude");//�����̬��
				sDebtInstance = rs.getString("DebtInstance");//ծ����ʵ���
				sFactVouchDegree = rs.getString("FactVouchDegree");//ʵ�ʵ����̶�
				sVouchEffectDate = rs.getString("VouchEffectDate");//����ʱЧ
				sLawEffectDate = rs.getString("LawEffectDate");//����ʱЧ
				sExistNewType = rs.getString("ExistNewType");//������������
				sTextDocStatus = rs.getString("TextDocStatus");//�ı��������
				sBadLoanCaliber = rs.getString("BadLoanCaliber");//��������ھ�
			}
			rs.getStatement().close();
			//���µ���ͬ��Ӧ��Ϣ
			//ֻ������治������ɽ��û������������Ʊ���û�һ���ر�����и���
			if(sBadType.equals("010")||sBadType.equals("020")||sBadType.equals("030"))
			{
				sSql = " UPDATE BUSINESS_CONTRACT SET FactUser='"+sFactUser+"',"+
						" BorrowerManageStatus='"+sFactUser+"',BorrowerAssetStatus='"+sBorrowerAssetStatus+"',"+
						" BorrowerAttitude='"+sBorrowerAttitude+"',DebtInstance='"+sDebtInstance+"',"+
						" FactVouchDegree='"+sFactVouchDegree+"',VouchEffectDate='"+sVouchEffectDate+"',"+
						" LawEffectDate='"+sLawEffectDate+"',ExistNewType='"+sExistNewType+"',"+
						" TextDocStatus='"+sTextDocStatus+"',BadLoanCaliber='"+sBadLoanCaliber+"' "+
						" WHERE SerialNo='"+sContractSerialNo+"'";
				Sqlca.executeSQL(sSql);
			}
			//�ü����ɱ�ʶ��
			sSql = " UPDATE MONITOR_REPORT SET FinishDate='"+StringFunction.getToday()+"' "+
					" WHERE ObjectNo='"+sContractSerialNo+"' and (FinishDate is null or FinishDate ='') " +
					" and ReportType='"+sReportType+"'";
			Sqlca.executeSQL(sSql);
			//���º�ͬ�������
			if(sReportType.equals("020"))//�ص��ؼ������
			{
				sSql = " UPDATE BUSINESS_CONTRACT SET EMonitorDate='"+StringFunction.getToday()+"' "+
						" WHERE SerialNo='"+sContractSerialNo+"'";
				Sqlca.executeSQL(sSql);
			}else//һ���ؼ������
			{
				sSql = " UPDATE BUSINESS_CONTRACT SET CMonitorDate='"+StringFunction.getToday()+"' "+
						" WHERE SerialNo='"+sContractSerialNo+"'";
				Sqlca.executeSQL(sSql);
			}
			sReturnMessage="True";//�����ɹ�
		}else
		{
			sReturnMessage="None";//û���ҵ���Ӧ�ļ����Ϣ
		}
		return sReturnMessage;
	}

}

