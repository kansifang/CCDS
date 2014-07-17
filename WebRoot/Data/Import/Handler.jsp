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
 	  		// AfterImport表示导入后即进行数据处理 BeforeDisplay标识展示前做一下最后的数据处理
 	  		String sHandleType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("HandleType")));
 	   		String sConfigNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ConfigNo")));
 	     	//1 一期多文件 2 多期多文件一一对应
 	 		String sUploadMethod =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UploadMethod")));
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
     		 	if("AfterImport".equals(sHandleType)){
     		 		//查询文件对应数据库配置信息号的 文件类型（大数据文件还是小数据文件）和处理器标志
 	 	   		 	rs=Sqlca.getASResultSet("select SortNo,CodeDescribe from Code_Catalog where CodeNo='"+sConfigNo+"'");
 	 	   		 	if(rs.next()){
 	 	   		 		String sFileType=DataConvert.toString(rs.getString("SortNo")).toUpperCase();
 	 	   		 		String sHandlerFlag=DataConvert.toString(rs.getString("CodeDescribe")).toUpperCase();
 	 	   		 		if("1".equals(sUploadMethod)){
 	 		   	 			AIHandlerFactory.handle(sFiles,sFileType,sHandlerFlag, sConfigNo, sKeys, CurUser, Sqlca);
 	 		   	 			Sqlca.conn.commit();
 	 		   		 	}else if("2".equals(sUploadMethod)){
 	 		   		 		String[] sReportDates=sKeys.split("~");
 	 		   		 		String[] sFile=sFiles.split("~");
 	 		   		 		for(int i=0;i<sReportDates.length;i++){
 	 		   		 			if("".equals(sReportDates[i])){
 	 		   		 				continue;
 	 		   		 			}
 	 		   	  	 			AIHandlerFactory.handle(sFile[i],sFileType,sHandlerFlag, sConfigNo, sReportDates[i], CurUser, Sqlca);
 	 		   	  	 			Sqlca.conn.commit();//一个循环提交一次，以节省缓存，否则容易报57011
 	 		   		 		}
 	 		   		 	}
 	 		   		 	sMessage="true";
 	 	   		 	}
 	 	   		 	rs.getStatement().close();
     		 	}else if("BeforeDisplay".equals(sHandleType)){
     		 		rs=Sqlca.getASResultSet("select DocKeyWord from Doc_Library where DocNo='"+sConfigNo+"'");
     		 		if(rs.next()){
     		 			String sHandlerFlag=DataConvert.toString(rs.getString("DocKeyWord")).toUpperCase();
  		   	 			BDHandlerFactory.handle(sHandlerFlag, sConfigNo, sKeys, CurUser, Sqlca);
  		   	 			Sqlca.conn.commit();
 	 		   		 	sMessage="true";
 	 	   		 	}
 	 	   		 	rs.getStatement().close();
     		 	}
     		 	
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