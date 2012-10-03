package com.amarsoft.app.lending.bizlets;

/*
Author: --zywei 2006-01-12
Tester:
Describe: --���롢������������ͺ�ͬ�н�������Ѻ���뵣����ͬ��ҵ���֮ͬ��Ĺ�����ϵ
		  --Ŀǰ����ҳ�棺ApplyImpawnInfo1��ApplyPawnInfo1��ApproveImpawnInfo1��
		  ApprovePawnInfo1��ContractImpawnInfo1��ContractPawnInfo1
Input Param:
		ObjectType����������
		ObjectNo��������
		ContractNo: ������ͬ���
		GuarantyID: ����Ѻ����
		Channel��������Դ��New��������Copy��������
Output Param:
		
HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InsertGuarantyRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		String sChannel = (String)this.getAttribute("Channel");
		String sType = (String)this.getAttribute("Type");
		
		//����ֵת��Ϊ���ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";	
		if(sChannel == null) sChannel = "";
		if(sType == null) sType = "";
				
		//�������		
		ASResultSet rs = null;//��ѯ�����
		String sSql = "";//Sql���
		String sReturnFlag = "";//���ر�־
		int iCount = 0;//��¼��	
		
		//��֤������ϵ�Ƿ��Ѵ���
		sSql = 	" select count(ObjectNo) from GUARANTY_RELATIVE "+
				" where ObjectType = '"+sObjectType+"' "+
				" and ObjectNo = '"+sObjectNo+"' "+
				" and ContractNo = '"+sContractNo+"' "+
				" and GuarantyID = '"+sGuarantyID+"' ";
		
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		//��������ڹ�����ϵ�����½�������ϵ
		if(iCount < 1)
		{
			//��������Ѻ���뵣����ͬ��ҵ���֮ͬ��Ĺ����ϵ
			//�������ͣ���ͬ��BusinessContract���������ţ���ͬ��ţ���������ͬ��š�����Ѻ���š�������ϵ��Դ������������New��������Copy������Ч��־��1����Ч��2����Ч����������Դ���ͣ�Add��������Import�����룩
			sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type)"+
					" values('"+sObjectType+"','"+sObjectNo+"','"+sContractNo+"','"+sGuarantyID+"','"+sChannel+"','1','"+sType+"') ";
			
			Sqlca.executeSQL(sSql);
			sReturnFlag = "1";//������ϵ�Ѿ��ɹ�����
		}else
		{
			sReturnFlag = "0";//������ϵ�Ѿ����ڣ�����Ҫ�ٽ��н���
		}
				
		return sReturnFlag;
	}		
}
