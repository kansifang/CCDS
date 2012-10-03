<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
String sUserSelected = CurPage.getParameter("UserSelected",10);
String sAlertIDString = CurPage.getParameter("AlertIDString",10);
String sRequirement = CurPage.getParameter("Requirement");

if(sUserSelected==null || sUserSelected.equals("")){
	throw new Exception("没有接收到分发目标用户(sUserSelected)");
}
if(sAlertIDString==null || sAlertIDString.equals("")){
	throw new Exception("没有接收到警示ID(AlertID)");
}
if(sRequirement==null || sRequirement.equals("")){
	throw new Exception("没有接收到警示处理要求(sRequirement)");
}

try{
	if(sUserSelected!=null && !sUserSelected.equals("")){
		StringTokenizer	st = new StringTokenizer(sUserSelected,"@");//分隔
		while(st.hasMoreTokens()){
			String sUserID = st.nextToken();//取下一个
			if(sUserID==null||sUserID.equals("")) continue;

			StringTokenizer	st1 = new StringTokenizer(sAlertIDString,"@");//分隔
			while(st1.hasMoreTokens()){
				String sAlertID = st1.nextToken();//取下一个
				if(sAlertID==null||sAlertID.equals("")) continue;

				String sHandleNo = DBFunction.getSerialNo("ALERT_HANDLE","HandleNo",Sqlca);
				String sSql = "insert into ALERT_HANDLE(SerialNo,HandleNo,UserID,Requirement) values('"+sAlertID+"','"+sHandleNo+"','"+sUserID+"','"+sRequirement+"')";
				out.println(sSql);
				Sqlca.executeSQL(sSql);
			}
		}
	}
	%>
	<script>top.returnValue="succeeded";self.close();</script>
	<%
}catch(Exception ex){
	out.println(ex.toString());
	%><script>top.returnValue="failed";</script><%
}
%>


<%@ include file="/IncludeEnd.jsp"%>
