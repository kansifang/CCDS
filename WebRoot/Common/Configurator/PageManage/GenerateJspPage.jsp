<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%@ page language="java" 
 import="com.amarsoft.web.jspgen.*"     
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Dialog00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zxu 2005-01-21
		Tester:
		Content: ����JSPҳ��
		Input Param:
                  
		Output param:
		                
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Dialog01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Dialog02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sPageID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PageID"));
	String sCompID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CompID"));
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ServerRootPath"));

	if(sPageID==null) sPageID="";
	if(sCompID==null) sCompID="";

	try{
	        System.out.println("writing sPageID:"+sPageID);

		String[][] ssURL = Sqlca.getStringMatrix("select PageURL, ItemDescribe from REG_PAGE_DEF,CODE_LIBRARY where PageID='"+sPageID+"' and CodeNo='JSPModel' and ItemNo=JspModel ");
		String sPageURL = ssURL[0][0];
		String sMdlURL = ssURL[0][1];
		
		String sData = ASJspReader.readFileToString(sRealPath+sMdlURL);
		
		ASJspGenerate jspGen = new ASJspGenerate(sRealPath,sPageID,CurUser);
	    
		String sbCodeBody = jspGen.parseJspModel(sData, Sqlca,sPageID,sCompID);

		ASJspWriter.writeToFile(sRealPath+sPageURL,sbCodeBody);
		%>
		<script language="javascript">
		self.returnValue="succeeded";
		self.close();
		</script>
		<%
	}catch(Exception ex){
		out.println("����ʧ��!����:"+ex.toString());
		%>
		<script language="javascript">
		self.returnValue="failed";
		</script>
		<%
	}
 
	//���ҳ�����	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>





<%@ include file="/IncludeEnd.jsp"%>
