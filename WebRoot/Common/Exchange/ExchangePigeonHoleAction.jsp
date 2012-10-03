<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  fXie  2005-4-19 
		Tester:
		Content: 交易归档
		Input Param:
			      DegbugFlag : 调试标志：0 ：不显示调试信息 1：显示调试信息          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	//页面参数之间的传递一定要用 DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window.open
	//获取SerialNo列表
	String	sSerialNoArray = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNoArray"));		
	String sSql = "",sMsg="ERR@";
	if (sSerialNoArray==null) sSerialNoArray="";
	
	try{
		if (sSerialNoArray.equals("")){
			throw new Exception("参数传递错误，出账流水号为空！"); 
		}else{
			sSerialNoArray = StringFunction.replace(sSerialNoArray,",","','");
			sSql="Update BUSINESS_PUTOUT Set ExchangeState='9' where SerialNo in ('"+sSerialNoArray+"')";
			
			Sqlca.executeSQL(sSql);
			sMsg = "SUC@归档成功！";
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
