package com.lmt.baseapp.Import.impl;
import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
public class TotalFactory extends Bizlet {
	public Object run(Transaction Sqlca) throws Exception{
  		// AfterImport��ʾ����󼴽������ݴ��� 
		//BeforeDisplay��ʶչʾǰ��һ���������ݴ���
  		String sHandleType =DataConvert.toString((String)this.getAttribute("HandleType"));
  		//1 һ�ڶ��ļ� 2 ���ڶ��ļ�һһ��Ӧ
 		String sUploadMethod =DataConvert.toString((String)this.getAttribute("UploadMethod"));
   		String sConfigNo =DataConvert.toString((String)this.getAttribute("ConfigNo"));
 		String sKeys =DataConvert.toString((String)this.getAttribute("OneKeys"));
  		String sFiles =DataConvert.toString((String)this.getAttribute("Files"));
  		ASUser CurUser =(ASUser)this.getAttribute("CurUser");
  		String sBatchNo =DataConvert.toString((String)this.getAttribute("PCNo"));
  		//���������SQL��䡢�������
  		String sMessage="";
  		ASResultSet rs=null;
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
 	   		 			ImportFactory.importData(sFiles, sFileType, sHandlerFlag, sConfigNo, sKeys, CurUser, Sqlca);
 		   	 			DataHandlerFactory.handle(sBatchNo,sFiles,sFileType,sHandlerFlag, sConfigNo, sKeys, CurUser, Sqlca);
 		   	 			Sqlca.conn.commit();
 		   		 	}else if("2".equals(sUploadMethod)){
 		   		 		String[] sReportDates=sKeys.split("~");
 		   		 		String[] sFile=sFiles.split("~");
 		   		 		for(int i=0;i<sReportDates.length;i++){
 		   		 			if("".equals(sReportDates[i])){
 		   		 				continue;
 		   		 			}
 		   		 			ImportFactory.importData(sFile[i], sFileType,sHandlerFlag, sConfigNo, sReportDates[i], CurUser, Sqlca);
 		   	  	 			DataHandlerFactory.handle(sBatchNo,sFile[i],sFileType,sHandlerFlag, sConfigNo, sReportDates[i], CurUser, Sqlca);
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
		}catch (Exception e) {
		 	sMessage="���ݵ��벢����ʧ�ܣ�An error occurs : " + e.toString()+"@"+e.getMessage();
		 	System.out.println(sMessage);
		 	throw e;
		}finally{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(isAutoCommit);
		}
		return sMessage;
	}
}