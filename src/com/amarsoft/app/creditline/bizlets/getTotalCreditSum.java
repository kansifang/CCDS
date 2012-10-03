/**
 * Author: --lpzhang 2009-8-7  
 * Tester:                               
 * Describe: --ȡ�ù��̻�е��ȴ�Э���ܽ�� 
 * Input Param:                          
 * 		ObjectNo : ��Э���
 * 		SerialNo : ����Э���
 * 		CreditSum : ����Э����
 *      Currency : ����Э�����
 * Output Param:                         
 * 	   dTotalSum ��	ת��Ϊ��Э���Ľ���          
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
		String sObjectNo = (String)this.getAttribute("ObjectNo");//��Э���
		String sSerialNo = (String)this.getAttribute("SerialNo");//����Э���
        double dCreditSum = Double.valueOf((String)this.getAttribute("CreditSum")).doubleValue();//����Э����
        String sCurrency = (String)this.getAttribute("Currency");//����Э�����
        String sParentCurrency = (String)this.getAttribute("ParentCurrency");//��Э�����
        
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
       //�ܽ��
       dTotalSum = dTotalSum+dZCreditSum;
       sTotalSum = String.valueOf(dTotalSum);
        return sTotalSum;

	}

}
