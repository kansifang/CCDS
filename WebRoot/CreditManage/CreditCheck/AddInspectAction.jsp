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
	String sReportType=DataConvert.toRealString(iPostChange,(String)request.getParameter("ReportType"));	
	if(sActionType==null) sActionType="";
	if(sReportType == null) sReportType = "";
	//�����ɾ������
	if(sActionType.equals("Del"))
	{
		sSerialNo=DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));

		sSql="delete from inspect_info where SerialNo='"+sSerialNo+"'";
		Sqlca.executeSQL(sSql);
		//ɾ���ô�����;���������¼���ÿ��¼
		sSql="delete from inspect_detail where ObjectNo='"+sSerialNo+"'";
		Sqlca.executeSQL(sSql);
	}
	//��������
	else
	{
		sObjectNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
		sInspectType   = DataConvert.toRealString(iPostChange,(String)request.getParameter("InspectType"));
		sSerialNo = DBFunction.getSerialNo("INSPECT_INFO","SerialNo",Sqlca);
		if(sInspectType.equals("020010") || sInspectType.equals("020020"))
		{
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate,ReportType) "+
				"values('Customer','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"','"+sReportType+"')";
			Sqlca.executeSQL(sSql);
			
			sSql = "update Check_Frequency set CheckTime ='"+StringFunction.getToday()+"',NextCheckTime = null where CustomerID = '"+sObjectNo+"'";	
			Sqlca.executeSQL(sSql);

			//sSql = "insert into inspect_detail(ObjectType,ObjectNo,SerialNo,ItemNo,ItemName)"+
			//" select 'Customer','"+sObjectNo+"','"+sSerialNo+"',ItemNo,ItemName from CODE_LIBRARY where CodeNo='InspectInfo'";
			//Sqlca.executeSQL(sSql);
		}
		else if(sInspectType.equals("040010") || sInspectType.equals("040020")){
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('Customer','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
			
			sSql = "update Check_Frequency set CheckTime ='"+StringFunction.getToday()+"',NextCheckTime = null where CustomerID = '"+sObjectNo+"'";	
			Sqlca.executeSQL(sSql);
		}
		//����ҵ����������
		else if(sInspectType.equals("060")) {
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('ApproveApproval','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
			
			//sSql = "update Check_Frequency set CheckTime ='"+StringFunction.getToday()+"',NextCheckTime = null where CustomerID = '"+sObjectNo+"'";	
			//Sqlca.executeSQL(sSql);
		}
		//Ԥ����������
		else if(sInspectType.equals("RiskSignal16")) {
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('RiskSignal','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		}
		//Ԥ����������
		else if(sInspectType.equals("RiskSignal17")) {
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('FreeRiskSignal','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		}//���������
		else if(sInspectType.equals("065")) {
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('RehearForm','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		}
		//Ԥ�����ñ���
		else if(sInspectType.equals("RiskSignalDispose")) {
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
			"values('RiskSignalDispose','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
		Sqlca.executeSQL(sSql);
		}
		else
		{
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('BusinessContract','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
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