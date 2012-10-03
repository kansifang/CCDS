/**
 * Author: --lpzhang 2009-8-7  
 * Tester:                               
 * Describe: --取得工程机械额度从协议总金额 
 * Input Param:                          
 * 		ObjectNo : 主协议号
 * 		SerialNo : 本从协议号
 * 		CreditSum : 本从协议金额
 *      Currency : 本从协议币种
 * Output Param:                         
 * 	   dTotalSum ：	转换为主协议后的金额和          
 * HistoryLog:                           
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class getTotalCreditSum extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
		String sObjectNo = (String)this.getAttribute("ObjectNo");//主协议号
		String sSerialNo = (String)this.getAttribute("SerialNo");//本从协议号
        double dCreditSum = Double.valueOf((String)this.getAttribute("CreditSum")).doubleValue();//本从协议金额
        String sCurrency = (String)this.getAttribute("Currency");//本从协议币种
        String sParentCurrency = (String)this.getAttribute("ParentCurrency");//主协议币种
        
		String sSql = "";
		ASResultSet rs = null;
		String sTotalSum = "";
		double dTotalSum = 0.0 ,dZCreditSum =0.0; 
        sSql = "select Sum(nvl(CreditSum*getERate(Currency,'"+sParentCurrency+"',''),0)) as dTotalSum  from Dealer_Agreement where ObjectNo = '"+sObjectNo+"' and SerialNo <> '"+sSerialNo+"'";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        	dTotalSum = rs.getDouble("dTotalSum");
        else
    	   dTotalSum =0.0;
        rs.getStatement().close();
        
       sSql= "select "+dCreditSum+"*getERate('"+sCurrency+"','"+sParentCurrency+"','') as ZCreditSum  from (values 1) as a ";
       dZCreditSum = Sqlca.getDouble(sSql).doubleValue();
       //总金额
       dTotalSum = dTotalSum+dZCreditSum;
       sTotalSum = String.valueOf(dTotalSum);
        return sTotalSum;

	}

}
