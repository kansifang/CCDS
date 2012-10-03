package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;


public class ReservePara {
	
	private Transaction Sqlca = null;
		
	public ReservePara(Transaction Sqlca)
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
		ArrayList alReservePara = new ArrayList();//存放当前会计月份的减值准备参数
		ASResultSet rs = null;
		String sSql = "";
		
		//根据组织机构代码获取客户信息
		sSql = 	" select AccountMonth,MLossTerm,ALossTerm,MAdjustValue,AAdjustValue, "+
				" MLossRate1,MLossRate2,MLossRate3,MLossRate4,MLossRate5,ALossRate1, "+
				" ALossRate2,ALossRate3,ALossRate4,ALossRate5,MBToCRate,MBToDRate, "+
				" MBToERate,ABToCRate,ABToDRate,ABToERate,MAToBRate,MAToCRate, "+
				" MAToDRate,MAToERate,AAToBRate,AAToCRate,AAToDRate,AAToERate, "+
				" BaseDate,LastAccountMonth, Grade "+
				" from RESERVE_PARA "+
				" where AccountMonth = '"+sAccountMonth+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			alReservePara.add(0, rs.getString("AccountMonth") == null ? "" : rs.getString("AccountMonth"));//会计月份
			alReservePara.add(1, rs.getString("MLossTerm") == null ? "" : rs.getString("MLossTerm"));//管理口径识别期间
			alReservePara.add(2, rs.getString("ALossTerm") == null ? "" : rs.getString("ALossTerm"));//审计口径识别期间
			alReservePara.add(3, rs.getString("MAdjustValue") == null ? "" : rs.getString("MAdjustValue"));//管理口径调整系数
			alReservePara.add(4, rs.getString("AAdjustValue") == null ? "" : rs.getString("AAdjustValue"));//审计口径调整系数			
			alReservePara.add(5, rs.getString("MLossRate1") == null ? "" : rs.getString("MLossRate1"));//管理正常类贷款损失率
			alReservePara.add(6, rs.getString("MLossRate2") == null ? "" : rs.getString("MLossRate2"));//管理关注类贷款损失率
			alReservePara.add(7, rs.getString("MLossRate3") == null ? "" : rs.getString("MLossRate3"));//管理次级类贷款损失率
			alReservePara.add(8, rs.getString("MLossRate4") == null ? "" : rs.getString("MLossRate4"));//管理可疑类贷款损失率
			alReservePara.add(9, rs.getString("MLossRate5") == null ? "" : rs.getString("MLossRate5"));//管理损失类贷款损失率
			alReservePara.add(10, rs.getString("ALossRate1") == null ? "" : rs.getString("ALossRate1"));//审计正常类贷款损失率
			alReservePara.add(11, rs.getString("ALossRate2") == null ? "" : rs.getString("ALossRate2"));//审计关注类贷款损失率
			alReservePara.add(12, rs.getString("ALossRate3") == null ? "" : rs.getString("ALossRate3"));//审计次级类贷款损失率
			alReservePara.add(13, rs.getString("ALossRate4") == null ? "" : rs.getString("ALossRate4"));//审计可疑类贷款损失率
			alReservePara.add(14, rs.getString("ALossRate5") == null ? "" : rs.getString("ALossRate5"));//审计损失类贷款损失率
			alReservePara.add(15, rs.getString("MBToCRate") == null ? "" : rs.getString("MBToCRate"));//管理层关注转次级迁徙率
			alReservePara.add(16, rs.getString("MBToDRate") == null ? "" : rs.getString("MBToDRate"));//管理层关注转可疑迁徙率
			alReservePara.add(17, rs.getString("MBToERate") == null ? "" : rs.getString("MBToERate"));//管理层关注转损失迁徙率
			alReservePara.add(18, rs.getString("ABToCRate") == null ? "" : rs.getString("ABToCRate"));//审计关注转次级迁徙率
			alReservePara.add(19, rs.getString("ABToDRate") == null ? "" : rs.getString("ABToDRate"));//审计关注转可疑迁徙率
			alReservePara.add(20, rs.getString("ABToERate") == null ? "" : rs.getString("ABToERate"));//审计关注转损失迁徙率
			alReservePara.add(21, rs.getString("MAToBRate") == null ? "" : rs.getString("MAToBRate"));//管理层正常转关注次级迁徙率
			alReservePara.add(22, rs.getString("MAToCRate") == null ? "" : rs.getString("MAToCRate"));//管理层正常转次级迁徙率
			alReservePara.add(23, rs.getString("MAToDRate") == null ? "" : rs.getString("MAToDRate"));//管理层正常转可疑迁徙率
			alReservePara.add(24, rs.getString("MAToERate") == null ? "" : rs.getString("MAToERate"));//管理层正常转损失迁徙率
			alReservePara.add(25, rs.getString("AAToBRate") == null ? "" : rs.getString("AAToBRate"));//审计正常转关注次级迁徙率
			alReservePara.add(26, rs.getString("AAToCRate") == null ? "" : rs.getString("AAToCRate"));//审计正常转次级迁徙率
			alReservePara.add(27, rs.getString("AAToDRate") == null ? "" : rs.getString("AAToDRate"));//审计正常转可疑迁徙率
			alReservePara.add(28, rs.getString("AAToERate") == null ? "" : rs.getString("AAToERate"));//审计正常转损失迁徙率			
			alReservePara.add(29, rs.getString("BaseDate") == null ? "" : rs.getString("BaseDate"));//基准日期
			alReservePara.add(30, rs.getString("LastAccountMonth") == null ? "" : rs.getString("LastAccountMonth"));//上一月会计月份
			alReservePara.add(31, rs.getString("Grade") == null ? "" : rs.getString("Grade"));//本月更新减值准备使用的现金流级别
			
		}
		rs.getStatement().close();
		
		return alReservePara;
	}


	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			java.sql.Connection conn = ConnectionManager.getConnection("jdbc:oracle:thin:@128.1.250.64:1521:ebank2",
					"oracle.jdbc.driver.OracleDriver", "credit", "credit");
			Transaction Sqlca = new Transaction(conn);
//			ReservePara t = new ReservePara(Sqlca);			
//			ArrayList al = t.getAandBLossRate("2007/11", "A", "Q");
//			
//			Sqlca.conn.commit();
//			for(int i =0; i< al.size(); i++){
//				System.out.println(al.get(i));
//			}
			
		}catch(Exception e)
		{
			e.printStackTrace();
			System.out.println(e.toString());
		}
	}
}
