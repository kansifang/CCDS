package com.amarsoft.app.configurator.bizlets;

import java.sql.PreparedStatement;
import java.text.DecimalFormat;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GenerateCodeCatalogSortNo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {

		//放入2维数组
		String sSql = "select CODENO,SORTNO,CODETYPEONE,CODETYPETWO,CODENAME from CODE_CATALOG where CodeTypeTwo is not null order by CODETYPEONE,CODETYPETWO"; 
		String[][] sCodeCatalog = Sqlca.getStringMatrix(sSql);


		sSql = "select CODETYPEONE,count(*) from CODE_CATALOG where CodeTypeTwo is not null group by CODETYPEONE order by CODETYPEONE"; 
		String[][] sCodeTypeOne = Sqlca.getStringMatrix(sSql);
		
		for(int i=0;i<sCodeTypeOne.length;i++){
			sSql = "insert into CODE_CATALOG(CODENO,SORTNO,CODETYPEONE,CODETYPETWO,CODENAME) " +
					"values('"+new DecimalFormat("000").format(i+1)+"0"+"'," +
							"'"+new DecimalFormat("000").format(i+1)+"0"+"'," +
							"'"+sCodeTypeOne[i][0]+"',null,'"+sCodeTypeOne[i][0]+"')";
			try{
				Sqlca.executeSQL(sSql);
				System.out.println(sCodeTypeOne[i][0]+".........succeeded");
			}catch(Exception ex){
				System.out.println(sCodeTypeOne[i][0]+".........failed");
			}
		}
		
		for(int i=0;i<sCodeTypeOne.length;i++){
			String s1 = new DecimalFormat("000").format(i+1);
			int n = 0;
			for(int j=0;j<sCodeCatalog.length;j++){
				if(sCodeCatalog[j][2]!=null && sCodeCatalog[j][2].equals(sCodeTypeOne[i][0])){
					n++;
					String s2 = new DecimalFormat("000").format(n);
					sCodeCatalog[j][1]=s1+"0"+s2+"0";
				}
			}
		}
		
		//将2维数组更新到数据库
		sSql = "update CODE_CATALOG set SORTNO=? where CODENO=?";
		PreparedStatement pstm = Sqlca.conn.prepareStatement(sSql);

		for(int i=0;i<sCodeCatalog.length;i++){
			pstm.setString(1, sCodeCatalog[i][1]);
			pstm.setString(2, sCodeCatalog[i][0]);
			pstm.addBatch();
		}
		try{
			pstm.executeBatch();
		}catch(Exception ex){
			throw new Exception("更新数据库失败："+ex);
		}
		return "succeeded";
	}

}
