<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   FSGong  2004-12-15
 * Tester:
 *
 * Content: 更改资产表的管理机构及人员
 * Global Param:
 *	
 *	
 * 
 * Input Param:
 *	SerialNo	：			合同流水号
 *	sRecoveryOrgID  ：管理人机构号
 *	sRecoveryUser   ：	 抵债资产管理人
 * Output param:     
 *       
 * History Log:  
 *
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sSerialNo = DataConvert.toRealString(iPostChange,request.getParameter("SerialNo")); //资产流水号	
	String sManageOrgID = DataConvert.toRealString(iPostChange,request.getParameter("ManageOrgID")); //管理人机构号	
	String sManageUserID = DataConvert.toRealString(iPostChange,request.getParameter("ManageUserID")); //抵债资产管理人

	String sSql= " UPDATE Asset_Info "+" SET ManageOrgID='"+sManageOrgID+"', "+" ManageUserID='"+
						sManageUserID+"' "+" WHERE  SerialNo='" + sSerialNo + "'";
    	
			Sqlca.executeSQL(sSql);
%>

<script language=javascript>
    self.returnValue="true";
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>
