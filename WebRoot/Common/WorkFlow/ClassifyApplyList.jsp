<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:    xhyong 2009/08/19 
		Tester:	
		Content:   ���շ����϶��б�
		Input Param:
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���շ����϶��б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	/*~[Describe=���������¼�����ʣ�;InputParam=��;OutPutParam=��;]~*/
	function newSingleRecord()
	{    		
		sReturn = popComp("ClassifyDialog","/CreditManage/CreditCheck/ClassifyDialog.jsp","ObjectType=BusinessContract&ModelNo=Classify1&Type=Single&ClassifyType=010","dialogWidth=30;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=���������¼��������;InputParam=��;OutPutParam=��;]~*/
	function newBatchRecord()
	{    		
		sReturn = popComp("ClassifyDialog","/CreditManage/CreditCheck/ClassifyDialog.jsp","ObjectType=BusinessContract&ModelNo=Classify1&Type=Batch&ClassifyType=010","dialogWidth=30;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	//�ջ�
	function takeBack()
	{
		//���ջ��������ˮ��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
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
	
	
	/*~[Describe=�����϶�;InputParam=��;OutPutParam=��;]~*/
	function classifyCogn()
	{	
		//������͡���ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");//��������
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//������ˮ��
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");//�ͻ����� 
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sCSerialNo = getItemValue(0,getRow(),"ObjectNo");//��ͬ��ˮ��
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ�ID
		var sRightType="";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		if(sPhaseNo != "0010"){
		    sRightType="ReadOnly";
		}
		PopComp("ClassifyCogn","/CreditManage/CreditCheck/ClassifyCogn.jsp","SerialNo="+sSerialNo+"&CustomerType="+sCustomerType+"&TaskNo="+sTaskNo+"&CustomerID="+sCustomerID+"&ObjectNo="+sCSerialNo+"&RightType="+sRightType,"","");
		reloadSelf();
	}
	
	/*~[Describe=�����϶�;InputParam=��;OutPutParam=��;]add by bqliu 2011/06/17 ~*/
	function reSubmit()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");//������ˮ��
		sBCObjectNo = getItemValue(0,getRow(),"ObjectNo");//��ͬ��ˮ��
		sPhaseNo = "0010";
		sOrgID = "<%=CurOrg.OrgID%>";
		//���������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		//��ȡ����������
		sRuturn = RunMethod("WorkFlowEngine","GetFinalUser",sSerialNo);
		var sUserID = sRuturn.split("@")[0];
		var relativeSerialNo = sRuturn.split("@")[1];
		if(sUserID != "<%=CurUser.UserID%>"){
		    alert("���������϶����Լ���׼��ҵ��");
		    return;
		}
		//ȡ���һ��������¼
		sMaxRelativeSerialNo=RunMethod("WorkFlowEngine","getMaxClassifyFlowNo",sBCObjectNo);
		if(sSerialNo!=sMaxRelativeSerialNo)
		{
			alert("�ñ�ҵ�������һ�ڵķ��շ���������ߴ�����;�ķ��շ�������,���ܽ��������϶�!");
			return;
		}
		if(confirm("�Ƿ������Ҫǿ�������϶���ǿ�������϶��ᵼ��ǩ������ȫ������������ã�")){
			sReturn = RunMethod("BusinessManage","EnforceTakeBackBusiness",sObjectType+","+sObjectNo+","+sPhaseNo+","+sOrgID+","+relativeSerialNo);	
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@FinishDate@None,CLASSIFY_RECORD,String@SerialNo@"+sSerialNo);
			alert(sReturn);
			reloadSelf();
		}
	}
	
	/*~[Describe=ģ�ͷ���;InputParam=��;OutPutParam=��;]~*/
	function modelClassify()
	{				
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
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
		OpenComp("ClassifyDetails","/CreditManage/CreditCheck/ClassifyDetail.jsp","ComponentName=���շ���ο�ģ��&Action=_DISPLAY_&ObjectType=BusinessContract&ObjectNo="+sObjectNo+"&AccountMonth="+sAccountMonth+"&SerialNo="+sSerialNo+"&ModelNo=Classify1&ClassifyType=010","_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=�鿴ģ�ͷ���;InputParam=��;OutPutParam=��;]~*/
	function viewModel()
	{				
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
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
	
	/*~[Describe=ɾ�������¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		//������͡���ˮ��
		var ObjectType = getItemValue(0,getRow(),"ObjectType");
		var SerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(SerialNo)=="undefined" || SerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			var sReturn = RunMethod("WorkFlowEngine","DeleteClassifyTask",ObjectType+","+SerialNo+",DeleteTask");
			if (typeof(sReturn) != "undefined" && sReturn.length>=0)
			{
				alert("ɾ���ɹ���");
			}	
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}	
	
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function classifyEdit()
	{	
		//������͡���ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");//��������
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//������ˮ��
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sCSerialNo = getItemValue(0,getRow(),"ObjectNo");//��ͬ��ˮ��
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ�ID
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

		PopComp("SignClassifyOpinionInfo","/Common/WorkFlow/SignClassifyOpinionInfo.jsp","SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo+"&CSerialNo="+sCSerialNo+"&CustomerID="+sCustomerID,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=��ɷ���;InputParam=��;OutPutParam=��;]~*/
	function Finished()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��Result1
			return;
		}
		
		sResult1 = getItemValue(0,getRow(),"Result1");
		if (typeof(sResult1)=="undefined" || sResult1.length==0)	
		{
			alert(getBusinessMessage('658'));//���շ���û����ɣ�
			return;
		}
		if(confirm(getBusinessMessage('659')))//��ȷ���Ѿ����������
		{	
			//�϶���ɲ���
			sFinishDate = "<%=StringFunction.getToday()%>";
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishDate@"+sFinishDate+",CLASSIFY_RECORD,String@SerialNo@"+sSerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
				alert(getBusinessMessage('660'));//����ʲ����շ���ʧ�ܣ�
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('661'));	//����ʲ����շ���ɹ���
			}	
		}
	}	
	
	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function contractInfo()
	{ 
		//��ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
			return;
		}
		
		openObject("AfterLoan",sSerialNo,"002");
	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/
	function DueBillInfo()
	{ 
		//�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
			return;
		}
		
		openObject("BusinessDueBill",sSerialNo,"002");
	}
	
/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//������͡���ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		PopComp("ViewClassifyOpinions","/Common/WorkFlow/ViewClassifyOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function doSubmit()
	{//������͡�������ˮ�š����̱�š��׶α��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	    sFinishDate = "<%=StringFunction.getToday()%>";
		sUserId="<%=CurUser.UserID%>";
		sCustomerName = getItemValue(0,getRow(),"CustomerName");//�ͻ�����
		sResult1 = getItemValue(0,getRow(),"Result1");//���ֽ��(PhaseOpinion2)
		sClassifyLevel = getItemValue(0,getRow(),"ClassifyLevel");//�ͻ����������(����)(PhaseOpinion3)
		sClassifyLevel2 = getItemValue(0,getRow(),"ClassifyLevel2");//�ͻ����������(ʵ��)(PhaseOpinion4)
	
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
		var sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert("������д�����϶���Ȼ�����ύ��");//��ǩ���϶����
			return;
		}
		
		//���������
		sReturn = RunMethod("WorkFlowEngine","UpdateCROpinion",sSerialNo+","+sResult1+","+sClassifyLevel+","+sClassifyLevel2+","+sCustomerName);
		
		//���³�ʼ������ 
		if(sObjectType == "ClassifyApply")//���³�ʼ������
		{
			sReturn=RunMethod("BusinessManage","ReinitClassifyFlow",sSerialNo+","+sObjectType+","+sTaskNo);
		}
		
		//���������ύѡ�񴰿�		
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined"){
			 return;
		}else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				reloadSelf();
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}		
	}
	
	/*~[Describe=��д���շ����϶�����;InputParam=��;OutPutParam=��;]~*/
	function genReport()
	{
		//����������͡�������ˮ��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sDocID = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sReturn = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if(typeof(sReturn)=="undefined" || sReturn.length==0)
		{
			sDocID = "10";	
		}else
		{
			sDocID = sReturn;
			sReturn = PopPage("/Common/WorkFlow/ButtonDialog.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sReturn)=="undefined"  || sReturn.length==0 )
			{
				return;
			}else if (sReturn == "_CANCEL_") 
			{
				sDocID = "10";
			}			
		}
		sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if(typeof(sReturn)!='undefined' && sReturn!="")
		{
			sReturnSplit = sReturn.split("?");
			var sFormName=randomNumber().toString();
			sFormName = "AA"+sFormName.substring(2);
			OpenComp("MonitorFormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
		}
	}
	
	/*~[Describe=���ɷ��շ����϶�����;InputParam=��;OutPutParam=��;]~*/
	function createReport()
	{
		//����������͡�������ˮ�š��ͻ����
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}	
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert(getBusinessMessage('505'));//���鱨�滹δ��д��������д���鱨���ٲ鿴��
			return;
		}	
		var sAttribute = PopPage("/FormatDoc/DefaultPrint/GetAttributeAction.jsp?DocID="+sDocID,"","");
		
		if (confirm(getBusinessMessage('504'))) //�Ƿ�Ҫ���Ӵ�ӡ����,���������ȷ����ť��
		{
			var sAttribute1 = PopPage("/Common/WorkFlow/DefaultPrintSelect.jsp?DocID="+sDocID+"&rand="+randomNumber(),"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
			if (typeof(sAttribute1)=="undefined" || sAttribute1.length==0)
				return;
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute1,"_blank02",CurOpenStyle); 
		}
		else
		{
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute,"_blank02",CurOpenStyle); 
		}
	}	
	
	/*~[Describe=��ӡ���շ����϶�����;InputParam=��;OutPutParam=��;]~*/
	function printReport()
	{
		//����������͡�������ˮ��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert(getBusinessMessage('505'));//���鱨�滹δ��д��������д���鱨���ٲ鿴��
			return;
		}
		
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
		if (sReturn == "false")
		{
			createReport();
			return;  
		}else
		{
			if(confirm(getBusinessMessage('503')))//���鱨���п��ܸ��ģ��Ƿ����ɵ��鱨����ٲ鿴��
			{
				createReport();
				return; 
			}else
			{				
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
				OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
		}
		

	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
    var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
