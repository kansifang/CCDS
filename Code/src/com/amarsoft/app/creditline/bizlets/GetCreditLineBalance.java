/**
 * 取得授信额度实际可用金额  
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
	 * @return 实际可用金额
	 */
	public Object run(Transaction Sqlca) throws Exception {
		/**
		 * 授信额度协议号(合同号)
		 */
        String sLineNo = (String)this.getAttribute("LineNo");        
		
		String sSql = "";
		ASResultSet rs = null;
		String sLineCurrency="";//额度币种
		String sObjectNo="";//合同流水号
		String sContractNoList="";//合同流水号序列
		String[] sContractNos=null;//合同流水号数组,用于计算每笔合同的敞口
		String sCreditCycle="";//额度是否循环
        double sBalance = 0;//余额
        String sPigeonholeDate=null;//完成放贷日期
        String sExposureFlag="";//计算敞口标志。sum:计算敞口金额,balance:计算敞口余额
        double dLine = 0.0;//额度金额
        double dContractSum = 0.0;//已完成放贷合同总金额
        double dContractBalance = 0.0;//已完成放贷合同余额总和
        int i=0;//用于计数
        int iCount=0;//关联本额度合同数
        
       
        //取额度协议金额,币种,循环信息
        sSql = "select nvl(BusinessSum,0) as BusinessSum,BusinessCurrency,CreditCycle from BUSINESS_CONTRACT where SerialNO = '"+sLineNo+"'";
        rs = Sqlca.getASResultSet(sSql);
    	while(rs.next()){
    		sLineCurrency = rs.getString("BusinessCurrency");
    		sCreditCycle = rs.getString("CreditCycle");
    		dLine = rs.getDouble("BusinessSum");
    	}
    	rs.getStatement().close();
    	
        //取得关联该额度的:合同流水号序列sContractNoList,合同流水号数组sContractNos
        sSql = "Select SerialNo from Business_Contract B where B.BusinessType not like '30%' and (B.FinishDate = '' or B.FinishDate is null)  and B.CreditAggreement = '"+sLineNo+"'";
    	rs = Sqlca.getASResultSet(sSql);
    	iCount = rs.getRowCount();//获取关联本额度合同数
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
    	
    	//获取关联本额度已完成放贷合同总金额(不区分是否已完成放贷),汇率转成额度币种
    	sSql = "select sum(nvl(BusinessSum,0)*geterate(BusinessCurrency,'"+sLineCurrency+"',ERateDate)) as ContractSum from BUSINESS_CONTRACT where SerialNo in("+sContractNoList+")";
    	rs = Sqlca.getASResultSet(sSql);
    	while(rs.next()){
    		dContractSum = rs.getDouble("ContractSum");
    	}
    	rs.getStatement().close();
    	
    	//获取关联本额度已完成放贷合同敞口余额总和
    	Bizlet bzGetExposureBalance = new GetExposureBalance();
    	//求每笔合同敞口余额
    	for(i=0;i<iCount;i++)
    	{
    		sObjectNo=sContractNos[i];
    		sSql="select PigeonholeDate from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";
    		rs = Sqlca.getASResultSet(sSql);
        	if(rs.next()){
        		sPigeonholeDate = rs.getString("PigeonholeDate");
        	}
        	rs.getStatement().close();
        	if(sPigeonholeDate !=null && sPigeonholeDate.length() !=0){//该笔合同已完成放贷
        		sExposureFlag="balance";
        	}else{
        	//没有完成放贷
        		sExposureFlag="sum";
        	}
        bzGetExposureBalance.setAttribute("Currency",sLineCurrency);
    		bzGetExposureBalance.setAttribute("Flag",sExposureFlag);
    		bzGetExposureBalance.setAttribute("ObjectType","BusinessContract");
    		bzGetExposureBalance.setAttribute("ObjectNo",sObjectNo);
    		dContractBalance+=Double.valueOf((String)bzGetExposureBalance.run(Sqlca)).doubleValue();//做累加
    	}
    	
    	//取额度实际可用金额
    	if("1".equals(sCreditCycle))//可循环
    	{
    		sBalance = (dLine - dContractBalance);//额度余额=额度合同金额-关联本笔额度合同敞口余额总和
    	}else{//不可循环,或者没有是否循环信息。均为不可循环
    		sBalance = (dLine - dContractSum);//额度余额=额度合同金额-关联本笔额度合同总金额
    	}
    	//更新额度余额
    	//sSql = "update BUSINESS_CONTRACT set TotalBalance = "+DataConvert.toDouble(sBalance)+" where SerialNo = '"+sLineNo+"'";
    	//Sqlca.executeSQL(sSql);
        
    	return sBalance;

	}

}
