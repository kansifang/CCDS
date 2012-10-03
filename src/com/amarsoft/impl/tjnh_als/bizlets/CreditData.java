package com.amarsoft.impl.tjnh_als.bizlets;
/**
Author: --zrli 20090731
Tester:
Describe: 客户授信业务统计信息，进行数据库一次读取按需统计。
Input Param:
		sObjectType：对象类型
		sObjectNo：对象编号
Output Param:

HistoryLog:
*/

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.sql.rowset.FilteredRowSet;
import com.amarsoft.are.sql.Transaction;
import com.sun.rowset.FilteredRowSetImpl;

/**
 * 客户授信业务统计信息，进行数据库一次读取按需统计。
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
	 * 返回对应一个条件下的某列汇总<br>
	 * 例：取所有短期流贷的业务余额<br>
	 * getSum("Balance","BusinessType",Tools.EQUALS,"1001010")<br>
	 * 例：取无终结日期的业务余额<br>
	 * getSum("Balance","Maturity",Tools.ISEMPTYORNULL,"")<br>
	 * 例：取担保方式为信用的短期流贷<br>
	 * WhereClause[] wc = new WhereClause[2];<br>
	 * wc[0] = new WhereClause("BusinessType",Tools.EQUALS,"1010010");<br>
	 * wc[1] = new WhereClause("VouchType",Tools.EQUALS,"005");<br>
	 * getSum("Balance",wc)<br>
	 * 例：取业务品种为短期流贷或承兑的业务余额<br>
	 * getSum("Balance","BusinessType",Tools.IN,"1001010~2010")<br>
	 * @param sColumnSum 汇总列
	 * @param sColumn 条件列
	 * @param sCondition 条件值
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
        	System.out.println("sColumnSum="+sColumnSum+",sColumn="+sColumn+",sOperator="+sOperator+",sCondition="+sCondition+"无值出错！");
        }
		return dReturn;
	}
	
	/**
	 * 返回一组条件下的余额汇总<br>
	 * 
	 * @param iType
	 * 1:担保方式+产品
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
	 * 初始化业务数据
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
