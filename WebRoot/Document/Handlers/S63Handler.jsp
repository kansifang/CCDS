<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.util.Date,com.lmt.baseapp.Import.base.*"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*

		 */
	%>
<%
	/*~END~*/
%> 

<%
 	//����ҳ�洫�����
  		String sType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type")));
 		String sConfigNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ConfigNo")));
 		String sKey =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Key")));
  		String sReportDate =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate")));
  		//FileUpload�������
  		String sClearTable =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClearTable")));
  		//FileUpload�������
  		String sFiles =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Files")));
  		//���������SQL��䡢�������
  		String sSql = "",sMessage="";
  		ASResultSet rs=null;
  		HashMap<String, String> mmReplace = new HashMap<String, String>();
  		HashMap<String, String> mmAutoSet = new HashMap<String, String>();
  		PreparedStatement ps1 = null,ps2 = null,ps3 = null,ps4 = null;
  		String sImportTableName="Batch_Import";
  		boolean isAutoCommit=false;
 		try {
 		 	isAutoCommit=Sqlca.conn.getAutoCommit();
 		 	Sqlca.conn.setAutoCommit(false);
 		 	Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and Key='"+sKey+"'");
 		 	//�����ļ�
 		 	EntranceImpl efih=new ExcelBigEntrance(sFiles,sImportTableName,CurUser,Sqlca);
 		 	efih.action(sConfigNo,sKey);
 	 		//�������úźͱ�������
 	 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 	 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and Key='"+sKey+"' and ImportNo like 'N%000000'");
 	 		//�����������Ӷ�ͱ���
  		}catch (Exception e) {
 		 	sMessage=e.getMessage(); 	
 		 	out.println("An error occurs : " + e.toString());
 		 	sMessage="false";
 		 	e.printStackTrace();
 		 	Sqlca.conn.rollback();
 		 	throw e;
 		}finally{
 	 		Sqlca.conn.setAutoCommit(isAutoCommit);
 	 	}
 %>
<script language=javascript>
	self.returnValue = "<%=sMessage%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>