<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   hxli 2005-8-17
 * Tester:
 *
 * Content:   �������ҵ��ת�ƶ���
 * Input Param:
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//��ȡҳ�����
	String sSerialNo    = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 
	String sLineID      = DataConvert.toRealString(iPostChange,CurPage.getParameter("LineID"));
	//����ֵת��Ϊ���ַ���	
	if(sSerialNo==null) sSerialNo="";
	if(sLineID==null) sLineID="";
	
	//�������
	String sSql="";
	String sSerialNo1[]=sSerialNo.split(",");
	
	boolean bOld = Sqlca.conn.getAutoCommit(); 
	Sqlca.conn.setAutoCommit(false);
	try
	{	
		for(int m=0;m<sSerialNo1.length;m++)
		{
			sSql=" UPDATE BUSINESS_CONTRACT  SET CreditAggreement='"+sLineID+"'  WHERE  SerialNo='"+sSerialNo1[m]+"'";
			Sqlca.executeSQL(sSql);
		}
	
		//�����ύ
		Sqlca.conn.commit();
		Sqlca.conn.setAutoCommit(bOld);
		%>
        <script language=javascript>	
            alert(getBusinessMessage('412'));//ҵ�������ϵ�ɹ�ת�ƣ�
        </script>	
        <%
	}
	catch(Exception e)
	{
		//����ʧ�ܣ����ݻع�
		Sqlca.conn.rollback();
		Sqlca.conn.setAutoCommit(bOld);
		throw new Exception("������ʧ�ܣ�"+e.getMessage());
	}
%>

<script language=javascript>
        parent.close();   
</script>
<%@ include file="/IncludeEnd.jsp"%>
