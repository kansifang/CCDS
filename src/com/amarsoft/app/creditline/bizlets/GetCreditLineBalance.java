/**
 * ȡ�����Ŷ��ʵ�ʿ��ý��  
 * @author hwang
 * @date 2009-06-23 21:00  
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.util.DataConvert;

import java.util.Arrays;


public class GetCreditLineBalance extends Bizlet {

	/**
	 * @return ʵ�ʿ��ý��
	 */
	public Object run(Transaction Sqlca) throws Exception {
		/**
		 * ���Ŷ��Э���(��ͬ��)
		 */
        String sLineNo = (String)this.getAttribute("LineNo");        
		
		String sSql = "";
		ASResultSet rs = null;
		String sLineCurrency="";//��ȱ���
		String sObjectNo="";//��ͬ��ˮ��
		String sContractNoList="";//��ͬ��ˮ������
		String[] sContractNos=null;//��ͬ��ˮ������,���ڼ���ÿ�ʺ�ͬ�ĳ���
		String sCreditCycle="";//����Ƿ�ѭ��
        double sBalance = 0;//���
        String sPigeonholeDate=null;//��ɷŴ�����
        String sExposureFlag="";//���㳨�ڱ�־��sum:���㳨�ڽ��,balance:���㳨�����
        double dLine = 0.0;//��Ƚ��
        double dContractSum = 0.0;//����ɷŴ���ͬ�ܽ��
        double dContractBalance = 0.0;//����ɷŴ���ͬ����ܺ�
        int i=0;//���ڼ���
        int iCount=0;//��������Ⱥ�ͬ��
        
       
        //ȡ���Э����,����,ѭ����Ϣ
        sSql = "select nvl(BusinessSum,0) as BusinessSum,BusinessCurrency,CreditCycle from BUSINESS_CONTRACT where SerialNO = '"+sLineNo+"'";
        rs = Sqlca.getASResultSet(sSql);
    	while(rs.next()){
    		sLineCurrency = rs.getString("BusinessCurrency");
    		sCreditCycle = rs.getString("CreditCycle");
    		dLine = rs.getDouble("BusinessSum");
    	}
    	rs.getStatement().close();
    	
        //ȡ�ù����ö�ȵ�:��ͬ��ˮ������sContractNoList,��ͬ��ˮ������sContractNos
        sSql = "Select SerialNo from Business_Contract B where B.BusinessType not like '30%' and (B.FinishDate = '' or B.FinishDate is null)  and B.CreditAggreement = '"+sLineNo+"'";
    	rs = Sqlca.getASResultSet(sSql);
    	iCount = rs.getRowCount();//��ȡ��������Ⱥ�ͬ��
    	sContractNos=new String[iCount];
    	i=0;
    	while(rs.next()){
    		sObjectNo = rs.getString("SerialNo");
    		sContractNos[i]=sObjectNo;
    		if(i==0){
    			sContractNoList+="'"+sObjectNo+"'";
    		}else{
    			sContractNoList+=",'"+sObjectNo+"'";
    		}
    		i++;
    	}
    	rs.getStatement().close();	
    	if(sContractNoList.length()==0) sContractNoList ="''";
    	
    	//��ȡ�������������ɷŴ���ͬ�ܽ��(�������Ƿ�����ɷŴ�),����ת�ɶ�ȱ���
    	sSql = "select sum(nvl(BusinessSum,0)*geterate(BusinessCurrency,'"+sLineCurrency+"',ERateDate)) as ContractSum from BUSINESS_CONTRACT where SerialNo in("+sContractNoList+")";
    	rs = Sqlca.getASResultSet(sSql);
    	while(rs.next()){
    		dContractSum = rs.getDouble("ContractSum");
    	}
    	rs.getStatement().close();
    	
    	//��ȡ�������������ɷŴ���ͬ��������ܺ�
    	Bizlet bzGetExposureBalance = new GetExposureBalance();
    	//��ÿ�ʺ�ͬ�������
    	for(i=0;i<iCount;i++)
    	{
    		sObjectNo=sContractNos[i];
    		sSql="select PigeonholeDate from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";
    		rs = Sqlca.getASResultSet(sSql);
        	if(rs.next()){
        		sPigeonholeDate = rs.getString("PigeonholeDate");
        	}
        	rs.getStatement().close();
        	if(sPigeonholeDate !=null && sPigeonholeDate.length() !=0){//�ñʺ�ͬ����ɷŴ�
        		sExposureFlag="balance";
        	}else{
        	//û����ɷŴ�
        		sExposureFlag="sum";
        	}
        bzGetExposureBalance.setAttribute("Currency",sLineCurrency);
    		bzGetExposureBalance.setAttribute("Flag",sExposureFlag);
    		bzGetExposureBalance.setAttribute("ObjectType","BusinessContract");
    		bzGetExposureBalance.setAttribute("ObjectNo",sObjectNo);
    		dContractBalance+=Double.valueOf((String)bzGetExposureBalance.run(Sqlca)).doubleValue();//���ۼ�
    	}
    	
    	//ȡ���ʵ�ʿ��ý��
    	if("1".equals(sCreditCycle))//��ѭ��
    	{
    		sBalance = (dLine - dContractBalance);//������=��Ⱥ�ͬ���-�������ʶ�Ⱥ�ͬ��������ܺ�
    	}else{//����ѭ��,����û���Ƿ�ѭ����Ϣ����Ϊ����ѭ��
    		sBalance = (dLine - dContractSum);//������=��Ⱥ�ͬ���-�������ʶ�Ⱥ�ͬ�ܽ��
    	}
    	//���¶�����
    	//sSql = "update BUSINESS_CONTRACT set TotalBalance = "+DataConvert.toDouble(sBalance)+" where SerialNo = '"+sLineNo+"'";
    	//Sqlca.executeSQL(sSql);
        
    	return sBalance;

	}

}
