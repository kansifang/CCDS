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
String getFullPath(String sDocNo, String sAttachmentNo,String sFileName,String sFileSavePath, String sFileNameType, ServletContext sc,String sLastDirPath) {
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
	} else {
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
//根据相关参数得到中间部分的路径 yyyy/mm/dd
String getMidPath(String sDocNo, String sAttachmentNo,String lastDirPath) {
	return sDocNo.substring(0,4)+"/"+sDocNo.substring(4,6)+"/"+sDocNo.substring(6,8)+"/"+lastDirPath;
}
//根据相关参数得到完整文件名 docno_attachmentno_filename
String getFileName(String sDocNo, String sAttachmentNo,String sShortFileName,String sFileNameType) {
	String sFileName = "";
	// 判断文件类型
	if (sFileNameType.equalsIgnoreCase("MD5")) {
		sFileName = getMD5String(sDocNo+sAttachmentNo);
	} else {
		sFileName = sDocNo + "_" + sAttachmentNo + "_" + sShortFileName;
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
%>
	<%
			AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
			myAmarsoftUpload.initialize(pageContext);
			myAmarsoftUpload.upload(); 
			//调用页面传入参数
			String sDocNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo")));
			String sDocModelNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocModelNo")));
			String sMessage = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Message")));
			String sHandlers = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Handler")));
			String sClearTable = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClearTable")));
			//FileChooseDialog传入参数
			StringBuffer sb=new StringBuffer();
			
			Files files=myAmarsoftUpload.getFiles();
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
		               		String sFullPath=getFullPath(sDocNo, sAttachmentNo,sFileName, sFileSavePath, sFileNameType, application,sDocModelNo);lfile.saveAs(sFullPath);
		               		//得到带相对路径的文件名
		               		String sFilePath = getMidPath(sDocNo,sAttachmentNo,sDocModelNo)+"/"+getFileName(sDocNo,sAttachmentNo,sFileName,sFileNameType);
							rs.updateString("FilePath",sFilePath); 
							rs.updateString("FullPath",sFullPath);
							sb.append(sFullPath).append("~");
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
					myAmarsoftUpload = null;
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
			//最终获得文件全路径拼成的字符串
			if(sb.lastIndexOf("~")==sb.length()-1){
		sb.deleteCharAt(sb.length()-1);
			}
			//调用上传文件后的处理器
			String[]handlers=sHandlers.split("~");
	%>
<script language=javascript>var sReturn=""</script>
<%
	if(!"".equals(sHandlers)&&handlers.length>0){
%>
			<script language=javascript>
				ShowMessage("正在进行文档上传后的后续操作,请耐心等待.......",true,false);
			</script>
<%
	for(int i=0;i<handlers.length;i++){
%>				
			<script language=javascript>
				sReturn+=PopPage("/Common/Document/AfterUpload/<%=handlers[i]%>.jsp?SerialNo=&File=<%=sb.toString()%>&ClearTable=<%=sClearTable%>","","dialogWidth=0;dialogHeight=0;minimize:yes");
			</script>
<%
	}
%>
			<script language=javascript>try{hideMessage();}catch(e) {}</script>
<%
	}
%>
<script language=javascript>
	if(sReturn!==""){
		alert("导入失败！");
	}else{
		if("<%=sMessage%>"==""){
			alert(getHtmlMessage(13));//上传文件成功
		}else{
			 alert("<%=sMessage%>");
		}
	}
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>