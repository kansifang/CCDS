<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  --JBai 2005.12.17
		Tester:
		Content: --�ͻ���Ϣ���
		Input Param:
			  UserID���ͻ�����
			  OrgID����������			                				
			  CustomerID���ͻ���
			  sCustomerType ���ͻ�����
		Output param:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ���ϢУ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>

<%  
    //���������sql���
	String sSql = "";
	
	//����������
	
    //���ҳ��������ͻ���š��������롢�ͻ���š��ͻ�����
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
   
   	if(sCustomerType == null) sCustomerType = "";
   	
	if(sCustomerType.equals("02"))
	{
	    //��ʼ����
 	   boolean bOld = Sqlca.conn.getAutoCommit(); 
	   try 
	   {		
			if(!bOld) Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(false);
			{
				sSql = 	" update CUSTOMER_BELONG set OrgID = '"+sOrgID+"' , UserID = '"+sUserID+"'"+
						" where CustomerID = '"+sCustomerID+"' and Belongattribute = '1'";
					   	
			}
			
			Sqlca.executeSQL(sSql);
		
			//�����ύ�ɹ�
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(bOld);
		} catch(Exception e)
		{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bOld);
			throw new Exception("������ʧ�ܣ�"+e.getMessage());
		}			
	}
		
   
%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "succeed";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>