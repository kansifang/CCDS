<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: fxie 2005-04-25
		Tester:
		Describe: ���Ʊ����Ϣ
		Input Param:
			ObjectType: ��������
			ObjectNo:   ������
			SerialNo:	��ˮ��
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ʊ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sPerPutOutNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("PerPutOutNo"));
	String sPutOutSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("PutOutSerialNo"));
	String sExchangeState = DataConvert.toRealString(iPostChange,(String)request.getParameter("ExchangeState"));
	
	if (sSerialNo == null ) sSerialNo = "";
	if (sObjectType == null) sObjectType="";
	if (sObjectNo == null) sObjectNo="";
	if (sPerPutOutNo == null) sPerPutOutNo="";
	if (sPutOutSerialNo == null) sPutOutSerialNo="";
	if (sExchangeState == null) sExchangeState="";
	
	String sSql = "";
	String sInterSerialNo = "";
    String sAccountNo = "";
    String sGatheringName = "";
    String sAboutBankID = "";
    String sAboutBankName = "";
    boolean bIsHave = false;
    
	String sSqlNo = "select InterSerialNo,AccountNo,GatheringName,AboutBankID,AboutBankName from BILL_INFO where ObjectNo = '"+sObjectNo+"'"+
                    " and ObjectType='"+sObjectType+"' and InputUserID='"+CurUser.UserID+"' order by InterSerialNo DESC";
	
    ASResultSet rsNo = Sqlca.getResultSet(sSqlNo);
    if (rsNo.next()) {
        bIsHave = true;
        sInterSerialNo = rsNo.getString("InterSerialNo");
        sAccountNo = rsNo.getString("AccountNo");
        sGatheringName = rsNo.getString("GatheringName");
        sAboutBankID = rsNo.getString("AboutBankID");
        sAboutBankName = rsNo.getString("AboutBankName");     
    }
    rsNo.getStatement().close();
    if(sAccountNo==null)sAccountNo="";
    if(sGatheringName==null)sGatheringName="";
    if(sAboutBankID==null)sAboutBankID="";
    if(sAboutBankName==null)sAboutBankName="";
   
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AcceptBillInfo";
	//out.println(sTempletNo);
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	
	if (sExchangeState.equals("1")){
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}else{
		dwTemp.ReadOnly = "1";
	}

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
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
		{"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	
	if (sExchangeState.equals("1")){
		sButtons[0][0] = "true";
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
		var sInterSerialNo = getItemValue(0,getRow(),"InterSerialNo");
		if (sInterSerialNo.length > 4) {
			alert("�жһ�Ʊ������Ų��ܳ���4λ��");
			return;
		}

		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sBusinessSum = getItemValue(0,getRow(),"BillSum");
		if (sBusinessSum == null || sBusinessSum=="undefined" || sBusinessSum=="") {
			alert("Ʊ�ݽ��δ¼�룡");
			return;
		}
		sMessage = PopPage("/CreditManage/CreditApply/AcceptBillCheckSumAction2.jsp?SerialNo="+sSerialNo+"&PutOutSerialNo=<%=sPutOutSerialNo%>&BusinessSum="+sBusinessSum,"","");
				
		if(typeof(sMessage)!="undefined" && sMessage!="") {
			alert(sMessage);
			return;
		}

		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/Common/Exchange/ExchangeAcceptBillList.jsp?PutOutSerialNo=<%=sPutOutSerialNo%>&ExchangeState=<%=sExchangeState%>","_self","");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

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


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"RelativePutoutNo","<%=sPutOutSerialNo%>");
			setItemValue(0,0,"SendFlag","01");
			
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
			setItemValue(0,0,"InterSerialNo","0001");
			<%
			if (sPerPutOutNo!=null) {
			%>
				setItemValue(0,0,"PerPutOutNo","<%=sPerPutOutNo%>");
			<%
			}
			%>
			<%
			if(bIsHave)
			{
			        //����ַ����������ٵ��ַ�����ת������������λǰ��0
			        sInterSerialNo = "1" + sInterSerialNo;
			        int dInterSerialNo = Integer.parseInt(sInterSerialNo);
			        dInterSerialNo = dInterSerialNo + 1;
			        String sdInterSerialNo = String.valueOf(dInterSerialNo);
			        String ssdInterSerialNo = sdInterSerialNo.substring(1);
			%>
			    setItemValue(0,0,"InterSerialNo","<%=ssdInterSerialNo%>");
			    setItemValue(0,0,"AccountNo","<%=sAccountNo%>");
    			setItemValue(0,0,"GatheringName","<%=sGatheringName%>");
    			setItemValue(0,0,"AboutBankID","<%=sAboutBankID%>");
    			setItemValue(0,0,"AboutBankName","<%=sAboutBankName%>");
			<%
			}
			%>
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BILL_INFO";//����
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
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>