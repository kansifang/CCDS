<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.util.ObjectExim"%>
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
	String[] saObjects ;
	String sOldObjectType="";
	String sObjectType,sFileName;
	ObjectExim oe=null;
	
	//����������	
	String sObjectValue =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("column_selection"));
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FilePath"));

	if(sObjectValue==null) sObjectValue="";
	if(sRealPath==null) sRealPath="";
	sRealPath = sRealPath.trim();

	try{
		saObjects = StringFunction.toStringArray(sObjectValue,"\r\n");
		for(int i=0;i<saObjects.length-1;i++)
		{
			sFileName=saObjects[i];
			sObjectType=StringFunction.getSeparate(sFileName,"_",1);
			if( sObjectType == "" || sFileName == "" )
				throw new Exception("��Ϣ���岻������ObjectType["+sObjectType+"]-FileName["+sFileName+"]");
			if( !sObjectType.equals(sOldObjectType) )
			{
				sOldObjectType = sObjectType;
				System.out.println("New ObjectExim:"+sObjectType);
				oe = new ObjectExim(Sqlca,sObjectType,sRealPath);
			}
			//oe.setSDefaultSchema("INFORMIX");
			System.out.println("Import DataObject--"+sObjectType+"-"+sFileName);
			oe.importFromXml(Sqlca,sFileName);
		
		}
		System.out.println("Import is ok.............");
		%>
		<script language="javascript">
		self.returnValue="succeeded";
		alert("���ݵ���ɹ���");
		self.close();
		</script>
		<%
	}catch(Exception ex){
		out.println("���ݵ���ʧ��!����:"+ex.toString());
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
