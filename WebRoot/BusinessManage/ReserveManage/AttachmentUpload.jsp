
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.web.upload.*,java.text.*" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jytian  2004/12/21
		Tester: 
  		Content: 将附件上传 
  		Input Param:
 			DocNo:文档编号	    
  		Output param:
  		History Log: hysun 2006/04/05 把附件保存在服务器的目录下
			
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
		String sAttachmentNo = "";
		ASResultSet rs = null; 
		
		AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
		myAmarsoftUpload.initialize(pageContext);
		myAmarsoftUpload.upload(); 

		String sDocNo = (String)myAmarsoftUpload.getRequest().getParameter("ObjectNo");
		String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("DocName");
		String sDocumentType = (String)myAmarsoftUpload.getRequest().getParameter("DocumentTypeValue");
		System.out.println("=================Attachment DocNo:"+sDocNo+"  FileName"+sFileName);
		sAttachmentNo = DBFunction.getSerialNoFromDB("DOC_ATTACHMENT1","AttachmentNo","DocNo='"+sDocNo+"'","","000",new java.util.Date(),Sqlca);   
		Sqlca.executeSQL("insert into DOC_ATTACHMENT1(DocNo,AttachmentNo,DocumentType) values('"+sDocNo+"','"+sAttachmentNo+"','"+ sDocumentType +"')");
		rs = Sqlca.getASResultSetForUpdate("SELECT DOC_ATTACHMENT1.* FROM DOC_ATTACHMENT1 WHERE DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");

    	if(rs.next()) 
    	{
        	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing())
        	{
            		try 
            		{
            			System.out.println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++"+1);
                		java.util.Date dateNow = new java.util.Date();
						SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
						String sBeginTime=sdfTemp.format(dateNow);
		
						//modify by hxd in 2002/05/30 for oracle_new_jdbc upload 4000 limit
						//myAmarsoftUpload.getFiles().getFile(0).fileToField(rs,"DocContent");
						//rs.updateRow();
						
						//modify by hxd in 2005/07/04
						//myAmarsoftUpload.getFiles().getFile(0).fileToField(Sqlca,"update DOC_ATTACHMENT set DocContent=? where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
						String sPath="";
						java.io.File dFile=null;
						sPath = request.getRealPath("/WEB-INF/classes/Upload1"); 
						//out.println(sPath);
						System.out.println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++"+2);
						dFile=new java.io.File(sPath);				if(!dFile.exists()) dFile.mkdir();	
						sPath = request.getRealPath("/WEB-INF/classes/Upload1/"+sDocNo.substring(0,4));
						dFile=new java.io.File(sPath);				if(!dFile.exists()) dFile.mkdir();
						sPath = request.getRealPath("/WEB-INF/classes/Upload1/"+sDocNo.substring(0,4)+"/"+sDocNo.substring(4,6));
						dFile=new java.io.File(sPath);				if(!dFile.exists()) dFile.mkdir();
						sPath = request.getRealPath("/WEB-INF/classes/Upload1/"+sDocNo.substring(0,4)+"/"+sDocNo.substring(4,6)+"/"+sDocNo.substring(6,8)); 
						dFile=new java.io.File(sPath);				if(!dFile.exists()) dFile.mkdir();			
						//out.println(sPath);
						myAmarsoftUpload.getFiles().getFile(0).saveAs(
							"/WEB-INF/classes/Upload1/"+sDocNo.substring(0,4)+"/"+sDocNo.substring(4,6)+"/"+sDocNo.substring(6,8)+"/"+
							sDocNo+"_"+sAttachmentNo+"_"+StringFunction.getFileName(sFileName));
						
						dateNow = new java.util.Date();
						String sEndTime=sdfTemp.format(dateNow);
		
						
						rs.updateString("FileName",StringFunction.getFileName(sFileName));  
						rs.updateString("DocumentType",StringFunction.getFileName(sDocumentType));  
						rs.updateString("ContentType",DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType()));
						rs.updateString("ContentLength",DataConvert.toString(String.valueOf(myAmarsoftUpload.getFiles().getFile(0).getSize())));
						rs.updateString("BeginTime",sBeginTime);
						rs.updateString("EndTime",sEndTime);
						rs.updateRow();
						
						rs.getStatement().close();
						myAmarsoftUpload = null;
						System.out.println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++"+3);
                		
                    } 
            		catch(Exception e) 
            		{
                	out.println("An error occurs : " + e.toString());               
                	Sqlca.executeSQL("delete FROM doc_attachment1 WHERE DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
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