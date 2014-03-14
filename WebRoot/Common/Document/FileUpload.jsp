<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.lmt.frameapp.web.uad.*"%>
<%@page import="java.security.NoSuchAlgorithmException"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   jytian  2004/12/21
			Tester: 
	  		Content: �������ϴ� 
	  		Input Param:
	 			DocNo:�ĵ����	    
	  		Output param:
	  		History Log:
		*/
	%>
<%
	/*~END~*/
%>

<%!//������ز����õ������ļ���ʵ��·��
String getFullPath(String sDocNo, String sAttachmentNo,String sFileName,String sFileSavePath, String sFileNameType, ServletContext sc,String sLastDirPath) {
	java.io.File dFile=null;
	String sBasePath = sFileSavePath;
	if (!sFileSavePath.equals("")) {
		try {
			dFile=new java.io.File(sBasePath);
			if(!dFile.exists()) {
				dFile.mkdirs();	
				System.out.println("�������渽���ļ�·��["+sFileSavePath+"]�����ɹ�����");
			}
		}catch (Exception e) {
			System.out.println("�������渽���ļ�·��["+sFileSavePath+"]�޷�������");
		}
	} else {
		sBasePath = sc.getRealPath("/WEB-INF/Upload");
		System.out.println("�������渽���ļ�·��û�ж���,�ļ�������ȱʡĿ¼["+sBasePath+"]��");
	}
		
	String sFullPath= sBasePath+"/"+getMidPath(sDocNo,sAttachmentNo,sLastDirPath);
	try {
		dFile=new java.io.File(sFullPath);
		if(!dFile.exists()) {
			dFile.mkdirs();	
		}
	}catch (Exception e) {
		System.out.println("�������渽���ļ�����·��["+sFullPath+"]�޷�������");
	}

	String sFullName=sFullPath+"/"+getFileName(sDocNo,sAttachmentNo,sFileName,sFileNameType);
	return sFullName;
}
//������ز����õ��м䲿�ֵ�·�� yyyy/mm/dd
String getMidPath(String sDocNo, String sAttachmentNo,String lastDirPath) {
	return sDocNo.substring(0,4)+"/"+sDocNo.substring(4,6)+"/"+sDocNo.substring(6,8)+"/"+lastDirPath;
}
//������ز����õ������ļ��� docno_attachmentno_filename
String getFileName(String sDocNo, String sAttachmentNo,String sShortFileName,String sFileNameType) {
	String sFileName = "";
	// �ж��ļ�����
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
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
%>
	<%
			AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
			myAmarsoftUpload.initialize(pageContext);
			myAmarsoftUpload.upload(); 
			//����ҳ�洫�����
			String sDocNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo")));
			String sDocModelNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocModelNo")));
			String sMessage = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Message")));
			String sHandlers = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Handler")));
			String sClearTable = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClearTable")));
			//FileChooseDialog�������
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
	              		//�õ�����·�����ļ���
	            		String sFileName = StringFunction.getFileName(lfile.getFileName());
	              		//����ļ���������
	               		if(sFileSaveMode.equals("Disk")) {	                	
		               		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
		               		String sFileNameType = CurConfig.getConfigure("FileNameType");
		               		String sFullPath=getFullPath(sDocNo, sAttachmentNo,sFileName, sFileSavePath, sFileNameType, application,sDocModelNo);lfile.saveAs(sFullPath);
		               		//�õ������·�����ļ���
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
					if(sFileSaveMode.equals("Table")) {//������ݱ���							
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
	                  alert(getHtmlMessage(10));//�ϴ��ļ�ʧ�ܣ�
	                  self.close();
	              </script>
	<%
		}           
		        	}
	    	}
			//���ջ���ļ�ȫ·��ƴ�ɵ��ַ���
			if(sb.lastIndexOf("~")==sb.length()-1){
		sb.deleteCharAt(sb.length()-1);
			}
			//�����ϴ��ļ���Ĵ�����
			String[]handlers=sHandlers.split("~");
	%>
<script language=javascript>var sReturn=""</script>
<%
	if(!"".equals(sHandlers)&&handlers.length>0){
%>
			<script language=javascript>
				ShowMessage("���ڽ����ĵ��ϴ���ĺ�������,�����ĵȴ�.......",true,false);
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
		alert("����ʧ�ܣ�");
	}else{
		if("<%=sMessage%>"==""){
			alert(getHtmlMessage(13));//�ϴ��ļ��ɹ�
		}else{
			 alert("<%=sMessage%>");
		}
	}
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>