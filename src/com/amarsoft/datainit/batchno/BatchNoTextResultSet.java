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
		if("qrybail2.txt".equals(initWho)){//��Ʊ
			this.addColumn("BatchNo","���κ�",1);                                                                      
			this.addColumn("BillNo","Ʊ��",4); 
			this.addColumn("DuebillNo","ҵ����",5);
		}else if("bill.txt".equals(initWho)){//ֽƱ
			this.addColumn(new String[]{"BillNo","DuebillNo"},new String[]{"Ʊ��"},1); 
			this.addColumn("BatchNo","���κ�",2); 
		}
		this.addColumn("ImportNo", "����������",10000);
	}
	public void initResultSetPara() throws Exception{
		super.initResultSetPara();
		this.setFixLengthMode(false);
		this.setSeparator(",");
		this.setaReplaceBWithAInValue(new String[][]{{"\"",""},{"\\s",""},{"��������","" },{"�������йɷ����޹�˾",""}});
		SimpleDateFormat sdf=new SimpleDateFormat("'N"+CurUser.UserID+"'yyyyMMddhhmm");
		this.setString("ImportNo", sdf.format(new Date())+"000000");
	}
}
