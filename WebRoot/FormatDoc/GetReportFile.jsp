<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.17
		Tester:
		Content: 检查生成的格式化报告文件是否存在
		Input Param:
			DocID: 文档类别（ FORMATDOC_CATALOG中的调查报告，贷后检查报告，...)
			ObjectNo：对象编号
			ObjectType：对象类型
		Output param:
		History Log: cdeng 2009-02-12 修改获取文档存储路径方式
	 */
	%>
<%/*~END~*/%>


<% 	
	//定义变量
	String sFlag = "",sSerialNoNew = "",sFileName = "";	
	//获得页面参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 		//业务流水号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 	//对象类型
	String sDocID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocID")); 	//对象类型
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sDocID == null) sDocID = "";
	//cdeng 2009-02-12 获取文档存储路径方式
	ASResultSet rs = null;
	String sSql1="";
	sSql1=" select SerialNo,SavePath from Formatdoc_Record where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+"' ";
	if(!sObjectType.equals("PutOutApply"))
		sSql1=sSql1+" and DocID='"+sDocID+"'";
	rs = Sqlca.getASResultSet(sSql1);
	if(rs.next())
	{
		sFileName = rs.getString("SavePath");
	}
	rs.getStatement().close();
	if(sFileName==null) sFileName="";
	
	java.io.File file = new java.io.File(sFileName);
    if(file.exists())
		sFlag = "true";
	else
		sFlag = "false";
	
%>

<script language="JavaScript">
	self.returnValue="<%=sFlag%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>