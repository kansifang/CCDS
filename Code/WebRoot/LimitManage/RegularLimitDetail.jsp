<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:Thong 2005.8.29 16:15
		Tester:
		Content: ����޶�����
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����޶�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	String sTempletFilter = "";
	//����������
	
	//���ҳ�����	
	String sExampleID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleID"));
	if(sExampleID==null) sExampleID="";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ��Sql����ASDataObject����doTemp
	
	
	String sHeaders[][] = { 
				{"LimitType","�޶�����"},
				{"TotalSum","�����ʱ���ֵ(Ԫ)"},
				{"Limit","��һ�ͻ�����޶�(Ԫ)"},
				{"ActualLimit","���ſͻ�����޶�(Ԫ)"},
				{"BeginDate","��Ч����"},
				{"EndDate","ʧЧ����"},
				{"Useflg","�Ƿ�ʹ��"},
				{"UserName","������Ա"},
				{"OrgName","����"},
				{"InputDate","�Ǽ�����"}
			       };   				   			       
	sTempletFilter = "1=1";
	sSql = "select SerialNo,LimitType,TotalSum,Limit,ActualLimit,BeginDate,EndDate,Useflg"+
			",UserID,getUserName(UserID) as UserName,OrgID,getOrgName(OrgID) as OrgName,InputDate "
			+" from LIMIT_INFO where SerialNo='"+sSerialNo+"'";
			
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LIMIT_INFO";
	
	doTemp.setKey("SerialNo",true);
	doTemp.setUpdateable("OrgName,UserName",false);			
	doTemp.setVisible("SerialNo,OrgID,UserID",false);
	doTemp.setRequired("TotalSum,BeginDate,EndDate,Useflg",true);
		
	doTemp.setAlign("TotalSum,Limit,ActualLimit","3");
	doTemp.setCheckFormat("TotalSum,Limit,ActualLimit","2");
	
	doTemp.setDDDWCode("Useflg","YesOrNo");
	doTemp.setAlign("BeginDate,EndDate,InputDate", "2");
    doTemp.setCheckFormat("BeginDate,EndDate,InputDate","3");
    doTemp.setReadOnly("LimitType,Limit,ActualLimit,InputDate,UserName,OrgName",true);
  	
    doTemp.setHTMLStyle("BeginDate,EndDate"," style={width:80px} ");
   	doTemp.setHTMLStyle("UserName,InputDate,InputDate"," style={color:#848284;width:80px} ");
   	doTemp.setHTMLStyle("TotalSum"," onBlur=\"javascript:parent.caculateRegularLimit()\" ");
   		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
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
		{"true","","Button","���沢����","���������޸�,�������б�ҳ��","saveAndGoBack()",sResourcesPath},
		{"true","","Button","���沢����","���沢����һ����¼","saveAndNew()",sResourcesPath},
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
		initSerialNo();
		saveRecord("goBack()");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/LimitManage/RegularLimitList.jsp","_self","");
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
		OpenPage("/LimitManage/RegularLimitDetail.jsp","_self","");
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
	function selectExample()
	{
		setObjectInfo("Example","@ParentExampleID@0",0,0);
	}
	/*~[Describe=��һ�����Ų�ͬ�޶��������;InputParam=��;OutPutParam=��;]~*/
	function caculateRegularLimit()
	{
		sTotalSum= getItemValue(0,0,"TotalSum");
		sLimit = sTotalSum * 0.1;
		//alert(sLimit);
		sActualLimit = sTotalSum * 0.15;
		setItemValue(0,0,"Limit",sLimit);
		setItemValue(0,0,"ActualLimit",sActualLimit);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		 	setItemValue(0,0,"LimitType","����޶�");
		 	setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");			
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "Limit_Info";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "RL";//ǰ׺

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
