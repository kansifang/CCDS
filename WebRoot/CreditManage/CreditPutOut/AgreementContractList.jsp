<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lpzhang 2009-9-9
		Tester:
		Describe: 
		Input Param:
				DealType��
				    05δ��Ч�Ķ��
					06����Ч�Ķ��
					07���ս�Ķ��
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql1="";
	
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"CustomerName","�ͻ�����"},
							{"SerialNo","��ͬ��ˮ��"},
							{"OccurTypeName","��������"},
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"ManageOrgName","�������"},
						  };
	String 	sSql = "";
	sSql =  " select SerialNo,CustomerID,CustomerName,"+
			" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			" ArtificialNo,"+
			" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
			" BusinessSum,TempSaveFlag,"+
			" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
			" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
			" PutOutDate,Maturity,"+
			" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName"+
			" from BUSINESS_CONTRACT "+
			" where ManageUserID = '"+CurUser.UserID+"' "+ 
			" and BusinessType like '30%'"+
 			" and (DeleteFlag = ''  or  DeleteFlag is null) ";
	
	if(sDealType.equals("05100"))//δ��Ч
	{
	    sSql1 =" and (InUseFlag ='' or InUseFlag is null) and (FinishDate='' or FinishDate is null  )";
	}
	else if(sDealType.equals("05110"))//����Ч
	{
		sSql1 =" and InUseFlag='01' and (FinishDate='' or FinishDate is null)";
	}
	else if(sDealType.equals("05120"))//���ս�
	{
		sSql1 =" and (FreezeFlag = '4'  or  FinishDate is not null) ";
	}
	sSql = sSql + sSql1 + " order by SerialNo desc ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable="BUSINESS_CONTRACT";
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("ArtificialNo,CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,ManageOrgID,TempSaveFlag",false);
	if (sDealType.equals("030")) {
		doTemp.setVisible("RelativeSum",false);
	}

	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,RelativeSum,Balance","3");
	doTemp.setAlign("Currency,OccurTypeName","2");
	doTemp.setType("BusinessSum,RelativeSum,Balance","Number");
	
	doTemp.setCheckFormat("BusinessSum,RelativeSum,Balance","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:120px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
    
    doTemp.setFilter(Sqlca,"1","SerialNo","");
    doTemp.setFilter(Sqlca,"2","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"3","BusinessSum","");
	doTemp.setFilter(Sqlca,"4","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
    
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10); 	//��������ҳ

	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(BusinessContract,#SerialNo,DeleteBusiness)"); 
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//��֯���кϼ��ò��� add by zrli 
	String[][] sListSumHeaders = {	{"BusinessCurrency","����"},
									{"BusinessSum","��ͬ���"},
								 };
	String sListSumSql = "Select BusinessCurrency,Sum(BusinessSum) as BusinessSum "
						+ " From BUSINESS_CONTRACT "
						+ doTemp.WhereClause
						+ " Group By BusinessCurrency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"false","","Button","������ͬ","������ͬ","newRecord()",sResourcesPath},
		{"true","","Button","��ͬ����","��ͬ����","viewTab()",sResourcesPath},
		{"false","","Button","ȡ����ͬ","ȡ����ͬ","cancelContract()",sResourcesPath},
		{"false","","Button","�����Ч","�����Ч","AgreementInUse()",sResourcesPath},
		{"true","","Button","�����ص�����","�����ص��ͬ����","addUserDefine()",sResourcesPath},
		{"true","","Button","����","������","listSum()",sResourcesPath},
		{"false","","Button","���ʧЧ","���ʧЧ","cancelAgreement()",sResourcesPath}
	};
	if(sDealType.equals("05100"))
	{	
		sButtons[0][0] ="true";
		sButtons[2][0] ="true";
		sButtons[3][0] ="true";
	}else if(sDealType.equals("05110"))
	{
		sButtons[6][0] ="true";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
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

	/*~[Describe=�����ص��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function addUserDefine()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage('420'))) //Ҫ�������ͬ��Ϣ�����ص��ͬ��������
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
		}
		reloadSelf();
	}
	
	/*~[Describe=�����Ч;InputParam=��;OutPutParam=��;]~*/
	function AgreementInUse()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sOccurType = getItemValue(0,getRow(),"OccurType");
		sTempSaveFlag = getItemValue(0,getRow(),"TempSaveFlag");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(sTempSaveFlag == '1')
		{
			alert("��ͬ��Ϣδ���棬������Ч��");
			retrun;
		}
		//��鵣����ͬ��û�еǼ�����
		sReturn=RunMethod("CreditLine","CheckGuarantyContract",sSerialNo);
		if(sReturn>0){
			alert("������ͬ��Ϣδ���棬������Ч��");
			return;
		}
		if(sOccurType == "100")
		{
			//�����û���������Ƿ���û�еǼǺ�ͬ������
			sReturn=RunMethod("CreditLine","CheckCustomerApply",sSerialNo);
			if(parseFloat(sReturn)>0)
			{
				alert("����δ�ǼǺ�ͬ�Ķ������ҵ��");
				retrun;
			}
			if(confirm("�ö��������Ч��ԭ�ۺ����Ŷ�Ƚ����ս� \r\n��ȷ����")) 
			{
				sReturn=RunMethod("CreditLine","ChangeAgreementInuse",sSerialNo+","+sCustomerID+","+sBusinessType+","+sOccurType); 
				if(typeof(sReturn)=="undefined" || sReturn.length==0) 
				{
					alert("����ʧ��!");
				}else{
					alert("�����ɹ�!");
				}
				reloadSelf();
			}
		}else
		{
			sReturn=RunMethod("CreditLine","ChangeAgreementInuse",sSerialNo+","+sCustomerID+","+sBusinessType+","+sOccurType); 
			if(sReturn != "1") 
			{
				alert("����ʧ��!");
			}else{
				alert("�����ɹ�!");
			}
			reloadSelf();
		}
	}

	/*~[Describe=��ɷŴ�;InputParam=��;OutPutParam=��;]~*/
	function archive(){
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage('421'))) //������뽫�ñʺ�ͬ��Ϊ��ɷŴ���
		{
			sReturn = PopPage("/Common/WorkFlow/AddPigeonholeAction.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","");
			if(typeof(sReturn)!="undefined" && sReturn!="failed")
				reloadSelf();
			alert(getBusinessMessage('422'));//�ñʺ�ͬ�Ѿ���Ϊ��ɷŴ���
		}
	}

	/*~[Describe=ȡ����ͬ;InputParam=��;OutPutParam=��;]~*/
	function cancelContract()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('70')))//�������ȡ������Ϣ��
		{
		    sReturn = PopPage("/CreditManage/CreditPutOut/CheckContractDelAction.jsp?ObjectNo="+sObjectNo,"","");
	        if (typeof(sReturn)=="undefined" || sReturn.length==0)
	       	{
	            as_del('myiframe0');
	            as_save('myiframe0');  //�������ɾ������Ҫ���ô����
	        }else if(sReturn == 'Reinforce')
	        {
	            alert(getBusinessMessage('425'));//�ú�ͬΪ���Ǻ�ͬ������ɾ����
	            return;
	        }else if(sReturn == 'Finish')
	        {
	            alert(getBusinessMessage('426'));//�ú�ͬ�Ѿ����ս��ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'Pigeonhole')
	        {
	            alert(getBusinessMessage('427'));//�ú�ͬ�Ѿ���ɷŴ��ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'PutOut')
	        {
	            alert(getBusinessMessage('428'));//�ú�ͬ�Ѿ������ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'Other')
	        {
	            alert(getBusinessMessage('429'));//�ú�ͬ�ܻ���Ϊ������Ա������ɾ����
	            return;
	        }else if(sReturn == 'Use')
	        {
	            alert(getBusinessMessage('430'));//�����Ŷ���ѱ�ռ�ã�����ɾ����
	            return;
	        }
		}
	}
	
	/*~[Describe=������ͬ;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sParaString = "ObjectType"+","+"CreditApply"+","+"UserID"+","+"<%=CurUser.UserID%>";
		sReturn = setObjectValue("SelectApplyForContract1",sParaString,"",0,0,"");		
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;

		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sReturn=RunMethod("BusinessManage","InitializeContract","CreditApply,"+sObjectNo+","+"<%=CurUser.UserID%>"+","+"<%=CurOrg.OrgID%>");
	    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
		alert("��������׼���������ɺ�ͬ�ɹ�����ͬ��ˮ��["+sReturn+"]��\n\r�������д��ͬҪ�ز������桱���Ժ��ڡ�����ɷŴ��ĺ�ͬ���б���ѡ��ú�ͬ����д��ͬҪ�أ�");
		sObjectType = "BusinessContract";
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	 /*~[Describe=������;InputParam=��;OutPutParam=��;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
	}
	   
	//ȡ�����
	function cancelAgreement()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sReturn = RunMethod("CreditLine","SelectAgreement",sSerialNo);
		if(sReturn == "0")
		{
			var sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@InUseFlag@None,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{
				alert("�����ʧЧ");
			}else
			{
				alert("����ʧ��");
			}
			reloadSelf();
		}else
		{
			alert("������»���ҵ�񣬲���ʧЧ");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>