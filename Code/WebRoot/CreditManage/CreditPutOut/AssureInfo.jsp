<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --FMWu 2004-12-7
		Tester:
		Describe: --������ͬ��Ϣ;
		Input Param:
			ObjectType: --��������(ҵ��׶�)��
			ObjectNo: --�����ţ�����/����/��ͬ��ˮ�ţ���
			SerialNo:--������ͬ��
			sContractType��--��ͬ����
			sGuarantyType��--��������
		Output Param:

		HistoryLog:
			2005-08-07 ��ҵ� �����ؼ� 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ͬ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sContractStatus = "";//--��ͬ״̬
	String sTempletFilter = "";//--��������
	String sSql = "",sRelativeTableName="",sObjectTable="";
	ASResultSet rs=null;//--��Ž����

	//�������������������͡������š���ͬ����
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo     = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));
	if(sContractType==null) sContractType="";
	
	//���ҳ�����,��������,��ˮ��
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	if(sGuarantyType==null) sGuarantyType="";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";

	if (sObjectType.equals("GuarantyContract")) {
		sSerialNo=sObjectNo;
		sContractStatus = "020";
		sTempletFilter = " (ColAttribute like '%BC%' ) ";
	}
	else {
		//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ���������ģ����
		sSql="select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";
		rs=Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sRelativeTableName=rs.getString("RelativeTable");
			sObjectTable=rs.getString("ObjectTable");
		}
		rs.getStatement().close();
		
		//��ͬ�׶Σ���ʾ��ͬ�׶ε���Ϣ
		if (sObjectTable.equals("BUSINESS_CONTRACT")) {
			sContractStatus = "020";
			sTempletFilter = " (ColAttribute like '%BC%' ) ";
		}
		else {
			sContractStatus = "010";
			sTempletFilter = " (ColAttribute like '%BA%' ) ";
		}
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
    //����sGuarantyID��Ϊ�գ������ݿ���ȡ��������
	if (!sSerialNo.equals("")) {
		sSql="select GuarantyType from GUARANTY_CONTRACT where SerialNo='"+sSerialNo+"'";
		sGuarantyType = Sqlca.getString(sSql);
	}
	//���ݵ�������ȡ����ʾģ���
	sSql="select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo='"+sGuarantyType+"'";
	String sTempletNo = Sqlca.getString(sSql);

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//�������߶����ͬ�ڷǺ�ͬ�׶β������޸�
	if(sObjectType.equals("GuarantyContract")||(!sObjectTable.equals("BUSINESS_CONTRACT") && sContractType.equals("020"))) {
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д		
	}

	//��ͬ�׶εĵ�����ͬ���Ͳ������޸�
	if (sObjectTable.equals("BUSINESS_CONTRACT")) {
		doTemp.setReadOnly("ContractType",true);
	}
	doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
	doTemp.setHTMLStyle("GuarantyName","style={width:400px} onchange=parent.checkCustomer() ");
	doTemp.setHTMLStyle("CertID","style={width:400px} onchange=parent.getCustomerName() ");

	//����setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertGuarantyRelative(#SerialNo,GuarantyContract,"+sObjectNo+","+sRelativeTableName+")");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
		{"false","","Button","�ͻ�����","�鿴�ͻ�����","viewCustomerInfo()",sResourcesPath}
		};

	if(sObjectType.equals("GuarantyContract")) {
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "true";
	}
	//�Ǻ�ͬ�׶ε���߶����ͬ�������޸�
	if (!sObjectTable.equals("BUSINESS_CONTRACT") && sContractType.equals("020")) {
		sButtons[0][0] = "false";
	}
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
		OpenPage("/CreditManage/CreditPutOut/AssureFrame.jsp","_self","");
	}
	
	/*~[Describe=�鿴�����ͻ���������;InputParam=��;OutPutParam=��;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"GuarantorID");
		//alert(sSerialNo);
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			if (sSerialNo.length == 1)
				alert("�ͻ�����ϸ��Ϣ��");
			else
				openObject("Customer",sSerialNo,"002");
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
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
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ContractType","<%=sContractType%>");
			setItemValue(0,0,"GuarantyType","<%=sGuarantyType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ContractStatus","<%=sContractStatus%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_CONTRACT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "GC";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������		
		sReturn = setObjectValue("SelectOwner","","@GuarantyID@0@GuarantyName@1",0,0,"");
		if(sReturn != "_CANCEL_" && typeof(sReturn) != "undefined"){
			getCustomerInfo();
		}		
	}

	/*~[Describe=�õ�֤�����ͺ�֤������;InputParam=��;OutPutParam=��;]~*/
	function getCustomerInfo()
	{
		var sGuarantyID   = getItemValue(0,getRow(),"GuarantyID");

		//��ÿͻ�����
        var sColName = "CertID@CertType";
		var sTableName = "CUSTOMER_INFO";
		var sWhereClause = "String@CustomerID@"+sGuarantyID;
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array1[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array1.length;j++)
			{
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(m = 0;m < sReturnInfo.length;m++)
				{
					my_array2[m] = sReturnInfo[m];
				}
				
				for(n = 0;n < my_array2.length;n++)
				{		
					//����֤������
					if(my_array2[n] == "certtype")
						setItemValue(0,getRow(),"CertType",sReturnInfo[n+1]);
					//����֤������
					if(my_array2[n] == "certid")
						setItemValue(0,getRow(),"CertID",sReturnInfo[n+1]);
				}				
			}			
		}		
	}

	/*~[Describe=����Ƿ�����Ŀͻ����ƣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function checkCustomer()
	{
		setItemValue(0,0,"GuarantyID","")
	}

	/*~[Describe=�õ��ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		
		//��ÿͻ�����
        var sColName = "CustomerID@CustomerName";
		var sTableName = "CUSTOMER_INFO";
		var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array1[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array1.length;j++)
			{
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(m = 0;m < sReturnInfo.length;m++)
				{
					my_array2[m] = sReturnInfo[m];
				}
				
				for(n = 0;n < my_array2.length;n++)
				{									
					//���ÿͻ�ID
					if(my_array2[n] == "customerid")
						setItemValue(0,getRow(),"GuarantyID",sReturnInfo[n+1]);
					//���ÿͻ�����
					if(my_array2[n] == "customername")
						setItemValue(0,getRow(),"GuarantyName",sReturnInfo[n+1]);
				}
			}			
		}		
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
