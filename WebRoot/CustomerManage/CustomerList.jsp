<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --cchang  2004.12.2
		       
		Tester:	
		Content: �ͻ���Ϣ�б�
		Input Param:
			CustomerType���ͻ�����
				01����˾�ͻ���
				0201��һ�༯�ſͻ���
				0202�����༯�ſͻ���
				03�����˿ͻ�
            CustomerListTemplet���ͻ��б�ģ�����
            sCustomerScale����˾�ͻ���ģ CustomerScale 010 ������ҵ 020 ������ҵ 022 С����ҵ 024 ΢����ҵ
		���ϲ���ͳһ�ɴ����:--MainMenu���˵��õ�����
		Output param:
		   CustomerID���ͻ����
           CustomerType���ͻ�����		                				
           CustomerName���ͻ�����
           CertType���ͻ�֤������						                
           CertID���ͻ�֤������
		History Log: 
			DATE	CHANGER		CONTENT
			2005-07-20	fbkang	ҳ������
			2005/09/10 zywei �ؼ����
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ���Ϣ�б�"   ; // ��������ڱ��� <title> PG_TITLE </title>  
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//��� sql���	
	String sUserID = CurUser.UserID; //�û�ID
	String sOrgID = CurOrg.OrgID; //����ID
	
	//����������	���ͻ����͡��ͻ���ʾģ���
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	String sTempletNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerListTemplet"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	
	//����ֵת��Ϊ���ַ���
	if(sCustomerType == null) sCustomerType = "";
	if(sTempletNo == null) sTempletNo = "";
	if(sCustomerScale == null) sCustomerScale = "";
	//���ҳ�����
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sCustomerType.substring(0,2).equals("02"))//���ſͻ�
		doTemp.setKeyFilter("EI.CustomerID||CB.CustomerID||CB.OrgID||CB.UserID");	
	else
		doTemp.setKeyFilter("CI.CustomerID||CB.CustomerID||CB.OrgID||CB.UserID");//add by hxd in 2005/02/20 for �ӿ��ٶ�
	doTemp.setHTMLStyle("OrgName","style={width=200px}");
	doTemp.setHTMLStyle("UserName","style={width=80px}");	
	//���ӹ�����	
	doTemp.setColumnAttribute("CustomerName,CustomerID,CertID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(10); //add by hxd in 2005/02/20 for �ӿ��ٶ�
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sCustomerType+","+sOrgID+","+sCustomerScale);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //����datawindow��Sql���÷���
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼� 
		//6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{((!sCustomerScale.equals("")&&sCustomerScale.substring(0,2).equals("02"))?"false":"true"),"","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{((!sCustomerScale.equals("")&&sCustomerScale.substring(0,2).equals("02"))?"true":"false"),"","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{(sCustomerType.substring(0,2).equals("01")?"true":"false"),"","Button","�ͻ���ϢԤ��","�ͻ���ϢԤ��","alarmCustInfo()",sResourcesPath},
			//modify by xhyong 2009/08/10
			{((sCustomerType.substring(0,2).equals("02")||sCustomerType.equals("0401")||sCustomerType.equals("0501"))?"false":"true"),"","Button","�����ص�ͻ�����","�����ص�ͻ�����","addUserDefine()",sResourcesPath},
			{((sCustomerType.substring(0,2).equals("02")||sCustomerType.substring(0,2).equals("04")||sCustomerType.substring(0,2).equals("05"))?"false":"true"),"","Button","Ȩ������","Ȩ������","ApplyRole()",sResourcesPath},
			{((sCustomerType.substring(0,2).equals("02")||sCustomerType.substring(0,2).equals("04")||sCustomerType.substring(0,2).equals("05"))?"false":"true"),"","Button","�ջ�Ȩ������","�ջ�Ȩ������","BackApplyRole()",sResourcesPath},
			//end
			{(sCustomerType.substring(0,2).equals("01")&&!sCustomerType.equals("0107")?"true":"false"),"","Button","�ı�ͻ�����","�ı�ͻ�����","changeCustomerType()",sResourcesPath},
			{(sCustomerType.substring(0,2).equals("01")?"false":"false"),"","Button","�϶��ͻ���ģ","�϶��ͻ���ģ","confirmScale()",sResourcesPath},
			{"false","","Button","�ͻ�����","�鿴�ͻ�������Ϣ������ҵ����Ϣ","viewCustomerInfo()",sResourcesPath},
			{((sCustomerType.substring(0,2).equals("02")||sCustomerType.equals("0401")||sCustomerType.equals("0501")||sCustomerType.equals("0107"))?"false":"true"),"","Button","��ȡ���Ŀͻ���","��ȡ���Ŀͻ���","getMFCustomerID()",sResourcesPath},
		};

		
	%> 
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
		var sCustomerType='<%=sCustomerType%>';//--�ͻ�����
		var sCustomerScale='<%=sCustomerScale%>';//--�ͻ���ģ
		var sCustomerID ='';//--�ͻ�����
		var sReturn ='';//--����ֵ���ͻ���¼����Ϣ�Ƿ�ɹ�
		var sReturnStatus = '';//--��ſͻ���Ϣ�����
		var sStatus = '';//--��ſͻ���Ϣ���״̬		
		var sReturnValue = '';//--��ſͻ�������Ϣ
		//�ͻ���Ϣ¼��ģ̬�����	
		//�������ֿͻ����ͣ���Ϊ���ƶԻ����չʾ��С
		if(sCustomerType == "01"||sCustomerType == "03"||sCustomerType == "0107") 
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
			sReturnStatus = PopPage("/CustomerManage/CheckCustomerAction.jsp?CustomerType="+sCustomerType+"&CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
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
			}
			
			//�������Ϊ�޸ÿͻ���û�к��κοͻ���������Ȩ���������ͻ���������Ȩʱ���ж����ݿ����
			if(sStatus == "01" || sStatus == "04" || sStatus == "05")
			{
				sReturn = PopPage("/CustomerManage/AddCustomerAction.jsp?CustomerType="+sCustomerType+"&CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID+"&ReturnStatus="+sStatus+"&CustomerID="+sCustomerID+"&CustomerScale="+sCustomerScale+"","","");
				//���ÿͻ��������û�������Ч������Ϊ��ҵ�ͻ��͹������� ,��Ҫ��ϵͳ����Ա����Ȩ��
				if(sReturn == "succeed" && sStatus == "05" )
				{
					if(confirm(getBusinessMessage('103'))) //�ͻ��ѳɹ����룬Ҫ��������ÿͻ��Ĺܻ�Ȩ��
					    popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.UserID%>&OrgID=<%=CurOrg.OrgID%>","");					
				//���ÿͻ�û�����κ��û�������Ч��������ǰ�û�����ÿͻ�������Ч�������ÿͻ��������û�������Ч���������˿ͻ�/���幤�̻�/ũ��/����С�飩�Ѿ�����ͻ�
				}else if(sReturn == "succeed" && (sStatus == "04"))
				{
					alert(getBusinessMessage('108')); //�ͻ�����ɹ�
				//�Ѿ������ͻ�
				}else if(sReturn == "succeed" && sStatus == "01")
				{
					alert(getBusinessMessage('109')); //�����ͻ��ɹ�
				}
			}
			
			if(sStatus == "01" || sStatus == "04")
			{
				openObject("Customer",sCustomerID,"001");
				
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=������С��ҵ��¼;InputParam=��;OutPutParam=��;]~*/
	function newSMERecord()
	{
		var sCustomerType='<%=sCustomerType%>';//--�ͻ�����
		var sCustomerScale='<%=sCustomerScale%>';//--�ͻ���ģ
		var sCustomerID ='';//--�ͻ�����
		var sReturn ='';//--����ֵ���ͻ���¼����Ϣ�Ƿ�ɹ�
		var sReturnStatus = '';//--��ſͻ���Ϣ�����
		var sStatus = '';//--��ſͻ���Ϣ���״̬		
		var sReturnValue = '';//--��ſͻ�������Ϣ
		
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
			sReturnStatus = PopPage("/CustomerManage/CheckCustomerAction.jsp?CustomerType="+sCustomerType+"&CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
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
			
			//�������Ϊ�޸ÿͻ���û�к��κοͻ���������Ȩ���������ͻ���������Ȩʱ���ж����ݿ����
			if(sStatus == "04" || sStatus == "05")
			{
				sReturn = PopPage("/CustomerManage/AddCustomerAction.jsp?CustomerType="+sCustomerType+"&CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID+"&ReturnStatus="+sStatus+"&CustomerID="+sCustomerID+"&CustomerScale="+sCustomerScale+"","","");
				//���ÿͻ��������û�������Ч������Ϊ��ҵ�ͻ��͹������� ,��Ҫ��ϵͳ����Ա����Ȩ��
				if(sReturn == "succeed" && sStatus == "05" )
				{
					if(confirm(getBusinessMessage('103'))) //�ͻ��ѳɹ����룬Ҫ��������ÿͻ��Ĺܻ�Ȩ��
					    popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.UserID%>&OrgID=<%=CurOrg.OrgID%>","");					
				//���ÿͻ�û�����κ��û�������Ч��������ǰ�û�����ÿͻ�������Ч�������ÿͻ��������û�������Ч���������˿ͻ�/���幤�̻�/ũ��/����С�飩�Ѿ�����ͻ�
				}else if(sReturn == "succeed" && (sStatus == "04"))
				{
					alert(getBusinessMessage('108')); //�ͻ�����ɹ�
				//�Ѿ������ͻ�
				}else if(sReturn == "succeed" && sStatus == "01")
				{
					alert(getBusinessMessage('109')); //�����ͻ��ɹ�
				}
			}
			
			if(sStatus == "01" || sStatus == "04")
			{
				openObject("Customer",sCustomerID,"001");
				
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			sReturn = PopPage("/CustomerManage/DelCustomerBelongAction.jsp?CustomerID="+sCustomerID+"","","");
			if(sReturn == "ExistApply")
			{
				alert(getBusinessMessage('113'));//�ÿͻ���������ҵ��δ�սᣬ����ɾ����
	 			return;
			}
			if(sReturn == "ExistApprove")
			{
				alert(getBusinessMessage('112'));//�ÿͻ����������������ҵ��δ�սᣬ����ɾ����
	 			return;
			}
			if(sReturn == "ExistContract")
			{
				alert(getBusinessMessage('111'));//�ÿͻ�������ͬҵ��δ�սᣬ����ɾ����
	 			return;
			}
			if(sReturn == "DelSuccess")
			{
				alert(getBusinessMessage('110'));//�ÿͻ�������Ϣ��ɾ����
	 			reloadSelf();
			}
		}
	}
	
	//�ͻ���ϢԤ��
	function alarmCustInfo()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
		}else 
		{					
			popComp("ScenarioAlarm.jsp","/PublicInfo/ScenarioAlarm.jsp","OneStepRun=no&ScenarioNo=005&ObjectType=CustomerID&ObjectNo="+sCustomerID,"dialogWidth=50;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
		}		
	}
	
	/*~[Describe=�ı�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function changeCustomerType()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }

        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];
        sReturnValue2 = sReturnValue[1];
        sReturnValue3 = sReturnValue[2];
                        
        if(sReturnValue1 == "Y" || sReturnValue3 == "Y2")
        {    		
    		sCustomerType = PopPage("/CustomerManage/ChangeCustomerTypeDialog.jsp","","dialogWidth=20;dialogHeight=8;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
			if(sCustomerType == "" || sCustomerType == "_CANCEL_" || typeof(sCustomerType) == "undefined") return;
			sReturn = PopPage("/CustomerManage/ChangeCustomerTypeAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			if(sReturn == "_TRUE_")
			{
				alert(getBusinessMessage('106'));//�ı�ͻ����ͳɹ���"
				reloadSelf();
				return;
			}else
			{
				alert(getBusinessMessage('107'));//�ı�ͻ�����ʧ�ܣ������²�����
				return;
			}
    		
		}else
		{
		    alert(getBusinessMessage('249'));//����Ȩ���ĸÿͻ���Ȩ�ޣ�
		}
				
	}
	/*~[Describe=�϶��ͻ���ģ;InputParam=��;OutPutParam=��;]~*/
	function confirmScale()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		alert("�����!")				
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID) == "undefined" || sCustomerID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }

        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];
        sReturnValue2 = sReturnValue[1];
        sReturnValue3 = sReturnValue[2];
                        
        if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2")
        {    		
    		openObject("Customer",sCustomerID+"&<%=sCustomerScale%>","001");
    		reloadSelf();
		}else
		{
		    alert(getBusinessMessage('115'));//�Բ�����û�в鿴�ÿͻ���Ȩ�ޣ�
		}
	}
	
	/*~[Describe=�����ص���Ϣ����;InputParam=CustomerID,ObjectType=Customer;OutPutParam=��;]~*/
	function addUserDefine()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage('114'))) //������ͻ���Ϣ�����ص�ͻ���������?
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=Customer&ObjectNo="+sCustomerID,"","");
		}
	}
		
	/*~[Describe=Ȩ������;InputParam=CustomerID,ObjectType=Customer;OutPutParam=��;]~*/			
	function ApplyRole()
	{   
        //��ÿͻ����
        sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		//�������״̬
		sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");           
        if(sApplyStatus == "1")
        {
            alert(getBusinessMessage('116'));//���ύ����,�����ٴ��ύ��
            return;
        }
        //��ÿͻ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ
        sBelongAttribute = getItemValue(0,getRow(),"BelongAttribute");        
        sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");
        sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");
        sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");        
        if(sBelongAttribute == "��" && sBelongAttribute1 == "��" && sBelongAttribute2 == "��" && sBelongAttribute3 == "��")
        {
            alert(getBusinessMessage('117'));//���Ѿ�ӵ�иÿͻ�������Ȩ�ޣ�
            return;
        }
        
		popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.UserID%>&OrgID=<%=CurOrg.OrgID%>","");
		reloadSelf();
	}
	
	function BackApplyRole()
	{
	    //��ÿͻ����
        sCustomerID = getItemValue(0,getRow(),"CustomerID");
        sUserID = getItemValue(0,getRow(),"UserID");	
        sOrgID = getItemValue(0,getRow(),"OrgID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		//�������״̬
		sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");           
        if(sApplyStatus != "1")
        {
            alert('���������ύ����δ��׼/�����Ȩ�����룡');
            return;
        }
        RunMethod("CustomerManage","UpdateApplyRole",sCustomerID+","+sOrgID+","+sUserID);
        reloadSelf();
	}
	
	function viewCustomerInfo()
	{
		//��ÿͻ����
        sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		popComp("EntInfo","/CustomerManage/EntManage/EntInfo.jsp","CustomerID="+sCustomerID,"");
	}
	
	function getMFCustomerID()
	{
		//��ÿͻ����
        sCustomerID = getItemValue(0,getRow(),"CustomerID");		
        sTradeType = "798001";	
        sObjectNo = sCustomerID;
        sObjectType = "Customer";
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
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
			alert("ȡ�ú��Ŀͻ��ųɹ�["+sReturn[1]+"]");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>