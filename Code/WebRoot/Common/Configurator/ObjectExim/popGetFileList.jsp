<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.util.ASLocator"%>
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
	StringBuffer sbReturn = new StringBuffer("");
	String sReturn;
	
	//����������	
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FilePath"));

	if(sRealPath==null) sRealPath="";

	try{
		System.out.println("Get Real Path File List--"+sRealPath);

		String[] saFileList = ASLocator.getFileList(sRealPath,".xml");
		for( int i=0; i < saFileList.length; i++ )
		{
			if( i > 0 ) sbReturn.append("$");
			sbReturn.append(saFileList[i]);
		}
		sReturn = sbReturn.toString();
		//oe.importFromXml(Sqlca,sObjectType+"_"+sObjectNo+".xml");
		%>
		<script language="javascript">
		self.returnValue="<%=sReturn%>";
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
