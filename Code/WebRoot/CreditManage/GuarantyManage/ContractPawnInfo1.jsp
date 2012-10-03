<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ҵ���ͬ����Ӧ�ĵ�Ѻ�������Ϣ����;
		Input Param:
			ObjectType����������
			ObjectNo: ������
			ContractNo: ������Ϣ���
			GuarantyID��������
			PawnType����Ѻ������
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ѻ�������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sGuarantyStatus = "";//��Ѻ��״̬
	String sTempletNo = "";//--ģ�����
	String sTempletFilter = "";//ģ����˱���
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	String sPawnTypeName = "";//��Ѻ����������
	String sBCMaturity = "";//��ͬ������
	String sBusinessType = "";//ҵ��Ʒ��
	double dBusinessSum = 0;//��ͬ���
	
	//����������:
	String sOldObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sOldObjectType==null)sOldObjectType="";

	//���ҳ��������������͡������š�������Ϣ��š���Ѻ���š���������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractNo"));
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyID"));
	String sPawnType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PawnType"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sContractNo == null) sContractNo = "";
	if(sGuarantyID == null) sGuarantyID = "";
	if(sPawnType == null) sPawnType = "";
	if(sObjectType.equals("ReinforceContract")) sObjectType="BusinessContract";	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		        	
	//���ݵ�Ѻ���Ż�ȡ��Ѻ��״̬��01��δ��⣻02����⣻03����ʱ���⣻04�����⣩
	sGuarantyStatus = Sqlca.getString("select GuarantyStatus from GUARANTY_INFO where GuarantyID = '"+sGuarantyID+"'");
	if(sGuarantyStatus == null) sGuarantyStatus = "01";
	
	sSql = " select Maturity,BusinessType,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum "+
				  " from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sBCMaturity = rs.getString("Maturity");
		if(sBCMaturity == null) sBCMaturity = "";
		sBusinessType = rs.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = "";
		dBusinessSum = rs.getDouble("BusinessSum");
	}
	rs.getStatement().close();
	//���ݵ�Ѻ������ȡ����ʾģ���
	sSql = "select ItemName,ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='"+sPawnType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sTempletNo = rs.getString("ItemDescribe");
		sPawnTypeName = rs.getString("ItemName");
	}
	rs.getStatement().close();
	
	//����ֵת��Ϊ���ַ���
	if(sTempletNo == null) sTempletNo = "";
	if(sPawnTypeName == null) sPawnTypeName = "";

	//���ù�������	
	sTempletFilter = " (ColAttribute like '%BusinessContract%' ) and (attribute1 is null or attribute1 = ' ' or attribute1 like '%"+sBusinessType+"%') ";

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//����Ȩ����ѡ���
	if("1030040".equals(sBusinessType)) 
		doTemp.setReadOnly("InsuranceType",true);
	doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
	doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	doTemp.setUnit("EvalOrgName"," <input type=button value=.. onclick=parent.selectEvalOrgName()>");
	doTemp.setHTMLStyle("OwnerName"," style={width:400px} ");	
	if(sPawnType.equals("010020")){
		doTemp.appendHTMLStyle("OwnerTime"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(sGuarantyStatus.equals("01")||"ReinforceContract".equals(sOldObjectType)) 
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
		{((sGuarantyStatus.equals("01")||"ReinforceContract".equals(sOldObjectType))?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
		if(vI_all("myiframe0"))
		{
		//¼��������Ч�Լ��
			if (!ValidityCheck()) return;
			if(bIsInsert){		
				beforeInsert();
			}
	
			beforeUpdate();
			as_save("myiframe0",sPostEvents);	
		}		
	}
	function selectEvalOrgName()
	{
		//����ֻ���ɷ��ز����������������������ʲ�������˾
		var AuditOrgType = "";
		if("<%=sPawnType%>" == "010010"){
			AuditOrgType = "020";
		}else{
			AuditOrgType = "030";
		}
		sParaString = "AuditOrgType"+","+AuditOrgType;
		if("<%=sPawnType%>" == "010020"||"<%=sPawnType%>" == "010025")//����||�ڽ�����
		{
			setObjectValue("selectNewEvalOrgName2",sParaString,"@EvalOrgName@0",0,0,"");
		}else{
			setObjectValue("selectNewEvalOrgName",sParaString,"@EvalOrgName@0",0,0,"");
		}
	}
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/GuarantyManage/ContractPawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo=<%=sContractNo%>","_self","");
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
		
		//У��Ȩ���˴�����
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//Ȩ���˴�����	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
		{
			if(!CheckLoanCardID(sLoanCardNo))
			{
				alert(getBusinessMessage('235'));//Ȩ���˴���������							
				return false;
			}
			
			//����Ȩ���˴�����Ψһ��
			sOwnerName = getItemValue(0,getRow(),"OwnerName");//Ȩ��������	
			sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sOwnerName+","+sLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
			{
				alert(getBusinessMessage('236'));//��Ȩ���˴������ѱ������ͻ�ռ�ã�							
				return false;
			}						
		}
		
		//��������Ȩ�����Ƿ����Ŵ���ϵ�����δ��������Ҫ�»�ȡȨ���˵Ŀͻ����
		if(typeof(sCertType) != "undefined" && sCertType != "" 
		&& typeof(sCertID) != "undefined" && sCertID != "")
		{
			var sOwnerID = PopPage("/PublicInfo/CheckCustomerAction.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sOwnerID)=="undefined" || sOwnerID.length==0) {
				return false;
			}
			setItemValue(0,0,"OwnerID",sOwnerID);
		}			
/*	
		if("<%=sOldObjectType%>" != "ReinforceContract"){
			//���������Ʒ�֣�Ͷ�����Ӧ�����ڴ����
			sInsuranceSum = getItemValue(0,0,"InsuranceSum");//--���ս��
			if("<%=dBusinessSum%>" > sInsuranceSum && (typeof(sInsuranceSum) != "undefined" && sInsuranceSum != "")){
				alert("���ս��Ӧ�����ڴ����!");
				return false
			}	

			//���յ������賤�ں�ͬ�����գ����У����ز�����������ڱ��յ�����Ҫ�󣺱��յ���Ч��Ӧ���ٳ��ں�ͬ�����պ��92�졣
			sInsuranceEndDate = getItemValue(0,0,"InsuranceEndDate");//--���յ�����
			if(typeof(sInsuranceEndDate) != "undefined" && sInsuranceEndDate != ""){
				sBCMaturity = "<%=sBCMaturity%>";
				if(sBCMaturity == "" ){
					alert("������д��ͬ��Ϣ��");
					return false;
				}else{
					//dReturn = RunMethod("BusinessManage","getDays",sInsuranceEndDate+","+sBCMaturity);
					var sCheckTermMonth = "2";
					var iCheckTermDay1 = "-1";
					sReturn = RunMethod("WorkFlowEngine","DateExcute",sBCMaturity+","+sCheckTermMonth+","+iCheckTermDay1);
					if("<%=sBusinessType%>" == "1050010" && sReturn >= sInsuranceEndDate){
						alert("���ز���������ı��������賤�ں�ͬ����3�¼�1��!");
						return false;
					}
					else if(dReturn < 0){
						alert("���յ������賤�ں�ͬ������!");
						return false;
					}
					
				}	
			}	
			
		}
*/		
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
			setItemValue(0,0,"GuarantyType","<%=sPawnType%>");			
			setItemValue(0,0,"GuarantyStatus","01");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"GuarantyTypeName","<%=sPawnTypeName%>");
			if("<%=sBusinessType%>" == "1030040") 
				setItemValue(0,0,"InsuranceType","�ۺϲƲ���");
			bIsInsert = true;			
		}
		if("<%=sOldObjectType%>" == "ReinforceContract"){
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");		
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
	
	/* ���õ�Ѻ��2009-12-26 lpzhang*/
	function setGuarantyRate()
	{
		dConfirmValue = getItemValue(0,getRow(),"ConfirmValue");
		dAboutSum2 = getItemValue(0,getRow(),"AboutSum2");
		if(dConfirmValue<0 || dAboutSum2<0){
			alert("��ֵ����С���㣡");
			return;
		}
		dGuarantyRate = (dAboutSum2/dConfirmValue)*100;
		dGuarantyRate = roundOff(dGuarantyRate,2);
		setItemValue(0,0,"GuarantyRate",dGuarantyRate);
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
