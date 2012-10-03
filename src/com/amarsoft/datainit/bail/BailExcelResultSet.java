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
		this.addColumn(new String[]{"BPPutOutNo","PutOutNo","DuebillNo"},new String[]{"Ʊ��","���κ�","ҵ����"});                                                                      
		this.addColumn("BailAccountNo","��֤���˺�");   
		this.addColumn(new String[]{"SubAcct1"},new String[]{"�����˺�","����"});  
		this.addColumn(new String[]{"ACHoldSum","PLHoldSum"},new String[]{"���","��֤����"});   
		this.addColumn("BailAccountSum","��֤�����");
		this.addColumn("BailCurrency","��֤�����");
		this.addColumn("ImportNo", "����������",10000);//10000�Ժ��������ֶΣ���������һЩ�̶�ֵ
	}
	public void initResultSetPara() throws Exception {
		super.initResultSetPara();
		SimpleDateFormat sdf=new SimpleDateFormat("'N"+CurUser.UserID+"'yyyyMMddhhmm");
		this.setString("ImportNo", sdf.format(new Date())+"000000");
	}
}
