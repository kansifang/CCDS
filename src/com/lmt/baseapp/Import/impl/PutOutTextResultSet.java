package com.lmt.baseapp.Import.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.lmt.baseapp.Import.base.TextResultSet;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.Transaction;
public  class PutOutTextResultSet extends TextResultSet{
	private ASUser CurUser=null;
	public PutOutTextResultSet(Transaction sqlca,ASUser CurUser)throws Exception{
		super(sqlca);
		this.CurUser=CurUser;
	}
	public void initResultSetMeta(String initWho) throws Exception{
		this.columns.clear();
		this.addColumn("MFCustomerID","���Ŀͻ���",1);                                                                        
		this.addColumn("CustomerName","�ͻ�����",2);                                                                
		this.addColumn("LineID","��ȱ��",3);                                                              
		this.addColumn("BusinessType","��Ʒ����",4);                                                        
		this.addColumn(new String[]{"PutOutNo","RelativeSerialNo"},new String[]{"ҵ����"},5);                                              
		this.addColumn("Currency","�ſ����",6);                                                                 
		this.addColumn("BusinessSum","�ſ���",7);                                                                      
		this.addColumn("PutOutDate","�ſ�����",8);                                                                      
		this.addColumn("Maturity","ҵ������",9);                                                             
		this.addColumn(new String[]{"TotalBailRatio"},new String[]{"��֤�����"},10);                                                     
		this.addColumn(new String[]{"TotalBailSum"},new String[]{"��֤����"},11);                                                             
		this.addColumn("BailCurrency","��֤�����",12);                                                    
		this.addColumn("UnifiedOrgID","���������",13);  
		this.addColumn("ImportNo", "����������",10000);
	}
	public void initResultSetPara() throws Exception{
		super.initResultSetPara();
		this.setFixLengthMode(false);
		this.setSeparator(",");
		this.setaReplaceBWithAInValue(new String[][]{{"\"",""},{"\\s",""},{ "��������", "" },{ "�������йɷ����޹�˾", "" }});	
		SimpleDateFormat sdf=new SimpleDateFormat("'N"+CurUser.UserID+"'yyyyMMddhhmm");
		this.setString("ImportNo", sdf.format(new Date())+"000000");
	}
}
