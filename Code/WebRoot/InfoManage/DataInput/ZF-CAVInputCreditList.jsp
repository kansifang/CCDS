<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: slliu 2005-03-25
		Tester:
		Describe: �����ʲ������б�;
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
	String PG_TITLE = "�����ʲ������б�"; // ��������ڱ��� <title> PG_TITLE </title>
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

	String sHeaders[][] = {
					{"SerialNo","��ͬ��ˮ��"},
					{"CustomerName","�ͻ�����"},
					{"CustomerTypeName","�ͻ�����"},
					{"CustomerID","�ͻ����"},
					{"CertID","��֯��������"},
					{"BusinessTypeName","ҵ��Ʒ��"},
					{"OccurTypeName","��������"},
					{"FinishType","�ս᷽ʽ"},
					{"FinishTypeName","�ս᷽ʽ"},
					{"ShiftType","�ƽ���ʽ"},
					{"ShiftTypeName","�ƽ���ʽ"},									
					{"Currency","����"},
					{"BusinessSum","��ͬ���(Ԫ)"},
					{"Balance","���(Ԫ)"},
					{"VouchTypeName","��Ҫ������ʽ"},
					{"PutOutDate","��ʼ����"},
					{"Maturity","��������"},
					{"ManageOrgIDName","�ܻ�����"},
					{"ManageUserIDName","�ܻ���"}
					
				  };

	if(sReinforceFlag.equals("010"))  //�����Ǻ����ʲ�
	{
	
		sClauseWhere = 	" and BC.ManageOrgID in (select BelongOrgId from ORG_BELONG where OrgId='"+CurOrg.OrgID+"') "+
						" and (BC.DeleteFlag =''  or  BC.DeleteFlag is null) order by BC.CustomerID ";		
	}
	if(sReinforceFlag.equals("020"))  //������ɺ����ʲ�
	{		
		sClauseWhere = 	" and BC.ManageOrgID in (select BelongOrgId from ORG_BELONG where OrgId='"+CurOrg.OrgID+"') "+
						" and (BC.DeleteFlag =''  or  BC.DeleteFlag is null) order by BC.CustomerID ";		
	}
	
	 sSql = " select BC.SerialNo,CI.CustomerName as CustomerName,"+
			" BC.CustomerID as CustomerID,CI.CertID as CertID,getCustomerType(CI.CustomerID) as CustomerType,"+
			" getItemName('CustomerType',CI.CustomerType) as CustomerTypeName,"+
			" BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.OccurType,BC.FinishType,getItemName('FinishType',BC.FinishType) as FinishTypeName,"+
			" BC.ShiftType,getItemName('ShiftType',BC.ShiftType) as ShiftTypeName,"+
			" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as Currency,"+
			" BC.BusinessSum,BC.Balance,"+
			" BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
			" BC.PutOutDate,BC.Maturity,"+
			" getUserName(BC.ManageUserID) as ManageUserIDName,"+
			" getOrgName(BC.ManageOrgID) as ManageOrgIDName "+			
			" from BUSINESS_CONTRACT BC,CUSTOMER_INFO CI"+
			" where BC.CustomerID=CI.CustomerID and (BC.BusinessType like '[1,2,5]%' or BC.BusinessType is null or BC.BusinessType ='')"+
			" and BC.ReinforceFlag= '"+sReinforceFlag+"' "+
			" and (BC.FinishType like '060%' ) "
			+sClauseWhere ;
	
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
		
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//out.println(sSql);
	doTemp.setKeyFilter("BC.SerialNo||CI.CustomerID");		//add by hxd in 2005/02/20 for �ӿ��ٶ�
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,CustomerType,OccurType,BusinessCurrency,VouchType",false);
	doTemp.setVisible("BusinessType,FinishType,ShiftType",false);

	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerTypeName,CertID,ManageUserIDName"," style={width:80px} ");	
	doTemp.setHTMLStyle("CustomerTypeName,FinishTypeName,ShiftTypeName,Currency"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:170px} ");
	doTemp.setHTMLStyle("VouchTypeName,ManageOrgIDName,ManageUserIDName"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserIDName"," style={width:60px} ");
	doTemp.setHTMLStyle("BusinessTypeName,BusinessSum,Balance"," style={width:100px} ");
		
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,SerialNo","IsFilter","1");
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
				{"true","","Button","����ҵ��","����ҵ����Ϣ","InputBusinessInfo()",sResourcesPath},
				{"true","","Button","�������","�������","NewContract()",sResourcesPath},
				{"true","","Button","�������","�������","BusinessInfo()",sResourcesPath},
				{"true","","Button","ɾ�����","ɾ�����","DeleteContract()",sResourcesPath},
				{"true","","Button","���ǿͻ���Ϣ","���ǿͻ���Ϣ","InputCustomerInfo()",sResourcesPath},		
				{"true","","Button","�������","�������","Finished()",sResourcesPath},
				{"true","","Button","�ͻ�����","�ͻ�����","CustomerInfo()",sResourcesPath},
				{"true","","Button","ҵ������","ҵ������","BusinessInfo()",sResourcesPath},
				{"true","","Button","�ٴβ���","�ٴβ���","secondFinished()",sResourcesPath},
				{"true","","Button","�ı�ҵ��Ʒ��","�ı�ҵ��Ʒ��","changeBusinessType()",sResourcesPath},
				{"true","","Button","�ı�ͻ�����","�ı�ͻ�����","changeCustomerType()",sResourcesPath},
				{"true","","Button","��ͬ�ϲ�","��ͬ�ϲ�","UniteContract()",sResourcesPath},
				{"true","","Button","�ƽ���ȫ","�������ʲ��ƽ���ȫ������","ShiftRMDepart()",sResourcesPath},
				//Add by wuxiong 20050709 ȥ��ɾ��������,change by ndeng 20050720 ����ȥ��
				{"true","","Button","������ͬ","������ͬ","NewContract()",sResourcesPath},
				//Add by wuxiong 20050709 ȥ��ɾ��������,change by ndeng 20050720 ����ȥ��
				{"true","","Button","ɾ����ͬ","ɾ����ͬ","DeleteContract()",sResourcesPath},
			
			};
	//�貹���Ŵ�ҵ��
	if(sReinforceFlag.equals("010")) 
	{
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[7][0] = "false";
		sButtons[8][0] = "false";
		sButtons[9][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
	}
	
	//��������Ŵ�ҵ��
	if(sReinforceFlag.equals("020")) 
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "false";		
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";	
		sButtons[14][0] = "false";
		sButtons[15][0] = "false";		
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
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function DeleteContract()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");		
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{				
			if(sBusinessType.substring(0,4)=="1020" || sBusinessType=="5010" || sBusinessType=="5020")	
			{
				//���ΪƱ�����֣�����ɾ��
				if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
				{
					as_del("myiframe0");
					as_save("myiframe0");  //�������ɾ������Ҫ���ô����
					
					
				}
			}else	//�����ΪƱ�����֣�������ɾ��
			{
				alert("��628ϵͳ��������ݲ���ɾ����");
				return;
			}			
		}
	}
	
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

	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function BusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if(sReinforceFlag=="110") 
			{
				openObject("AfterLoan",sSerialNo,"000");
			}else
			{
				openObject("AfterLoan",sSerialNo,"002");
			}
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
			openObject("ReinforceCustomer",sCustomerID,"000");
		}
	}

	/*~[Describe=����ҵ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function InputBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
			
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				sCustomerType   = getItemValue(0,getRow(),"CustomerType");
				sCustomerType = sCustomerType.substr(0,3);
				sReturn=selectObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=N");
				
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];
					sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
				
				}
				else if (sReturn=='_CLEAR_')
				{
					return;
				}
				else 
				{
					return;
				}
			}
			
			openObject("ReinforceContract",sSerialNo,"000");
			reloadSelf();
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

	/*~[Describe=�ı�ҵ��Ʒ��;InputParam=��;OutPutParam=��;]~*/
	function changeBusinessType()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			sCustomerType   = getItemValue(0,getRow(),"CustomerType");
			sCustomerType = sCustomerType.substr(0,3);
			if(sReinforceFlag=="010") //�貹���Ŵ�ҵ�����
			{
				sReturn=selectObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=N");
			}else		//�����Ŵ�ҵ�����
			{
				sReturn=selectObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=Y");

			}
			
			if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
			{
				sss1 = sReturn.split("@");
				sBusinessType=sss1[0];
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
				reloadSelf();
				
			}else if (sReturn=='_CLEAR_')
			{
				return;
			}
			else 
			{
				return;
			}
		
		}
	}

	/*~[Describe=������ͬ;InputParam=��;OutPutParam=��;]~*/
	function NewContract()
	{
		
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		//������ͬ����
		var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag+"~ReinforceFlag=G~ListFlag=CAVInputCreditList");
		
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sss = sReturn.split("@");
		sSerialNo=sss[0];

		
		openObject("ReinforceContract",sSerialNo,"000");
		
		reloadSelf();

		
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
					sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag,"","");
					
					if(sReturn == "succeed")
					{
						if(sReinforceFlag == "010")
						{
							alert("������ɣ���ҵ����ת��������ɵĺ����ʲ��б�!");
						}
						
					}					
					OpenComp("CAVDataInputMain","/InfoManage/DataInput/CAVDataInputMain.jsp","ComponentName=�����ʲ�����Ǽ�&ReinforceFlag=<%=sReinforceFlag%>&ComponentType=MainWindow","_top","");
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
			
			var sFlag1 = "SecondFlag";
			
			sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag+"&Flag1=SecondFlag","","");
			
			
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			
			if(sReturn == "true")
			{
				if(sReinforceFlag == "020")
				{
					alert("�ٴβ��ǣ���ѡ���ݽ��ص��貹�Ǻ����ʲ��б�!");
				}				
			}			
			OpenComp("CAVDataInputMain","/InfoManage/DataInput/CAVDataInputMain.jsp","ComponentName=�����ʲ�����Ǽ�&ReinforceFlag=<%=sReinforceFlag%>&ComponentType=MainWindow","_top","");
		}
	}

    /*~[Describe=�ƽ���ȫ����;InputParam=��;OutPutParam=��;]~*/
	function ShiftRMDepart()
	{
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{       
		
			var sTrace= PopPage("/RecoveryManage/Public/NPAShiftDialog.jsp","","dialogWidth=25;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		
			if(typeof(sTrace)!="undefined" && sTrace.length!=0)
			{				
				var sTrace=sTrace.split("@");
				
				//����ƽ����͡���ȫ����
				var sShiftType = sTrace[0];
				var sTraceOrgID = sTrace[1];
				var sTraceOrgName = sTrace[2];
				
				if(typeof(sTraceOrgID)!="undefined" && sTraceOrgID.length!=0)
				{
					var sReturn = PopPage("/RecoveryManage/Public/CAVShiftAction.jsp?SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"&TraceOrgID="+sTraceOrgID+"","","");
					if(sReturn == "true") //ˢ��ҳ��
					{
						alert("�ò����ʲ��ɹ��ƽ�����"+sTraceOrgName+"��"); 
						reloadSelf();
					}else
					{
						alert("�ò����ʲ��Ѿ��ƽ��������ٴ��ƽ���"); 
						reloadSelf();
					}
				}
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
		var sArtificialNo   = getItemValue(0,getRow(),"ArtificialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			
			 popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&ArtificialNo="+sArtificialNo+"&CustomerID="+sCustomerID+"&Flag=QueryContract","_self","dialogWidth=100;dialogHeight=20;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
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
				sRelativeContractNo = selectObjectInfo("BusinessContract","BusinessType= like '2%'~CustomerID="+sCustomerID+"");
				alert(sRelativeContractNo);
				sRelativeContractNo = sRelativeContractNo.split("@");
				sRelativeContractNo=sRelativeContractNo[0];
				alert(sRelativeContractNo);
				sReturn = PopPage("/CreditManage/CreditCheck/RelativeBusinessAction.jsp?SerialNo="+sSerialNo+"&RelativeContractNo="+sRelativeContractNo,"","");
				if(sReturn == "succeed")
				{
					alert("�����ɹ�");
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
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","ComponentName=�ս���Ϣ&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
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
