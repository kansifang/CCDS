<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: bliu 2004-12-02 
		Tester:
		Describe: ��������ϸ��Ϣ
		Input Param:
			SerialNo:	��ˮ��
		Output Param:

		HistoryLog:	slliu 2004.12.17
					ndeng 2004.12.23
					zywei 2005/09/07 �ؼ����
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	  
    String sHeaders[][] = { 							
							{"AgentName","����������"},				
							{"PersonType","����������"},
							{"BelongAgency","�����������"},
							{"SelfOrgName","�������д������"},					
							{"PractitionerTime","��ҵʱ��"},				
							{"CompetenceNo","�ʸ�֤���"},
							{"PersistNo","ִҵ֤���"},
							{"Age","����"},
							{"Degree","ѧ��"},
							{"Specialty","ר��"},
							{"TypicalCase","���Ͱ���"},
							{"RelationMode","��ϵ��ʽ"},
							{"OrgName","����ְ�Ĵ������"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},				
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"},
							{"Remark","��ע"}								
						}; 
	
	String sSql =  " select SerialNo,AgentName,AgentType,PersonType,BelongAgency,BelongNo,SelfOrgName, "+
				   " PractitionerTime,CompetenceNo,PersistNo,Age,Degree,Specialty,TypicalCase,RelationMode, "+		   	  
				   " OrgName,Remark,InputUserID,getUserName(InputUserID) as InputUserName,InputOrgID, " +   
				   " getOrgName(InputOrgID) as InputOrgName,InputDate,UpdateDate" +
				   " from AGENT_INFO "+
				   " where SerialNo = '"+sSerialNo+"'";
	
	//����Sql���ɴ������	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "AGENT_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo,BelongNo,InputUserID,InputOrgID,AgentType,SelfOrgName",false);
	//��������
	doTemp.setType("Age","Number");
	doTemp.setCheckFormat("Age","5");
	//������Ӵ�����ȡ��ֵ
	doTemp.setDDDWCode("AgentType","AgentType1");
	doTemp.setDDDWCode("PersonType","PersonType1");
	doTemp.appendHTMLStyle("PractitionerTime"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
	doTemp.setUnit("PractitionerTime","��");
	doTemp.setAlign("PractitionerTime","3");
	//ѡ�����������������
	doTemp.setUnit("BelongAgency"," <input type=button class=inputDate  value=... name=button onClick=\"javascript:parent.getAgencyName()\">");
	doTemp.appendHTMLStyle("BelongAgency","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getAgencyName()\" ");
	//����ֻ������
	doTemp.setReadOnly("InputOrgName,InputUserName,InputDate,UpdateDate,BelongAgency",true);
	
	//���ó���
	doTemp.setLimit("Remark,RelationMode",200);
	doTemp.setLimit("TypicalCase",100);
	doTemp.setLimit("OrgName",100);
	doTemp.setLimit("CompetenceNo,PersistNo,AgentName",32);
	//���ñ༭��ʽ����ı���
	doTemp.setEditStyle("TypicalCase","3");
	doTemp.setEditStyle("Remark","3");
	doTemp.setEditStyle("OrgName","3");
	
	doTemp.setHTMLStyle("InputDate,UpdateDate,InputOrgName,InputUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("RelationMode,Specialty"," style={width:300px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	doTemp.setRequired("SerialNo,PersonType,AgentName,AgentType",true);
	
	doTemp.setCheckFormat("UpdateDate","3");
	//���ÿɸ����ֶ�
	doTemp.setUpdateable("InputOrgName,InputUserName",false);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
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
	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/Public/AgentList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ѡ������������;InputParam=��;OutPutParam=��;]~*/
	function getAgencyName()
	{
		var sParaString = "AgencyType"+","+"02";
		setObjectValue("SelectAgency",sParaString,"@BelongNo@0@BelongAgency@1",0,0,"");	
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			
			setItemValue(0,0,"AgentType","02");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");			
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "AGENT_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
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
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
