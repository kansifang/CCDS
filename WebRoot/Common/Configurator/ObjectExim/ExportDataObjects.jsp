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
	String[] saObjects ;
	String sOldObjectType="";
	String sObjectType,sObjectNo;
	ObjectExim oe=null;
	
	//����������	
	String sObjectValue =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("column_selection"));
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FilePath"));
		
	if(sObjectValue==null) sObjectValue="";
	if(sRealPath==null) sRealPath="";
	sRealPath = sRealPath.trim();
	
	//��������ԡ�\���������Զ�����
	if(sRealPath.length()>1 && !sRealPath.substring(sRealPath.length()-1).equals(ASConfigure.sCurSlash)){
		sRealPath = sRealPath + ASConfigure.sCurSlash;
	}
	
	try{
		saObjects = StringFunction.toStringArray(sObjectValue,"\r\n");
		Vector errors = new Vector();
		for(int i=0;i<saObjects.length-1;i++)
		{
	try{
		sObjectType=StringFunction.getSeparate(saObjects[i],".",1);
		sObjectNo=StringFunction.getSeparate(saObjects[i],".",2);
		if(sObjectType.indexOf("\\")>=0) throw new Exception("�Ƿ��Ķ����������ƣ�"+sObjectType);
		if(sObjectType.indexOf("/")>=0) throw new Exception("�Ƿ��Ķ����������ƣ�"+sObjectType);
		if(sObjectNo.indexOf("\\")>=0) throw new Exception("�Ƿ��Ķ������ƣ�"+sObjectNo+"["+sObjectType+"]");
		if(sObjectNo.indexOf("/")>=0) throw new Exception("�Ƿ��Ķ������ƣ�"+sObjectNo+"["+sObjectType+"]");
		if( sObjectType == "" || sObjectNo == "" )
			throw new Exception("��Ϣ���岻������ObjectType["+sObjectType+"].ObjectNo["+sObjectNo+"]");
		if( !sObjectType.equals(sOldObjectType) )
		{
			sOldObjectType = sObjectType;
			System.out.println("New ObjectExim:"+sObjectType);
			oe = new ObjectExim(Sqlca,sObjectType,sRealPath);
		}
		//oe.setSDefaultSchema("INFORMIX");
		System.out.println("Export DataObject--"+sObjectType+":"+sObjectNo);
		oe.exportToXml(Sqlca,sObjectNo);
	}catch(Exception ex){
		errors.add(ex.getMessage());
	}
		
		}
		System.out.println("�������.............");
		if(errors.size()<=0){
%>
			<script language="javascript">
			self.returnValue="succeeded";
			alert("���ݵ����ɹ����뵽��ָ����Ŀ¼�¼���ļ���");
			self.close();
			</script>
			<%
				}else{
				out.println("���ݵ�������ɣ����д���"+errors.size()+"����");
				for(int i=0;i<errors.size();i++) out.println((String)errors.get(i)+"<br>");
			%>
			<script language="javascript">
			self.returnValue="failed";
			</script>
			<%
				}
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
