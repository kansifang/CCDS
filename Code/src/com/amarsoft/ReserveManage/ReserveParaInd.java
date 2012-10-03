package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;


public class ReserveParaInd {
	
	private Transaction Sqlca = null;
		
	public ReserveParaInd(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
	
	/**
	 * 根据会计月份获取相应的减值准备参数
	 * @param sAccountMonth 会计月份
	 * @return ArrayList 依次为：会计月份、管理口径识别期间、审计口径识别期间、......
	 */
	public ArrayList getReservePara(String sAccountMonth) throws Exception
	{
		//定义变量		
		ArrayList alReserveParaInd = new ArrayList();//存放当前会计月份的减值准备参数
		ASResultSet rs = null;
		String sSql = "";
		
		//根据组织机构代码获取客户信息
		sSql = 	" select AccountMonth,AAdjustValue,ALossRate1, "+
				" ALossRate2,OverDueDaysAdjust1,OverDueDaysAdjust2,OverDueDaysAdjust3,OverDueDaysAdjust4,OverDueDaysAdjust5,OverDueDaysAdjust6, "+
				" BaseDate,LastAccountMonth, Grade "+
				" from RESERVE_INDPARA "+
				" where AccountMonth = '"+sAccountMonth+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
            alReserveParaInd.add(0, rs.getString("AccountMonth") == null ? "" : rs.getString("AccountMonth"));//会计月份
            alReserveParaInd.add(1, rs.getString("AAdjustValue") == null ? "" : rs.getString("AAdjustValue"));//审计口径调整系数			
            alReserveParaInd.add(2, rs.getString("ALossRate1") == null ? "" : rs.getString("ALossRate1"));//审计正常类贷款损失率
            alReserveParaInd.add(3, rs.getString("ALossRate2") == null ? "" : rs.getString("ALossRate2"));//审计关注类贷款损失率
            alReserveParaInd.add(4, rs.getString("OverDueDaysAdjust1") == null ? "" : rs.getString("ALossRate3"));//正常天数调整系数
            alReserveParaInd.add(5, rs.getString("OverDueDaysAdjust2") == null ? "" : rs.getString("ALossRate4"));//逾期1-30天数调整系数
            alReserveParaInd.add(6, rs.getString("OverDueDaysAdjust3") == null ? "" : rs.getString("ALossRate5"));//逾期31-90天数调整系数
            alReserveParaInd.add(7, rs.getString("OverDueDaysAdjust4") == null ? "" : rs.getString("ALossRate5"));//逾期91-180天数调整系数
            alReserveParaInd.add(8, rs.getString("OverDueDaysAdjust5") == null ? "" : rs.getString("ALossRate5"));//逾期181-360天数调整系数
            alReserveParaInd.add(9, rs.getString("OverDueDaysAdjust6") == null ? "" : rs.getString("ALossRate5"));//逾期360天以上数调整系数
            alReserveParaInd.add(10, rs.getString("BaseDate") == null ? "" : rs.getString("BaseDate"));//基准日期
            alReserveParaInd.add(11, rs.getString("LastAccountMonth") == null ? "" : rs.getString("LastAccountMonth"));//上一月会计月份
            alReserveParaInd.add(12, rs.getString("Grade") == null ? "" : rs.getString("Grade"));//本月更新减值准备使用的现金流级别
			
		}
		rs.getStatement().close();
		
		return alReserveParaInd;
	}
}
