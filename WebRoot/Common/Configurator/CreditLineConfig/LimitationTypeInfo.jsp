<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:          cjiang    2005-8-1 23:59
			Tester:
			Content:         ������������
			Input Param:     sExampleID
			Output param:
			History Log: 

		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "������������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	
	//����������

	//���ҳ�����	
	String sTypeID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeID"));
	if(sTypeID==null) sTypeID="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][]={ {"TypeID","��������ID"},
			      {"TypeName","��������˵��"},
			      {"CheckerClass","���Ƽ��������"},
			      {"LimitationExpr","�����ж�Script"},
			      {"CompileCheckExpr","�޶�����У��Script"},
			      {"ControlType","���Ʒ�ʽ"},
			      {"ObjectType","���ƶ�������"},
			      {"CrossUsageEnabled","�Ƿ���"},
			      {"LimitationComp","�������������ID"},
			      {"LimitationWizard","����������Wizrd"}
			    };	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sSql="select TypeID , TypeName , CheckerClass , LimitationExpr ,"+
	             " CompileCheckExpr , ControlType , ObjectType , " +
	             " CrossUsageEnabled , LimitationComp , LimitationWizard "+
	             " from CL_LIMITATION_TYPE where TypeID='"+sTypeID+"'" ;
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="CL_LIMITATION_TYPE";
	doTemp.setKey("TypeID",true);
	doTemp.setDDDWCode("ControlType","ControlType");
	doTemp.setDDDWCode("CrossUsageEnabled","YesNo");
	doTemp.setDDDWSql("ObjectType","select ObjectType , ObjectName from  objecttype_catalog");
	doTemp.setEditStyle("LimitationExpr","3");
	doTemp.setHTMLStyle("LimitationExpr","style={height=100px;width=400px;overflow=scroll}");
	doTemp.setLimit("LimitationExpr",1600);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//ASDataWindow dwTemp = new ASDataWindow("EntList",doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
			{"true","","Button","���沢����","���沢����һ����¼","saveAndNew()",sResourcesPath},
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
		if(typeof(sPostEvents)!="undefined" && sPostEvents!="") sPostEvents = "reloadCache();parent."+sPostEvents;
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
		OpenPage("/Common/Configurator/CreditLineConfig/LimitationTypeList.jsp","_self","");
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
	function reloadCache(){
    	if(confirm("���ѶԶ���������ͽ������޸ģ�����ˢ�¶���������Ͷ��建����"))
    		PopPage("/Common/ToolsB/reloadCacheConfig.jsp?ConfigName=SYSCONF_LIMITATIONTYPE","","");
    }
	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/CreditLineConfig/LimitationTypeInfo.jsp","_self","");
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
