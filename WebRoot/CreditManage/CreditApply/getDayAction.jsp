<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.util.Date" %>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: slliu 2005-03-04
		Tester:
		Describe: �����������֮�������
		Input Param:
			
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%
		//��ͬ�����ա���������
		String sMaturity = DataConvert.toRealString(iPostChange,(String)request.getParameter("Maturity"));
		String sFinishDate = DataConvert.toRealString(iPostChange,(String)request.getParameter("FinishDate"));
				
		java.util.Calendar sDate = java.util.Calendar.getInstance();
		java.util.Calendar eDate = java.util.Calendar.getInstance();
		String tmpDay = "";

		int year;
		int month;
		int day;

		tmpDay = sFinishDate;

		year = Integer.parseInt(tmpDay.substring(0, 4));
		month = Integer.parseInt(tmpDay.substring(5, 7));
		day = Integer.parseInt(tmpDay.substring(8, 10));
		month -= 1;
		sDate.set(year, month, day, 0, 0, 0);

		tmpDay = sMaturity;
		year = Integer.parseInt(tmpDay.substring(0, 4));
		month = Integer.parseInt(tmpDay.substring(5, 7));
		day = Integer.parseInt(tmpDay.substring(8, 10));
		

		month -= 1;
		eDate.set(year, month, day, 0, 0, 0);

		day =
			(int) ((eDate.getTime().getTime() - sDate.getTime().getTime())
				/ 1000
				/ 3600
				/ 24);
		
%>
 <script language=javascript>
	self.returnValue='<%=day%>';
	self.close();
 </script>
<%@	include file="/IncludeEnd.jsp"%>