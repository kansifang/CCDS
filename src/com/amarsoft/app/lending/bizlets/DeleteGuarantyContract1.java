package com.amarsoft.app.lending.bizlets;
/*
		Author: --xhyong 2011/09/01
		Tester:
		Describe: --ɾ��������ͬ;
		Input Param:
				ObjectType: --��������(ҵ��׶�)��
				ObjectNo: --�����ţ�����/����/��ͬ��ˮ�ţ���
				SerialNo:--������ͬ��
		Output Param:
				return������ֵ��SUCCEEDED --ɾ���ɹ���

		HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;

public class DeleteGuarantyContract1 extends Bizlet {

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
		
		//��ȡ������ˮ��
		String sRelativeSerialNo = "";
		 sSql = " select RelativeSerialNo from BUSINESS_CONTRACT "+
			          " where SerialNo = '"+sObjectNo+"' ";
		 rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));
		rs.getStatement().close();
		
		//�õ�����ͬ�Ƿ��ѱ�����ҵ��ʹ�ù�
		int iCount = 0;
		sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT "+
				" where SerialNo = '"+sSerialNo+"' "+
				" and ContractType = '020' "+
				" and (ContractStatus = '020' "+
				" or ContractStatus = '030')";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		if(iCount <= 0)//����߶����ͬ
		{					
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
		
		//��ԭ���뵣����ͬδ�Ǽ�
		sSql =  " update GUARANTY_CONTRACT " +
				"set ApplyGuarantyContract=null " +
				"where ApplyGuarantyContract =  '"+sSerialNo+"'" ;
		Sqlca.executeSQL(sSql);
		
		return "SUCCEEDED";
	}
}
