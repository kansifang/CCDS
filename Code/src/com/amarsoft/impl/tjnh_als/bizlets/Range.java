package com.amarsoft.impl.tjnh_als.bizlets;

import java.sql.SQLException;

import javax.sql.RowSet;
import javax.sql.rowset.CachedRowSet;
import javax.sql.rowset.Predicate;

/**
 * 
 * @author zrli
 * @discribe 此类是对FilteredRowSet的过滤条件
 */
class Range implements Predicate {
	
	private String sColumn ;
	private String sOperator;
	private String sCondition;
	private WhereClause[] whereClause;
	
	/**
	 * 构造函数1
	 * @param sColumn 列名
	 * @param sCondition 条件值
	 */
	public Range(String sColumn,String sOperator,String sCondition) {
		this.whereClause = new WhereClause[1];
		whereClause[0] = new WhereClause();
		whereClause[0].sCondition = sCondition;
		whereClause[0].sColumn = sColumn;
		whereClause[0].sOperator = sOperator;
	}

	/**
	 * 构造函数2
	 * @param iColumnNum 多少列
	 */
	public Range(int iColumnNum){
		this.whereClause = new WhereClause[iColumnNum];
		for(int i = 0;i<iColumnNum;i++)
			whereClause[i] = new WhereClause();
	}
	
	/**
	 * 构造函数3
	 * @param iColumnNum 多少列
	 */
	public Range(WhereClause[] whereClause){
		this.whereClause = whereClause;
	}
	
	/**
	 * 对第N个条件进行初始化
	 * @param iColumnNum
	 * @param sColumn
	 * @param sCondition
	 */
	public void initWhereClause(int iColumn,String sColumn,String sCondition){
		whereClause[iColumn].sColumn = sColumn;
		whereClause[iColumn].sCondition = sCondition;
	}
	/**
	 * 是继承接口Predicate的方法
	 */
	public boolean evaluate(RowSet rs) {
		try {
			if(whereClause != null && whereClause.length > 0){		
				//循环设定每个条件
				for(int i = 0; i<whereClause.length; i++){
					sColumn = rs.getString(whereClause[i].sColumn);
					sOperator = whereClause[i].sOperator;
					sCondition = whereClause[i].sCondition;
					
					//首先进行特殊条件判断
					if(sOperator.equals(Tools.S1)){
						if(compare(Tools.S1))
							continue;
					}
					
					//如果数据为NULL，并且未统计为NULL的数据那么直接FALSE
					if(sColumn == null && !(sOperator.equals(Tools.ISNULL)||sOperator.equals(Tools.ISEMPTYORNULL)))
							return false;
					
					if(sOperator.equals(Tools.EQUALS)){
						if(sColumn.equals(sCondition))
							continue;
					}
					else if(sOperator.equals(Tools.INCLUDED)){
						if(sColumn.indexOf(sCondition)>0)
							continue;
					}
					else if(sOperator.equals(Tools.ISNOTNULL)){
						if(sColumn != null)
							continue;
					}else if(sOperator.equals(Tools.ISNULL)){
						if(sColumn == null)
							continue;
					}else if(sOperator.equals(Tools.LARGER)){
						if(rs.getDouble(whereClause[i].sColumn) > Double.parseDouble(sCondition))
							continue;
					}else if(sOperator.equals(Tools.LARGEREQUALS)){
						if(rs.getDouble(whereClause[i].sColumn) >= Double.parseDouble(sCondition))
							continue;
					}else if(sOperator.equals(Tools.LESS)){
						if(rs.getDouble(whereClause[i].sColumn) < Double.parseDouble(sCondition))
							continue;
					}else if(sOperator.equals(Tools.LARGEREQUALS)){
						if(rs.getDouble(whereClause[i].sColumn) <= Double.parseDouble(sCondition))
							continue;
					}else if(sOperator.equals(Tools.NOTEQUALS)){
						if(!sColumn.equals(sCondition))
							continue;
					}else if(sOperator.equals(Tools.STARTWITH)){
						if(sColumn.startsWith(sCondition))
							continue;
					}else if(sOperator.equals(Tools.ISEMPTY)){
						if(!sColumn.equals(""))
							continue;
					}else if(sOperator.equals(Tools.ISNOTEMPTY)){
						if(!sColumn.equals(""))
							continue;
					}else if(sOperator.equals(Tools.BEFORE)){
						//日期比较时如果字段为则不通过
						if(sColumn == null)
							return false;
						//if(Double.parseDouble(sColumn.replace("/", ""))<Double.parseDouble(sCondition.replace("/", "")))
						if(sColumn.compareTo(sCondition)<0)
							continue;
					}else if(sOperator.equals(Tools.AFTER)){
						//日期比较时如果字段为则不通过
						if(sColumn == null)
							return false;
						//if(Double.parseDouble(sColumn.replace("/", ""))>Double.parseDouble((sCondition.replace("/", ""))))
						if(sColumn.compareTo(sCondition)>0)	
						    continue;
					}else if(sOperator.equals(Tools.ISEMPTYORNULL)){
						if(sColumn==null || sColumn.equals(""))
							continue;
					}else if(sOperator.equals(Tools.IN)){
						String[] str = sCondition.split("~");
						if( str != null && str.length > 0){
							int j=0;
							for(j=0;j<str.length;j++){
								if(sColumn.equals(str[j]))
									break;
							}
							if(j>=str.length)
								return false;
							else
								continue;
						}
						return false;
					}
					return false;
				}
				return true;
			}
			return false;
		} catch (SQLException e) {
			// do nothing
		}

		return false;

	}
	
	/**
	 * 特别方式的比较,因为主体whereClause是与运算，所以涉及或等特别运算时需单独定义。
	 * @param sFlag
	 * @return
	 */
	public boolean compare(String sFlag){
		//S1 的运算方式是指(A<>B or A is null)
		if(sFlag.equals(Tools.S1)){
			if(sColumn == null || !sColumn.equals(sCondition))
				return true;
		}
		return false;
	}

	public boolean evaluate(Object value, int column) throws SQLException {
		return false;
	}

	public boolean evaluate(Object value, String columnName)
			throws SQLException {
		return false;
	}
}
