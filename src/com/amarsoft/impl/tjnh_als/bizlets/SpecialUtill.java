package com.amarsoft.impl.tjnh_als.bizlets;

/**
 * 
 * @author zrli
 *
 */
public class SpecialUtill {
	
	/**
	 * 从SQL中得到WHERE条件部分
	 * @param sSql
	 * @return sWhereClause
	 */
	public static String getWhereClause(String sSql){
		try{
			String sWhereClause = "";
			int begin = sSql.toUpperCase().indexOf("WHERE");
			int group = sSql.toUpperCase().indexOf("GROUP");
			int order = sSql.toUpperCase().indexOf("ORDER");
			int end = sSql.length();
			if(group>0&&group<end) end = group;
			if(order>0&&order<end) end = order;
			sWhereClause = sSql.substring(begin, end);
			return sWhereClause;
		}catch(Exception ex){
			ex.printStackTrace();
			return "where 1=2";
		}
	}
}
