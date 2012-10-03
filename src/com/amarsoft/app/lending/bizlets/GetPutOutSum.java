package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetPutOutSum extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub
		//合同流水号
		String sContractSerialNo = (String)this.getAttribute("ContractSerialNo");
		//出帐流水号
		String sSerialNo = (String)this.getAttribute("SerialNo");
		//将空值转化为空字符串
		if(sContractSerialNo == null) sContractSerialNo = "";
		if(sSerialNo == null) sSerialNo = "";
		
		//合同金额、合同余额、合同项下出帐总额
		double dBCBusinessSum = 0.0, dBCBalance = 0.0,dPutOutSum = 0.0,dPayBackSum = 0.0,
		dTotalBusinessSum=0.0,dBCPracticeSum = 0.0;
		//Sql语句、合同项下出帐总额、循环标志
		String sSql = null,sPutOutSum = "",sCycleFlag = "",sBusinessType = "";
		//查询结果集
		ASResultSet rs = null;
		
		//根据合同流水号获取循环标志
		sSql = 	" select BusinessSum,Balance,CycleFlag,PracticeSum,BusinessType "+
				" from BUSINESS_CONTRACT "+
				" where SerialNo = '"+sContractSerialNo+"'";	
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dBCBusinessSum = rs.getDouble("BusinessSum");
			dBCBalance = rs.getDouble("Balance");
			sCycleFlag = rs.getString("CycleFlag");			
			if(sCycleFlag == null) sCycleFlag = "";	
			dBCPracticeSum =  rs.getDouble("PracticeSum");
			sBusinessType = rs.getString("BusinessType");			
			if(sBusinessType == null) sBusinessType = "";	
		}
		rs.getStatement().close();
		
		//查询合同项下的出帐金额(非已生成借据)
		if(sSerialNo.equals(""))
		{			
			sSql = 	" select sum(BusinessSum) as BusinessSum "+
					" from BUSINESS_PUTOUT "+
					" where ContractSerialNo = '"+sContractSerialNo+"' "+
					" and not exists(select 1 from BUSINESS_DUEBILL where RelativeSerialno1=BUSINESS_PUTOUT.SerialNo)";
			
		}else
		{
			sSql = 	" select sum(BusinessSum) as BusinessSum "+
					" from BUSINESS_PUTOUT "+
					" where SerialNo <> '"+sSerialNo+"' "+
					" and ContractSerialNo = '"+sContractSerialNo+"' "+
					" and not exists(select 1 from BUSINESS_DUEBILL where RelativeSerialno1=BUSINESS_PUTOUT.SerialNo)";;
		}
		
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dPutOutSum = rs.getDouble("BusinessSum");			
		}
		rs.getStatement().close();
		
		if(sCycleFlag.equals("1")) //循环标志（1：是；2：否）
		{
			//取所有还款金额 add by zrli
			sSql = 	" select sum(BusinessSum-Balance) as BusinessSum "+
						" from BUSINESS_DUEBILL "+
						" where  RelativeSerialno2 = '"+sContractSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dPayBackSum = rs.getDouble("BusinessSum");			
			}
			rs.getStatement().close();
			//进口信用证使用实际用信计算
			if("2050030".equals(sBusinessType))
			{
				dPutOutSum = dBCPracticeSum - dPutOutSum + dPayBackSum ;
			}else{
				dPutOutSum = dBCBusinessSum - dPutOutSum + dPayBackSum ;
			}
		}else //非循环
		{
			//进口信用证使用实际用信计算
			if("2050030".equals(sBusinessType))
			{
				dPutOutSum = dBCPracticeSum - dPutOutSum;
			}else{
				dPutOutSum = dBCBusinessSum - dPutOutSum;
			}
		}
		//取所有借据出账金额
		sSql = 	" select sum(BusinessSum) as TotalBusinessSum "+
					" from BUSINESS_DUEBILL "+
					" where  RelativeSerialno2 = '"+sContractSerialNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dTotalBusinessSum = rs.getDouble("TotalBusinessSum");			
		}
		rs.getStatement().close();
		dPutOutSum = dPutOutSum-dTotalBusinessSum;
		
		sPutOutSum = String.valueOf(dPutOutSum);		
		return sPutOutSum;
	}

}
