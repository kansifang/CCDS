<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: ȡ�ö�Ӧ�ı�������
		Input Param:
			                
		Output param:
		History Log: 
			DATE	CHANGER		CONTENT
			2005-8-10	fbkang	ҳ�����				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ȡ�ñ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����,������Чֵ;]~*/%>
<html>
<head>
<title>ȡ�ñ��������</title>
<%
    //�������
	String sSql = "";//--���sql���
	String sObjectNo = "";//--������
	String sObjectType = "";//--��������
	String sTabelName = "";//--����
	String sReturnValue = "false";//--����ֵ
	
	//���ҳ������������� ��ʱΪ�ͻ���
	sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));

	//���ݿͻ����ҵ���Ӧ�Ŀͻ�����
	sSql = "select CustomerType from CUSTOMER_INFO where CustomerID ='"+sObjectNo+"' ";
	sObjectType = Sqlca.getString(sSql);
		
	//���ݲ�ͬ�Ŀͻ����͵���ͬ�ı���ȡ�ö�Ӧ�ı�������
	if(sObjectType!=null && ("01,02").indexOf(sObjectType.substring(0,2))>=0)// ��˾�ͻ������ſͻ�
		sTabelName = "ENT_INFO ";
	else if(sObjectType!=null && ("03,04,05").indexOf(sObjectType.substring(0,3))>=0)//���˿ͻ������幤�̻���ũ��
		sTabelName = "IND_INFO ";

	//��ȡ���񱨱�����
	sSql = "select FinanceBelong as FSModelClass from "+sTabelName+" where CustomerID ='"+sObjectNo+"' and length(FinanceBelong)>1";
	String sFinanceBelong = Sqlca.getString(sSql);	
	if(sFinanceBelong == null) sFinanceBelong = "";
	if(!sFinanceBelong.equals("")) sReturnValue = sFinanceBelong;	
	
		
%>
<script language=javascript>
	self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>