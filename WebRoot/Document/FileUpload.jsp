<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.lmt.frameapp.web.uad.*"%>
<%@page import="java.security.NoSuchAlgorithmException"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   jytian  2004/12/21
			Tester: 
	  		Content: 将附件上传 
	  		Input Param:
	 			DocNo:文档编号	    
	  		Output param:
	  		History Log:
		*/
	%>
<%
	/*~END~*/
%>

<%!//根据相关参数得到保存文件的实际路径
String getFullPath(String sFileSavePath,String sDocNo, String sAttachmentNo,String sLastDirPath,String sFileName, String sFileNameType, ServletContext sc) {
	java.io.File dFile=null;
	String sBasePath = sFileSavePath;
	if (!sFileSavePath.equals("")) {
		try {
			dFile=new java.io.File(sBasePath);
			if(!dFile.exists()) {
				dFile.mkdirs();	
				System.out.println("！！保存附件文件路径["+sFileSavePath+"]创建成功！！");
			}
		}catch (Exception e) {
			System.out.println("！！保存附件文件路径["+sFileSavePath+"]无法创建！");
		}
	}else {
		sBasePath = sc.getRealPath("/WEB-INF/Upload");
		System.out.println("！！保存附件文件路径没有定义,文件保存在缺省目录["+sBasePath+"]！");
	}
	String sFullPath= sBasePath+"/"+getMidPath(sDocNo,sAttachmentNo,sLastDirPath);
	try {
		dFile=new java.io.File(sFullPath);
		if(!dFile.exists()) {
			dFile.mkdirs();	
		}
	}catch (Exception e) {
		System.out.println("！！保存附件文件完整路径["+sFullPath+"]无法创建！");
	}
	String sFullName=sFullPath+"/"+getFileName(sDocNo,sAttachmentNo,sFileName,sFileNameType);
	return sFullName;
}
//根据相关参数得到中间部分的路径 
String getMidPath(String sDocNo, String sAttachmentNo,String lastDirPath) {
	return sDocNo+"/"+sAttachmentNo+("".equals(lastDirPath)?"":"/"+lastDirPath);
}
//根据相关参数得到完整文件名 docno_attachmentno_filename
String getFileName(String sDocNo, String sAttachmentNo,String sShortFileName,String sFileNameType) {
	String sFileName = "";
	// 判断文件类型
	if (sFileNameType.equalsIgnoreCase("MD5")) {
		sFileName = getMD5String(sDocNo+sAttachmentNo+sShortFileName);
	} else {
		sFileName = sDocNo+sAttachmentNo+sShortFileName;
	}
	return sFileName;
}
String getMD5String(String srcKey){
	String md5Key = srcKey;
	try {
		md5Key = MessageDigest.getDigestAsUpperHexString("MD5", srcKey);
	} catch (NoSuchAlgorithmException e) {
		e.printStackTrace();
	}
	return md5Key;
}%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/
		//调用页面与当前页面共用一个组件，故这样获取参数
		String sDocNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo")));
%>
	<%
			StringBuffer sReportDates=new StringBuffer();
			StringBuffer sFiles=new StringBuffer();

			AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
			myAmarsoftUpload.initialize(pageContext);
			myAmarsoftUpload.upload(); 
			
			//FileChooseDialog进行文件上传时，form表单中的input值不能用request.getParamete来获取，因为变成流了，
			//AmarsoftUpload已通过读取流还原成了form的键值对的形式，故可以下面这样使用
			String sConfigNo=DataConvert.toString(myAmarsoftUpload.getRequest().getParameter("ConfigNo"));
			String UploadType=DataConvert.toString(myAmarsoftUpload.getRequest().getParameter("UploadType"));
			
			
	   		//2、保存文件并插入文档目录下
			Files files=myAmarsoftUpload.getFiles();
			int fileCount=files.getCount();
			if("1".equals(UploadType)){
				sReportDates.append(myAmarsoftUpload.getRequest().getParameter("ReportDate[0]"));
			}else if("2".equals(UploadType)){
				for(int i=0;i<fileCount;i++){
					String reportDate=DataConvert.toString(myAmarsoftUpload.getRequest().getParameter("ReportDate["+i+"]"));
					sReportDates.append(reportDate).append("~");
				}
			}
			if(sReportDates.lastIndexOf("~")==sReportDates.length()-1){
				sReportDates.deleteCharAt(sReportDates.length()-1);
			}
			String sBatchNo=sConfigNo+"_"+myAmarsoftUpload.getRequest().getParameter("ReportDate[0]");
			//1、插入文档目录，所传文件将放到该目录下
			if("".equals(sDocNo)){
				sDocNo=DataConvert.toString(Sqlca.getString("select Doc_Library.DocNo from Doc_Relative,Doc_Library where Doc_Relative.DocNo=Doc_Library.DocNo and ObjectType='Batch' and ObjectNo='"+sConfigNo+"' and DocAttribute='02'"));
				if(sDocNo.length()==0){
					sDocNo=DBFunction.getSerialNo("Doc_Library", "DocNo", Sqlca);
					Sqlca.executeSQL("insert into Doc_Relative(DocNo,ObjectType,ObjectNo)values('"+sDocNo+"','Batch','"+sConfigNo+"')");
					Sqlca.executeSQL("insert into Doc_Library(DocNo,DocTitle,DocAttribute,InputTime)values('"+sDocNo+"','"+sBatchNo+"','02','"+StringFunction.getToday()+"')");
		   		}
			}
			com.lmt.frameapp.web.uad.File lfile=null;
			for(int i=0;i<files.getCount()&&!(lfile=files.getFile(i)).isMissing();i++){
				String sAttachmentNo = DBFunction.getSerialNoFromDB("DOC_ATTACHMENT","AttachmentNo","DocNo='"+sDocNo+"'","","000",new java.util.Date(),Sqlca);   
				Sqlca.executeSQL("insert into DOC_ATTACHMENT(DocNo,AttachmentNo) values('"+sDocNo+"','"+sAttachmentNo+"')");
				ASResultSet rs = Sqlca.getASResultSetForUpdate("SELECT DOC_ATTACHMENT.* FROM DOC_ATTACHMENT WHERE DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
				if(rs.next()){
	          		try{
	              		java.util.Date dateNow = new java.util.Date();
	              		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	              		String sBeginTime=sdfTemp.format(dateNow);
	              		String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
	              		//得到不带路径的文件名
	            		String sFileName = StringFunction.getFileName(lfile.getFileName());
	              		//存放文件服务器中
	               		if(sFileSaveMode.equals("Disk")) {	                	
		               		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
		               		String sFileNameType = CurConfig.getConfigure("FileNameType");
		               		String sFullPath=getFullPath(sFileSavePath, sDocNo, sAttachmentNo,"",sFileName, sFileNameType, application);
		               		lfile.saveAs(sFullPath);
		               		//得到带相对路径的文件名
		               		String sFilePath = getMidPath(sDocNo,sAttachmentNo,"")+"/"+getFileName(sDocNo,sAttachmentNo,sFileName,sFileNameType);
							rs.updateString("FilePath",sFilePath); 
							rs.updateString("FullPath",sFullPath);
							sFiles.append(sFullPath).append("~");
						}
						dateNow = new java.util.Date();
						String sEndTime=sdfTemp.format(dateNow);
						rs.updateString("FileSaveMode",sFileSaveMode);  
						rs.updateString("FileName",sFileName);  
						rs.updateString("ContentType",DataConvert.toString(lfile.getContentType()));
						rs.updateString("ContentLength",DataConvert.toString(String.valueOf(lfile.getSize())));
						rs.updateString("BeginTime",sBeginTime);
						rs.updateString("EndTime",sEndTime);
						rs.updateString("InputUser",CurUser.UserID);
						rs.updateString("InputOrg",CurUser.OrgID);
						rs.updateRow();
						rs.getStatement().close();
						if(sFileSaveMode.equals("Table")) {//存放数据表中							
							lfile.fileToField(Sqlca,"update DOC_ATTACHMENT set DocContent=? where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
						}	
	                  }catch(Exception e){
		               	out.println("An error occurs : " + e.toString());               
		               	Sqlca.executeSQL("delete FROM doc_attachment WHERE DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
		               	rs.getStatement().close();
		               	myAmarsoftUpload = null;
	%>          
	              <script language=javascript>
	                  alert(getHtmlMessage(10));//上传文件失败！
	                  self.close();
	              </script>
	<%
		}           
		        	}
	    	}
			myAmarsoftUpload = null;
			//最终获得文件全路径拼成的字符串
			if(sFiles.lastIndexOf("~")==sFiles.length()-1){
				sFiles.deleteCharAt(sFiles.length()-1);
			}
	%>
<script language=javascript>
	//alert(getHtmlMessage(13));//上传文件成功
	self.returnValue="<%=sConfigNo+"@"+UploadType+"@"+sReportDates.toString()+"@"+sFiles.toString()%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>