package com.amarsoft.impl.tjnh_als.bizlets;

import java.sql.SQLException;

import javax.sql.RowSet;
import javax.sql.rowset.CachedRowSet;
import javax.sql.rowset.Predicate;

/**
 * 
 * @author zrli
 * @discribe �����Ƕ�FilteredRowSet�Ĺ�������
 */
class Range implements Predicate {
	
	private String sColumn ;
	private String sOperator;
	private String sCondition;
	private WhereClause[] whereClause;
	
	/**
	 * ���캯��1
	 * @param sColumn ����
	 * @param sCondition ����ֵ
	 */
	public Range(String sColumn,String sOperator,String sCondition) {
		this.whereClause = new WhereClause[1];
		whereClause[0] = new WhereClause();
		whereClause[0].sCondition = sCondition;
		whereClause[0].sColumn = sColumn;
		whereClause[0].sOperator = sOperator;
	}

	/**
	 * ���캯��2
	 * @param iColumnNum ������
	 */
	public Range(int iColumnNum){
		this.whereClause = new WhereClause[iColumnNum];
		for(int i = 0;i<iColumnNum;i++)
			whereClause[i] = new WhereClause();
	}
	
	/**
	 * ���캯��3
	 * @param iColumnNum ������
	 */
	public Range(WhereClause[] whereClause){
		this.whereClause = whereClause;
	}
	
	/**
	 * �Ե�N���������г�ʼ��
	 * @param iColumnNum
	 * @param sColumn
	 * @param sCondition
	 */
	public void initWhereClause(int iColumn,String sColumn,String sCondition){
		whereClause[iColumn].sColumn = sColumn;
		whereClause[iColumn].sCondition = sCondition;
	}
	/**
	 * �Ǽ̳нӿ�Predicate�ķ���
	 */
	public boolean evaluate(RowSet rs) {
		try {
			if(whereClause != null && whereClause.length > 0){		
				//ѭ���趨ÿ������
				for(int i = 0; i<whereClause.length; i++){
					sColumn = rs.getString(whereClause[i].sColumn);
					sOperator = whereClause[i].sOperator;
					sCondition = whereClause[i].sCondition;
					
					//���Ƚ������������ж�
					if(sOperator.equals(Tools.S1)){
						if(compare(Tools.S1))
							continue;
					}
					
					//�������ΪNULL������δͳ��ΪNULL��������ôֱ��FALSE
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
						//���ڱȽ�ʱ����ֶ�Ϊ��ͨ��
						if(sColumn == null)
							return false;
						//if(Double.parseDouble(sColumn.replace("/", ""))<Double.parseDouble(sCondition.replace("/", "")))
						if(sColumn.compareTo(sCondition)<0)
							continue;
					}else if(sOperator.equals(Tools.AFTER)){
						//���ڱȽ�ʱ����ֶ�Ϊ��ͨ��
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
	 * �ر�ʽ�ıȽ�,��Ϊ����whereClause�������㣬�����漰����ر�����ʱ�赥�����塣
	 * @param sFlag
	 * @return
	 */
	public boolean compare(String sFlag){
		//S1 �����㷽ʽ��ָ(A<>B or A is null)
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
