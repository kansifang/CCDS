<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   fXie  2005-3-21 10:01
		Tester:
		Content:  
		Input Param:
			      DegbugFlag : ���Ա�־��0 ������ʾ������Ϣ 1����ʾ������Ϣ          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>
<%
		
	//ҳ�����֮��Ĵ���һ��Ҫ�� DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window.open
	//��ȡSerialNo�б�
	String sSerialNoArray = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNoArray"));
	String sSql = "",sMsg = "";
	if (sSerialNoArray==null) sSerialNoArray="000";
	
	try{
		sSerialNoArray = StringFunction.replace(sSerialNoArray,",","','");
		sSql = " delete from Trade_Log where SerialNo in ('"+sSerialNoArray+"')";
		Sqlca.executeSQL(sSql);
		sMsg = "SUC";
	}catch (Exception e){
		sMsg = e.getMessage();
	}
%>
<script language=javascript>
	self.returnValue = "<%=sMsg%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
