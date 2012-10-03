package com.amarsoft.datainit.bail;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.ExcelResultSet;
public  class BailExcelResultSet extends ExcelResultSet{
	private ASUser CurUser=null;
	public BailExcelResultSet(Transaction sqlca,ASUser CurUser)throws SQLException{
		super(sqlca);
		this.CurUser=CurUser;
	}
	public void initResultSetMeta(String initWho) throws Exception{
		this.columns.clear();
		this.addColumn(new String[]{"BPPutOutNo","PutOutNo","DuebillNo"},new String[]{"票号","批次号","业务编号"});                                                                      
		this.addColumn("BailAccountNo","保证金账号");   
		this.addColumn(new String[]{"SubAcct1"},new String[]{"款项账号","款项"});  
		this.addColumn(new String[]{"ACHoldSum","PLHoldSum"},new String[]{"余额","保证金金额"});   
		this.addColumn("BailAccountSum","保证金比例");
		this.addColumn("BailCurrency","保证金币种");
		this.addColumn("ImportNo", "导入批量号",10000);//10000以后是自由字段，可以设置一些固定值
	}
	public void initResultSetPara() throws Exception {
		super.initResultSetPara();
		SimpleDateFormat sdf=new SimpleDateFormat("'N"+CurUser.UserID+"'yyyyMMddhhmm");
		this.setString("ImportNo", sdf.format(new Date())+"000000");
	}
}
