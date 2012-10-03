/*
		Author: zwhu 2010-04-28
		Tester:
		Describe: У���ֽ��������Ƿ�ƽ��
		Input Param:
				ReportNo: ������
		Output Param:
				sReturn:  ����ֵ
		HistoryLog:
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.impl.tjnh_als.bizlets.CreditData;
import com.amarsoft.impl.tjnh_als.bizlets.Tools;

public class CheckReportData extends Bizlet {
	public Object run(Transaction Sqlca) throws Exception {
		String sReturn = "";
		String sReportNo = (String) this.getAttribute("ReportNo");
		String sSql = "";
		sSql = " Select RD.Col2value,RD.RowSubject from REPORT_DATA RD,REPORT_MODEL RM "
				+ " where RD.ReportNo = '"+sReportNo+ "'And  RM.modelno = '0008' And RD.RowNo = RM.RowNo ";
		CreditData Report = new CreditData(Sqlca, sSql);
		sReturn = CheckData(Report, "a01~a16~a17~a18~a19", "a20","��Ӫ������ֽ�����С��Ϊ:", "��Ӫ������ֽ�����С�ƻ���ֵΪ:");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report, "a02~a03~a22~a23~a24~a25~a26", "a27","��Ӫ������ֽ�����С��Ϊ��", "��Ӫ������ֽ�����С�ƻ���ֵΪ��");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report,"a01~a16~a17~a18~a19","a02~a03~a22~a23~a24~a25~a26", "810","��Ӫ����ֽ������ϼ�Ϊ��", "��Ӫ����ֽ������ϼƻ���ֵΪ��");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report, "a28~a29~a30~a31~a32", "a33","Ͷ�ʻ�ֽ�����С��Ϊ:", "Ͷ�ʻ�ֽ�����С�ƻ���ֵΪ:");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report, "a34~a35~a36~a37", "a38","Ͷ�ʻ�ֽ�����С��Ϊ��", "Ͷ�ʻ�ֽ�����С�ƻ���ֵΪ��");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report,"a28~a29~a30~a31~a32","a34~a35~a36~a37", "811","Ͷ�ʻ���ֽ������ϼ�Ϊ��", "Ͷ�ʻ���ֽ������ϼƻ���ֵΪ��");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report, "a39~a40~a41~a42", "a43","���ʻ�ֽ�����С��Ϊ:", "���ʻ�ֽ�����С�ƻ���ֵΪ:");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report, "a44~a45~a46~a47~a48~a49", "a50","Ͷ�ʻ�ֽ�����С��Ϊ��", "Ͷ�ʻ�ֽ�����С�ƻ���ֵΪ��");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report,"a39~a40~a41~a42","a44~a45~a46~a47~a48~a49", "812","���ʻ���ֽ������ϼ�Ϊ��", "���ʻ���ֽ������ϼƻ���ֵΪ��");
		if (!sReturn.equals("equals")) return sReturn;
		
		sReturn = CheckData(Report,"a01~a16~a17~a18~a19~a28~a29~a30~a31~a32~a39~a40~a41~a42","a02~a03~a22~a23~a24~a25~a26~a34~a35~a36~a37~a44~a45~a46~a47~a48~a49", "813","�ֽ�����Ϊ��", "�ֽ���������ֵΪ��");
		if (!sReturn.equals("equals")) return sReturn;
		return sReturn;
	}

	private String CheckData(CreditData Report, String s1, String s2,String s3, String s4) throws Exception {
		String sReturn = "";
		double dTotalSum1;
		double dTotalSum2;
		double dDeviation = 0.001;
		dTotalSum1 = Report.getSum("Col2value", "RowSubject", Tools.IN, s1);
		dTotalSum2 = Report.getSum("Col2value", "RowSubject", Tools.EQUALS, s2);
		if ((dTotalSum1-dTotalSum2)>dDeviation) {
			sReturn = s3 + DataConvert.toMoney(String.valueOf(dTotalSum2)) + s4 + DataConvert.toMoney(String.valueOf(dTotalSum1));
		} else {
			sReturn = "equals"; 
		}
		return sReturn;
	}

	private String CheckData(CreditData Report, String s1, String s2,String s3, String s4, String s5) throws Exception {
		String sReturn = "";
		double dTotalSum1;
		double dTotalSum2;
		double dTotalSum3;
		double dDeviation = 0.001;
		dTotalSum1 = Report.getSum("Col2value", "RowSubject", Tools.IN, s1);
		dTotalSum2 = Report.getSum("Col2value", "RowSubject", Tools.IN, s2);
		dTotalSum3 = Report.getSum("Col2value", "RowSubject", Tools.EQUALS, s3);
		if ((dTotalSum1-dTotalSum2-dTotalSum3)>dDeviation) {
			sReturn = s4 + DataConvert.toMoney(String.valueOf(dTotalSum3))+ s5 + DataConvert.toMoney(String.valueOf((dTotalSum1 - dTotalSum2))) ;
		} else {
			sReturn = "equals";
		}
		return sReturn;
	}
}
