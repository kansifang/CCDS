/**
 * Author: --jbye 2005-08-31 17:57            
 * Tester:                               
 * Describe: --�ж��Ƿ���ϱ�����������  
 * Input Param:                          
 * 		ObjectType: ��������          
 * 		ObjectNo: ������ 
 * 		LimitationSetID : ����������ID
 *      LineID : ����ID
 * Output Param:                         
 * 		sErrorLog�����ش�����Ϣ          
 * HistoryLog:                           
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.DataConvert;

public class SubJudgeCurrency extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sObjectNo = (String)this.getAttribute("ObjectNo");
        String sObjectType = (String)this.getAttribute("ObjectType");
        String sLimitationSetID = (String)this.getAttribute("LimitationSetID");
        String sLineID = (String)this.getAttribute("LineID");
		
        if(sObjectNo==null) sObjectNo = "";
        if(sObjectType==null) sObjectType = "";
        if(sLimitationSetID==null) sLimitationSetID = "";
        if(sLineID==null) sLineID = "";
        
        String sRelativeTable = "",sCurrency = "",sLimitationID = "",sSubBalance = "";
		String sSql = "";
        String sErrorLog = "";//������־
        double dSubBusinessSum = 0.0,dSubBalance = 0.0;
        ASResultSet rs=null;
        
        //���ݶ�������ȷ����Ӧ��ҵ���ж�����
        if(sObjectType.equals("CreditApply"))	sRelativeTable = "BUSINESS_APPLY";
        else if(sObjectType.equals("AgreeApproveApply"))	sRelativeTable = "BUSINESS_APPROVE";
        else if(sObjectType.equals("BusinessContract"))	sRelativeTable = "BUSINESS_CONTRACT";
        
        //�ж�һ��ȡ�õ�ǰҵ����֡����볨�ڽ����Ϣ�����û�б�ʾ ��ҵ����ֲ����ڶ�Ӧ���ŷ�Χ
        sSql = "select BusinessCurrency,(BusinessSum-BailSum)*getERate(BusinessCurrency,'01',ERateDate) "+
        	 " from "+sRelativeTable+" where  SerialNo='"+sObjectNo+"'";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
		{ 
        	sCurrency = rs.getString("BusinessCurrency");
        	dSubBusinessSum = rs.getDouble(2);
		}else	sErrorLog = "ErrorType=NOFOUND_BUSINESSAPPLY;";
        //�ж�һ����
        rs.getStatement().close();
        
        //�ж϶���ʼ��ȡ�ö�Ӧ��������������ID���ж��Ƿ������������
        sSql = "select LimitationID from CL_LIMITATION where  LimitationSetID='"+sLimitationSetID+"' " +
        		" and LimObjectNo='"+sCurrency+"'";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        { 
        	sLimitationID = rs.getString("LimitationID");//���ų��ڽ��
        	//ȡ�ö�Ӧ���������Ŀ������
            Bizlet SubLineBalance2 = new GetCreditLine2Balance_Sub();
            SubLineBalance2.setAttribute("LimitationID",sLimitationID); 
            SubLineBalance2.setAttribute("LineID",sLineID); 
            SubLineBalance2.setAttribute("WhereClause"," and BusinessCurrency = '"+sCurrency+"'"); 
            sSubBalance = (String)SubLineBalance2.run(Sqlca);
            dSubBalance = DataConvert.toDouble(sSubBalance);
            //����������Ž�����Ӧ���������Ŀ�������򷵻� ��ͨ�� ��־Ϊ �� EX_SUB_CURRENCY
            if(dSubBusinessSum>dSubBalance) sErrorLog = "ErrorType=EX_SUB_CURRENCY;";
       	}else sErrorLog = "ErrorType=EX_SUB_CURRENCY_NF;";
        rs.getStatement().close();
    	
        //�ж϶�����
        return sErrorLog;

	}

}