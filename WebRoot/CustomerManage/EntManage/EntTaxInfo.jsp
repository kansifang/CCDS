<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29  ndeng 2004-11-30
		Tester:
		Describe: ��˰��Ϣ
		Input Param:
			CustomerID����ǰ�ͻ����
			SerialNo����Ϣ��ˮ��
			EditRight��Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��˰��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null ) sCustomerID = "";
	
	//���ҳ�����	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sEditRight     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
  	if(sSerialNo == null ) sSerialNo = "";
  	if(sEditRight == null ) sEditRight = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CustomerTaxInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//������˰��Ԫ����Χ
	doTemp.appendHTMLStyle("TaxSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��˰��Ԫ��������ڵ���0��\" ");
	
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
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntTaxList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntTaxInfo.jsp","_self","");
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

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		//У��ͳ�ƽ�ֹ�����Ƿ���ڵ�ǰ����
		sUpToDate = getItemValue(0,0,"UPTODATE");//ͳ�ƽ�ֹ����
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����		
		if(typeof(sUpToDate) != "undefined" && sUpToDate != "" )
		{
			if(sUpToDate >= sToday)
			{		    
				alert(getBusinessMessage('144'));//ͳ�ƽ�ֹ���ڱ������ڵ�ǰ���ڣ�
				return false;		    
			}
		}
		
		//У����˰�����Ƿ���ڵ�ǰ����
		sTaxPayingDate = getItemValue(0,0,"TaxPayingDate");//��˰����
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����		
		if(typeof(sTaxPayingDate) != "undefined" && sTaxPayingDate != "" )
		{
			if(sTaxPayingDate >= sToday)
			{		    
				alert(getBusinessMessage('168'));//��˰���ڱ������ڵ�ǰ���ڣ�
				return false;		    
			}
		}		
		
		sBeginDate = getItemValue(0,getRow(),"BeginDate");//���俪ʼ����			
		sEndDate = getItemValue(0,getRow(),"EndDate");//�����������
		
		if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
		{
			if(typeof(sEndDate)!="undefined" && sEndDate.length > 0)
			{
				if(sEndDate <= sBeginDate)
				{		    
					alert(getBusinessMessage('169'));//����������ڱ����������俪ʼ���ڣ�
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
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_TAXPAYING";//����
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
