<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-17
		Tester:
		Describe: ��ɹ鵵/ȡ���鵵������ͨ��ģ��
		Input Param:
			ObjectType: ��������
			ObjectNo: ������
			Pigeonholed:�鵵��־(Y/N)
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%
	String sObjectType = DataConvert.toRealString(iPostChange,request.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,request.getParameter("ObjectNo"));
    String sPigeonholed = DataConvert.toRealString(iPostChange,request.getParameter("Pigeonholed"));//�鵵��־ȡY/N
	
	if (sPigeonholed==null) sPigeonholed="";
   	
   	 String sTable="";//�鵵/ȡ���鵵�ı����
     String sSql="";

	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ�������
	sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sTable=DataConvert.toString(rs.getString("ObjectTable"));
	}
	rs.getStatement().close(); 
    
    if(sPigeonholed.equals("Y"))//�ѹ鵵
        sSql="UPDATE " + sTable + " SET PigeonholeDate=null";
    else sSql="UPDATE " + sTable + " SET PigeonholeDate='" + StringFunction.getToday() + "'";
    
    sSql=sSql + " where SerialNo='" + sObjectNo + "'";
    Sqlca.executeSQL(sSql);
%>

<script language=javascript>
    self.returnValue="true";
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>