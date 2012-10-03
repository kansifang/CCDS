package com.amarsoft.app.lending.bizlets;

/*
 Author: --zywei 2006-01-17
 Tester:
 Describe: --��������ʱ��ͬʱ��ORG_BELONG������Ӧ�Ļ�����Ĳ�ι�ϵ
 --Ŀǰ����ҳ�棺OrgInfo
 Input Param:
 OrgID: �������
 RelativeOrgID: �ϼ��������
 Output Param:

 HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.bizlet.Bizlet;

public class EvaluateScoreOrResultGene extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		// �Զ���ô���Ĳ���ֵ
		String sModelNo = DataConvert.toString((String) this.getAttribute("ModelNo"));
		String sEItemNo = DataConvert.toString((String) this.getAttribute("ItemNo"));
		String sItemValue = DataConvert.toString((String) this.getAttribute("ItemValue"));
		String sTotalScore = DataConvert.toString((String) this.getAttribute("TotalScore"));
		String sCodeNo = DataConvert.toString((String)this.getAttribute("CodeNo"));
		// �������
		ASResultSet rs = null;
		String sSql = "";
		double dValue = 0;
		if("ScoreToItemValue".equals(sCodeNo)){
			dValue =DataConvert.toDouble(sItemValue);
			sSql=" and SortNo='"+sEItemNo+"'";
		}else if("CreditLevelToTotalScore".equals(sCodeNo)){
			dValue =DataConvert.toDouble(sTotalScore);
		}
		// �жϸû������ϼ�����֮��Ĳ�ι�ϵ�Ƿ��Ѵ���
		sSql = " select ItemDescribe,"
				+ " Attribute1,"
				+ " Attribute2,"
				+ " Attribute3,"
				+ " Attribute4,"
				+ " Attribute5"
				+ " from Code_Library "
				+ " where CodeNo = '"+sCodeNo+"'"
				+ " and ItemName='"+sModelNo+"'"
				+ " and IsInUse='1'"
				+ " and "
				+ "("
				+ " Attribute5 is not null and length(trim(Attribute5))>0 and locate('"+sItemValue+"',Attribute5)>0"
				+ " or"
				+ " Attribute1 is not null and length(trim(Attribute1))>0 and Attribute2 is not null and length(trim(Attribute2))>0 "
				+ " or"
				+ " Attribute3 is not null and length(trim(Attribute3))>0 and Attribute4 is not null and length(trim(Attribute4))>0 "
				+ ")"
				+sSql;
		rs = Sqlca.getASResultSet(sSql);
		while (rs.next()) {
			String sScoreOrResult = DataConvert.toString(rs.getString(1));

			String ArithmeticOpe1 = DataConvert.toString(rs.getString(2));
			String dValue1 = DataConvert.toString(rs.getString(3));

			String ArithmeticOpe2 = DataConvert.toString(rs.getString(4));
			String dValue2 = DataConvert.toString(rs.getString(5));

			String valueCode = DataConvert.toString(rs.getString(6));
			if (!"".equals(sScoreOrResult)) {
				if (!"".equals(valueCode)) {
					return sScoreOrResult;
				}
			if ("".equals(ArithmeticOpe1)// 030 >=,040 >,050 =
					||"030".equals(ArithmeticOpe1) && !"".equals(dValue1)&&dValue >= Double.valueOf(dValue1)
					|| "040".equals(ArithmeticOpe1)&& !"".equals(dValue1)&&dValue > Double.valueOf(dValue1)
					|| "050".equals(ArithmeticOpe1)&& !"".equals(dValue1)&&dValue == Double.valueOf(dValue1)){
				if ("".equals(ArithmeticOpe2)// 010 <,020 <=
						||"010".equals(ArithmeticOpe2)&&!"".equals(dValue2)&&dValue < Double.valueOf(dValue2)
						||"020".equals(ArithmeticOpe2)&&!"".equals(dValue2)&&dValue <= Double.valueOf(dValue2)
						||"050".equals(ArithmeticOpe2)&&!"".equals(dValue2)&&dValue == Double.valueOf(dValue2)){
					return sScoreOrResult;
					}
				} 
			}
		}
		rs.getStatement().close();
		//return "1";
		String sMessage="";
		if("ScoreToItemValue".equals(sCodeNo)){
			sMessage+="-------------��ǰ���ֿ�"+sEItemNo+"���ֵ"+sItemValue+"û��������Ӧ��ֵ���䣬�޷���ȡ������";
		}else if("CreditLevelToTotalScore".equals(sCodeNo)){
			sMessage+="-------------��ǰ���ֿ��õ����ܷ���"+sTotalScore+"û��������Ӧ��ֵ���䣬�޷���ȡ���ܽ����";
		}
		throw new Exception(sMessage);
	}
}
