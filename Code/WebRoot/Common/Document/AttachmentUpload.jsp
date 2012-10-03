<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.web.upload.*" %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
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
<%/*~END~*/%>

<%!
//������ز����õ������ļ���ʵ��·��
String getFullPath(String sDocNo, String sAttachmentNo,String sFileName,String sFileSavePath, String sFileNameType, ServletContext sc) {
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
			sBasePath = sc.getRealPath("/WEB-INF/Upload");
			System.out.println("�������渽���ļ�·��["+sFileSavePath+"]�޷�����,�ļ�������ȱʡĿ¼["+sBasePath+"]��");
		}
	} else {
		sBasePath = sc.getRealPath("/WEB-INF/Upload");
		System.out.println("�������渽���ļ�·��û�ж���,�ļ�������ȱʡĿ¼["+sBasePath+"]��");
	}
		
	String sFullPath= sBasePath+"/"+getMidPath(sDocNo,sAttachmentNo);
	try {
		dFile=new java.io.File(sFullPath);
		if(!dFile.exists()) {
			dFile.mkdirs();	
		}
	}catch (Exception e) {
		System.out.println("�������渽���ļ�����·��["+sFullPath+"]�޷�������");
	}

	String sFullName=sBasePath+"/"+getFilePath(sDocNo,sAttachmentNo,sFileName,sFileNameType);
	return sFullName;
}

//������ز����õ��м䲿�ֵ�·��
String getMidPath(String sDocNo, String sAttachmentNo) {
	//modify in 2008/04/10 for Ŀ¼�ֿ�
	//return "/Attachment/"+sDocNo.substring(0,8);
	return sDocNo.substring(0,4)+"/"+sDocNo.substring(4,6)+"/"+sDocNo.substring(6,8);	
}

//������ز����õ������ļ���
String getFilePath(String sDocNo, String sAttachmentNo,String sShortFileName,String sFileNameType) {
	String sFileName;
	// �ж��ļ�����
	if (sFileNameType.equalsIgnoreCase("MD5")) {
		sFileName = getMidPath(sDocNo,sAttachmentNo);
		sFileName = sFileName+"/"+new MD5().getMD5ofStr(sDocNo+sAttachmentNo);
	} else {
		sFileName = getMidPath(sDocNo,sAttachmentNo);
		sFileName = sFileName+"/"+sDocNo + "_" + sAttachmentNo + "_" + sShortFileName;
	}
	return sFileName;
}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
		AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
		myAmarsoftUpload.initialize(pageContext);
		myAmarsoftUpload.upload(); 

		String sDocNo = (String)myAmarsoftUpload.getRequest().getParameter("DocNo");
		String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName");
		//�õ�����·�����ļ���
		sFileName = StringFunction.getFileName(sFileName);
		String sAttachmentNo = DBFunction.getSerialNoFromDB("DOC_ATTACHMENT","AttachmentNo","DocNo='"+sDocNo+"'","","000",new java.util.Date(),Sqlca);   
		Sqlca.executeSQL("insert into DOC_ATTACHMENT(DocNo,AttachmentNo) values('"+sDocNo+"','"+sAttachmentNo+"')");
		ASResultSet rs = Sqlca.getASResultSetForUpdate("SELECT DOC_ATTACHMENT.* FROM DOC_ATTACHMENT WHERE DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");

		if(rs.next()) 
    	{
        	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing())
        	{
            		try 
            		{
                		java.util.Date dateNow = new java.util.Date();
                		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
                		String sBeginTime=sdfTemp.format(dateNow);
						
                		String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
	                	if(sFileSaveMode.equals("Disk")) //����ļ���������
						{	                	
	                		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
	                		String sFileNameType = CurConfig.getConfigure("FileNameType");
	                		String sFullPath=getFullPath(sDocNo, sAttachmentNo,sFileName, sFileSavePath, sFileNameType, application);
							myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
	                		//�õ������·�����ļ���
	                		String sFilePath = getFilePath(sDocNo,sAttachmentNo,sFileName,sFileNameType);
							rs.updateString("FilePath",sFilePath); 
							rs.updateString("FullPath",sFullPath);
						}
						dateNow = new java.util.Date();
						String sEndTime=sdfTemp.format(dateNow);
		
						rs.updateString("FileSaveMode",sFileSaveMode);  
						rs.updateString("FileName",sFileName);  
						rs.updateString("ContentType",DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType()));
						rs.updateString("ContentLength",DataConvert.toString(String.valueOf(myAmarsoftUpload.getFiles().getFile(0).getSize())));
						rs.updateString("BeginTime",sBeginTime);
						rs.updateString("EndTime",sEndTime);
						rs.updateString("InputUser",CurUser.UserID);
						rs.updateString("InputOrg",CurUser.OrgID);
						rs.updateRow();
						rs.getStatement().close();

						if(sFileSaveMode.equals("Table")) //������ݱ���
						{							
							myAmarsoftUpload.getFiles().getFile(0).fileToField(Sqlca,"update DOC_ATTACHMENT set DocContent=? where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
						}	
						myAmarsoftUpload = null;
                    } 
            		catch(Exception e) 
            		{
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
    
%>

<script language=javascript>
    alert(getHtmlMessage(13));//�ϴ��ļ��ɹ���
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>