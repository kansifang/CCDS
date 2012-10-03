package com.amarsoft.datainit.batchno;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.TextResultSet;
public  class BatchNoTextResultSet extends TextResultSet{
	private ASUser CurUser=null;
	public BatchNoTextResultSet(Transaction sqlca,ASUser CurUser)throws Exception{
		super(sqlca);
		this.CurUser=CurUser;
	}
	public void initResultSetMeta(String initWho) throws Exception{
		this.columns.clear();
		if("qrybail2.txt".equals(initWho)){//电票
			this.addColumn("BatchNo","批次号",1);                                                                      
			this.addColumn("BillNo","票号",4); 
			this.addColumn("DuebillNo","业务编号",5);
		}else if("bill.txt".equals(initWho)){//纸票
			this.addColumn(new String[]{"BillNo","DuebillNo"},new String[]{"票号"},1); 
			this.addColumn("BatchNo","批次号",2); 
		}
		this.addColumn("ImportNo", "导入批量号",10000);
	}
	public void initResultSetPara() throws Exception{
		super.initResultSetPara();
		this.setFixLengthMode(false);
		this.setSeparator(",");
		this.setaReplaceBWithAInValue(new String[][]{{"\"",""},{"\\s",""},{"渤海银行","" },{"渤海银行股份有限公司",""}});
		SimpleDateFormat sdf=new SimpleDateFormat("'N"+CurUser.UserID+"'yyyyMMddhhmm");
		this.setString("ImportNo", sdf.format(new Date())+"000000");
	}
}
