package com.amarsoft.app.lending.bizlets;

/*
 Author: --zywei 2006-01-17
 Tester:
 Describe: --新增机构时，同时在ORG_BELONG新增相应的机构间的层次关系
 --目前用于页面：OrgInfo
 Input Param:
 OrgID: 机构编号
 RelativeOrgID: 上级机构编号
 Output Param:

 HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.bizlet.Bizlet;

public class EvaluateScoreOrResultGene extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		// 自动获得传入的参数值
		String sModelNo = DataConvert.toString((String) this.getAttribute("ModelNo"));
		String sEItemNo = DataConvert.toString((String) this.getAttribute("ItemNo"));
		String sItemValue = DataConvert.toString((String) this.getAttribute("ItemValue"));
		String sTotalScore = DataConvert.toString((String) this.getAttribute("TotalScore"));
		String sCodeNo = DataConvert.toString((String)this.getAttribute("CodeNo"));
		// 定义变量
		ASResultSet rs = null;
		String sSql = "";
		double dValue = 0;
		if("ScoreToItemValue".equals(sCodeNo)){
			dValue =DataConvert.toDouble(sItemValue);
			sSql=" and SortNo='"+sEItemNo+"'";
		}else if("CreditLevelToTotalScore".equals(sCodeNo)){
			dValue =DataConvert.toDouble(sTotalScore);
		}
		// 判断该机构与上级机构之间的层次关系是否已存在
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
			sMessage+="-------------当前评分卡"+sEItemNo+"项的值"+sItemValue+"没有配置相应的值区间，无法获取分数！";
		}else if("CreditLevelToTotalScore".equals(sCodeNo)){
			sMessage+="-------------当前评分卡得到的总分数"+sTotalScore+"没有配置相应的值区间，无法获取最总结果！";
		}
		throw new Exception(sMessage);
	}
}
