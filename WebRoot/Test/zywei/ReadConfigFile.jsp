<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="java.util.ResourceBundle" %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006/08/06
		Tester: 
  		Content: ��ȡ�����ļ���Ϣ
  		Input Param:
  		Output param:
  		History Log:
			
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�����ļ�credit.properties�����WEB-INF\classesĿ¼��
    //ResourceBundle resourcebundle = ResourceBundle.getBundle("credit",java.util.Locale.CHINA);
	//String sReportUrl = resourcebundle.getString("ReportHome");
	//�����ļ�cfg.properties�����WEB-INF\etcĿ¼��
	ResourceBundle resourcebundle = ResourceBundle.getBundle("cfg",java.util.Locale.CHINA);
	String sReportUrl = resourcebundle.getString("ReportHome");
	out.println("---------------"+sReportUrl);
	%>

<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>