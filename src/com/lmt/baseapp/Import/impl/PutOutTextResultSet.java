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
		this.addColumn("MFCustomerID","核心客户号",1);                                                                        
		this.addColumn("CustomerName","客户名称",2);                                                                
		this.addColumn("LineID","额度编号",3);                                                              
		this.addColumn("BusinessType","产品代码",4);                                                        
		this.addColumn(new String[]{"PutOutNo","RelativeSerialNo"},new String[]{"业务编号"},5);                                              
		this.addColumn("Currency","放款币种",6);                                                                 
		this.addColumn("BusinessSum","放款金额",7);                                                                      
		this.addColumn("PutOutDate","放款日期",8);                                                                      
		this.addColumn("Maturity","业务到期日",9);                                                             
		this.addColumn(new String[]{"TotalBailRatio"},new String[]{"保证金比例"},10);                                                     
		this.addColumn(new String[]{"TotalBailSum"},new String[]{"保证金金额"},11);                                                             
		this.addColumn("BailCurrency","保证金币种",12);                                                    
		this.addColumn("UnifiedOrgID","账务机构号",13);  
		this.addColumn("ImportNo", "导入批量号",10000);
	}
	public void initResultSetPara() throws Exception{
		super.initResultSetPara();
		this.setFixLengthMode(false);
		this.setSeparator(",");
		this.setaReplaceBWithAInValue(new String[][]{{"\"",""},{"\\s",""},{ "渤海银行", "" },{ "渤海银行股份有限公司", "" }});	
		SimpleDateFormat sdf=new SimpleDateFormat("'N"+CurUser.UserID+"'yyyyMMddhhmm");
		this.setString("ImportNo", sdf.format(new Date())+"000000");
	}
}
