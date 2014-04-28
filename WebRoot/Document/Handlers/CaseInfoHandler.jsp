<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.util.Date,com.lmt.baseapp.Import.base.*"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*

		 */
	%>
<%
	/*~END~*/
%> 

<%	//注意 原始页面调用顺序是： FileChooseDialog——>FileUpload——>本页面，前两个父组件都是原始页面
 	//调用页面传入参数 
 		String sBatchNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BatchNo")));
		String sConfigNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ConfigNo")));
 		String sHandlerType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("HandlerType")));
 		//FileUpload传入参数
 		String sFiles =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Files")));
 		//定义变量：SQL语句、意见详情
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
		 	//导入文件
		 	 ExcelImport efih=new ExcelImport(sFiles,sConfigNo,sImportTableName,CurUser,Sqlca);
		 	efih.action();
		 	//解析文件
		 	if(sHandlerType.equals("1")){//新增批次
		 		//新值批次到Batch_Case
		 		//备份此批次
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
		 		//导入后不允许对此批量再次导入，可以废掉，建批次重新导入
		 		Sqlca.executeSQL("update Batch_Info set ImportFlag='1' where BatchNo='"+sBatchNo+"'");
		 	}else if(sHandlerType.equals("2")){//更新批次
		 		//只更新包
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
		 	//备份此批次最新案例表
		 	//清空今天此批次的备份
		 	Sqlca.executeSQL("Delete from Batch_Case_History where InputDate='"+StringFunction.getToday()+"' and BatchNo='"+sBatchNo+"'");
		 	//备份此批次
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