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
String getFullPath(String sFileSavePath,String sDocNo, String sAttachmentNo,String sLastDirPath,String sFileName, String sFileNameType, ServletContext sc) {
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
	}else {
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
//������ز����õ��м䲿�ֵ�·�� 
String getMidPath(String sDocNo, String sAttachmentNo,String lastDirPath) {
	return sDocNo+"/"+sAttachmentNo+("".equals(lastDirPath)?"":"/"+lastDirPath);
}
//������ز����õ������ļ��� docno_attachmentno_filename
String getFileName(String sDocNo, String sAttachmentNo,String sShortFileName,String sFileNameType) {
	String sFileName = "";
	// �ж��ļ�����
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
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
		//����ҳ���뵱ǰҳ�湲��һ���������������ȡ����
		String sDocNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo")));
%>
	<%
			StringBuffer sReportDates=new StringBuffer();
			StringBuffer sFiles=new StringBuffer();

			AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
			myAmarsoftUpload.initialize(pageContext);
			myAmarsoftUpload.upload(); 
			
			//FileChooseDialog�����ļ��ϴ�ʱ��form���е�inputֵ������request.getParamete����ȡ����Ϊ������ˣ�
			//AmarsoftUpload��ͨ����ȡ����ԭ����form�ļ�ֵ�Ե���ʽ���ʿ�����������ʹ��
			String sConfigNo=DataConvert.toString(myAmarsoftUpload.getRequest().getParameter("ConfigNo"));
			String UploadType=DataConvert.toString(myAmarsoftUpload.getRequest().getParameter("UploadType"));
			
			
	   		//2�������ļ��������ĵ�Ŀ¼��
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
			//1�������ĵ�Ŀ¼�������ļ����ŵ���Ŀ¼��
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
	              		//�õ�����·�����ļ���
	            		String sFileName = StringFunction.getFileName(lfile.getFileName());
	              		//����ļ���������
	               		if(sFileSaveMode.equals("Disk")) {	                	
		               		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
		               		String sFileNameType = CurConfig.getConfigure("FileNameType");
		               		String sFullPath=getFullPath(sFileSavePath, sDocNo, sAttachmentNo,"",sFileName, sFileNameType, application);
		               		lfile.saveAs(sFullPath);
		               		//�õ������·�����ļ���
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
						if(sFileSaveMode.equals("Table")) {//������ݱ���							
							lfile.fileToField(Sqlca,"update DOC_ATTACHMENT set DocContent=? where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
						}	
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
			myAmarsoftUpload = null;
			//���ջ���ļ�ȫ·��ƴ�ɵ��ַ���
			if(sFiles.lastIndexOf("~")==sFiles.length()-1){
				sFiles.deleteCharAt(sFiles.length()-1);
			}
	%>
<script language=javascript>
	//alert(getHtmlMessage(13));//�ϴ��ļ��ɹ�
	self.returnValue="<%=sConfigNo+"@"+UploadType+"@"+sReportDates.toString()+"@"+sFiles.toString()%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>