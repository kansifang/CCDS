<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: zywei 2006-09-09
			Tester:
			Describe: ��ü��ܺ����ˮ��
			Input Param:
		EncryptionType����������
		SerialNo����ˮ�ţ�����ǰ��
			Output Param:
		SerialNo����ˮ�ţ����ܺ�
			HistoryLog:
		 */
	%>
<%
	/*~END~*/
%>

<%
	//���ҳ�����
		String sEncryptionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EncryptionType"));
		String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
		//����ֵת������ַ���
		if(sEncryptionType == null) sEncryptionType = "";
		if(sSerialNo == null) sSerialNo = "";
		
		//ʹ��MD5���ܼ������м���
		if(sEncryptionType.equals("MD5"))
		{
	MD5 o_md5 = new MD5();
    		sSerialNo = o_md5.getMD5ofStr(sSerialNo);
		}
%>
 <script language=javascript>
	self.returnValue='<%=sSerialNo%>';
	self.close();
 </script>
<%@	include file="/IncludeEnd.jsp"%>