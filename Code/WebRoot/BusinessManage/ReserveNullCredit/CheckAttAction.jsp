<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-15
 * Tester:
 *
 * Content: ���¼��Ԥ���ֽ���ǰ���������ϴ�����
 * Input Param:
 *         
 * Output param:
 *          00-�и���
 *          
 *          01-ȱ�ٸ���
 *          02-���ݿ����
 * History Log:

 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sReturnValue="00";
	if(sObjectNo==null) sObjectNo = "";
	try
	{
      //�鿴�Ƿ��й����׸�
      
	    String sSelSql = " select count(*) from DOC_ATTACHMENT1 DA "+
			    " where  DA.DOCno = '"+sObjectNo+"' ";
		  ASResultSet rs = Sqlca.getASResultSet(sSelSql);
		  if(rs.next()){
			  if(rs.getInt(1)==0) sReturnValue = "01";
		  }
		  rs.getStatement().close();
    }catch(Exception ex){
	    sReturnValue = "02";
		System.out.println(ex.getMessage());
	}
%>
<script language=javascript>
    self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>