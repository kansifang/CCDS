<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zwhu 2009-11-19
		Describe: 
		Input Param:
			CustomerID��--��ǰ�ͻ����
		Output Param:
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ������Լ��Ƶ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
     String sSql = "";
     
	//����������,�ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InspectType"));
	if(sInspectType == null) sInspectType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = {		
								{"CustomerID","�ͻ�ID"},
								{"CustomerName","�ͻ�����"},
								{"CheckFrequency","���Ƶ��"},
								{"InputUserName","�Ǽ���"},
								{"FinishFrequencyDate","���ʱ��"}
						  };

	      sSql =	" select CF.SerialNo,CI.CustomerID,CI.CustomerName,getItemName('CheckFrequency',CF.CheckFrequency) as CheckFrequency,getUserName(CF.InputUserID) as InputUserName, "+
					" CF.FinishFrequencyDate"+
					" from CHECK_Frequency CF,CUSTOMER_INFO CI " +
					" where CF.CustomerID='"+sCustomerID+"'and CI.CustomerID = CF.CustomerID" ;

	//��sSql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ,���±���,��ֵ,������,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	//�����޸ĵı�
	doTemp.setVisible("SerialNo",false);
	//�����ֶθ�ʽ
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	dwTemp.ReadOnly = "1"; 
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenComp("BusinessInspectDataList","/CreditManage/CreditCheck/BusinessInspectDataList.jsp","InspectType=<%=sInspectType%>","right");
	}

	</script>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
