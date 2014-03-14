<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.web.upload.*"%>

<title>文档附件上传</title>
<%!//根据相关参数得到保存文件的实际路径
String getFullPath(String sDocNo, String sAttachmentNo,String sFileName,String sFileSavePath, String sFileNameType, ServletContext sc) {
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
			sBasePath = sc.getRealPath("/WEB-INF/Upload");
			System.out.println("！！保存附件文件路径["+sFileSavePath+"]无法创建,文件保存在缺省目录["+sBasePath+"]！");
		}
	} else {
		sBasePath = sc.getRealPath("/WEB-INF/Upload");
		System.out.println("！！保存附件文件路径没有定义,文件保存在缺省目录["+sBasePath+"]！");
	}
		
	String sFullPath= sBasePath+"/"+getMidPath(sDocNo,sAttachmentNo);
	try {
		dFile=new java.io.File(sFullPath);
		if(!dFile.exists()) {
			dFile.mkdirs();	
		}
	}catch (Exception e) {
		System.out.println("！！保存附件文件完整路径["+sFullPath+"]无法创建！");
	}

	String sFullName=sBasePath+"/"+getFilePath(sDocNo,sAttachmentNo,sFileName,sFileNameType);
	return sFullName;
}

//根据相关参数得到中间部分的路径
String getMidPath(String sDocNo, String sAttachmentNo) {
	return "/BoradList/"+sDocNo.substring(0,4);
}

//根据相关参数得到完整文件名
String getFilePath(String sDocNo, String sAttachmentNo,String sShortFileName,String sFileNameType) {
	String sFileName;
	// 判断文件类型
	if (sFileNameType.equalsIgnoreCase("MD5")) {
		sFileName = getMidPath(sDocNo,sAttachmentNo);
		sFileName = sFileName+"/"+new MD5().getMD5ofStr(sDocNo+sAttachmentNo);
	} else {
		sFileName = getMidPath(sDocNo,sAttachmentNo);
		sFileName = sFileName+"/"+sDocNo + "_" + sAttachmentNo + "_" + sShortFileName;
	}
	return sFileName;
}%>

<%
	String sAttachmentNo="000";
	
	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 

	String sBoardNo = (String)myAmarsoftUpload.getRequest().getParameter("BoardNo");			
	String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName");

	//得到不带路径的文件名
	sFileName = StringFunction.getFileName(sFileName);
	
	ASResultSet rs = Sqlca.getASResultSetForUpdate("SELECT BOARD_LIST.* FROM BOARD_LIST WHERE BoardNo='"+sBoardNo+"' ");

	if(rs.next() ) {
		if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
	try 
	{
		java.util.Date dateNow = new java.util.Date();
		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
		String sBeginTime=sdfTemp.format(dateNow);
		
        		String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
		if(sFileSaveMode.equals("Disk")) //存放文件服务器中
		{	                	
            		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
            		String sFileNameType = CurConfig.getConfigure("FileNameType");
            		String sFullPath=getFullPath(sBoardNo, sAttachmentNo,sFileName, sFileSavePath, sFileNameType, application);
			myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
            		//得到带相对路径的文件名
            		String sFilePath = getFilePath(sBoardNo,sAttachmentNo,sFileName,sFileNameType);
			rs.updateString("FilePath",sFilePath); 
			rs.updateString("FullPath",sFullPath);
		}
		dateNow = new java.util.Date();
		String sEndTime=sdfTemp.format(dateNow);

		rs.updateString("FileSaveMode",sFileSaveMode);  
		rs.updateString("FileName",sFileName);
		rs.updateString("ContentType",DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType()));
		rs.updateString("ContentLength",DataConvert.toString(String.valueOf(myAmarsoftUpload.getFiles().getFile(0).getSize())));
		rs.updateString("UploadTime",sBeginTime);
		rs.updateString("EndTime",sEndTime);
		rs.updateRow();				
		rs.getStatement().close();				
		if(sFileSaveMode.equals("Table")) //存放数据表中
		{
			myAmarsoftUpload.getFiles().getFile(0).fileToField(Sqlca,"update board_list set DocContent=? where BoardNo='"+sBoardNo+"' ");
		}
		myAmarsoftUpload = null;				
	} 
	catch(Exception e) 
	{
		out.println("An error occurs : " + e.toString());				
		rs.getStatement().close();
		myAmarsoftUpload = null;
%>			
				<script language=javascript>
					alert("上传失败！");
					self.close();
				</script>
<%
	}			
		}
	}
%>

<script language=javascript>
	alert("上传成功！");
	self.close();

</script>

<%@ include file="/IncludeEnd.jsp"%>