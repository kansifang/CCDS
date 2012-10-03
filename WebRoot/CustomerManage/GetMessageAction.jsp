<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  cchang  2004.12.2
		Tester:
		Content: --权限申请弹出页面
		Input Param:
			  CustomerID  ：--客户号
		Output param:
			               
		History Log: 
		   DATE	    CHANGER		CONTENT
		   2005.7.27 fbkang     修改新的版本      
		
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
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window.open
	//获取表名、列名和格式
	//定义变量	
	String  sSql = "";//--存放sql语句	
	String  sSuperiorOrgID = "";//--存放上级金融机构代码
	String  sSuperiorOrgName = "";//--存放上级金融机构名称
	String  sMessage = "";//--存放信息
	ASResultSet rs = null;//--存放结果集
	//获取页面参数
	String	sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	//获取组件参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获取变量值;]~*/%>
<%
//modify by xhyong 2009/08/18 客户权限申请提交到总行
/*~
	//获取当前机构的上级机构
	sSql = 	" select OI.RelativeOrgID as SuperiorOrgID,getOrgName(OI.RelativeOrgID) as SuperiorOrgName "+
			" from ORG_INFO OI"+
			" where OI.OrgID = '"+CurOrg.OrgID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sSuperiorOrgID = rs.getString("SuperiorOrgID");
		sSuperiorOrgName = rs.getString("SuperiorOrgName");	
	}
	rs.getStatement().close();
~*/
	//  10--直属支行客户权限管理员  20--中心支行客户权限管理员 30--总行客户权限管理员 
	String sSql1 = "select OrgFlag from org_info where orgid = '"+CurOrg.OrgID+"'";
	String sOrgFlag = Sqlca.getString(sSql1);
	if (CurUser.hasRole("080")||"030".equals(sOrgFlag)){  //集团客户部,直属支行
		String sSql3 = " select OrgFlag from org_info where orgid in(select orgid from customer_belong where customerid = '"+sCustomerID+"' and belongattribute='1' fetch first 1 rows only) ";
		String sOrgFlag3 = Sqlca.getString(sSql3);
		if("030".equals(sOrgFlag3)&&!CurUser.hasRole("080"))//直属支行之间客户权限交接给直属支行管户权审批人
		{
			sSuperiorOrgID = "9900";
			sSuperiorOrgName = "总行";
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '10' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
	
		}else
		{
			sSuperiorOrgID = "9900";
			sSuperiorOrgName = "总行";
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '30' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		}
	}else if("010".equals(sOrgFlag))  //2级支行
	{
		String sSql2 = 	" select OI.RelativeOrgID as SuperiorOrgID,getOrgName(OI.RelativeOrgID) as SuperiorOrgName "+
		" from ORG_INFO OI"+
		" where OI.OrgID = '"+CurOrg.OrgID+"' ";
		rs = Sqlca.getASResultSet(sSql2);
		if(rs.next())
		{
			sSuperiorOrgID = rs.getString("SuperiorOrgID");
			sSuperiorOrgName = rs.getString("SuperiorOrgName");	
		}
		rs.close();
		//如果拥有管户权的机构为中心支行则取本机构否则取上级机构
		String sSql3 = " select case when OrgFlag='020' then OrgID else RelativeOrgID end "+
						" from ORG_INFO "+
						" where OrgID in(select orgid from customer_belong where customerid = '"+sCustomerID+"' and belongattribute='1') ";
		String sOrgID = Sqlca.getString(sSql3);
		if(CurOrg.RelativeOrgID.equals(sOrgID))
		{
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '20' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		}else
		{	
			sSuperiorOrgID = "9900";
			sSuperiorOrgName = "总行";
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '30' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		}
	}else if("020".equals(sOrgFlag)||"040".equals(sOrgFlag))//中心支行
	{
		String sSql2 = 	" select OrgID as SuperiorOrgID,OrgName as SuperiorOrgName "+
		" from ORG_INFO OI"+
		" where OI.OrgID = '"+CurOrg.OrgID+"' ";
		rs = Sqlca.getASResultSet(sSql2);
		if(rs.next())
		{
			sSuperiorOrgID = rs.getString("SuperiorOrgID");
			sSuperiorOrgName = rs.getString("SuperiorOrgName");	
		}
		rs.close();
		String sSql3 = " select RelativeOrgID from ORG_INFO where OrgID in(select orgid from customer_belong where customerid = '"+sCustomerID+"' and belongattribute='1') ";
		String sOrgID = Sqlca.getString(sSql3);
		if(CurOrg.OrgID.equals(sOrgID))
		{
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+CurOrg.OrgID+"',Flag1 = '20' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		}else
		{	
			sSuperiorOrgID = "9900";
			sSuperiorOrgName = "总行";
			Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '30' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		}
	}else 
	{
		sSuperiorOrgID = "9900";
		sSuperiorOrgName = "总行";
		Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"',Flag1 = '30' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		//Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='9900' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
		//sSuperiorOrgName = CurOrg.OrgName;
	}
	//sSuperiorOrgID = "9900";
	//sSuperiorOrgName = "总行";
	//Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"'");
	sMessage = "该客户权限申请消息已经发送到【"+sSuperiorOrgName+"】，请与以上机构的客户权限管理人员进行联络。 ";
	
%>
<%/*~END~*/%>


<script language=javascript>
	self.returnValue = "<%=sMessage%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
