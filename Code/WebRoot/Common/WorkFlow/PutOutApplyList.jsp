<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: ��ҳ����Ҫ����Ŵ�����
	Input Param:
	Output param:
	History Log: 
		zywei 2005/07/27 �ؼ�ҳ�� 
		zywei 2007/10/10 �޸�ȡ�����ʵ���ʾ��
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
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
	/*~[Describe=�����Ŵ�����;InputParam=��;OutPutParam=��;]~*/
	function newApply()
	{
		//���ú�ͬ����
		sObjectType = "BusinessContract";		
		//�����ʵĺ�ͬ��Ϣ
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
			return;  //�á�return���Ƿ���Ч�Ӿ���ҵ���������
		}
		
		//�������ҵ����Ҫ����Ʊ����ʱ������Ŀ�����б�дѡ��Ʊ�ݵ��б�����ѡ��Ļ�Ʊ��Ÿ���sBillNo
		//��Ʒԭ�����ǽ������ֺ�ͬ���µ�Ʊ��һ���Գ���
		var sBillNo="";
				
		//��ʼ���Ŵ�����,���س�����ˮ��
		sReturn = RunMethod("WorkFlowEngine","InitializePutOut","<%=sObjectType%>,"+sObjectNo+","+sBusinessType+","+sBillNo+",<%=CurUser.UserID%>,<%=sApplyType%>,<%=sInitFlowNo%>,<%=sInitPhaseNo%>,<%=CurUser.OrgID%>");
		if(typeof(sReturn) == "undefined" || sReturn == "") return;
 		//����ҵ��Ʒ�֡����ޡ�������ʽ��ÿ�Ŀ��
 		RunMethod("BusinessManage","GetSubjectByBusinessType",sReturn);
 		//���ݺ�ͬ��ȡ�������
 		var shenqinghao = "";
 		shenqinghao = RunMethod("BusinessManage","GetShenqinghaoByHetonghao",sObjectNo);
 		//��������Ż�ȡ�ſ����Ļ������
 		var LoanOrgID = "";
 		LoanOrgID = RunMethod("BusinessManage","GetLoanOrgID",shenqinghao);
 		//���·ſ����Ļ������
 		RunMethod("PublicMethod","UpdateColValue","String@LoanOrgID@"+LoanOrgID+",BUSINESS_PUTOUT,String@serialno@"+sReturn);
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
		sSendFlag = getItemValue(0,getRow(),"SendFlag");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		
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
				 || sBusinessType=='1110027'|| sBusinessType=='1140025' || sBusinessType == '1110025'){
				 	sTradeType = "6009";
				 	sObjectType = sContractSerialNo;//�����ͬ�ţ����º�ͬ�鵵����
					sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
					sReturn=sReturn.split("@");
					if(sReturn[0] != "0000000"){
						alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
						return;
					}else{
						alert("����ȡ���ɹ���");
					}
				}else{
					//չ�ڽ����е������� added by zrli
					if(sExchangeType == '6201'){
						sTradeType = "798007";
						sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
						sReturn=sReturn.split("@");
						if(sReturn[0] != "0000000"){
							alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
							return;
						}else{
							alert("չ�ڷ��ͺ��ĳɹ���"+sReturn[1]);
						}
						return;
					}else{
						sTradeType = "798003";
						sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
						sReturn=sReturn.split("@");
						if(sReturn[0] != "0000000"){
							alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
							return;
						}else{
							alert("ɾ�����ĳɹ���");
						}
					}
				}
			}
			//��ͬȡ���鵵
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@PigeonholeDate@None,BUSINESS_CONTRACT,String@SerialNo@"+sContractSerialNo);
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
		//��ó������͡�������ˮ�š����̱�š��׶α��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo"); 
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sERateDate = getItemValue(0,getRow(),"ERateDate");
		var sChangType = "";
		sChangType	= getItemValue(0,getRow(),"ChangType");    //�������

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//�����ó���Σ�����ǰɾ�� add by zrli
		/*
		var sReturn1 = RunMethod("WorkFlowEngine","GetAfaloanFlag1",sObjectNo);
		if(sReturn1 == "1")
		{
			sTradeType = "6023";
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
			alert("���͸����ɹ���"+sReturn[1]);
			//print();
			//reloadSelf();
		}
		return;
		
		//���Գ������
		*/
		
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert("�÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��");//�÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��
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
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
			return;
		}
		
		//�жϱ�֤���Ƿ����
		dBCBailRatio = getItemValue(0,getRow(),"BailRatio");//��֤�����
		dBPBailRatio = getItemValue(0,getRow(),"BPBailRatio");//���˱�֤�����
        if(parseFloat(dBCBailRatio)>0 && (parseFloat(dBPBailRatio) < parseFloat(dBCBailRatio)))
        {  			
		    alert("��֤�����");
		    return ;			
		}
	
		//��������˲�ѯ
		//sReturn1 = RunMethod("WorkFlowEngine","GetAfaloanFlag3",sObjectNo);
		if(sBusinessType == "1110027")
		{
			if(sChangType != "")
			{
				sTradeType = "6032";
				sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+" "+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
					alert("�����ϵͳ���Ӵ��󣬸ñʴ���ܳ��ˣ�");
					return;
				}else
				{
					if(sReturn[4] == "0")
					{
						alert("����������ϵͳ����δ��");
						return;
					}else if(sReturn[4] == "1")
					{
						alert("����������ϵͳ���");
						return;
					}else if(sReturn[4] == "2")
					{
							alert("����������ϵͳ�����");
					}else if(sReturn[4] == "3")
					{
							alert("����������ϵͳ�����");
					}
				}
			
			}else
			{
				sTradeType = "6022";
				sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+" "+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
					alert("�����ϵͳ���Ӵ��󣬸ñʴ���ܳ��ˣ�");
					return;
				}else
				{
					if(sReturn[3] == "0")
					{
						alert("����������ϵͳδ������");
						return;
					}else if(sReturn[3] == "1")
					{
						alert("����������ϵͳ�������");
						return;
					}else
					{
						if(sReturn[2] == "0")
						{
							alert("�ñʴ����Ŵ����˽�������������ϵͳ���˽�һ�£�");
							return;
						}
					}
				}
			}
		}
		
		//����ҵ����ʾ(ֻ��ʾ������)
		sReturn=RunMethod("BusinessManage","CheckBusinessRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/ShowRiskView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
		}
		
		//�����ݴ�״̬�������ƹ���
		sReturn=RunMethod("BusinessManage","CheckSaveFlag",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			alert(sReturn);
			return; 
		}
		
		//���������ύѡ�񴰿�	
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
	
	//ǩ�����
	function signOpinion()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sTempSaveFlag = getItemValue(0,getRow(),"TempSaveFlag");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(sTempSaveFlag !="2"){
			alert("�ſ�������Ϣû����д���������ݴ�״̬������ǩ�������");
			return;
		}

		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		sCompID = "SignTaskOpinion";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
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
		
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function send(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");

		//���ָ��������ͺ���ֱ�Ӵ�ӡ����֪ͨ�� add by zrli 
		if(sBusinessType=='1110010' || sBusinessType=='1110020' || sBusinessType=='1110030' || sBusinessType=='1110040'
		 || sBusinessType=='1140010' || sBusinessType=='1140020'|| sBusinessType=='1140025' 
				 || sBusinessType == '1110025'){
			print();
			return;
		}
		//����ҵ�񡢳жҡ����֡����������ͺ���ֱ�Ӵ�ӡ����֪ͨ�� add by zrli 
		if(sBusinessType.substring(0,4)=='2050' || sBusinessType.substring(0,4)=='1080' || 
		sBusinessType == '2010' || sBusinessType.substring(0,4)=='1020' || 
		sBusinessType.substring(0,4)=='2030' || sBusinessType.substring(0,4)=='2040'){
			print();
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
		//�ٷ��ͳ�����Ϣ add by zrli 
		sTradeType = "798002";
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			return;
		}else{
			alert("���ͺ��ĳɹ���");
			print();
			reloadSelf();
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