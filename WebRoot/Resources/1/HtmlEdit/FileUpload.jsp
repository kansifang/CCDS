<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sAttachmentNo="";
	ASResultSet rs=null;
    String sSerialNo=  ""; //DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
    String sFileName = "",sFileExt = "";
		
    com.lmt.frameapp.web.uad.AmarsoftUpload myAmarsoftUpload = new com.lmt.frameapp.web.uad.AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);              
	myAmarsoftUpload.upload();                             
                                                           
	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing())
	{
		try 
		{
			sFileName = DataConvert.toRealString(iPostChange,myAmarsoftUpload.getFiles().getFile(0).getFilePathName());
			System.out.println(sFileName);
			int iPos = sFileName.lastIndexOf(".");
			if(iPos == -1) 
				sFileExt = ".gif";
			else
				sFileExt = sFileName.substring(iPos);
			String sRand1 = String.valueOf(Math.random());
			sRand1  = sRand1.substring(sRand1.lastIndexOf(".")+1);
			String sRand2 = String.valueOf(Math.random());
			sRand2  = sRand1.substring(sRand2.lastIndexOf(".")+1);
			String sRand = sRand1 + "-" + sRand2;
			sFileName = "/FormatDoc/Upload/"+sSerialNo+sRand+sFileExt;
			System.out.println(sFileName);
			myAmarsoftUpload.getFiles().getFile(0).saveAs(sFileName);
			myAmarsoftUpload = null;			
		} 
		catch(Exception e) 
		{
			System.out.println("An error occurs : " + e.toString());				
			myAmarsoftUpload = null;
%>			
			<script language=javascript>
				//alert("上传失败！");
				parent.bFileUploaded = false;
			</script>
<%
		}			
	}
	
%>

<script language=javascript>
	//alert("上传成功！");
	parent.bFileUploaded = true;
	parent.sFileName = "<%=sFileName%>";
	eval(parent.btnOKClick_2());
</script>
<%@ include file="/IncludeEnd.jsp"%>