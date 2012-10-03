package com.amarsoft.app.lending.bizlets;

/*
Author: --zywei 2006-01-12
Tester:
Describe: --������ͬ�����н�������Ѻ���뵣����ͬ��ҵ���֮ͬ��Ĺ�����ϵ
		  --Ŀǰ����ҳ�棺ValidAssureImpawnInfo1��ValidAssureImpawnInfo2��
		  ValidAssurePawnInfo1��ValidAssurePawnInfo2
Input Param:
		ContractNo: ������ͬ���
		GuarantyID: ����Ѻ����
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddGuarantyRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		String sChannel = (String)this.getAttribute("Channel");
		String sType = (String)this.getAttribute("Type");
		
		//����ֵת��Ϊ���ַ���
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";
		if(sChannel == null) sChannel = "";
		if(sType == null) sType = "";
				
		//�������		
		ASResultSet rs = null;//��ѯ�����
		String sSql = "";//Sql���
		String sSerialNo = "";//��ͬ���			
		int iCount = 0;//��¼��	
		
		//���ݵ�����ͬ��Ż�ȡ���ҵ���ͬ���
		sSql = 	" select SerialNo from CONTRACT_RELATIVE "+
				" where ObjectType = 'GuarantyContract' "+
				" and ObjectNo = '"+sContractNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while (rs.next())
		{
			sSerialNo = rs.getString("SerialNo");
			//��֤�ù�����ϵ�Ƿ��Ѵ���
			sSql = 	" select count(ObjectNo) from GUARANTY_RELATIVE "+
					" where ObjectType = 'BusinessContract' "+
					" and ObjectNo = '"+sSerialNo+"' "+
					" and ContractNo = '"+sContractNo+"' "+
					" and GuarantyID = '"+sGuarantyID+"' ";
	
			ASResultSet rs1 = Sqlca.getASResultSet(sSql);
			if (rs1.next())
				iCount = rs1.getInt(1);
			rs1.getStatement().close();
			
			//��������ڹ�����ϵ����������Ѻ���뵣����ͬ��ҵ���֮ͬ��Ĺ����ϵ
			if(iCount < 1)
			{
				//�������ͣ���ͬ��BusinessContract���������ţ���ͬ��ţ���������ͬ��š�����Ѻ���š�������ϵ��Դ������������New��������Copy������Ч��־��1����Ч��2����Ч����������Դ���ͣ�Add��������Import�����룩
				sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type)"+
						" values('BusinessContract','"+sSerialNo+"','"+sContractNo+"','"+sGuarantyID+"','"+sChannel+"','1','"+sType+"') ";
				Sqlca.executeSQL(sSql);
			}
		}		
		rs.getStatement().close();
				
		return "1";
	}		
}
