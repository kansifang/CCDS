<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ndeng  2005.1.24
		Tester:
		Content: ������ɵļ�鱨�����
		Input Param:
			 SerialNo: ��ˮ��
			 ObjectType����������
			 ObjectNo��������
		Output param:
		
		History Log: zywei 2006/09/11 �ؼ����
			
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>���������</title>
<%
	//�������
	String sSql = "";
	
	//��ȡҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sInspectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("InspectType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	//����Ǵ�����;����
	if(sObjectType.equals("BusinessContract"))
	{
		sSql = 	" update INSPECT_INFO set FinishDate = null,InspectType = '010010'"+
				" where SerialNo = '"+sSerialNo+"' "+
				" and ObjectNo = '"+sObjectNo+"' "+
				" and ObjectType = '"+sObjectType+"'";
		Sqlca.executeSQL(sSql);
	}
	//�ͻ���鱨�棬
	else if(sObjectType.equals("Customer") && sInspectType.equals("020020"))
	{		
		sSql = 	" update INSPECT_INFO set FinishDate = null,InspectType = '020010'"+
	   			" where SerialNo = '"+sSerialNo+"' "+
	   			" and ObjectNo = '"+sObjectNo+"' "+
	   			" and ObjectType = '"+sObjectType+"' ";
		Sqlca.executeSQL(sSql);
		sSql = " update CHECK_Frequency set NextCheckTime='' where CustomerID ='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
	}
	else if(sObjectType.equals("Customer") && sInspectType.equals("040020"))
	{		
		sSql = 	" update INSPECT_INFO set FinishDate = null,InspectType = '040010'"+
	   			" where SerialNo = '"+sSerialNo+"' "+
	   			" and ObjectNo = '"+sObjectNo+"' "+
	   			" and ObjectType = '"+sObjectType+"' ";
		Sqlca.executeSQL(sSql);
		sSql = " update CHECK_Frequency set NextCheckTime='' where CustomerID ='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
	}
%>
<script language=javascript>
	alert(getBusinessMessage('655'));//���泷����ɣ�
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>