<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  hxli 2004.02.19
 * Tester:
 *
 * Content: ת�ƺ�ͬ����̨�����ݿ�Ĳ�����
 * Input Param:
 * 			 UserID:���ܿͻ�����
 *           OrgID:���ܻ���
 *           SerialNo:��ͬ���
 * Output param:
 *
 * History Log:
 *  		gecg 2005.3.01	 �޸�ҳ��
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
    //��ȡ������ת�ƺ�ͬ��ת��ǰ�������롢ת��ǰ�������ơ�ת��ǰ�ͻ�������롢ת��ǰ�ͻ��������ơ�ת�ƺ�ͻ�������롢ת�ƺ�ͻ���������
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));		
	String sToOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgID"));
	String sToOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgName"));

	//ת������
	String sInputDate   = StringFunction.getToday();	
	//ת����־��Ϣ
	String sChangeReason = "ҵ�����˻������Ӳ�����Ա����:"+CurUser.UserID+"   ������"+CurUser.UserName+"   �������룺"+CurOrg.OrgID+"   �������ƣ�"+CurOrg.OrgName;
	String sSql = "",sFlag = "";
	//������ʼ	
	boolean bOld = Sqlca.conn.getAutoCommit();
	Sqlca.conn.setAutoCommit(false);
	try{
		//��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
	    String sSerialNo1 =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
	    sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
	    		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
	            " VALUES('BusinessContract','"+sSerialNo+"','"+sSerialNo1+"','"+sFromOrgID+"','"+sFromOrgName+"','"+sToOrgID+"', "+
	            " '"+sToOrgName+"','','','','','"+sChangeReason+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
	    Sqlca.executeSQL(sSql);

	    //�����ͬ�����˻���
		sSql = " update BUSINESS_CONTRACT set StatOrgID='"+sToOrgID+"' where "+
			   " SerialNo = '"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);	
						
		sFlag = "TRUE";
		
		//�����ύ
	    Sqlca.conn.commit();
	    Sqlca.conn.setAutoCommit(bOld);
	}catch(Exception e)
	{
		sFlag = "FALSE";
		//����ʧ�ܻع�
	    Sqlca.conn.rollback();
	    Sqlca.conn.setAutoCommit(bOld);
		throw new Exception("��ͬת�ƴ���ʧ�ܣ�"+e.getMessage());
	}
%>

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>