<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.lmt.baseapp.flow.*" %>
<%
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));//���ϸ�ҳ��õ������������ˮ��
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));//���ϸ�ҳ��õ������������ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));//���ϸ�ҳ��õ������������ˮ��
	
	
	String sReturnMessage = "";//ִ�к󷵻ص���Ϣ
	
	FlowGoBack back = new FlowGoBack(sSerialNo,sObjectNo,sObjectType,Sqlca);
	sReturnMessage = back.cancel();
	
	/* ��Ϊ�������ڸ�ΪA�˻ز������ϵģ��ͻ�����ֱ���ύ��A�����������ˣ�ԭ���˻ص���һ��ʱֻ��
	        �˵��ͻ�������ҵ������Ҫ�˻ص��ύҵ���A���Ǹ���
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);//��ʼ���������
	sReturnMessage = ftBusiness.cancel(CurUser).ReturnMessage;
	System.out.println("--------------------"+sReturnMessage+"----------------");

	//add by xqli by �˻�ҵ��ʱɾ����һ�׶ε�ǩ������
	Sqlca.executeSQL(" delete from flow_opinion where serialno=("+
			" select max(serialno) from flow_task where objectno='"+sObjectNo+"' and objecttype='"+sObjectType+"')"
			);*/
%>
<script language=javascript>	
	if("<%=sReturnMessage%>" == "�˻����")
		self.returnValue = "Commit";
	else
		self.returnValue = '<%=sReturnMessage%>';
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>