<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   XWu  2004.11.29
		Tester:
		Content: �ͻ�����ծȯ��Ϣ
		Input Param:
                CustomerID���ͻ����
                SerialNo����Ϣ��ˮ��
                EditRight��Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�����ծȯ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//������������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//���ҳ�������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sEditRight == null) sEditRight = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CustomerBondInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//���ù����ܼ۸�(Ԫ)��Χ
	doTemp.appendHTMLStyle("BondSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ܼ۸�(Ԫ)������ڵ���0��\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform	
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sSerialNo);
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
		{(sEditRight.equals("02")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;	
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntHoldBondList.jsp","_self","");
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script language=javascript>

	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntHoldBondInfo.jsp","_self","");	
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		//У��ͳ�ƽ�ֹ�����Ƿ���ڵ�ǰ����
		sUpToDate = getItemValue(0,0,"UptoDate");//ͳ�ƽ�ֹ����
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����		
		if(typeof(sUpToDate) != "undefined" && sUpToDate != "" )
		{
			if(sUpToDate >= sToday)
			{		    
				alert(getBusinessMessage('144'));//ͳ�ƽ�ֹ���ڱ������ڵ�ǰ���ڣ�
				return false;		    
			}
		}
		
		//У��ծȯ��ʼ���ں�ծȯ��������֮���ҵ���߼���ϵ
		sBeginDate = getItemValue(0,getRow(),"BeginDate");//ծȯ��ʼ����			
		sEndDate = getItemValue(0,getRow(),"EndDate");//ծȯ��������	
		
		if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
		{			
			if(sBeginDate >= sToday)
			{		    
				alert(getBusinessMessage('165'));//ծȯ��ʼ���ڱ������ڵ�ǰ���ڣ�
				return false;		    
			}
			
			if(sBeginDate >= sUpToDate)
			{		    
				alert(getBusinessMessage('167'));//ծȯ��ʼ���ڱ�������ͳ�ƽ�ֹ���ڣ�
				return false;		    
			}
			
			if(typeof(sEndDate)!="undefined" && sEndDate.length > 0)
			{
				if(sEndDate <= sBeginDate)
				{		    
					alert(getBusinessMessage('166'));//ծȯ�������ڱ�������ծȯ��ʼ���ڣ�
					return false;		    
				}
			}	
		}
		return true;
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		
		}
    }
    
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_BOND";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=����ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getMonth(sObject)
	{
		sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
		if(typeof(sReturnMonth) != "undefined")
		{
			setItemValue(0,0,sObject,sReturnMonth);
		}
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
