/*
		Author: --κ���� 2005-11-23
		Tester:
		Describe: --�������Ŷ�������¼ʱ����ͬʱ�ڶ����Ϣ��CL_INFO������һ�ʼ�¼
		Input Param:
				ObjectNo��������
				BusinessType��ҵ��Ʒ��
				CustomerID: �ͻ�����
				CustomerName: �ͻ�����				
		Output Param:

		HistoryLog: ���ӹ��̻�е���Ҷ�� added by lpzhang 2009-8-11
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.ASResultSet;
public class InitializeCLInfo extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");	
		//ҵ��Ʒ��
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//�ͻ����
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//�ͻ�����		
		String sCustomerName = (String)this.getAttribute("CustomerName");		
		//�Ǽ���
		String sInputUser = (String)this.getAttribute("InputUser");
		//�Ǽǻ���
		String sInputOrg = (String)this.getAttribute("InputOrg");
		
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sCustomerID == null) sCustomerID = "";
	    if(sCustomerName == null) sCustomerName = "";
	    if(sInputUser == null) sInputUser = "";
	    if(sInputOrg == null) sInputOrg = "";
	    ASResultSet rs = null,rs1 = null;
	    
	    //��õ�ǰʱ��
	    String sCurDate = StringFunction.getToday();
	    
	    //���ҵ��Ʒ���Ƕ�ȣ�������ڶ����Ϣ��CL_INFO�в���һ����Ϣ
	    if(sBusinessType.startsWith("3") && !sBusinessType.equals("3020"))
	    {
	        String sSerialNo = DBFunction.getSerialNo("CL_INFO","LineID",Sqlca);
	        String sClTypeName=Sqlca.getString("select TypeName from Business_Type where typeno='"+sBusinessType+"'");
	        String sSql =  " insert into CL_INFO(LineID,CLTypeID,ClTypeName,ApplySerialNo,BusinessType,CustomerID,CustomerName, "+
	        	  		   " FreezeFlag,InputUser,InputOrg,InputTime,UpdateTime) "+
	                       " values ('"+sSerialNo+"','001','"+sClTypeName+"','"+sObjectNo+"','"+sBusinessType+"', '" + sCustomerID+"', " + 
	         			   " '"+sCustomerName+"','1','"+sInputUser+"','"+sInputOrg+"','"+sCurDate+"','"+sCurDate+"')";
        
	        //ִ�в������
		    Sqlca.executeSQL(sSql);
	    }
	    if(sBusinessType.equals("3020"))//���̻�е���Ҷ��
	    {
	    	String sSerialNo = DBFunction.getSerialNo("ENT_AGREEMENT","SerialNo",Sqlca);
	    	String sSql =  " insert into ENT_AGREEMENT(SerialNo,AgreementType,CustomerID,CustomerName ,InputUserID,InputOrgID,InputDate,UpdateDate)"+
	    	 			   " values ('"+sSerialNo+"','ProjectAgreement','"+sCustomerID+"', " + 
	         			   " '"+sCustomerName+"','"+sInputUser+"','"+sInputOrg+"','"+sCurDate+"','"+sCurDate+"')";
	    	//ִ�в������
		    Sqlca.executeSQL(sSql);
		    
		    String sSql1 =  " insert into Apply_Relative(SerialNo,ObjectType,ObjectNo)"+
			   " values ('"+sObjectNo+"','ProjectAgreement','"+sSerialNo+"')" ;
			   
			 //ִ�в������
			Sqlca.executeSQL(sSql1);
		     
		    Sqlca.executeSQL("update Business_Apply set UseOrgList = '"+sInputOrg+"' where SerialNo = '"+sObjectNo+"'");
		    
	    }
	    /*if(sBusinessType.equals("3060"))//���ù�ͬ�����Ŷ��
	    {	
	    	String sAssureGroupID = "",CLSerialNo = "",sLineID = "";
	    	String sCLTypeID = "",sParentLineID = "";
	    	//��ѯ��Ȼ�����Ϣ
	    	String sSql = 	" select LineID,CLTypeID "+
			" from CL_INFO where (ParentLineID is null or ParentLineID='') "+
			" and ApplySerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sParentLineID = rs.getString("LineID");
			}
			rs.getStatement().close();
			
	    	//ѭ����ѯ���ù�ͬ������С����
	    	sSql = " select distinct AssureGroupID from CUSTOMER_RELATIVE  "+ 
	    				" where AssureGroupID is not null and  AssureGroupID<>'' "+
	    				" and CustomerID='"+sCustomerID+"' and RelationShip like '0701%'   ";
	    	rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
			{
				sAssureGroupID = rs.getString("AssureGroupID");
				//��ѯ����С�����¶�ȷ�����Ϣ
				String Sql1 = " select LineID from CL_INFO  "+ 
				" where ParentLineID is not null and ParentLineID<>'' "+
				" and BCSerialNo in(select SerialNo from BUSINESS_CONTRACT "+
				" where BusinessType ='3050' "+
				" and (DeleteFlag = ''  or  DeleteFlag is null)  "+
				" and InUseFlag='01' and (FinishDate='' or FinishDate is null)"+
				" and CustomerID='"+sAssureGroupID+"' )";
				rs1 = Sqlca.getASResultSet(Sql1);
				while(rs1.next())
				{
					CLSerialNo = DBFunction.getSerialNo("CL_INFO","LineID",Sqlca);
					sLineID = rs1.getString("LineID");
					String sSql2 =  " insert into cl_info(lineid,TermMonth,InputTime,"+
										" ApproveSerialNo,Currency,InputOrg,CLTypeID,"+
										" CustomerName,LineSum2,ParentLineID,"+
										" ApplySerialNo,MemberName,UpdateTime,"+
										" BCSerialNo,CustomerID,LineSum1,"+
										"InputUser,CLTypeName,MemberID,"+
										"Rotative) select '"+CLSerialNo+"',TermMonth,'"+sCurDate+"',"+
										" '','01','"+sInputOrg+"',CLTypeID,"+
										" '"+sCustomerName+"',LineSum2,'"+sParentLineID+"', "+
										" '"+sObjectNo+"',MemberName,'"+sCurDate+"',"+
										" '','"+sCustomerID+"',LineSum1,"+
										" '"+sInputUser+"',CLTypeName,MemberID,Rotative "+
										" from cl_info where LineID='"+sLineID+"'";
					//ִ�в������
					Sqlca.executeSQL(sSql2);
				}
				rs1.getStatement().close();
			}
			rs.getStatement().close();
	   
	    }*/
	    //Ĭ��Ϊ�����
		Sqlca.executeSQL("Update Business_Apply  set BusinessCurrency = '01' where  SerialNo = '"+sObjectNo+"'");
	    
	    
		return "1";
	 }
}
