<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
String sUserSelected = CurPage.getParameter("UserSelected",10);
String sAlertIDString = CurPage.getParameter("AlertIDString",10);
String sRequirement = CurPage.getParameter("Requirement");

if(sUserSelected==null || sUserSelected.equals("")){
	throw new Exception("û�н��յ��ַ�Ŀ���û�(sUserSelected)");
}
if(sAlertIDString==null || sAlertIDString.equals("")){
	throw new Exception("û�н��յ���ʾID(AlertID)");
}
if(sRequirement==null || sRequirement.equals("")){
	throw new Exception("û�н��յ���ʾ����Ҫ��(sRequirement)");
}

try{
	if(sUserSelected!=null && !sUserSelected.equals("")){
		StringTokenizer	st = new StringTokenizer(sUserSelected,"@");//�ָ�
		while(st.hasMoreTokens()){
			String sUserID = st.nextToken();//ȡ��һ��
			if(sUserID==null||sUserID.equals("")) continue;

			StringTokenizer	st1 = new StringTokenizer(sAlertIDString,"@");//�ָ�
			while(st1.hasMoreTokens()){
				String sAlertID = st1.nextToken();//ȡ��һ��
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
