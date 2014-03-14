<%@page contentType="text/html; charset=GBK"%>
<%@page buffer="64kb" errorPage="/ErrorPage.jsp"%>
<%@page import="com.lmt.frameapp.web.*"%>
<%@page import="com.lmt.frameapp.ARE"%>
<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: byhu 2005.6.6
 * Tester:
 *
 * Content: ×é¼þÏú»Ù
 * Input Param:
 * Output param:
 *
 * History Log: 2005.06.06 byhu
 * 
 */
%> 
<%
	try
	{
		ASRuntimeContext CurARC= (ASRuntimeContext)session.getAttribute("CurARC");
		if(session==null && session.isNew()) throw new Exception("------Timeout------");
	
		String sToDestroyClientID = com.lmt.baseapp.util.DataConvert.toRealString(5,(String)request.getParameter("ToDestroyClientID"));
		ASComponentSession CurCompSession = (ASComponentSession)CurARC.getAttribute("CurCompSession");
		if(sToDestroyClientID!=null) 
		{
			ARE.getLog().debug("...destroy..."+sToDestroyClientID);
			CurCompSession.lookUpAndDestroy(sToDestroyClientID,session);
		}
%>
<script language=javascript>
	self.close();
</script>
<%
	}
	catch(Exception e)
	{	
		e.printStackTrace();
		ARE.getLog().error(e.getMessage(),e);
		throw e;
	}
%>