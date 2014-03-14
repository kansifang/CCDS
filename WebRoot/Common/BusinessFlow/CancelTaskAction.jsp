<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.lmt.baseapp.flow.*" %>
<%
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));//从上个页面得到传入的任务流水号
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));//从上个页面得到传入的申请流水号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));//从上个页面得到传入的申请流水号
	
	
	String sReturnMessage = "";//执行后返回的信息
	
	FlowGoBack back = new FlowGoBack(sSerialNo,sObjectNo,sObjectType,Sqlca);
	sReturnMessage = back.cancel();
	
	/* 因为流程现在改为A退回补充资料的，客户经理直接提交给A不经过其他人，原先退回到上一步时只能
	        退到客户经理，而业务当中需要退回到提交业务给A的那个人
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);//初始化任务对象
	sReturnMessage = ftBusiness.cancel(CurUser).ReturnMessage;
	System.out.println("--------------------"+sReturnMessage+"----------------");

	//add by xqli by 退回业务时删除上一阶段的签署的意见
	Sqlca.executeSQL(" delete from flow_opinion where serialno=("+
			" select max(serialno) from flow_task where objectno='"+sObjectNo+"' and objecttype='"+sObjectType+"')"
			);*/
%>
<script language=javascript>	
	if("<%=sReturnMessage%>" == "退回完成")
		self.returnValue = "Commit";
	else
		self.returnValue = '<%=sReturnMessage%>';
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>