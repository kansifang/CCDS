<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.8
		Tester:
		Content: 置补登完成标志
		Input Param:
			                SerialNo:分类流水号
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>检查客户信息</title>
<%
	String sSql;
	String sSql1;
	String sSerialNo="";	
	ASResultSet rs = null;
	int sCount=0;

	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	
	//补登菜单标志sFlag=Y表示从不良资产补登进入，否则表示从信贷补登进入
	String sFlag = DataConvert.toRealString(iPostChange,(String)request.getParameter("Flag"));
	if(sFlag==null) sFlag="";
	
	//补登标志sReinforceFlag表示从不同的列表进入
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)request.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="";
	
	//再次补登标志
	String sSecondFlag = DataConvert.toRealString(iPostChange,(String)request.getParameter("Flag1"));
	if(sSecondFlag==null) sSecondFlag="";	
	
	
	
	if(sFlag.equals("Y")) //不良资产进入补登
	{
		if(sSecondFlag.equals("")) //补登完成
		 {
			if(sReinforceFlag.equals("010")) //新增补登业务
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '020',RecoveryOrgID='"+CurOrg.OrgID+"' where SerialNo = '"+sSerialNo+"'";
			}else
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '120',RecoveryOrgID='"+CurOrg.OrgID+"' where SerialNo = '"+sSerialNo+"'";

			}

			Sqlca.executeSQL(sSql);
		
%>			
			<script language=javascript>
				self.returnValue = "succeed";
				self.close();
			</script>
<%
		 }
		 else	//再次补登
		 {
		 	
		 	sSql1 = " select count(*) from business_contract where SerialNo = '"+sSerialNo+"' and (RecoveryUserID is not null)";
		 	rs = Sqlca.getASResultSet(sSql1); 
   			if(rs.next())
   			sCount = rs.getInt(1);
			rs.getStatement().close();
		 	
		 	if(sCount<=0)
		 	{
			 	
			 	if(sReinforceFlag.equals("020")) //补登完成业务
				{
					sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '010',RecoveryOrgID=null where SerialNo = '"+sSerialNo+"'";
				}else
				{
					sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '110',RecoveryOrgID=null where SerialNo = '"+sSerialNo+"'";
	
				}
				
				Sqlca.executeSQL(sSql);
%>			
				<script language=javascript>
					self.returnValue = "true";
					self.close();
				</script>
<%				
			}else
			{
%>			
				<script language=javascript>
					self.returnValue = "false";
					self.close();
				</script>
<%		
			}
		 }
	}else
	{
		if(sSecondFlag.equals("")) //补登完成
		{
			
			if(sReinforceFlag.equals("010")) //需补登业务
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '020' where SerialNo = '"+sSerialNo+"'";
			}else   //新增业务
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '120' where SerialNo = '"+sSerialNo+"'";

			}
			
			Sqlca.executeSQL(sSql);
			
%>			
			<script language=javascript>
				self.returnValue = "succeed";
				self.close();
			</script>
<%
		}else	//再次补登
		{
			
			if(sReinforceFlag.equals("020")) //补登业务
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '010' where SerialNo = '"+sSerialNo+"'";
			}else	//新增业务
			{
				sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '110' where SerialNo = '"+sSerialNo+"'";

			}
			Sqlca.executeSQL(sSql);
%>			
			<script language=javascript>
				self.returnValue = "true";
				self.close();
			</script>
<%
		}
	}		
%>

<%@ include file="/IncludeEnd.jsp"%>