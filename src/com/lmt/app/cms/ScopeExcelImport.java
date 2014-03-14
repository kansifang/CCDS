package com.lmt.app.cms;

import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Statement;

import jxl.Sheet;
import jxl.Workbook;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.Transaction;

/**
 * 对于特殊客户企业规模实行批量导入操作
 * @author kwang 2011/12/20
 *
 */
public class ScopeExcelImport extends Bizlet{

	private String msg = "";
	
	public Object run(Transaction Sqlca) throws Exception {
		String Today = (String)getAttribute("sToday");
	    String OrgID = (String)getAttribute("sOrgID");
	    String UserID = (String)getAttribute("sUserID");
	    String FilePath = (String)getAttribute("sFileFullPath");
	    String MSg = Excel(Sqlca, FilePath, Today, OrgID, UserID);
	    return MSg;
	}
	
	/**
	 * 执行批量导入数据
	 * @param Sqlca
	 * @param Path
	 * @param Today
	 * @param OrgID
	 * @param UserID
	 * @return
	 */
	private String Excel(Transaction Sqlca,String Path,String Today,String OrgID,String UserID){
		String sSql = "";
		boolean isCommit = false;
		try
	    {
			isCommit = Sqlca.conn.getAutoCommit();
			if(!isCommit)Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(isCommit);
			
			InputStream is = new FileInputStream(Path);// 写入到FileInputStream
			Workbook wb = Workbook.getWorkbook(is); // 得到工作薄
			Statement sts = Sqlca.conn.createStatement();
			for (int i = 0; i < wb.getSheets().length; i++) {
				Sheet st = wb.getSheet(i);
				
				for (int j = 1; j < st.getRows(); j++) {
					if(st.getCell(1, j).getContents()==null ||st.getCell(1, j).getContents().equals(""))break;
					
					Sqlca.executeSQL("delete from Wb_Sysconf_Library where ItemNo = '"+st.getCell(1, j).getContents().trim()+"' ");
					Sqlca.conn.commit();
					
					sSql = "insert into Wb_Sysconf_Library (CONFNO, ITEMNO, ITEMNAME, SORTNO, ISINUSE, ITEMDESCRIBE, ITEMATTRIBUTE, ATTRIBUTE1, " +
						   "ATTRIBUTE2, INPUTUSER, INPUTORG, INPUTTIME, UPDATEUSER, UPDATETIME, REMARK, UPDATEORG)" +
						   "values ('CustomerSopceConfig', '"+st.getCell(1, j).getContents().trim()+"', '"+st.getCell(2, j).getContents().trim()+"', " +
						   "'', '1', '"+st.getCell(3, j).getContents().trim()+"', '', '', '', '"+UserID+"', '"+OrgID+"', " +
						   "'"+Today+"', '"+UserID+"', '"+Today+"', '', '"+OrgID+"') ";
					sts.addBatch(sSql);
					if(j%100==0){
						sts.executeBatch();
						sts.clearBatch();
					}
					sts.executeBatch();
				}
			}
			
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(isCommit);
			sts.close();
			is.close();
			wb.close();
			this.msg = "导入成功";
			
	    }catch (Exception e)
	    {
	      if(e.getMessage() == "gs"){
	        this.msg = "导入格式错误";
	      }else{
	        e.printStackTrace();
	        this.msg = "导入失败";
	      }
	      try{
	    	  Sqlca.conn.rollback();
	    	  Sqlca.conn.setAutoCommit(isCommit);
	      }catch(Exception ex){
	    	  ex.printStackTrace();
	      }
	    }
	    return msg;
	  }
}
