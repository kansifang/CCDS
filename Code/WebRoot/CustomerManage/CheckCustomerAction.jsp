<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: �ͻ���Ϣ���
		Input Param:
			CustomerType���ͻ�����
					01����˾�ͻ���
					0201��һ�༯�ſͻ���
					0202�����༯�ſͻ���ϵͳ��ʱ���ã���
					03�����˿ͻ���
			CustomerName:�ͻ�����
			CertType:�ͻ�֤������
			CertID:�ͻ�֤������
		Output param:
  			ReturnStatus:����״̬
				01Ϊ�޸ÿͻ�
				02Ϊ��ǰ�û�����ÿͻ���������
				04Ϊ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ.
				05Ϊ��ǰ�û�û����ÿͻ���������,���к������ͻ���������Ȩ.
		History Log: 			
			2005/09/10 �ؼ����
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>���ͻ���Ϣ</title>
<%
	//���������Sql��䡢������Ϣ���ͻ����롢����Ȩ
	String sSql = "",sReturnStatus = "",sCustomerID = "",sBelongAttribute = "";	
	//���������������
	int iCount = 0;
	//�����������ѯ�����
	ASResultSet rs = null;
	
	//��ȡҳ��������ͻ����͡��ͻ����ơ�֤�����͡�֤�����
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));	
	String sCertType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertType"));
	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));	
	//����ֵת��Ϊ���ַ���
	if(sCustomerType == null) sCustomerType = "";
	if(sCustomerName == null) sCustomerName = "";
	if(sCertType == null) sCertType = "";
	if(sCertID == null) sCertID = "";
	
	//�ǹ������ſͻ���ͨ��֤�����͡�֤���������Ƿ���CI���д�����Ϣ	
	if(!sCustomerType.substring(0,2).equals("02")&&!sCustomerType.equals("0401")&&!sCustomerType.equals("0501"))		
		sSql = 	" select CustomerID "+
				" from CUSTOMER_INFO "+
				" where CertType = '"+sCertType+"' "+
				" and CertID = '"+sCertID+"' "+
				" and (CustomerID is not null and CustomerID <>'')";
	else //�������ſͻ�ͨ���ͻ����Ƽ���Ƿ���CI���д�����Ϣ
		sSql = 	" select CustomerID "+
				" from CUSTOMER_INFO "+
				" where CustomerName = '"+sCustomerName+"' "+
				" and CustomerType = '"+sCustomerType+"' ";
	sCustomerID = Sqlca.getString(sSql);
	if(sCustomerID == null) sCustomerID = "";
	
	if(sCustomerID.equals(""))
	{
		//�޸ÿͻ�
		sReturnStatus = "01";
	}else
	{
		//�õ���ǰ�û���ÿͻ�֮��ܻ���ϵ
		sSql = 	" select count(CustomerID) "+
				" from CUSTOMER_BELONG "+
				" where CustomerID = '"+sCustomerID+"' "+
				" and UserID = '"+CurUser.UserID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		   	iCount = rs.getInt(1);

		rs.getStatement().close(); 
		
		if(iCount > 0)
		{
  			//02Ϊ��ǰ�û�����ÿͻ�������Ч����
 			sReturnStatus = "02";
		}else
		{
			//���ÿͻ��Ƿ��йܻ���
			sSql = 	" select count(CustomerID) "+
					" from CUSTOMER_BELONG "+
					" where CustomerID = '"+sCustomerID+"' "+
					" and BelongAttribute = '1'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			   	iCount = rs.getInt(1);
	
			rs.getStatement().close(); 
			
			if(iCount > 0)
			{
  				//05Ϊ��ǰ�û�û����ÿͻ���������,���кͿͻ���������Ȩ.
				sReturnStatus = "05";
			}else
			{
  				//04Ϊ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ.
				sReturnStatus = "04";
			}
		}
	}		
	
%>
<script language=javascript>
	//���ؼ��״ֵ̬�Ϳͻ���
	self.returnValue = "<%=sReturnStatus%>"+"@"+"<%=sCustomerID%>";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>