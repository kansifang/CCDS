<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: ���������б�
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/WorkFlow/GuarantyTaskList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%     
    String sSerialNoNew = String.valueOf(new java.util.Date().getTime()); 
    MD5 m = new MD5();
    String sSerialNoNews = m.getMD5ofStr(sSerialNoNew);
    
%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	//����Ѻ������
	function GuarantyDetail()
	{
		var sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		var sPawnType = getItemValue(0,getRow(),"GUARANTYTYPE");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			//�������ǵ�Ѻ
			if(sPawnType.substring(0,2)=="01")
				{
					popComp("ViewPawnInfo","/CreditManage/GuarantyManage/ViewPawnInfo.jsp","GuarantyStatus=02&GuarantyID="+sGuarantyID+"&PawnType="+sPawnType);
				}
			//����������Ѻ	
			else if(sPawnType.substring(0,2)=="02")
				{
					popComp("ViewImpawnInfo","/CreditManage/GuarantyManage/ViewImpawnInfo.jsp","GuarantyStatus=02&GuarantyID="+sGuarantyID+"&ImpawnType="+sPawnType);
				}
		}
	}
	
	/*~[Describe=�鿴������ͬ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewGuarantyContract()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("GuarantyContractList","/CreditManage/GuarantyManage/GuarantyContractList.jsp","GuarantyID="+sGuarantyID);
		}
	}
	/*~[Describe=�鿴ҵ���ͬ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function contractDetail()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("BusinessContractList","/CreditManage/GuarantyManage/BusinessContractList.jsp","GuarantyID="+sGuarantyID);
		}
	}

	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function doSubmit()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		doSubmitIn(sObjectType,sObjectNo,sBusinessType,sFlowNo,sPhaseNo);
	}

	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doSubmitIn()
	{
		//��ö������͡������š��׶α��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sConsultNo = getItemValue(0,getRow(),"ConsultNo");
		
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
		if(!((sFlowNo == "GuarantyOutFlow" && sPhaseNo == "0017" ))
		 ){
				sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
				if(typeof(sReturn)=="undefined" || sReturn.length==0) {
					alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
					return;
				}
		 }
		//���������ύѡ�񴰿�	
		//�ύʱ����Ƿ��ѻ�ȡҵ��ο���	
		if(sFlowNo == "EntPutOutFlow" && sPhaseNo == "0012" &&(sBusinessType.substring(0,4)=='1080' || sBusinessType.substring(0,4)=='2050'))
		{
			if (typeof(sConsultNo)=="undefined" || sConsultNo.length==0)
			{
				alert("����ҵ��δ��ȡҵ��ο��ţ�");
			}
		}
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//����ύ�ɹ�����ˢ��ҳ��
		if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			//RunMethod("BusinessManage","UpdateGuaranty_Apply",sSerialNo+","+sUserID+","+sOrgID+","+sInputDate);
			//ˢ�¼�����ҳ��
			//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			reloadSelf();
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}
		
	}
	
    
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function signOpinion()
	{
		//���������ˮ�š��������͡�������
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		//ǩ���Ӧ�����
		sCompID = "SignTaskOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
		
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");

		popComp("ViewLaskOpinion","/Common/WorkFlow/ViewLaskOpinion.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
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
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sFlowNo=="PutOutFlow" && sPhaseNo != "0035") {
			sParamString += "&ViewID=002"
		}
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
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
		if(!confirm(getBusinessMessage('496'))) return; //��ȷ��Ҫ���ó��������˻���һ������
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
			}
		}else
		{
			alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
			return;
		}    	
	}
	
	/*~[Describe=��ӡ����֪ͨ��;InputParam=��;OutPutParam=��;]~*/
	function print(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}	
		//������֪ͨ���Ƿ��Ѿ�����
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false") //δ���ɳ���֪ͨ��
		{
			//���ɳ���֪ͨ��	
			PopPage("/FormatDoc/PutOut/"+sExchangeType+".jsp?DocID="+sExchangeType+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//��ü��ܺ�ĳ�����ˮ��
		sEncryptSerialNo = PopPage("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo+"&rand="+randomNumber(),"myprint10","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//ͨ����serverlet ��ҳ��
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
	}
	
	function viewBusiness(){
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	   	PopComp("CustomerBusiness","/CreditManage/CreditPutOut/CustomerBusinessList.jsp","CustomeID="+sCustomerID,"");
	   	reloadSelf();
	}
	
	/*~[Describe=���ⷢ��;InputParam=��;OutPutParam=��;]~*/
	function sendOut()
	{
		//��õ���Ѻ����
        sGuarantyID = getItemValue(0,getRow(),"GuarantyID");	
        sTradeType = "777110";	
        sObjectNo = sGuarantyID;
        sObjectType = "GuarantyInfoUnLoad";
        sAPPROVEOPINION = "";        //�����������
        sObjectNo = getItemValue(0,getRow(),"ObjectNo"); //�����������
		if (typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		//�жϸñ�ҵ���������������Ƿ�Ϊ����׼��
		sReturn = RunMethod("PublicMethod","GetColValue","APPROVEOPINION,GUARANTY_APPLY,String@SerialNo@"+sObjectNo);
		if (typeof(sReturn)!="undefined" && sReturn.length!=0) 
		{
			sReturn=sReturn.split("@");
			sAPPROVEOPINION = sReturn[1]
			if(sAPPROVEOPINION!="��׼")
			{
				alert("�ñ�ҵ��δ����׼");
				return;
			}	
		}
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			return;
		}else{
			alert("����ɹ�["+sReturn[1]+"]");
			//�ñʵ���Ѻ��ķ���״̬��Ϊ��02���ⷢ�͡�
			RunMethod("PublicMethod","UpdateColValue","String@GISendFlag@02,GUARANTY_INFO,String@GUARANTYID@"+sGuarantyID);
			PopComp("LoadPawnSheet","/CreditManage/GuarantyManage/LoadPawnSheet1.jsp","GuarantyID="+sGuarantyID+"&Churuku=����","dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
		}
	}	
	
	/*~[Describe=�����ίԱ�鿴��鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewCreateApproveReport()
	{
		sObjectType = "";
		var sObjectNo1 = getItemValue(0,getRow(),"ObjectNo");
		var sCreditAggreement = getItemValue(0,getRow(),"CreditAggreement");//���Э���
		if (typeof(sObjectNo1)=="undefined" || sObjectNo1.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (typeof(sCreditAggreement)!="undefined" && sCreditAggreement.length!=0)
		{
			//���������ˮ��
			sReturn=RunMethod("PublicMethod","GetColValue","relativeserialno,business_Contract,String@SerialNo@"+sCreditAggreement);
			sReturnValue =sReturn.split("@")
			sObjectNo =sReturnValue[1];
		}else{
			sObjectNo = RunMethod("WorkFlowEngine","GetApplyNo",sObjectNo1);
		}
		sOrgFlagValue = RunMethod("PublicMethod","GetColValue","OrgFlag,BUSINESS_APPLY,String@SerialNo@"+sObjectNo);
		sOrgFlag=sOrgFlagValue.split("@")
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sPhaseNo = "<%=sPhaseNo%>";
		sFlowNo = "<%=sFlowNo%>";
		/*
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		*/
		if(confirm("�Ƿ�鿴ϵͳ���ɵ���鱨�棬�����ȷ�����鿴�������ȡ�����鿴�ϴ�����鱨�棡")){
			if(sOrgFlag[1]=="0"){
				sObjectType = "CityApprove";
			}else{
				sObjectType = "CountyApprove";
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
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=CreditApply&ObjectNo="+sObjectNo);
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
	/*~[Describe=�鿴����ҵ����������;InputParam=��;OutPutParam=��;]~*/
	function viewApproveApproval()
	{	
	    //����������͡�������ˮ��
		var sObjectType = "ApproveApproval";
		var sObjectNo1 = getItemValue(0,getRow(),"ObjectNo");
		var sCreditAggreement = getItemValue(0,getRow(),"CreditAggreement");//���Э���
		if (typeof(sObjectNo1)=="undefined" || sObjectNo1.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (typeof(sCreditAggreement)!="undefined" && sCreditAggreement.length!=0)
		{
			//���������ˮ��
			sReturn=RunMethod("PublicMethod","GetColValue","relativeserialno,business_Contract,String@SerialNo@"+sCreditAggreement);
			sReturnValue =sReturn.split("@")
			sObjectNo =sReturnValue[1];
		}else{
			sObjectNo = RunMethod("WorkFlowEngine","GetApplyNo",sObjectNo1);
		}
	    
	   	var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+","+sObjectType);
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			alert("��ҵ����������Ϣ��");
			return;
		}else{
		    //�ж��Ƿ��ύ
			var sColName = "FinishApproveUserID";
			var sTableName = "BUSINESS_APPLY";
			var sWhereClause = "String@SerialNo@"+sObjectNo;
		    sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('@');
				if(sReturn[1]=="null")
				{
					alert("����δͨ����");
					return;
				}
			}
			var sCompID = "PurposeInspectTab";
			var sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			var sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true&viewPrint=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);

		}
		return true;
	}
	/*~[Describe=��ȡҵ��ο���;InputParam=��;OutPutParam=��;]~*/
	function viewBusinessNo()
	{
		
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sConsultNo = getItemValue(0,getRow(),"ConsultNo");
		sTradeType = "ISS000000120";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(sBusinessType.substring(0,4)=='1080' || sBusinessType.substring(0,4)=='2050')
		{	
			if((typeof(sConsultNo)=="undefined" || sConsultNo.length==0)||confirm("ҵ��ο����ѻ�ȡ��ȷ�����»�ȡ��"))
			{
				sReturn = RunMethod("BusinessManage","SendESBGJ",sObjectNo+","+sObjectType+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
					return;
				}else{
					alert("ҵ��ο��Ż�ȡ�ɹ���");
					reloadSelf();
				}
				sParaString = "ObjectNo"+","+sObjectNo;
				sReturn = setObjectValue("selectConsultNo",sParaString,"",0,0,"");
				if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
				var sReturn = sReturn.split("@");
				sConsultNo = sReturn[0];
				sReturn = RunMethod("BusinessManage","ESBUpdate",sConsultNo+","+sObjectNo);// ��ѡ�еĿͻ��ο��Ÿ��µ� BP��
				reloadSelf();
			}
			
		}
	}

</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>

<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,"myiframe0");
	hideFilterArea();
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
