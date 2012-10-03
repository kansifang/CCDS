<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong  2010/03/28
		Tester:
		Content: Ԥ���źŽ����Ϣ_List
		Input Param:			
			SignalType��Ԥ�����ͣ�01������02�������
			SignalStatus��Ԥ��״̬��10��������15�����ַ���20�������У�30����׼��40�������   
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ���źŽ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/WorkFlow/TaskList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function signOpinion()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sApplyType = getItemValue(0,getRow(),"ApplyType");
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
		sCompID = "SignRiskSignalOpinionInfo";
		sCompURL = "/CreditManage/CreditAlarm/SignRiskSignalOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApplyType="+sApplyType,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		popComp("ViewRiskSignalOpinions","/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
					
	/*~[Describe=�鿴���޸��������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		//���������������ˮ�ţ��������������
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
		//OpenPage("/CreditManage/CreditAlarm/RiskSignalFreeApproveInfo.jsp?SerialNo="+sObjectNo,"_self","");
	}
	
	
	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function commitRecord()
	{
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//��ȡ������ˮ��
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		//����Ƿ�ǩ�����
		var sReturn = PopPage("/Common/WorkFlow/RiskCheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(sPhaseNo!="0050" && sPhaseNo!="0140" &&(typeof(sReturn)=="undefined" || sReturn.length==0)) {
			alert("����ǩ���϶������Ȼ�����ύ��");//��ǩ���϶����
			return;
		}

		//���������ύѡ�񴰿�,�����̸�Ϊһ���ύ
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			OpenComp("RiskSinalApproveMain","/CreditManage/CreditAlarm/RiskSinalApproveMain.jsp","ComponentName=����Ԥ���϶�&ComponentType=MainWindow&ApproveType=ApproveRiskSignalApply@ApproveRiskSignalFApply","_top","")
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}
		
	}
	
	
	/*~[Describe=�˻�ǰһ��;InputParam=��;OutPutParam=��;]~*/
	function backStep()
	{		
		//��ȡ������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");				
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
        {	
    		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		return;
		}
		
		//����Ƿ�ǩ�����
		sReturn = PopPage("/Common/WorkFlow/RiskCheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");	
		if(typeof(sReturn)=="undefined" || sReturn.length==0) 
		{						
			//�˻��������   
			if(!confirm(getBusinessMessage('509'))) return; //��ȷ��Ҫ���������˻���һ������	
			sRetValue = PopPage("/Common/WorkFlow/CancelTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//����ɹ�����ˢ��ҳ��
			if (sRetValue == "Commit")
			{
				OpenComp("RiskSinalApproveMain","/CreditManage/CreditAlarm/RiskSinalApproveMain.jsp","ComponentName=����Ԥ���϶�&ComponentType=MainWindow&ApproveType=ApproveRiskSignalApply@ApproveRiskSignalFApply","_top","");
			}else{
				alert(sRetValue);
			}
		}else
		{
			alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
			return;
		}
		
	}
	  function takeBack()
	{
		//��ȡ������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined"||sSerialNo.length == 0 )
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//�ջ��������
		sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�ջ��������","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		//����ɹ�����ˢ��ҳ��
		if (sRetValue == "Commit")
		{
		    OpenComp("RiskSinalApproveMain","/CreditManage/CreditAlarm/RiskSinalApproveMain.jsp","ComponentName=����Ԥ���϶�&ComponentType=MainWindow&ApproveType=ApproveRiskSignalApply@ApproveRiskSignalFApply","_top","");
		}		
	}	
	
	
	/*~[Describe=��ȡ�ϼ�������Ա;InputParam=��;OutPutParam=��;]~*/	
	function getNextExaminer(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		sReturn = RunMethod("BusinessManage","getNextExaminer",sSerialNo);	
		alert("�ϼ������Ա�ǣ�"+sReturn);	
	}
			/*~[Describe=�鿴Ԥ����������;InputParam=��;OutPutParam=��;]~*/
	function checkRiskFreeReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sObjectType = "FreeRiskSignal";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",FreeRiskSignal");
	    if (typeof(sSerialNo)!="undefined" && sSerialNo.length!=0 && sSerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}	
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
