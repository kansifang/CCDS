<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  cchang  2004.12.2
		Tester:
		Content: --Ȩ�����뵯��ҳ��
		Input Param:
			  CustomerID  ��--�ͻ���
		Output param:
			               
		History Log: 
		   DATE	    CHANGER		CONTENT
		   2005.7.27 fbkang     �޸��µİ汾      
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�Ȩ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window.open
	//��ȡ�����������͸�ʽ
	//�������	
	String  sSql = "";//--���sql���	
	String  sSuperiorOrgID = "";//--����ϼ����ڻ�������
	String  sSuperiorOrgName = "";//--����ϼ����ڻ�������
	String  sMessage = "";//--�����Ϣ
	ASResultSet rs = null;//--��Ž����
	//��ȡҳ�����
	String	sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	//��ȡ�������	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ȡ����ֵ;]~*/%>
<%
//modify by xhyong 2009/08/18 �ͻ�Ȩ�������ύ������
/*~
	//��ȡ��ǰ�������ϼ�����
	sSql = 	" select OI.RelativeOrgID as SuperiorOrgID,getOrgName(OI.RelativeOrgID) as SuperiorOrgName "+
			" from ORG_INFO OI"+
			" where OI.OrgID = '"+CurOrg.OrgID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sSuperiorOrgID = rs.getString("SuperiorOrgID");
		sSuperiorOrgName = rs.getString("SuperiorOrgName");	
	}
	rs.getStatement().close();
~*/
	//  10--ֱ��֧�пͻ�Ȩ�޹���Ա  20--����֧�пͻ�Ȩ�޹���Ա 30--���пͻ�Ȩ�޹���Ա 
	String sSql1 = "select OrgFlag from org_info where orgid = '"+CurOrg.OrgID+"'";
	String sOrgFlag = Sqlca.getString(sSql1);
	if (CurUser.hasRole("080")||"030".equals(sOrgFlag)){  //���ſͻ���,ֱ��֧��
		String sSql3 = " select OrgFlag from org_info where orgid in(select orgid from customer_belong where customerid = '"+sCustomerID+"' and belongattribute='1' fetch first 1 rows only) ";
		String sOrgFlag3 = Sqlca.getString(sSql3);
		if("030".equals(sOrgFlag3)&&!CurUser.hasRole("080"))//ֱ��֧��֮��ͻ�Ȩ�޽��Ӹ�ֱ��֧�йܻ�Ȩ������
		{
			sSuperiorOrgID = "9900";
			sSuperiorOrgName = "����";
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '10' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
	
		}else
		{
			sSuperiorOrgID = "9900";
			sSuperiorOrgName = "����";
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '30' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		}
	}else if("010".equals(sOrgFlag))  //2��֧��
	{
		String sSql2 = 	" select OI.RelativeOrgID as SuperiorOrgID,getOrgName(OI.RelativeOrgID) as SuperiorOrgName "+
		" from ORG_INFO OI"+
		" where OI.OrgID = '"+CurOrg.OrgID+"' ";
		rs = Sqlca.getASResultSet(sSql2);
		if(rs.next())
		{
			sSuperiorOrgID = rs.getString("SuperiorOrgID");
			sSuperiorOrgName = rs.getString("SuperiorOrgName");	
		}
		rs.close();
		//���ӵ�йܻ�Ȩ�Ļ���Ϊ����֧����ȡ����������ȡ�ϼ�����
		String sSql3 = " select case when OrgFlag='020' then OrgID else RelativeOrgID end "+
						" from ORG_INFO "+
						" where OrgID in(select orgid from customer_belong where customerid = '"+sCustomerID+"' and belongattribute='1') ";
		String sOrgID = Sqlca.getString(sSql3);
		if(CurOrg.RelativeOrgID.equals(sOrgID))
		{
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '20' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		}else
		{	
			sSuperiorOrgID = "9900";
			sSuperiorOrgName = "����";
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '30' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		}
	}else if("020".equals(sOrgFlag)||"040".equals(sOrgFlag))//����֧��
	{
		String sSql2 = 	" select OrgID as SuperiorOrgID,OrgName as SuperiorOrgName "+
		" from ORG_INFO OI"+
		" where OI.OrgID = '"+CurOrg.OrgID+"' ";
		rs = Sqlca.getASResultSet(sSql2);
		if(rs.next())
		{
			sSuperiorOrgID = rs.getString("SuperiorOrgID");
			sSuperiorOrgName = rs.getString("SuperiorOrgName");	
		}
		rs.close();
		String sSql3 = " select RelativeOrgID from ORG_INFO where OrgID in(select orgid from customer_belong where customerid = '"+sCustomerID+"' and belongattribute='1') ";
		String sOrgID = Sqlca.getString(sSql3);
		if(CurOrg.OrgID.equals(sOrgID))
		{
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+CurOrg.OrgID+"',Flag1 = '20' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		}else
		{	
			sSuperiorOrgID = "9900";
			sSuperiorOrgName = "����";
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '30' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		}
	}else 
	{
		sSuperiorOrgID = "9900";
		sSuperiorOrgName = "����";
		Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '30' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		//Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='9900' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		//sSuperiorOrgName = CurOrg.OrgName;
	}
	//sSuperiorOrgID = "9900";
	//sSuperiorOrgName = "����";
	//Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
	sMessage = "�ÿͻ�Ȩ��������Ϣ�Ѿ����͵���"+sSuperiorOrgName+"�����������ϻ����Ŀͻ�Ȩ�޹�����Ա�������硣 ";
	
%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "<%=sMessage%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
