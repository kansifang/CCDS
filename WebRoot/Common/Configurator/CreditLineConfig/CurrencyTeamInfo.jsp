<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-29 
		Tester:
		Content: ���ַ�����Ϣ����
		Input Param:
			CLTeamID�����ַ�����
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ַ�����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sCLTeamID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CLTeamID"));
	if(sCLTeamID == null) sCLTeamID = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][]={ 
						{"CLTeamID","���ַ�����"},
					    {"CLTeamName","���ַ�������"},
					    {"CLTeamContentName","���ַ�������"},
					    {"CLTeamLimit","���ַ�����������"},
					    {"CLTeamRelaObj","���ַ����������"},
					    {"IsInUse","�Ƿ���Ч"},
					    {"InputUserName","�Ǽ���"},
					    {"InputOrgName","�Ǽǻ���"},
					    {"InputTime","�Ǽ�ʱ��"},
					    {"UpdateTime","����ʱ��"}
					    };	
	
	String sSql = " select CLTeamID,CLTeamName,CLTeamType,CLTeamContentID,CLTeamContentName,CLTeamLimit, "+
	              " CLTeamRelaObj,IsInUse,InputUser,getUserName(InputUser) as InputUserName,InputOrg, "+
	              " getOrgName(InputOrg) as InputOrgName,InputTime,UpdateUser,UpdateTime "+	             
	              " from CL_TEAM "+
	              " where CLTeamID = '"+sCLTeamID+"' ";
	              
	//����Sql�������ݶ���DataObject 
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ���
	doTemp.setHeader(sHeaders);
	//���ñ���������
	doTemp.UpdateTable="CL_TEAM";
	doTemp.setKey("CLTeamID",true);
	//������������ʾ����
	doTemp.setDDDWCode("IsInUse","IsInUse");
	//���ñ�����
   	doTemp.setRequired("CLTeamName,CLTeamContentName,IsInUse",true);
	//���ò��ɼ���	
	doTemp.setVisible("CLTeamID,CLTeamType,CLTeamContentID,InputUser,InputOrg,UpdateUser",false);
	//���ò��ɸ�����
	doTemp.setUpdateable("InputUserName,InputOrgName",false);
	//����ֻ����
	doTemp.setReadOnly("InputUserName,InputOrgName,InputTime,UpdateTime",true);
	//���ô��ı�����
	doTemp.setEditStyle("CLTeamContentName,CLTeamLimit","3");
	doTemp.setHTMLStyle("CLTeamContentName,CLTeamLimit"," style={width:400px;height:200px;overflow:auto} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
	//���õ���ʽѡ�񴰿�
	doTemp.setUnit("CLTeamContentName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectCurrency();\"> ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","���沢����","���������޸�,�������б�ҳ��","saveAndGoBack()",sResourcesPath},
		{"true","","Button","���沢����","���沢����һ����¼","saveAndNew()",sResourcesPath}
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
		//��ñ��ַ�������(��Ҫ�Ǳ��ַ�����ʾ��־)
		sCLTeamContentName = getItemValue(0,getRow(),"CLTeamContentName");
		sCLTeamContentName.replace("/r/n","//r//n");
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
		OpenPage("/Common/Configurator/CreditLineConfig/CurrencyTeamList.jsp","_self","");
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
		OpenPage("/Common/Configurator/CreditLineConfig/CurrencyTeamInfo.jsp","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�		
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");		
		setItemValue(0,0,"UpdateTime",sNow);
	}
	
	/*~[Describe=ѡ�����;InputParam=��;OutPutParam=��;]~*/
	function selectCurrency()
	{
		sReturnValue = PopPage("/Common/Configurator/CreditLineConfig/AddCurrencyDialog.jsp?CLTeamID=<%=sCLTeamID%>","","dialogWidth=35;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "@" && sReturnValue != "_none_")
		{
		 	sReturnValue = sReturnValue.split("@");		 	
		 	setItemValue(0,getRow(),"CLTeamContentID",sReturnValue[0]);
		 	setItemValue(0,getRow(),"CLTeamContentName",sReturnValue[1]);		 	
		 	
		}		
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
			setItemValue(0,0,"CLTeamType","CurrencyTeam");
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime",sNow);
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CL_TEAM";//����
		var sColumnName = "CLTeamID";//�ֶ���
		
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
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
