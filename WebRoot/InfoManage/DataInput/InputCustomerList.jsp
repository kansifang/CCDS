<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zrli 2007-12-14
		Tester:
		Describe: �Ŵ����ݲ����б�;
		Input Param:
					DataInputType��010�貹���Ŵ�ҵ��
									020��������Ŵ�ҵ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ŵ����ݲ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";
	
	String sClauseWhere="";
	//���ҳ�����
	
	//����������
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag1"));
	if(sReinforceFlag==null) sReinforceFlag="";
	if(sFlag==null) sFlag="";
	
	String sHeaders[][] = {
					{"CustomerName","�ͻ�����"},					
					{"CustomerID","�ͻ����"},
					{"CertType","֤������"},
					{"CertTypeName","֤������"},					
					{"CertID","֤�����"},							
					{"CertTypeName","�ͻ�����"},
					{"CustomerTypeName","�ͻ�����"},											
					{"InputUserID","�Ǽ���"},					
					{"InputUserName","�Ǽ���"},	
					{"InputOrgID","�Ǽǻ���"},
					{"InputOrgName","�Ǽǻ���"},
				  };

	if(sReinforceFlag.equals("010"))  //�����ǹ�˾ҵ��
	{	
		
		sClauseWhere = " from CUSTOMER_INFO CI,ENT_INFO EI where CI.CustomerID=EI.CustomerID and (EI.TempSaveFlag<>'2' or EI.TempSaveFlag='' or EI.TempSaveFlag is null) and CI.InputOrgID='"+CurOrg.OrgID+"' ";
		
	}else if(sReinforceFlag.equals("020"))  //������ɹ�˾��ҵ��
	{
		sClauseWhere = " from CUSTOMER_INFO CI,ENT_INFO EI where CI.CustomerID=EI.CustomerID and EI.TempSaveFlag='2' and CI.InputOrgID='"+CurOrg.OrgID+"' ";
		
	}else if(sReinforceFlag.equals("030"))  //������ɸ��˿ͻ���Ϣ
	{
		sClauseWhere = " from CUSTOMER_INFO CI,IND_INFO II where CI.CustomerID=II.CustomerID and (II.TempSaveFlag<>'2' or II.TempSaveFlag='' or II.TempSaveFlag is null) and CI.InputOrgID='"+CurOrg.OrgID+"' ";	
		
	}else if(sReinforceFlag.equals("040"))  //������ɸ��˿ͻ���Ϣ
	{
		sClauseWhere = " from CUSTOMER_INFO CI,IND_INFO II where CI.CustomerID=II.CustomerID and II.TempSaveFlag='2' and CI.InputOrgID='"+CurOrg.OrgID+"' ";	
		
	}
	
	 sSql = "select CI.CustomerName,CI.CustomerID,CI.CertType,"
			+" getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID,"
			+" CI.CustomerType,getItemName('CustomerType',CI.CustomerType) as CustomerTypeName,"
			+" CI.InputUserID,getUserName(CI.InputUserID) as InputUserName,CI.InputOrgID,getOrgName(CI.InputOrgID) as InputOrgName"
			+sClauseWhere ;

	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("CI.CustomerID");	
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSOTMER_INFO";	
	doTemp.setKey("CustomerID",true);	 //���ùؼ���
	
	//���ò��ɼ���
	doTemp.setVisible("CertType,CustomerType",false);
	
	doTemp.setUpdateable("",false);
	//doTemp.setAlign("BusinessSum,Balance,Interestbalance1,Interestbalance2","3");
	//doTemp.setCheckFormat("BusinessSum,Balance,Interestbalance1,Interestbalance2","2");
	
	//����html��ʽ

	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");

		
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,CustomerID,CertID,ManageOrgIDName","IsFilter","1");
		
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10); 	//��������ҳ

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		//6.��ԴͼƬ·��
	String sButtons[][] = {		
				{"true","","Button","���ǿͻ�","���ǿͻ���Ϣ","InputCustomerInfo()",sResourcesPath},				
				{"true","","Button","���ǿͻ���Ϣ","���ǿͻ���Ϣ","InputCustomerInfo()",sResourcesPath},		
				{"true","","Button","�������","�������","Finished()",sResourcesPath},
				{"true","","Button","�ٴβ���","�ٴβ���","secondFinished()",sResourcesPath},
				{"true","","Button","�ͻ�����","�ͻ�����","CustomerInfo()",sResourcesPath},
				{"true","","Button","�ı�ͻ�����","�ı�ͻ�����","changeCustomerType()",sResourcesPath},
			};
	
	//�貹���Ŵ�ҵ��
	if(sReinforceFlag.equals("010")||sReinforceFlag.equals("030")) 
	{
		
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
	}
	
	//��������Ŵ�ҵ��
	if(sReinforceFlag.equals("020")||sReinforceFlag.equals("040")) 
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[5][0] = "false";		
	}
	
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function CustomerInfo()
	{
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sReturn = PopPage("/InfoManage/DataInput/CustomerQueryAction.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("Ҫ��ѯ�Ŀͻ���Ϣ�����ڣ�");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("Ҫ��ѯ�Ŀͻ�����Ϊ�գ���ѡ��ͻ����ͣ�");
			}
			
			openObject("ReinforceCustomer",sCustomerID,"002");
			
		}
	}

	
	/*~[Describe=���ǿͻ���Ϣ;InputParam=��;OutPutParam=��;]~*/
	function InputCustomerInfo()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sReturn = PopPage("/InfoManage/DataInput/CustomerQueryAction.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("Ҫ���ǵĿͻ���Ϣ�����ڣ�");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("Ҫ���ǵĿͻ�����Ϊ�գ���ѡ��ͻ����ͣ�");
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
				if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
				sCustomerType = sReturn;
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			}
			//openObject("ReinforceCustomer",sCustomerID,"000");
			openObject("ReinforceCustomer",sCustomerID,"000");
		}
	}

	

	/*~[Describe=�ı�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function changeCustomerType()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			sReturn=PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
			if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
			sCustomerType = sReturn;
			sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			reloadSelf();
		}
	}


	/*~[Describe=����ɲ��Ǳ�־;InputParam=��;OutPutParam=��;]~*/
	function Finished()
	{
		//��ͬ��ˮ�š��ͻ���š�ҵ��Ʒ��
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		//��ʾ���ǽ����б�
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm("���Ҫ���������")) 
		{
			var sFlag="<%=sFlag%>";
			
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				alert("ҵ��Ʒ��Ϊ�գ����Ȳ���ҵ��Ʒ�֣�");
				return;
			}else
			{	
				var sExistFlag = PopPage("/InfoManage/DataInput/ReinforceCheckAction.jsp?ContractNo="+sSerialNo+"&CustomerID="+sCustomerID,"","");
				
				if(sExistFlag!="true")
				{
					alert(sExistFlag);
					return;
				}else
				{					
					if(sFlag=="Y")   //�����ʲ��������
					{
						sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag+"&Flag="+sFlag,"","");
					}else
					{
						sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag,"","");
					}
					if(sReturn == "succeed")
					{
						if(sReinforceFlag == "010")
						{
							alert("������ɣ���ҵ����ת����������Ŵ�ҵ���б�!");
						}else
						{
							alert("������ɣ���ҵ����ת��������ɶ���б�!");
						}
						
					}
					reloadSelf();	
				}
			}
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=�ٴβ���;InputParam=��;OutPutParam=��;]~*/
	function secondFinished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm("���Ҫ�ٴβ�����")) 
		{
			
			var sFlag="<%=sFlag%>";
			var sFlag1 = "SecondFlag";
			
			if(sFlag=="Y")   //�����ʲ��������
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag+"&Flag="+sFlag+"&Flag1="+sFlag1,"","");
			}else
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag+"&Flag1=SecondFlag","","");
			}
			
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			
			if(sReturn == "true")
			{
				if(sReinforceFlag == "020")
				{
					alert("�ٴβ��ǣ���ѡ���ݽ��ص��貹��ҵ���б�!");
				}else
				{
					alert("�ٴβ��ǣ���ѡ���ݽ��ص���������б�!");
				}
			}
			
			if(sReturn == "false")
			{
				alert("��ѡ�ʲ��Ѿ��ַ�,�����ٴβ���!");
			}
			
			if(sFlag=="Y")
			{
				OpenComp("DataInputMain","/InfoManage/DataInput/DataInputMain.jsp","ComponentName=��Ϣ����Ǽ�&Component=Y&ReinforceFlag=<%=sReinforceFlag%>&ComponentType=MainWindow","_top","")
			}else
			{
				OpenComp("DataInputMain","/InfoManage/DataInput/DataInputMain.jsp","ComponentName=��Ϣ����Ǽ�&Component=N&ReinforceFlag=<%=sReinforceFlag%>&ComponentType=MainWindow","_top","")
			}
		}
	}


	/*~[Describe=�ϲ���ͬ;InputParam=��;OutPutParam=��;]~*/
	function UniteContract()
	{
		//��ͬ��ˮ�š��ͻ���š���ͬ���
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sArtificialNo   = getItemValue(0,getRow(),"ArtificialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{			
			 var sReturn = popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&ArtificialNo="+sArtificialNo+"&CustomerID="+sCustomerID,"dialogWidth=50;dialogHeight=40;","resizable=yes;scrollbars=yes;status:no;maximize:yes;help:no;");
			 if(sReturn=="true")
			 {
				reloadSelf();
			 }	
		}
	}

	/*~[Describe=�Ѻϲ���ͬ��ѯ;InputParam=��;OutPutParam=��;]~*/
	function QueryContract()
	{
		//��ͬ��ˮ�š��ͻ���š���ͬ���
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{			
			 popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&CustomerID="+sCustomerID+"&Flag=QueryContract","_self","dialogWidth=100;dialogHeight=20;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
		}
	}

	function RelativeBusiness()
	{
		//��ͬ��ˮ�š��ͻ���š���ͬ���
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			if (sBusinessType == '1100050' )
			{
				sParaString = "CustomerID"+","+sCustomerID;
				sRelativeContractNo=setObjectValue("SelectOutContract","","",0,0,"");
				if(typeof(sRelativeContractNo)=="undefined" || sRelativeContractNo.length==0 || sRelativeContractNo == "_CANCEL_" || sRelativeContractNo == "_CLEAR_")
				{
				    return;
				}
				sRelativeContractNo = sRelativeContractNo.split("@");
				sRelativeContractNo=sRelativeContractNo[0];

				sReturn = PopPage("/CreditManage/CreditCheck/RelativeBusinessAction.jsp?SerialNo="+sSerialNo+"&RelativeContractNo="+sRelativeContractNo,"","");
				if(sReturn == "succeed")
				{
					alert("�����ɹ�");
				}else if(sReturn == "fail")
				{
				    alert("�ú�ͬ�ѱ�����");
				}
			}else
			{
				alert("��ǰҵ���ǵ��ҵ����ѡ��һ�ʵ��ҵ��չ��");
			}
		}
	}

	/*~[Describe=̨�ʹ���;InputParam=��;OutPutParam=��;]~*/
	function Account()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBalance   = getItemValue(0,getRow(),"Balance");
		sInterestbalance1   = getItemValue(0,getRow(),"Interestbalance1");
		sInterestbalance2   = getItemValue(0,getRow(),"Interestbalance2");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if((sBalance=="0" || sBalance=="") && (sInterestbalance1=="0" || sInterestbalance1=="") && (sInterestbalance2=="0" || sInterestbalance2==""))
			{
			    OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","cando=Y&ComponentName=�ս���Ϣ&ObjectNo="+sSerialNo,"_blank",OpenStyle);
			}
			else
			{
			    OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","ComponentName=�ս���Ϣ&ObjectNo="+sSerialNo,"_blank",OpenStyle);
			}
		}
	}
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
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
