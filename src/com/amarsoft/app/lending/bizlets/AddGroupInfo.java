package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;

public class AddGroupInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sRelativeID = (String)this.getAttribute("RelativeID");
		String sUserID  = (String)this.getAttribute("UserID");
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sRelativeID == null) sRelativeID = "";		
		if(sUserID == null) sUserID = "";
		
		//�������
		ASResultSet rs = null;//��ѯ�����
		String sSql = "";//Sql���
		String sCustomerType = "";//�ͻ�����
		String sGroupFlag = "";//���ű�־
		String sCustomerName = "";//�ͻ�����
		String sCertType = "";//֤������
		String sCertID = "";//֤�����
				
		//ʵ�����û�����
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		
		//���ݼ��ſͻ������ȡ���ſͻ�����
		sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
		if(sCustomerType == null) sCustomerType = "";
		
		//���ݼ��ų�Ա�����ȡ���ų�Ա���ơ�֤�����͡�֤�����
		sSql = 	" select CustomerName,CertType,CertID "+
				" from CUSTOMER_INFO "+
				" where CustomerID = '"+sRelativeID+"' ";
		rs = Sqlca.getASResultSet(sSql);	
		if (rs.next()) 
		{					
			sCustomerName = rs.getString("CustomerName");	
			sCertType = rs.getString("CertType");
			sCertID = rs.getString("CertID");
			if(sCustomerName == null) sCustomerName = "";
			if(sCertType == null) sCertType = "";
			if(sCertID == null) sCertID = "";
		}
		rs.getStatement().close();
		
		//���¼��ų�Ա����������
		sSql =  " update CUSTOMER_INFO set BelongGroupID = '"+sCustomerID+"' "+
				" where CustomerID = '"+sRelativeID+"' ";
		Sqlca.executeSQL(sSql);
			
		//���¼��ų�Ա�ļ��ű�־	
		if(sCustomerType.equals("0201")) sGroupFlag = "1";
		if(sCustomerType.equals("0202")) sGroupFlag = "2";
		sSql = 	" update ENT_INFO set GroupFlag = '"+sGroupFlag+"' "+
				" where CustomerID = '"+sRelativeID+"' ";
		Sqlca.executeSQL(sSql);
		
		//�������ų�Ա�����¼
		//�����ˮ�ţ����Ŵ��룬�ͻ����룬�䶯���ͣ�ԭ�ͻ����ƣ��䶯���ڣ�����������������Ա���ͻ����ƣ���֯��������
		//�䶯��־��010��������020��ɾ����030�������� 040������תһ�ࣻ050��һ��ת����
		String sSerialNo = DBFunction.getSerialNo("GROUP_CHANGE","SerialNo",Sqlca);
		if(sCertType.equals("Ent01"))//ֻ��֤������Ϊ��֯��������֤ʱ���ż�¼��֯��������
		{
			sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
				   " values('"+sSerialNo+"','"+sCustomerID+"','"+sRelativeID+"','010','"+sCustomerName+"','"+StringFunction.getToday()+"','"+CurUser.OrgID+"', "+
				   " '"+CurUser.UserID+"','"+sCustomerName+"','"+sCertID+"')";
		}else
		{
			sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
				   " values('"+sSerialNo+"','"+sCustomerID+"','"+sRelativeID+"','010','"+sCustomerName+"','"+StringFunction.getToday()+"','"+CurUser.OrgID+"', "+
				   " '"+CurUser.UserID+"','"+sCustomerName+"','')";
		}
		Sqlca.executeSQL(sSql);				
				
		return "1";
	}		
}
