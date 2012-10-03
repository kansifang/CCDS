/*
Author:   xhyong 2009/09/25
Tester:
Describe: ��ɵ�ծ�ʲ��ճ������ر���
Input Param:
		SerialNo: ���ʵ�ծ��ˮ��
		ReportType: ��������
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishNPAReport extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//��ȡ����:��ͬ��,��������
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sReportType = (String)this.getAttribute("ReportType");
		
		//����ֵת���ɿ��ַ���
		if(sSerialNo == null) sSerialNo = "";
		if(sReportType == null) sReportType = "";//Ĭ��Ϊһ����
		
		//�������:
		String sReturnMessage = "",sAssetStatus = "";
		String sAssetAmount = "",sDescribe1 = "",sDescribe2 = "";
		String sDescribe3 = "",sDescribe4 = "";
		String sAssetCustomerName = "",sAssetLocation = "",sAssetOccurType = "";
		double dAssetAccountSum = 0.00,dAssetSaleSum = 0.00,dAssetLendSum = 0.00;
		double dAssetDisposeSum = 0.00,dAssetAccountBalance = 0.00;
		int dCount = 0;
		double dEvalNetValue = 0.00;
		//�������ݼ�
		String sSql = "";
		ASResultSet rs=null;
		//��ѯ�Ƿ��н����м��
		sSql = "select count(SerialNo) as Count  from ASSET_REPORT "+
				" where ObjectNo='"+sSerialNo+"'"+
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
			sSql = "select AssetCustomerName,AssetLocation,AssetStatus,EvalNetValue,AssetAmount,Describe1," +
					" Describe2,Describe3,Describe4,AssetOccurType,AssetAccountSum,AssetSaleSum, " +
					" AssetLendSum,AssetDisposeSum,AssetAccountBalance "+
					" from ASSET_REPORT where SerialNo " +
					" in(select Max(SerialNo)  from ASSET_REPORT "+
					" where ObjectNo='"+sSerialNo+"'"+
					" and (FinishDate is null or FinishDate ='') "+
					" and ReportType='010')";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){	
				sAssetStatus = rs.getString("AssetStatus");//��ծ�ʲ���״
				dEvalNetValue = rs.getDouble("EvalNetValue");//������ֵ/�г����ʼ�ֵ
				sAssetAmount = rs.getString("AssetAmount");//��ծ�ʲ�����
				sDescribe1 = rs.getString("Describe1");//��ծ�ʲ�������״������Ͼ��
				sDescribe2 = rs.getString("Describe2");//��ծ�ʲ�Ȩ����״��Ȩ��Ͼ��
				sDescribe3 = rs.getString("Describe3");//��ծ�ʲ�Ȩ֤�����������������Ч�̶�
				sDescribe4 = rs.getString("Describe4");//��ծ�ʲ�������������������Ԥ��
				sAssetCustomerName = rs.getString("AssetCustomerName");//�ֳ�������
				sAssetLocation = rs.getString("AssetLocation");//����(����)�ص�
				sAssetOccurType = rs.getString("AssetOccurType");//��������
				dAssetAccountSum = rs.getDouble("AssetAccountSum");//��ծ�ʲ����˽��
				dAssetSaleSum = rs.getDouble("AssetSaleSum");//��ծ�ʲ����۱��ֽ��
				dAssetLendSum = rs.getDouble("AssetLendSum");//��ծ�ʲ�������ֽ��
				dAssetDisposeSum = rs.getDouble("AssetDisposeSum");//��ծ�ʲ�������ʧ���
				dAssetAccountBalance = rs.getDouble("AssetAccountBalance");//��ծ�ʲ��������
			}
			rs.getStatement().close();
			//���µ���ծ�ʲ���Ӧ��Ϣ
			//ֻ���̨����Ϣά��
			if(sReportType.equals("010"))
			{
				sSql = " UPDATE ASSET_INFO SET AssetStatus='"+sAssetStatus+"',"+
						" EvalNetValue="+dEvalNetValue+",AssetAmount='"+sAssetAmount+"',"+
						" Describe1='"+sDescribe1+"',Describe2='"+sDescribe2+"',"+
						" Describe3='"+sDescribe3+"',Describe4='"+sDescribe4+"', "+
						" AssetLocation='"+sAssetLocation+"',AssetCustomerName='"+sAssetCustomerName+"',"+
						" AssetOccurType='"+sAssetOccurType+"',AssetAccountSum="+dAssetAccountSum+","+
						" AssetSaleSum='"+dAssetSaleSum+"',AssetLendSum="+dAssetLendSum+","+
						" AssetDisposeSum='"+dAssetDisposeSum+"',AssetAccountBalance="+dAssetAccountBalance+" "+
						" WHERE SerialNo='"+sSerialNo+"'";
				Sqlca.executeSQL(sSql);
			}
			
			//�ü����ɱ�ʶ��
			sSql = " UPDATE ASSET_REPORT SET FinishDate='"+StringFunction.getToday()+"' "+
					" WHERE ObjectNo='"+sSerialNo+"' and (FinishDate is null or FinishDate ='') " +
					" and ReportType='"+sReportType+"'";
			Sqlca.executeSQL(sSql);
			//���º�ͬ�������
			if(sReportType.equals("020"))//�̵����
			{
				sSql = " UPDATE ASSET_INFO SET LiquidateDate='"+StringFunction.getToday()+"' "+
						" WHERE SerialNo='"+sSerialNo+"'";
				Sqlca.executeSQL(sSql);
			}else//̨��ά��
			{
				sSql = " UPDATE ASSET_INFO SET VindicateDate='"+StringFunction.getToday()+"' "+
						" WHERE SerialNo='"+sSerialNo+"'";
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

