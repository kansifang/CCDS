<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2009/09/21
		Tester:
		Content: �����ʲ��ճ������ر�������
		Input Param:
			sObjectNo    :��������(�������)
			sSerialNo    :ȡ��ˮ��
			DealType:��ͼ�ڵ��
		Output param:

		History Log: 

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ��ճ������ر�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//������� �Ƿ�ɱ༭
	String sEditRight="02";//Ĭ�ϲ��ɱ༭
	//��ͬ��š��ͻ�ID,�ͻ�����,��ͬ��
	String  sCustomerID = "",sCustomerName = "",sContractSerialNo = "";
	String sBusinessType = "",sBusinessCurrency = "",sOriginalPutoutDate = "";
	String sMaturity = "",sReportType = "",sBadType = "";
	double dBalance = 0.00,dInterestBalance1 = 0.00,dInterestBalance2 = 0.00;
	//��ȡ����
	//�������ݼ�
	String sSql="";
	ASResultSet rs=null;
	
	//����������	
	
	//���ҳ�����:������ˮ��,������ˮ��,��ͼ�ڵ�
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo")); 
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 
	String sDealType =  DataConvert.toRealString(iPostChange,(String)request.getParameter("DealType")); 
	String sFinishDate =  DataConvert.toRealString(iPostChange,(String)request.getParameter("FinishDate")); 
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sDealType == null) sDealType = "";
	if(sFinishDate == null) sFinishDate = "";
	//��ȡ��ͬ�����Ϣ
	sSql =  "  select SerialNo,CustomerID,"+
			 " CustomerName,BusinessType,BusinessCurrency,"+
			 " Balance,InterestBalance1,InterestBalance2,"+
			 " OriginalPutoutDate,Maturity "+
	   	 	 " from BUSINESS_CONTRACT  "+
	         " where SerialNo ='"+sObjectNo+"' ";     
   	rs = Sqlca.getASResultSet(sSql);   	
   	if(rs.next())
	 {
   		sContractSerialNo = DataConvert.toString(rs.getString("SerialNo"));
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
		sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
		sBusinessCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
		dBalance = rs.getDouble("Balance");
		dInterestBalance1 = rs.getDouble("InterestBalance1");
		dInterestBalance2 = rs.getDouble("InterestBalance2");
		sOriginalPutoutDate = DataConvert.toString(rs.getString("OriginalPutoutDate"));
		sMaturity = DataConvert.toString(rs.getString("Maturity"));
	}
	rs.getStatement().close();
	//ȡ��������:
	if(sDealType.length()>=12){
		//����,�ɾ��û�,����Ʊ���û�,�Ѻ�������
		if(sDealType.substring(0,9).equals("020030010"))
		{  
		    sBadType="010";
		}else if(sDealType.substring(0,9).equals("020030020"))
		{
			sBadType="020";
		}else if(sDealType.substring(0,9).equals("020030030"))
		{
			sBadType="030";
		}else if(sDealType.substring(0,9).equals("020030040"))
		{
			sBadType="040";
		}
		//һ����,�ص���
		if(sDealType.substring(9,12).equals("010"))
		{
			sReportType="010";
		}else if(sDealType.substring(9,12).equals("020")){
			sReportType="020";
		}
	}
	//�༭Ȩ��
	if(sDealType.equals("020030010010010")||sDealType.equals("020030010020010")||
			sDealType.equals("020030020010010")||sDealType.equals("020030020020010")||
			sDealType.equals("020030030010010")||sDealType.equals("020030030020010")||
			sDealType.equals("020030040010010")||sDealType.equals("020030040020010"))
	{	
		if(sFinishDate.equals("")||sFinishDate == null) //δ��Ч
		sEditRight="01";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "MonitorReportInfo";
	if(sDealType.equals("020030040010010")||sDealType.equals("020030040010020"))//������������ʹ�ú�����ر���ģ��
	{
		sTempletNo = "MonitorReportInfo1";
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
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
		{sEditRight.equals("01")?"true":"flase","","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/MonitorReportList.jsp","_self","");
	}
	
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");//�ͻ�ID
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");//�ͻ�����
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");//��ͬ���
			setItemValue(0,0,"ReportType","<%=sReportType%>");//��������
			setItemValue(0,0,"BadType","<%=sBadType%>");//��������
			setItemValue(0,0,"ReportDate","<%=StringFunction.getToday()%>");//��������
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");//�ͻ�ID
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");//�ͻ�����
			setItemValue(0,0,"ContractSerialNo","<%=sContractSerialNo%>");//��ͬ���
			setItemValue(0,0,"BusinessType","<%=sBusinessType%>");//ҵ��Ʒ��
			setItemValue(0,0,"BusinessCurrency","<%=sBusinessCurrency%>");//����
			setItemValue(0,0,"Balance","<%=dBalance%>");//��������
			setItemValue(0,0,"InterestBalance1","<%=dInterestBalance1%>");//����ǷϢ
			setItemValue(0,0,"InterestBalance2","<%=dInterestBalance2%>");//����ǷϢ
			if("<%=sDealType%>"=="020030040010010"||"<%=sDealType%>"=="020030040010020")//���������Ϣ¼��
			{
				setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
				setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
				setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
				setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			}else
			{
				setItemValue(0,0,"RecoveryUserID","<%=CurUser.UserID%>");
				setItemValue(0,0,"RecoveryUserName","<%=CurUser.UserName%>");
				setItemValue(0,0,"RecoveryOrgID","<%=CurOrg.OrgID%>");
				setItemValue(0,0,"RecoveryOrgName","<%=CurOrg.OrgName%>");
			}
		}		
    }
    
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "MONITOR_REPORT";//����
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
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
