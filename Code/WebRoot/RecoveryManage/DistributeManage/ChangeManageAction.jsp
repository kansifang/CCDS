<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xhyong 2010/06/20
 * Tester:
 *
 * Content:  ��������¼
 * Input Param:
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%  
	//������,��������,ԭ����,ԭ������,�»���,�¹�����
	String sObjectNo = DataConvert.toRealString(iPostChange,request.getParameter("ObjectNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,request.getParameter("ObjectType")); 
	String sOldOrgID = DataConvert.toRealString(iPostChange,request.getParameter("OldOrgID")); 
	String sOldUserID = DataConvert.toRealString(iPostChange,request.getParameter("OldUserID")); 
	String sNewOrgID = DataConvert.toRealString(iPostChange,request.getParameter("NewOrgID")); 
	String sNewUserID = DataConvert.toRealString(iPostChange,request.getParameter("NewUserID"));
	if(sObjectNo == null) sObjectNo="";
	if(sObjectType == null) sObjectType="";
	if(sOldOrgID == null) sOldOrgID="";
	if(sOldUserID == null) sOldUserID="";
	if(sNewOrgID == null) sNewOrgID="";
	if(sNewUserID == null) sNewUserID="";
	String sSql = "";
		
	try 
		{
			//��MANAGE_CHANGE��������
			String sSerialNo = DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo",Sqlca);
			sSql= " Insert into MANAGE_CHANGE(SerialNo,ObjectNo,ObjectType,OldOrgID,OldUserID,NewOrgID,NewUserID,ChangeOrgID,ChangeUserID,ChangeTime) "+
			       " Values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sOldOrgID+"','"+sOldUserID+"','"+sNewOrgID+"','"+sNewUserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+ StringFunction.getToday() + "') ";
			Sqlca.executeSQL(sSql);
		 	//�����ύ
			Sqlca.conn.commit();
		}catch(Exception e)
		{
			Sqlca.conn.rollback();
			throw new Exception("������ʧ�ܣ�"+e.getMessage());
		}
%>

<script language=javascript>
    self.returnValue="true";
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>
