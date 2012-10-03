package com.amarsoft.app.lending.bizlets;
/*
		Author: --xyong 2012/03/05
		Tester:
		Describe: --ɾ��׷�ӵ�����ͬ;
		Input Param:
				ObjectType: --�������͡�
				ObjectNo: --�����š�
				SerialNo:--������ͬ��
		Output Param:
				return������ֵ��SUCCEEDED --ɾ���ɹ���

		HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;

public class DeleteAddGuarantyContract extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSerialNo = (String)this.getAttribute("SerialNo");

		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
				
		//���ݶ������ͻ�ù�������
		String sRelativeTableName = "";
		String sSql = " select RelativeTable from OBJECTTYPE_CATALOG "+
			          " where ObjectType = '"+sObjectType+"' ";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			sRelativeTableName = DataConvert.toString(rs.getString("RelativeTable"));
		rs.getStatement().close();
		
		//�õ�����ͬ�Ƿ�ֻ��һ����¼
		int iCount = 0;
		sSql = 	" select count(GC.SerialNo) " +
				" from GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR " +
				"where GC.SerialNo=CR.ObjectNo " +
				" and CR.ObjectType='GuarantyContract' " +
				" and GC.ContractStatus = '010'  "+
				" and GC.SerialNo = '"+sSerialNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		if(iCount == 1)
		{
			//ɾ���뵣����ͬ�й���δ���ĵ���Ѻ��
			sSql =  " delete from GUARANTY_INFO "+
					" where GuarantyID in "+
					" (select GuarantyID from GUARANTY_RELATIVE "+
					" where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo='"+sObjectNo+"' "+
					" and ContractNo = '"+sSerialNo+"' ) "+
					" and GuarantyStatus = '01' ";
			Sqlca.executeSQL(sSql);
						
			//ɾ��������ͬ
			sSql =  " delete from GUARANTY_CONTRACT "+
					" where SerialNo = '"+sSerialNo+"' ";
			Sqlca.executeSQL(sSql);
		}
		
		//ɾ��������ͬ�����Ѻ��Ĺ�����ϵ
		sSql =  " delete from GUARANTY_RELATIVE "+
				" where ObjectType = '"+sObjectType+"' "+
				" and ObjectNo = '"+sObjectNo+"' "+
				" and ContractNo = '"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
		
		//ɾ��ҵ���뵣����ͬ�Ĺ�����ϵ
		sSql =  " delete from "+sRelativeTableName+" "+
				" where SerialNo = '"+sObjectNo+"' "+
				" and ObjectType = 'GuarantyContract' "+
				" and ObjectNo='"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
	
		return "SUCCEEDED";
	}
}
