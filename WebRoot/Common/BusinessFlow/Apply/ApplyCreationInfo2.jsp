<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   byhu  2004.12.7
			Tester:
			Content: �������Ŷ������/��������ҵ������
			Input Param:
		ObjectType����������
		ApplyType����������
		PhaseType���׶�����
		FlowNo�����̺�
		PhaseNo���׶κ�
		OccurType����������	
		OccurDate����������		
			Output param:
			History Log: zywei 2005/07/28
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "���ŷ���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α�š�������ʽ����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sOccurType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurType"));
	String sOccurDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDate"));

	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sOccurType == null) sOccurType = "";	
	if(sOccurDate == null) sOccurDate = "";	
//System.out.println("sFlowNo = " + sFlowNo);
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		//ͨ����ʾģ�����ASDataObject����doTemp
		String sTempletNo = "CreditApplyCreationInfo";
		String sTempletFilter = "1=1";	
		//��ȡ��������������������ʾģ��
		if(sApplyType.equals("DependentApply")) 
			sTempletFilter = " ColAttribute like '%Dependent%' ";
		//��ȡ������������ҵ�����������ʾģ��
		if(sApplyType.equals("IndependentApply")) 
			sTempletFilter = " ColAttribute like '%Independent%' ";
		ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		//���ñ��䱳��ɫ
		doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
		//��������Ϊչ�ڣ�������չ���������
		if(sOccurType.equals("015"))
		{
			doTemp.setHeader("RelativeAgreement","����չ��ҵ��");
			doTemp.setVisible("RelativeAgreement",true);				
			doTemp.setRequired("RelativeAgreement",true);
			doTemp.setReadOnly("RelativeAgreement",true);
			doTemp.setVisible("BusinessTypeName",false);
			doTemp.setRequired("BusinessTypeName",false);
			doTemp.setUnit("RelativeAgreement","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectExtendContract();\"> ");
		}
		//��������Ϊ���»��ɣ������ý��»����������
		if(sOccurType.equals("020"))
		{
			doTemp.setHeader("RelativeAgreement","�������»���ҵ��");
			doTemp.setVisible("RelativeAgreement",true);
			doTemp.setRequired("RelativeAgreement",true);
			doTemp.setReadOnly("RelativeAgreement",true);		
			doTemp.setUnit("RelativeAgreement","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectRelativeContract();\"> ");
		}
		//��������Ϊ�ʲ����飬�������ʲ������������
		if(sOccurType.equals("030"))
		{
			doTemp.setHeader("RelativeAgreement","�������鷽��");
			doTemp.setVisible("RelativeAgreement",true);
			doTemp.setRequired("RelativeAgreement",true);
			doTemp.setReadOnly("RelativeAgreement",true);		
			doTemp.setUnit("RelativeAgreement"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectNPARefrom()>");
		}
		//���ͻ����ͷ����ı�ʱ��ϵͳ�Զ������¼�����Ϣ
		doTemp.appendHTMLStyle("CustomerType"," onChange=\"javascript:parent.clearData()\" ");
		
		//--added by wwhe 2010-04-11 for:���Ŷ����ʱ��У��
		doTemp.setRequired("CreditAggreement",false);
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		/*	modified by wwhe 2009-06-09 for:�������¼�����javascript��RunMethod����ִ��,��Ҫ�ж�FlowNo
		//���ñ���ʱ�����������ݱ�Ķ���
		if(sOccurType.equals("015") || sOccurType.equals("020") || sOccurType.equals("030"))
			dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative(#SerialNo,#RelativeObjectType,#RelativeAgreement,APPLY_RELATIVE) + !WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")");
		else
			dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")");
		*/
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		//out.println(doTemp.SourceSql);
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
%>
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
		{"true","","Button","ȷ��","ȷ��������������","doCreation()",sResourcesPath},
		{"true","","Button","��һ��","���������������һ��","beforeStep()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ��������������","doCancel()",sResourcesPath}	
		};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//--added by wwhe 2009.06.10 for:У��������ҵ���Ƿ��ڶ�ȷ��䷶Χ��
		var sCustomerType = getItemValue(0,0,"CustomerType");
		var sCreditAggreement = getItemValue(0,0,"CreditAggreement");
		var sBusinessType = getItemValue(0,0,"BusinessType");
		
		if(typeof(sCreditAggreement) != "undefined" && sCreditAggreement != "" && sCustomerType == "01"){
			var sReturnValue = RunMethod("BusinessManage","ChechCreditLineBusinessType",sCreditAggreement+","+sBusinessType);
			if(sReturnValue == "false"){
				alert("���Ŷ������δ�����ҵ��Ʒ�֣�������ѡ��ҵ��Ʒ��");
				return false;
			}
		}else{//added by bllou 20120426 û�й�����Ƚ�����ʾ
			if("<%=sApplyType%>" == "DependentApply"&&!confirm("û�й������Ŷ�ȣ�ȷ�ϼ�����")){
				return false;
			}
		}
		//--finished adding wwhe 2009-06-10
		//add by bllou 2011/08/24΢�����˵������� ΢�����˵�Ѻ���� ΢�������������� ΢������ҵ���ĸ�ҵ��Ʒ�־����ˣ��ͻ������ÿ��Է���¼�����ֹ�ѡ��
		if(sBusinessType.substr(0,4)=="1125"){		
			setItemValue(0,0,"OperateUserID"," ");
		}
		if("<%=sApplyType%>" == "DependentApply")
			setItemValue(0,0,"ContractFlag","1");//ռ�ö��
		else
			setItemValue(0,0,"ContractFlag","2");//��ռ�ö��
		initSerialNo();
		as_save("myiframe0","AfterInsert()");		
	}
	
	/*~[Describe=��һ��;InputParam=��;OutPutParam=��;]~*/
	function beforeStep()
	{		
		OpenPage("/CreditManage/CreditApply/CreditApplyCreationInfo1.jsp?ObjectType=<%=sObjectType%>&ApplyType=<%=sApplyType%>&PhaseType=<%=sPhaseType%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>&OccurType=<%=sOccurType%>&OccurDate=<%=sOccurDate%>","_self","");
    }
    
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>

	<script language=javascript>

	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		sIsJGT = getItemValue(0,0,"isJGT");		
		sCreditAggreement = getItemValue(0,0,"CreditAggreement");		
		
		if(sIsJGT == "1" && sCreditAggreement.length == 0){
			alert("����ͨҵ����ѡ����Э��ţ�");
			return 
		}
		//added by bllou 20120413 ��������������ѡ������ˮ��
		var sisAccept = getItemValue(0,0,"isAccept");		
		var sAcceptSerialNo = getItemValue(0,0,"AcceptSerialNo");		
		if(sisAccept == "1" && sAcceptSerialNo.length == 0){
			alert("����������������ѡ��������ˮ�ţ�");
			return 
		}
		saveRecord("doReturn()");
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");		
		top.returnValue = sObjectNo;
		top.close();
	}
	
	/*~[Describe=�����Ϣ;InputParam=��;OutPutParam=������ˮ��;]~*/
	function clearData(){
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		setItemValue(0,0,"BusinessType","");
		setItemValue(0,0,"BusinessTypeName","");
		setItemValue(0,0,"CreditAggreement","");
		setItemValue(0,0,"RelativeAgreement","");
		setItemValue(0,0,"RelativeObjectType","");
	}
		
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{			
		sCustomerType = getItemValue(0,0,"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert(getBusinessMessage('225'));//����ѡ��ͻ����ͣ�
			return;
		}
		//����ҵ�����Ȩ�Ŀͻ���Ϣ
		sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType == "01")//��˾�ͻ�
			setObjectValue("SelectApplyCustomer3",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		if(sCustomerType == "02")//��������
			setObjectValue("SelectApplyCustomer2",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		if(sCustomerType == "03")//���˿ͻ�
			setObjectValue("SelectApplyCustomer1",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectBusinessType(sType)
	{		
		if(sType == "ALL")
		{
			sCustomerType = getItemValue(0,0,"CustomerType");
			if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
			{
				alert(getBusinessMessage('225'));//����ѡ��ͻ����ͣ�
				return;
			}
			
			sCustomerID = getItemValue(0,0,"CustomerID");
			if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
			{
				alert(getBusinessMessage('226'));//����ѡ�����ſͻ���
				return;
			}
			if(sCustomerType == "03")//���˿ͻ�
				setObjectValue("SelectIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
			else //��˾�ͻ�
			{
				/*	modified by wwhe 2009.06.15 for:���Σ���ʱû��������С��ҵ�ͻ���Թ��ͻ�
				//��Status=1Ϊ��С��ҵ�ͻ�
				sStatus = RunMethod("PublicMethod","GetColValue","Status,Customer_Info,String@CustomerID@"+sCustomerID);
				if( sStatus == "1")
				{ 
					setObjectValue("SelectEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
				}
				else
				{
					setObjectValue("SelectSMEBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
				}
				*/
				setObjectValue("SelectEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
			}
		}
	}
	
	/*~[Describe=�������Ŷ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditLine()
	{		
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert(getBusinessMessage('225'));//����ѡ��ͻ���
			return;
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}
		//���Ҹÿͻ�����Ч����Э��
		if(sCustomerType == "01")
		{
			sParaString = "CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract",sParaString,"@CreditAggreement@0@BusinessSubType@1",0,0,"");//--modified by wwhe 2009-06-08 for:��ȡ���Ŷ�ȷ����ֶ���Ϣ
		}
		if(sCustomerType == "03")
		{
			sParaString = "PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract1",sParaString,"@CreditAggreement@0",0,0,"");
		}
	}
	
	/*~[Describe=������չ�ڵĺ�ͬ/���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectExtendContract()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}
		//���պ�ͬչ��
		//sParaString = "CustomerID"+","+sCustomerID+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
		//setObjectValue("SelectExtendContract",sParaString,"@RelativeAgreement@0@BusinessType@1",0,0,"");			
		//setItemValue(0,0,"RelativeObjectType","BusinessContract");
		//���ս��չ��
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateOrgID"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectExtendDueBill",sParaString,"@RelativeAgreement@0@BusinessType@1",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","BusinessDueBill");
	}
	
	/*~[Describe=���������»��ɵĺ�ͬ/���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectRelativeContract()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}
		//���պ�ͬ���»���
		/*
		sParaString = "CustomerID"+","+sCustomerID+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
		setObjectValue("SelectExtendContract",sParaString,"@RelativeAgreement@0",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","BusinessContract");
		*/
		//���ս�ݽ��»���
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateOrgID"+","+"<%=CurUser.OrgID%>";
		setObjectValue("SelectExtendDueBill",sParaString,"@RelativeAgreement@0",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","BusinessDueBill");				
	}
	
	/*~[Describe=�����ʲ�����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectNPARefrom()
	{				
		setObjectValue("SelectNPARefrom","","@RelativeAgreement@0",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","CapitalReform");		
	}
	//added by bllou ������������ҵ�����룬ѡ��������Ϣ���԰�������Ϣ��������Ϣ������
	/*~[Describe=�����ʲ�����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditAcceptInfo()
	{				
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(typeof(sBusinessType) == "undefined" || sBusinessType == "")
		{
			alert("����ѡ��ҵ��Ʒ��");//����ѡ��ͻ���
			return;
		}
		setObjectValue("SelectCreditAcceptInfo","CustomerType,"+sCustomerType+",BusinessType,"+sBusinessType+",OrgID,<%=CurUser.OrgID%>,UserID,<%=CurUser.UserID%>","@AcceptSerialNo@0",0,0,"");	
	}		
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼	
			//�ͻ�����
			setItemValue(0,0,"CustomerType","01");		
			//��������
			setItemValue(0,0,"OccurType","<%=sOccurType%>");
			//��������
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			//��������
			setItemValue(0,0,"ApplyType","<%=sApplyType%>");
			//�������
			setItemValue(0,0,"OperateOrgID","<%=CurUser.OrgID%>");
			//������
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			//��������
			setItemValue(0,0,"OperateDate","<%=StringFunction.getToday()%>");
			//�Ǽǻ���
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			//�Ǽ���
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			//�Ǽ�����			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//��������
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//�ݴ��־
			setItemValue(0,0,"TempSaveFlag","1");//�Ƿ��־��1���ǣ�2����
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_APPLY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[added by wwhe 2009-06-08 for:Describe=��������¼�;InputParam=��;OutPutParam=��;]~*/
	function AfterInsert()
	{
		var sOccurType = "<%=sOccurType%>";
		var sObjectType = "<%=sObjectType%>";
		var sApplyType = "<%=sApplyType%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		var sUserID = "<%=CurUser.UserID%>";
		var sOrgID = "<%=CurOrg.OrgID%>";
		var sSerialNo = getItemValue(0,0,"SerialNo");
		var sRelativeObjectType = getItemValue(0,0,"RelativeObjectType");
		var sRelativeAgreement = getItemValue(0,0,"RelativeAgreement");
		var sCreditAggreement = getItemValue(0,0,"CreditAggreement");
		var sBusinessSubType = getItemValue(0,0,"BusinessSubType");
		var sCustomerType = getItemValue(0,0,"CustomerType");
		var sIsJGT = getItemValue(0,0,"isJGT");
		
		//sFlowNo = RunMethod("BusinessManage","SelectFlow","OrgID:"+sOrgID+"@ApplyType:"+sApplyType+"@CreditAggreement:"+sCreditAggreement+"@CustomerType:"+sCustomerType+"@BusinessSubType:"+sBusinessSubType+"@IsJGT:"+sIsJGT);
		//add by bllou ���������ĳ������ҳ�� ������
		sFlowNo = PopPage("/Common/WorkFlow/SelectFlow.jsp?OrgID="+sOrgID+"&ApplyType="+sApplyType+"&CreditAggreement="+sCreditAggreement+"&CustomerType="+sCustomerType+"&BusinessSubType="+sBusinessSubType+"&IsJGT="+sIsJGT,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		//end by bllou 2012.02.07
		//added by bllou 20120411 �������ҵ�񾭹��������������ѵ�ǰҵ����ˮ�ź�������ˮ�Ź�������
		var isAccept = getItemValue(0,getRow(),"isAccept");
		var sAcceptSerialNo = getItemValue(0,getRow(),"AcceptSerialNo");
		if(isAccept==="1"){
			RunMethod("BusinessManage","InsertRelative",sSerialNo+",AcceptSource,"+sAcceptSerialNo+",APPLY_RELATIVE");
		}
		if(sOccurType == "015" || sOccurType == "020" || sOccurType == "030")
			RunMethod("BusinessManage","InsertRelative",sSerialNo+","+sRelativeObjectType+","+sRelativeAgreement+",APPLY_RELATIVE");
		RunMethod("WorkFlowEngine","InitializeFlow",sObjectType+","+sSerialNo+","+sApplyType+","+sFlowNo+","+sPhaseNo+","+sUserID+","+sOrgID);	

		doReturn();
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	var bCheckBeforeUnload=false;	
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>