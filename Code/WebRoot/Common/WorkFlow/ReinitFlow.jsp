<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.lending.bizlets.*" %>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lpzhang 2009-8-14 
		Tester:
		Describe: ��ȡ������ˮ��
		Input Param:
			ObjectNo:�������
			ObjectType����������
			TaskNo�����̺�
		Output Param:
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%> 


<% 
	//��ȡ�������������,��������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sTaskNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TaskNo"));
	//����ֵת���ɿ��ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sTaskNo == null) sTaskNo = "";
	//��ʼ�����̶���
	CreditFlowBusiness CB = new CreditFlowBusiness(sObjectNo,sObjectType,Sqlca);
	CB.InitWorkFlow(sTaskNo);
	
%>


<script language=javascript>
    self.close();    
</script>


<%@ include file="/IncludeEnd.jsp"%>
