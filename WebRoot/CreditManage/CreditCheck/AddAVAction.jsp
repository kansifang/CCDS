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
	String sObjectNo="",sObjectType="",sSerialNo="";	
	sObjectNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	sObjectType   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	sSerialNo = DBFunction.getSerialNo("INSPECT_INFO","SerialNo",Sqlca);
	sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
		"values('"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
	Sqlca.executeSQL(sSql);	
%>
<script language=javascript>
	self.returnValue = "<%=sSerialNo%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>