<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui  2003.8.18
		Tester:
		Content: ��ҵծȯ������Ϣ_List
		Input Param:
			                CustomerID���ͻ����
			                CustomerRight:Ȩ�޴���----01�鿴Ȩ��02ά��Ȩ��03����ά��Ȩ
		Output param:
		                CustomerID����ǰ�ͻ�����Ŀͻ���
		              	Issuedate:��������
		              	BondType:ծȯ����
		                CustomerRight:Ȩ�޴���
		                EditRight:�༭Ȩ�޴���----01�鿴Ȩ��02�༭Ȩ
		History Log: 
		                 2003.08.20 CYHui
		                 2003.08.28 CYHui
		                 2003.09.08 CYHui 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ʾ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String AlertID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertID"));
	if(AlertID==null) AlertID="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ExampleInfo";
	String sTempletFilter = "1=1";
	String sSql = "select SerialNo,ObjectType,ObjectNo,GetObjectName(ObjectType,ObjectNo) as ObjectName,AlertType,AlertTip,AlertDescribe,OccurDate,OccurTime,UserID,OrgID,OccurReason,Treatment,EndTime,Remark,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime from ALERT_LOG where SerialNo='"+AlertID+"'";
	String[][] sHeaders = {
		{"Treatment","������"},
		{"EndTime","�����������"},
		};
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="ALERT_LOG";
	doTemp.setKey("SerialNo",true);
	doTemp.setUpdateable("ObjectName",false);

	doTemp.setDDDWSql("ObjectType","select ObjectType,ObjectName from OBJECTTYPE_CATALOG where ObjectType in('Customer','Individual','BusinessContract')");
	doTemp.setVisible("SerialNo,ObjectType,ObjectName,ObjectNo,AlertType,AlertTip,OccurDate,AlertDescribe,UserID,OrgID,OccurTime,OccurReason,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime,Remark",false);

	//doTemp.setDDDWCode("AlertType","AlertSignal");
	doTemp.setUnit("AlertTip"," <input type=button value=\"..\" class=inputDate onClick=\"javascript:parent.setObjectInfo(\\'Code\\',\\'CodeNo=AlertSignal@AlertType@0@AlertTip@1\\')\"> ");
	doTemp.setEditStyle("Treatment","3");
	doTemp.setCheckFormat("EndTime","3");
	doTemp.setReadOnly("AlertTip",true);
	doTemp.setRequired("EndTime,Treatment",true);

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
		{"true","","Button","ȷ��","ȷ��","saveAndGoBack()",sResourcesPath},
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
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	
	/*~[Describe=���������޸�,�������б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function saveAndGoBack()
	{
		if(!confirm("��ȷ��Ҫ���ñʾ�ʾ��Ϣ���Ϊ���Ѵ�����ɡ���\n����Ϣ����ʾ�ڡ��Ѵ����Ԥ����Ϣ�������С�")) return;
		saveRecord("goBack()");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}

	/*~[Describe=���沢����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function saveAndNew()
	{
		saveRecord("newRecord()");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditAlarm/AlertInfo.jsp?AlertID=new","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputTime",sNow);
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}

	function chooseObject(sValueString){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(sObjectType==null || sObjectType=="")
		{
			alert("����ѡ����ض�������");
			return;
		}
		setObjectInfo(sObjectType,sValueString);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
		if(getItemValue(0,0,"EndTime")=="") setItemValue(0,0,"EndTime","<%=StringFunction.getToday()%>");
		
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ALERT_LOG";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "AL";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
