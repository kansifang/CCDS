<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.lmt.baseapp.flow.*" %>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   byhu  2004.12.6
			Tester:
			Content: ��ʾ��һ�׶���Ϣ
			Input Param:
		SerialNo����ǰ�������ˮ��
		PhaseAction����ѡ����һ������
		PhaseOpinion1�����
			Output param:
		sReturnValue:	����ֵCommit��ʾ��ɲ���
			History Log: zywei 2005/08/03  �ؼ�ҳ��
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�����ύ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//��ȡ������������ˮ�ź���һ������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//���ϸ�ҳ��õ������������ˮ��
	String sPhaseAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseAction"));//���ϸ�ҳ��õ�����Ķ�����Ϣ
	String sPhaseOpinion1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseOpinion1"));//���ϸ�ҳ��õ�����������Ϣ
	//����ֵת���ɿ��ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sPhaseAction == null) sPhaseAction = "";
	if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
	
	//������������ؽ׶���Ϣ���׶�����
	String sPhaseInfo = "",sNextPhaseName = "",sNextPhaseNo = "";
%>
<%
	/*~END~*/
%>	


<%
		/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=����ҵ���߼�;]~*/
	%>
<%
	//��ʼ���������
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
	//ִ���ύ����
	FlowPhase fpFlow = ftBusiness.commitAction(sPhaseAction,sPhaseOpinion1);
	//��ȡ��һ�׶εĽ׶�����
	sNextPhaseName = fpFlow.PhaseName;
	sNextPhaseNo = fpFlow.PhaseNo;
	//ƴ����ʾ��Ϣ
	sPhaseInfo="��һ�׶�:";
	sPhaseInfo = sPhaseInfo+" " + sNextPhaseName;		
	if (sPhaseInfo!=null && sPhaseInfo.trim().length()>0){
%>
		<script language=javascript>
			alert("<%=sPhaseInfo%>");
			self.returnValue = "Success";
			self.close();	
		</script>
<%
	}else
	{
%>
		<script language=javascript>			
			self.returnValue = "Failure";
			self.close();	
		</script>
<%
	}
%>
	
<%
		/*~END~*/
	%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List04;Describe=�����ύ�󷵻����־;]~*/
%>
<script language=javascript>
	//self.returnValue = "Commit";
	//self.close();	
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>