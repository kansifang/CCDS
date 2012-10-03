<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-3
		Tester:
		Describe:
			检查关联关系情况，主要是检查关联关系的主键重复问题，在新插入关联关系的时候被调用
			对于集团成员关系，主要成员只能有一个（主体成员关系代码0401）

		Input Param:
			CustomerID: 客户编号
			RelationShip: 关联关系
			CertType: 证件类型
			CertID:证件号码
		Output Param:
			Message: 返回关联客户编号RelativeID 如果为空则表示检查不通过,并提示消息
		HistoryLog: pliu 2011-11-28
	*/
	%>
<%/*~END~*/%>

<%
	//获取页面参数
	String sCustomerID   = DataConvert.toRealString(iPostChange,CurPage.getParameter("CustomerID"));
	String sRelationShip = DataConvert.toRealString(iPostChange,CurPage.getParameter("RelationShip"));
	String sCertType     = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertType"));
	String sCertID       = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertID"));
	
	//定义变量
	String sRelativeID = "";
	String sSql = "";
	String sMessage = "";
	String sRelativeRelationShip = "";
	ASResultSet rs = null;
	
	//根据证件类型和证件编号获取客户编号
	sSql = 	" select CustomerID from CUSTOMER_INFO "+
			" where CertType = '"+sCertType+"' "+
			" and CertID = '"+sCertID+"' ";
	rs = Sqlca.getResultSet(sSql);
	if (rs.next()) {
		sRelativeID = rs.getString(1);
		
		//根据客户编号、关联客户编号和关联关系获得关联客户名称
		sSql = 	" select CustomerName from CUSTOMER_RELATIVE "+
				//" where CustomerID = '"+sCustomerID+"' "+
				//" and RelativeID = '"+sRelativeID+"' "+
				" where RelativeID = '"+sRelativeID+"' "+
				" and RelationShip = '"+sRelationShip+"' ";	
		//如果是法人代表亲属关系则该判断看该法人代表配偶是否是当前客户
		if(sRelationShip.startsWith("06"))
		{
			//关联关系转换
			if("0601".equals(sRelationShip))//配偶(法人代表)
			{
				sRelativeRelationShip="0301";
			}else if("0602".equals(sRelationShip))//父母(法人代表)
			{
				sRelativeRelationShip="0302";
			}else if("0603".equals(sRelationShip))//子女(法人代表)
			{
				sRelativeRelationShip="0303";
			}else if("0604".equals(sRelationShip))//其他血亲(法人代表)
			{
				sRelativeRelationShip="0304";
			}else if("0605".equals(sRelationShip))//其他姻亲(法人代表)
			{
				sRelativeRelationShip="0305";
			}
			sSql += " and not exists(select 1 from CUSTOMER_RELATIVE CR1,CUSTOMER_RELATIVE CR2 "+
					" where CR1.RelativeID=CR2.CustomerID "+
					" and CR1.CustomerID=CUSTOMER_RELATIVE.CustomerID "+
					" and CR1.RelationShip='0100' and CR2.RelationShip='"+sRelativeRelationShip+"')";
		}
		//如果是上下游关系,则判断于本客户是否存在关系
		if("99".equals(sRelationShip.substring(0,2)))
		{
			sSql = 	" select CustomerName from CUSTOMER_RELATIVE "+
					" where CustomerID = '"+sCustomerID+"' "+
					" and RelativeID = '"+sRelativeID+"' ";
		}
		ASResultSet rs1 = Sqlca.getResultSet(sSql);		
		if (rs1.next()&&!"52".equals(sRelationShip.substring(0,2)))
		{
			if(!"02".equals(sRelationShip.substring(0,2)))
			{
				sMessage="客户["+rs1.getString("CustomerName")+"]与其他客户已经存在此关系,请选择其他的关系或客户后保存!";
			}
			if("99".equals(sRelationShip.substring(0,2)))
			{
				sMessage="客户["+rs1.getString("CustomerName")+"]与本客户的此关系已经存在,请选择其他的关系或客户后保存!";
			}
			if (sRelationShip.equals("0401"))
				//sMessage="客户["+rs1.getString("CustomerName")+"]已经是该集团的主体成员,一个关联集团只能有一个主体成员,不予保存!";
				sMessage="客户["+rs1.getString("CustomerName")+"]已经是集团的主体成员,一个主体成员只能属于一个集团,不予保存!";
		}
		rs1.getStatement().close();
		
		if (!sMessage.equals("")) sRelativeID = "";
	}else 
	{
		sRelativeID = DBFunction.getSerialNo("CUSTOMER_INFO","CustomerID",Sqlca);
	}
	rs.getStatement().close();	
%>
<script	language=javascript>
	if ("<%=sMessage%>" != "" ) alert("<%=sMessage%>");
	self.returnValue = "<%=sRelativeID%>"
	self.close();
</script>
<%@	include file="/IncludeEnd.jsp"%>