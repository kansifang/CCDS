package com.amarsoft.datainit.importobj;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.PreparedStatement;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.web.upload.File;
import com.amarsoft.web.upload.Files;
/**
 * 
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public abstract class TextImport implements ObjImportImpl {
	protected TextResultSet TRS = null;
	protected int iCount = 0;
	// 装各下拉框
	protected Transaction Sqlca = null;
	private String[] files = null;
	protected String fileName="";
	/**
	 * 解析xls 将数据插入数据表中
	 */
	public TextImport(Transaction Sqlca, String[] files, TextResultSet TRS) {
		this.Sqlca = Sqlca;
		this.files = files;
		this.TRS = TRS;
	}
	public void action() throws Exception {
		for(String sFilePathName:this.files){
			this.fileName =StringFunction.getFileName(sFilePathName);
			BufferedReader br = new BufferedReader(new FileReader(sFilePathName));
			this.TRS.setReader(br);
			this.TRS.setReInitPara(true);
			this.TRS.setInitWho(this.fileName);
			// 普通文本导入
			while (this.TRS.next()) {
				if (this.checkObj()) {
					this.importObj();
					if (this.iCount >= 500) {
						for (PreparedStatement ps : this.TRS.getPs().values()) {
							ps.executeBatch();
						}
						this.iCount = 0;
					}
				}
			}
			for (PreparedStatement ps : this.TRS.getPs().values()) {
				if (ps != null) {
					ps.executeBatch();
					ps.close();
				}
			}
			br.close();
		}
	}
}