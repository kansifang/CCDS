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
 		String sConfigNo =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ConfigNo")));
   		String sUploadType =DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UploadType")));
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
  		 	if("1".equals(sUploadType)){
  		 		//�����ļ���ԭʼ��ʼ�ձ���ԭ��ԭζ
  	 	 		Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sKeys+"'");
  	  		 	EntranceImpl efih=new ExcelBigEntrance(sFiles,sImportTableName,CurUser,Sqlca);
  	  		 	efih.action(sConfigNo,sKeys);
  	  			//�ٵ��뵽�м�����Խ��мӹ�
  	  		 	Sqlca.executeSQL("Delete from Batch_Import_Interim where ConfigNo='"+sConfigNo+"' and OneKey='"+sKeys+"'");
  	  		 	EntranceImpl efih_Iterim=new ExcelBigEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
  	  		 	efih_Iterim.action(sConfigNo,sKeys);
  	  		 	//�������úźͱ�������
  	  	 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
  	  	 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
  	 			//3��ѡ������д���
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
  		 			//�����ļ���ԭʼ��ʼ�ձ���ԭ��ԭζ
  	  	 	 		Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sReportDates[i]+"'");
  	  	  		 	EntranceImpl efih=new ExcelBigEntrance(sFile[i],sImportTableName,CurUser,Sqlca);
  	  	  		 	efih.action(sConfigNo,sReportDates[i]);
  	  	  			//�ٵ��뵽�м�����Խ��мӹ�
  	  	  		 	Sqlca.executeSQL("Delete from Batch_Import_Interim where ConfigNo='"+sConfigNo+"' and OneKey='"+sReportDates[i]+"'");
  	  	  		 	EntranceImpl efih_Iterim=new ExcelBigEntrance(sFile[i],"Batch_Import_Interim",CurUser,Sqlca);
  	  	  		 	efih_Iterim.action(sConfigNo,sReportDates[i]);
  	  	  		 	//�������úźͱ�������
  	  	  	 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
  	  	  	 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
  	  	 			//3��ѡ������д���
  	  	 			String sHandler=DataConvert.toString(Sqlca.getString("select CodeDescribe from Code_Catalog where CodeNo='"+sConfigNo+"'")).toUpperCase();
  	  	 			if(!"".equals(sHandler)){
  	  	 				AfterImportHandlerFactory.handle(sHandler, sConfigNo, sReportDates[i], Sqlca);
  	  	 			}
  	  	 			Sqlca.conn.commit();//һ��ѭ���ύһ�Σ��Խ�ʡ���棬�������ױ�57011
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