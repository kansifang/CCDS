package com.lmt.app.cms.dbh;
//bllou 20120216 通用删除方法 多个删除语句的要素用“~”分割
import java.util.StringTokenizer;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.Transaction;

public class DeleteColValue extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//表名
		String sTableName = (String)this.getAttribute("TableName");
		if(sTableName == null) sTableName = "";
		//查询条件（格式："类型@列名@列值"）
		String sWhereClause = (String)this.getAttribute("WhereClause");
		if(sWhereClause == null) sWhereClause = "";
		//表名字符串、条件字符串
		String sTableStr = "",sWhereStr = "";
		//SQL语句、返回值
		String sSql = "",sReturnValue = "";
		//计数器i、计数器j
		int j = 0,m = 0;
		//拆分表名
		StringTokenizer stTableArgs1 = new StringTokenizer(sTableName,"~");
		String [] stTableArgsCount = new String[stTableArgs1.countTokens()];
		while (stTableArgs1.hasMoreTokens()) 
		{
			sTableStr = "";	
			sTableStr = sTableStr + stTableArgs1.nextToken().trim();
			stTableArgsCount[j] = sTableStr;
			j++;			
		}
		//拆分条件
		StringTokenizer stWhereArgs1 = new StringTokenizer(sWhereClause,"~");
		String [] stWhereArgsCount = new String[stWhereArgs1.countTokens()];
		while (stWhereArgs1.hasMoreTokens()) 
		{
			sWhereStr = "";
			StringTokenizer stWhereArgs2 = new StringTokenizer(stWhereArgs1.nextToken().trim(),"@");
			while(stWhereArgs2.hasMoreTokens())
			{				
				String sArgType  = stWhereArgs2.nextToken().trim();
				String sArgName  = stWhereArgs2.nextToken().trim();
				String sArgValue  = stWhereArgs2.nextToken().trim();					
				if (sArgType.equals("String"))
				{
					sWhereStr = sWhereStr +  sArgName + " = " + "'" + sArgValue + "'";
				}else if (sArgType.equals("Number"))
				{
					sWhereStr = sWhereStr + sArgName + " = " + sArgValue;
				}else if (sArgType.equals("None"))
				{
					sWhereStr = sWhereStr +  sArgName +  " = " + sArgValue;
				}else if (sArgType.equals("Exists"))
				{
					sWhereStr = sWhereStr +  " Exists ( " + sArgValue+")";
				}
				sWhereStr = sWhereStr + " and ";				
			}
			if(sWhereStr.length() > 0)
				sWhereStr = sWhereStr.substring(0,sWhereStr.length()-4);			
			stWhereArgsCount[m] = sWhereStr;
			m++;			
		}
		//循环组成删除语句并删除相应数据
		for(int n = 0 ; n < stTableArgsCount.length ; n ++)
		{
			sSql = "";
			try{
				sSql = sSql + " delete from "+stTableArgsCount[n]+" where "+stWhereArgsCount[n];
				Sqlca.executeSQL(sSql);
				sReturnValue = "TRUE";
			}catch(Exception e)
			{
				sReturnValue = "FALSE";
				throw e;
			}
		}
		return sReturnValue;
	}
}
