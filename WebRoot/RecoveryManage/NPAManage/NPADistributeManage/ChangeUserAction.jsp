<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   XWu 2004-12-06
 * Tester:
 *
 * Content: ���ĺ�ͬ�����ʲ��Ĺ����������Ա
 * Global Param:
 *	
 *	
 * 
 * Input Param:
 *	SerialNo	����ͬ��ˮ��
 *	sRecoveryOrgID  ����ȫ��������
 *	sRecoveryUser   �������ʲ�������
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
	String sSerialNo = DataConvert.toRealString(iPostChange,request.getParameter("SerialNo")); //��ͬ��ˮ��	
	String sRecoveryOrgID = DataConvert.toRealString(iPostChange,request.getParameter("RecoveryOrgID")); //��ȫ��������	
	String sRecoveryUser = DataConvert.toRealString(iPostChange,request.getParameter("RecoveryUserID")); //�����ʲ�������
	String sObjectType = DataConvert.toRealString(iPostChange,request.getParameter("ObjectType")); //��������
    String sSql = "";
	if(sObjectType.equals("BadBizAsset"))//��ծ�ʲ������˱��
	{
		sSql =" UPDATE BADBIZ_APPLY "+
		        " SET ManageOrgID='"+sRecoveryOrgID+"', "+
		        " ManageUserID='"+sRecoveryUser+"' "+
		        " WHERE  SerialNo='" + sSerialNo + "'";   
	}else//��ͬ�����˱��
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
