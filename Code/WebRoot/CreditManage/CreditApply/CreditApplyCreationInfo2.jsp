<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   lpzhang 2009-9-3
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
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ŷ���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α�š�������ʽ����������,���鷽�����
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sOccurType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurType"));
	String sOccurDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDate"));
	String sNPAReformNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NPAReformNo"));

	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sOccurType == null) sOccurType = "";	
	if(sOccurDate == null) sOccurDate = "";	
	if(sNPAReformNo == null) sNPAReformNo = "";	
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//��ȡ��ؿͻ���Ϣ
	
	
	
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
		doTemp.setVisible("BusinessTypeName,CommunityAgreement",false);
		doTemp.setRequired("BusinessTypeName",false);
		doTemp.setUnit("RelativeAgreement","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectExtendContract();\"> ");
	}
	//��������Ϊ���»��ɣ������ý��»����������
/*	if(sOccurType.equals("020"))
	{
		doTemp.setHeader("RelativeAgreement","�������»���ҵ��");
		doTemp.setVisible("RelativeAgreement",true);
		doTemp.setRequired("RelativeAgreement",true);
		doTemp.setReadOnly("RelativeAgreement",true);		
		doTemp.setUnit("RelativeAgreement","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectRelativeContract();\"> ");
	}
	//��������Ϊ���ɽ��£������û��ɽ����������
	if(sOccurType.equals("060"))
	{
		doTemp.setHeader("RelativeAgreement","�������ɽ���ҵ��");
		doTemp.setVisible("RelativeAgreement",true);
		doTemp.setRequired("RelativeAgreement",true);
		doTemp.setReadOnly("RelativeAgreement",true);		
		doTemp.setUnit("RelativeAgreement","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectRelativeContract();\"> ");
	}*/
	//modify by xhyong 
	//��������Ϊ�ʲ����飬�������ʲ������������
	if(sOccurType.equals("030"))
	{
		doTemp.setHeader("RelativeAgreement","�������鷽��");
		doTemp.setVisible("RelativeAgreement",true);
		doTemp.setRequired("RelativeAgreement",true);
		doTemp.setReadOnly("RelativeAgreement",true);		
		//doTemp.setUnit("RelativeAgreement"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectNPARefrom()>");
	}
	//end
	//��������Ϊ���飬�����ø���ҵ��
	if(sOccurType.equals("090"))
	{
		doTemp.setHeader("RelativeAgreement","��������ҵ��");
		doTemp.setVisible("RelativeAgreement",true);
		doTemp.setRequired("RelativeAgreement",true);
		doTemp.setReadOnly("RelativeAgreement",true);		
		doTemp.setUnit("RelativeAgreement"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectReApply()>");
	}
	//��������Ϊ����������ù���ҵ����
	if(sOccurType.equals("120"))
	{
		doTemp.setHeader("RelativeAgreement","����ҵ����");
		doTemp.setVisible("RelativeAgreement",true);
		doTemp.setRequired("RelativeAgreement",true);
		doTemp.setReadOnly("RelativeAgreement",true);		
		doTemp.setUnit("RelativeAgreement"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectContractChange()>");
	}
	
	//���ͻ����ͷ����ı�ʱ��ϵͳ�Զ������¼�����Ϣ
	doTemp.appendHTMLStyle("CustomerType"," onChange=\"javascript:parent.clearData()\" ");
	if(sOccurType.equals("110"))
	{
		doTemp.setDDDWSql("CustomerType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='CustomerType' and ItemNo='01' and IsInUse='1'");
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ñ���ʱ�����������ݱ�Ķ���
	if(sOccurType.equals("120"))
	{
		dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative(#SerialNo,#RelativeObjectType,#RelativeAgreement,APPLY_RELATIVE) + !WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")+ !BusinessManage.InitializeBusiness("+sObjectType+",#SerialNo)+!BusinessManage.BackUpContract(#RelativeObjectType,#SerialNo,#RelativeAgreement,#BusinessType,#ChangType)");
	}else if(sOccurType.equals("015") || sOccurType.equals("030")|| sOccurType.equals("090"))
	{
		dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative(#SerialNo,#RelativeObjectType,#RelativeAgreement,APPLY_RELATIVE) + !WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")+ !BusinessManage.InitializeBusiness("+sObjectType+",#SerialNo)");
	}	
	else
		dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")+!BusinessManage.InitializeBusiness("+sObjectType+",#SerialNo)");
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
	String sButtons[][] = {
			{"true","","Button","ȷ��","ȷ��������������","doCreation()",sResourcesPath},
			{"true","","Button","��һ��","���������������һ��","beforeStep()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ��������������","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{		
		if("<%=sApplyType%>" == "DependentApply")
			setItemValue(0,0,"ContractFlag","1");//ռ�ö��
		else
			setItemValue(0,0,"ContractFlag","2");//��ռ�ö��
		//����Ȩ���lpzhang
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sOccurType = getItemValue(0,getRow(),"OccurType");
		sRelativeAgreement = getItemValue(0,getRow(),"RelativeAgreement");
		sReturn = RunMethod("BusinessManage","CheckCreditCondition",sBusinessType+","+sCustomerID+","+sOccurType+","+sRelativeAgreement+",<%=sApplyType%>");
		if(sReturn != "PASS")
		{
			alert(sReturn);
			return;
		}
		
		//��ҵ����Ĭ��ֵΪ�ͻ����������ҵ���ࣻչ�ں͸���û����ҵͶ��
		/*
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(<%=sOccurType%> != "015" && "03".indexOf(sCustomerType)!=0)
		{
			sGetIndustryType = RunMethod("BusinessManage","GetIndustryType",sCustomerID);
			setItemValue(0,getRow(),"Direction",sGetIndustryType);
		}
		*/
		initSerialNo();
		as_save("myiframe0",sPostEvents);		
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
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
var ChangeObject = "";
	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		var sReturnValue ="";
		sBusinessType = getItemValue(0,0,"BusinessType");
		sRelativeAgreement = getItemValue(0,0,"RelativeAgreement");
		sApplyType = "<%=sApplyType%>";
		if((sBusinessType.substr(0,4) == "1080" || sBusinessType.substr(0,4) == "2050") && sApplyType =="IndependentApply"){//����ҵ��
			while(sReturnValue =="" || typeof(sReturnValue) == "undefined" || sReturnValue == "")
			{
				sReturnValue = PopPage("/CreditManage/CreditApply/CreditApplyNationRisk.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			}
			setItemValue(0,getRow(),"NationRisk",sReturnValue);
			setItemValue(0,getRow(),"LowRisk",sReturnValue);
		}
		
		//����ǣ������������Ϊ�������ҵ��
		if(sApplyType =="IndependentApply" && "015,020,060".indexOf("<%=sOccurType%>") > -1 && (typeof(sRelativeAgreement) != "undefined" && sRelativeAgreement != ""))
		{
				sReturn = RunMethod("BusinessManage","GetRelativeApplyType",sRelativeAgreement);
				if(sReturn=="DependentApply")
				{
					alert("�������Ϊ�������ҵ�񣬲��ܷ����ҵ�����룡");
					return;
				}
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
		if("<%=sOccurType%>" != "030")
		{
			setItemValue(0,0,"RelativeAgreement","");
			setItemValue(0,0,"RelativeObjectType","");
		}
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
			if("<%=sOccurType%>" == "110")//�޸�(��Թ���ҵ����)
			{
				setObjectValue("SelectNationBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
			}
			else{
				if(sCustomerType == "03")//���˿ͻ�
				{
					var sReturn="";
					if("<%=sApplyType%>" == "IndependentApply")//���ʲ������״�ֱ�״�
					{
						sReturn=setObjectValue("SelectOtherIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
					}else{
						sReturn=setObjectValue("SelectIndBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
					}
					if(sReturn == "" || sReturn == "_CANCEL_" || typeof(sReturn) == "undefined") return;
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];
					//��Թ�����:
					if(sBusinessType=="1110027")
					{
						var sReturnValue = "";	
						if("<%=sOccurType%>" == "120")
						{
							sReturnValue =PopPage("/CreditManage/CreditApply/AssembleBusinessDialogChange.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
							if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
							{
								sss2 = sReturnValue.split("@");
								setItemValue(0,getRow(),"AFALoanFlag","1");
								setItemValue(0,getRow(),"CommercialNo",sss2[0]);
								setItemValue(0,getRow(),"AccumulationNo",sss2[1]);
								setItemValue(0,getRow(),"ChangType",sss2[2]);
							}
							
						}
						else{
							sReturnValue =PopPage("/CreditManage/CreditApply/AssembleBusinessDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
							if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
							{
								sss2 = sReturnValue.split("@");
								setItemValue(0,getRow(),"AFALoanFlag","1");
								setItemValue(0,getRow(),"CommercialNo",sss2[0]);
								setItemValue(0,getRow(),"AccumulationNo",sss2[1]);
							}
						}
					}
					//��������ı�������Ŵ�ϵͳ����
					else if("<%=sOccurType%>" == "120" && sBusinessType=="2110020")
					{
						alert("��������ı�������Ŵ�ϵͳ����");
						setItemValue(0,getRow(),"BusinessTypeName","");
						setItemValue(0,getRow(),"BusinessType","");
						return;
					}
					//���˿ͻ��ǹ����������
					else if("<%=sOccurType%>" == "120" && sBusinessType!="2110020")	
					{
					sReturnValue =PopPage("/CreditManage/CreditApply/AssembleBusinessDialogChangeOther.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
					if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
							{
								sss2 = sReturnValue.split("@");
								ChangeObject = sss2[0]
								setItemValue(0,getRow(),"ChangType",sss2[1]);
							}
						
					}
						
				}else //��˾�ͻ�
				{
					var sReturnValue = "";
					//��Status=1Ϊ΢С��ҵ modefied by lpzhang 2010-1-28
					sStatus = RunMethod("BusinessManage","GetSmallCustomerType",sCustomerID);
					if( sStatus == "1")
					{ 
						setObjectValue("SelectSMEBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
					}
					else
					{
						setObjectValue("SelectEntBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
					}
					//��˾�ͻ���� 
					if("<%=sOccurType%>" == "120")
					{
					sReturnValue =PopPage("/CreditManage/CreditApply/AssembleBusinessDialogChangeOther.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
					if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
							{
								sss2 = sReturnValue.split("@");
								ChangeObject = sss2[0]
								setItemValue(0,getRow(),"ChangType",sss2[1]);
							}
					}
				}
			}
			
			if("<%=sApplyType%>" == "IndependentApply")
			{
				sBusinessType = getItemValue(0,0,"BusinessType");
				if("1140130,1150060,1150050,1054,1056".indexOf(sBusinessType)>-1) 
				{
					setItemRequired(0,0,"CommunityAgreement",true);
				}else
				{
					setItemRequired(0,0,"CommunityAgreement",false);
					setItemValue(0,getRow(),"CommunityAgreement",'');
				}
				if(sBusinessType == "1150020"){
					sCustomerIDArr = RunMethod("CreditLine","AssureCustomerID",sCustomerID); //��ѯ�ͻ���������С��
					if(typeof(sCustomerIDArr) == "undefined" || sCustomerIDArr == "" || sCustomerIDArr == "Null" || sCustomerIDArr == "NULL")
					{
						alert("�ÿͻ�����ũ������С���Ա��");
						setItemValue(0,getRow(),"BusinessType",'');
						setItemValue(0,getRow(),"BusinessTypeName",'');
						return;
					}
					//setItemRequired(0,0,"AssureAgreement",true);
					//setItemRequired(0,0,"CommunityAgreement",true);
				}else{
					//setItemRequired(0,0,"AssureAgreement",false);
					//setItemValue(0,getRow(),"AssureAgreement",'');
					//setItemRequired(0,0,"CommunityAgreement",false);
					//setItemValue(0,getRow(),"CommunityAgreement",'');	
				}
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
			setObjectValue("SelectCLContract",sParaString,"@CreditAggreement@0",0,0,"");
			CheckLineDate();
		}
		
		if(sCustomerType == "03")
		{
			sParaString = "CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract1",sParaString,"@CreditAggreement@0",0,0,"");
			CheckLineDate();
		}
	}
	
	function CheckLineDate(){
		sCreditAggreement = getItemValue(0,getRow(),"CreditAggreement");
		dReturn = RunMethod("CreditLine","CheckLineUse",sCreditAggreement);
		if(dReturn <= 0){//���δ������
			dReturn = RunMethod("CreditLine","CheckLineDate",sCreditAggreement);
			if(dReturn > 92){
				alert("�����׼�����������²���������ҵ��");
				setItemValue(0,0,"CreditAggreement","");
			}
		}
	}
	/*~[Describe=��������С�����Ŷ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	/*function selectAssureAgreement()
	{		
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert(getBusinessMessage('225'));//����ѡ��ͻ���
			return;
		}
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(typeof(sBusinessType) == "undefined" || sBusinessType == "")
		{
			alert("����ѡ��ҵ��Ʒ�֣�");
			return;
		}else if(sBusinessType !="1150020"){
			alert("����ũ����������,������ѡ������С����Э�飡");
			return;
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert("����ѡ��ͻ���");
			return;
		}
		if(sCustomerType != "03")
		{
			alert("�Ǹ��˿ͻ���������ѡ������С����Э�飡");
			return;
		}
		sCustomerIDArr = RunMethod("CreditLine","AssureCustomerID",sCustomerID); //��ѯ�ͻ���������С��
		if(typeof(sCustomerIDArr) == "undefined" || sCustomerIDArr == "" || sCustomerIDArr == "Null" || sCustomerIDArr == "NULL")
		{
			alert("�ÿͻ�����ũ������С���Ա��");
			return;
		}else
		{
			sParaString = "CustomerID"+","+sCustomerIDArr+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract2",sParaString,"@AssureAgreement@0",0,0,"");
		}
	}*/
	/*~[Describe=�������ù�ͬ�����Ŷ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCommunityAgreement()
	{		
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert(getBusinessMessage('225'));//����ѡ��ͻ���
			return;
		}
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(typeof(sBusinessType) == "undefined" || sBusinessType == "")
		{
			alert("����ѡ��ҵ��Ʒ�֣�");
			return;
		}
		/*if(sBusinessType == "1150020"){
			sAssureAgreement = getItemValue(0,getRow(),"AssureAgreement");
			if(typeof(sAssureAgreement) == "undefined" || sAssureAgreement == ""){
				alert("ũ��������������ȹ���ũ������С������Э��ţ�");
				return;
			}
		}*/
		else if("1140130,1150060,1150050,1054,1056".indexOf(sBusinessType) < 0) 
		{
			alert("�������ù�ͬ���ڴ������ѡ�����ù�ͬ���ȣ�");
			return;
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert("����ѡ��ͻ���");
			return;
		}
		if(sBusinessType == "1150020"){
			sCustomerID = RunMethod("CreditLine","AssureCustomerID",sCustomerID); //��ѯ�ͻ���������С��
		}
		sCustomerIDArr = RunMethod("CreditLine","CommunityCustomerID",sCustomerID); //��ѯ�ͻ��������ù�ͬ��
		if(typeof(sCustomerIDArr) == "undefined" || sCustomerIDArr == "" || sCustomerIDArr == "Null" || sCustomerIDArr == "NULL")
		{
			alert("�ÿͻ��������ù�ͬ���Ա��");
			return;
		}else
		{
			sParaString = "CustomerID"+","+sCustomerIDArr+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract3",sParaString,"@CommunityAgreement@0",0,0,"");
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
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateOrgID"+","+"<%=CurUser.OrgID%>";
		setObjectValue("SelectExtendDueBill",sParaString,"@RelativeAgreement@0@BusinessType@1",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","BusinessDueBill");
	}
	
	/*~[Describe=���������»��ɵĺ�ͬ/���ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectRelativeContract()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sOccurType = "<%=sOccurType%>"
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}
		//���պ�ͬ���»���
		//sParaString = "CustomerID"+","+sCustomerID+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
		//setObjectValue("SelectExtendContract",sParaString,"@RelativeAgreement@0",0,0,"");			
		//setItemValue(0,0,"RelativeObjectType","BusinessContract");
		//���ս�ݽ��»���
		sParaString = "CustomerID"+","+sCustomerID+","+"OperateOrgID"+","+"<%=CurOrg.OrgID%>";
		if(sOccurType == "015"){//չ��
			setObjectValue("SelectExtendDueBill",sParaString,"@RelativeAgreement@0",0,0,"");	
		}else if(sOccurType == "020"){//���»���
			setObjectValue("SelectDueBill1",sParaString,"@RelativeAgreement@0",0,0,"");	
		}else if(sOccurType == "060"){//���ɽ���
			setObjectValue("SelectDueBill2",sParaString,"@RelativeAgreement@0",0,0,"");	
		}
		setItemValue(0,0,"RelativeObjectType","BusinessDueBill");				
	}
	
	/*~[Describe=�����ʲ�����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectNPARefrom()
	{				
		setObjectValue("SelectNPARefrom","","@RelativeAgreement@0",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","CapitalReform");		
	}
	
	/*~[Describe=�����ʸ�������룬���ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectReApply()
	{	
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}			
		setObjectValue("SelectReApply","CustomerID,"+sCustomerID+","+"OperateUserID"+","+"<%=CurUser.UserID%>","@RelativeAgreement@0",0,0,"");			
		setItemValue(0,0,"RelativeObjectType","BusinessReApply");		
	}
	/*~[Describe=��������ҵ���ͬ��Ϣ�����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectContractChange()
	{
		CustomerType = getItemValue(0,0,"CustomerType");
		BusinessType = getItemValue(0,getRow(),"BusinessType");
		CustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}			
		if(typeof(BusinessType) == "undefined" || BusinessType == "")
		{
			alert("��ѡ��ҵ��Ʒ�֣�");//����ѡ��ҵ��Ʒ�֣�
			return;
		}			
		//����ǹ�������
		if(BusinessType=="1110027")	
		{
			setObjectValue("selectContractChange","UserID,"+"<%=CurUser.UserID%>","@RelativeAgreement@0",0,0,"");		
			setItemValue(0,0,"RelativeObjectType","ContractChange");	
		}	
		//����Ƿǹ�������
		else
		{
			if(typeof(ChangeObject) == "undefined" || ChangeObject == "")
			{
				alert("��ѡ��������");//����ѡ��������
				return;
			}
			//������������������Ϣ
			if(ChangeObject=="01")
			{
			sParaString = "UserID,"+"<%=CurUser.UserID%>"+",CustomerID,"+CustomerID+",BusinessType,"+BusinessType;
			//alert(sParaString);
			setObjectValue("selectApplyChangeInfoById",sParaString,"@RelativeAgreement@0",0,0,"");
			setItemValue(0,0,"RelativeObjectType","ApplyChange");	
			}
			//�����������Ǻ�ͬ��Ϣ
			if(ChangeObject=="02")
			{
			sParaString = "UserID,"+"<%=CurUser.UserID%>"+",CustomerID,"+CustomerID+",BusinessType,"+BusinessType;
			setObjectValue("selectContractChangeInfoById",sParaString,"@RelativeAgreement@0",0,0,"");
			setItemValue(0,0,"RelativeObjectType","ContractChange");	
			}
		}
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
			if("<%=sOccurType%>" == "030")//����
			{
				setItemValue(0,0,"RelativeAgreement","<%=sNPAReformNo%>");
				setItemValue(0,0,"RelativeObjectType","CapitalReform");		
			}
			//�ݴ��־
			setItemValue(0,0,"TempSaveFlag","1");//�Ƿ��־��1���ǣ�2����
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_APPLY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "BA";//ǰ׺
								
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
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>