<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   XWu 2004-12-06
 * Tester:
 *
 * Content: 更改合同表不良资产的管理机构及人员
 * Global Param:
 *	
 *	
 * 
 * Input Param:
 *	SerialNo	：合同流水号
 *	sRecoveryOrgID  ：保全部机构号
 *	sRecoveryUser   ：不良资产管理人
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
	String sSerialNo = DataConvert.toRealString(iPostChange,request.getParameter("SerialNo")); //合同流水号	
	String sRecoveryOrgID = DataConvert.toRealString(iPostChange,request.getParameter("RecoveryOrgID")); //保全部机构号	
	String sRecoveryUser = DataConvert.toRealString(iPostChange,request.getParameter("RecoveryUserID")); //不良资产管理人
	String sObjectType = DataConvert.toRealString(iPostChange,request.getParameter("ObjectType")); //更新类型
    String sSql = "";
	if(sObjectType.equals("BadBizAsset"))//抵债资产管理人变更
	{
		sSql =" UPDATE BADBIZ_APPLY "+
		        " SET ManageOrgID='"+sRecoveryOrgID+"', "+
		        " ManageUserID='"+sRecoveryUser+"' "+
		        " WHERE  SerialNo='" + sSerialNo + "'";   
	}else//合同管理人变更
	{
	    sSql =" UPDATE BUSINESS_CONTRACT "+
	           " SET RecoveryOrgID='"+sRecoveryOrgID+"', "+
	           " RecoveryUserID='"+sRecoveryUser+"' "+
	           " WHERE  SerialNo='" + sSerialNo + "'";  
	}

    Sqlca.executeSQL(sSql);
%>

<script language=javascript>
    self.returnValue="true";
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>
