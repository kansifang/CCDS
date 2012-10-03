<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: Ԥ����Ϣ_Info
		Input Param:	
			SignalType��Ԥ�����ͣ�01������02�������		
			SignalStatus��Ԥ��״̬��10��������15�����ַ���20�������У�30����׼��40�����; 50:�˻أ� 
			SerialNo��Ԥ����ˮ��    
		Output param:
		                
		History Log: 
		      bqliu 2011-06-10 ����������ϢҪ��           
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
    ASResultSet rs = null;
    String sCreditLevel = "";//���õȼ�
    String sSumBusinessSum = "";//�������
	String sBailSum = "";//��֤����
	String sSumCreditBalance = "";//���ڽ��
	String sAlarmApplyDate = "";//Ԥ����������
	String sPhaseNo = "";//���̽׶�
	//����������		
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
    String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalStatus"));
	//����ֵת��Ϊ���ַ���	
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sSignalStatus == null) sSignalStatus = "";
	
	//���õȼ�
	sCreditLevel = Sqlca.getString("select EvaluateResult from EVALUATE_RECORD where ObjectNo = '"+sCustomerID+"'");
	if(sCreditLevel == null) sCreditLevel = "";
	
	//Ԥ���׶�
	sPhaseNo = Sqlca.getString("select PhaseNo from FLOW_OBJECT where ObjectNo = '"+sSerialNo+"' and ObjectType='RiskSignalApply'");
	
	
	//��������֤����
	sSql = "select sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)),"+
		" sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)*BailRatio)/100 "+
	    " from BUSINESS_CONTRACT where customerID='"+sCustomerID+"'"+
	    "  and (FinishDate = '' or FinishDate is null) and BusinessType not like '3%' ";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{	
		sSumBusinessSum = DataConvert.toMoney((rs.getDouble(1)));
		sBailSum = DataConvert.toMoney((rs.getDouble(2)));
	    sSumCreditBalance = DataConvert.toMoney((rs.getDouble(1)-rs.getDouble(2)));
	    if(sSumBusinessSum == null) sSumBusinessSum="";
	    if(sBailSum == null) sBailSum="";
	    if(sSumCreditBalance == null) sSumCreditBalance="";
	}
	rs.getStatement().close();

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {							
							{"CustomerName","�ͻ�����"},
							{"SignalLevel","Ԥ������"},
							{"CustomerBalance","�������"},
							{"BailSum","��֤����"},
							{"CustomerOpenBalance","���ڽ��"},
							{"MessageContent","Ԥ��˵��"},
							{"ApproveDate","������׼����"},
							{"CreditLevel","���õȼ�"},
							{"AlarmApplyDate","Ԥ����������"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�ʱ��"},
							{"UpdateDate","����ʱ��"}
							};
		
	sSql =  " select SerialNo,ObjectType,ObjectNo,GetCustomerName(ObjectNo) as CustomerName, "+
			" SignalLevel,CustomerBalance,BailSum,CustomerOpenBalance,"+
			" MessageContent,ApproveDate,CreditLevel,AlarmApplyDate, "+
			" GetOrgName(InputOrgID) as InputOrgName,InputOrgID, "+
			" GetUserName(InputUserID) as InputUserName,InputUserID,InputDate,UpdateDate "+
			" from RISK_SIGNAL "+
			" where SerialNo = '"+sSerialNo+"' ";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("ApproveDate,AlarmApplyDate,SerialNo,ObjectType,SignalNo",false);
	
	//��������������
	doTemp.setDDDWCode("SignalLevel","SignalLevel");
	
	//���ø�ʽ
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setEditStyle("MessageContent","3");
	doTemp.setCheckFormat("AlarmApplyDate","3");
	doTemp.setType("CustomerBalance,BailSum,CustomerOpenBalance","Number");
 	doTemp.setLimit("MessageContent",800);
 	if("3000".equals(sPhaseNo))
 	{
 		doTemp.setReadOnly("SignalLevel",true);
 	}
	doTemp.setReadOnly("ObjectNo,CustomerName,CustomerBalance,BailSum,CustomerOpenBalance,AlarmApplyDate,ApproveDate,CreditLevel,InputUserName,InputOrgName,InputDate,UpdateDate",true);
 	doTemp.setRequired("SignalLevel,CustomerName,MessageOrigin",true);
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,InputUserID,InputOrgID",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,CustomerName",false);
  	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly="0";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//��ȡ����׼��Ԥ����Ϣ�Ƿ��ѱ����
	String sFreeFlag = "��";
	
	if(sSignalStatus.equals("30")) //��׼
	{
		sSql = 	" select Count(SerialNo) from RISK_SIGNAL "+
				" where RelativeSerialNo = '"+sSerialNo+"' "+				
				" and SignalStatus = '30' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			int iCount = rs.getInt(1);
			if(iCount > 0) sFreeFlag = "��";
			else sFreeFlag = "��";		
		} 
		rs.getStatement().close();
	}
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}
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
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

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
			setItemValue(0,0,"ObjectType","Customer");	
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}
		setItemValue(0,0,"CreditLevel","<%=sCreditLevel%>");	
		setItemValue(0,0,"CustomerBalance","<%=sSumBusinessSum%>");	
		setItemValue(0,0,"BailSum","<%=sBailSum%>");	
		setItemValue(0,0,"CustomerOpenBalance","<%=sSumCreditBalance%>");	
		setItemValue(0,0,"FreeFlag","<%=sFreeFlag%>");
		setItemValue(0,0,"AlarmApplyDate","<%=sAlarmApplyDate%>");
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