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
        String sBalance = null;//���
        Double dLine = null;//��Ƚ��
        Double dUsed = null;//��ʹ�ý��
                
        //��ȡ��Ƚ��
        sSql = "select LineSum1 from CL_INFO where LineID = '"+sLineID+"'";
        dLine = Sqlca.getDouble(sSql);        
        if(dLine == null) throw new Exception("ȡ��Ƚ�����û���ҵ����"+sLineID);
        //��ȡ����Э����ˮ��
        sSql = "select BCSerialNo from CL_INFO where LineID = '"+sLineID+"'";
        sCreditAggreement = Sqlca.getString(sSql);    
        
        sSql = "select sum(((case when balance is null then 0 else balance end)-(case when BailSum is null then 0 else BailSum end))*getERate(BusinessCurrency,'01',ERateDate)) "+
        	 " from BUSINESS_CONTRACT where CreditAggreement = '"+sCreditAggreement+"' ";
        dUsed = Sqlca.getDouble(sSql);
        
        sBalance = String.valueOf(dLine.doubleValue() - dUsed.doubleValue());
        return sBalance;

	}

}
