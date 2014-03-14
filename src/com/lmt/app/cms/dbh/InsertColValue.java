package com.lmt.app.cms.dbh;
//bllou 20120216 通用插入方法 多个插入语句的要素用“~”分割
import java.util.StringTokenizer;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.Transaction;

public class InsertColValue extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//列名（格式："列名1,列名2"）
		String sColName = (String)this.getAttribute("ColName");
		if(sColName == null) sColName = "";
		//表名
		String sTableName = (String)this.getAttribute("TableName");
		if(sTableName == null) sTableName = "";
		//表名字符串
		String sTableStr = "";
		//SQL语句、返回值
		String sSql = "",sReturnValue = "";
		//计数器i、计数器j
		int i = 0,j = 0;
		//拆分列名
		StringBuffer sColNameStr=null;
		StringBuffer sColValueStr=null;
		StringTokenizer stColArgs1 = new StringTokenizer(sColName,"~");
		String [] stColArgsCount = new String[stColArgs1.countTokens()];
		while (stColArgs1.hasMoreTokens()) 
		{
			sColNameStr=new StringBuffer("");
			sColValueStr=new StringBuffer("");
			StringTokenizer stColArgs2 = new StringTokenizer(stColArgs1.nextToken().trim(),"@");
			while(stColArgs2.hasMoreTokens())
			{				
				String sColArgType  = stColArgs2.nextToken().trim();				
				String sColArgName  = stColArgs2.nextToken().trim();				
				String sColArgValue  = stColArgs2.nextToken().trim();	
				sColNameStr.append(sColArgName+",");
				if (sColArgType.equals("String"))
				{
					if(sColArgValue.equals("None"))
						sColValueStr.append("null");
					else
						sColValueStr.append("'"+sColArgValue+"'");
				}else if (sColArgType.equals("Number"))
				{
					if(sColArgValue.equals("None"))
						sColValueStr.append("0");
					else
						sColValueStr.append(sColArgValue);
				}else if (sColArgType.equals("Date"))
				{
					if(sColArgValue.equals("None"))
						sColValueStr.append("null");
					else
						sColValueStr.append("'"+sColArgValue+"'");
				}
				sColValueStr.append(",");				
			}
			if(sColNameStr.length() > 0 && sColValueStr.length() > 0)
				stColArgsCount[i] = "("+sColNameStr.substring(0,sColNameStr.length()-1)+") values("+sColValueStr.substring(0,sColValueStr.length()-1)+")";
			i++;			
		}	
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
		//循环组成插入语句并插入数据库
		for(int n = 0 ; n < stColArgsCount.length ; n ++)
		{
			sSql = "";
			try{
				sSql = sSql + " insert into "+stTableArgsCount[n]+stColArgsCount[n];
				int rowcount=Sqlca.executeSQL(sSql);
				if(rowcount>0){
					sReturnValue = "TRUE";
				}else{
					sReturnValue = "FALSE";
				}
			}catch(Exception e)
			{
				sReturnValue = "FALSE";
				throw e;
			}
		}
		return sReturnValue;
	}

}
