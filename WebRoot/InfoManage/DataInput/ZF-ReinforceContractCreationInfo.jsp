<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.7
		Tester:
		Content: �������Ǻ�ͬ��Ϣ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ǻ�ͬ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������
	String sItemNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	
	//sInputFlag=G��ʾ������ͬ���룬sInputFlag=Y��ʾ������Ƚ���
	String sInputFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sInputFlag==null) sInputFlag="";
	
	//sListFlag=CAVInputCreditList��ʾ�貹�Ǻ����б��������ͬ������Ϊ�貹���Ŵ�ҵ���б��������ͬ
	String sListFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ListFlag"));
	if(sListFlag==null) sListFlag="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ReinforceContract";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 

	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20); 	//��������ҳ
	
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
	String sButtons[][] = {};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	var sObjectNo = "";    //������������

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		var sSerialNo = getItemValue(0,0,"SerialNo");		
		var	sBusinessType = getItemValue(0,0,"BusinessType");
		var	sBusinessTypeName = getItemValue(0,0,"BusinessTypeName");

		if(bIsInsert)
		{
			sBusinessTypeName = getItemValue(0,0,"BusinessTypeName");
			sOccurType = getItemValue(0,0,"OccurType");
			sCustomerID = getItemValue(0,0,"CustomerID");
			sBusinessType = getItemValue(0,0,"BusinessType");

			//ѡȡչ�ڹ����ĺ�ͬ��
			if (sOccurType=="015") 
			{
				alert("��ѡ���ҵ��������Ϊչ�ڣ���ѡ��չ�ڹ�����ҵ��");
				//ѡȡ��ͬ��
				sReturn = selectObjectInfo("BusinessContract","UserID=<%=CurUser.UserID%>~Finished=N~CustomerID="+sCustomerID+"~BusinessType=='"+sBusinessType+"'");
				if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
				sReturn = sReturn.split("@");
				sObjectNo=sReturn[0];
			}

			//ѡȡ���»��ɹ����ĺ�ͬ��
			if (sOccurType=="020") {
				alert("��ѡ���ҵ��������Ϊ���»��ɣ���ѡ����»��ɹ�����ҵ��");
				//ѡȡ��ͬ��
				sReturn = selectObjectInfo("BusinessContract","UserID=<%=CurUser.UserID%>~Finished=N~CustomerID="+sCustomerID);
				if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
				sReturn = sReturn.split("@");
				sObjectNo=sReturn[0];
			}

			//ѡȡ���������鷽��
			if (sOccurType=="030") {
				alert("��ѡ���ҵ��������Ϊ�ʲ����飬��ѡ����������鷽����");
				sReturn = selectObjectInfo("NPARefromApply","");
				if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
				sReturn = sReturn.split("@");
				sObjectNo=sReturn[0];
			}

			//ȡ����ˮ�ź���в����ʼ������
			beforeInsert();
			sSerialNo = getItemValue(0,0,"SerialNo");

			//����չ�ںͽ��»��ɹ����ĺ�ͬ��
			if (sOccurType=="015" || sOccurType=="020") {
				var sRTableName="CONTRACT_RELATIVE";
				var sRelativeType="BusinessContract";
				//���ӹ���
				sReturnValue=PopPage("/CreditManage/CreditApply/AddBusinessRelativeAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&RTableName="+sRTableName+"&RelativeType="+sRelativeType,"","");
				if (sReturnValue!="ok") return;
			}

			//�������鷽��
			if (sOccurType=="030") {
				var sRTableName="CONTRACT_RELATIVE";
				var sRelativeType="NPARefromApply";
				//���ӹ���
				sReturnValue=PopPage("/CreditManage/CreditApply/AddBusinessRelativeAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&RTableName="+sRTableName+"&RelativeType="+sRelativeType,"","");
				if (sReturnValue!="ok") return;
			}

			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	</script>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~ѡ�����Ŷ�Ⱥź����~*/
	function selectCreditLine()
	{
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(sBusinessType==""){
			alert("����ѡ��ҵ��Ʒ������!");
			return;
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(sCustomerID==""){
			alert("����ѡ��ͻ�!");
			return;
		}
		sReturn = setObjectInfo("CreditLineContract","BusinessType="+sBusinessType+"~CustomerID="+sCustomerID+"@CreditAggreement@0@TotalSum@1",0,0);
	}
	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		saveRecord("doReturn()");
	}

	function doReturn(){
		sOccurType = getItemValue(0,0,"OccurType");
		sSerialNo = getItemValue(0,0,"SerialNo");

		//���ݷ�����ʽ��������Ӧ����Ϣ
		//ѡȡչ�ںͽ��»��ɹ����ĺ�ͬ��
		if (sOccurType=="015" || sOccurType=="020") {
			//����ҵ����Ϣ
			sReturnValue=PopPage("/CreditManage/CreditApply/ExetendApplyAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectTable=BUSINESS_CONTRACT&OccurType="+sOccurType,"","");
		}
		sBusinessTypeName = getItemValue(0,0,"BusinessTypeName");
		sCustomerName = getItemValue(0,0,"CustomerName");
		parent.sObjectInfo = sSerialNo+"@"+sCustomerName+"-"+sBusinessTypeName;
		parent.doReturn();
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�

		//�ʽ���Դ(���ݿ��ֶ�FundSource) ���մ����CapitalSource
		//businesstypeΪ2060/3110ʱ020
		//businesstypeΪlike1070ʱ030
		//������Ϊ010
		sBusinessType = getItemValue(0,0,"BusinessType");
		if (sBusinessType == "2060" || sBusinessType == "3110") {
			setItemValue(0,0,"FundSource","020");
		}
		else if (sBusinessType.substr(0,4) == "1070") {
			setItemValue(0,0,"FundSource","030");
		}
		else {
			setItemValue(0,0,"FundSource","010");
		}

		//������ʽ(���ݿ��ֶ�OperateType) ���մ����OperateType
		//businesstypeΪ1060ʱ030
		//������Ϊ010
		if (sBusinessType == "1060") {
			setItemValue(0,0,"OperateType","030");
		}
		else {
			setItemValue(0,0,"OperateType","010");
		}

		bIsInsert = false;
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
	}

	/*~[Describe=�����ͻ�����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomerType()
	{
		sReturn = setObjectInfo("Code","CodeNo=CustomerType^�ͻ�����^length(ItemNo)=3@CustomerType@0",0,0);
		if(sReturn!="_CANCEL_" && typeof(sReturn)!="undefined"){
			setItemValue(0,getRow(),"CustomerID","");
			setItemValue(0,getRow(),"CustomerName","");
			setItemValue(0,getRow(),"BusinessType","");
			setItemValue(0,getRow(),"BusinessTypeName","");
		}
	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(sCustomerType==""){
			alert("����ѡ��ͻ�����!");
			return;
		}
		setObjectInfo("Customer","CustomerType=like '"+sCustomerType+"%'~CustomerBelong=All~CustomerFlag=00@CustomerID@0@CustomerName@1",0,0);
	}
	
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectBusinessType()
	{
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		sItemNo = "<%=sItemNo%>";
		sInputFlag = "<%=sInputFlag%>";
		//sInputFlag = "X";
		if(sCustomerType==""){
			alert("����ѡ��ͻ�����!");
			return;
		}
		if(sItemNo == '010')
		{
			if(sInputFlag=="G")
			{
				//��ʾ������ͬ����
			    if("<%=sListFlag%>"=="CAVInputCreditList")//������������
			    {
			        //�г�����ҵ��Ʒ��
			        setObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=N@BusinessType@0@BusinessTypeName@1",0,0);
			    }
			    else
			    {
			        //�Ŵ���������,�г�����ҵ��Ʒ��
			        setObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=G~SubTypeFlag=Y@BusinessType@0@BusinessTypeName@1",0,0);
			    }
			}
			else
			{
				//��ʾ����ҵ�����
				setObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=X@BusinessType@0@BusinessTypeName@1",0,0);
			}
		}else
		{
			//��Ȳ���
			setObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=Y@BusinessType@0@BusinessTypeName@1",0,0);
		}
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CustomerType","010");

			//��������
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			//�������
			//������
			//�Ǽǻ���
			//�Ǽ���
			//�Ǽ�����
			//��������
			
			setItemValue(0,0,"PutOutOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"ManageOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"ManageUserID","<%=CurUser.UserID%>");
			
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"PigeonholeDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"BailCurrency","01");
			
			if("<%=sItemNo%>"=="010")
			{
				setItemValue(0,0,"ReinforceFlag","010");
			}
			if("<%=sItemNo%>"=="110")
			{
				setItemValue(0,0,"ReinforceFlag","110");
			}
			
			//������������ʲ������ʼ���ս�����=060����
			if("<%=sListFlag%>"=="CAVInputCreditList")
			{
				setItemValue(0,0,"FinishType","060");
			}

			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "BC";//ǰ׺

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