<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   ndeng  2005.04.18
		Tester:
		Content: 转移客户主办权
		Input Param:
			  CustomerID：客户代码
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>
<%

	//定义变量

	//获得组件参数
	
	//获得页面参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sBelongUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BelongUserID"));
%>
<html>
<head>
<title>转移主办权</title>

<%
      //将原来用户对当前客户的主办权、信息查看权、信息维护权、业务办理权全部置为“无”
      Sqlca.executeSQL("Update CUSTOMER_BELONG set BelongAttribute='2',BelongAttribute1='2',BelongAttribute2='2',BelongAttribute3='2',BelongAttribute4='2',ApplyStatus=null,ApplyRight=null where CustomerID='"+sCustomerID+"' and UserID='"+sBelongUserID+"'");
      //将当前用户对当前客户的主办权、信息查看权、信息维护权、业务办理权全部置为“有”
      Sqlca.executeSQL("Update CUSTOMER_BELONG set BelongAttribute='1',BelongAttribute1='1',BelongAttribute2='1',BelongAttribute3='1',BelongAttribute4='1' where CustomerID='"+sCustomerID+"' and UserID='"+sUserID+"'");
      
      ASResultSet rs = null;
    	String sSql1 = "select * From CUSTOMER_BELONG where customerid = '"+sCustomerID+"' and userid = '"+sUserID+"'";
    	rs = Sqlca.getASResultSet(sSql1);
    	if(rs.next())
    	{
    		String sSerialNo1 = DBFunction.getSerialNo("CUSTOMER_BELONGLOG","SerialNo","CBL",Sqlca);
    		String sSql2 = "insert into CUSTOMER_BELONGLOG values "+
    		" ('"+sSerialNo1+"','"+rs.getString("CUSTOMERID")+"','"+rs.getString("ORGID")+"','"+rs.getString("USERID")+"', "+
    		" '"+rs.getString("BELONGATTRIBUTE")+"','"+rs.getString("BELONGATTRIBUTE1")+"','"+rs.getString("BELONGATTRIBUTE2")+"', "+
    		" '"+rs.getString("BELONGATTRIBUTE3")+"','"+rs.getString("BELONGATTRIBUTE4")+"','"+rs.getString("INPUTUSERID")+"', "+
    		" '"+rs.getString("INPUTORGID")+"','"+rs.getString("INPUTDATE")+"','"+rs.getString("UPDATEDATE")+"', "+
    		" '"+rs.getString("APPLYATTRIBUTE")+"','"+rs.getString("APPLYATTRIBUTE1")+"','"+rs.getString("APPLYATTRIBUTE2")+"', "+
    		" '"+rs.getString("APPLYATTRIBUTE3")+"','"+rs.getString("APPLYATTRIBUTE4")+"','"+rs.getString("REMARK")+"', "+
    		" '"+rs.getString("APPLYSTATUS")+"','"+rs.getString("APPLYREASON")+"','"+rs.getString("APPLYRIGHT")+"', "+
    		" '"+CurUser.UserID+"','"+CurUser.OrgID+"','"+StringFunction.getToday()+" "+StringFunction.getNow()+"')";
    		Sqlca.executeSQL(sSql2);
    	}
    	rs.close();

%>

<script language=javascript>
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
