<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2005.1.2
		Tester:
		Content: 插入检查表
		Input Param:
			                sObjectNo:代号
			                sInspectType:报告类型
							                010	贷款用途报告
											020	贷款检查报告
		Output param:
		History Log: 
			2004-12-13	cchang	增加个体工商户操作
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>贷款用途检查客户信息</title>
<%
	String sSql;
	String sObjectNo="",sInspectType="",sSerialNo="";	
	ASResultSet rs = null;
	String sActionType=DataConvert.toRealString(iPostChange,(String)request.getParameter("ActionType"));
	if(sActionType==null) sActionType="";
	//如果是删除操作
	if(sActionType.equals("Del"))
	{
		sSerialNo=DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));

		sSql="delete from inspect_info where SerialNo='"+sSerialNo+"'";
		Sqlca.executeSQL(sSql);
	}
	//新增操作
	else
	{
		sObjectNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
		sInspectType   = DataConvert.toRealString(iPostChange,(String)request.getParameter("InspectType"));
		sSerialNo = DBFunction.getSerialNo("INSPECT_INFO","SerialNo",Sqlca);
		if(sInspectType.equals("030010"))
		{
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('CustomerRisk','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
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