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
 		String sReportType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportType")));
 		String sReportDate =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate")));
 		//FileUpload�������
 		String sClearTable =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClearTable")));
 		String sFiles =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("File")));
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
		 	//�����ļ�
		 	 ExcelImport efih=new ExcelImport(sImportTableName,Sqlca,sFiles,CurUser);
		 	efih.action();
		 	//�����ļ�
		 	if(sType.equals("1")){//��������
		 		if("true".equals(sClearTable)){
		 			Sqlca.executeSQL("truncate table Impawn_Total_Import ");
		 		}
		 		//��ֵ���ε�Batch_Case
		 		//���ݴ�����
		 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
		 		Sqlca.executeSQL("update "+sImportTableName+" set ReportType='"+sReportType+"',ReportDate='"+sReportDate+"' where ImportNo like 'N"+CurUser.UserID+"%000000'");
		 	}else if(sType.equals("2")){//��������
		 		if("true".equals(sClearTable)){
		 			Sqlca.executeSQL("truncate table Business_PutOut_Import ");
		 			Sqlca.executeSQL("truncate table Business_PutOut_Temp ");
		 		}
		 		//ֻ���°�
		 		sSql="select "+
		 			"DueNo,"+
		 			"LCustomerName,"+
		 			"LDate,"+
		 			"LSum,"+	
		 			"DCustomerName,"+
		 			"ID,"+
		 			"CardNo,"+
		 			"PayBackSum,"+
		 			"PayBackDate,"+
		 			"Balance"+	
		 			" from Batch_Case_Import "+
		 			" where Batch_Case_Import.DueNo=Batch_Case.DueNo"+
		 			" and ImportNo like 'N"+CurUser.UserID+"%000000'";
		 		String updateSql="update Batch_Case set ("+
		 				"DueNo,"+
		 				"LCustomerName,"+
		 				"LDate,"+
		 				"LSum,"+	
		 				"DCustomerName,"+
		 				"ID,"+
		 				"CardNo,"+
		 				"PayBackSum,"+
		 				"PayBackDate,"+
		 				"Balance)="+
		 				"("+sSql+")"+
		 				"where  BatchNo='"+sReportType+"'"+
		 				" and exists(select 1 from Batch_Case_Import "+
		 				" where Batch_Case_Import.DueNo=Batch_Case.DueNo"+
		 				" and ImportNo like 'N"+CurUser.UserID+"%000000')";
		 		Sqlca.executeSQL(updateSql);
		 	}
		 	//���ݴ��������°�����
		 	//��ս�������εı���
		 	Sqlca.executeSQL("Delete from Batch_Case_History where InputDate='"+StringFunction.getToday()+"' and BatchNo='"+sReportType+"'");
		 	//���ݴ�����
		 	sSql="select '"+StringFunction.getToday()+"',"+
		 			"BatchNo,"+
		 			"SerialNo,"+
		 			"DueNo,"+
		 			"LCustomerName,"+
		 			"LDate,"+
		 			"LSum,"+	
		 			"DCustomerName,"+
		 			"ID,"+
		 			"CardNo,"+
		 			"PayBackSum,"+
		 			"PayBackDate,"+
		 			"Balance"+	
		 			" from Batch_Case "+
		 			" where BatchNo = '"+sReportType+"'";
		 	String insertSql="insert into Batch_Case_History ("+
		 				"InputDate,"+
		 				"BatchNo,"+
		 				"SerialNo,"+
		 				"DueNo,"+
		 				"LCustomerName,"+
		 				"LDate,"+
		 				"LSum,"+	
		 				"DCustomerName,"+
		 				"ID,"+
		 				"CardNo,"+
		 				"PayBackSum,"+
		 				"PayBackDate,"+
		 				"Balance)"+
		 				"("+sSql+")";
		 	Sqlca.executeSQL(insertSql);
		 	Sqlca.conn.commit();
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