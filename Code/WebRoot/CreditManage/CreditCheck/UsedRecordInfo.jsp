<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: ��������¼;
		
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ÿ��¼"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//����������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sItemNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sHeaders[][] = { {"AccountNo","�ͻ��˺�"},
							{"Currency","����"}, 
							{"ItemName","�Է��û���"},
							{"ItemAccountNo","�Է��˺�"},
							{"ItemDate","��������"},
							{"ItemSum","���׽��"},
							{"Balance","�ʻ����"}, 
							{"ItemDescribe","ժҪ����"},
							{"ItemContent","ƾ֤��"}
						  };
	String sSql="select SerialNo,ItemNo,ObjectType,objectno,ItemType,AccountNo,Currency,ItemName,ItemAccountNO,"+
	            " ItemDate,ItemSum,Balance,ItemDescribe,ItemContent  "+
	            " from INSPECT_DETAIL where SerialNo='"+sSerialNo+
	            "' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' and ItemNo='"+sItemNo+"'";
    //sql����doTemp����
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ùؼ���
	doTemp.setKey("SerialNo,ItemNo,ObjectType,objectno",true);
	//���ÿɸ��µı�
	doTemp.UpdateTable = "INSPECT_DETAIL";
	
	doTemp.setType("ItemSum,Balance","Number");//����������
	doTemp.setCheckFormat("ItemSum,Balance","2");//���������ʽ�������ŵ�Ǯ��d
	doTemp.setAlign("ItemSum,Balance","3");
	doTemp.setCheckFormat("ItemDate","3");//���������ʽ������ѡ��ť
	doTemp.setVisible("SerialNo,ItemNo,ObjectType,objectno,ItemType",false);
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setDefaultValue("Currency","01");
	doTemp.setDefaultValue("ItemDate",StringFunction.getToday());
	doTemp.setRequired("AccountNo,Currency,ItemName,ItemAccountNo,ItemDate,ItemSum",true);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
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
		{"true","","Button","���沢����","��������¼������","saveRecord()",sResourcesPath}
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

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		as_save("myiframe0","goBack()");
	}
	function goBack()
	{
		OpenPage("/CreditManage/CreditCheck/UsedRecordList.jsp?SerialNo=<%=sSerialNo%>&rand="+randomNumber(),"_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0)
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ItemType","02");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"objectno","<%=sObjectNo%>");
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");

		}
    }
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "INSPECT_DETAIL";//����
		var sColumnName = "ItemNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntStockInfo.jsp","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
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

