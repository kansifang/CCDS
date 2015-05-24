package com.lmt.baseapp.Import.impl;
import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
public class TotalFactory extends Bizlet {
	public Object run(Transaction Sqlca) throws Exception{
  		// AfterImport表示导入后即进行数据处理 
		//BeforeDisplay标识展示前做一下最后的数据处理
  		String sHandleType =DataConvert.toString((String)this.getAttribute("HandleType"));
  		//1 一期多文件 2 多期多文件一一对应
 		String sUploadMethod =DataConvert.toString((String)this.getAttribute("UploadMethod"));
   		String sConfigNo =DataConvert.toString((String)this.getAttribute("ConfigNo"));
 		String sKeys =DataConvert.toString((String)this.getAttribute("OneKeys"));
  		String sFiles =DataConvert.toString((String)this.getAttribute("Files"));
  		ASUser CurUser =(ASUser)this.getAttribute("CurUser");
  		String sBatchNo =DataConvert.toString((String)this.getAttribute("PCNo"));
  		//定义变量：SQL语句、意见详情
  		String sMessage="";
  		ASResultSet rs=null;
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
		}catch (Exception e) {
		 	sMessage="数据导入并处理失败！An error occurs : " + e.toString()+"@"+e.getMessage();
		 	System.out.println(sMessage);
		 	throw e;
		}finally{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(isAutoCommit);
		}
		return sMessage;
	}
}