/**
 * 
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author William
 *
 */
public class DefGetCreditLine2Balance extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sLineID = (String)this.getAttribute("LineID");
		
		String sSql = "";
		String sCreditAggreement = "";
        String sBalance = null;//余额
        Double dLine = null;//额度金额
        Double dUsed = null;//已使用金额
                
        //获取额度金额
        sSql = "select LineSum1 from CL_INFO where LineID = '"+sLineID+"'";
        dLine = Sqlca.getDouble(sSql);        
        if(dLine == null) throw new Exception("取额度金额错误：没有找到额度"+sLineID);
        //获取授信协议流水号
        sSql = "select BCSerialNo from CL_INFO where LineID = '"+sLineID+"'";
        sCreditAggreement = Sqlca.getString(sSql);    
        
        sSql = "select sum(((case when balance is null then 0 else balance end)-(case when BailSum is null then 0 else BailSum end))*getERate(BusinessCurrency,'01',ERateDate)) "+
        	 " from BUSINESS_CONTRACT where CreditAggreement = '"+sCreditAggreement+"' ";
        dUsed = Sqlca.getDouble(sSql);
        
        sBalance = String.valueOf(dLine.doubleValue() - dUsed.doubleValue());
        return sBalance;

	}

}
