/*
		Author: zwhu 2010-04-28
		Tester:
		Describe: 校验现金流量表是否平衡
		Input Param:
				ReportNo: 报表编号
		Output Param:
				sReturn:  返回值
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
		sReturn = CheckData(Report, "a01~a16~a17~a18~a19", "a20","经营活动产生现金流入小计为:", "经营活动产生现金流入小计汇总值为:");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report, "a02~a03~a22~a23~a24~a25~a26", "a27","经营活动产生现金流出小计为：", "经营活动产生现金流出小计汇总值为：");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report,"a01~a16~a17~a18~a19","a02~a03~a22~a23~a24~a25~a26", "810","经营活动的现金流量合计为：", "经营活动的现金流量合计汇总值为：");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report, "a28~a29~a30~a31~a32", "a33","投资活动现金流入小计为:", "投资活动现金流入小计汇总值为:");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report, "a34~a35~a36~a37", "a38","投资活动现金流出小计为：", "投资活动现金流出小计汇总值为：");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report,"a28~a29~a30~a31~a32","a34~a35~a36~a37", "811","投资活动的现金流量合计为：", "投资活动的现金流量合计汇总值为：");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report, "a39~a40~a41~a42", "a43","筹资活动现金流入小计为:", "筹资活动现金流入小计汇总值为:");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report, "a44~a45~a46~a47~a48~a49", "a50","投资活动现金流出小计为：", "投资活动现金流出小计汇总值为：");
		if (!sReturn.equals("equals")) return sReturn;
		sReturn = CheckData(Report,"a39~a40~a41~a42","a44~a45~a46~a47~a48~a49", "812","融资活动的现金流量合计为：", "融资活动的现金流量合计汇总值为：");
		if (!sReturn.equals("equals")) return sReturn;
		
		sReturn = CheckData(Report,"a01~a16~a17~a18~a19~a28~a29~a30~a31~a32~a39~a40~a41~a42","a02~a03~a22~a23~a24~a25~a26~a34~a35~a36~a37~a44~a45~a46~a47~a48~a49", "813","现金净流量为：", "现金净流量汇总值为：");
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
