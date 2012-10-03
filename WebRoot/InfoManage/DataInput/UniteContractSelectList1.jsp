<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2011/0614
		Tester:
		Describe1: ��ͬѡ��;
		Input Param:
		Output Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬѡ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";
	String sWhereClause ="";
	String sTempletNo ="";
	
	//����������	
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
		
	if(sContractNo==null) sContractNo="";
	if(sCustomerID==null) sCustomerID="";
	if(sFlag==null) sFlag="";
	//�����ͷ�ļ�
	String sHeaders[][] = { 		
	    					{"SerialNo","��ͬ��ˮ��"},     					
	    					{"CustomerName","�ͻ�����"},
	    					{"RelativeSerialNo","Ŀ���ͬ��"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"BusinessCurrencyName","����"},
							{"BusinessSum","���(Ԫ)"},
							{"BlanceSum","���(Ԫ)"},
							{"PutoutDate","��ʼ��"},
							{"Maturity","������"},
							{"ManageUserName","�ܻ���"},
							{"ManageOrgName","�ܻ�����"}
						}; 
	
	
	if(sFlag.equals("DeleteContract"))	//���ݲ�ѯ������ѯ�ѱ��ϲ��ĺ�ͬ
	{
		sSql = 	" select BC.SerialNo as SerialNo ,BC.CustomerID as CustomerID,BC.CustomerName as CustomerName, "+
			   	" BC.RelativeSerialNo as RelativeSerialNo,BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
	           	" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName, "+
			   	" BC.BusinessSum as BusinessSum,BC.Balance as BlanceSum, "+
			   	" BC.ManageOrgID,getUserName(BC.ManageUserID) as ManageUserName, "+
			   	" GetOrgName(BC.ManageOrgID) as ManageOrgName ,BC.ManageUserID "+
		 		" from BUSINESS_CONTRACT BC,CUSTOMER_INFO CI "+
				" where BC.CustomerID=CI.CustomerID "+
			 	" and BC.ManageOrgID in (select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') "+
			 	" and BC.CustomerID = '"+sCustomerID+"' "+
				" and BC.DeleteFlag = '01' "+         //01��ʾ�ѱ��ϲ�
				" and exists(select 1 from BUSINESS_DUEBILL where serialno=BC.serialno and RelativeSerialNo2='"+sContractNo+"')"+
				" order by BC.PutOutDate ";
	
	}else	//δ���ϲ��ĺ�ͬ�б�
	{
		sSql = 	" select BC.SerialNo as SerialNo ,BC.CustomerID as CustomerID,BC.CustomerName as CustomerName, "+
			   	" BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
	           	" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName, "+
			   	" BC.BusinessSum as BusinessSum,BC.Balance as BlanceSum,PutoutDate, Maturity,  "+
			   	" BC.ManageOrgID, "+
			   	" getUserName(BC.ManageUserID) as ManageUserName, "+
			   	" GetOrgName(BC.ManageOrgID) as ManageOrgName ,BC.ManageUserID "+
			 	" from BUSINESS_CONTRACT BC,CUSTOMER_INFO CI "+
			 	" where BC.SerialNo <> '"+sContractNo+"' "+				
			 	" and (DeleteFlag =''  or  DeleteFlag is null) "+
			 	" and CI.CustomerID = BC.CustomerID "+
			 	" and BC.ManageOrgID in (select BelongOrgId from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') "+
			 	" and BC.CustomerID = '"+sCustomerID+"' "+
			 	" and BC.CustomerID<>'' "+
			 	" and substr(BC.SerialNo,1,4)<>'0871' and substr(BC.SerialNo,1,2)<>'BC' "+
			 	" and substr(BC.SerialNo,1,2)<>'FC' "+
			 	" and BC.ReinforceFlag in('010','020') "+
			 	" and exists(select 1 from business_duebill where relativeserialno2=BC.serialno) "+
				" and BC.CustomerID is not null order by BC.PutOutDate ";
	}	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	//����Sql���ɴ������
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("BusinessType,CustomerType,CustomerID,BusinessType,BusinessCurrency,ManageOrgID,ManageUserID",false);	
	doTemp.setVisible("RelativeSerialNo",false);	
	
	//���ý��Ϊ������ʽ
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");
	
	doTemp.setType("BlanceSum","Number");
	doTemp.setCheckFormat("BlanceSum","2");
	
	//���ý����뷽ʽ
	doTemp.setAlign("BusinessSum,BlanceSum","3");
	doTemp.setColumnAttribute("SerialNo,BusinessTypeName,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//��ѡ
	doTemp.multiSelectionEnabled = true;
	
	//����html��ʽ
	doTemp.setHTMLStyle("RelativeSerialNo"," style={width:160px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName,RecoveryUserName"," style={width:100px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
				{"true","","Button","�ϲ�","�ϲ���ѡ��ͬ","addSubmit()",sResourcesPath},
				{"true","","Button","ɾ���ϲ�","ɾ���ϲ���ͬ","deleteSubmit()",sResourcesPath},
				{"false","","Button","�ͻ�����","�ͻ�����","CustomerInfo()",sResourcesPath},
				{"false","","Button","ҵ������","ҵ������","BusinessInfo()",sResourcesPath}
			};
			
	if(sFlag.equals("AddContract"))
	{
		sButtons[1][0]="false";
	}else if(sFlag.equals("DeleteContract"))
	{
		sButtons[0][0]="false";
	}
	
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script>
	
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
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{			
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				sReturn=setObjectValue("SelectBusinessType","","",0,0,"");
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];
					sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
				}else if (sReturn=='_CLEAR_')
				{
					return;
				}else 
				{
					return;
				}				
			}
			openObject("AfterLoan",sSerialNo,"002");			
		}
	}

	
	/*~[Describe=�ϲ���ͬ�ύ;InputParam=��;OutPutParam=��;]~*/
	function addSubmit()
	{
		//��ú�ͬ��ˮ��
		sObjectNoArray = getItemValueArray(0,"SerialNo");
		
		if (sObjectNoArray.length==0){
			alert("��û��ѡ����Ϣ��������Ҫѡ�����Ϣǰ��̣� ");
			return;
		}		

		var iCount = 0;
		var sMessage1 = "";
		
		sMessage = "���Ѿ�ѡ����������Ҫ���ϲ��ĺ�ͬ:\n\r\n\r";
		//�ҵ���һ��ѡ�е����񣬲�������ʾ��Ϣ
		for(var iMSR = 0; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a == "��")
			{
				if (iCount == 0) 
				{
					sSerialNo = getItemValue(0,iMSR,"SerialNo");
					
				}
				
				iCount = iCount + 1;
				
				sMessage = sMessage+getItemValue(0,iMSR,"SerialNo")+"-";
				sMessage = sMessage+getItemValue(0,iMSR,"CustomerName")+"-";
				sMessage = sMessage+"\n\r";
				if(sMessage1=="")
				{
					sMessage1 = getItemValue(0,iMSR,"SerialNo");
				}else
				{
					sMessage1 = sMessage1+","+getItemValue(0,iMSR,"SerialNo");
				}
			}
		}

		sMessage = sMessage+"\n\r"+"ȷ��Ҫ����ѡ��ͬ��Ŀ���ͬ��<%=sContractNo%>���ϲ���";
		
		if (confirm(sMessage)==false){
			return;
		}		
				
		var sReturn = PopPage("/InfoManage/DataInput/UniteContractAction1.jsp?ContractNo=<%=sContractNo%>&Flag=<%=sFlag%>&ObjectNoArray="+sObjectNoArray,"","");
		
		if(sReturn=="true")
		{
			alert("��ѡ��ͬ��"+sMessage1+"���Ѿ��ɹ��ϲ���Ŀ���ͬ��<%=sContractNo%>��!");
			self.returnValue =sReturn;
			self.close();
		}else
		{
			self.returnValue =sReturn;
			self.close();
		}
		
	}
	
	
	/*~[Describe=ɾ����ͬ�ϲ��ύ;InputParam=��;OutPutParam=��;]~*/
	function deleteSubmit()
	{
		//��ú�ͬ��ˮ��
		sObjectNoArray = getItemValueArray(0,"SerialNo");
		
		if (sObjectNoArray.length==0){
			alert("��û��ѡ����Ϣ��������Ҫѡ�����Ϣǰ��̣� ");
			return;
		}		

		var iCount = 0;
		var sMessage1 = "";
		
		sMessage = "���Ѿ�ѡ����������Ҫ������ϲ��ĺ�ͬ:\n\r\n\r";
		//�ҵ���һ��ѡ�е����񣬲�������ʾ��Ϣ
		for(var iMSR = 0; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a == "��")
			{
				if (iCount == 0) 
				{
					sSerialNo = getItemValue(0,iMSR,"SerialNo");
					
				}
				
				iCount = iCount + 1;
				
				sMessage = sMessage+getItemValue(0,iMSR,"SerialNo")+"-";
				sMessage = sMessage+getItemValue(0,iMSR,"CustomerName")+"-";
				sMessage = sMessage+"\n\r";
				if(sMessage1=="")
				{
					sMessage1 = getItemValue(0,iMSR,"SerialNo");
				}else
				{
					sMessage1 = sMessage1+","+getItemValue(0,iMSR,"SerialNo");
				}
			}
		}

		sMessage = sMessage+"\n\r"+"ȷ��Ҫ����ѡ��ͬ��Ŀ���ͬ��<%=sContractNo%>������ϲ���";
		
		if (confirm(sMessage)==false){
			return;
		}		
				
		var sReturn = PopPage("/InfoManage/DataInput/UniteContractAction1.jsp?ContractNo=<%=sContractNo%>&Flag=<%=sFlag%>&ObjectNoArray="+sObjectNoArray,"","");
		
		if(sReturn=="true")
		{
			alert("��ѡ��ͬ��"+sMessage1+"���Ѿ��ɹ���Ŀ���ͬ��<%=sContractNo%>������ϲ�!");
			self.returnValue =sReturn;
			self.close();
		}else
		{
			self.returnValue =sReturn;
			self.close();
		}
		
	}
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