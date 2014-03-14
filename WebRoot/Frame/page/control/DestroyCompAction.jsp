<%@page contentType="text/html; charset=GBK"%>
<%@page buffer="64kb" errorPage="/Frame/page/control/ErrorPage.jsp"%>
<%@page import="com.amarsoft.web.*"%>
<%@page import="com.amarsoft.are.ARE"%><%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	try
	{
		ASRuntimeContext CurARC= (ASRuntimeContext)session.getAttribute("CurARC");
		if(CurARC != null)  {
			String sToDestroyClientID = com.amarsoft.are.util.DataConvert.toRealString(5,(String)request.getParameter("ToDestroyClientID"));
			ASComponentSession CurCompSession = CurARC.getCompSession();
			if(sToDestroyClientID!=null) 
			{
				ARE.getLog().debug("...destroy..."+sToDestroyClientID);
				CurCompSession.lookUpAndDestroy(sToDestroyClientID,session);
			}
		}
	}
	catch(Exception e)
	{	
		e.printStackTrace();
		ARE.getLog().error(e.getMessage(),e);
	}
%>