/*
		Author: --xhyong
		Tester:
		Describe: --������ծ�ʲ�����ʱ,�ڵ�ծ�ʲ�������һ�����ü�¼
		Input Param:
				ObjectNo��������
				BusinessType��ҵ��Ʒ��
				CustomerID: �ͻ�����
				CustomerName: �ͻ�����				
		Output Param:

		HistoryLog: ���ӹ��̻�е���Ҷ�� added by lpzhang 2009-8-11
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;

public class InitializeBadBiz extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");	
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//��������
		String sUserID = (String)this.getAttribute("UserID");
		//��������
		String sOrgID = (String)this.getAttribute("OrgID");
		ASResultSet rs = null;
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		String sApplyType = "";
	    //��õ�ǰʱ
		String sCurDate = StringFunction.getToday();
		//��ѯ��������
    	String sSql1 = 	" select ApplyType from BADBIZ_APPLY where SerialNo= '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql1);
		if(rs.next())
		{
			sApplyType = rs.getString("ApplyType");
		}
		rs.getStatement().close();
		
		if("020".equals(sApplyType))//��ծ�ʲ�����
		{
	    //���ҵ��Ʒ���Ƕ�ȣ�������ڶ����Ϣ��Asset_Info�в���һ����Ϣ
	     String sSerialNo = DBFunction.getSerialNo("Asset_Info","SerialNo",Sqlca);
	     String sSql =  " insert into Asset_Info(SerialNo,ObjectNo,ObjectType,AssetFlag,OperateUserID,OperateOrgID,InputUserID,InputOrgID,InputDate) "+
	                       " values ('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','030','"+sUserID+"','"+sOrgID+"','"+sUserID+"','"+sOrgID+"','"+sCurDate+"')";
	     //ִ�в������
		 Sqlca.executeSQL(sSql);
		}
	    
		if("025".equals(sApplyType))//��ծ�ʲ����ú���
		{
	     //ִ�в������
		 Sqlca.executeSQL("Update BADBIZ_APPLY set OperateType='160' where SerialNo= '"+sObjectNo+"'");
		}
		
		return "1";
	 }
}
