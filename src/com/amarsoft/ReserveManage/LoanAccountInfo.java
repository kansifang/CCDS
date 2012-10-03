package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import java.util.Vector;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;


public class LoanAccountInfo {
	
	private Transaction Sqlca = null;
	public String sCurBatchDate = "";//批量下载数据日期（本期）
	public String sLastBatchDate = "";//批量下载数据日期（上一期）
	public String sCurAccountMonth = "";//会计月份（本期）
	public String sLastAccountMonth = "";//会计月份（上一期）
	
	public LoanAccountInfo(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
	
	/**
	 * 获取批量下载数据日期（本期）和会计月份（本期）
	 * @param
	 * @return
	 */
	public void getCurAccountMonth() throws Exception
	{
		ASResultSet rs = null;
		String sSql = "";
		String sInputDate = "";
		
		sSql = 	" select max(InputDate) as InputDate "+
				" from LOANACCOUNT_INFO ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sInputDate = rs.getString("InputDate");
			if(sInputDate == null) sInputDate = "";
		}
		rs.getStatement().close();
		
		if(!sInputDate.equals(""))
		{
			this.sCurBatchDate = sInputDate;
			this.sCurAccountMonth = sInputDate.substring(0, 4) + "/" + sInputDate.substring(4, 6);
		}				
	}
	
	/**
	 * 获取批量下载数据日期（上一期）和会计月份（上一期）
	 * @param
	 * @return
	 */
	public void getLastAccountMonth() throws Exception
	{
		ASResultSet rs = null;
		String sSql = "";
		String sInputDate = "";
		
		sSql = 	" select max(InputDate) as InputDate "+
				" from LOANACCOUNT_INFO "+
				" where InputDate < '"+this.sCurBatchDate+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sInputDate = rs.getString("InputDate");
			if(sInputDate == null) sInputDate = "";
		}
		rs.getStatement().close();
		
		if(!sInputDate.equals(""))
		{
			this.sLastBatchDate = sInputDate;
			this.sLastAccountMonth = sInputDate.substring(0, 4) + "/" + sInputDate.substring(4, 6);
		}				
	}
	
	/**
	 * 根据会计月份获取核心系统相关信息
	 * @param sInputDate 批量下载数据日期
	 * @return ArrayList 依次为：贷款帐号、余额、汇率、目前余额折合人民币、科目、贷款年利率、资产类别、币种
	 */
	public Vector getLoanAccountInfo(String sInputDate) throws Exception
	{
		//定义变量	
		Vector v = new Vector();
		ASResultSet rs = null;
		String sSql = "";
				
		//获取核心系统相关信息
		sSql = 	" select Account,Balance,getERateByPaijia(Currency,'01','"+this.sCurBatchDate+"') as ExchangeRate, "+
				" Balance*getERateByPaijia(Currency,'01','"+this.sCurBatchDate+"') as RMBBalance,Subject,BusinessRate, "+
				" BusinessFlag,Currency "+
				" from LOANACCOUNT_INFO "+
				" where InputDate = '"+sInputDate+"' ";
		System.out.println(sSql);
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			ArrayList al=new ArrayList();
			al.add(0, rs.getString("Account"));
			al.add(1, rs.getString("Balance"));
			al.add(2, rs.getString("ExchangeRate"));
			al.add(3, rs.getString("RMBBalance"));
			al.add(4, rs.getString("Subject"));
			al.add(5, rs.getString("BusinessRate"));
			al.add(6, rs.getString("BusinessFlag"));
			al.add(7, rs.getString("Currency"));
			v.add(al);
		}
		rs.getStatement().close();
		
		return v;
	}
	
	/**
	 * 根据会计月份和贷款帐号获取余额信息
	 * @param sInputDate 批量下载数据日期,sLoanAccountNo 贷款帐号
	 * @return double 余额
	 */
	public double getBalance(String sInputDate,String sLoanAccountNo) throws Exception
	{
		//定义变量	
		ASResultSet rs = null;
		String sSql = "";
		double dBalance = 0.0;
				
		//获取贷款余额
		sSql = 	" select Balance "+
				" from LOANACCOUNT_INFO "+
				" where InputDate = '"+sInputDate+"' "+
				" and Account = '"+sLoanAccountNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dBalance = rs.getDouble(1);
		}
		rs.getStatement().close();
						
		return dBalance;
	}
	
	/**
	 * 将本期缺少的上期结清的数据补充到本期记录中
	 *
	 */
	public void amendRecord()throws Exception{
		getCurAccountMonth();
		getLastAccountMonth();
		amendRecord(this.sLastBatchDate, this.sCurBatchDate);
	}

	/**
	 * 将本期缺少的上期结清的数据补充到本期记录中
	 *
	 */
	public void amendRecord(String sLastInputDate, String sCurInputDate)throws Exception{
		String sOmitSql = "select account from LOANACCOUNT_INFO where InputDate = '" + sLastInputDate + "'" + 
		                  " minus " + 
		                  "select account from LOANACCOUNT_INFO where InputDate = '" + sCurInputDate + "'" ;
		String sInsSql = "insert into LOANACCOUNT_INFO (" + 
		                 " InputDate, Account, BusinessFlag, Currency, Balance, Subject, BusinessRate ) " + 
		                 " select '" + sCurInputDate + "', Account, BusinessFlag, Currency, 0.0,  Subject, BusinessRate " + 
		                 " From LOANACCOUNT_INFO where InputDate = '" + sLastInputDate + "'" + 
		                 " and Account in (" + sOmitSql + ")";
		System.out.println(sInsSql);
		Sqlca.executeSQL(sInsSql);		
	}
	
	/**
	 * 删除非信贷类的数据
	 * @throws Exception
	 */
	public void delRecord()throws Exception{
		String sSql = "delete LOANACCOUNT_INFO where Businessflag = '0' "; //非信贷类数据
		Sqlca.executeSQL(sSql);
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			java.sql.Connection conn = ConnectionManager.getConnection("jdbc:oracle:thin:@128.1.250.64:1521:ebank2",
					"oracle.jdbc.driver.OracleDriver", "credit", "credit");
			Transaction Sqlca = new Transaction(conn);
			LoanAccountInfo bri = new LoanAccountInfo(Sqlca);
			bri.amendRecord("20070930","20071031");
			Sqlca.conn.commit();
			
		}catch(Exception e)
		{
			e.printStackTrace();
			System.out.println(e.toString());
		}
	}
}
