<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   FSGong  2004-12-15
 * Tester:
 *
 * Content: �����ʲ���Ĺ����������Ա
 * Global Param:
 *	
 *	
 * 
 * Input Param:
 *	SerialNo	��			��ͬ��ˮ��
 *	sRecoveryOrgID  �������˻�����
 *	sRecoveryUser   ��	 ��ծ�ʲ�������
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
	String sSerialNo = DataConvert.toRealString(iPostChange,request.getParameter("SerialNo")); //�ʲ���ˮ��	
	String sManageOrgID = DataConvert.toRealString(iPostChange,request.getParameter("ManageOrgID")); //�����˻�����	
	String sManageUserID = DataConvert.toRealString(iPostChange,request.getParameter("ManageUserID")); //��ծ�ʲ�������

	String sSql= " UPDATE Asset_Info "+" SET ManageOrgID='"+sManageOrgID+"', "+" ManageUserID='"+
						sManageUserID+"' "+" WHERE  SerialNo='" + sSerialNo + "'";
    	
			Sqlca.executeSQL(sSql);
%>

<script language=javascript>
    self.returnValue="true";
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>
