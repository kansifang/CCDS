<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2009/08/14
		Tester:
		Content: ͬҵ�ͻ�������Ϣ����
		Input Param:
                CustomerID���ͻ����
                SerialNo����Ϣ��ˮ��
                EditRight��Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
                ReportDate:�����·�
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ͬҵ�ͻ�������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sSql = "";//--���sql���
    String sCreditBelong = "";//--������õȼ�����ģ����
	ASResultSet rs = null;//-- ��Ž����
	//������������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerType == null) sCustomerType = "";
	//���ҳ�������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sEditRight == null) sEditRight = "";
	String sReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportDate"));
	if(sEditRight == null) sReportDate = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CustomerFSRationInfo";
	//����ģ������
	String sTempletFilter = " (ColAttribute like '%000%' ) ";
	//ȡ�ÿͻ����õȼ�����ģ��
	sSql = "select (Case when CreditBelong is null then '' else CreditBelong end) as CreditBelong "+
		   " from ENT_INFO where CustomerID = '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCreditBelong = rs.getString("CreditBelong");	
	}
	rs.getStatement().close();
	//�������õȼ�����ģ��ȷ��ģ������
	if(sCreditBelong.equals("200"))
	{
		//��ҵ�������õȼ�������
		sTempletFilter = " (ColAttribute like '%200%' ) ";
	}else if(sCreditBelong.equals("201")){
		//���С�ũ�����������õȼ�������
		sTempletFilter = " (ColAttribute like '%201%' ) ";
	}else if(sCreditBelong.equals("202")){
		//֤ȯ��˾���õȼ�������
		sTempletFilter = " (ColAttribute like '%202%' ) ";
	}else if(sCreditBelong.equals("203")){
		//���չ�˾���õȼ�������
		sTempletFilter = " (ColAttribute like '%203%' ) ";
	}else if(sCreditBelong.equals("204")){
		//�������޹�˾���õȼ�������
		sTempletFilter = " (ColAttribute like '%204%' ) ";
	}else if(sCreditBelong.equals("205")){
		//����Ͷ�ʹ�˾���õȼ�������
		sTempletFilter = " (ColAttribute like '%205%' ) ";
	}else if(sCreditBelong.equals("206")){
		//�³�����������ڻ�����һ�����õȼ�������
		sTempletFilter = " (ColAttribute like '%206%' ) ";
	}
	//΢С��ҵ������ָ��ģ��
	if(!"0107".equals(sCustomerType))
	{
		sTempletFilter = "";
		sTempletNo = "CustomerMEntRationInfo";
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//���ù����ܼ۸�(Ԫ)��Χ
	//doTemp.appendHTMLStyle("BondSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ܼ۸�(Ԫ)������ڵ���0��\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform	
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}

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
		OpenPage("/CustomerManage/EntManage/CustomerFSRationList.jsp","_self","");
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script language=javascript>


	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=���������ʲ��ϼ�;InputParam=��;OutPutParam=��;]~*/
	function getSum1()
	{		
		sRetCapital =  getItemValue(0,getRow(),"RetCapital");
		sTotalAsset =  getItemValue(0,getRow(),"TotalAsset");
		sRetLoanCallRate =  getItemValue(0,getRow(),"RetLoanCallRate");
		sTotalDeposit =  getItemValue(0,getRow(),"TotalDeposit");
		sTotalLoan =  getItemValue(0,getRow(),"TotalLoan");
		sTaking =  getItemValue(0,getRow(),"Taking");
		sLongInvestRate =  getItemValue(0,getRow(),"LongInvestRate");
		sCapitalFullRate = sRetCapital+sTotalAsset+sRetLoanCallRate+sTotalDeposit+sTotalLoan+sTaking+sLongInvestRate;
		setItemValue(0,0,"CapitalFullRate",sCapitalFullRate);
	}
	
	/*~[Describe=����̶��ʲ��ϼ�;InputParam=��;OutPutParam=��;]~*/
	function getSum2()
	{		
		sCoreCapitalRate =  getItemValue(0,getRow(),"CoreCapitalRate");
		sOneLoanRate =  getItemValue(0,getRow(),"OneLoanRate");
		sTenLoanRate =  getItemValue(0,getRow(),"TenLoanRate");
		sBadLoanRate = sCoreCapitalRate+sOneLoanRate+sTenLoanRate;
		setItemValue(0,0,"BadLoanRate",sBadLoanRate);
	}
	
	/*~[Describe=�����ʲ��ܼ�;InputParam=��;OutPutParam=��;]~*/
	function getSum3()
	{		
		sBadLoanRate =  getItemValue(0,getRow(),"BadLoanRate");
		sPeculateCapital =  getItemValue(0,getRow(),"PeculateCapital");
		sLiquidityRate = sBadLoanRate+sPeculateCapital;
		setItemValue(0,0,"LiquidityRate",sLiquidityRate);
	}
	
	/*~[Describe=����������ծ�ϼ�;InputParam=��;OutPutParam=��;]~*/
	function getSum4()
	{		
		sAssetIncomeRate =  getItemValue(0,getRow(),"AssetIncomeRate");
		sRetIncomeRate =  getItemValue(0,getRow(),"RetIncomeRate");
		sTakeCashFluxRate =  getItemValue(0,getRow(),"TakeCashFluxRate");
		sFactRetAsset =  getItemValue(0,getRow(),"FactRetAsset");
		sSlackDistillRate =  getItemValue(0,getRow(),"SlackDistillRate");
		sBadLoanFallRate =  getItemValue(0,getRow(),"BadLoanFallRate");
		sExcessPrePayRate = sAssetIncomeRate+sRetIncomeRate+sTakeCashFluxRate+sFactRetAsset+sSlackDistillRate+sBadLoanFallRate;
		setItemValue(0,0,"ExcessPrePayRate",sExcessPrePayRate);
	}
	
	/*~[Describe=���㸺ծ�ܶ�;InputParam=��;OutPutParam=��;]~*/
	function getSum5()
	{		
		sExcessPrePayRate =  getItemValue(0,getRow(),"ExcessPrePayRate");
		sCostinComeRate =  getItemValue(0,getRow(),"CostinComeRate");
		sHoldBondRate = sExcessPrePayRate+sCostinComeRate;
		setItemValue(0,0,"HoldBondRate",sHoldBondRate);
	}
	
	/*~[Describe=����������ծ�ϼ�;InputParam=��;OutPutParam=��;]~*/
	function getSum6()
	{		
		sAssetIncomeRate =  getItemValue(0,getRow(),"AssetIncomeRate");
		sRetIncomeRate =  getItemValue(0,getRow(),"RetIncomeRate");//���ڽ��
		sTakeCashFluxRate =  getItemValue(0,getRow(),"TakeCashFluxRate");
		sFactRetAsset =  getItemValue(0,getRow(),"FactRetAsset");
		sSlackDistillRate =  getItemValue(0,getRow(),"SlackDistillRate");
		sBadLoanFallRate =  getItemValue(0,getRow(),"BadLoanFallRate");
		sInterestBackRate =  getItemValue(0,getRow(),"InterestBackRate");//��������
		sExcessPrePayRate = sAssetIncomeRate+sRetIncomeRate+sTakeCashFluxRate+sFactRetAsset+sSlackDistillRate+sBadLoanFallRate;
		setItemValue(0,0,"CapitalFullRate",sExcessPrePayRate);
		if(typeof(sInterestBackRate)!="undefined" && sInterestBackRate.length!=0)
		{
			setItemValue(0,0,"InterestMultiple",roundOff(sRetIncomeRate*100/sInterestBackRate,2));
		}
	}
	
	/*~[Describe=������ڽ��/��������;InputParam=��;OutPutParam=��;]~*/
	function getSum7()
	{		
		sRetIncomeRate =  getItemValue(0,getRow(),"RetIncomeRate");//���ڽ��
		sInterestBackRate =  getItemValue(0,getRow(),"InterestBackRate");//��������
		sRetCapitalRate=  getItemValue(0,getRow(),"RetCapitalRate");//��Ӫҵ������
		if(typeof(sInterestBackRate)!="undefined" && sInterestBackRate.length!=0)
		{
			setItemValue(0,0,"InterestMultiple",roundOff(sRetIncomeRate*100/sInterestBackRate,2));
			setItemValue(0,0,"RetassetFareRate",roundOff(sRetCapitalRate*100/sInterestBackRate,2));
		}
	}
	
	/*~[Describe=�����ʲ���ծ��;InputParam=��;OutPutParam=��;]~*/
	function getSum8()
	{		
		sHoldBondRate =  getItemValue(0,getRow(),"HoldBondRate");//��ծ�ܶ�
		sLiquidityRate =  getItemValue(0,getRow(),"LiquidityRate");//�ʲ��ܼ�
		if(typeof(sHoldBondRate)!="undefined" && sHoldBondRate.length!=0)
		{
			setItemValue(0,0,"AssetOwesRate",roundOff(sLiquidityRate*100/sHoldBondRate,2));
		}
	}
	
	/*~[Describe=��������������;InputParam=��;OutPutParam=��;]~*/
	function getSum9()
	{		
		sInterestBackRate =  getItemValue(0,getRow(),"InterestBackRate");//��������
		sRetCapitalRate=  getItemValue(0,getRow(),"RetCapitalRate");//��Ӫҵ������
		if(typeof(sInterestBackRate)!="undefined" && sInterestBackRate.length!=0)
		{
			setItemValue(0,0,"RetassetFareRate",roundOff(sRetCapitalRate*100/sInterestBackRate,2));
		}
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{		
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
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ReportDate","<%=sReportDate%>");//�����·�
			setItemValue(0,0,"UpdateDate","<%=sCreditBelong%>");
		
		}
    }
    
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_FSRATION";//����
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
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
