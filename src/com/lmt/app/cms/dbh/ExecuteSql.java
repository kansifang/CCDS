package com.lmt.app.cms.dbh;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class ExecuteSql  extends Bizlet{
	
	public Object run(Transaction Sqlca) throws Exception {
		ASResultSet rs=null;
		String str ="";//返回值
		String sSql = (String) getAttribute("Sql");
		sSql = sSql.replaceAll("~BFH~","%");			
		sSql = sSql.replaceAll("~ZKH~","(");	
		sSql = sSql.replaceAll("~YKH~",")");
		sSql = sSql.replaceAll("@",",");
		sSql = sSql.replaceAll("#","+");
		sSql = sSql.replaceAll("!","-");
		sSql = sSql.replaceAll("~DY~",">");
		sSql = sSql.replaceAll("~XY~","<");
		if(-1!=sSql.indexOf("Update")){//更新
			int i= Sqlca.executeSQL(sSql);
			return i+"";
		}else{
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				if(rs.iColumnCount==1){
					str = rs.getString(1);
				}else{
				  for(int i=1;i<=rs.iColumnCount;i++){
					  String result=rs.getString(i)+"&";
					  str=str+result;
				 }
				}
			}
			rs.close();
		}
		
		return str;
	}
}
