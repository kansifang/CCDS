<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:    xhyong 2009/09/04 
		Tester:	
		Content:   ����ҵ�������б�
		Input Param:
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ҵ�������б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newApply()
	{
		//��jsp�еı���ֵת����js�еı���ֵ
		sObjectType = "<%=sObjectType%>";	
		sApplyType = "<%=sApplyType%>";	
		sPhaseType = "<%=sPhaseType%>";
		sInitFlowNo = "<%=sInitFlowNo%>";
		sInitPhaseNo = "<%=sInitPhaseNo%>";	
		//����������������Ի���
		sCompID = "BadBizApplyCreationInfo";
		sCompURL = "/RecoveryManage/NPAManage/NPAApplyManage/BadBizApplyCreationInfo.jsp";			
		sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo,"dialogWidth=25;dialogHeight=15;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sObjectNo=sReturn[0];
		sApplyType=sReturn[1];
		sParaString = "RecoveryOrgID,<%=CurOrg.OrgID%>,RecoveryUserID,<%=CurUser.UserID%>";
		
		/*
		if(sApplyType == "020")//��ծ�ʲ�����
		{	
			sParaString = "ManageOrgID,<%=CurOrg.OrgID%>,ManageUserID,<%=CurUser.UserID%>,AssetFlag,020";
			//��ծ�ʲ��б�
			sReturnValue=setObjectValue("SelectDebtAsset",sParaString,"",0,0,"");
			if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
			{
				sReturnValue = sReturnValue.split("@");
				sRelativeSerialNo=sReturnValue[0];
				//���µ�ծ�ʲ������й�����ծ�ʲ�
				var sPara="String@RelativeSerialNo@"+sRelativeSerialNo+
						  ",BADBIZ_APPLY,String@SerialNo@"+sObjectNo;
				sReturnValue = RunMethod("PublicMethod","UpdateColValue",sPara);
			}else
			{
				sReturn=RunMethod("WorkFlowEngine","DeleteBadBizTask","BadBizApply,"+sObjectNo+",DeleteTask");	
				return;
			}
		}else if(sApplyType == "025")//��ծ�ʲ�������ʧ����
		{	
			sParaString = "ManageOrgID,<%=CurOrg.OrgID%>,ManageUserID,<%=CurUser.UserID%>,AssetFlag,020";
			//��ծ�ʲ��б�
			sReturnValue=setObjectValue("SelectDebtAsset",sParaString,"",0,0,"");
			if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
			{
					sReturnValue = sReturnValue.split("@");
				sRelativeSerialNo=sReturnValue[0];
				//���µ�ծ�ʲ������й�����ծ�ʲ�
				var sPara="String@RelativeSerialNo@"+sRelativeSerialNo+
						  ",BADBIZ_APPLY,String@SerialNo@"+sObjectNo;
				sReturnValue = RunMethod("PublicMethod","UpdateColValue",sPara);
			}else
			{
				sReturn=RunMethod("WorkFlowEngine","DeleteBadBizTask","BadBizApply,"+sObjectNo+",DeleteTask");	
				return;
			}
		}else if(sApplyType == "030")//����
		{
			sReturnValue=setObjectValue("SelectBadContract",sParaString,"",0,0,"");
			if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
			{	
				sReturnValue = sReturnValue.split("@");
				var sContractSerialNo = sReturnValue[0];
				var sCustomerID = sReturnValue[1];
				var sBusinessType = sReturnValue[6];
				var sBusinessCurrency = sReturnValue[5];
				var sBalance = sReturnValue[3];
				var sInterestBalance1 = sReturnValue[7];
				var sInterestBalance2 = sReturnValue[8];
				var sClassifyResult = sReturnValue[9];
				//���º�����������غ�ͬ��Ϣ
				var sPara="String@ContractSerialNo@"+sContractSerialNo+
						  "@String@CustomerID@"+sCustomerID+
						  "@String@BusinessType@"+sBusinessType+
						  "@String@BusinessCurrency@"+sBusinessCurrency+
						  "@String@ClassifyResult@"+sClassifyResult+
						  "@Number@Balance@"+sBalance+
						  "@Number@InterestBalance1@"+sInterestBalance1+
						  "@Number@InterestBalance2@"+sInterestBalance2+
						  ",BADBIZ_APPLY,String@SerialNo@"+sObjectNo;
				sReturnValue = RunMethod("PublicMethod","UpdateColValue",sPara);
			}else
			{
				sReturn=RunMethod("WorkFlowEngine","DeleteBadBizTask","BadBizApply,"+sObjectNo+",DeleteTask");	
				return;
			}
		}else if(sApplyType == "040")//�����ս�
		{	
			//���¹�����ͬ
			sReturnValue=setObjectValue("SelectFinishContract",sParaString,"",0,0,"");
			if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
			{
				sReturnValue = sReturnValue.split("@");
				sContractSerialNO=sReturnValue[0];
				sReturn = RunMethod("BusinessManage","InsertRelative",sObjectNo+",FinishContract,"+sContractSerialNO+",BADBIZ_RELATIVE");
			}else
			{
				sReturn=RunMethod("WorkFlowEngine","DeleteBadBizTask","BadBizApply,"+sObjectNo+",DeleteTask");	
				return;
			}
		}else if(sApplyType == "050")//���ϰ���
		{
			//����������������Ի���
			sCompID = "BadBizLawCaseCreationInfo";
			sCompURL = "/RecoveryManage/NPAManage/NPAApplyManage/BadBizLawCaseCreationInfo.jsp";			
			sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=25;dialogHeight=15;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_")
			{
				sReturn=RunMethod("WorkFlowEngine","DeleteBadBizTask","BadBizApply,"+sObjectNo+",DeleteTask");	
				return;
			}
		}
		*/
        //���������������ˮ�ţ��������������
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();		
	}
	
	/*~[Describe=ɾ������ҵ�������¼;InputParam=��;OutPutParam=��;]~*/
	function cancelApply()
	{
		//������͡���ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			var sReturn = RunMethod("WorkFlowEngine","DeleteBadBizTask",sObjectType+","+sSerialNo+",DeleteTask");
			if (typeof(sReturn) != "undefined" && sReturn.length>=0)
			{
				alert("ɾ���ɹ���");
			}	
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}	
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		//����������͡�������ˮ��
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
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function doSubmit()
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
		
		/*
		//����Ƿ�ǩ�����
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert("��ҵ��δ�ύ���,�����ύ,�����ύ�����");
			return;
		}
		*/
		
		//����ҵ���ύ������ 
		sReturn=RunMethod("BusinessManage","CheckBadBizApplyRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
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
	
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function signOpinion()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sApplyType = getItemValue(0,getRow(),"ApplyType");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
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
		sCompID = "SignBadBizOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignBadBizOpinionInfo.jsp";
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
		popComp("ViewBadBizOpinions","/Common/WorkFlow/ViewBadBizOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}

	/*~[Describe=�鵵;InputParam=��;OutPutParam=��;]~*/
	function archive()
	{
		//����������͡�������ˮ��
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
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@PigeonholeDate@<%=StringFunction.getToday()%>,BADBIZ_APPLY,String@SerialNo@"+sObjectNo);
			if(sReturnValue == "TRUE")//ˢ��ҳ��
			{
				reloadSelf();	
				alert(getHtmlMessage('57'));//�鵵�ɹ���
			}else
			{
				alert(getHtmlMessage('60'));//�鵵ʧ�ܣ�
				return;			
			}		
		}
	}

	/*~[Describe=ȡ���鵵;InputParam=��;OutPutParam=��;]~*/
	function cancelArch()
	{
		//����������͡�������ˮ��
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
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BADBIZ_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//ȡ���鵵ʧ�ܣ�
				return;
			}else
			{
				alert(getHtmlMessage('59'));//ȡ���鵵�ɹ���
				reloadSelf();
			}
		}
	}

	/*~[Describe=���Ƶ�ǰ;InputParam=��;OutPutParam=��;]~*/
	function copyThis()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sObjectType = "<%=sObjectType%>";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sReturn = RunMethod("WorkFlowEngine","CopyApplyFlow",sObjectType+","+sObjectNo);
		if(typeof(sReturn)!="undefined" && sReturn.length!=0)	
		{
			alert("���Ƴɹ�");
			reloadSelf();					
		}
	}	
	
	/*~[Describe=���˴���;InputParam=��;OutPutParam=��;]~*/
	function enterAccount()
	{
		alert("�˹�������������......");
	}
	
	/*~[Describe=��ӡ֪ͨ��;InputParam=��;OutPutParam=��;]~*/
	function myPrint()
	{
		alert("�˹�������������......");
	}
	
	/*~[Describe=תΪ�޷�ִ�е�����;InputParam=��;OutPutParam=��;]~*/
	function UnableExcute()
	{
		//����������͡�������ˮ��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm("�������Ҫ������ϢתΪ�޷�ִ������!")) 
		{
			//ȡ���鵵����
			sReturn=RunMethod("BusinessManage","UnableExcuteBusiness",sObjectNo+",BADBIZ_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert("תΪ�޷�ִ������ʧ��");
				return;
			}else
			{
				alert("תΪ�޷�ִ������ɹ�");
				reloadSelf();
			}
		}
	}
	
	/*~[Describe=תΪִ��;InputParam=��;OutPutParam=��;]~*/
	function doExcute()
	{
		//����������͡�������ˮ��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm("��ȷ��תִ�в���!")) //������뽫����Ϣ�鵵ȡ����
		{
			//ȡ���鵵����
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@UnableExcute@None,BADBIZ_APPLY,String@SerialNo@"+sObjectNo);
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert("����ʧ��!");
				return;
			}else
			{
				alert("�����ɹ�!");
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
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
    var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
