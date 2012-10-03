package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.ASResultSet;



public class DeleteProjectRelative extends Bizlet 
{

	 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ
	    //����Ĳ�������Ҫ���뵥���ţ��Ǵ���ı�����ԭ���Ĳ���������ͬ���Ĵ���
	    ASResultSet rs = null;
		String sProjectNo    = (String)this.getAttribute("ProjectNo");
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo     = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sProjectNo == null) sProjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//�������
	    String sSql = "";
	    int iCount = 0;
	    //������ڿͻ���Ϣ��ɾ����Ϣ��У��ҵ����Ϣ���Ƿ����룬����Ѿ����벻��ɾ������Ϣ
	    //�����ҵ��û�й�������ֱ��ȫ��ɾ��
		if (sObjectType.equals("Customer"))
		 {
			  sSql = " select count(ProjectNo) from Project_Relative where ProjectNo='"+sProjectNo+"' and " +
	         		 " (ObjectType ='CreditApply' or ObjectType ='AfterLoan') and ObjectNo ='"+sObjectNo+"'";
	          rs = Sqlca.getResultSet(sSql);
	  	      if(rs.next())
	  	      {
	  	    	iCount = rs.getInt(1);
	  	      }
	  	    
	  	      rs.getStatement().close();
	  	      if (iCount>0)
	  	      {
	  	    	  System.out.println("����Ŀ�Ѿ���ҵ����Ϣ�����������ɾ����");
	  	      }
	  	      else
	  	      {
	  	    	//ִ��ɾ�����
	  	    	//ɾ������Ϣ
	  	    	sSql = " delete from  Project_Info where PROJECTNO = '"+sProjectNo+"' ";
	  	    	Sqlca.executeSQL(sSql);
	  			//ɾ����Ŀ��չ���
	  	    	sSql = " delete from  PROJECT_PROGRESS where PROJECTNO = '"+sProjectNo+"' ";
	  	    	Sqlca.executeSQL(sSql);
	  			//ɾ����Ŀ�ʽ���Դ
	  			sSql = " delete from  PROJECT_FUNDS where PROJECTNO = '"+sProjectNo+"' ";
	  			Sqlca.executeSQL(sSql);
	  			//ɾ����ĿͶ�ʸ���
	  			sSql =" delete from  PROJECT_BUDGET where PROJECTNO = '"+sProjectNo+"' ";
	  			Sqlca.executeSQL(sSql);	    
	  	      }
		 }
		//�����ҵ������ʹ������ɾ����ֻ����ɾ����������ɾ����Ϣ
		else
		{
			sSql = " delete from Project_Relative  where PROJECTNO = '"+sProjectNo+"' " +
				   " and ObjectType = '"+sObjectType+"' and  ObjectNo = '"+sObjectNo+"' ";
			
			//ɾ��������Ϣ
			Sqlca.executeSQL(sSql);
		}
	
	
	    return "aa"; 
	 }

}
