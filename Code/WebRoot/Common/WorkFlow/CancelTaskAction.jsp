<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: CChang 2003.8.28
 * Tester:
 *
 * Content: 提示下一阶段信息 
 * Input Param:
 * 				SerialNo：	当前任务的流水号
 * Output param:
 *				sReturnValue:	返回值Commit表示完成操作
 * History Log:
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>
<% 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));//从上个页面得到传入的任务流水号
	String sReturnMessage = "";//执行后返回的信息
	
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);//初始化任务对象
	//ftBusiness.cancel(CurUser);//执行退回操作
	sReturnMessage = ftBusiness.cancel(CurUser).ReturnMessage;	
%>
<script language=javascript>	
	if("<%=sReturnMessage%>" == "退回完成")
		self.returnValue = "Commit";
	else
		self.returnValue = '<%=sReturnMessage%>';
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>