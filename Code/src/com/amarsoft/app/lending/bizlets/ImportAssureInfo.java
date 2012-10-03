package com.amarsoft.app.lending.bizlets;
/*
		Author: --��ҵ� 2005-08-08
		Tester:
		Describe: --������ߵ�����ͬ;
		Input Param:
				ObjectType: --��������(ҵ��׶�)��
				ObjectNo: --�����ţ�����/����/��ͬ��ˮ�ţ���
				SerialNo:--������ͬ��
		Output Param:
				return��EXIST --�����Ѵ���
						SUCCEEDED --����ɹ�

		HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;

public class ImportAssureInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSerialNo = (String)this.getAttribute("SerialNo");

		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
		String sRelativeTableName="",sGuarantyID = "";

		String sSql = "select RelativeTable from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			sRelativeTableName = DataConvert.toString(rs.getString("RelativeTable"));
		}
		rs.getStatement().close();
		
		 
		//�ж��Ƿ�������
		int iCount=0;
		sSql = " select count(*) as iCount from "+sRelativeTableName+"  where SerialNo='"+sObjectNo+"' and ObjectType='GuarantyContract' and ObjectNo='"+sSerialNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			iCount = rs.getInt("iCount");
		}
		rs.getStatement().close(); 
		
		if (iCount==0)
		{
			Sqlca.executeSQL("insert into "+sRelativeTableName+" values('"+sObjectNo+"','GuarantyContract','"+sSerialNo+"',0.00)");
			//���ݵ�����ͬ��Ż�ȡ��Ӧ�ĵ���Ѻ����Ϣ
			sSql = 	" select GuarantyID from GUARANTY_RELATIVE "+
					" where ObjectType = 'BusinessContract' "+
					" and ContractNo = '"+sSerialNo+"' "+
					" and Type = 'Add' ";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
			{
				sGuarantyID = rs.getString("GuarantyID");
				sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
						" values('"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"','"+sGuarantyID+"','Copy','1','Import')";
				Sqlca.executeSQL(sSql);
			}
			rs.getStatement().close();
			return "SUCCEEDED";
		}
		else
		{
			return "EXIST";
		}
	}
}
