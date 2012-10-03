package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.context.ASUser;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateGroupType extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ	    
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sUserID   = (String)this.getAttribute("UserID");
		String sChangeFlag   = (String)this.getAttribute("ChangeFlag");
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sUserID == null) sUserID = "";
		if(sChangeFlag == null) sChangeFlag = "";
		
		//�������		
		ASResultSet rs = null;
		String sSql = "";//Sql���
		String sCustomerType = "";//�ͻ�����
		String sGroupType = "";//���ſͻ�����
		String sChangeType = "";//�������
		String sSerialNo = "";//�����ˮ��
		
		//ʵ�����û�����
	    ASUser CurUser = new ASUser(sUserID,Sqlca);
		if(sChangeFlag.equals("1To2"))//��һ�༯�ſͻ�ת��Ϊ���༯�ſͻ�
		{
			sCustomerType = "0202";
			sGroupType = "2";
			sChangeType = "050";
		}
		if(sChangeFlag.equals("2To1"))//�����༯�ſͻ�ת��Ϊһ�༯�ſͻ�
		{
			sCustomerType = "0201";
			sGroupType = "1";
			sChangeType = "040";
		}
		
		//�����ſͻ��Ŀͻ�������һ�༯�ſͻ�����Ϊ���༯�ſͻ�
		sSql =  " update CUSTOMER_INFO "+
				" set CustomerType = '"+sCustomerType+"' "+
				" where CustomerID = '"+sCustomerID+"' ";
		//ִ�и������
	    Sqlca.executeSQL(sSql);
	    
	    //�����ſͻ��ſ���Ϣ�Ļ���������һ�༯�ſͻ�����Ϊ���༯�ſͻ�
		sSql =  " update ENT_INFO "+
				" set OrgNature = '"+sCustomerType+"', "+
	    		" GroupFlag = '"+sGroupType+"' "+
				" where CustomerID = '"+sCustomerID+"' ";
		//ִ�и������
	    Sqlca.executeSQL(sSql);
	    	    	    
	    //�����ų�Ա�ſ���Ϣ�Ļ������ʡ����ſͻ���־��һ�༯�ſͻ�����Ϊ���༯�ſͻ�
	    sSql =  " update ENT_INFO "+
	    		" set GroupFlag = '"+sGroupType+"' "+
	    		" where CustomerID in "+
	    		" (select RelativeID "+
	    		" from CUSTOMER_RELATIVE "+
	    		" where CustomerID = '"+sCustomerID+"' "+
	    		" and RelationShip like '04%' "+
				" and length(RelationShip)>2) "; 
	    //ִ�и������
	    Sqlca.executeSQL(sSql);
	    
	   //�����ų�Ա�ļ��ŷ�����һ�༯�ſͻ�����Ϊ���༯�ſͻ�
	    sSql =  " update CUSTOMER_RELATIVE "+
	    		" set Describe = '"+sGroupType+"' "+
	    		" where CustomerID = '"+sCustomerID+"' "+
	    		" and RelationShip like '04%' "+
				" and length(RelationShip)>2 ";
	    //ִ�и������
	    Sqlca.executeSQL(sSql); 
		//�ǼǼ��ų�Ա�����¼
	    //��ȡ���ų�Ա�Ŀͻ���š��ͻ����ơ�֤�����͡���֯��������
	    sSql = 	" select RelativeID,CustomerName,CertType,CertID "+
	    		" from CUSTOMER_RELATIVE "+
	    		" where CustomerID = '"+sCustomerID+"' "+
	    		" and RelationShip like '04%' "+
				" and length(RelationShip)>2 ";
	    rs = Sqlca.getASResultSet(sSql);
	    while(rs.next())
	    {
	    	String sRelativeID = rs.getString("RelativeID");
	    	String sRelativeName = rs.getString("CustomerName");
	    	String sCertType = rs.getString("CertType");
	    	String sCertID = rs.getString("CertID");
	    	if(sCertType.equals("Ent01"))
	    	{
	    		//�����ˮ�ţ����Ŵ��룬�ͻ����룬�䶯���ͣ�ԭ�ͻ����ƣ��䶯���ڣ�����������������Ա���ͻ����ƣ���֯��������
	    		//�䶯��־��010��������020��ɾ����030�������� 040������תһ�ࣻ050��һ��ת����
	    		sSerialNo = DBFunction.getSerialNo("GROUP_CHANGE","SerialNo",Sqlca);
	    		sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
	    			   " values('"+sSerialNo+"','"+sCustomerID+"','"+sRelativeID+"','"+sChangeType+"','"+sRelativeName+"','"+StringFunction.getToday()+"','"+CurUser.OrgID+"', "+
	    			   " '"+sUserID+"','"+sRelativeName+"','"+sCertID+"')";
	    		Sqlca.executeSQL(sSql);	
	    	}else
	    	{
	    		//�����ˮ�ţ����Ŵ��룬�ͻ����룬�䶯���ͣ�ԭ�ͻ����ƣ��䶯���ڣ�����������������Ա���ͻ����ƣ���֯��������
	    		//�䶯��־��010��������020��ɾ����030�������� 040������תһ�ࣻ050��һ��ת����
	    		sSerialNo = DBFunction.getSerialNo("GROUP_CHANGE","SerialNo",Sqlca);
	    		sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
	    			   " values('"+sSerialNo+"','"+sCustomerID+"','"+sRelativeID+"','"+sChangeType+"','"+sRelativeName+"','"+StringFunction.getToday()+"','"+CurUser.OrgID+"', "+
	    			   " '"+sUserID+"','"+sRelativeName+"','')";
	    		Sqlca.executeSQL(sSql);	
	    	}
	    }
	    rs.getStatement().close();
	    
	    return "1";
	    
	 }

}
