<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ���������Ϣ����;
		Input Param:
			ImpawnType����������				
			GuarantyID��������
			GuarantyStatus������״̬
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletNo = "";//--ģ�����
	String sTempletFilter = "";//ģ����˱���
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	String sImpawnTypeName = "";//������������
	
	//���ҳ��������������͡������š�����״̬
	String sImpawnType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ImpawnType"));
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyID"));
	String sGuarantyStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyStatus"));
	
	//����ֵת��Ϊ���ַ���
	if(sImpawnType == null) sImpawnType = "";
	if(sGuarantyID == null) sGuarantyID = "";
	if(sGuarantyStatus == null) sGuarantyStatus = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		        
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
	sTempletFilter = " (ColAttribute like '%ImpawnInfo%' ) ";

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.appendHTMLStyle("AboutRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"ע���ʱ�������ڵ���0С�ڵ���100��\" ");
	doTemp.appendHTMLStyle("GuarantyAmount1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���շѽ������ޱ�����ڵ���0��\" ");
	doTemp.setLimit("GuarantyName,EvalOrgName,GuarantyResouce",80);
	doTemp.setLimit("GuarantyRightID,AboutOtherID2,RelativeAccount",30);
	doTemp.setLimit("AboutOtherID1,OtherGuarantyRight",30);
	doTemp.setLimit("ThirdParty3",180);
	if(sGuarantyStatus.equals("01"))//δ���
	{
		//���ó�����ѡ���
		doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
		doTemp.setHTMLStyle("OwnerName"," style={width:400px} ");
		doTemp.setUnit("EvalOrgName"," <input type=button value=.. onclick=parent.selectEvalOrgName()>");
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(sGuarantyStatus.equals("01"))
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	else
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
	//����setEvent
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#OwnerID,#OwnerName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#OwnerID,#OwnerName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	doTemp.appendHTMLStyle("ConfirmValue","onChange=\"javascript:parent.setGuarantyRate()\" ");
	doTemp.appendHTMLStyle("EvalNetValue","onChange=\"javascript:parent.setGuarantyRate()\" ");	
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

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		//OpenPage("/CreditManage/GuarantyManage/ImpawnList.jsp?GuarantyStatus=<%=sGuarantyStatus%>","_self","");
		self.close();
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
	
	function selectEvalOrgName()
	{
		var AuditOrgType = "030";
		sParaString = "AuditOrgType"+","+AuditOrgType;
		setObjectValue("selectNewEvalOrgName",sParaString,"@EvalOrgName@0",0,0,"");
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/* ������Ѻ��2009-12-29 zwhu*/
	function setGuarantyRate()
	{
		dConfirmValue = getItemValue(0,getRow(),"ConfirmValue"); //��Ѻ���
		dEvalNetValue = getItemValue(0,getRow(),"EvalNetValue"); //��Ѻ����
		if(dConfirmValue<0 || dEvalNetValue<0){
			alert("��ֵ����С���㣡");
			return;
		}
		dGuarantyRate = (dConfirmValue/dEvalNetValue)*100;
		dGuarantyRate = roundOff(dGuarantyRate,2);
		setItemValue(0,0,"GuarantyRate",dGuarantyRate);
	}
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{	
		ssTempletNo	= "<%=sTempletNo%>";	
		sDay = "<%=StringFunction.getToday()%>";
		//���֤������Ƿ���ϱ������
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sCertID = getItemValue(0,0,"CertID");//֤������
		sBeginDate = getItemValue(0,0,"BeginDate");
		sOwnerTime = getItemValue(0,0,"OwnerTime");
		if(typeof(sBeginDate) != "undefined" && sBeginDate != "" && typeof(sOwnerTime) != "undefined" && sOwnerTime != "")
		{
			if(sBeginDate > sOwnerTime) 
			{
				if(ssTempletNo == "DepositInfo"){
					alert("��Ϣ����Ӧ��С�ڵ��ڵ�������!");
					return false;
					}
				else if(ssTempletNo == "DepotInfo"){
					alert("������ʼ����Ӧ��С�ڵ��ڲֵ���������!");
					return false;
				}
				else if(ssTempletNo == "OtherDroitInfo"){
					alert("����/��ʼ����Ӧ��С�ڵ��ڵ�������!");
					return false;
				}
				
			}
		}
		
		sGuarantyDate = getItemValue(0,0,"GuarantyDate");
		if(typeof(sBeginDate) != "undefined" && sBeginDate != "" && typeof(sGuarantyDate) != "undefined" && sGuarantyDate != "")
		{
			if(sBeginDate < sGuarantyDate) 
			{
				if(ssTempletNo == "TreasuryInfo"){
					alert("��������Ӧ��С�������������!");
					return false;
					}
				else if(ssTempletNo == "GuaranteeInfo"){
					alert("���տ�ʼ����Ӧ��С�ڵ��ڱ��յ�������!");
					return false;
				}
				else if(ssTempletNo == "AcceptanceBillInfo"){
					alert("ǩ������ӦС�ڵ��ڵ�������!");
					return false;
				}
			}
		}
		
		if(typeof(sGuarantyDate) != "undefined" && sGuarantyDate != "")
		{
			if(sDay < sGuarantyDate) 
			{
				if(ssTempletNo == "BondInfo"){
					alert("��������Ӧ��С�ڵ�ǰ����!");
					return false;
					}
				else if(ssTempletNo == "CreditInfo"){
					alert("��֤����Ӧ��С�ڵ�ǰ����!");
					return false;
					}	
					
			}
		}
		
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
			setItemValue(0,0,"GuarantyStatus","<%=sGuarantyStatus%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"GuarantyTypeName","<%=sImpawnTypeName%>");
		
			bIsInsert = true;			
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

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sGuarantyID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"GuarantyID",sGuarantyID);				
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��

</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
