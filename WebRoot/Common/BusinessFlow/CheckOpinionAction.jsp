<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: FMWu 2004-12-17
			Tester:
			Describe: �������Ƿ�ǩ��һ���������ύǰ���
			Input Param:
		SerialNo:������ˮ��
			Output Param:
			HistoryLog:zywei 2005/08/01
		
		 */
	%>
<%
	/*~END~*/
%> 


<%
 	//��ȡ������������ˮ��
 	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
 	//����ֵת���ɿ��ַ���
 	if(sSerialNo == null) sSerialNo = "";
 	
 	//���������SQL��䡢�������
 	String sSql = "",sPhaseOpinion = "";
 	
 	//����������ˮ�Ŵ����������¼���в�ѯǩ������
 	sSql = "select PhaseOpinion from FLOW_OPINION where SerialNo='"+sSerialNo+"' ";
 	sPhaseOpinion = Sqlca.getString(sSql);
 	//����ֵת���ɿ��ַ���
 	if (sPhaseOpinion == null) sPhaseOpinion = "";
 	else sPhaseOpinion = "�Ѿ�ǩ�����";//��ֹ�лس��������
 %>


<script language=javascript>
    self.returnValue="<%=sPhaseOpinion%>";
    self.close();    
</script>


<%@ include file="/IncludeEnd.jsp"%>
