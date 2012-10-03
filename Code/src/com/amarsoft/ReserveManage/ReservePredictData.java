package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import java.util.Vector;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;



public class ReservePredictData {
	
	private Transaction Sqlca = null;
	
	public ReservePredictData(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
	
	/**
	 * 根据会计月份、贷款帐号和预测级别获得相应的预测现金流信息
	 * @param sAccountMonth 会计月份，sLoanAccountNo 贷款帐号，sGrade 预测级别
	 * @return ArrayList 依次为：会计月份、预计收回日期、借据号、......
	 */
	public Vector getPredictCapital(String sAccountMonth,String sLoanAccountNo,String sGrade) throws Exception
	{
		//定义变量
		Vector vPredictCapital = new Vector();//存放会计月份和贷款帐号对应预测现金流信息
		ArrayList alPredictCapital = null;//存放每一笔预测现金流信息
		ASResultSet rs = null;
		String sSql = "";
		
		sSql = 	" select AccountMonth,ReturnDate,ObjectNo,Grade, "+
				" PredictCapital,PredictInterest,Reason,GuarantyValue, "+
				" GuarantyReason,EnsureValue,EnsureReason,DueSum, "+
				" Discount,DiscountValue, LoanAccount "+
				" from RESERVE_PREDICTDATA "+
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' "+
				" and Grade = '"+sGrade+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			alPredictCapital = new ArrayList();
			alPredictCapital.add(0, rs.getString("AccountMonth")== null ? "" : rs.getString("AccountMonth"));//会计月份
			alPredictCapital.add(1, rs.getString("ReturnDate")== null ? "" : rs.getString("ReturnDate"));//预计收回日期
			alPredictCapital.add(2, rs.getString("ObjectNo")== null ? "" : rs.getString("ObjectNo"));//借据号
			alPredictCapital.add(3, rs.getString("Grade")== null ? "" : rs.getString("Grade"));//预测级别
			alPredictCapital.add(4, rs.getString("PredictCapital")== null ? "" : rs.getString("PredictCapital"));//预计现金流本金
			alPredictCapital.add(5, rs.getString("PredictInterest")== null ? "" : rs.getString("PredictInterest"));//预计现金流利息
			alPredictCapital.add(6, rs.getString("Reason")== null ? "" : rs.getString("Reason"));//现金流预测理由
			alPredictCapital.add(7, rs.getString("GuarantyValue")== null ? "" : rs.getString("GuarantyValue"));//预计处置的抵押品价值
			alPredictCapital.add(8, rs.getString("GuarantyReason")== null ? "" : rs.getString("GuarantyReason"));//抵押品处置理由
			alPredictCapital.add(9, rs.getString("EnsureValue")== null ? "" : rs.getString("EnsureValue"));//预计可收回的保证金额
			alPredictCapital.add(10, rs.getString("EnsureReason")== null ? "" : rs.getString("EnsureReason"));//保证金额理由
			alPredictCapital.add(11, rs.getString("DueSum")== null ? "" : rs.getString("DueSum"));//合计金额
			alPredictCapital.add(12, rs.getString("Discount")== null ? "" : rs.getString("Discount"));//折现率
			alPredictCapital.add(13, rs.getString("DiscountValue")== null ? "" : rs.getString("DiscountValue"));//折现值
			alPredictCapital.add(14, rs.getString("LoanAccount")== null ? "" : rs.getString("LoanAccount"));//贷款帐号
			
			vPredictCapital.add(alPredictCapital);
		}
		rs.getStatement().close();	
		
		return vPredictCapital;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			
		}catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
}
