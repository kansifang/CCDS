<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: FSGong 2004-12-30
 * Tester:
 * Content: 
 *��Business_Apply��ɾ��һ�������¼֮�󣬱���ɾ�����������������Ϣ��
 * Input Param:
 *		  
 *  
 * Output param:
 *		��	
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	
	//������ˮ�š����������
	String 	sSerialNo		= DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String 	sObjectType	= DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	
	//���̱��
	String	sFlowNo		= DataConvert.toRealString(iPostChange,(String)request.getParameter("FlowNo"));
	
	ASResultSet               rs;

	boolean bOldTransaction = Sqlca.conn.getAutoCommit(); 
	try 
		{
			//���������δ�ύ���������ύ��
			if(!bOldTransaction) Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(false);

			//ɾ��FLOW_TASK����������ݣ�ɾ������������ʷ��
			String	sSql1 = " Delete from FLOW_TASK  where FlowNo='"+sFlowNo+"' and ObjectNo='"+sSerialNo+"'";
			Sqlca.executeSQL(sSql1);

			//ɾ��FLOW_OBJECT����������ݣ�ɾ�����̵�ǰ���е㡣
			String	sSql2 = " Delete from Flow_Object where ObjectType='"+sObjectType+"' and ObjectNo='"+sSerialNo+"'";
			Sqlca.executeSQL(sSql2);  				
			
			//ɾ��APPLY_RELATIVE�еĹ�����¼��SerialNoΪ�����š�ObjectNoΪ��ͬ��š�
			String	sSql3 = " Delete from Apply_Relative where ObjectType='BusinessContract'  and  SerialNo='"+sSerialNo+"'";
			Sqlca.executeSQL(sSql3);  

			//ɾ��Business_Apply�����������
			String	sSql4= " Delete from Business_Apply where SerialNo='"+sSerialNo+"'";
			Sqlca.executeSQL(sSql4);  			


			//�ύ�Զ�������
			Sqlca.conn.commit();
			//�ָ�ϵͳ����
			Sqlca.conn.setAutoCommit(bOldTransaction);
		}
		catch(Exception e)
		{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bOldTransaction);
			throw new Exception("������ʧ�ܣ�"+e.getMessage());
		}		
%>

<script language=javascript>
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>