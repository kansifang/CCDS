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

<%	//ע�� ԭʼҳ�����˳���ǣ� FileChooseDialog����>FileUpload����>��ҳ�棬ǰ�������������ԭʼҳ��
 	//����ҳ�洫����� 
 		String sBatchNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BatchNo")));
		String sConfigNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ConfigNo")));
 		String sHandlerType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("HandlerType")));
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
		 	//�����ļ�
		 	 ExcelImport efih=new ExcelImport(sFiles,sConfigNo,sImportTableName,CurUser,Sqlca);
		 	efih.action();
		 	//�����ļ�
		 	if(sHandlerType.equals("1")){//��������
		 		//��ֵ���ε�Batch_Case
		 		//���ݴ�����
		 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
		 		String[]columnArray=Sqlca.getStringArray("select ItemDescribe from code_library where codeNo='"+sConfigNo+"' and IsInuse='1'");
		 		String columns=StringFunction.toArrayString(columnArray, ",");
		 		sSql="select "+
		 				"'"+sBatchNo+"',"+
		 				"'"+sBatchNo+"'||ImportIndex,"+
		 				columns+
		 				" from Batch_Import "+
		 				" where ImportNo like 'N"+CurUser.UserID+"%000000' and ConfigNo='"+sConfigNo+"'";
		 		String insertSql="insert into Batch_Case("+
		 					"BatchNo,"+
		 					"SerialNo,"+
		 					"DueNo,"+
		 					"LCustomerName,"+
		 					"LDate,"+
		 					"LSum,"+	
		 					"ID)"+
		 					"("+sSql+")";
		 		Sqlca.executeSQL(insertSql);
		 		//���������Դ������ٴε��룬���Էϵ������������µ���
		 		Sqlca.executeSQL("update Batch_Info set ImportFlag='1' where BatchNo='"+sBatchNo+"'");
		 	}else if(sHandlerType.equals("2")){//��������
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
		 				"where  BatchNo='"+sBatchNo+"'"+
		 				" and exists(select 1 from Batch_Case_Import "+
		 				" where Batch_Case_Import.DueNo=Batch_Case.DueNo"+
		 				" and ImportNo like 'N"+CurUser.UserID+"%000000')";
		 		Sqlca.executeSQL(updateSql);
		 	}
		 	//���ݴ��������°�����
		 	//��ս�������εı���
		 	Sqlca.executeSQL("Delete from Batch_Case_History where InputDate='"+StringFunction.getToday()+"' and BatchNo='"+sBatchNo+"'");
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
		 			" where BatchNo = '"+sBatchNo+"'";
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