package com.amarsoft.datainit.bail;

import java.sql.PreparedStatement;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.CopyInfoUtil;
import com.amarsoft.datainit.importobj.ExcelImport;
/**
 * @author bllou 2012/08/13
 * @msg. 票据保证金信息导入初始化
 */
public class BailExcelImport extends ExcelImport{
	private String[]sTables=new String[]{"Bail_WasteBook_Import"};
	
	/**
	 * 解析xls 将数据插入数据表中
	 * @throws Exception 
	 */
	public BailExcelImport(Transaction Sqlca, String[] files,ASUser CurUser) throws Exception {
		super(Sqlca, files,new BailExcelResultSet(Sqlca,CurUser));
	}
	public boolean checkHead() throws Exception {
		return true;
	}
	public boolean checkObj() throws Exception{
		boolean isPass=true;
		int currentrow=this.ERS.getCurrentRow()+1;
		String sPutOutNo1=DataConvert.toString(this.ERS.getStringWH("票号"));
		String sPutOutNo2=DataConvert.toString(this.ERS.getStringWH("批次号"));
		String sPutOutNo3=DataConvert.toString(this.ERS.getStringWH("业务编号"));
		if(sPutOutNo1.length()==0&&sPutOutNo2.length()==0&&sPutOutNo3.length()==0){
			throw new Exception("文件名为"+this.fileName+"的EXCEL的第"+currentrow+"行：票号或批次号或业务编号不能为空");
		}
		String sBailAcctountNo=DataConvert.toString(this.ERS.getStringWH("保证金账号"));
		if(sBailAcctountNo.length()==0){
			throw new Exception("文件名为"+this.fileName+"的EXCEL的第"+currentrow+"行：保证金账号不能为空");
		}
		String sSubAcct1=DataConvert.toString(this.ERS.getStringWH("款项账号"));
		if(sSubAcct1.length()==0){
			throw new Exception("文件名为"+this.fileName+"的EXCEL的第"+currentrow+"行：款项账号或款项不能为空");
		}
		return isPass;
	}
	/**
	 * 拼接SQL
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public void importObj() throws Exception {
		//插入excel内容到数据库临时表中
		for(String sTable:sTables){
			PreparedStatement ps=this.ERS.getPs().get(sTable);
			ps =CopyInfoUtil.copyInfo("insert",this.ERS,"select * from "+sTable,"",null,null, null, Sqlca, ps);
			ps.addBatch();
			this.ERS.getPs().put(sTable,ps);
			this.iCount++;
		}
	}
}