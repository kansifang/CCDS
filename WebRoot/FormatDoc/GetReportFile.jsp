<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.17
		Tester:
		Content: ������ɵĸ�ʽ�������ļ��Ƿ����
		Input Param:
			DocID: �ĵ���� FORMATDOC_CATALOG�еĵ��鱨�棬�����鱨�棬...)
			ObjectNo��������
			ObjectType����������
		Output param:
		History Log: cdeng 2009-02-12 �޸Ļ�ȡ�ĵ��洢·����ʽ
	 */
	%>
<%/*~END~*/%>


<% 	
	//�������
	String sFlag = "",sSerialNoNew = "",sFileName = "";	
	//���ҳ�����	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 		//ҵ����ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 	//��������
	String sDocID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocID")); 	//��������
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sDocID == null) sDocID = "";
	//cdeng 2009-02-12 ��ȡ�ĵ��洢·����ʽ
	ASResultSet rs = null;
	String sSql1="";
	sSql1=" select SerialNo,SavePath from Formatdoc_Record where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+"' ";
	if(!sObjectType.equals("PutOutApply"))
		sSql1=sSql1+" and DocID='"+sDocID+"'";
	rs = Sqlca.getASResultSet(sSql1);
	if(rs.next())
	{
		sFileName = rs.getString("SavePath");
	}
	rs.getStatement().close();
	if(sFileName==null) sFileName="";
	
	java.io.File file = new java.io.File(sFileName);
    if(file.exists())
		sFlag = "true";
	else
		sFlag = "false";
	
%>

<script language="JavaScript">
	self.returnValue="<%=sFlag%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>