<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2005.1.2
		Tester:
		Content: �������
		Input Param:
			                sObjectNo:����
			                sInspectType:��������
							                010	������;����
											020	�����鱨��
		Output param:
		History Log: 
			2004-12-13	cchang	���Ӹ��幤�̻�����
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>������;���ͻ���Ϣ</title>
<%
	String sSql;
	String sObjectNo="",sInspectType="",sSerialNo="";	
	ASResultSet rs = null;
	String sActionType=DataConvert.toRealString(iPostChange,(String)request.getParameter("ActionType"));
	if(sActionType==null) sActionType="";
	//�����ɾ������
	if(sActionType.equals("Del"))
	{
		sSerialNo=DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));

		sSql="delete from inspect_info where SerialNo='"+sSerialNo+"'";
		Sqlca.executeSQL(sSql);
	}
	//��������
	else
	{
		sObjectNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
		sInspectType   = DataConvert.toRealString(iPostChange,(String)request.getParameter("InspectType"));
		sSerialNo = DBFunction.getSerialNo("INSPECT_INFO","SerialNo",Sqlca);
		if(sInspectType.equals("030010"))
		{
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('CustomerRisk','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);	
		}
	}

	
%>
<script language=javascript>
	self.returnValue = "<%=sSerialNo%>";
	//alert(<%=sSerialNo%>);
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>