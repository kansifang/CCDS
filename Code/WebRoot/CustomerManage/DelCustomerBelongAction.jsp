<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Action00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: �ͻ���Ϣ¼�����
		Input Param:
			CustomerID���ͻ����					
		Output param:
			ReturnValue:����ֵ
				ExistApply:����δ�ս������
				ExistApprove:����δ�ս�������������
				ExistContract:����δ�ս�ĺ�ͬ
		History Log: 
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Action01;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "",sReturnValue = "";		
	int iCount = 0;
	ASResultSet rs = null;
	
	//��ȡ�������
	
	//��ȡҳ��������ͻ����
	String sCustomerID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));	
	//����ֵת��Ϊ���ַ���
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Action02;Describe=����ҵ���߼�;]~*/%>
<%    
	//����δ�ս�����ҵ����
	sSql = " select count(SerialNo) from BUSINESS_APPLY "+
		   " where CustomerID = '"+sCustomerID+"' "+
	       " and PigeonholeDate is null "+
	       " and OperateUserID = '"+CurUser.UserID+"' " ;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close(); 		
	if (iCount == 0)	//����ҵ��ȫ���ս�
	{	
		//����δ�ս������������ҵ����
		sSql = " select count(*) from BUSINESS_APPROVE "+
			   " where CustomerID = '"+sCustomerID+"' "+
		       " and PigeonholeDate is null "+
		       " and OperateUserID = '"+CurUser.UserID+"' " ;
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()) iCount = rs.getInt(1);
		rs.getStatement().close();
		if(iCount == 0)	//�����������ҵ��ȫ���ս�
		{	
			//����δ�ս��ͬҵ����
			sSql = " select count(*) from BUSINESS_CONTRACT "+
				   " where CustomerID = '"+sCustomerID+"' "+
			       " and FinishDate is null "+
			       " and ManageUserID = '"+CurUser.UserID+"' " ;
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()) iCount = rs.getInt(1);
			rs.getStatement().close();
			if (iCount == 0)	//��ͬҵ��ȫ���ս�
			{	
				//����ɾ��������Ϣ
				Sqlca.executeSQL("Delete from  Customer_Belong where CustomerID='"+sCustomerID+"'"+" and UserID='"+CurUser.UserID+"'");					
				sReturnValue = "DelSuccess";//�ÿͻ�������Ϣ��ɾ����		
			}else
			{
				sReturnValue = "ExistContract";//�ÿͻ�������ͬҵ��δ�սᣬ����ɾ����
			}
		}else
		{
			sReturnValue = "ExistApprove";//�ÿͻ����������������δ�սᣬ����ɾ����
		}
	}else
	{
		sReturnValue = "ExistApply";//�ÿͻ���������ҵ��δ�սᣬ����ɾ����
	}	
	    	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Action03;Describe=����ֵ;]~*/%>
<script language=javascript>
	self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>