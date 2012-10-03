<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: 客户信息检查
		Input Param:
			CustomerType：客户类型
					01：公司客户；
					0201：一类集团客户；
					0202：二类集团客户（系统暂时不用）；
					03：个人客户；
			CustomerName:客户名称
			CertType:客户证件类型
			CertID:客户证件号码
		Output param:
  			ReturnStatus:返回状态
				01为无该客户
				02为当前用户以与该客户建立关联
				04为当前用户没有与该客户建立关联,且没有和任何客户建立主办权.
				05为当前用户没有与该客户建立关联,且有和其他客户建立主办权.
		History Log: 			
			2005/09/10 重检代码
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>检查客户信息</title>
<%
	//定义变量：Sql语句、返回信息、客户代码、主办权
	String sSql = "",sReturnStatus = "",sCustomerID = "",sBelongAttribute = "";	
	//定义变量：计数器
	int iCount = 0;
	//定义变量：查询结果集
	ASResultSet rs = null;
	
	//获取页面参数：客户类型、客户名称、证件类型、证件编号
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));	
	String sCertType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertType"));
	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));	
	//将空值转化为空字符串
	if(sCustomerType == null) sCustomerType = "";
	if(sCustomerName == null) sCustomerName = "";
	if(sCertType == null) sCertType = "";
	if(sCertID == null) sCertID = "";
	
	//非关联集团客户需通过证件类型、证件号码检查是否在CI表中存在信息	
	if(!sCustomerType.substring(0,2).equals("02")&&!sCustomerType.equals("0401")&&!sCustomerType.equals("0501"))		
		sSql = 	" select CustomerID "+
				" from CUSTOMER_INFO "+
				" where CertType = '"+sCertType+"' "+
				" and CertID = '"+sCertID+"' "+
				" and (CustomerID is not null and CustomerID <>'')";
	else //关联集团客户通过客户名称检查是否在CI表中存在信息
		sSql = 	" select CustomerID "+
				" from CUSTOMER_INFO "+
				" where CustomerName = '"+sCustomerName+"' "+
				" and CustomerType = '"+sCustomerType+"' ";
	sCustomerID = Sqlca.getString(sSql);
	if(sCustomerID == null) sCustomerID = "";
	
	if(sCustomerID.equals(""))
	{
		//无该客户
		sReturnStatus = "01";
	}else
	{
		//得到当前用户与该客户之间管户关系
		sSql = 	" select count(CustomerID) "+
				" from CUSTOMER_BELONG "+
				" where CustomerID = '"+sCustomerID+"' "+
				" and UserID = '"+CurUser.UserID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		   	iCount = rs.getInt(1);

		rs.getStatement().close(); 
		
		if(iCount > 0)
		{
  			//02为当前用户以与该客户建立有效关联
 			sReturnStatus = "02";
		}else
		{
			//检查该客户是否有管户人
			sSql = 	" select count(CustomerID) "+
					" from CUSTOMER_BELONG "+
					" where CustomerID = '"+sCustomerID+"' "+
					" and BelongAttribute = '1'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			   	iCount = rs.getInt(1);
	
			rs.getStatement().close(); 
			
			if(iCount > 0)
			{
  				//05为当前用户没有与该客户建立关联,且有和客户建立主办权.
				sReturnStatus = "05";
			}else
			{
  				//04为当前用户没有与该客户建立关联,且没有和任何客户建立主办权.
				sReturnStatus = "04";
			}
		}
	}		
	
%>
<script language=javascript>
	//返回检查状态值和客户号
	self.returnValue = "<%=sReturnStatus%>"+"@"+"<%=sCustomerID%>";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>