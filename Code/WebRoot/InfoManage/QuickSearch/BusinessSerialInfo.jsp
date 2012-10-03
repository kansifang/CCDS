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
			

		HistoryLog:
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
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { {"SerialNo","��ˮ��"},
	                        {"RelativeSerialNo","��ؽ����ˮ��"},
                            {"RelativeContractNo","��غ�ͬ��ˮ��"},
                            {"TransactionFlag","���ױ�־"},
                            {"OccurType","��������"},
                            {"OccurDirection","��������"},
                            {"OccurDate","��������"},
                            {"BackType","���շ�ʽ"},
                            {"OccurSubject","����ժҪ"},
                            {"ActualDebitSum","���Ž��(Ԫ)"},
                            {"ActualCreditSum","���ս��(Ԫ)"},
                            {"OrgName","�Ǽǻ���"},
                            {"UserName","�Ǽ���"},
                          };

		sSql=	" select SerialNo,RelativeContractNo,OccurDate,ActualCreditSum, "+
				" OccurType,TransactionFlag,OccurDirection,OccurSubject,BackType,OrgID,"+
				" getOrgName(OrgID) as OrgName,UserID,getUserName(UserID) as UserName "+
				" from BUSINESS_WASTEBOOK where SerialNo='"+sSerialNo+"'";
	//ͨ��sql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ÿɸ��µı�
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK";
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//����ֻ��ѡ��
	doTemp.setReadOnly("SerialNo,RelativeContractNo,OrgID,UserID,OrgName,UserName",true);
	//���ò��ɼ���
	doTemp.setVisible("OrgID,UserID",false);
	//���ò��ɸ����ֶ�
	doTemp.setUpdateable("OrgName,UserName",false);
	//���ñ�����
	doTemp.setRequired("RelativeSerialNo,RelativeContractNo,OccurDate,ActualCreditSum,ActualDebitSum,OccurDirection,OccurType,TransactionFlag,OccurSubject,BackType",true);
	//��������ѡ��
	doTemp.setDDDWCode("OccurSubject","OccurSubjectName1");
	doTemp.setDDDWCode("OccurType","WasteOccurType");
	doTemp.setDDDWCode("OccurDirection","OccurDirection");
	doTemp.setDDDWCode("TransactionFlag","TransactionFlag");
	doTemp.setDDDWCode("BackType","ReclaimType");
	doTemp.setCheckFormat("OccurDate","3");
    doTemp.setType("ActualCreditSum,ActualDebitSum","Number");
	doTemp.setCheckFormat("ActualCreditSum,ActualDebitSum","2");
	doTemp.setAlign("ActualCreditSum,ActualDebitSum","3");
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform


	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
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

	//����Ϊ������������Դ����628
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/InfoManage/QuickSearch/BusinessSerialInfoList.jsp","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_WASTEBOOK";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"OccurDirection","1");
			setItemValue(0,0,"RelativeContractNo","<%=sObjectNo%>");
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
		}
    }

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

