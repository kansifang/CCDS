/*
		Author: --zywei 2006-08-18
		Tester:
		Describe: ���µ���Ѻ��״̬�����������/����ۼ�
		Input Param:
			GuarantyID������Ѻ����
			GuarantyStatus������Ѻ��״̬
			UserID���Ǽ��˱��	
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;


public class InsertGuarantyAudit extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		if(sGuarantyID == null) sGuarantyID = "";
		String sGuarantyStatus = (String)this.getAttribute("GuarantyStatus");
		if(sGuarantyStatus == null) sGuarantyStatus = "";		
		String sInputUser   = (String)this.getAttribute("InputUser");
		if(sInputUser == null) sInputUser = "";
				
		//�������
		String sSql = "",sUpdateSql = "",sInsertSql = "",sGuarantyName = "";
		String sCurDate = "",sInputOrg = "",sSerialNo = "",sGuarantyType = "";
		ASResultSet rs = null;
		
		//��ȡ����Ѻ����Ϣ
		sSql = 	" select GuarantyName,GuarantyType from GUARANTY_INFO "+
				" where GuarantyID='"+sGuarantyID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sGuarantyName = rs.getString("GuarantyName");
			sGuarantyType = rs.getString("GuarantyType");
			//����ֵת��Ϊ���ַ���
			if(sGuarantyName == null) sGuarantyName = "";
			if(sGuarantyType == null) sGuarantyType = "";
		}
		rs.getStatement().close();
		
		//��ȡ��ˮ��
		sSerialNo = DBFunction.getSerialNo("GUARANTY_AUDIT","SerialNo",Sqlca);
		//��ȡϵͳ����
		sCurDate = StringFunction.getToday();
		//��ȡ�û����ڻ���
		ASUser CurUser = new ASUser(sInputUser,Sqlca);
		sInputOrg = CurUser.OrgID;
		
		//���µ���Ѻ��״̬
		sUpdateSql = " update GUARANTY_INFO set GuarantyStatus='"+sGuarantyStatus+"' "+
					 " where GuarantyID ='"+sGuarantyID+"' ";
		Sqlca.executeSQL(sUpdateSql);
		//�������/����ۼ���Ϣ
		if(sGuarantyStatus.equals("02")) //���
			sInsertSql = " insert into GUARANTY_AUDIT(SerialNo,GuarantyID,GuarantyName,GuarantyType, "+
					 	 " GuarantyStatus,HoldDate,InputOrg,InputUser,InputDate,UpdateDate) "+
					 	 " values('"+sSerialNo+"','"+sGuarantyID+"','"+sGuarantyName+"','"+sGuarantyType+"', "+
					 	 " '"+sGuarantyStatus+"','"+sCurDate+"','"+sInputOrg+"','"+sInputUser+"','"+sCurDate+"', "+
					 	 " '"+sCurDate+"') ";
		if(sGuarantyStatus.equals("04")) //����
			sInsertSql = " insert into GUARANTY_AUDIT(SerialNo,GuarantyID,GuarantyName,GuarantyType, "+
					 	 " GuarantyStatus,LostDate,InputOrg,InputUser,InputDate,UpdateDate) "+
					 	 " values('"+sSerialNo+"','"+sGuarantyID+"','"+sGuarantyName+"','"+sGuarantyType+"', "+
					 	 " '"+sGuarantyStatus+"','"+sCurDate+"','"+sInputOrg+"','"+sInputUser+"','"+sCurDate+"', "+
					 	 " '"+sCurDate+"') ";
		Sqlca.executeSQL(sInsertSql);
		return "1";
	 }

}
