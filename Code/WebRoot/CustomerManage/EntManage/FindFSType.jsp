<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: 取得对应的报表类型
		Input Param:
			                
		Output param:
		History Log: 
			DATE	CHANGER		CONTENT
			2005-8-10	fbkang	页面调整				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "取得报表的类型"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数,返回有效值;]~*/%>
<html>
<head>
<title>取得报表的类型</title>
<%
    //定义变量
	String sSql = "";//--存放sql语句
	String sObjectNo = "";//--对象编号
	String sObjectType = "";//--对象类型
	String sTabelName = "";//--表名
	String sReturnValue = "false";//--布尔值
	
	//获得页面参数，对象编号 暂时为客户号
	sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));

	//根据客户号找到对应的客户类型
	sSql = "select CustomerType from CUSTOMER_INFO where CustomerID ='"+sObjectNo+"' ";
	sObjectType = Sqlca.getString(sSql);
		
	//根据不同的客户类型到不同的表中取得对应的报表类型
	if(sObjectType!=null && ("01,02").indexOf(sObjectType.substring(0,2))>=0)// 公司客户、集团客户
		sTabelName = "ENT_INFO ";
	else if(sObjectType!=null && ("03,04,05").indexOf(sObjectType.substring(0,3))>=0)//个人客户、个体工商户、农户
		sTabelName = "IND_INFO ";

	//获取财务报表类型
	sSql = "select FinanceBelong as FSModelClass from "+sTabelName+" where CustomerID ='"+sObjectNo+"' and length(FinanceBelong)>1";
	String sFinanceBelong = Sqlca.getString(sSql);	
	if(sFinanceBelong == null) sFinanceBelong = "";
	if(!sFinanceBelong.equals("")) sReturnValue = sFinanceBelong;	
	
		
%>
<script language=javascript>
	self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>