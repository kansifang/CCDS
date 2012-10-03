package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import java.util.Vector;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;


public class LoanAccountInfo {
	
	private Transaction Sqlca = null;
	public String sCurBatchDate = "";//���������������ڣ����ڣ�
	public String sLastBatchDate = "";//���������������ڣ���һ�ڣ�
	public String sCurAccountMonth = "";//����·ݣ����ڣ�
	public String sLastAccountMonth = "";//����·ݣ���һ�ڣ�
	
	public LoanAccountInfo(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
	
	/**
	 * ��ȡ���������������ڣ����ڣ��ͻ���·ݣ����ڣ�
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
	 * ��ȡ���������������ڣ���һ�ڣ��ͻ���·ݣ���һ�ڣ�
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
	 * ���ݻ���·ݻ�ȡ����ϵͳ�����Ϣ
	 * @param sInputDate ����������������
	 * @return ArrayList ����Ϊ�������ʺš������ʡ�Ŀǰ����ۺ�����ҡ���Ŀ�����������ʡ��ʲ���𡢱���
	 */
	public Vector getLoanAccountInfo(String sInputDate) throws Exception
	{
		//�������	
		Vector v = new Vector();
		ASResultSet rs = null;
		String sSql = "";
				
		//��ȡ����ϵͳ�����Ϣ
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
	 * ���ݻ���·ݺʹ����ʺŻ�ȡ�����Ϣ
	 * @param sInputDate ����������������,sLoanAccountNo �����ʺ�
	 * @return double ���
	 */
	public double getBalance(String sInputDate,String sLoanAccountNo) throws Exception
	{
		//�������	
		ASResultSet rs = null;
		String sSql = "";
		double dBalance = 0.0;
				
		//��ȡ�������
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
	 * ������ȱ�ٵ����ڽ�������ݲ��䵽���ڼ�¼��
	 *
	 */
	public void amendRecord()throws Exception{
		getCurAccountMonth();
		getLastAccountMonth();
		amendRecord(this.sLastBatchDate, this.sCurBatchDate);
	}

	/**
	 * ������ȱ�ٵ����ڽ�������ݲ��䵽���ڼ�¼��
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
	 * ɾ�����Ŵ��������
	 * @throws Exception
	 */
	public void delRecord()throws Exception{
		String sSql = "delete LOANACCOUNT_INFO where Businessflag = '0' "; //���Ŵ�������
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
