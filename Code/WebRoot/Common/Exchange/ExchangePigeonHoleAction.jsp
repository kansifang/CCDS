<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  fXie  2005-4-19 
		Tester:
		Content: ���׹鵵
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
	String	sSerialNoArray = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNoArray"));		
	String sSql = "",sMsg="ERR@";
	if (sSerialNoArray==null) sSerialNoArray="";
	
	try{
		if (sSerialNoArray.equals("")){
			throw new Exception("�������ݴ��󣬳�����ˮ��Ϊ�գ�"); 
		}else{
			sSerialNoArray = StringFunction.replace(sSerialNoArray,",","','");
			sSql="Update BUSINESS_PUTOUT Set ExchangeState='9' where SerialNo in ('"+sSerialNoArray+"')";
			
			Sqlca.executeSQL(sSql);
			sMsg = "SUC@�鵵�ɹ���";
		}
	}catch(Exception e)
	{
		sMsg="ERR@"+ e.toString();
	}		   	
%>
<script language=javascript>
	self.returnValue = "<%=sMsg%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
