<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  hxli 2004.02.19
 * Tester:
 *
 * Content: ������ҵ��ת��Ȩ����̨�����ݿ�Ĳ�����
 * Input Param:
 * 			 SerialNo����ͬ���
 *           FromOrgID��ת��ǰ��������
 *           FromOrgName��ת��ǰ��������
 * 			 FromUserID��ת��ǰ�ͻ��������
 *           FromUserName��ת��ǰ�ͻ���������
 *           ToUserID��ת�ƺ�ͻ��������
 * 			 ToUserName��ת�ƺ�ͻ���������
 * Output param:
 *
 * History Log:
 *  		zywei 2005.8.16	 �޸�ҳ��
 */%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//��ȡ������ת�ƺ�ͬ��ת��ǰ�������롢ת��ǰ�������ơ�ת��ǰ�ͻ�������롢ת��ǰ�ͻ��������ơ�ת�ƺ�ͻ�������롢ת�ƺ�ͻ���������
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));
	String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserID"));
	String sFromUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserName"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));
	String sToUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserName"));

	//ת�ƺ�������������
	String sToOrgID = "",sToOrgName = "";	
	String sInputDate   = StringFunction.getToday();
	//ת����־��Ϣ
	String sChangeReason = "������ҵ��ת��Ȩ������Ա����:"+CurUser.UserID+"   ������"+CurUser.UserName+"   �������룺"+CurOrg.OrgID+"   �������ƣ�"+CurOrg.OrgName;
	//SQL��䡢�Ƿ�ɹ���־
	String sSql = "",sFlag = "";
	//��ѯ�����
	ASResultSet rs = null;
   
	//��ѯ���Ӻ�ͻ��������ڻ������������
    sSql =  " select BelongOrg,getOrgName(BelongOrg) as BelongOrgName "+
        	" from USER_INFO " +
        	" where UserID = '"+sToUserID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
	    sToOrgID = DataConvert.toString(rs.getString("BelongOrg"));
	    sToOrgName = DataConvert.toString(rs.getString("BelongOrgName"));
	}
	rs.getStatement().close();

	//������ʼ	
    boolean bOld = Sqlca.conn.getAutoCommit();
    Sqlca.conn.setAutoCommit(false);
	try{
		//��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
        String sSerialNo1 =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
        		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
                " VALUES('FlowTask','"+sSerialNo+"','"+sSerialNo1+"','"+sFromOrgID+"','"+sFromOrgName+"','"+sToOrgID+"', "+
                " '"+sToOrgName+"','"+sFromUserID+"','"+sFromUserName+"','"+sToUserID+"','"+sToUserName+"','"+sChangeReason+"', "+
                " '"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
        Sqlca.executeSQL(sSql);

        //�����ͬ�Ĺܻ��˺ͻ���
		sSql = " update FLOW_TASK set OrgID='"+sToOrgID+"',OrgName='"+sToOrgName+"',UserID='"+sToUserID+"',UserName='"+sToUserName+"' where "+
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
		throw new Exception("������ҵ��ת��Ȩ����ʧ�ܣ�"+e.getMessage());
	}
%>

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>