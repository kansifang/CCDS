<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   --fbkang  2005.07.27
		Tester:
		Content:  --得到客户号
		Input Param:
	        CustomerID：客户代码
	        UserID：用户代码
	        ApplyAttribute：申请客户主办权标志
	        ApplyAttribute1：申请信息查看权标志
	        ApplyAttribute2：申请信息维护标志
	        ApplyAttribute3：申请申请业务申办权标志	
	        ApplyAttribute4：待定的权限标志		                
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户权限申请情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量   
    String sOrgName = "";//--//金融机构名称
    String sUserName = "";//--用户名称
    String sBelongUserID = "";//--所属用户
    String sSql = ""; //--Sql语句
    String sHave = "_FALSE_";      //该客户是否有主办权
	//获得组件参数,客户代码、用户代码、申请客户主办权标志、申请信息查看权标志、申请信息维护标志、申请申请业务申办权标志、待定权限标志
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String sApplyAttribute  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute"));
	String sApplyAttribute1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute1"));
	String sApplyAttribute2 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute2"));
	String sApplyAttribute3 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute3"));
	String sApplyAttribute4 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute4"));
	//将空值转化为空字符串
	if(sCustomerID == null) sCustomerID = "";           
    if(sUserID == null) sUserID = "";
	if(sApplyAttribute == null) sApplyAttribute = "";           
    if(sApplyAttribute1 == null) sApplyAttribute1 = "";
    if(sApplyAttribute2 == null) sApplyAttribute2 = "";
    if(sApplyAttribute3 == null) sApplyAttribute3 = "";
    if(sApplyAttribute4 == null) sApplyAttribute4 = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获取数据值 ;]~*/%>
<%     
    //客户主办权
	if(sApplyAttribute.equals("1"))
	{
	    //判断是否有其他客户经理已具有该客户的主办权
	    sSql = " select BelongAttribute,getOrgName(OrgID) as OrgName, "+
			   " getUserName(UserID) as UserName,UserID "+
               " from CUSTOMER_BELONG "+
               " where CustomerID='"+sCustomerID+"' "+
               " and UserID <> '"+sUserID+"' "+
               " and BelongAttribute = '1'";
	    ASResultSet rs = Sqlca.getResultSet(sSql);
	    if(rs.next()) 
	    {
	        sHave = "_TRUE_";  //已有主办权
	        sOrgName = rs.getString("OrgName");
	        sUserName = rs.getString("UserName");
	        sBelongUserID = rs.getString("UserID");
	    }
	    rs.getStatement().close();	    
	}
	
	//如果该客户的主办权还没有用户拥有，则直接根据审批结果进行客户权限的更新
	if(sHave.equals("_FALSE_"))
	{  
    	sSql = 	" Update CUSTOMER_BELONG set BelongAttribute = '"+sApplyAttribute+"', "+
    			" BelongAttribute1 = '"+sApplyAttribute1+"',BelongAttribute2 = '"+sApplyAttribute2+"', "+
    			" BelongAttribute3 = '"+sApplyAttribute3+"',BelongAttribute4 = '"+sApplyAttribute4+"' "+
    			" where CustomerID = '"+sCustomerID+"' "+
    			" and UserID = '"+sUserID+"' ";
    	Sqlca.executeSQL(sSql);
    	ASResultSet rs = null;
    	String sSql1 = "select * From CUSTOMER_BELONG where customerid = '"+sCustomerID+"' and userid = '"+sUserID+"'";
    	rs = Sqlca.getASResultSet(sSql1);
    	if(rs.next())
    	{	String sSerialNo1 = DBFunction.getSerialNo("CUSTOMER_BELONGLOG","SerialNo","CBL",Sqlca);
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
    } 
%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "<%=sHave%>@<%=sOrgName%>@<%=sUserName%>@<%=sBelongUserID%>";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>
