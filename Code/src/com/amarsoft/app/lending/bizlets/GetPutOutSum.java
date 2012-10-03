package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetPutOutSum extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub
		//��ͬ��ˮ��
		String sContractSerialNo = (String)this.getAttribute("ContractSerialNo");
		//������ˮ��
		String sSerialNo = (String)this.getAttribute("SerialNo");
		//����ֵת��Ϊ���ַ���
		if(sContractSerialNo == null) sContractSerialNo = "";
		if(sSerialNo == null) sSerialNo = "";
		
		//��ͬ����ͬ����ͬ���³����ܶ�
		double dBCBusinessSum = 0.0, dBCBalance = 0.0,dPutOutSum = 0.0,dPayBackSum = 0.0,
		dTotalBusinessSum=0.0,dBCPracticeSum = 0.0;
		//Sql��䡢��ͬ���³����ܶѭ����־
		String sSql = null,sPutOutSum = "",sCycleFlag = "",sBusinessType = "";
		//��ѯ�����
		ASResultSet rs = null;
		
		//���ݺ�ͬ��ˮ�Ż�ȡѭ����־
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
		
		//��ѯ��ͬ���µĳ��ʽ��(�������ɽ��)
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
		
		if(sCycleFlag.equals("1")) //ѭ����־��1���ǣ�2����
		{
			//ȡ���л����� add by zrli
			sSql = 	" select sum(BusinessSum-Balance) as BusinessSum "+
						" from BUSINESS_DUEBILL "+
						" where  RelativeSerialno2 = '"+sContractSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dPayBackSum = rs.getDouble("BusinessSum");			
			}
			rs.getStatement().close();
			//��������֤ʹ��ʵ�����ż���
			if("2050030".equals(sBusinessType))
			{
				dPutOutSum = dBCPracticeSum - dPutOutSum + dPayBackSum ;
			}else{
				dPutOutSum = dBCBusinessSum - dPutOutSum + dPayBackSum ;
			}
		}else //��ѭ��
		{
			//��������֤ʹ��ʵ�����ż���
			if("2050030".equals(sBusinessType))
			{
				dPutOutSum = dBCPracticeSum - dPutOutSum;
			}else{
				dPutOutSum = dBCBusinessSum - dPutOutSum;
			}
		}
		//ȡ���н�ݳ��˽��
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
