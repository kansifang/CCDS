<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong  2011/03/16
		Tester:
		Content: Ԥ���źŷ���
		Input Param:			
			SignalType��Ԥ�����ͣ�01������02�������
			SignalStatus��Ԥ��״̬��10����������15�����ַ���20�������У�30����׼��40�������   
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����Ԥ�����������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	String sSignalType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalType"));	
	String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalStatus"));	
	//����ֵת��Ϊ���ַ���	
	if(sSignalType == null) sSignalType = "";
	if(sSignalStatus == null) sSignalStatus = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/WorkFlow/ApplyList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{	
		//OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp","_self","");
		//��jsp�еı���ֵת����js�еı���ֵ
		sCustomerInfo=setObjectValue("SelectOwnerCustomer","UserID,"+"<%=CurUser.UserID%>","",0,0,"");
		//�ж��Ƿ񷵻���Ч��Ϣ
		if(sCustomerInfo == "" || sCustomerInfo == "_CANCEL_" || sCustomerInfo == "_NONE_" || sCustomerInfo == "_CLEAR_" || typeof(sCustomerInfo) == "undefined") return;
		sCustomerInfo = sCustomerInfo.split('@');
		sCustomerID = sCustomerInfo[0];	
		//��ʼ��Ԥ���ź����̼�������Ϣ
		sReturn = RunMethod("BusinessManage","AddRiskSignalInfo",sCustomerID+","+"<%=CurUser.UserID%>");
        //���������������ˮ�ţ��������������
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sReturn;
		openComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		/*
		popComp("RiskSignal","/CreditManage/CreditAlarm/RiskSignalMain.jsp","ObjectNo="+sReturn+"&CustomerID="+sCustomerID+"&SignalType=<%=sSignalType%>&SignalStatus=<%=sSignalStatus%>","");
		*/
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		sObjectType = getItemValue(0,getRow(),"ObjectType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			var sReturn = RunMethod("WorkFlowEngine","DeleteRiskSignalTask",sObjectType+","+sSerialNo+",DeleteTask");
			if (typeof(sReturn) != "undefined" && sReturn.length>=0)
			{
				alert("ɾ���ɹ���");
			}
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
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
		
		popComp("ViewRiskSignalOpinions","/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
			
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//���������������ˮ�ţ��������������
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		/*
		popComp("RiskSignal","/CreditManage/CreditAlarm/RiskSignalMain.jsp","SerialNo="+sSerialNo+"&CustomerID="+sCustomerID+"&SignalType=<%=sSignalType%>&SignalStatus=<%=sSignalStatus%>","");
		*/
		reloadSelf();
		//OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp?ObjectNo="+sSerialNo,"_self","");
	}
	
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
	
	/*~[Describe=�ύ��¼;InputParam=��;OutPutParam=��;]~*/
	function commitRecord()
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
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
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
		var sReturn = PopPage("/Common/WorkFlow/RiskCheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert("����ǩ���϶������Ȼ�����ύ��");//��ǩ���϶����
			return;
		}		
		//����ҵ���ύ������
		sReturn=RunMethod("BusinessManage","CheckRiskSignal",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
			return;  //�á�return���Ƿ���Ч�Ӿ���ҵ���������
			/*if(!confirm("���ֺ��֣�ҵ�����ύ�����Խ׶��Ƿ�˿�����ʱ���������ύ��")){
				return;
			}*/
		}
		var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignal");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0|| sSerialNo == "Null") {
			alert("û����дԤ������������!");
			return;
		}
		//���������ύѡ�񴰿�	
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
		if (sPhaseInfo == "Success")
		{	
			//���������еı�ʶ��
			RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@20,RISK_SIGNAL,String@SerialNo@"+sObjectNo);
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}		
	}
	
	/*~[Describe=��дԤ����鱨��;InputParam=��;OutPutParam=��;]~*/
	function writeReport()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		/*
		sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,INSPECT_INFO,String@ObjectType@RiskSignal@String@ObjectNo@"+sSerialNo);
		if(typeof(sReturn)!="undefined" && sReturn.length != 0) 
		{
			alert('�Ѿ����Ԥ����鱨�棬ֻ�ܲ鿴');//�Ѿ����Ԥ����鱨�棬ֻ�ܲ鿴
			
		}
		*/
		PopComp("RiskSignalReports","/CreditManage/CreditAlarm/RiskSignalInspectList.jsp","CustomeID="+sObjectNo,"");
		
	}
		/*~[Describe=��дԤ������������;InputParam=��;OutPutParam=��;]~*/
	function writeManulReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sObjectType = "RiskSignal";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignal");
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sObjectNo+"&InspectType=RiskSignal16","","");
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}else {
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}
		//PopComp("CreditAlarm16","/FormatDoc/CreditAlarm/16.jsp","SerialNo=="+sSerialNo+"&ObjectNo="+sObjectNo,"","");				
	}
	/*~[Describe=�鿴Ԥ������������;InputParam=��;OutPutParam=��;]~*/
	function checkManulReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sObjectType = "RiskSignal";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignal");
	    
	    if (typeof(sSerialNo)!="undefined" && sSerialNo.length!=0 && sSerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}	
	}
	
	
	/*~[Describe=�鿴Ԥ����鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewReport()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
			PopComp("RiskSignalReport","/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
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
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				reloadSelf();
			}
		}else
		{
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
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