<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: ��ҳ����Ҫ����ҵ����ص������б������Ŷ�������б��������ҵ�������б�
			 ��������ҵ�������б�
	Input Param:
	Output param:
	History Log: zywei 2005/07/27 �ؼ�ҳ�� 
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ŷ�������"; // ��������ڱ��� <title> PG_TITLE </title>
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
		var sCustomerType='01';//--�ͻ�����
		var sCustomerScale='02';//--�ͻ���ģ
		var sCustomerID ='';//--�ͻ�����
		var sReturn ='';//--����ֵ���ͻ���¼����Ϣ�Ƿ�ɹ�
		var sReturnStatus = '';//--��ſͻ���Ϣ�����
		var sStatus = '';//--��ſͻ���Ϣ���״̬		
		var sReturnValue = '';//--��ſͻ�������Ϣ

		//��jsp�еı���ֵת����js�еı���ֵ
		sObjectType = "<%=sObjectType%>";	
		sApplyType = "<%=sApplyType%>";	
		sInitFlowNo = "<%=sInitFlowNo%>";
		sInitPhaseNo = "<%=sInitPhaseNo%>";			
		
		//�ͻ���Ϣ¼��ģ̬�����	
		//�������ֿͻ����ͣ���Ϊ���ƶԻ����չʾ��С
		if(sCustomerType == "01"||sCustomerType == "03") 
			sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		else
			sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		//�ж��Ƿ񷵻���Ч��Ϣ
		if(typeof(sReturnValue) != "undefined" && sReturnValue.length != 0 && sReturnValue != '_CANCEL_')
		{
			sReturnValue = sReturnValue.split("@");
			//�õ��ͻ�������Ϣ
			sCustomerType = sReturnValue[0];
			sCustomerName = sReturnValue[1];
			sCertType = sReturnValue[2];
			sCertID = sReturnValue[3];
		
			//���ͻ���Ϣ����״̬
			sReturnStatus = RunMethod("CustomerManage","CheckCustomerAction",sCustomerType+","+sCustomerName+","+sCertType+","+sCertID,+",<%=CurUser.UserID%>");
			//sReturnStatus = PopPage("/CustomerManage/CheckCustomerAction.jsp?CustomerType="+sCustomerType+"&CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			//�õ��ͻ���Ϣ������Ϳͻ���
			sReturnStatus = sReturnStatus.split("@");

			sStatus = sReturnStatus[0];
			sCustomerID = sReturnStatus[1];
			
  			//02Ϊ��ǰ�û�����ÿͻ�������Ч����
			if(sStatus == "02")
			{
				alert(getBusinessMessage('105')); //�ÿͻ��ѱ��Լ����������ȷ�ϣ�
				return;
			}
			//01Ϊ�ÿͻ������ڱ�ϵͳ��
			if(sStatus == "01")
			{				
				//ȡ�ÿͻ����
				sCustomerID = PopPage("/CustomerManage/GetCustomerIDAction.jsp","","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
				//�����ͻ���Ϣ���϶���ˮ��Ϣ
				sReturn = RunMethod("WorkFlowEngine","InitializeCustomerInfo",sObjectType+","+sCustomerID+","+sApplyType+","+sInitFlowNo+","+sInitPhaseNo+",<%=CurUser.UserID%>,<%=CurOrg.OrgID%>,"+sCustomerType+","+sCustomerName+","+sCertType+","+sCertID+","+sStatus+","+sCustomerID+","+sCustomerScale);
				if(sReturn == "succeed" && sReturnStatus == "01")
				{
					alert(getBusinessMessage('109')); //�����ͻ��ɹ�
				}
			}else alert("�ÿͻ��Ѿ����ڣ����������϶����룡");//������Ҫ�����Ѵ��ڿͻ������϶��������Ϊ�Ժ����չ�������ݲ�ʵ�� add by jbye
			/*
			//�������Ϊ�޸ÿͻ���û�к��κοͻ���������Ȩ���������ͻ���������Ȩʱ���ж����ݿ����
			if(sStatus == "01" || sStatus == "04" || sStatus == "05")
			{
				//���ÿͻ��������û�������Ч������Ϊ��ҵ�ͻ��͹������� ,��Ҫ��ϵͳ����Ա����Ȩ��
				if(sReturn == "succeed" && sReturnStatus == "05" )
				{
					if(confirm(getBusinessMessage('103'))) //�ͻ��ѳɹ����룬Ҫ��������ÿͻ��Ĺܻ�Ȩ��
					    popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.UserID%>&OrgID=<%=CurOrg.OrgID%>","");					
				//���ÿͻ�û�����κ��û�������Ч��������ǰ�û�����ÿͻ�������Ч�������ÿͻ��������û�������Ч���������˿ͻ�/���幤�̻�/ũ��/����С�飩�Ѿ�����ͻ�
				}else if(sReturn == "succeed" && (sReturnStatus == "04"))
				{
					alert(getBusinessMessage('108')); //�ͻ�����ɹ�
				//�Ѿ������ͻ�
				}else 
			}
			*/
			if(sStatus == "01" || sStatus == "04")
			{
				openObject("Customer",sCustomerID,"001");
				
			}
			reloadSelf();	
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function cancelApply()
	{
		//����������͡�������ˮ��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			//��ȡ������ˮ��
			sReturn = RunMethod("WorkFlowEngine","CancelCusApply",sObjectNo);
			if(sReturn=="OK")	
			{
				alert("ɾ���ɹ���");
				reloadSelf();
			}
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
		openObject("Customer",sObjectNo,"001");
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
		
		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert(�������Ѿ��ύ�ˣ������ٴ��ύ��);//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}
		
		//����Ƿ�ǩ�����
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
			return;
		}
		
		//���������ύѡ�񴰿�		
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
	
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function signOpinion()
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

		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		sCompID = "SignTaskOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
			sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",BUSINESS_APPLY");
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
	function cancelarch()
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
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BUSINESS_APPLY");
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