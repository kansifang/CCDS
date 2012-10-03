<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   --fbkang  2005.07.26
	Tester:
	Content: --校验客户是否有客户主办权，信息查看权，信息维护权，业务申办权
	Input Param:
		CustomerID：  --所选客户编号。             
	Output param:
		                
	History Log: 
	                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户权限校验"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%  
    //定义变量
    ASResultSet rs = null;//存放结果集    
    String sBelongAttribute = "";//--客户主办权    
    String sBelongAttribute1 = "";//--信息查看权
    String sBelongAttribute2 = "";//--信息维护权
    String sBelongAttribute3 = "";//--业务申办权    
    String sReturnValue = "";//--存放是否有客户主办权标志   
    String sReturnValue1 = "";//--存放是否有信息查看权标志
    String sReturnValue2 = "";//--存放是否有信息维护权标志
    String sReturnValue3 = "";//--存放是否有业务申办权标志
        
    String sReturn = "";   //返回整个标志
    //获得页面参数
    String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
    //获得组件参数
    
    String sSql = " select BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3 "+
                  " from CUSTOMER_BELONG "+
                  " where CustomerID = '"+sCustomerID+"' "+
                  " and UserID = '"+CurUser.UserID+"' ";
	
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{
	   sBelongAttribute = rs.getString("BelongAttribute");
	   sBelongAttribute1 = rs.getString("BelongAttribute1");
	   sBelongAttribute2 = rs.getString("BelongAttribute2");
	   sBelongAttribute3 = rs.getString("BelongAttribute3");	   
	}
	rs.getStatement().close();
	if(sBelongAttribute == null) sBelongAttribute = "";
	if(sBelongAttribute1 == null) sBelongAttribute1 = "";
	if(sBelongAttribute2 == null) sBelongAttribute2 = "";
	if(sBelongAttribute3 == null) sBelongAttribute3 = "";
	
	//确定是否有权限，010：有
	//如果有客户主办权返回Y，否则返回N	
    if(sBelongAttribute.equals("1")) 
        sReturnValue = "Y";
    else 
    	sReturnValue = "N";
        
    //如果有信息查看权返回Y，否则返回N	
    if(sBelongAttribute1.equals("1")) 
        sReturnValue1 = "Y1";
    else 
    	sReturnValue1 = "N1";
    
    //如果有信息维护权返回Y，否则返回N	
    if(sBelongAttribute2.equals("1")) 
        sReturnValue2 = "Y2";
    else 
    	sReturnValue2 = "N2";
    
    //如果有业务申办权返回Y，否则返回N	
    if(sBelongAttribute3.equals("1")) 
        sReturnValue3 = "Y3";
    else 
    	sReturnValue3 = "N3";
        
    sReturn = sReturnValue+"@"+sReturnValue1+"@"+sReturnValue2+"@"+sReturnValue3;

%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "<%=sReturn%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>