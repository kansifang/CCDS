<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:  ndeng 2005.03.15
 * Tester:
 *
 * Content: Ч��������û�����Ƿ��ظ�
 * Input Param: 
 * 			 UserID��      ����ѡ�û����롣
 * Output param:
 *
 *
 * History Log:  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%  
    String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
    
    
    //�ж�user_info���Ƿ��Ժ�ǰ���û����
    String sSql = "Update FLOW_TASK set EndTime='"+StringFunction.getToday()+"' where SerialNo='"+sSerialNo+"'";
	Sqlca.executeSQL(sSql);	

%>
<script language=javascript>
	
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>


