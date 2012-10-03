package com.amarsoft.impl.tjnh_als.bizlets;
/**
Author: --zrli 20090731
Tester:
Describe: �ͻ�����ҵ��ͳ����Ϣ���������ݿ�һ�ζ�ȡ����ͳ�ơ�
Input Param:
		sObjectType����������
		sObjectNo��������
Output Param:

HistoryLog:
*/

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.sql.rowset.FilteredRowSet;
import com.amarsoft.are.sql.Transaction;
import com.sun.rowset.FilteredRowSetImpl;

/**
 * �ͻ�����ҵ��ͳ����Ϣ���������ݿ�һ�ζ�ȡ����ͳ�ơ�
 * @author zrli
 *
 */
public class CreditData  
{
	public ResultSet rs;
	public FilteredRowSet frs;
	public String sSql ;
	public String sObjectType;
	public Transaction Sqlca;
	public boolean isEmpty;
			
	public CreditData(Transaction Sqlca,String sSql) throws Exception{
		this.Sqlca = Sqlca;
		this.sSql = sSql;
		initCreditData();
	}
	/**
	 * ���ض�Ӧһ�������µ�ĳ�л���<br>
	 * ����ȡ���ж���������ҵ�����<br>
	 * getSum("Balance","BusinessType",Tools.EQUALS,"1001010")<br>
	 * ����ȡ���ս����ڵ�ҵ�����<br>
	 * getSum("Balance","Maturity",Tools.ISEMPTYORNULL,"")<br>
	 * ����ȡ������ʽΪ���õĶ�������<br>
	 * WhereClause[] wc = new WhereClause[2];<br>
	 * wc[0] = new WhereClause("BusinessType",Tools.EQUALS,"1010010");<br>
	 * wc[1] = new WhereClause("VouchType",Tools.EQUALS,"005");<br>
	 * getSum("Balance",wc)<br>
	 * ����ȡҵ��Ʒ��Ϊ����������жҵ�ҵ�����<br>
	 * getSum("Balance","BusinessType",Tools.IN,"1001010~2010")<br>
	 * @param sColumnSum ������
	 * @param sColumn ������
	 * @param sCondition ����ֵ
	 * @return
	 * @throws Exception
	 */
	public double getSum (String sColumnSum,String sColumn,String sOperator,String sCondition) throws Exception{
		double dReturn = 0.0;
		if(isEmpty) return dReturn;
		Range r = new Range(sColumn,sOperator,sCondition);
        frs.setFilter(r); 
        frs.beforeFirst();
        try{
            while(frs.next()){
	        	dReturn += frs.getDouble(sColumnSum);
	        }
        }catch(Exception ex){
        	//System.out.println("ex.getErrorCode()="+ex.getErrorCode());    
        	//ex.printStackTrace();
        	System.out.println("sColumnSum="+sColumnSum+",sColumn="+sColumn+",sOperator="+sOperator+",sCondition="+sCondition+"��ֵ����");
        }
		return dReturn;
	}
	
	/**
	 * ����һ�������µ�������<br>
	 * 
	 * @param iType
	 * 1:������ʽ+��Ʒ
	 * @return
	 */
	public double getSum (String sColumnSum,WhereClause[] wc) throws Exception{
		double dReturn = 0.0;
		if(isEmpty) return dReturn;
		Range r = new Range(wc);
		if(wc.length>0){
			frs.setFilter(r); 
	        frs.beforeFirst();
	        try{
	            while(frs.next()){
		        	dReturn += frs.getDouble(sColumnSum);
		        }
	        }catch(SQLException ex){
	        	System.out.println("ex.getErrorCode()="+ex.getErrorCode());    
	        	ex.printStackTrace();
	        }
		}
		return dReturn;
	}
	/**
	 * ��ʼ��ҵ������
	 * @throws Exception
	 */
	private void initCreditData() throws Exception{
		rs = Sqlca.getResultSetOld(sSql);
		if(rs.next()){
			isEmpty = false;
			rs.beforeFirst();
		}
		else
			isEmpty = true;
		frs = new FilteredRowSetImpl();                    
		frs.populate(rs);
        rs.close();
        
	}
	public void closeCreditData() throws Exception{
		frs.close();
	}
}
