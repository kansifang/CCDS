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
	<%@include file="/Common/WorkFlow/TaskList.jsp"%>	
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
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		
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
		if(!((sFlowNo == "IndPutOutFlow" && sPhaseNo == "0017" ) || 
		   (sFlowNo == "EntPutOutFlow" && sPhaseNo == "0015" ) ||
		   (sFlowNo == "EntPutOutFlow02" && sPhaseNo == "0025" )||
			(sFlowNo == "EntPutOutFlow" && sPhaseNo == "0011" ))
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
		    //�������Ͳ�Ϊչ��
			sReturn = RunMethod("PublicMethod","GetColValue","OccurType,BUSINESS_CONTRACT,String@SerialNO@"+sContractSerialNo);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				sReturnValue = sReturn.split('@');
				sOccurType = sReturnValue[1];
			}
			if ((typeof(sConsultNo)=="undefined" || sConsultNo.length==0) && sOccurType != '015')
			{
				alert("����ҵ��δ��ȡҵ��ο��ţ�");
				return;
			}
		}
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//����ύ�ɹ�����ˢ��ҳ��
		if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			//ˢ�¼�����ҳ��
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
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
	/*~[Describe=���ͻ��ϵͳ����ӡ����֪ͨ;InputParam=��;OutPutParam=��;]~*/
	/* �޸� wangdw 2012-08-06 1������798002������2������777100����������� */
	function send(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sSendFlag = getItemValue(0,getRow(),"SendFlag");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
/*������ ��ʱȡ�� ��
		if(sSendFlag=="9")
		{
			alert("��ҵ����ȡ��,���ܷ��ͣ�");
			return;
		}
		//����׼��ҵ����ܷ��ͺ���
		sRetrun = RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sRetrun != "1000")
		{
			alert("��ҵ��δ����׼�����ܷ��ͺ��ģ�");
			return;
		}
		if(sSendFlag=='1' ||sSendFlag=='2')
		{
			print();
			return;
		}
		//չ�ڽ����е������� added by zrli
		sOccurType = "";
		sReturn = RunMethod("PublicMethod","GetColValue","OccurType,BUSINESS_CONTRACT,String@SerialNO@"+sContractSerialNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			sReturnValue = sReturn.split('@');
			sOccurType = sReturnValue[1];
		}
		if(sOccurType == '015'){
			sTradeType = "798005";
			sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
			sReturn=sReturn.split("@");
			if(sReturn[0] != "0000000"){
				alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
				return;
			}else{
				alert("չ�ڷ��ͺ��ĳɹ���"+sReturn[1]);
				//print();
				//reloadSelf();
			}
			return;
		}
		//���ָ��������ͺ���ֱ�Ӵ�ӡ����֪ͨ�� add by zrli 
		if(sBusinessType=='1110010' || sBusinessType=='1110020' || sBusinessType=='1140060'
		 || sBusinessType=='1140010' || sBusinessType=='1140020' || sBusinessType=='1140110' 
		 || sBusinessType=='1110027'|| sBusinessType=='1140025' || sBusinessType == '1110025'
		 ||sBusinessType == "2110020"||sBusinessType == '1140150'){
		// alert("�����ӿ���δ���ߣ��밴ԭ��ҵ��ʽ����");
			 //�Ƚ��к��Ŀͻ���Ϣ���� add by zrli 
			sTradeType = "798001";
			sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
			sReturn=sReturn.split("@");
			if(sReturn[0] != "0000000"){
				alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
				return;
			}
			
			//
			if(sBusinessType == "1110027"||sBusinessType == "2110020")
			{
				//��������
				if(sOccurType == '120')
				{
					sTradeType = "6033";
				}else
				{
					sTradeType = "6023";
				}
			}else
			{
				sTradeType = "6001";
			}
			sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
			sReturn=sReturn.split("@");
			if(sReturn[0] != "0000000"){
				alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
				return;
			}else{
					if(sTradeType == '6033'){
						alert("���͸����ɹ���");
					}else
					{
						alert("���͸����ɹ���"+sReturn[1]);
					}
					print();
					reloadSelf();
			}
			
			return;
		}
		//����ҵ�񡢳жҡ����֡����������ͺ���ֱ�Ӵ�ӡ����֪ͨ�� add by zrli   
		if(sBusinessType.substring(0,4)=='2050' || 
		sBusinessType == '2010' || sBusinessType.substring(0,4)=='1020' || 
		sBusinessType.substring(0,4)=='2030' || sBusinessType.substring(0,4)=='2040'){
			//���͹���ϵͳ
			if( sBusinessType.substring(0,4)=='2050')
			{  
				 sTradeType = "ISS000000100";
				// sReturn = RunMethod("BusinessManage","ESBGJTrade",sObjectNo+","+sTradeType);
				 sReturn = RunMethod("BusinessManage","SendESBGJ",sObjectNo+","+sObjectType+","+sTradeType);
				 sReturn=sReturn.split("@");
				 if(sReturn[0] == "0000000"){
					alert("���͹���ɹ���");
					print();
				 }else{
				 	alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
					return;
				 }			 
			}
			//��ͬ�Զ��鵵
			else
			{
				RunMethod("BusinessManage","UpdatePigeonhole",sContractSerialNo);
				print();
				return;
			}
			//alert("�鵵�ɹ���");
			reloadSelf();
			return;
		}
		//�Ƚ��к��Ŀͻ���Ϣ���� add by zrli 
		sTradeType = "798001";
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			return;
		}
		//�ٷ��Ϳ�����Ϣ add by zrli 
		sTradeType = "798002";
		sObjectType = "0";//���ױ�ʶ TradeFlag 0 ���� add by wangdw
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			return;
		}else{
			alert("���ͺ��ĳɹ���");
			//����798002�����ɹ�������BUSINESS_PUTOUT.sendflag �� 3 "���Ϳ����ɹ�"
			// add by wangdw 2012-08-09
			RunMethod("PublicMethod","UpdateColValue","String@sendflag@3,BUSINESS_PUTOUT,String@SERIALNO@"+sObjectNo);
			print();
		}
		������ ��ʱȡ�� ֹ*/
		//���������Ϣ add by wangdw
		GuarantyIn(sObjectNo);
		reloadSelf();
	}
	/*~[Describe=�ſ�;InputParam=��;OutPutParam=��;]~*/
	/*~�޸� wangdw 2012-08-06 ����798002�ſ�~*/	
	function send1(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sSendFlag = getItemValue(0,getRow(),"SendFlag");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		//ֻ�е�sendflag=3���Ϳ����ɹ���ʱ�򣬲ſ��Ե���798002�ſ�� add by wangdw
		if(sSendFlag!="3")
		{
			alert("��ҵ�񡰷��ͺ��Ŀ�����δ�ɹ������ܽ��С��ſ����");
			return;
		}
		sTradeType = "798002";
		sObjectType = "1";//���ױ�ʶ TradeFlag 1 �ſ� add by wangdw
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			return;
		}else{
			alert("���ͺ��ĳɹ���");
			//����798002�ſ�ɹ�������BUSINESS_PUTOUT.sendflag �� 1 "���ͳɹ�"
			// add by wangdw 2012-08-09
			RunMethod("PublicMethod","UpdateColValue","String@sendflag@1,BUSINESS_PUTOUT,String@SERIALNO@"+sObjectNo);
			print();
			reloadSelf();
		}
	}
	//����Ѻ����� add by wangdw
	function GuarantyIn(sObjectNo)
	{
		var i=0
		var sGuarantyID
		var Arr_GuarantyId = Array();
		sReturn = RunMethod("BusinessManage","GetGuarantyIdByPutOutNo ",sObjectNo);
		alert(sReturn);
		Arr_GuarantyId=sReturn.split("@");
		for(i=0;i<Arr_GuarantyId.length-1;i++)
		{
			//alert(Arr_GuarantyId[i])
			var sGuarantyID = Arr_GuarantyId[i];
			sTradeType = "777100";	
	        sObjectNo = sGuarantyID;
	        sObjectType = "GuarantyInfoLoad";
			if (typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
			{
				alert(getHtmlMessage('1'));
				return;
			}
			sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
			sReturn=sReturn.split("@");
			if(sReturn[0] != "0000000"){
				alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
				return;
			}else{
				alert("���ɹ�["+sReturn[1]+"]");
			}
			//�ñʵ���Ѻ��ķ���״̬��Ϊ����ⷢ�͡�
			RunMethod("PublicMethod","UpdateColValue","String@GISendFlag@01,GUARANTY_INFO,String@GUARANTYID@"+sGuarantyID);
		}
	}	
	//����Ѻ��״̬��ѯ add by wangdw
	function guarantyState(){
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	   	PopComp("SearchGuarantyByPutOutNo","/CreditManage/GuarantyManage/SearchGuarantyByPutOutNo.jsp","ObjectNo="+sObjectNo,"");
	   	reloadSelf();
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
	
	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancelSend()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sSendFlag = getItemValue(0,getRow(),"SendFlag");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
//���"��������"�� --- add by wangdw
		sOccurType = "";
		sReturn = RunMethod("PublicMethod","GetColValue","OccurType,BUSINESS_CONTRACT,String@SerialNO@"+sContractSerialNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			sReturnValue = sReturn.split('@');
			sOccurType = sReturnValue[1];
		}
//���"��������"ֹ
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}		
		if(confirm(getHtmlMessage('70')))//�������ȡ������Ϣ��
		{
			if(sSendFlag == "1"){
				//���ָ���ҵ�񷢸���ϵͳȡ�� add by zrli 
				if(sBusinessType=='1110010' || sBusinessType=='1110020' || sBusinessType=='1140060'
				 || sBusinessType=='1140010' || sBusinessType=='1140020' || sBusinessType=='1140110' 
				 || sBusinessType=='1110027'|| sBusinessType=='1140025' || sBusinessType == '1110025'
				 ||sBusinessType == "2110020"){
					 
					 if(sBusinessType == "1110027"||sBusinessType == "2110020")//��������ϴ�����ʵ�������
					{
						//���������ı����ȡ������
						if(sOccurType == '120')
						{
							sTradeType = "6034";
						}else
						{
							sTradeType = "6028";
						}
					}else{
						sTradeType = "6009";
					}
				 	sObjectType = sContractSerialNo;//�����ͬ�ţ����º�ͬ�鵵����
					sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
					sReturn=sReturn.split("@");
					if(sReturn[0] != "0000000"){
						alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
						return;
					}else{
						//�÷��ͺ��ı�־Ϊ��
						//sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@SendFlag@None,BUSINESS_PUTOUT,String@SerialNo@"+sObjectNo);
						alert("����ȡ���ɹ���");
						reloadSelf();
					}
				}else{
					//չ�ڽ����е������� added by zrli
					sOccurType = "";
					sReturn = RunMethod("PublicMethod","GetColValue","OccurType,BUSINESS_CONTRACT,String@SerialNO@"+sContractSerialNo);
					if(typeof(sReturn) != "undefined" && sReturn != "") 
					{
						sReturnValue = sReturn.split('@');
						sOccurType = sReturnValue[1];
					}
					if(sOccurType == '015'){
						sTradeType = "798007";
						sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
						sReturn=sReturn.split("@");
						if(sReturn[0] != "0000000"){
							alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
							return;
						}else{
							//�÷��ͺ��ı�־Ϊ��
							//sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@SendFlag@None,BUSINESS_PUTOUT,String@SerialNo@"+sObjectNo);
							alert("չ�ڷ��ͺ��ĳɹ���"+sReturn[1]);
							reloadSelf();
						}
						return;
					}else{
						if( sBusinessType.substring(0,4)=='2050')
						{
							sTradeType = "ISS000000110";
							//sReturn = RunMethod("BusinessManage","ESBGJTrade",sObjectNo+","+sTradeType);
							sReturn = RunMethod("BusinessManage","SendESBGJ",sObjectNo+","+sObjectType+","+sTradeType);
							sReturn=sReturn.split("@");
							if(sReturn[0] != "0000000"){
								alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
								return;
							}else{
									alert("����ȡ���ɹ���");
									reloadSelf();
								 }
						}
						else
						{
							sTradeType = "798003";
							sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
							sReturn=sReturn.split("@");
							if(sReturn[0] != "0000000"){
								alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
								return;
							}else{
								//�÷��ͺ��ı�־Ϊ��
								//sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@SendFlag@None,BUSINESS_PUTOUT,String@SerialNo@"+sObjectNo);
								alert("ɾ�����ĳɹ���");
								reloadSelf();
							}
						}
					}
				}
			}
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
