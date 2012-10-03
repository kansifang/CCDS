package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddProjectRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	    
	    ASResultSet rs = null;
		String sProjectNo    = (String)this.getAttribute("ProjectNo");
		String sObjectType   = (String)this.getAttribute("ObjectType");
		//String sObjectNo     = (String)this.getAttribute("ObjectNo");
		
		int iCount = 0;
		String sSql1 = null,sSql2 = null,sSql3 = null,sObjectNoadd="",sObjectNonew="";
		if (sObjectType.equals("Customer"))
		{
		   
		}else//ҵ������ʹ����������ʱ������ͻ���û�д���Ϣ��Ҫ����һ���Ϳͻ���������Ϣ
		{
			sSql1=" select count(ProjectNo) from Project_Relative where ProjectNo='"+sProjectNo+"' and " +
    		      " ObjectType ='Customer' ";
	          rs = Sqlca.getResultSet(sSql1);
	  	      if(rs.next())
	  	      {
	  	    	iCount = rs.getInt(1);
	  	      }	  	      
	  	      rs.getStatement().close();
	  	      if (iCount>0)
	  	      {
	  	    	  System.out.println("����Ŀ��ҵ����Ϣ���Ѿ�¼�룬����Ҫ���������");
	  	      }
	  	      //����һ���Ϳͻ���������Ϣ
	  	      else
	  	      {
	  	    	//�����������Ż��ͬ��
	  	    	sSql3=" select ObjectNo from Project_Relative where ProjectNo='"+sProjectNo+"' order by ObjectNo DESC";
		          rs = Sqlca.getResultSet(sSql3);
		  	      if(rs.next())
		  	      {
		  	    	sObjectNoadd = rs.getString(1);
		  	      }
		  	      rs.getStatement().close();	 
		  	      //���ȵ���������ҿͻ�����
		  	     sSql3=" select CustomerID from Business_Apply where SerialNo ='"+sObjectNoadd+"'";
			          rs = Sqlca.getResultSet(sSql3);
			  	      if(rs.next())
			  	      {
			  	    	sObjectNonew = rs.getString(1);
			  	      }
			  	      rs.getStatement().close();	 
			  	 //����������û�пͻ����뵽��ͬ������
			  	 if (sObjectNonew.equals("")||sObjectNonew==null)
			  	 {
			  	     sSql3=" select CustomerID from Business_Contract where SerialNo ='"+sObjectNoadd+"'";
			          rs = Sqlca.getResultSet(sSql3);
			  	      if(rs.next())
			  	      {
			  	    	sObjectNonew = rs.getString(1);
			  	      }
			  	      rs.getStatement().close();	
			  		 
			  	 }
			  	
	  	    	sSql2="  insert into Project_Relative(ProjectNo,ObjectType,ObjectNo,Remark)" +
	  	    		  " values ('"+sProjectNo+"','Customer','"+sObjectNonew+"','"+sObjectType+"')";
	  	    		  	    		  	    	
	  	    	Sqlca.executeSQL(sSql2);
	  	      }
		}
		return "aa";
	}

}
