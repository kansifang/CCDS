<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.util.ObjectExim"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Dialog00;Describe=ע����;]~*/
%>
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
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Dialog01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Dialog02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ServerRootPath"));

	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";

	try{
		System.out.println("Export DataObject--"+sObjectType+":"+sObjectNo);

		sRealPath = "D:/workdir/";
		ObjectExim oe = new ObjectExim(Sqlca,sObjectType,sRealPath);
	    oe.setSDefaultSchema("INFORMIX");
		oe.exportToXml(Sqlca,sObjectNo);

		System.out.println("export is ok.............");
		//oe.importFromXml(Sqlca,sObjectType+"_"+sObjectNo+".xml");
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
<%
	/*~END~*/
%>





<%@ include file="/IncludeEnd.jsp"%>
