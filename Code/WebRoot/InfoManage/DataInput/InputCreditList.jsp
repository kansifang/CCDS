<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
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
					{"SerialNo","��ͬ��ˮ��"},
					{"CustomerName","�ͻ�����"},
					{"CustomerID","�ͻ����"},
					{"MFCustomerID","���Ŀͻ���"},
					{"CertTypeName","֤������"},
					{"CertID","֤������"},
					{"LoanCardNo","�����"},
					{"CreditLevelName","�ͻ��������"},
					{"BusinessTypeName","ҵ��Ʒ��"},					
					{"OccurTypeName","��������"},
					{"BDSerialNo","�����˺�"},
					{"ClassifyResultName","��ǰ���շ�����"},
					{"LowRiskName","�Ƿ�ͷ���ҵ��"},
					{"FinishType","�ս᷽ʽ"},
					{"FinishTypeName","�ս᷽ʽ"},									
					{"Currency","����"},
					{"BusinessSum","��ͬ���(Ԫ)"},
					{"Balance","���(Ԫ)"},
					{"NormalBalance","�������(Ԫ)"},
					{"OverdueBalance","�������(Ԫ)"},
					{"DullBalance","�������(Ԫ)"},
					{"BadBalance","�������(Ԫ)"},
					{"Interestbalance1","����ǷϢ(Ԫ)"},
					{"Interestbalance2","����ǷϢ(Ԫ)"},
					{"VouchTypeName","��Ҫ������ʽ"},
					{"PutOutDate","��ʼ����"},
					{"Maturity","��������"},
					{"ManageOrgIDName","�ܻ�����"},
					{"ManageUserIDName","�ܻ���"}					
				  };

	if(sReinforceFlag.equals("010") || sReinforceFlag.equals("110"))  //�����ǻ�������ҵ��
	{	
		sClauseWhere = "  and BC.Balance>0 and BC.ManageOrgID in (select BelongOrgID from Org_Belong where OrgID = '"+CurOrg.OrgID+"') and (BC.DeleteFlag =''  or  BC.DeleteFlag is null) and (BC.FinishDate is null or BC.FinishDate ='')  order by BC.CustomerID,BC.PutOutDate ";
	}
	
	if(sReinforceFlag.equals("020") || sReinforceFlag.equals("120"))  //���ǻ�������ɵ�ҵ��
	{
		sClauseWhere = "  and BC.ManageOrgID in (select BelongOrgID from Org_Belong where OrgID = '"+CurOrg.OrgID+"') and (BC.DeleteFlag =''  or  BC.DeleteFlag is null) order by BC.CustomerID,BC.PutOutDate ";

	}
	
	 sSql = " select CI.CustomerType,BC.SerialNo,BC.SerialNo as BDSerialNo,CI.MFCustomerID as MFCustomerID,"+
	 		" BC.CustomerName as CustomerName,"+
			" BC.CustomerID as CustomerID,"+
			" getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID as CertID,"+
			" CI.LoanCardNo as LoanCardNo,"+
			" getItemName('CreditLevel',getCreditLevel(BC.CustomerID)) as CreditLevelName,"+
			" BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
			" BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.FinishType,getItemName('FinishType',BC.FinishType) as FinishTypeName,"+
			" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as Currency,"+
			" BC.BusinessSum,BC.Balance,"+
			" BC.NormalBalance,BC.OverdueBalance,BC.DullBalance,BC.BadBalance,"+
			" BC.Interestbalance1,BC.Interestbalance2,"+
			" BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
			" BC.PutOutDate,BC.Maturity,"+
			" getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
			" getItemName('YesNo',LowRisk) as LowRiskName,"+
			" getUserName(BC.ManageUserID) as ManageUserIDName,"+
			" getOrgName(BC.ManageOrgID) as ManageOrgIDName "+
			" from BUSINESS_CONTRACT BC left join CUSTOMER_INFO CI ON CI.CUSTOMERID=BC.CUSTOMERID "+
			" where  "+
			" (BC.BusinessType like '1%' "+
			" or BC.BusinessType like '2%' "+
			" or BC.BusinessType like '5%' "+
			" or BC.BusinessType is null "+
			" or BC.BusinessType ='')"+
			" and BC.ReinforceFlag= '"+sReinforceFlag+"' "+
			" and (BC.FinishType not like '060%' "+
			" or BC.FinishType is null)"
			+sClauseWhere 
			+" with ur ";
	
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//out.println("<font color='red' size = 2>"+
	//			"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������������ҵ����[��Ȳ��ǹ���]��������[����ҵ��]��[�������]�������ʾ�ͻ������Ⲣ���Ŵ�ϵͳ��ȷ�ϴ˿ͻ���[����]�ɹ�����ô���ں���ϵͳ�����ͻ��ϲ������������������Ӧ����Ѿ����ڣ���ô����Ϳ��԰��ա���������ҵ�񡱽��в��ǣ��������ٲ�¼������Ϣ��"+
	//			"</font>");
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("BC.SerialNo");		//add by hxd in 2005/02/20 for �ӿ��ٶ�
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ò��ɼ���
	doTemp.setVisible("CustomerType,OccurType,BusinessCurrency,VouchType",false);
	doTemp.setVisible("BusinessType,FinishType,FinishTypeName,Currency",false);
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("NormalBalance,OverdueBalance,DullBalance,BadBalance,BusinessSum,Balance,Interestbalance1,Interestbalance2","3");
	doTemp.setCheckFormat("NormalBalance,OverdueBalance,DullBalance,BadBalance,BusinessSum,Balance,Interestbalance1,Interestbalance2","2");
	
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerTypeName,CertID,ManageUserIDName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("SerialNo,CustomerID"," style={width:160px} ");
	doTemp.setHTMLStyle("VouchTypeName"," style={width:170px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:100px} ");
		
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,SerialNo,ManageOrgIDName","IsFilter","1");
		
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10); 	//��������ҳ

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
				{"true","","Button","��Ȳ��ǹ���","��Ȳ��ǹ���","NewContract()",sResourcesPath},
				{"true","","Button","ָ���ͻ�","���ǿͻ���Ϣ","InputCustomerInfo()",sResourcesPath},	
				{"true","","Button","����ҵ��","����ҵ����Ϣ","InputBusinessInfo()",sResourcesPath},
				{"false","","Button","�������","�������","CreditBusinessInfo()",sResourcesPath},
				{"false","","Button","ɾ�����","ɾ�����","DeleteContract()",sResourcesPath},
				{"true","","Button","���ǿͻ���Ϣ","���ǿͻ���Ϣ","InputCustomerInfo()",sResourcesPath},		
				{"true","","Button","�������","�������","Finished()",sResourcesPath},
				{"true","","Button","�ͻ�����","�ͻ�����","CustomerInfo()",sResourcesPath},
				{"true","","Button","ҵ������","ҵ������","BusinessInfo()",sResourcesPath},
				{"true","","Button","�ٴβ���","�ٴβ���","secondFinished()",sResourcesPath},
				{"true","","Button","�ı�ҵ��Ʒ��","�ı�ҵ��Ʒ��","changeBusinessType()",sResourcesPath},
				{"false","","Button","�ı�ͻ�����","�ı�ͻ�����","changeCustomerType()",sResourcesPath},
				{"true","","Button","��ͬ�ϲ�","��ͬ�ϲ�","UniteContract()",sResourcesPath},
				{"true","","Button","�����Ŵ��ʲ�ҵ�񲹵�","�����Ŵ��ʲ�ҵ�񲹵�","NewCreditContract()",sResourcesPath},
				{"false","","Button","ɾ����ͬ","ɾ����ͬ","DeleteContract()",sResourcesPath},
				{"true","","Button","�ִηſ�ҵ���ͬ����","�ִηſ�ҵ���ͬ����","dispartMendContract()",sResourcesPath}
			};
	String sButtons2[][] = {
				{"true","","Button","������ԭ����ҵ��","������ԭ����ҵ��","RelativeBusiness()",sResourcesPath},
				{"true","","Button","�ս���Ϣ�Ǽ�","�ս���Ϣ�Ǽ�","Account()",sResourcesPath},
				{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath}
			};
	
	//�貹���Ŵ�ҵ��
	if(sReinforceFlag.equals("010")) 
	{
		//sButtons[2][0] = "false";
		//sButtons[3][0] = "false";
		//sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		//sButtons[7][0] = "false";
		sButtons[8][0] = "false";
		sButtons[9][0] = "false";
		sButtons[12][0] = "false";
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
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons2[0][0] = "false";
		sButtons[15][0] = "false";
		
	}
	
	//�������
	if(sReinforceFlag.equals("110")) 
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";		
		sButtons[7][0] = "false";
		sButtons[8][0] = "false";
		sButtons[9][0] = "false";
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons2[0][0] = "false";
		
	}
	
	//������ɶ��
	if(sReinforceFlag.equals("120")) 
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
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons2[0][0] = "false";
	}
	CurPage.setAttribute("Buttons2",sButtons2);
	
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
		
		var sFlag="<%=sFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{			
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����			
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
			
			////openObject("ReinforceCustomer",sCustomerID,"002");
			openObject("Customer",sCustomerID,"001");
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
			}
			else
			{
				openObject("AfterLoan",sSerialNo,"002");
			}
		}
	}

	/*~[Describe=��Ⱥ�ͬ����;InputParam=��;OutPutParam=��;]~*/
	function CreditBusinessInfo()
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
				openObject("ReinforceContract",sSerialNo,"000");
			}else
			{
				openObject("ReinforceContract",sSerialNo,"002");
			}
		}
	}

	/*~[Describe=���ǿͻ���Ϣ;InputParam=��;OutPutParam=��;]~*/
	function InputCustomerInfo()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sCustomerName   = getItemValue(0,getRow(),"CustomerName");
		sBusinessSum   = getItemValue(0,getRow(),"BusinessSum");
		sPutOutDate   = getItemValue(0,getRow(),"PutOutDate");
		sMaturity   = getItemValue(0,getRow(),"Maturity");
		sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
	    {
			var sParaString = "UserID"+","+"<%=CurUser.UserID%>"+",CustomerType,0,OrgID,<%=CurUser.OrgID%>";
			//alert(sParaString);
			var sObjectNoString = selectObjectValue("SelectReinforceCustomer",sParaString,"dialogWidth:700px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
			//alert(sObjectNoString);
			if(sObjectNoString=="_CLEAR_" ||sObjectNoString=="" || sObjectNoString=="_CANCEL_" || sObjectNoString=="_NONE_" || typeof(sObjectNoString)=="undefined") return;
			sReturn=sObjectNoString.split("@");
			var sCustomerID=sReturn[0];
			var sNewCustomerName=sReturn[1];
			if(confirm("��ȷ��Ҫ�ѽ�ݺ�Ϊ["+sSerialNo+"],�ͻ���Ϊ["+sCustomerName+"],��ͬ���Ϊ["+sBusinessSum+"],������ ��Ϊ["+sMaturity+"]�ĺ�ָͬ���ͻ�Ϊ["+sNewCustomerName+"]��ҵ����"))
			{
				if(sReturn == "EMPTY")
				{
					alert("Ҫ���ǵĿͻ�����Ϊ�գ���ѡ��ͻ����ͣ�");
					sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
					if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
					sCustomerType = sReturn;
					sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
				}
				//alert(sCustomerID);
				//alert(sSerialNo);
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerIDAction.jsp?CustomerID="+sCustomerID+"&SerialNo="+sSerialNo,"","");
				if(sReturn=="succeed")
					alert("ָ���ͻ��ɹ���");
				else 
					alert("ָ���ͻ�ʧ�ܣ�");
				//openObject("ReinforceCustomer",sCustomerID,"000");
				reloadSelf();
			}
		}
	}

	/*~[Describe=����ҵ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function InputBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sCustomerType   = getItemValue(0,getRow(),"CustomerType");
		var sDependType = "";
		var sCreditAggreement = "";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{	
			if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0 || sCustomerID.length>16){
				alert("����ָ���ͻ���");
				return;
			}
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{				
				sParaString = "CodeNo"+",DependType";		
				sReturn=setObjectValue("SelectCode",sParaString,"",0,0,"");
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sDependType=sss1[0];		
					if(sDependType=="DependentApply"){
						sCLType =PopPage("/InfoManage/DataInput/AddCreditLineDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
						if (!(sCLType=='_CANCEL_' || typeof(sCLType)=="undefined" || sCLType.length==0 || sCLType=='_CLEAR_' || sCLType=='_NONE_'))
						{
							sParaString = "BusinessType"+","+sCLType+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
							sCLSerialNo = setObjectValue("SelectCL",sParaString,"",0,0,"");
							sCLSerialNo = sCLSerialNo.split("@");
							sCreditAggreement=sCLSerialNo[0];
						}else{
							return;
						}
					}
					
					if (sCustomerType.substring(0,2) == "03")
					{
					   sReturn=setObjectValue("SelectIndBusinessType","","",0,0,"");	
					}else if(sCustomerType.substring(0,2)=="01")
					{
					   sReturn=setObjectValue("SelectEntBusinessType","","",0,0,"");	
					}else
					{
					   sReturn=setObjectValue("SelectAllBusinessType","","",0,0,"");	
					}			
					if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
					{
						sss1 = sReturn.split("@");
						sBusinessType=sss1[0];		
						if((sSerialNo.substring(0,4)=='0871'||sSerialNo.substring(0,2)=='BC')&&sBusinessType=='2010'){
							alert("��ҵ�����϶�Ϊ�жһ�Ʊ��");
							return								
						}							
						sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction1.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType+"&ApplyType="+sDependType+"&CreditAggreement="+sCreditAggreement,"","");
					}else{
						return;
					}
				}else{
					return;
				}
			}
			openObject("ReinforceContract",sSerialNo,"001");
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
		var sCustomerType   = getItemValue(0,getRow(),"CustomerType");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sCreditAggreement = "";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{	
			if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0 || sCustomerID.length>16){
				alert("����ָ���ͻ���");
				return;
			}		
			sParaString = "CodeNo"+",DependType";		
			sReturn=setObjectValue("SelectCode",sParaString,"",0,0,"");
			if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
			{
				sss1 = sReturn.split("@");
				sDependType=sss1[0];	
				if(sDependType=="DependentApply"){
					sCLType =PopPage("/InfoManage/DataInput/AddCreditLineDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
					if (!(sCLType=='_CANCEL_' || typeof(sCLType)=="undefined" || sCLType.length==0 || sCLType=='_CLEAR_' || sCLType=='_NONE_'))
					{
						sParaString = "BusinessType"+","+sCLType+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
						sCLSerialNo = setObjectValue("SelectCL",sParaString,"",0,0,"");
						sCLSerialNo = sCLSerialNo.split("@");
						sCreditAggreement=sCLSerialNo[0];
					}else{
						return;
					}
					
				}
				if (sCustomerType.substring(0,2) == "03")
				{
					   sReturn=setObjectValue("SelectIndBusinessType","","",0,0,"");	
				}else if(sCustomerType.substring(0,2) == "01")
				{
					   sReturn=setObjectValue("SelectEntBusinessType","","",0,0,"");	
				}else
				{
				       sReturn=setObjectValue("SelectAllBusinessType","","",0,0,"");	
				}			
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];	
					if((sSerialNo.substring(0,4)=='0871'||sSerialNo.substring(0,2)=='BC')&&sBusinessType=='2010'){
						alert("��ҵ�����϶�Ϊ�жһ�Ʊ��");
						return								
					}
					sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction1.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType+"&ApplyType="+sDependType+"&CreditAggreement="+sCreditAggreement,"","");
				}else{
					return;
				}
			}else{
				return;
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=�������еȱ����ͬ;InputParam=��;OutPutParam=��;]~*/
	function NewCreditContract()
	{
		var sFlag="<%=sFlag%>";
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if(sReinforceFlag=="010")
		{  
			//������ͬ����
			//var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag+"~ReinforceFlag=G");
			//sNewBusinessType =PopPage("/InfoManage/DataInput/AddCreditDialog.jsp","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
			//if(typeof(sNewBusinessType)!="undefined" && sNewBusinessType.length!=0 && sNewBusinessType != '_none_')
			//{
				OpenComp("CreditList","/InfoManage/DataInput/CreditList.jsp","ComponentName=&OpenerFunctionName=&DealType=010&ReinforceFlag=01","_blank");
			//}
		}

		reloadSelf();		
	}
	
	
	/*~[Describe=�ִηſ�;InputParam=��;OutPutParam=��;]~*/
	function dispartMendContract()
	{
		var sFlag="<%=sFlag%>";
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if(sReinforceFlag=="010")
		{  
			OpenComp("DispartCreditList","/InfoManage/DataInput/DispartCreditList.jsp","ComponentName=&OpenerFunctionName=&DealType=010&ReinforceFlag=01","_blank");
		}

		reloadSelf();		
	}
	

	/*~[Describe=������ͬ;InputParam=��;OutPutParam=��;]~*/
	function NewContract()
	{
		var sFlag="<%=sFlag%>";
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if(sFlag=="Y")  //�����ʲ����ǽ���
		{
			var sReturn = createObject("NPAReinforceContract","");
		}
		else		//�Ŵ����ǽ���
		{
			if(sReinforceFlag=="010")
			{  
				//������ͬ����
				//var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag+"~ReinforceFlag=G");
				sNewBusinessType =PopPage("/InfoManage/DataInput/AddCreditLineDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
				if(typeof(sNewBusinessType)!="undefined" && sNewBusinessType.length!=0 && sNewBusinessType != '_none_')
				{
					//OpenPage("/CreditManage/CreditPutOut/AssureInfo.jsp?GuarantyType1="+sGuarantyType,"right");
					OpenComp("CreditLineList","/InfoManage/DataInput/CreditLineList.jsp","ComponentName=&OpenerFunctionName=&DealType=010&ReinforceFlag=01&BusinessType="+sNewBusinessType,"_blank");
				}
			}else
			{
				//������Ƚ���
				var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag);
			}
		}
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sss = sReturn.split("@");
		sSerialNo=sss[0];

		if(sFlag=="Y")
		{
			openObject("NPAReinforceContract",sSerialNo,"000");
		}else
		{
			openObject("ReinforceContract",sSerialNo,"000");
		}
		
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
			var sFlag="<%=sFlag%>";
			
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				alert("ҵ��Ʒ��Ϊ�գ����Ȳ���ҵ��Ʒ�֣�");
				return;
			}else
			{	
				var sExistFlag = PopPage("/InfoManage/DataInput/ReinforceCheckAction.jsp?ContractNo="+sSerialNo,"","");
				
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
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
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
