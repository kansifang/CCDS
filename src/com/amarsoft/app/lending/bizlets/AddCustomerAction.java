package com.amarsoft.app.lending.bizlets;
/*
Author: --jbye 2007-1-14 15:03
Tester:
Describe: --���ͻ���Ϣ״̬
Input Param:
	  CustomerType���ͻ�����
	  	��˾�ͻ���	
			0101��������ҵ��
			0102���Ƿ�����ҵ��
			0103�����幤�̻�����ϵͳ�ݲ��ã���
			0104����ҵ��λ��
			0105��������壻
			0106���������أ�
			0107�����ڻ�����
			0199��������
		�������ţ�
			0201��һ�༯�ţ�
			0202�����༯�ţ���ϵͳ�ݲ��ã���
		���˿ͻ���
			03�����˿ͻ�			  			                				
	  CustomerName���ͻ�����
	  CertType��֤������
	  CertID��֤������
	  ReturnStatus������״̬
	  CustomerID���ͻ���
Output param:
		History Log: 			
*/
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class AddCustomerAction extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{
	    //���ҳ��������ͻ����͡��ͻ����ơ�֤�����͡�֤����š�����״̬���ͻ����
		String sCustomerType = (String)this.getAttribute("CustomerType");
		String sCustomerName = (String)this.getAttribute("CustomerName");	
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");	
		String sReturnStatus = (String)this.getAttribute("ReturnStatus");
		String sCustomerID = (String)this.getAttribute("CustomerID");	
		String sCustomerScale = (String)this.getAttribute("CustomerScale");	
		String sOrgID = (String)this.getAttribute("OrgID");	
		String sUserID = (String)this.getAttribute("UserID");	
		
		//����ֵת��Ϊ���ַ���
	   	if(sCustomerType == null) sCustomerType = "";   
	   	if(sCustomerName == null) sCustomerName = "";
	   	if(sCertType == null) sCertType = "";
	   	if(sReturnStatus == null) sReturnStatus = "";
	   	if(sCustomerID == null) sCustomerID = "";
	   	if(sCustomerScale == null) sCustomerScale = "";
	   	
	   	//���������sql���
		String sSql = "",sGroupType = "";
		
	   	//���ݿͻ��������ü��ſͻ�����
	   	if(sCustomerType.equals("0201")) //һ�༯�ſͻ�
			sGroupType = "1";//һ�༯��
		else if(sCustomerType.equals("0202")) //���༯�ſͻ�
			sGroupType = "2";//���༯��
		else
			sGroupType = "0";//��һ�ͻ�
		//01Ϊ�޸ÿͻ� 
		if(sReturnStatus.equals("01"))
		{
		   //��ʼ����
	 	   boolean bOld = Sqlca.conn.getAutoCommit(); 
		   try 
		   {		
				if(!bOld) Sqlca.conn.commit();
				Sqlca.conn.setAutoCommit(false);
						
				//��CI�����½���¼	
				if(sCustomerType.substring(0,2).equals("02")) //�������ſͻ�
				{
					//�ͻ���š��ͻ����ơ��ͻ����͡�֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ����ڡ���Դ����
					sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel) "+
						   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"',null,null,'"+sOrgID+"', "+
						   " '"+sUserID+"','"+StringFunction.getToday()+"','1')";
					Sqlca.executeSQL(sSql);
				}else
				{
					//�ͻ���š��ͻ����ơ��ͻ����͡�֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ�����	����Դ����
					sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,CustomerScale) "+
						   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"','"+sCertType+"','"+sCertID+"','"+sOrgID+"', "+
						   " '"+sUserID+"','"+StringFunction.getToday()+"','1','"+sCustomerScale+"')";
					Sqlca.executeSQL(sSql);
				}
					
				//��CB�����½���Ч��¼
				//�ͻ���š���Ȩ��������Ȩ�ˡ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ
				sSql = 	" insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3, "+
						" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
					   	" values('"+sCustomerID+"','"+sOrgID+"','"+sUserID+"','1','1','1','1','1','"+sOrgID+"', "+
					   	" '"+sUserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
				Sqlca.executeSQL(sSql);
					
				if(sCustomerType.substring(0,2).equals("01"))//��˾�ͻ�
				{
					//֤������Ϊ��֯��������
					if(sCertType.equals("Ent01"))
					{
						//�ͻ���š���֯��������֤��š��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ���������
						sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate) "+
							   " values('"+sCustomerID+"','"+sCertID+"','"+sCustomerName+"','"+sCustomerType+"','"+sGroupType+"','"+sOrgID+"','"+sUserID+"', "+
							   " '"+StringFunction.getToday()+"','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"')";
						Sqlca.executeSQL(sSql);
					//֤������ΪӪҵִ��
					}else if(sCertType.equals("Ent02"))
					{
						//�ͻ���š�Ӫҵִ�պš��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ���������
						sSql = " insert into ENT_INFO(CustomerID,LicenseNo,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate) "+
							   " values('"+sCustomerID+"','"+sCertID+"','"+sCustomerName+"','"+sCustomerType+"','"+sGroupType+"','"+sOrgID+"','"+sUserID+"', "+
							   " '"+StringFunction.getToday()+"','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"')";
						Sqlca.executeSQL(sSql);
					
					}else
					{
						//�ͻ���š��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ���������
						sSql = " insert into ENT_INFO(CustomerID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate) "+
							   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"','"+sGroupType+"','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"', "+
							   " '"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"')";
						Sqlca.executeSQL(sSql);
					}	
				}else if(sCustomerType.substring(0,2).equals("02")) //�������ſͻ�
				{				
					//�ͻ���š���֯�������루ϵͳ�Զ����⣬ͬ���ſͻ���ţ����ͻ����ơ��������ʡ��Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ����ſͻ�����
					sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,GroupFlag) "+
						   " values('"+sCustomerID+"','"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"', "+
						   " '"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"','"+sGroupType+"')";
					Sqlca.executeSQL(sSql);		
				}else if(sCustomerType.substring(0,2).equals("03"))//���˿ͻ�
				{
					//�ͻ���š�������֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ����ڡ���������
					sSql = "insert into IND_INFO(CustomerID,FullName,CertType,CertID,InputOrgID,InputUserID,InputDate,UpdateDate) "+
						   "values('"+sCustomerID+"','"+sCustomerName+"','"+sCertType+"','"+sCertID+"','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
					Sqlca.executeSQL(sSql);
				}
				
				//�����ύ�ɹ�
				Sqlca.conn.commit();
				Sqlca.conn.setAutoCommit(bOld);
			} catch(Exception e)
			{
				Sqlca.conn.rollback();
				Sqlca.conn.setAutoCommit(bOld);
				throw new Exception("������ʧ�ܣ�"+e.getMessage());
			}			
		//�ÿͻ�û�����κ��û�������Ч����
		}else if(sReturnStatus.equals("04"))
		{
			//����Դ������"2"���"1"
			sSql = 	" update CUSTOMER_INFO set Channel = '1' "+
					" where CustomerID = '"+sCustomerID+"' ";
			Sqlca.executeSQL(sSql);
			//������Ч����
			//�ͻ���š���Ȩ��������Ȩ�ˡ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ������Ȩ�ޣ�Ԥ�������Ǽǻ������Ǽ��ˡ��Ǽ����ڡ���������
			sSql = " insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				   " values('"+sCustomerID+"','"+sOrgID+"','"+sUserID+"','1','1','1','1','1','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		//�ÿͻ��������û�������Ч����
		}else if(sReturnStatus.equals("05"))
		{
			//������Ч����
			sSql = " insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				   " values('"+sCustomerID+"','"+sOrgID+"','"+sUserID+"','2','2','2','2','2','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		}
		return "succeed";
	}	
		
}
