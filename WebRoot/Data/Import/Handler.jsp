<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.util.Date,com.lmt.baseapp.Import.base.*,com.lmt.baseapp.Import.impl.*"%>

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
 	  		// AfterImport��ʾ����󼴽������ݴ��� BeforeDisplay��ʶչʾǰ��һ���������ݴ���
 	  		String sHandleType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("HandleType")));
 	   		String sConfigNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ConfigNo")));
 	     	//1 һ�ڶ��ļ� 2 ���ڶ��ļ�һһ��Ӧ
 	 		String sUploadMethod =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UploadMethod")));
     		String sKeys =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OneKeys")));
      		String sFiles =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Files")));
      		//���������SQL��䡢�������
      		String sSql = "",sMessage="";
      		ASResultSet rs=null;
      		PreparedStatement ps1 = null;
      		String sImportTableName="Batch_Import";
      		boolean isAutoCommit=false;
     		try {
     		 	isAutoCommit=Sqlca.conn.getAutoCommit();
     		 	Sqlca.conn.setAutoCommit(false);
     		 	if("AfterImport".equals(sHandleType)){
     		 		//��ѯ�ļ���Ӧ���ݿ�������Ϣ�ŵ� �ļ����ͣ��������ļ�����С�����ļ����ʹ�������־
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
 	 		   	  	 			Sqlca.conn.commit();//һ��ѭ���ύһ�Σ��Խ�ʡ���棬�������ױ�57011
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
   		 	sMessage="����ʧ�ܣ�";
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