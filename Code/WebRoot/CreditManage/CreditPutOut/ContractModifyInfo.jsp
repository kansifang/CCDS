<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zwhu 2009/08/31
		Tester:
		Describe: 	��ͬ���������Ϣ
		Input Param:
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletNo = "ContractModifyInfo";
	//�������������ͻ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo="";
	String sAfaloanFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AfaloanFlag"));
	if(sAfaloanFlag == null) sAfaloanFlag="";
	String sPaycyc2 = " ";
	String sPaycyc1 = "",sBankAccount1 = "";
	String sPaycyc1Name = "";
	String sMaturity1 ="";
	String sRateFloat1 = "";
	String sFineRate1 = "";
	String sWarrantor1 = "";
	String sDisCountInfo1 = "";
	String sPurpose1 = "";
	String sBusinessType = "";
	double dBalance1 = 0.00;
	String sSql= " select Paycyc2 from CONTRACT_MODIFY where SerialNo = '"+sSerialNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sPaycyc2 = rs.getString(1);
		if(sPaycyc2 == null) sPaycyc2 = "";
	}
	rs.getStatement().close();
	if("".equals(sPaycyc2)){
		sSql = " select BC.CorPusPayMethod,getItemName('CorpusPayMethod2',BC.CorPusPayMethod) as PaycycName,BC.Maturity,BC.RateFloat,BC.FineRate,"+
					  " BC.Warrantor ,BC.DisCountinterest,BC.Purpose,nvl(BC.Balance,0),BC.AccountNo,BC.BusinessType "+
		              " from CONTRACT_MODIFY CM,BUSINESS_CONTRACT BC "+
		              " where CM.SerialNo = '"+sSerialNo+ "' and BC.SerialNo = CM.RelativeNo";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sPaycyc1 = rs.getString(1);
			if(sPaycyc1 == null) sPaycyc1 = "";
			sPaycyc1Name = rs.getString(2);
			if(sPaycyc1Name == null) sPaycyc1Name = "";	
			sMaturity1 = rs.getString(3);
			if(sMaturity1 == null) sMaturity1 = "";
			sRateFloat1 = rs.getString(4);
			if(sRateFloat1 == null) sRateFloat1 = "0";
			sFineRate1 = rs.getString(5);
			if(sFineRate1 == null) sFineRate1 = "";
			sWarrantor1 = rs.getString(6);
			if(sWarrantor1 == null) sWarrantor1 = "";
			sDisCountInfo1 = rs.getString(7);
			if(sDisCountInfo1 == null) sDisCountInfo1 = "0";
			sPurpose1 = rs.getString(8);
			if(sPurpose1 == null) sPurpose1 = "";
			dBalance1 = rs.getDouble(9);
			sBankAccount1 = rs.getString(10);
			if(sBankAccount1 == null) sBankAccount1 = "";
			sBusinessType = rs.getString(11);
			if(sBusinessType == null) sBusinessType = "";
		}        
		rs.getStatement().close();
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if("1110027".equals(sBusinessType)||"2110020".equals(sBusinessType))
	{
		doTemp.setReadOnly("ReduceTermMonth,ReturnBalance,RateOfPay",true);
		doTemp.setVisible("ReduceTermFlag,Paycyc3,RateOfPay",true);
		
	}
	if("1110027".equals(sBusinessType))
	{
		doTemp.setReadOnly("ReturnBalance1,RateOfPay1",true);
		doTemp.setVisible("ReturnBalance1,RateOfPay1",true);
	}
	//����������(Ԫ)��Χ
	//doTemp.appendHTMLStyle("MONTHLYWAGES"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //--����DW��� 1:Grid 2:Freeform
	
	if("1110010,1110020,1140060,1140010,1140020,1140110,1110027,1140025,1110025".indexOf(sBusinessType) > -1){
		doTemp.setDDDWSql("Paycyc2","select ItemNo,ItemName from code_library where CodeNo = 'CorpusPayMethod2' and ItemNo in('030','040') order by sortno");
	}
	else{
		doTemp.setDDDWSql("Paycyc2","select ItemNo,ItemName from code_library where CodeNo = 'CorpusPayMethod2' and ItemNo in('010','020','070') order by sortno");
	}
	if("1110027".equals(sBusinessType)||"2110020".equals(sBusinessType))
	{
		String sHTMLTemplate = "<font color=\"#FF0000\">ע:�ñʴ���Ϊ����������������ȡ������ϵͳ��ǰ������Ϣ����ť��ȡ��Ϣ!</font><hr color=\"#FFFFFF\" size=\"1\" />";
		sHTMLTemplate += "<tr><td> ${DOCK:PART1} </td></tr>";
		dwTemp.setHarborTemplate(sHTMLTemplate);
		doTemp.setColumnAttribute("","DockOptions","DockID=PART1");
		doTemp.setDDDWSql("ReduceTermFlag","select ItemNo,ItemName from code_library where CodeNo = 'ReduceTermFlag' and IsInuse = '1'");
		doTemp.setDDDWSql("Paycyc3","select ItemNo,ItemName from code_library where CodeNo = 'Paycyc3' and IsInuse = '1'");
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","��ǰ��������","��ǰ��������","prepayment()",sResourcesPath},
		{"true","","Button","��ȡ������ϵͳ��ǰ������Ϣ","��ȡ������ϵͳ��ǰ������Ϣ","send()",sResourcesPath},
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
	
	/*~[Describe=��ǰ��������;InputParam=��ǰ��������;OutPutParam=��;]~*/
	function prepayment(sPostEvents)
	{	
		
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//��ˮ��
		sObjectNo = sSerialNo;
		sObjectType = "BusinessContract";
		sTradeType = "6004";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			return;
		}else{
			alert("���͸����ɹ���"+sReturn[1]);
			//print();
			//reloadSelf();
		}
		return;
	
	}
	
	/*~[Describe=���͸���;InputParam=���͸���;OutPutParam=��;]~*/
	function send()
	{
		sSerialNo = getItemValue(0,getRow(),"RelativeNo");//��ˮ��
		sObjectNo = sSerialNo;
		sObjectType = "BusinessContract";
		sTradeType = "6025";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
		sReturnValue=sReturn.split("@");
		if(sReturnValue[0] != "0000000"){
			alert("����ϵͳ��ʾ��"+sReturnValue[1]+",������["+sReturnValue[0]+"]");//���ʧ���״������
			return;
		}else{
			if(sReturnValue[4] == "0")
			{
				setItemValue(0,getRow(),"ReduceTermMonth","0");
			}else if(sReturnValue[4] == "1")
			{
				setItemValue(0,getRow(),"ReduceTermMonth",sReturnValue[5]);//�����ڴ�
			}
			//alert(sReturnValue[1]+"@"+sReturnValue[2]+"@"+sReturnValue[3]+"@"+sReturnValue[4]+"@"+sReturnValue[5]+"@"+sReturnValue[6]+"@"+sReturnValue[7]+"@"+sReturnValue[8]);
			if("<%=sBusinessType%>"=="1110027")
			{
				setItemValue(0,getRow(),"ReturnBalance",sReturnValue[3]);//��ǰ������
				setItemValue(0,getRow(),"RateOfPay",sReturnValue[6]);//Ӧ����Ϣ
				setItemValue(0,getRow(),"ReduceTermFlag",sReturnValue[4]);//�Ƿ�����
				setItemValue(0,0,"Paycyc3",sReturnValue[2]);//��ǰ���ʽ
				setItemValue(0,getRow(),"ReturnBalance1",sReturnValue[7]);//��������ǰ������
				setItemValue(0,getRow(),"RateOfPay1",sReturnValue[8]);//ί��Ӧ����Ϣ
			}else{
				setItemValue(0,getRow(),"ReturnBalance",sReturnValue[7]);//��ǰ������
				setItemValue(0,getRow(),"RateOfPay",sReturnValue[8]);//Ӧ����Ϣ
				setItemValue(0,getRow(),"ReduceTermFlag",sReturnValue[4]);//�Ƿ�����
				setItemValue(0,0,"Paycyc3",sReturnValue[2]);//��ǰ���ʽ
			}
		}
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
	
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
		if("<%=sPaycyc2%>"==""){
			setItemValue(0,0,"Paycyc1","<%=sPaycyc1%>");
			setItemValue(0,0,"Paycyc1Name","<%=sPaycyc1Name%>");	
			setItemValue(0,0,"Maturity1","<%=sMaturity1%>");
			setItemValue(0,0,"RateFloat1","<%=DataConvert.toDouble(sRateFloat1)%>");
			setItemValue(0,0,"FineRate1","<%=sFineRate1%>");			
			setItemValue(0,0,"DisCountInfo1","<%=DataConvert.toDouble(sDisCountInfo1)%>");	
			setItemValue(0,0,"Warrantor1","<%=sWarrantor1%>");
			setItemValue(0,0,"Purpose1","<%=sPurpose1%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Balance1","<%=DataConvert.toMoney(dBalance1)%>");
			setItemValue(0,0,"BankAccount1","<%=sBankAccount1%>");						
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
