package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.ASResultSet;



public class DeleteProjectRelative extends Bizlet 
{

	 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值
	    //传入的参数不需要加入单引号，非传入的变量和原来的参数变量做同样的处理
	    ASResultSet rs = null;
		String sProjectNo    = (String)this.getAttribute("ProjectNo");
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo     = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sProjectNo == null) sProjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//定义变量
	    String sSql = "";
	    int iCount = 0;
	    //如果是在客户信息中删除信息，校验业务信息中是否引入，如果已经引入不能删除此信息
	    //如果和业务没有关联可以直接全部删除
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
	  	    	  System.out.println("此项目已经与业务信息相关联，不能删除！");
	  	      }
	  	      else
	  	      {
	  	    	//执行删除语句
	  	    	//删除主信息
	  	    	sSql = " delete from  Project_Info where PROJECTNO = '"+sProjectNo+"' ";
	  	    	Sqlca.executeSQL(sSql);
	  			//删除项目进展情况
	  	    	sSql = " delete from  PROJECT_PROGRESS where PROJECTNO = '"+sProjectNo+"' ";
	  	    	Sqlca.executeSQL(sSql);
	  			//删除项目资金来源
	  			sSql = " delete from  PROJECT_FUNDS where PROJECTNO = '"+sProjectNo+"' ";
	  			Sqlca.executeSQL(sSql);
	  			//删除项目投资概算
	  			sSql =" delete from  PROJECT_BUDGET where PROJECTNO = '"+sProjectNo+"' ";
	  			Sqlca.executeSQL(sSql);	    
	  	      }
		 }
		//如果是业务申请和贷后进行删除，只能是删除关联不能删除信息
		else
		{
			sSql = " delete from Project_Relative  where PROJECTNO = '"+sProjectNo+"' " +
				   " and ObjectType = '"+sObjectType+"' and  ObjectNo = '"+sObjectNo+"' ";
			
			//删除关联信息
			Sqlca.executeSQL(sSql);
		}
	
	
	    return "aa"; 
	 }

}
