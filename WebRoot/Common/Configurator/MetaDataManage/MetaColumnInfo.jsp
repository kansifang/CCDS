<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
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
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql;
	//����������

	//���ҳ�����	
	String sDatabaseID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DatabaseID"));
	String sTableID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TableID"));
	String sColumnID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColumnID"));
	if(sDatabaseID==null) sDatabaseID="";
	if(sTableID==null) sTableID="";
	if(sColumnID==null) sColumnID="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		//ͨ����ʾģ�����ASDataObject����doTemp
	   	String sHeaders[][] = {
			{"DatabaseID","���ݿ�ID"},	
			{"TableID","��ID"},
			{"ColID","�ֶ���"},
			{"ColName","�ֶ�������"},
			{"IsInUse","��Ч"},
			{"SortNo","�����"},
			{"ColType","�ֶ�����"},
			{"DomainID","������"},
			{"DefaultValue","ȱʡֵ"},
			{"CheckFormat","����ʽ"},
			{"ValidationType","У������"},
			{"ValidationCode","У�����"},
			{"ColLimit","��������"},
			{"ColKey","�Ƿ�ؼ���"},
			{"IsForeignKey","�Ƿ����"},
			{"DataPrecision","��Чλ��"},
			{"DataScale","С�����λ��"},
			{"Attribute1","����1"},
			{"Attribute2","����2"},
			{"Attribute3","����3"},
			{"Attribute4","����4"},
			{"Attribute5","����5"},
		       };  

		sSql = " Select  "+
			"DatabaseID,"+
			"TableID,"+
			"ColID,"+
			"ColName,"+
			"IsInUse,"+
			"SortNo,"+
			"ColType,"+
			"DomainID,"+
			"DefaultValue,"+
			"CheckFormat,"+
			"ValidationType,"+
			"ValidationCode,"+
			"ColLimit,"+
			"ColKey,"+
			"IsForeignKey,"+
			"DataPrecision,"+
			"DataScale,"+
			"Attribute1,"+
			"Attribute2,"+
			"Attribute3,"+
			"Attribute4,"+
			"Attribute5 "+
			"From META_COLUMN Where DatabaseID='"+sDatabaseID+"' and TableID='"+sTableID+"' and ColID='"+sColumnID+"'";
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.UpdateTable="META_COLUMN";
		doTemp.setKey("DatabaseID,TableID,ColID",true);
		doTemp.setHeader(sHeaders);

		//������
	 	doTemp.setRequired("DatabaseID,TableID,ColID,ColName",true);

		doTemp.setDDDWCode("IsInUse","IsInUse");
		doTemp.setDDDWSql("DatabaseID","select distinct DatabaseID,DatabaseName from META_DATABASE");
		doTemp.setDDDWSql("TableID","select distinct TableID,TableName from META_TABLE");

		doTemp.setHTMLStyle("DatabaseID"," style={width:360px} ");
		doTemp.setHTMLStyle("TableID"," style={width:360px} ");
		doTemp.setHTMLStyle("ColID"," style={width:360px} ");
		doTemp.setHTMLStyle("ColName"," style={width:360px} ");
		doTemp.setHTMLStyle("IsInUse"," style={width:360px} ");
		doTemp.setHTMLStyle("SortNo"," style={width:360px} ");
		doTemp.setHTMLStyle("ColType"," style={width:360px} ");
		doTemp.setHTMLStyle("DomainID"," style={width:360px} ");
		doTemp.setHTMLStyle("DefaultValue"," style={width:360px} ");
		doTemp.setHTMLStyle("CheckFormat"," style={width:360px} ");
		doTemp.setHTMLStyle("ValidationType"," style={width:360px} ");
		doTemp.setHTMLStyle("ValidationCode"," style={width:360px} ");
		doTemp.setHTMLStyle("ColLimit"," style={width:360px} ");
		doTemp.setHTMLStyle("ColKey"," style={width:360px} ");
		doTemp.setHTMLStyle("IsForeignKey"," style={width:360px} ");
		doTemp.setHTMLStyle("DataPrecision"," style={width:360px} ");
		doTemp.setHTMLStyle("DataScale"," style={width:360px} ");
		doTemp.setHTMLStyle("Attribute1"," style={width:260px} ");
		doTemp.setHTMLStyle("Attribute2"," style={width:260px} ");
		doTemp.setHTMLStyle("Attribute3"," style={width:260px} ");
		doTemp.setHTMLStyle("Attribute4"," style={width:260px} ");
		doTemp.setHTMLStyle("Attribute5"," style={width:260px} ");

		//����С����ʾ״̬,
		doTemp.setAlign("DataPrecision,DataScale","3");
		doTemp.setType("DataPrecision,DataScale","Number");
		//С��Ϊ2������Ϊ5
		doTemp.setCheckFormat("DataPrecision,DataScale","2");

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sDatabaseID+","+sTableID+","+sColumnID);
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		session.setAttribute(dwTemp.Name,dwTemp);
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
%>
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
			{"true","","Button","���沢����","���������޸�,�������б�ҳ��","saveAndGoBack()",sResourcesPath},
			// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
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
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>

	<script language=javascript>

	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Frame/CodeExamples/ExampleInfo.jsp","_self","");
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

	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser(sParam,sUserID,sUserName,sOrgID,sOrgName)
	{
		setObjectInfo("User","OrgID="+sParam+"@"+sUserID+"@0@"+sUserName+"@1@"+sOrgID+"@2@"+sOrgName+"@3",0,0);
		/*
		* setObjectInfo()����˵����---------------------------
		* ���ܣ� ����ָ�������Ӧ�Ĳ�ѯѡ��Ի��򣬲������صĶ������õ�ָ��DW����
		* ����ֵ�� ���硰ObjectID@ObjectName���ķ��ش��������ж�Σ����硰UserID@UserName@OrgID@OrgName��
		* sObjectType�� ��������
		* sValueString��ʽ�� ������� @ ID���� @ ID�ڷ��ش��е�λ�� @ Name���� @ Name�ڷ��ش��е�λ��
		* iArgDW:  �ڼ���DW��Ĭ��Ϊ0
		* iArgRow:  �ڼ��У�Ĭ��Ϊ0
		* ��������� common.js -----------------------------
		*/
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrg(sOrgID,sIDColumn,sNameColum)
	{
		setObjectInfo("Org","OrgID="+sOrgID+"@"+sIDColumn+"@0@"+sNameColum+"@1",0,0);
		/*
		* setObjectInfo()����˵����---------------------------
		* ���ܣ� ����ָ�������Ӧ�Ĳ�ѯѡ��Ի��򣬲������صĶ������õ�ָ��DW����
		* ����ֵ�� ���硰ObjectID@ObjectName���ķ��ش��������ж�Σ����硰UserID@UserName@OrgID@OrgName��
		* sObjectType�� ��������
		* sValueString��ʽ�� ������� @ ID���� @ ID�ڷ��ش��е�λ�� @ Name���� @ Name�ڷ��ش��е�λ��
		* iArgDW:  �ڼ���DW��Ĭ��Ϊ0
		* iArgRow:  �ڼ��У�Ĭ��Ϊ0
		* ��������� common.js -----------------------------
		*/
	}
	
	function selectAgency()
	{
		alert("1");
		sReturn=selectObjectInfo("Agency","@AuditUser@0@AuditUserName@1",0,0);
		alert(sReturn);
	}
	
	/*~[Describe=����ʾ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectExample1()
	{
		setObjectInfo("Example","@ParentExampleID@0",0,0);
	}
	function selectExample()
	{
	setObjectInfo("code","code=YesOrNo@ParentExampleID@0",0,0);
	}


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
		
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "EXAMPLE_INFO";//����
		var sColumnName = "ExampleID";//�ֶ���
		var sPrefix = "EP";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
