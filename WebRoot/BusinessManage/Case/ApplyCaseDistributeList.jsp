<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
<%
	/*
																													Author:   byhu  2004.12.6
		 */
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/
%>
<%@include file="/Common/BusinessFlow/Apply/ApplyList.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
<script language=javascript>
	/*~[Describe=��ʼ������;InputParam=��;OutPutParam=��;]~*/
	function InitFlow(){
		var sObjectType = "<%=sObjectType%>";
		var sApplyType = "<%=sApplyType%>";
		var sFlowNo = "<%=sInitFlowNo%>";
		var sPhaseNo = "<%=sInitPhaseNo%>";
		var sUserID = "<%=CurUser.UserID%>";
		var sOrgID = "<%=CurOrg.OrgID%>";
		var sSerialNo = getItemValue(0,0,"SerialNo");
		//sFlowNo = PopPage("/Common/BusinessFlow/SelectFlow.jsp?OrgID="+sOrgID+"&ApplyType="+sApplyType+"&CreditAggreement="+sCreditAggreement+"&CustomerType="+sCustomerType+"&BusinessSubType="+sBusinessSubType+"&IsJGT="+sIsJGT,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		//RunMethod("BusinessManage","InsertRelative",sSerialNo+",AcceptSource,"+sAcceptSerialNo+",APPLY_RELATIVE");
		RunMethod("WorkFlowEngine","InitializeFlow",sObjectType+","+sSerialNo+","+sApplyType+","+sFlowNo+","+sPhaseNo+","+sUserID+","+sOrgID);	
		doReturn();
	}
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�����Ŵ�����;InputParam=��;OutPutParam=��;]~*/
	function newApply()
	{
		//���ú�ͬ����
		sObjectType = "BusinessContract";		
		//�����˵ĺ�ͬ��Ϣ
		sParaString = "ManageUserID"+","+"<%=CurUser.UserID%>"+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
		sReturn = setObjectValue("SelectContractOfPutOut",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		//��ͬ��ˮ��
		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sBusinessType = sReturn[1];
		sSurplusPutOutSum = RunMethod("BusinessManage","GetPutOutSum",sObjectNo);
		if(parseFloat(sSurplusPutOutSum) <= 0) //�����ͬû�п��ý�����ֹ��������
		{	
			alert(getBusinessMessage('573'));//��ҵ���ͬ��û�п��ý����ܽ��зŴ����룡
			return;
		}
		//��ҵ��Ʒ��Ϊ����ҵ��ʱ����Ҫ�����Ƿ���Ʊ�ݡ�
		if(sBusinessType =="1020010" || sBusinessType == "1020020" || sBusinessType == "1020030")
		{
			sReturn = RunMethod("BusinessManage","CheckBillInfo",sObjectNo+","+sBusinessType);
			if(sReturn == "00")
			{
				alert("û��¼����ص�Ʊ����Ϣ����¼����ٽ��г������룡");
				return;
			}
		}
		
		//���з�������̽��
		sReturn=RunMethod("BusinessManage","CheckContractRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
			//return;  //�á�return���Ƿ���Ч�Ӿ���ҵ���������
		}
		
		//add by lzhang 2011/04/02 ���Ᵽ�����ӱ�֤�ൣ����ͬ�����տ���
		if(sBusinessType == "2050040"||sBusinessType == "2050045"){//���Ᵽ���ͱ�������ı�֤������ͬ�����ճ�������ͬ6��������
			sGCEndDate = RunMethod("BusinessManage","CheckMinDate",sObjectNo);//��ȡ��֤������ͬ����С������
			sContractEndDate = RunMethod("BusinessManage","CheckEndDate",sObjectNo);//��ȡҵ���ͬ�����º�ĵ�����
			sTermMonth = "6";//��������Ϊ������
			sTermDay = "0";
			sReturnValue = RunMethod("BusinessManage", "CheckPutOutDate", sContractEndDate + "," + sGCEndDate + "," + sTermMonth + "," + sTermDay);
			if(sReturnValue == "ok"){
				alert("���Ᵽ���ͱ�������ҵ����Ҫ��������ʽΪ��֤�ģ�\n������ͬ�ĵ���������ҵ���ͬ�����պ�6�������ϣ�");
				return;
			}
		}
		
		//�������ҵ����Ҫ����Ʊ����ʱ������Ŀ�����б�дѡ��Ʊ�ݵ��б�����ѡ��Ļ�Ʊ��Ÿ���sBillNo
		//��Ʒԭ�����ǽ������ֺ�ͬ���µ�Ʊ��һ���Գ���
		var sBillNo="";
				
		//��ʼ���Ŵ�����,���س�����ˮ��
		sReturn = RunMethod("WorkFlowEngine","InitializePutOut","<%=sObjectType%>,"+sObjectNo+","+sBusinessType+","+sBillNo+",<%=CurUser.UserID%>,<%=sApplyType%>,<%=sInitFlowNo%>,<%=sInitPhaseNo%>,<%=CurUser.OrgID%>");
		if(typeof(sReturn) == "undefined" || sReturn == "") return;

		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=PutOutApply&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
			
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function cancelApply()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
				
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
				
		if(confirm(getHtmlMessage('70')))//�������ȡ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����			
		}
	}

	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sPhaseNo != "0010" && sPhaseNo != "3000") {
			sParamString += "&ViewID=002"
		}
		
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doSubmit()
	{
		var XX=RunMethod("CheckCreditApply","getGuarantyLimit","201312080000037,1");
		alert("LL"+XX+"MM");
		//��ó������͡�������ˮ�š����̱�š��׶α��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert("�ð����Ѿ��ύ�ˣ������ٴ��ύ��");//�÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}
		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		//����Ƿ�ǩ�����
		sReturn = PopPage("/Common/BusinessFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
			return;
		}
		//���������ύѡ�񴰿�		
		sPhaseInfo = PopPage("/Common/BusinessFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined") return;
		else if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else
		{
			sPhaseInfo = PopPage("/Common/BusinessFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success")
			{
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				reloadSelf();
			}else if (sPhaseInfo == "Failure")
			{
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}	
	}
	
	//ǩ�����
	function signOpinion()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		sCompID = "SignOpinionInfo";
		sCompURL = "/Common/BusinessFlow/SignOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//��ó������͡�������ˮ�š����̱�š��׶α��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("ViewFlowOpinions","/Common/BusinessFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}

	/*~[Describe=�鵵;InputParam=��;OutPutParam=��;]~*/
	function archive(){
		//��ó������͡�������ˮ��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('56'))) //������뽫����Ϣ�鵵��
		{
			//�鵵����
			sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",BUSINESS_PUTOUT");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getHtmlMessage('60'));//�鵵ʧ�ܣ�
				return;			
			}else
			{
				reloadSelf();	
				alert(getHtmlMessage('57'));//�鵵�ɹ���
			}			
		}
	}

	/*~[Describe=ȡ���鵵;InputParam=��;OutPutParam=��;]~*/
	function cancelarch(){
		//��ó������͡�������ˮ��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('58'))) //������뽫����Ϣ�鵵ȡ����
		{
			//ȡ���鵵����
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BUSINESS_PUTOUT");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//ȡ���鵵ʧ�ܣ�
				return;
			}else
			{
				reloadSelf();
				alert(getHtmlMessage('59'));//ȡ���鵵�ɹ���
			}
		}
	}
	
	//�ջ�
	function takeBack()
	{
		//���ջ��������ˮ��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = "<%=sInitPhaseNo%>";	
		//��ȡ������ˮ��
		sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0)
		{
			if(confirm(getBusinessMessage('498'))) //ȷ���ջظñ�ҵ����
			{
				sRetValue = PopPage("/Common/BusinessFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				reloadSelf();
			}
		}else
		{
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}				
	}
	
	
	/*~[Describe=��ӡ����֪ͨ��;InputParam=��;OutPutParam=��;]~*/
	function print(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sReturn = PopPage("/FormatDoc/PutOut/"+sExchangeType+".jsp?ObjectNo="+sObjectNo+"&ContractSerialNo="+sContractSerialNo,"","");	
	}
	/*~[Describe=���ͷſ���Ϣ������;InputParam=��;OutPutParam=��;]~*/
	function sendInfo(){
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm("ȷ��Ҫ���ͷſ���Ϣ��������")){
			sReturnMessage = RunMethod("BusinessManage","DoExchange",sObjectNo+",send");
				alert(sReturnMessage);
			reloadSelf();
		}
		return;
	}
	
	//--added by wwhe 2010-01-13 for:�˻������ύ�׶�
	function backFirst()
	{
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(sBusinessType=="2010"){
			alert("����ҵ�����˻أ�");
			return;
		}

		if(!confirm("ȷ���˻س�������׶���")){
			return ;
		}
		sExchangeState = getItemValue(0,getRow(),"ExchangeState");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(sExchangeState == "1"){//--���¹�
			alert("�ñ���Ϣ�ѳ��˳ɹ��������˻أ�");
		}else{
			sReturnValue = RunMethod("BusinessManage","BackFirstPutOutApply",sObjectNo);
			if(sReturnValue == "true"){
				alert("�˻سɹ���");
				reloadSelf();
			}else
				alert("�˻�ʧ�ܣ������²�����");
		}
	}
	//--finished adding wwhe 2010-01-13
	
	//--added by wwhe 2010-02-01 for:�޸ĳ�����Ϣ
	function changeList()
	{
		sExchangeState = getItemValue(0,getRow(),"ExchangeState");
		if(sExchangeState == "1"){//--���¹�
			alert("�ñ���Ϣ�ѳ��˳ɹ��������޸ģ�");
			return false;
		}
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sContractNo = getItemValue(0,getRow(),"ContractSerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sContractNo = getItemValue(0,getRow(),"ContractSerialNo");
		
		sReturnValue = 	PopComp("ChangeView","/Common/WorkFlow/ChangeView.jsp","ObjectNo="+sObjectNo+"&ContractNo="+sContractNo+"&BusinessType="+sBusinessType,"");
		reloadSelf();
	}
	//--finished adding wwhe 2010-02-01
	
	 /*added by hywu 2008.12.17 ��ѯҵ��Ŀǰ������*/
	function selectUserName()
	{
	    //���������ˮ��
			sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
			if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
			{
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}
			sObjectType = "<%=sObjectType%>";	
			
			sParaString = "ObjectNo,"+sObjectNo+",ObjectType,"+sObjectType;
			setObjectValue("selectUserName",sParaString,"",0,0,"");
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
<script language=javascript>
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>