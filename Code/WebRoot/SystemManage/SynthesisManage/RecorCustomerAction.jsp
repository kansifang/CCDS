<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  mjpeng 2011-1-19
		Tester:
		Content:  --得到客户代号
		Input Param:
	        CustomerID：客户代号
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户历史修改记录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得组件参数,客户代号代号，变更人代号，组织机构
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	//将空值转化为空字符串
	if(sCustomerID == null) sCustomerID = "";           
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获取数据值 ;]~*/%>
<%     
	ASResultSet rs = null;
	String sSql = "select * From Customer_Info where CustomerID = '"+sCustomerID+"'";
	String sUserID = CurUser.UserID ;
	String sBelongOrg = CurOrg.OrgID ;
	String sEfficientDate =StringFunction.getToday() ;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		
		String sSql1 = "insert into CUSTOMER_CHANGELOG values('"+sCustomerID+"','"+DataConvert.toString(rs.getString("CUSTOMERNAME"))+"','"+DataConvert.toString(rs.getString("CUSTOMERTYPE"))+"','"+
						DataConvert.toString(rs.getString("CERTTYPE"))+"','"+DataConvert.toString(rs.getString("CERTID"))+"','"+DataConvert.toString(rs.getString("LOANCARDNO"))+"','"
						+sUserID+"','"+sBelongOrg+"','"+sEfficientDate+"')";
		Sqlca.executeSQL(sSql1);
	}
	rs.close();
    
%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>
