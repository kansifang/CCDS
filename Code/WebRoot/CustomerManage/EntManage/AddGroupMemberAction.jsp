<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=ע����;]~*/%>
<%
/* 
  author:  zywei 2006-8-9 
  Tester:
  Content:  �ֹ�������Ա��Ϣ
  Input Param:
			CustomerID���ͻ����	
			RelativeID�������ͻ����
			RelativeType����������		
  Output param:
 
  History Log:     

               
 */
 %>
<%/*~END~*/%>

<%     
	
    //�������
    ASResultSet rs = null;
    int iCount1 = 0,iCount2 = 0;
    String sSql = "";
    String sReturnValue = "";
    //����������
    
    //���ҳ��������ͻ���š������ͻ���ź͹������͡�
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
   	String sRelativeType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeType"));
   	//����ֵת��Ϊ���ַ���
   	if(sCustomerID == null) sCustomerID = "";
   	if(sRelativeID == null) sRelativeID = "";
   	if(sRelativeType == null) sRelativeType = "";
   	
   	//�������ͻ��Ƿ��Ѵ���ĳ������
   	sSql = 	" select Count(CustomerID) "+ 
			" from CUSTOMER_RELATIVE " +
			" where RelativeID='"+sRelativeID+"' "+
			" and RelationShip like '04%' "+
			" and length(RelationShip)>2 ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
		iCount1 = rs.getInt(1);
	rs.getStatement().close();	
	if(iCount1 <= 0)
	{
		//�������ͻ��Ƿ��Ѵ��ڵ�ǰϵͳ�Զ����������
		sSql =  " select Count(CustomerID) from GROUP_SEARCH "+
				" where RelativeID = '"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) 
			iCount2 = rs.getInt(1);	
		rs.getStatement().close();
		
		if(iCount2 <= 0)
		{
			sReturnValue = "HaveRecord_Search"; //�ͻ��Ѿ�����ϵͳ�����Ľ��֮��
		}else
		{
			sSql = " Insert into GROUP_SEARCH(CustomerID,RelativeID,SearchFlag, "+
				   " InputOrgid,InputUserid,InputDate,UpdateDate,UpdateOrgid, "+
				   " UpdateUserid,RelativeType) "+
				   " values('"+sCustomerID+"','"+sRelativeID+"','2', "+
				   " '"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"', "+
				   " '"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"', "+
				   " '"+sRelativeType+"') ";
					
			Sqlca.executeSQL(sSql);	
			sReturnValue = "Join"; //�ÿͻ��Ѿ�����Ϊ���ſͻ���
		}		
	}else
	{
		sReturnValue = "HaveRecord_Member";//�ͻ��Ѿ����ڣ������Ѿ���ĳһ�����ŵĳ�Ա	
	}	    	      
%>

<script language=javascript>
	self.returnValue = "<%=sReturnValue%>";	
	self.close();		
</script>


<%@ include file="/IncludeEnd.jsp"%>