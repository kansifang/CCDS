package com.amarsoft.datainit.importobj;

import java.io.FileInputStream;
import java.sql.PreparedStatement;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.ars.jxl.core.Sheet;
import com.amarsoft.ars.jxl.core.Workbook;

/**
 * 
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public abstract  class ExcelImport implements ObjImportImpl{
	protected ExcelResultSet ERS=null;
	protected int iCount=0;
	// 装各下拉框
	protected Transaction Sqlca = null;
	private String[] files = null;
	protected String fileName="";
	/**
	 * 解析xls 将数据插入数据表中
	 */
	public ExcelImport(Transaction Sqlca, String[] files,ExcelResultSet ERS) {
		this.Sqlca = Sqlca;
		this.files = files;
		this.ERS=ERS;
	}
	public void action() throws Exception {
		Workbook workbook = null;
		for(String sFilePathName:this.files){
			this.fileName=StringFunction.getFileName(sFilePathName);
			workbook = Workbook.getWorkbook(new FileInputStream(new java.io.File(sFilePathName)));
			int count = workbook.getSheets().length;
			for (int j = 0; j < count; ++j) {
				Sheet sheet = workbook.getSheet(j);
				this.ERS.setSheet(sheet);
				this.ERS.setReInitPara(true);
				this.ERS.setInitWho(sheet.getName());
				while(this.ERS.next()){
					if(!this.checkHead()){//sheet不符合要求时直接跳过
						break;
					}
					if (this.checkObj()) {
						this.importObj();
					}
					if (this.iCount >=500) {
						for(PreparedStatement ps:this.ERS.getPs().values()){
							ps.executeBatch();
						}
						this.iCount=0;
					}
				}
				for(PreparedStatement ps:this.ERS.getPs().values()){
					if(ps!=null){
						ps.executeBatch();
						ps.close();
					}
				}
			}
			workbook.close();
		}
	}
	public abstract boolean checkHead() throws Exception;
}