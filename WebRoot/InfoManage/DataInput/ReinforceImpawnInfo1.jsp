<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-28
		Tester:
		Describe: ҵ�����������ĵ�����Ϣ����Ӧ��������Ϣ;
		Input Param:
			ObjectType����������
			ObjectNo: ������
			ContractNo: ������Ϣ���
			GuarantyID��������
			ImpawnType����������				
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sGuarantyStatus = "";//����״̬
	String sTempletNo = "";//--ģ�����
	String sTempletFilter = "";//ģ����˱���
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	String sImpawnTypeName = "";//������������
	
	//���ҳ��������������͡������š�������Ϣ��š������š���������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractNo"));
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyID"));
	String sImpawnType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ImpawnType"));
	
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sContractNo == null) sContractNo = "";
	if(sGuarantyID == null) sGuarantyID = "";
	if(sImpawnType == null) sImpawnType = "";
	if(sObjectType.equals("ReinforceContract")) sObjectType="BusinessContract";
			
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//���������Ż�ȡ��Ѻ��״̬��01��δ��⣻02����⣻03����ʱ���⣻04�����⣩
	sGuarantyStatus = Sqlca.getString("select GuarantyStatus from GUARANTY_INFO where GuarantyID = '"+sGuarantyID+"'");
	if(sGuarantyStatus == null) sGuarantyStatus = "01";
	 		        
	//���ݵ�Ѻ������ȡ����ʾģ���
	sSql = "select ItemName,ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='"+sImpawnType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sTempletNo = rs.getString("ItemDescribe");
		sImpawnTypeName = rs.getString("ItemName");
	}
	rs.getStatement().close();
	
	//����ֵת��Ϊ���ַ���
	if(sTempletNo == null) sTempletNo = "";
	if(sImpawnTypeName == null) sImpawnTypeName = "";

	//���ù�������	
	sTempletFilter = " (ColAttribute like '%CreditApply%' ) ";

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//���ó�����ѡ���
	doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()><font color=red>(���ڵĿͻ���ѡ��,����������)</font>");
	doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	doTemp.setHTMLStyle("OwnerName"," style={width:400px} ");
	//doTemp.setDDDWSql("EvalOrgName","select SerialNo,CustomerName  from CUSTOMER_SPECIAL where SectionType='60'");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(sGuarantyStatus.equals("01")) 
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	else
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertGuarantyRelative("+sObjectType+","+sObjectNo+","+sContractNo+",#GuarantyID,New,Add)+!CustomerManage.AddCustomerInfo(#OwnerID,#OwnerName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.InsertGuarantyRelative("+sObjectType+","+sObjectNo+","+sContractNo+",#GuarantyID,New,Add)+!CustomerManage.AddCustomerInfo(#OwnerID,#OwnerName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGuarantyID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){		
			beforeInsert();
		}
		//add by hlzhang 2008-08-03 ����Ѻ-����֤ҵ�����жϱ������Ƿ�Ϊ������
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
		if(sGuarantyType == '020080')
		{
		 	sFlag1 = getItemValue(0,getRow(),"Flag1");
		 	sGuarantyDescribe2 = getItemValue(0,getRow(),"GuarantyDescribe2");
		 	if(sFlag1 == "1"&&(typeof(sGuarantyDescribe2) == "undefined" 
			|| sGuarantyDescribe2 == ""))
		 	{
		 	 	alert("�������Ǳ����");
		 	 	return;
		 	} 	
		}
		//add by hlzhang 2008-09-25 �ж�������ʽ���Դ���ʾ�û�������
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
	    if(sGuarantyType.substring(0,3)=="020")
	    {
		 	sEvalMethod = getItemValue(0,getRow(),"EvalMethod");
		 	sEvalOrgName = getItemValue(0,getRow(),"EvalOrgName");
		 	sEvalDate = getItemValue(0,getRow(),"EvalDate");
		 	if(sEvalMethod == "01" && (typeof(sEvalOrgName) == "undefined" || sEvalOrgName == ""||typeof(sEvalDate) == "undefined" || sEvalDate == ""))	
		 	{ 	
		 	 	alert("������ʽΪ����˾��ʱ�������������ƺ�����ʱ��Ϊ�����");
		 	 	return;
		 	} 	
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/GuarantyManage/ApplyImpawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo=<%=sContractNo%>","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		//���֤������Ƿ���ϱ������
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sCertID = getItemValue(0,0,"CertID");//֤������
		
		if(typeof(sCertType) != "undefined" && sCertType != "" )
		{
			//�ж���֯��������Ϸ���
			if(sCertType =='Ent01')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if(!CheckORG(sCertID))
					{
						alert(getBusinessMessage('102'));//��֯������������						
						return false;
					}
				}
			}
				
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if (!CheckLisince(sCertID))
					{
						alert(getBusinessMessage('156'));//���֤��������				
						return false;
					}
				}
			}
		}
		
		//У������˴�����
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//�����˴�����	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
		{
			if(!CheckLoanCardID(sLoanCardNo))
			{
				alert(getBusinessMessage('239'));//�����˴���������							
				return false;
			}
			
			//��������˴�����Ψһ��
			sOwnerName = getItemValue(0,getRow(),"OwnerName");//����������	
			sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sOwnerName+","+sLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
			{
				alert(getBusinessMessage('240'));//�ó����˴������ѱ������ͻ�ռ�ã�							
				return false;
			}						
		}
		
		//�������ĳ������Ƿ����Ŵ���ϵ�����δ��������Ҫ�»�ȡ�����˵Ŀͻ����
		if(typeof(sCertType) != "undefined" && sCertType != "" 
		&& typeof(sCertID) != "undefined" && sCertID != "")
		{
			var sOwnerID = PopPage("/PublicInfo/CheckCustomerAction.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sOwnerID)=="undefined" || sOwnerID.length==0) {
				return false;
			}
			setItemValue(0,0,"OwnerID",sOwnerID);
		}			
		
		return true;
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"GuarantyType","<%=sImpawnType%>");			
			setItemValue(0,0,"GuarantyStatus","01");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"GuarantyTypeName","<%=sImpawnTypeName%>");
			//add by hlzhang 2008-08-04 ��ʼ������Ϊ�����
			sEvalCurrency = getItemValue(0,getRow(),"EvalCurrency");
			if(typeof(sEvalCurrency) == "undefined" || sEvalCurrency == "")
			{
				setItemValue(0,getRow(),"EvalCurrency",'01');
			}
			sGuarantyCurrency = getItemValue(0,getRow(),"GuarantyCurrency");		
			if(typeof(sGuarantyCurrency) == "undefined" || sGuarantyCurrency == "") 
			{
				setItemValue(0,getRow(),"GuarantyCurrency",'01');
			}
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
			if(sGuarantyType == '020040' || sGuarantyType == '020050' || sGuarantyType == '020070'
			|| sGuarantyType == '020080'|| sGuarantyType == '020090'|| sGuarantyType == '020100'
			|| sGuarantyType == '020110'|| sGuarantyType == '020120'|| sGuarantyType == '020150'
			|| sGuarantyType == '020160'|| sGuarantyType == '020180'|| sGuarantyType == '020190'
			|| sGuarantyType == '020230'|| sGuarantyType == '020260')
			{		
				sThirdParty2 = getItemValue(0,getRow(),"ThirdParty2");		
				if(typeof(sThirdParty2) == "undefined" || sThirdParty2 == "") 
				{
					setItemValue(0,getRow(),"ThirdParty2",'01');
				}
			}		
			bIsInsert = true;			
		}
		
    }
    
   	/*~[Describe=�����Զ���С��λ����������,����objectΪ�������ֵ,����decimalΪ����С��λ��;InputParam=��������������λ��;OutPutParam=��������������;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
    	
	}
		
	/*~[Describe=ͨ������Ѻ��/����Ѻ����Զ������Ѻ�ʣ�%��;InputParam=��;OutPutParam=��;]~*/
	function getGuarantyRate() 
	{
		dEvalNetValue = getItemValue(0,getRow(),"EvalNetValue");//��Ѻ����
		sCurrency = getItemValue(0,getRow(),"EvalCurrency");//��Ѻ�����
		dERate1 = RunMethod("BusinessManage","GetERate",sCurrency);
		dEvalNetValue = dEvalNetValue*dERate1;
		if(dEvalNetValue == 0)
		{
			alert("��ʱ�޷������Ѻ�ʣ�");
			setItemValue(0,getRow(),"GuarantyRate",0);
		}else	
	    if(parseFloat(dEvalNetValue) >= 0)
	    {
	        dConfirmValue = getItemValue(0,getRow(),"ConfirmValue");//��Ѻ���
	        sCurrency = getItemValue(0,getRow(),"GuarantyCurrency");//�϶�����
	        dERate2 = RunMethod("BusinessManage","GetERate",sCurrency);
		    dConfirmValue = dConfirmValue*dERate2;
	        
	        dConfirmValue = roundOff(dConfirmValue);
	        if(parseFloat(dConfirmValue) >= 0)
	        {	       
	            dGuarantyRate = parseFloat(dConfirmValue)/parseFloat(dEvalNetValue)*100;
	            dGuarantyRate = roundOff(dGuarantyRate,2);
	            setItemValue(0,getRow(),"GuarantyRate",dGuarantyRate);
	        }
	    }
	}       

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������		
		setObjectValue("SelectOwner","","@OwnerID@0@OwnerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");		
	}

	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���š��ͻ����ƺʹ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		
		if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
			//��ÿͻ���š��ͻ����ƺʹ�����
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//���ÿͻ�ID
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"OwnerID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"OwnerName",sReturnInfo[n+1]);
						//���ô�����
						if(my_array2[n] == "loancardno") 
						{
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"LoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"LoanCardNo","");
						}
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"OwnerID","");
				setItemValue(0,getRow(),"OwnerName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			} 
		}		
	}
	        
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_INFO";//����
		var sColumnName = "GuarantyID";//�ֶ���
		var sPrefix = "GI";//ǰ׺

		//ʹ��GetGuarantyID.jsp����ռһ����ˮ��
		var sGuarantyID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"GuarantyID",sGuarantyID);				
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;],hlzhang 2008-07-29~*/
	function selectCountryCode()
	{		
		sParaString = "CodeNo"+",CountryCode";	
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
		if(sGuarantyType=='020080'||sGuarantyType=='020090')
		{ 		
			sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@GuarantyDescribe1@0@GuarantyDescribe1Name@1",0,0,"");
     	}
	}
		/*~[Describe=������Ҫ�ض�Ҫ�󵯳�����ѡ�񴰿�ʱ�����Ӧ�ŵڶ���Ҫ�أ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;],hlzhang 2008-07-29~*/
	function selectCountryCode1()
	{		
		sParaString = "CodeNo"+",CountryCode";	
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
		if(sGuarantyType=='020080')
		{ 		
			sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@GuarantyDescribe3@0@GuarantyDescribe3Name@1",0,0,"");
     	}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��

</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
