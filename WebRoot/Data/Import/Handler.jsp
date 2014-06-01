<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.util.Date,com.lmt.baseapp.Import.base.*,com.lmt.baseapp.Import.impl.*"%>

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

<%
 	//调用页面传入参数
 		String sConfigNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ConfigNo")));
   		String sUploadType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UploadType")));
  		String sKeys =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OneKeys")));
   		String sFiles =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Files")));
   		//定义变量：SQL语句、意见详情
   		String sSql = "",sMessage="";
   		ASResultSet rs=null;
   		PreparedStatement ps1 = null;
   		String sImportTableName="Batch_Import";
   		boolean isAutoCommit=false;
  		try {
  		 	isAutoCommit=Sqlca.conn.getAutoCommit();
  		 	Sqlca.conn.setAutoCommit(false);
  		 	if("1".equals(sUploadType)){
  		 		//导入文件到原始表，始终保持原滋原味
  	 	 		Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sKeys+"'");
  	  		 	EntranceImpl efih=new ExcelBigEntrance(sFiles,sImportTableName,CurUser,Sqlca);
  	  		 	efih.action(sConfigNo,sKeys);
  	  			//再导入到中间表，可以进行加工
  	  		 	Sqlca.executeSQL("Delete from Batch_Import_Interim where ConfigNo='"+sConfigNo+"' and OneKey='"+sKeys+"'");
  	  		 	EntranceImpl efih_Iterim=new ExcelBigEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
  	  		 	efih_Iterim.action(sConfigNo,sKeys);
  	  		 	//更新配置号和报表日期
  	  	 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
  	  	 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
  	 			//3、选择处理就行处理
  	 			String sHandler=DataConvert.toString(Sqlca.getString("select CodeDescribe from Code_Catalog where CodeNo='"+sConfigNo+"'")).toUpperCase();
  	 			if(!"".equals(sHandler)){
  	 				AfterImportHandlerFactory.handle(sHandler, sConfigNo, sKeys, Sqlca);
  	 			}
  	 			sMessage="true";
  		 	}else if("2".equals(sUploadType)){
  		 		String[] sReportDates=sKeys.split("~");
  		 		String[] sFile=sFiles.split("~");
  		 		for(int i=0;i<sReportDates.length;i++){
  		 			if("".equals(sReportDates[i])){
  		 				continue;
  		 			}
  		 			//导入文件到原始表，始终保持原滋原味
  	  	 	 		Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sReportDates[i]+"'");
  	  	  		 	EntranceImpl efih=new ExcelBigEntrance(sFile[i],sImportTableName,CurUser,Sqlca);
  	  	  		 	efih.action(sConfigNo,sReportDates[i]);
  	  	  			//再导入到中间表，可以进行加工
  	  	  		 	Sqlca.executeSQL("Delete from Batch_Import_Interim where ConfigNo='"+sConfigNo+"' and OneKey='"+sReportDates[i]+"'");
  	  	  		 	EntranceImpl efih_Iterim=new ExcelBigEntrance(sFile[i],"Batch_Import_Interim",CurUser,Sqlca);
  	  	  		 	efih_Iterim.action(sConfigNo,sReportDates[i]);
  	  	  		 	//更新配置号和报表日期
  	  	  	 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
  	  	  	 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
  	  	 			//3、选择处理就行处理
  	  	 			String sHandler=DataConvert.toString(Sqlca.getString("select CodeDescribe from Code_Catalog where CodeNo='"+sConfigNo+"'")).toUpperCase();
  	  	 			if(!"".equals(sHandler)){
  	  	 				AfterImportHandlerFactory.handle(sHandler, sConfigNo, sReportDates[i], Sqlca);
  	  	 			}
  	  	 			Sqlca.conn.commit();//一个循环提交一次，以节省缓存，否则容易报57011
  		 		}
  		 	}
  		 	sMessage="true";
		}catch(SQLException e){
			System.out.println(e.getNextException());
			throw e;
		}
  		catch (Exception e) {
		 	sMessage=e.getMessage(); 	
		 	out.println("An error occurs : " + e.toString());
		 	sMessage="导入失败！";
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