<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="java.util.ResourceBundle" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei  2006/08/06
		Tester: 
  		Content: 读取配置文件信息
  		Input Param:
  		Output param:
  		History Log:
			
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//配置文件credit.properties存放在WEB-INF\classes目录下
    //ResourceBundle resourcebundle = ResourceBundle.getBundle("credit",java.util.Locale.CHINA);
	//String sReportUrl = resourcebundle.getString("ReportHome");
	//配置文件cfg.properties存放在WEB-INF\etc目录下
	ResourceBundle resourcebundle = ResourceBundle.getBundle("cfg",java.util.Locale.CHINA);
	String sReportUrl = resourcebundle.getString("ReportHome");
	out.println("---------------"+sReportUrl);
	%>

<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>