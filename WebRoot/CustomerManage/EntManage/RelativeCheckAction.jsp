<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-3
		Tester:
		Describe:
			��������ϵ�������Ҫ�Ǽ�������ϵ�������ظ����⣬���²��������ϵ��ʱ�򱻵���
			���ڼ��ų�Ա��ϵ����Ҫ��Աֻ����һ���������Ա��ϵ����0401��

		Input Param:
			CustomerID: �ͻ����
			RelationShip: ������ϵ
			CertType: ֤������
			CertID:֤������
		Output Param:
			Message: ���ع����ͻ����RelativeID ���Ϊ�����ʾ��鲻ͨ��,����ʾ��Ϣ
		HistoryLog: pliu 2011-11-28
	*/
	%>
<%/*~END~*/%>

<%
	//��ȡҳ�����
	String sCustomerID   = DataConvert.toRealString(iPostChange,CurPage.getParameter("CustomerID"));
	String sRelationShip = DataConvert.toRealString(iPostChange,CurPage.getParameter("RelationShip"));
	String sCertType     = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertType"));
	String sCertID       = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertID"));
	
	//�������
	String sRelativeID = "";
	String sSql = "";
	String sMessage = "";
	String sRelativeRelationShip = "";
	ASResultSet rs = null;
	
	//����֤�����ͺ�֤����Ż�ȡ�ͻ����
	sSql = 	" select CustomerID from CUSTOMER_INFO "+
			" where CertType = '"+sCertType+"' "+
			" and CertID = '"+sCertID+"' ";
	rs = Sqlca.getResultSet(sSql);
	if (rs.next()) {
		sRelativeID = rs.getString(1);
		
		//���ݿͻ���š������ͻ���ź͹�����ϵ��ù����ͻ�����
		sSql = 	" select CustomerName from CUSTOMER_RELATIVE "+
				//" where CustomerID = '"+sCustomerID+"' "+
				//" and RelativeID = '"+sRelativeID+"' "+
				" where RelativeID = '"+sRelativeID+"' "+
				" and RelationShip = '"+sRelationShip+"' ";	
		//����Ƿ��˴���������ϵ����жϿ��÷��˴�����ż�Ƿ��ǵ�ǰ�ͻ�
		if(sRelationShip.startsWith("06"))
		{
			//������ϵת��
			if("0601".equals(sRelationShip))//��ż(���˴���)
			{
				sRelativeRelationShip="0301";
			}else if("0602".equals(sRelationShip))//��ĸ(���˴���)
			{
				sRelativeRelationShip="0302";
			}else if("0603".equals(sRelationShip))//��Ů(���˴���)
			{
				sRelativeRelationShip="0303";
			}else if("0604".equals(sRelationShip))//����Ѫ��(���˴���)
			{
				sRelativeRelationShip="0304";
			}else if("0605".equals(sRelationShip))//��������(���˴���)
			{
				sRelativeRelationShip="0305";
			}
			sSql += " and not exists(select 1 from CUSTOMER_RELATIVE CR1,CUSTOMER_RELATIVE CR2 "+
					" where CR1.RelativeID=CR2.CustomerID "+
					" and CR1.CustomerID=CUSTOMER_RELATIVE.CustomerID "+
					" and CR1.RelationShip='0100' and CR2.RelationShip='"+sRelativeRelationShip+"')";
		}
		//����������ι�ϵ,���ж��ڱ��ͻ��Ƿ���ڹ�ϵ
		if("99".equals(sRelationShip.substring(0,2)))
		{
			sSql = 	" select CustomerName from CUSTOMER_RELATIVE "+
					" where CustomerID = '"+sCustomerID+"' "+
					" and RelativeID = '"+sRelativeID+"' ";
		}
		ASResultSet rs1 = Sqlca.getResultSet(sSql);		
		if (rs1.next()&&!"52".equals(sRelationShip.substring(0,2)))
		{
			if(!"02".equals(sRelationShip.substring(0,2)))
			{
				sMessage="�ͻ�["+rs1.getString("CustomerName")+"]�������ͻ��Ѿ����ڴ˹�ϵ,��ѡ�������Ĺ�ϵ��ͻ��󱣴�!";
			}
			if("99".equals(sRelationShip.substring(0,2)))
			{
				sMessage="�ͻ�["+rs1.getString("CustomerName")+"]�뱾�ͻ��Ĵ˹�ϵ�Ѿ�����,��ѡ�������Ĺ�ϵ��ͻ��󱣴�!";
			}
			if (sRelationShip.equals("0401"))
				//sMessage="�ͻ�["+rs1.getString("CustomerName")+"]�Ѿ��Ǹü��ŵ������Ա,һ����������ֻ����һ�������Ա,���豣��!";
				sMessage="�ͻ�["+rs1.getString("CustomerName")+"]�Ѿ��Ǽ��ŵ������Ա,һ�������Աֻ������һ������,���豣��!";
		}
		rs1.getStatement().close();
		
		if (!sMessage.equals("")) sRelativeID = "";
	}else 
	{
		sRelativeID = DBFunction.getSerialNo("CUSTOMER_INFO","CustomerID",Sqlca);
	}
	rs.getStatement().close();	
%>
<script	language=javascript>
	if ("<%=sMessage%>" != "" ) alert("<%=sMessage%>");
	self.returnValue = "<%=sRelativeID%>"
	self.close();
</script>
<%@	include file="/IncludeEnd.jsp"%>