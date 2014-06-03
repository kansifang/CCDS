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
   		 	rs=Sqlca.getASResultSet("select SortNo,CodeDescribe from Code_Catalog where CodeNo='"+sConfigNo+"'");
   		 	if(rs.next()){
   		 		String sFileType=DataConvert.toString(rs.getString("SortNo")).toUpperCase();
   		 		String sHandlerFlag=DataConvert.toString(rs.getString("CodeDescribe")).toUpperCase();
	 			if("1".equals(sUploadType)){
	   	 			ImportAHandlerFactory.handle(sFiles,sFileType,sHandlerFlag, sConfigNo, sKeys, CurUser, Sqlca);
	   	 			Sqlca.conn.commit();
	   		 	}else if("2".equals(sUploadType)){
	   		 		String[] sReportDates=sKeys.split("~");
	   		 		String[] sFile=sFiles.split("~");
	   		 		for(int i=0;i<sReportDates.length;i++){
	   		 			if("".equals(sReportDates[i])){
	   		 				continue;
	   		 			}
	   	  	 			ImportAHandlerFactory.handle(sFile[i],sFileType,sHandlerFlag, sConfigNo, sReportDates[i], CurUser, Sqlca);
	   	  	 			Sqlca.conn.commit();//一个循环提交一次，以节省缓存，否则容易报57011
	   		 		}
	   		 	}
	   		 	sMessage="true";
   		 	}
   		 	rs.getStatement().close();
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