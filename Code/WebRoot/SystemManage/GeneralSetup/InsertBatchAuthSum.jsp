<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: zwhu
 * Tester:
 *
 * Content: 设置授权
 * Input Param:
 *			
 *
 * History Log:
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>更新授权</title>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window.open
	
	String	sOrgIDArr = DataConvert.toRealString(iPostChange,(String)request.getParameter("OrgIDArr"));
	String	sBusinessTypeArr = DataConvert.toRealString(iPostChange,(String)request.getParameter("BusinessTypeArr"));
	String	sRoleIDArr = DataConvert.toRealString(iPostChange,(String)request.getParameter("RoleIDArr"));
	String  sSetUnit = DataConvert.toRealString(iPostChange,(String)request.getParameter("SetUnit"));

	if (sOrgIDArr == null) sOrgIDArr="";
	if (sBusinessTypeArr == null) sBusinessTypeArr = "";
	if (sRoleIDArr == null) sRoleIDArr = "";
	if (sSetUnit == null) sSetUnit = "";
	
	String[] sOrgIDArrs = sOrgIDArr.split(",");
	String[] sBusinessTypeArrs = sBusinessTypeArr.split(",");
	String[] sSetUnits = sSetUnit.split(",");
	int insertItems = 0;
	for(int i=0;i<sOrgIDArrs.length;i++){
		for(int j=0;j<sBusinessTypeArrs.length;j++){
			String sSerialNo1 = Sqlca.getString(" select SerialNo from Org_Auth where orgid = "+sOrgIDArrs[i]+
											    " and businesstype="+sBusinessTypeArrs[j]+" and roleid = "+sRoleIDArr);
			if(sSerialNo1 != null || "".equals(sSerialNo1))
				continue;							    
			String sSerialNo = DBFunction.getSerialNo("ORG_AUTH","SerialNo","OA",Sqlca); 
			String sSql = " insert into Org_Auth(serialno,OrgID,BusinessType,RoleID,AuthSum1,AuthSum2,"+
						  " AuthSum3,AuthSum4,AuthSum5,AuthSum6,AuthSum7,InputOrgID,InputUserID,InputDate,UpdateDate)"+ 
			  			  " values('"+sSerialNo+"',"+sOrgIDArrs[i]+","+sBusinessTypeArrs[j]+","+sRoleIDArr+",";
			for(int k=0;k<sSetUnits.length;k++){
				sSql += sSetUnits[k]+",";
			}
			sSql += "'"+CurUser.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			//System.out.println(sSql);
			insertItems = Sqlca.executeSQL(sSql);
		}
	}
	
%>

<script language=javascript>
	self.returnValue = "<%=insertItems%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
