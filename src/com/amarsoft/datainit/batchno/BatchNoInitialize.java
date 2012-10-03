package com.amarsoft.datainit.batchno;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.ObjImportImpl;
/**
 * 
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class BatchNoInitialize {
	// Text报表头和数据库对应的表
	// 装各下拉框
	private Transaction Sqlca = null;
	private ObjImportImpl OII=null;
	private ASUser CurUser=null;
	/**
	 * 解析xls 将数据插入数据表中
	 */
	public BatchNoInitialize(Transaction Sqlca, String[] files,ASUser CurUser)throws Exception {
		this.Sqlca = Sqlca;
		this.CurUser = CurUser;
		this.OII = new BatchNoTextImport(Sqlca,files,CurUser);
	}
	public void handle() throws Exception {
		//0、把Text导入数据库
		this.OII.action();
	}
}