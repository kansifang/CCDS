<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.are.util.SpecialTools" %>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ʾ������ҳ��
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sExampleID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleID"));
	if(sExampleID==null) sExampleID="";
	
%>
<%/*~END~*/%>

<%

String s = Sqlca.getString("select ExampleName from Example_info where ExampleID='"+sExampleID+"'");
s = SpecialTools.real2Amarsoft(s);
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ExampleInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����һ��HTMLģ��
	String sHTMLTemplate = "<table border=1 width='100%' >";
	sHTMLTemplate += "<tr height=1><td>==============��һ����==============</td></tr>";
	sHTMLTemplate += "<tr><td> ${DOCK:PART1} </td></tr>";
	sHTMLTemplate += "<tr height=1><td>==============�ڶ�����==============</td></tr>";
	sHTMLTemplate += "<tr><td> ${DOCK:PART2} </td></tr>";
	sHTMLTemplate += "<tr height=1><td>==============û�������������ֶ�==============</td></tr>";
	sHTMLTemplate += "<tr><td> ${DOCK:default} </td></tr>";
	sHTMLTemplate += "</table>";
	
	//��ģ��Ӧ����Datawindow
	dwTemp.setHarborTemplate(sHTMLTemplate);
	
	//��DW���ֶηŵ�ģ��Ĳ�λ(Dock)��
	doTemp.setColumnAttribute("ExampleID,SortNo,ExampleName,ParentExampleID,BeginDate","DockOptions","DockID=PART1");
	doTemp.setColumnAttribute("AuditUser,AuditUserName,InputUser,InputUserName,InputTime","DockOptions","DockID=PART2");
	
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
		saveRecord("goBack()");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/Frame/CodeExamples/ExampleList.jsp","_self","");
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

	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrg(sOrgID,sOrgName)
	{
		setObjectValue("SelectAllOrg","","@"+sOrgID+"@0@"+sOrgName+"@1",0,0,"");		
	}
	
	function selectUser(sUserID,sUserName)
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.OrgID%>";
		//sReturn=selectObjectValue("SelectUserBelongOrg",sParaString,"@AuditUser@0@AuditUserName@1",0,0,"");
		//alert(sReturn);
		setObjectValue("SelectUserBelongOrg",sParaString,"@"+sUserID+"@0@"+sUserName+"@1",0,0,"");
	}
	
	/*~[Describe=����ʾ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectExample()
	{
		setObjectInfo("Example","@ParentExampleID@0",0,0);
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
		var sPrefix = "";//ǰ׺

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
	//var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	setItemValue(0,getRow(),"ExampleName",amarsoft2Real("<%=s%>"));
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
