<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-07
		Tester:
		Describe: ҵ����ˮ��Ϣ;
		Input Param:
			SerialNo:��ˮ��
		Output Param:			

		HistoryLog:zywei 2005/09/04 �ؼ����
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = " ҵ����ˮ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";

	//����������
	
	//���ҳ�����(��¼��ˮ�š���ʶFlag-Y��ʾ�ӻ��ʽ���ǽ����ҳ��)
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sFlag == null) sFlag = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 
	                        {"OccurType","��������"},
	                        {"OccurDirection","��������"},
	                        {"OccurDate","��������"},
	                        {"BackType","���շ�ʽ"},
	                        {"OccurSubject","����ժҪ"},
	                        {"ActualDebitSum","���Ž��(Ԫ)"},
	                        {"ActualCreditSum","���ս��(Ԫ)"},
	                        {"UserName","�Ǽ���"},
	                        {"OrgName","�Ǽǻ���"}     
                          };	
	
	sSql=	" select SerialNo,OccurDate,ActualDebitSum,ActualCreditSum,OccurType, "+
			" OccurDirection,OccurSubject,BackType,getUserName(UserID) as UserName,"+
			" getOrgName(OrgID) as OrgName "+
			" from BUSINESS_WASTEBOOK where SerialNo='"+sSerialNo+"' ";	

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK";
	doTemp.setKey("SerialNo",true);

	doTemp.setHeader(sHeaders);
	doTemp.setReadOnly("OrgName,UserName,OccurSubject,BackType",true);
	doTemp.setReadOnly("OccurDate,ActualDebitSum,ActualCreditSum,OccurType,OrgName,OccurDirection",true);
	
	doTemp.setVisible("SerialNo",false);
	doTemp.setUpdateable("OrgName,UserName",false);
	
	doTemp.setDDDWCode("OccurSubject","OccurSubjectName");
	doTemp.setDDDWCode("OccurType","WasteOccurType");
	doTemp.setDDDWCode("OccurDirection","OccurDirection");
	doTemp.setDDDWCode("BackType","ReclaimType");
    doTemp.setType("ActualCreditSum,ActualDebitSum","Number");
	doTemp.setCheckFormat("ActualCreditSum,ActualDebitSum","2");
	doTemp.setAlign("ActualCreditSum,ActualDebitSum","3");
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
	//����HTMLDataWindow
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
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		var sFlag="<%=sFlag%>";
		if(sFlag=="Y")
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPAReturnWayList.jsp","_self","");
		else
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPABadDebtList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

