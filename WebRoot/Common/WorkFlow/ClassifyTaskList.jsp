<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/20 
		Tester:
		Content: ��ҳ����Ҫ�������õȼ���������������б�
		Input Param:
		Output param:
		History Log: ��ʼ��ҳ��
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���õȼ������϶�����"; // ��������ڱ��� <title> PG_TITLE </title>
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
	
	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doSubmit()
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
		if(!((sFlowNo == "ClassifyFlow" && (sPhaseNo == "0060" || sPhaseNo == "0090"))||(sFlowNo == "ClassifyFlow01" && (sPhaseNo == "0060" ))))
		{
			//����Ƿ�ǩ�����
			var sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {
				alert("����ǩ���϶������Ȼ�����ύ��");//��ǩ���϶����
				return;
			}
		}
		//���������ύѡ�񴰿�		
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined"){
			 return;
		}else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=���õȼ��϶�����&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=���õȼ��϶�����&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
	}
	
	/*~[Describe=�鿴ģ�ͷ���;InputParam=��;OutPutParam=��;]~*/
	function viewModel()
	{				
		sSerialNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectNo = getItemValue(0,getRow(),"BCObjectNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//�õ��ͻ�����	
	    var sColName = "CUSTOMER_INFO.CustomerType";
		var sTableName = "CUSTOMER_INFO|BUSINESS_CONTRACT";
		var sWhereClause = "None@BUSINESS_CONTRACT.CustomerID@CUSTOMER_INFO.CustomerID@String@BUSINESS_CONTRACT.SERIALNO@"+sObjectNo;
			
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "")
		{
			sReturn = sReturn.split('@');			
			if (sReturn[1].substring(0,2)=="03")
			{
				alert("���˿ͻ����ý���ģ�ͷ���!");
				return;
			}
		}
		
		OpenComp("ClassifyDetails","/CreditManage/CreditCheck/ClassifyDetail.jsp","ComponentName=���շ���ο�ģ��&Action=_DISPLAY_&ObjectType=BusinessContract&ObjectNo="+sObjectNo+"&AccountMonth="+sAccountMonth+"&SerialNo="+sSerialNo+"&ModelNo=Classify1&ClassifyType=020","_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=�����ջ�;InputParam=��;OutPutParam=��;]~*/
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
		    OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�����������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
		}		
	}
	
	/*~[Describe=�����϶�;InputParam=��;OutPutParam=��;]~*/
	function classifyCogn()
	{	
		//������͡���ˮ�š����̱�š��׶α��
		var sSerialNo = getItemValue(0,getRow(),"CRSerialNo");//������ˮ��
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");//�ͻ����� 
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ�ID
		var sCustomerName = getItemValue(0,getRow(),"CustomerName");//�ͻ�ID
		var sObjectNo = getItemValue(0,getRow(),"BCObjectNo");//��ͬ��ˮ��
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCustomerType = RunMethod("CustomerManage","GetCustomerType",sCustomerID);
		PopComp("ClassifyCogn","/CreditManage/CreditCheck/ClassifyCogn.jsp","SerialNo="+sSerialNo+"&CustomerType="+sCustomerType+"&TaskNo=1"+"&RightType=ReadOnly"+"&ObjectNo="+sObjectNo,"","");
		reloadSelf();
	}
	
	 /*~[Describe=�����϶�;InputParam=��;OutPutParam=��;]~*/
	function reSubmit()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBCObjectNo=getItemValue(0,getRow(),"BCObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sOrgID = "<%=CurOrg.OrgID%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		//���������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		//ȡ���һ��������¼
		sMaxRelativeSerialNo=RunMethod("WorkFlowEngine","getMaxClassifyFlowNo",sBCObjectNo);
		if(sSerialNo!=sMaxRelativeSerialNo)
		{
			alert("�ñ�ҵ�������һ�ڵķ��շ���������ߴ�����;�ķ��շ�������,���ܽ��������϶�!"); 
			return;
		}
		if(confirm("�Ƿ������Ҫǿ���ջر���ҵ��ǿ���ջػᵼ���Ժ�׶ε����ȫ������������ã�")){
			sReturn = RunMethod("BusinessManage","EnforceTakeBackBusiness",sObjectType+","+sObjectNo+","+sPhaseNo+","+sOrgID+","+sSerialNo);	
			alert(sReturn);
			reloadSelf();
		}
	}

		
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function classifyEdit()
	{	
		//������͡���ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");//��������
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");//������ˮ��
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sCSerialNo = getItemValue(0,getRow(),"BCObjectNo");//��ͬ��ˮ��
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ�ID
		var sClassifyLevel = getItemValue(0,getRow(),"Result2Name");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}

		PopComp("SignClassifyOpinionInfo","/Common/WorkFlow/SignClassifyOpinionInfo.jsp","SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo+"&CSerialNo="+sCSerialNo+"&CustomerID="+sCustomerID+"&ClassifyLevel="+sClassifyLevel,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function contractInfo()
	{ 
		//��ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"BCObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
			return;
		}
		
		openObject("AfterLoan",sSerialNo,"002");
	}
		
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//������͡���ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		PopComp("ViewClassifyOpinions","/Common/WorkFlow/ViewClassifyOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");	
		if(typeof(sReturn)=="undefined" || sReturn.length==0) 
		{						
			//�˻��������   
			if(!confirm(getBusinessMessage('509'))) return; //��ȷ��Ҫ���������˻���һ������	
			sRetValue = PopPage("/Common/WorkFlow/CancelTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//����ɹ�����ˢ��ҳ��
			if (sRetValue == "Commit")
			{
				OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=���õȼ��϶�����&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			}else{
				alert(sRetValue);
			}
		}else
		{
			alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
			return;
		}
		
	}
	
	/*~~~~~~~~~~~~~~~~~~~~~�ַ�Ա�������Ĳ��У������ύ���շ��� add by zwhu 201007005~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
	function batchSubmit(){
		popComp("ClassifyBatchSubmit","/CreditManage/CreditCheck/ClassifyBatchSubmit.jsp","ComponentName=�����ύ���շ���&ComponentType=MainWindow","","")
		reloadSelf();
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
