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

		HistoryLog:modified by lpzhang 2009-8-6

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
	String sCustomerID = "",sCustomerName = "",sCertID = "",sCertType ="",sCertName ="",sLoanCardNo = "";//�����������Ϣ
	String sBusinessType ="";
	double dBusinessSum = 0.0;
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
			
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ�õ����������Ϣ
	sSql =  " select CI.CustomerID,CI.CustomerName,CI.CertID,CI.CertType,getItemName('CertType',CI.CertType) as CertName,CI.LoanCardNo from "+
			" GUARANTY_CONTRACT GC,Customer_Info CI where "+
			" GC.GuarantorID=CI.CustomerID and GC.SerialNo ='"+sContractNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
		sCertID = rs.getString("CertID");
		sCertType = rs.getString("CertType");
		sCertName = rs.getString("CertName");
		sLoanCardNo = rs.getString("LoanCardNo");
		if(sCustomerID == null) sCustomerID="";
		if(sCustomerName == null) sCustomerName="";
		if(sCertID == null) sCertID="";
		if(sCertType == null) sCertType="";
		if(sCertName == null) sCertName="";
		if(sLoanCardNo == null) sLoanCardNo ="";
	}
	rs.getStatement().close();
	//ȡ������Ϣ
	sSql = " select BusinessType,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum "+
	  " from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sBusinessType = rs.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = "";
		dBusinessSum = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	
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
	doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
	doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	doTemp.appendHTMLStyle("AboutRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʵķ�ΧΪ[0,100]\" ");
	doTemp.setHTMLStyle("OwnerName"," style={width:400px} ");
	if("DepotInfo".equals(sTempletNo)){
		doTemp.setUnit("GuarantyResouce"," <input type=button value=.. onclick=parent.selectDepotOrgName()>");
	}	
	doTemp.setUnit("EvalOrgName"," <input type=button value=.. onclick=parent.selectEvalOrgName()>");
	doTemp.appendHTMLStyle("GruarantyRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��Ѻ��(��)�ķ�ΧΪ[0,100]\" ");
	doTemp.appendHTMLStyle("ConfirmValue","onChange=\"javascript:parent.setGuarantyRate()\" ");
	doTemp.appendHTMLStyle("EvalNetValue","onChange=\"javascript:parent.setGuarantyRate()\" ");	
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

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	function selectEvalOrgName()
	{
		//����ֻ���ɷ��ز����������������������ʲ�������˾
		var AuditOrgType = "030";
		sParaString = "AuditOrgType"+","+AuditOrgType;
		setObjectValue("selectNewEvalOrgName",sParaString,"@EvalOrgName@0",0,0,"");
	}
	/*~[Describe=�����ִ���˾ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/	
	function selectDepotOrgName()
	{
		var AuditOrgType = "040";
		sParaString = "AuditOrgType"+","+AuditOrgType;
		setObjectValue("selectNewEvalOrgName",sParaString,"@GuarantyResouce@0",0,0,"");
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrg()
	{		
		sParaString = "OrgID,"+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectBelongOrg",sParaString,"@BelongOrg@0@GuarantyDescribe3@1",0,0,"");
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
		sBeginDate = getItemValue(0,getRow(),"BeginDate");
		sOwnerTime = getItemValue(0,getRow(),"OwnerTime");
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
		if(sBeginDate >= sOwnerTime && sGuarantyType =="020010")
		{
			alert("�浥�����ձ��������Ϣ���ڣ�");
			return false;
		}
		 //��֤������Ϊ��֯�������룬 ����ű�����  2009-8-11 
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//�����˴�����	
		/*
		if(sCertType == "Ent01" && (typeof(sLoanCardNo) == "undefined" || sLoanCardNo =="" ))
		{
			alert("��֤������Ϊ��֯��������֤������ű������룡");
			return false;
		}
		*/
		//�����տ�ʼ���ڡ���Ӧ���ڡ����յ������ڡ����Ҳ�Ӧ���ڵ�ǰ���ڡ�lpzhang 2009-12-24
		if("<%=sImpawnType%>" == "020060")//��Ѻ-����
		{
			sGuarantyDate = getItemValue(0,0,"GuarantyDate");//���տ�ʼ����
			sBeginDate = getItemValue(0,0,"BeginDate");//���յ�������
			if(sGuarantyDate > sBeginDate){
				alert("���տ�ʼ���ڲ�Ӧ���ڱ��յ�������!");
				return false;
			}
			if(sGuarantyDate > "<%=StringFunction.getToday()%>"){
				alert("���տ�ʼ���ڲ�Ӧ���ڵ�ǰ����!");
				return false;
			}
			
		}
		
		sGuarantyRate = getItemValue(0,0,"GuarantyRate");
		sThirdParty1 = getItemValue(0,0,"ThirdParty1");   // ȡ�浥����01-���˱���03-��λ����		
		if(sGuarantyRate >90 ){
			//���гжһ�Ʊ,�浥��Ѻ,��Ѻ�ʲ��ܳ���100%
			if(("<%=sBusinessType.startsWith("2")%>"=="true" && "<%=sImpawnType%>" == "020010")||
				("<%=sBusinessType.startsWith("2")%>"=="true" && "<%=sImpawnType%>" == "020210")||
				((sThirdParty1 == "01" || sThirdParty1 =="03") && "<%=sImpawnType%>" == "020010" ))
			{
				if(sGuarantyRate >100)
				{
					alert("��Ѻ�ʲ��ô���100%��");
					return false;
				}
			}else {
				alert("��Ѻ�ʲ��ô���90%��");
				return false;
			}
		}
		
		//����������Ч�Լ��(��ʾ������)
		sEvalOrgName = getItemValue(0,getRow(),"EvalOrgName");
		sEvalDate = getItemValue(0,getRow(),"EvalDate");
		if(typeof(sEvalOrgName) != "undefined" && sEvalOrgName != "" )
		{
			sReturn=RunMethod("CustomerManage","selectNewEvalOrgDate",sEvalOrgName);
			sReturn1=sReturn.split("@");
	     	sEffectStartDate=sReturn1[0];
	     	sEffectFinishDate=sReturn1[1];
			if(sEvalDate<sEffectStartDate || sEvalDate>sEffectFinishDate)
			{
				alert("������ڲ�������������Ч����!");
				return true;
			}
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
			setItemValue(0,0,"OwnerID","<%=sCustomerID%>");
			setItemValue(0,0,"OwnerName","<%=sCustomerName%>");
			setItemValue(0,0,"CertID","<%=sCertID%>");
			setItemValue(0,0,"CertType","<%=sCertType%>");
			setItemValue(0,0,"CertName","<%=sCertName%>");
			setItemValue(0,0,"LoanCardNo","<%=sLoanCardNo%>");			
			bIsInsert = true;			
		}
		
    }

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������		
		setObjectValue("SelectOwner","","@OwnerID@0@OwnerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");		
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
	
	function setEvalNetValue(){
		var sAboutSum1 = getItemValue(0,getRow(),"AboutSum1");
		if(typeof(sAboutSum1) != "undefined" && sAboutSum1 != ""){
			if(sAboutSum1<0){
				alert("Ʊ���������ڵ���0!");
				setItemValue(0,0,"AboutSum1","");
				return;
			}else{	
				setItemValue(0,0,"EvalNetValue",sAboutSum1);
				return;
			}
		}
		return;
	}
	
	
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���š��ͻ����ƺʹ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType = getItemValue(0,getRow(),"CertType");
		var sCertID = getItemValue(0,getRow(),"CertID");
		
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
				//setItemValue(0,getRow(),"CertID","");
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
