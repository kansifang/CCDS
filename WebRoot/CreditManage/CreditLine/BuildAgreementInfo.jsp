<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   lpzhang 2009-8-9
		       
		Tester:	
		Content:������¥���Э������
		Input Param:
			
			
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������¥���Э������"   ; // ��������ڱ��� <title> PG_TITLE </title>  

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "BuildAgreement";
	String sTempletFilter = "1=1";
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//���ð����ܶ�Ƚ��
	doTemp.appendHTMLStyle("LoanSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ܶ�Ƚ��(Ԫ)������ڵ���0��\" ");
		//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "0"; 
	//������׶�¼��¥���Э��
	if(!"".equals(sObjectNo))
	{
		dwTemp.setEvent("AfterInsert","!BusinessManage.InsertApplyRelative(#AgreementType,#SerialNo,"+sObjectNo+")");
	}	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+",BuildAgreement");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //����datawindow��Sql���÷���

	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{	
		if(vI_all("myiframe0"))
		{
			sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
			sMaturity = getItemValue(0,getRow(),"Maturity");
			if(sPutOutDate > sMaturity)
			{
				alert("Э��ǩ�����ڲ��ܴ���Э�鵽���գ�");
				return;
			}
			if(bIsInsert){		
				beforeInsert();
			}	
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
			
		}		
	}	
    
	</script>
	
	

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
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
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"AgreementType","BuildAgreement");
			setItemValue(0,0,"FreezeFlag","1");
		}
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");

	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getCompanyName()
	{
		setObjectValue("getCompanyName","","@CustomerID@0@CustomerName@1@CertNo@2@CertType@3@CapitalSum1@4@CapitalSum2@5",0,0,"");
		
	}
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ENT_AGREEMENT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
	
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>