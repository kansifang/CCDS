<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zwhu  2010-05-31
		Tester:
		Describe: ��������̨����������;
		Input Param:

		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������̨������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletNo = "";//--ģ�����
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	String sPhaseNo="";
	String sEditRight="";
	//���ҳ�������
	//����ֵת��Ϊ���ַ���
	//����������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sStateFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("StateFlag"));
	String sAccountType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AccountType"));
	String sRefromBAFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RefromBAFlag"));
	if(sRefromBAFlag == null) sRefromBAFlag="";	
	//����ֵת��Ϊ�ַ���
	if(sObjectNo == null) sObjectNo="";
	if(sObjectType == null) sObjectType="";
	if(sSerialNo == null) sSerialNo="";
	if(sStateFlag == null) sStateFlag="";
	if(sAccountType == null) sAccountType="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ��״̬
	sSql =  " select PhaseNo "+
		" from flow_object "+
		" where objectno in(select ObjectNo from BadBizApply_account where serialno='"+sSerialNo+"' )"+
		" and ObjectType='BadBizApply'  ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sPhaseNo = rs.getString("PhaseNo");
		if(sPhaseNo == null) sPhaseNo="";
		
	}
	rs.getStatement().close();
	
	if(!"0010".equals(sPhaseNo)&&!"3000".equals(sPhaseNo)&&!"".equals(sPhaseNo))
	{
		sEditRight="02";
	}
	//����ֵת��Ϊ���ַ���
	if(sTempletNo == null) sTempletNo = "";
	if("010".equals(sAccountType))
	{
		sTempletNo = "BadBizApplyAccountInfo1";
	}else if("020".equals(sAccountType))
	{
		sTempletNo = "BadBizApplyAccountInfo2";
	}else if("030".equals(sAccountType))
	{
		sTempletNo = "BadBizApplyAccountInfo3";
	}else if("040".equals(sAccountType))
	{
		sTempletNo = "BadBizApplyAccountInfo4";
	}else
	{
		sTempletNo = "BadBizApplyAccountInfo5";
	}
	//���ù�������	

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if("2".equals(sRefromBAFlag))
	{
		doTemp.setRequired("FormerManageName,BadLoanType,loanAccountNo,ClassifyResult,ISLawFlag,LastDunDate",false);
	}
	//���ó�����ѡ���
	doTemp.setHTMLStyle("OwnerName"," style={width:400px} ");	
	doTemp.setUnit("EvalOrgName"," <input type=button value=.. onclick=parent.selectEvalOrgName()>");
	doTemp.appendHTMLStyle("EvalNetValue","onChange=\"javascript:parent.setGuarantyRate()\" ");	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	
	//����setEvent
	//dwTemp.setEvent("AfterInsert","!BusinessManage.InsertGuarantyRelative("+sObjectType+","+sObjectNo+","+sContractNo+",#GuarantyID,New,Add)+!CustomerManage.AddCustomerInfo(#OwnerID,#OwnerName,#CertType,#CertID,#LoanCardNo,#InputUserID)");

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
		{"02".equals(sEditRight)?"false":"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
		self.close();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		//initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		//���֤������Ƿ���ϱ������
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sCertID = getItemValue(0,0,"CertID");//֤������
		
		if(typeof(sCertType) != "undefined" && sCertType != "" )
		{
			//�ж���֯��������Ϸ���
			if(sCertType =='Ent01')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if(!CheckORG(sCertID))
					{
						alert(getBusinessMessage('102'));//��֯������������						
						return false;
					}
				}
			}
			/*	
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if (!CheckLisince(sCertID))
					{
						alert(getBusinessMessage('156'));//���֤��������				
						return false;
					}
				}
			}
			*/
		}
		
		return true;
	}
	
	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/	
	function getBelongOrgName()
	{
		setObjectValue("SelectWholeOrg","","@BelongOrgID@0@BelongOrgName@1",0,0,"");
	}
		
	
	/*~[Describe=���ڲ�������̨��;InputParam=��;OutPutParam=��;]~*/
	function getSum1()
	{		
		sInitializeBalance =  getItemValue(0,getRow(),"InitializeBalance");
		if(typeof(sInitializeBalance) == "undefined" || sInitializeBalance == "" )
		sInitializeBalance="0";
		sInitializeBalance=parseFloat(sInitializeBalance);
		
		sMoneyReturnSum =  getItemValue(0,getRow(),"MoneyReturnSum");
		if(typeof(sMoneyReturnSum) == "undefined" || sMoneyReturnSum == "" )
		sMoneyReturnSum="0";
		sMoneyReturnSum=parseFloat(sMoneyReturnSum);
		
		sReformUpSum =  getItemValue(0,getRow(),"ReformUpSum");
		if(typeof(sReformUpSum) == "undefined" || sReformUpSum == "" )
		sReformUpSum="0";
		sReformUpSum=parseFloat(sReformUpSum);
		
		sNotReformUpSum =  getItemValue(0,getRow(),"NotReformUpSum");
		if(typeof(sNotReformUpSum) == "undefined" || sNotReformUpSum == "" )
		sNotReformUpSum="0";
		sNotReformUpSum=parseFloat(sNotReformUpSum);
		
		sPayDebtSum =  getItemValue(0,getRow(),"PayDebtSum");
		if(typeof(sPayDebtSum) == "undefined" || sPayDebtSum == "" )
		sPayDebtSum="0";
		sPayDebtSum=parseFloat(sPayDebtSum);
		
		sCVSum =  getItemValue(0,getRow(),"CVSum");
		if(typeof(sCVSum) == "undefined" || sCVSum == "" )
		sCVSum="0";
		sCVSum=parseFloat(sCVSum);
		
		sMetathesisSum =  getItemValue(0,getRow(),"MetathesisSum");
		if(typeof(sMetathesisSum) == "undefined" || sMetathesisSum == "" )
		sMetathesisSum="0";
		sMetathesisSum=parseFloat(sMetathesisSum);
		
		sOtherReturnSum =  getItemValue(0,getRow(),"OtherReturnSum");
		if(typeof(sOtherReturnSum) == "undefined" || sOtherReturnSum == "" )
		sOtherReturnSum="0";
		sOtherReturnSum=parseFloat(sOtherReturnSum);
		//���������մ��ñ���ϼ�=�����ڻ����ʽ��ջ�+�����������ϵ�+�����ڷ������ϵ�+���������ʵ�ծ+�����ں���+�������ʽ��û�+������������ʽ�ջ�
		//��ĩ��Ƿ�������=���������ʼ����-���������մ��ñ���ϼ�
		sDisposeTotalSum = sMoneyReturnSum+sReformUpSum+sNotReformUpSum+sPayDebtSum+sCVSum+sMetathesisSum+sOtherReturnSum;
		setItemValue(0,0,"DisposeTotalSum",sDisposeTotalSum);
		setItemValue(0,0,"FinalBalance",sInitializeBalance-sDisposeTotalSum);
	}
	
	
	/*~[Describe=Ʊ���û���������̨��;InputParam=��;OutPutParam=��;]~*/
	function getSum2()
	{		
		sInitializeBalance = getItemValue(0,getRow(),"InitializeBalance");
		if(typeof(sInitializeBalance) == "undefined" || sInitializeBalance == "" )
		sInitializeBalance="0";
		sInitializeBalance=parseFloat(sInitializeBalance);
		
		sMoneyReturnSum = getItemValue(0,getRow(),"MoneyReturnSum");
		if(typeof(sMoneyReturnSum) == "undefined" || sMoneyReturnSum == "" )
		sMoneyReturnSum="0";
		sMoneyReturnSum=parseFloat(sMoneyReturnSum);
		
		sPayDebtSum = getItemValue(0,getRow(),"PayDebtSum");
		if(typeof(sPayDebtSum) == "undefined" || sPayDebtSum == "" )
		sPayDebtSum="0";
		sPayDebtSum=parseFloat(sPayDebtSum);
		
		sOtherReturnSum = getItemValue(0,getRow(),"OtherReturnSum");
		if(typeof(sOtherReturnSum) == "undefined" || sOtherReturnSum == "" )
		sOtherReturnSum="0";
		sOtherReturnSum=parseFloat(sOtherReturnSum);
		//���������մ��ñ���ϼ�=�����ڻ����ʽ��ջ�+���������ʵ�ծ+������������ʽ�ջ�
		//��ĩ��Ƿ�������=���û������ʼ���-���������մ��ñ���ϼ�
		sDisposeTotalSum = sMoneyReturnSum+sPayDebtSum+sOtherReturnSum;
		setItemValue(0,0,"DisposeTotalSum",sDisposeTotalSum);
		setItemValue(0,0,"FinalBalance",sInitializeBalance-sDisposeTotalSum);
	}


	/*~[Describe=�Ѻ�����������̨��;InputParam=��;OutPutParam=��;]~*/
	function getSum3()
	{		
		sInitializeBalance = getItemValue(0,getRow(),"InitializeBalance");
		if(typeof(sInitializeBalance) == "undefined" || sInitializeBalance == "" )
		sInitializeBalance="0";
		sInitializeBalance=parseFloat(sInitializeBalance);
		
		sMoneyReturnSum = getItemValue(0,getRow(),"MoneyReturnSum");
		if(typeof(sMoneyReturnSum) == "undefined" || sMoneyReturnSum == "" )
		sMoneyReturnSum="0";
		sMoneyReturnSum=parseFloat(sMoneyReturnSum);
		
		sOtherReturnSum = getItemValue(0,getRow(),"OtherReturnSum");
		if(typeof(sOtherReturnSum) == "undefined" || sOtherReturnSum == "" )
		sOtherReturnSum="0";
		sOtherReturnSum=parseFloat(sOtherReturnSum);
		//�������ջ��Ѻ������˱���ϼ�=�����ڻ����ʽ��ջ�+������������ʽ�ջ�
		//��ĩ�Ѻ������˱������=�Ѻ������˱���-�������ջ��Ѻ������˱���ϼ�
		sDisposeTotalSum = sMoneyReturnSum+sOtherReturnSum;
		setItemValue(0,0,"DisposeTotalSum",sDisposeTotalSum);
		setItemValue(0,0,"FinalBalance",sInitializeBalance-sDisposeTotalSum);
	}
	
	
	/*~[Describe=�ʽ��û���������̨��;InputParam=��;OutPutParam=��;]~*/
	function getSum4()
	{				
		sInitializeBalance = getItemValue(0,getRow(),"InitializeBalance");
		if(typeof(sInitializeBalance) == "undefined" || sInitializeBalance == "" )
		sInitializeBalance="0";
		sInitializeBalance=parseFloat(sInitializeBalance);
		
		sMoneyReturnSum = getItemValue(0,getRow(),"MoneyReturnSum");
		if(typeof(sMoneyReturnSum) == "undefined" || sMoneyReturnSum == "" )
		sMoneyReturnSum="0";
		sMoneyReturnSum=parseFloat(sMoneyReturnSum);
		
		sReformSBSum = getItemValue(0,getRow(),"ReformSBSum");
		if(typeof(sReformSBSum) == "undefined" || sReformSBSum == "" )
		sReformSBSum="0";
		sReformSBSum=parseFloat(sReformSBSum);
		
		sOtherReturnSum = getItemValue(0,getRow(),"OtherReturnSum");
		if(typeof(sOtherReturnSum) == "undefined" || sOtherReturnSum == "" )
		sOtherReturnSum="0";
		sOtherReturnSum=parseFloat(sOtherReturnSum);
		
		//���������մ��ñ���ϼ�=�����ڻ����ʽ��ջ�+����������ת��+������������ʽ�ջ�
		//��ĩ��Ƿ�������=�ʽ��û�����������ڳ����-���������մ��ñ���ϼ�
		sDisposeTotalSum = sMoneyReturnSum+sReformSBSum+sOtherReturnSum;
		setItemValue(0,0,"DisposeTotalSum",sDisposeTotalSum);
		setItemValue(0,0,"FinalBalance",sInitializeBalance-sDisposeTotalSum);
	}
	
	
	/*~[Describe=��ծ�ʲ�;InputParam=��;OutPutParam=��;]~*/
	function getSum5()
	{		
		sInitializeBalance = getItemValue(0,getRow(),"InitializeBalance");
		if(typeof(sInitializeBalance) == "undefined" || sInitializeBalance == "" )
		sInitializeBalance="0";
		sInitializeBalance=parseFloat(sInitializeBalance);
		
		sSaleSum = getItemValue(0,getRow(),"SaleSum");
		if(typeof(sSaleSum) == "undefined" || sSaleSum == "" )
		sSaleSum="0";
		sSaleSum=parseFloat(sSaleSum);
		
		sHireSum = getItemValue(0,getRow(),"HireSum");
		if(typeof(sHireSum) == "undefined" || sHireSum == "" )
		sHireSum="0";
		sHireSum=parseFloat(sHireSum);
		
		sOtherDisposeSum = getItemValue(0,getRow(),"OtherDisposeSum");
		if(typeof(sOtherDisposeSum) == "undefined" || sOtherDisposeSum == "" )
		sOtherDisposeSum="0";
		sOtherDisposeSum=parseFloat(sOtherDisposeSum);
		
		sLostSum = getItemValue(0,getRow(),"LostSum");
		if(typeof(sLostSum) == "undefined" || sLostSum == "" )
		sLostSum="0";
		sLostSum=parseFloat(sLostSum);
		//�����ڵ�ծ�ʲ����úϼ�=�����ڵ�ծ�ʲ�����+�����ڵ�ծ�ʲ�����+�����ڵ�ծ�ʲ�������ʽ����+�����ڵ�ծ�ʲ�������ʧ
		//��ĩ����ծ�ʲ��������=��ծ�ʲ������ʼ���-�����ڵ�ծ�ʲ����úϼ�
		sDisposeTotalSum = sSaleSum+sHireSum+sOtherDisposeSum+sLostSum;
		setItemValue(0,0,"DisposeTotalSum",sDisposeTotalSum);
		setItemValue(0,0,"FinalAccountBalance",sInitializeBalance-sDisposeTotalSum);
	}
	
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");
			setItemValue(0,0,"AccountType","<%=sAccountType%>");
			setItemValue(0,getRow(),"RefromBAFlag","<%=sRefromBAFlag%>");
			bIsInsert = true;			
		}
		
    }
	
	        
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BADBIZ_ACCOUNT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetGuarantyID.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"SerialNo",sSerialNo);		
					
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
