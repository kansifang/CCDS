package com.amarsoft.impl.tjnh_als.bizlets;

/**
 * ������Ϊ����CreditData����
 * 
 * @author zrli
 * 
 */
public class WhereClause {
	public String sColumn;

	public String sCondition;
	
	public String sOperator;
	
	public WhereClause(){
		
	}
	
	public WhereClause(String sColumn,String sOperator,String sCondition){
		this.sColumn = sColumn;
		this.sCondition = sCondition;
		this.sOperator = sOperator;
	}
	

}
