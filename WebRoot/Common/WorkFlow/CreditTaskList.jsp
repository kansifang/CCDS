<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: ��ҳ����Ҫ����ҵ����ص���������б�
		Input Param:
		Output param:
		History Log: 
			2005.08.03 jbye    �����޸�������������Ϣ
			2005.08.05 zywei   �ؼ�ҳ��
			2009-8-18  lpzhang for TJ �޸��ύ�������Ϣ
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
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
		//����������͡�������ˮ�š��׶α�š����̱��,�������,��Ա���
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sUserID = getItemValue(0,getRow(),"UserID");
		//���������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
			reloadSelf();
			return;
		}
			
		//����Ƿ�ǩ�����
		if(!((sFlowNo == "CreditFlow03" && (sPhaseNo == "0060" || sPhaseNo == "0250")) || 
		   (sFlowNo == "EntCreditFlow01" && (sPhaseNo == "0030" || sPhaseNo == "0060" || sPhaseNo == "0090" || sPhaseNo == "0120" ||
		   									 sPhaseNo == "0150" || sPhaseNo == "0190" || sPhaseNo == "0250" || sPhaseNo == "0280" ||
		   									 sPhaseNo == "0220")) ||		   									     
		   (sFlowNo == "EntCreditFlow02" && (sPhaseNo == "0060" || sPhaseNo == "0090" || sPhaseNo == "0120" || sPhaseNo == "0190" ||
		   									 sPhaseNo == "0220" || sPhaseNo == "0250" )) ||	
 		   (sFlowNo == "EntCreditFlow03" && (sPhaseNo == "0040" || sPhaseNo == "0070" || sPhaseNo == "0100"  )) ||			   									 	   
		   (sFlowNo == "IndCreditFlow01" && (sPhaseNo == "0030" || sPhaseNo == "0090" || sPhaseNo == "0120" || sPhaseNo == "0150" ||
		   									 sPhaseNo == "0240" || sPhaseNo == "0260" || sPhaseNo == "0280")) ||			   
		   (sFlowNo == "IndCreditFlow02" && (sPhaseNo == "0050" || sPhaseNo == "0080" || sPhaseNo == "0250" || sPhaseNo == "0180" )) ||
		   (sFlowNo == "EntCreditFlowTJ02"  &&(sPhaseNo == "0040" || sPhaseNo == "0110" || sPhaseNo == "0080" ))||
		   (sFlowNo == "IndCreditFlowTJ02"  &&(sPhaseNo == "0040" || sPhaseNo == "0110"  )) || 
		   (sFlowNo == "EntCreditFlowTJ01" &&(sPhaseNo == "0030" || sPhaseNo == "0120" || sPhaseNo == "0150" || sPhaseNo == "0190" ||
		   									sPhaseNo == "0250" || sPhaseNo == "0280"))||
		   (sFlowNo == "IndCreditFlowTJ01" &&(sPhaseNo == "0030" || sPhaseNo == "0120" || sPhaseNo == "0150" || sPhaseNo == "0190" ||
		   									sPhaseNo == "0280"))									
		   ))
		{
			sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {
				alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
				return;
			}	
		}
		
		if((sFlowNo == "EntCreditFlowTJ01" && (sPhaseNo == "0130" || sPhaseNo == "0260")) 
			|| (sFlowNo == "IndCreditFlowTJ01" && (sPhaseNo == "0130" || sPhaseNo == "0200"))
			|| (sFlowNo == "CreditFlow02" && sPhaseNo == "0030"))
		{
			sObjectType1 = "";
			if (sFlowNo == "EntCreditFlowTJ01" && sPhaseNo == "0130" ){
				sObjectType1 = "CountyApprove";
			}
			else if (sFlowNo == "EntCreditFlowTJ01" && sPhaseNo == "0260" ){
				sObjectType1 = "CityApprove";
			}	
			else if(sFlowNo == "IndCreditFlowTJ01" && sPhaseNo == "0130" ){
				sObjectType1 = "CountyApprove";
			}
			else if(sFlowNo == "IndCreditFlowTJ01" && sPhaseNo == "0200"){
				sObjectType1 = "CityApprove";
			}
			else if(sFlowNo == "CreditFlow02" && sPhaseNo == "0030"){
				sObjectType1 = "SmallCustomerAP";
			}
			/* ���ڿ����ϴ���鱨�棬����ȡ�� add by zwhu 20100929
			var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType1,"","");
			if (typeof(sDocID)=="undefined" || sDocID.length==0)
			{
				alert("��鱨�滹δ��д��������д��鱨�棡");
				return;
			}
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType1+"&DocID="+sDocID,"","");
			if (sReturn == "false")
			{
				alert("��鱨�滹δ���ɣ���������鱨�����ύ��")
				return;  
			}
			*/
		}
		
		//���ӡ���д���������Ϣ�����ƹ���  add by bqliu 2011-05-26
		if(sFlowNo == "EntCreditFlowTJ01"){
		    sObjectType2 = "BasisInfo";
		    
		    if(sPhaseNo == "0130" || sPhaseNo == "0260" ||sPhaseNo == "0220"){
		        var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType2,"","");
				if (typeof(sDocID)=="undefined" || sDocID.length==0 || sDocID!='70')
				{
					alert("������Ϣ��δ��д��������д�����ύ��");
					return;
				}
				sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType2+"&DocID="+sDocID,"","");
				if (sReturn == "false")
				{
					alert("������Ϣ��δ���ɣ��������ɻ�����Ϣ�����ύ��");
					return;  
				}
		    }
		}
		
		if("<%=CurUser.hasRole("051")%>"=="true"||"<%=CurUser.hasRole("251")%>"=="true"||"<%=CurUser.hasRole("451")%>"=="true")//���������
		{
			//����ũ,�������г�
			if("<%=CurOrg.OrgID%>"!="918010100"&&"<%=CurUser.hasRole("010")%>"=="false")
			{
				//������Ȩ�����ж�,�����Ȩ����������ʾ
				sIsAuthFlag = RunMethod("��������","�Ƿ�������Ȩ����",sObjectNo+","+sObjectType+","+sUserID+","+sOrgID+","+sFlowNo+","+sSerialNo);
				if(sIsAuthFlag=="TRUE")
				{
					 sReturn = PopPage("/Common/WorkFlow/ButtonDialog3.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				}else{
					sReturn = PopPage("/Common/WorkFlow/ButtonDialog4.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				}
			}
		}
		//���������ύѡ�񴰿�,�����̸�Ϊһ���ύ lpzhang 2009-8-18	
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined") return;
		else if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			//ˢ�¼�����ҳ��
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}	
		reloadSelf();
	}
		
	//ǩ�����
	function signCheckOpinion() 
	{
		//���������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		//add by hldu
		//���˿ͻ���;ҵ������������������Ϳ��ƹ���
		sApplyType = getItemValue(0,getRow(),"ApplyType");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sCustomerID = RunMethod("BusinessManage","GetCustomerID",sObjectType+","+sObjectNo);			
        if(sApplyType == "IndependentApply")
        {
        	sReturn = RunMethod("BusinessManage","CheckBusinessTypeAndEvaluate",sObjectNo+","+sObjectType+","+sCustomerID+","+sBusinessType);
        	if(typeof(sReturn) != "undefined" && sReturn != "") 
        	{
        		alert(sReturn);
        		return;
        	}
        }
        // add end
		
		sCompID = "CheckOpinionTab";
		sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
		OpenComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_blank",OpenStyle);
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
		dReturn = RunMethod("BusinessManage","CheckApplyApprove",sObjectType+","+sObjectNo);
		if(dReturn < 1){
			alert("����ҵ��û����������ͨ����");
		}
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(sObjectType="CreditApproveApply")
		{
			sObjectType="CreditApply";
		}
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sFlowNo=="PutOutFlow" && sPhaseNo != "0035") {
			sParamString += "&ViewID=002"
		}
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
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
		if(!confirm(getBusinessMessage('509'))) return; //��ȷ��Ҫ���������˻���һ������
		//����Ƿ�ǩ�����
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) 
		{			
			//�˻��������   	
			sRetValue = PopPage("/Common/WorkFlow/CancelTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//����ɹ�����ˢ��ҳ��
			if (sRetValue == "Commit")
			{
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�����������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			}else{
				alert(sRetValue);
			}
		}else
		{
			alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
			return;
		}
    	
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
	
	/*~[Describe=�Զ�����̽��;InputParam=��;OutPutParam=��;]~*/
	function riskSkan()
	{
		//����������͡�������ˮ��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//���з�������̽��
		popComp("ScenarioAlarm.jsp","/PublicInfo/ScenarioAlarm.jsp","OneStepRun=No&ScenarioNo=001&ObjectType=ApplySerialNo&ObjectNo="+sObjectNo,"dialogWidth=45;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
		//sReturn=RunMethod("BusinessManage","CheckApplyRisk",sObjectType+","+sObjectNo);
		//if(typeof(sReturn) != "undefined" && sReturn != "") 
			//PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
	}
	
	/*~[Describe=�鿴���鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewReport()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm("�Ƿ�鿴ϵͳ���ɵĵ��鱨�棬�����ȷ�����鿴�������ȡ�����鿴�ϴ��ĵ��鱨�棡")){
			var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (typeof(sDocID)=="undefined" || sDocID.length==0)
			{
				alert(getBusinessMessage('505'));//���鱨�滹δ��д��������д���鱨���ٲ鿴��
				return;
			}
			
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
			if (sReturn == "false")
			{
				alert("���鱨�滹δ���ɣ��������ɵ��鱨���ٲ鿴��")
				return;  
			}
					
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}	
	}
	//add by cdeng  2009-02-17  ���Ӳ鿴������ʷ��ť
	function flowHistory()
	{
		 //��ȡ������ˮ��
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
        {	
    		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		return;
		}
		OpenComp("FlowSubList","/Common/WorkFlow/FlowSubList.jsp","PhaseNo="+sPhaseNo+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&ObjectType="+sObjectType,"_blank");
	}
	/*~[Describe=������鱨��;InputParam=��;OutPutParam=��;]~*/
	function genApproveReport()
	{
		//����������͡�������ˮ��\
		sObjectType = "";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sDocID = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm("�Ƿ��ֹ���д��鱨�棬�����ȷ������д�������ȡ�����ϴ�����鱨�棡")){
			sCustomerType = RunMethod("BusinessManage","getCustomerType",sObjectNo);
			if("<%=CurOrg.OrgLevel%>" == "3"){
				sObjectType = "CountyApprove";
			}
			else{
				sObjectType = "CityApprove";
			}	
			sSmallCustomerFlag = RunMethod("BusinessManage","GetSmallCustomer",sObjectNo);
			if(sSmallCustomerFlag == "1"){
				sObjectType = "SmallCustomerAP";
			}
			
			sReturn = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if(typeof(sReturn)=="undefined" || sReturn.length==0)
			{
				if("<%=CurOrg.OrgLevel%>" == "3" && sCustomerType == "03" ){
					sDocID = "17";
				}
				else if("<%=CurOrg.OrgLevel%>" == "0" && sCustomerType == "03" ){
					sDocID = "18";
				}
				else if("<%=CurOrg.OrgLevel%>" == "3" ){
					sDocID = "15";
				}
				else {
					sDocID = "16";
				}	
				
				if(sSmallCustomerFlag == "1"){
					sDocID = "19";
				}	
			}else
			{
				sDocID = sReturn;	
			}
			sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			
			if(typeof(sReturn)!='undefined' && sReturn!="")
			{
				sReturnSplit = sReturn.split("?");
				var sFormName=randomNumber().toString();
				sFormName = "AA"+sFormName.substring(2);
				OpenComp("FormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
			}
		}	
		else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}	
	}
	/*~[Describe=������鱨��;InputParam=��;OutPutParam=��;]~*/
	function createReport()
	{
		//����������͡�������ˮ�š��ͻ����
		sObjectType = "";
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		sObjectType   = getItemValue(0,getRow(),"ObjectType");
		sCustomerID = RunMethod("BusinessManage","GetCustomerID",sObjectType+","+sObjectNo);
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if("<%=CurOrg.OrgLevel%>" == "3"){
			sObjectType = "CountyApprove";
		}
		else{
			sObjectType = "CityApprove";
		}
		
		sSmallCustomerFlag = RunMethod("BusinessManage","GetSmallCustomer",sObjectNo);
		if(sSmallCustomerFlag == "1"){
			sObjectType = "SmallCustomerAP";
		}
		
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert("��鱨�滹δ��д��������д��鱨���ٲ鿴��");
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
	
	/*~[Describe=����鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewApproveReport()
	{
		//����������͡�������ˮ��
		sObjectType = "";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if("<%=CurOrg.OrgLevel%>" == "3"){
			sObjectType = "CountyApprove";
		}
		else{
			sObjectType = "CityApprove";
		}		
		
		sSmallCustomerFlag = RunMethod("BusinessManage","GetSmallCustomer",sObjectNo);
		if(sSmallCustomerFlag == "1"){
			sObjectType = "SmallCustomerAP";
		}
				
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert("��鱨�滹δ��д��������д��鱨���ٲ鿴��");//���鱨�滹δ��д��������д���鱨���ٲ鿴��
			return;
		}
		
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
		if (sReturn == "false")
		{
			createReport();
			return;  
		}else
		{
			if(confirm("��鱨���п��ܸ��ģ��Ƿ�������鱨����ٲ鿴��"))
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
	/*~[Describe=�����ίԱ�鿴��鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewCreateApproveReport()
	{
		sObjectType = "";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sPhaseNo = "<%=sPhaseNo%>";
		sFlowNo = "<%=sFlowNo%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm("�Ƿ�鿴ϵͳ���ɵ���鱨�棬�����ȷ�����鿴�������ȡ�����鿴�ϴ�����鱨�棡")){
			if("<%=CurOrg.OrgLevel%>" == "3" || ((sPhaseNo == "0200" && sFlowNo == "IndCreditFlowTJ01" && "<%=sFinishFlag%>" == "N") || (sPhaseNo == "0260" && sFlowNo == "EntCreditFlowTJ01" && "<%=sFinishFlag%>" == "N"))){
				sObjectType = "CountyApprove";
			}
			else{
				sObjectType = "CityApprove";
			}	
			//��������֧����鱨������������鱨��,����ѡ���,ѡ������
			sCheckApproveReportFlag = RunMethod("BusinessManage","CheckExistApproveReport",sObjectNo);
			if(sCheckApproveReportFlag == "1"){//�������������֧����鱨��,�ִ���������鱨��
				sNewObjectType =PopPage("/CreditManage/CreditApply/SelectReprotTypeDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
				if(typeof(sNewObjectType)!="undefined" && sNewObjectType.length!=0 && sNewObjectType != '_none_')
				{
					sObjectType=sNewObjectType;
				}
			}
			sSmallCustomerFlag = RunMethod("BusinessManage","GetSmallCustomer",sObjectNo);
			if(sSmallCustomerFlag == "1"){
				sObjectType = "SmallCustomerAP";
			}	
			
			var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			
			if((typeof(sDocID)=="undefined" || sDocID.length==0) && ((sPhaseNo == "0200" && sFlowNo == "IndCreditFlowTJ01" && "<%=sFinishFlag%>" == "N") || (sPhaseNo == "0260" && sFlowNo == "EntCreditFlowTJ01" && "<%=sFinishFlag%>" == "N"))){
				alert("�����أ���鱨�滹δ��д�򱾱�ҵ����ֱ��֧�з���");
				return;
			}
			
			if (typeof(sDocID)=="undefined" || sDocID.length==0)
			{
				alert("��鱨�滹δ��д��������д��鱨���ٲ鿴��");//���鱨�滹δ��д��������д���鱨���ٲ鿴��
				return;
			}
			
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
			
			if(sReturn == "false" && ((sPhaseNo == "0200" && sFlowNo == "IndCreditFlowTJ01" && "<%=sFinishFlag%>" == "N") || (sPhaseNo == "0260" && sFlowNo == "EntCreditFlowTJ01" && "<%=sFinishFlag%>" == "N"))){
				alert("�����أ���鱨�滹δ���ɻ򱾱�ҵ����ֱ��֧�з���");
				return;
			}
			
			if (sReturn == "false")
			{
				alert("���鱨�滹δ���ɣ�����������鱨���ٲ鿴��")
				return;  
			}
					
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}	
	}	

	/*~[Describe=ǿ���ջ�;InputParam=��;OutPutParam=��;]~*/	
	function enforceTakeBack(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
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
		if(confirm("�Ƿ������Ҫǿ���ջر���ҵ��ǿ���ջػᵼ���Ժ�׶ε����ȫ������������ã�")){
			sReturn = RunMethod("BusinessManage","EnforceTakeBackBusiness",sObjectType+","+sObjectNo+","+sPhaseNo+","+sOrgID+","+sSerialNo);	
			alert(sReturn);
			reloadSelf();
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
	
	/*~[Describe=�鿴���������������;InputParam=��;OutPutParam=��;]~*/
	function viewLaskOpinion()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("ViewLaskOpinion","/Common/WorkFlow/ViewLaskOpinion.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doApproveSubmit()
	{
		//����������͡�������ˮ�š��׶α�š����̱��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		
		//���������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
			reloadSelf();
			return;
		}

		//���������ύѡ�񴰿�,�����̸�Ϊһ���ύ lpzhang 2009-8-18	
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined") return;
		else if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			//ˢ�¼�����ҳ��
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}	
		reloadSelf();
	}
	
	/*~[Describe=��д������Ϣ�����;InputParam=��;OutPutParam=��;]~*/
	function setBasisInfo()
	{
		//����������͡�������ˮ�š��ͻ����
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = "BasisInfo";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sReturn = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if(typeof(sReturn)!="undefined" && sReturn.length!=0)
		{
		    sReturn = PopPage("/Common/WorkFlow/ButtonDialog2.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		    if(typeof(sReturn)=="undefined"  || sReturn.length==0 )
			{
				return;
			}else if (sReturn == "_CONFIRM_") 
			{
				PopPage("/FormatDoc/DeleteReportAction.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			}
		}
		
		var sDocID = "70";
		
		sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		
		if(typeof(sReturn)!='undefined' && sReturn!="")
		{
			sReturnSplit = sReturn.split("?");
			var sFormName=randomNumber().toString();
			sFormName = "AA"+sFormName.substring(2);
			OpenComp("FormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
		}
	}	
	
	/*~[Describe=���ɻ�����Ϣ�����;InputParam=��;OutPutParam=��;]~*/
	function createBasisInfo(){
	    //����������͡�������ˮ�š��ͻ����
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		sCustomerID = RunMethod("BusinessManage","GetCustomerID",sObjectType+","+sObjectNo);
        sObjectType = "BasisInfo";
        
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}	
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0 || sDocID!='70')
		{
			alert("������Ϣ��δ��д��������д���ٲ鿴��");
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
	
	/*~[Describe=�鿴������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewBasisInfo()
	{
		//����������͡�������ˮ��
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sObjectType = "BasisInfo";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm("�Ƿ�鿴ϵͳ���ɵĻ�����Ϣ�������ȷ�����鿴�������ȡ�����鿴�ϴ��Ļ�����Ϣ��")){
			var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (typeof(sDocID)=="undefined" || sDocID.length==0 || sDocID!='70')
			{
				alert("������Ϣ��δ��д��������д���ٲ鿴��");//���鱨�滹δ��д��������д���鱨���ٲ鿴��
				return;
			}
			
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
			if (sReturn == "false")
			{
				createBasisInfo();
				return;  
			}else
			{
				 if((sPhaseNo=="0010"||sPhaseNo=="3000")&&confirm("������Ϣ���п��ܸ��ģ��Ƿ����ɻ�����Ϣ����ٲ鿴��"))
				{
					createBasisInfo();
					return; 
				}else
				{				
					var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
					OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
				}
			}
		}
		else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}
		
	}	
	
	
		
	/*~[Describe=��д����ҵ����������;InputParam=��;OutPutParam=��;]~*/
	function writeApproveApproval()
	{	
	    //����������͡�������ˮ��
		sObjectType = "ApproveApproval";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+","+sObjectType);
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sObjectNo+"&InspectType=060","","");
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
	}
	
	/*~[Describe=�鿴����ҵ����������;InputParam=��;OutPutParam=��;]~*/
	function viewApproveApproval()
	{	
	    //����������͡�������ˮ��
		var sObjectType = "ApproveApproval";
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}  
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+","+sObjectType);
	   	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			alert("��δ��д��������!");
			return;
		}else{
			var sCompID = "PurposeInspectTab";
			var sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			var sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		return true;
	}
	
	/*~[Describe=�鿴���������;InputParam=��;OutPutParam=��;]~*/
	function viewRehearForm()
	{	
	    //����������͡�������ˮ��
		var sObjectType = "RehearForm";
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sOccurType = getItemValue(0,getRow(),"OccurType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(sOccurType!="090")
		{
			alert("�ñ����벻�Ǹ���ҵ��,����Ҫ�鿴���������!");
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+","+sObjectType);
	   	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			alert("��δ��д���������!");
			return;
		}else{
			var sCompID = "PurposeInspectTab";
			var sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			var sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		return true;
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
