<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   lpzhang 2009-7-30
		Tester:
		Content: ҵ�������Ϣ
		Input Param:
				 ObjectType����������
				 ObjectNo��������
		Output param:
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�����������������������Ӧ����������SQL��䡢��Ʒ���͡��ͻ����롢��ʾ����
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "",sThirdParty="0.0";
	//�����������ѯ��������ʾģ�����ơ��������͡��������͡��ݴ��־������ҵ������Ķ��������ˮ
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sBAAgreement = "";
	//�������������ҵ����֡�����ҵ�����ա�������ˮ��
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "";
	//����������ͻ�����,�ͻ���Ϣ����,��ҵͶ��
	String sCustomerType = "",sCustomerTable="",sIndustryType="",sApproveDate="",sCreditAggreement="",sChangType = "" ;
	//�������������ҵ�������ҵ�����ʡ�����ҵ�����
	double dOldBusinessSum = 0.0,dOldBusinessRate = 0.0,dOldBalance = 0.0,dThirdPartyRatio=0.0,dThirdParty=0.0;
	//���������չ�ڴ��������»��ɴ��������ɽ��´�����ծ���������
	int iExtendTimes = 0,iLNGOTimes = 0,iGOLNTimes = 0,iDRTimes = 0,dTermDay=0 ,dOldTermMonth=0,dOldTermDay=0;
	//�����������ѯ�����
	ASResultSet rs = null;
	
	//���ҳ�����	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	/*
	String sObjectTypeUsed = "";//��Ȳ���ʱҪʹ�õ�ObjectType add by zrli 
	if(sObjectType.equals("ReinforceContract"))
		sObjectTypeUsed = "BusinessContract";
	else
		sObjectTypeUsed = sObjectType;
	*/
%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%	
	//���ݶ������ʹӶ������Ͷ�����в�ѯ����Ӧ�����������
	sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sMainTable = DataConvert.toString(rs.getString("ObjectTable"));
		sRelativeTable = DataConvert.toString(rs.getString("RelativeTable"));
				
		//����ֵת���ɿ��ַ���
		if(sMainTable == null) sMainTable = "";
		if(sRelativeTable == null) sRelativeTable = "";		
	}
	rs.getStatement().close(); 
	
	//��ҵ����л��ҵ��Ʒ��
	sSql = "select CustomerID,BAAgreement,ApplyType,RelativeSerialNo,CustomerID,BusinessType,OccurType,TempSaveFlag,ApproveDate,changtype from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sBAAgreement = DataConvert.toString(rs.getString("BAAgreement"));
		sApplyType = DataConvert.toString(rs.getString("ApplyType"));
		sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
		sOccurType = DataConvert.toString(rs.getString("OccurType"));
		sTempSaveFlag = DataConvert.toString(rs.getString("TempSaveFlag")); 
		sApproveDate = DataConvert.toString(rs.getString("ApproveDate")); 
		sChangType = DataConvert.toString(rs.getString("changtype"));
		
		//����ֵת���ɿ��ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sBAAgreement == null) sBAAgreement = "";
		if(sApplyType == null) sApplyType = "";
		if(sRelativeSerialNo == null) sRelativeSerialNo = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sTempSaveFlag == null) sTempSaveFlag = "";
		if(sApproveDate == null) sApproveDate = "";
		if(sChangType == null) sChangType = "";
	
	}
	rs.getStatement().close(); 
	System.out.println("sApproveDate:"+sApproveDate);
	
	sSql= "select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerType = rs.getString("CustomerType");
		if(sCustomerType == null) sCustomerType = "";
	}
	rs.getStatement().close(); 

	//���ҵ��Ʒ��Ϊ��,����ʾ���������ʽ����
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//��ҵ�����Ϊ����ʱ��ִ������ҵ���߼�
	if(sObjectType.equals("CreditApply"))
	{
		//���ݷ������ͣ�ϵͳ�ݴ��� չ�ڡ����»��ɡ����ɽ��¡�ծ�������������ͣ���ȡ��Ӧ�Ĺ���ҵ����Ϣ
		if(sOccurType.equals("015") || sOccurType.equals("020") || sOccurType.equals("060") || sOccurType.equals("065")) //չ�ڡ����»��ɡ����ɽ��¡�����(����)
		{
			//��ȡչ�ں�ͬ��/��ݣ��Ľ������ʡ����֡������ա�չ�ڴ��������»��ɴ��������ɽ��´�����ծ�������������Ϣ
			//sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //���պ�ͬ
			String sContractNo = "";
			sSql = 	" select relativeserialno2, BusinessSum,Balance,ActualBusinessRate,BusinessCurrency,Maturity,ExtendTimes,RenewTimes as LNGOTimes,GOLNTimes,ReorgTimes as DRTimes "+ //���ս��
					//" from BUSINESS_CONTRACT "+ //���պ�ͬ
					" from BUSINESS_DUEBILL "+ //���ս��
					" where SerialNo in (select ObjectNo "+
					" from "+sRelativeTable+" "+
					//" where ObjectType = 'BusinessContract' "+ //���պ�ͬ
					" where ObjectType = 'BusinessDueBill' "+ //���ս��
					" and SerialNo = '"+sObjectNo+"') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{ 
				sContractNo= rs.getString("relativeserialno2");
				dOldBusinessSum = rs.getDouble("BusinessSum");
				dOldBalance = rs.getDouble("Balance");
				dOldBusinessRate = rs.getDouble("ActualBusinessRate");			
				sOldBusinessCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
				sOldMaturity = DataConvert.toString(rs.getString("Maturity"));
				iExtendTimes = rs.getInt("ExtendTimes");
				iLNGOTimes = rs.getInt("LNGOTimes");
				iGOLNTimes = rs.getInt("GOLNTimes");
				iDRTimes = rs.getInt("DRTimes");
							
				//����ֵת���ɿ��ַ���					
				if(sOldBusinessCurrency == null) sOldBusinessCurrency = "";
				if(sOldMaturity == null) sOldMaturity = "";
			}
			rs.getStatement().close(); 		
			if(sOccurType.equals("015")){
				sSql = "select TermMonth,TermDay from BUSINESS_CONTRACT where SerialNo = '"+sContractNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					dOldTermMonth = rs.getInt("TermMonth");
					dOldTermDay = rs.getInt("TermDay");
				}
				rs.getStatement().close();
			}
		}else if(sOccurType.equals("030")) //ծ������
		{
			//��ȡ�ʲ����鷽�����
			sSql = 	" select ObjectNo from "+sRelativeTable+" "+
					" where ObjectType = 'CapitalReform' "+
					" and SerialNo = '"+sObjectNo+"' ";
			String sCapitalReformNo = Sqlca.getString(sSql);
			/*
			//��ȡ�����ͬ�Ľ�ծ�������ͬ�����ʡ����֡������ա�չ�ڴ��������»��ɴ��������ɽ��´�����ծ�������������Ϣ
			sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //���պ�ͬ
					" from BUSINESS_CONTRACT "+ //���պ�ͬ
					" where SerialNo = (select ObjectNo "+
					//" from APPLY_RELATIVE "+
					" from Reform_RELATIVE "+
					" where ObjectType = 'BusinessContract' "+ 				
					" and SerialNo = '"+sCapitalReformNo+"') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{ 
				dOldBusinessSum = rs.getDouble("BusinessSum");
				dOldBalance = rs.getDouble("Balance");
				dOldBusinessRate = rs.getDouble("BusinessRate");			
				sOldBusinessCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
				sOldMaturity = DataConvert.toString(rs.getString("Maturity"));
				iExtendTimes = rs.getInt("ExtendTimes");
				iLNGOTimes = rs.getInt("LNGOTimes");
				iGOLNTimes = rs.getInt("GOLNTimes");
				iDRTimes = rs.getInt("DRTimes");
							
				//����ֵת���ɿ��ַ���					
				if(sOldBusinessCurrency == null) sOldBusinessCurrency = "";
				if(sOldMaturity == null) sOldMaturity = "";
			}
			rs.getStatement().close(); 	
			*/
		}
		//��Щ����ҵ����Ҫ�ٽ��й���һ�Σ�չ��/���»���/���ɽ���/ծ�����飩�������Ҫ��ԭ���Ĵ���������һ��
		iExtendTimes = iExtendTimes + 1;
		iLNGOTimes = iLNGOTimes + 1;
		iGOLNTimes = iExtendTimes + 1;
		iDRTimes = iDRTimes + 1;
	}else{//��������
		//չ��ȡԭ����ͬ�����¡���
		if(sOccurType.equals("015"))
		{
			//��ȡչ�ں�ͬ��/��ݣ� ��ͬ��
			//sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //���պ�ͬ
			String sContractNo = "";
			sSql = 	" select relativeserialno2 "+ 
					//" from BUSINESS_CONTRACT "+ //���պ�ͬ
					" from BUSINESS_DUEBILL "+ //���ս��
					" where SerialNo in (select ObjectNo "+
					" from "+sRelativeTable+" "+
					//" where ObjectType = 'BusinessContract' "+ //���պ�ͬ
					" where ObjectType = 'BusinessDueBill' "+ //���ս��
					" and SerialNo = '"+sObjectNo+"') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{ 
				sContractNo= rs.getString("relativeserialno2");	
				//����ֵת���ɿ��ַ���					
				if(sContractNo == null) sContractNo = "";
			}
			rs.getStatement().close(); 		
			sSql = "select TermMonth,TermDay from BUSINESS_CONTRACT where SerialNo = '"+sContractNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				dOldTermMonth = rs.getInt("TermMonth");
				dOldTermDay = rs.getInt("TermDay");
			}
			rs.getStatement().close();
		}
	}
	
	//���ݲ�Ʒ���ʹӲ�Ʒ��Ϣ��BUSINESS_TYPE�л����ʾģ������
	//��������Ϊչ�ڣ���Ҫ����չ����Ϣģ��
	if(sOccurType.equals("015"))
	{
		if(sObjectType.equals("CreditApply")) //�������
			sDisplayTemplet = "ApplyInfo0000";
		if(sObjectType.equals("ApproveApply")) //���������������
			sDisplayTemplet = "ApproveInfo0000";
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //��ͬ����
			sDisplayTemplet = "ContractInfo0000";					
	}else
	{
		if(sObjectType.equals("CreditApply")) //�������
			sFieldName = "ApplyDetailNo";
		if(sObjectType.equals("ApproveApply")) //���������������
			sFieldName = "ApproveDetailNo";
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //��ͬ����
			sFieldName = "ContractDetailNo";

		sSql = " select "+sFieldName+" as DisplayTemplet from BUSINESS_TYPE where TypeNo = '"+sBusinessType+"' ";
		sDisplayTemplet = Sqlca.getString(sSql);
	
		//����ͬһģ���ڲ�ͬ�׶���ʾ��ͬ������	
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //��ͬ����
			sColAttribute = " ColAttribute like '%"+sObjectType+"%' ";
	}
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,sColAttribute,Sqlca);
	//���ø��±���������
	doTemp.UpdateTable = sMainTable;
	doTemp.setKey("SerialNo",true);
	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��׼�����ʱ�����ڵ���0,С�ڵ���100��\" ");
	//------����-----------add by wangdw 2012-06-05
	if(sObjectType.equals("CreditApply"))
	{
		if("120".equals(sOccurType))
		{
			//doTemp.setReadOnly("",true);
			//doTemp.setReadOnly("ChangeReason",false);
			
		}
	}
	//�������;�����������;����
	if(sChangType.equals("05"))
	{
		doTemp.setReadOnly("Purpose",false);
	}
	
	if(sBusinessType.equals("1110010")|| sBusinessType.equals("1110020") || sBusinessType.equals("1110030") || sBusinessType.equals("1110040")||sBusinessType.equals("1110025") )
	{
		doTemp.appendHTMLStyle("ThirdPartyZIP3"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"������������ʱ�����ڵ���0,С�ڵ���1000��\" ");
		doTemp.appendHTMLStyle("ThirdPartyZIP2"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���Ҵ������������ڵ���0,С�ڵ���100��\" ");
		doTemp.appendHTMLStyle("ThirdPartyAdd1"," myvalid=\"parseFloat(myobj.value,10)>=0  \" mymsg=\"�׸���������ڵ���0 \" ");
		//doTemp.appendHTMLStyle("ThirdPartyZIP1"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�׸�����������ڵ���0,С�ڵ���100��\" ");
		
	}
	
	if( sBusinessType.equals("1110027"))
	{
		//doTemp.appendHTMLStyle("ThirdParty3"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�׸�����������ڵ���0,С�ڵ���100��\" ");
		doTemp.appendHTMLStyle("ThirdPartyID3"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���Ҵ������������ڵ���0,С�ڵ���100��\" ");
		doTemp.appendHTMLStyle("ThirdPartyID2"," myvalid=\"parseFloat(myobj.value,10)>=0  \" mymsg=\"�׸���������ڵ���0 \" ");
	}
	if( sBusinessType.equals("1080070"))
	{
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤��֤�����������ڵ���0,С�ڵ���100��\" ");
	}
	//������ѧ����
	if( sBusinessType.equals("1110150"))
	{
		doTemp.appendHTMLStyle("ThirdPartyID1"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��Ϣ����������ڵ���0,С�ڵ���100��\" ");
	}
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����������ڵ���0,С�ڵ���100��\" ");
	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������ʱ�����ڵ���0,С�ڵ���1000��\" ");
	
	//ũ����������
	if(sBusinessType.equals("1150020"))
	{
		doTemp.setVisible("BailRatio,BailSum",true);
		doTemp.setRequired("BailRatio",true);
	}
	if(sBusinessType.equals("3010")){
		doTemp.setVisible("BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate,SelfUseFlag",true);
		doTemp.setRequired("RateFloatType,RateFloat,BusinessRate,SelfUseFlag",true);
	}
	
	//�Զ���ȡ�������ͺ�����ֵ
	if(!sBusinessType.startsWith("3") || sBusinessType.startsWith("3010")){
		if("2110020".equals(sBusinessType))
		{
			doTemp.appendHTMLStyle("TermMonth,TermDay","onBlur=\"javascript:parent.getAFBaseRateType()\" ");
		}else{
			doTemp.appendHTMLStyle("TermMonth,TermDay","onBlur=\"javascript:parent.getBaseRateType()\" ");
		}
	}
	doTemp.appendHTMLStyle("VouchCorpFlag","onBlur=\"javascript:parent.setVouchAggreement()\" ");
	//��Ա���ҵ�������ѽ��Ϊ���޸�
	if(sBusinessType.startsWith("2030")||sBusinessType.startsWith("2040"))
	{
		doTemp.setReadOnly("PdgSum",false);
		doTemp.setReadOnly("PdgRatio",false);
	}else{
		doTemp.setReadOnly("PdgSum",true);
	}
	//�����ֶεĿɼ�����
	/* �ر�by zrli 2010-8-12
	if(sOccurType.equals("020")) //���»���ʱ��ʾ���»��ɴ����ֶ�
		doTemp.setVisible("LNGOTimes",true);
	if(sOccurType.equals("060")) //���ɽ�����ʾ���ɽ��´����ֶ�
		doTemp.setVisible("GOLNTimes",true);
	if(sOccurType.equals("030")) //ծ��������ʾծ����������ֶ�
		doTemp.setVisible("DRTimes",true);	
	*/
	if(sOccurType.equals("015"))
		doTemp.setCheckFormat("TotalSum,BusinessSum","2");
	//if(sOccurType.equals("120")&&sBusinessType.equals("1110027"))
	if(sOccurType.equals("120"))	
	{
		System.out.println("������ʾģ��=====================================>>>��");
		doTemp.setVisible("ChangType",true); 	//���ñ�����Ϳɼ�
		doTemp.setVisible("ChangeReason",true); //���ñ��ԭ��ɼ�
		doTemp.setRequired("ChangType",true);	//���ñ�����ͱ���
		doTemp.setReadOnly("ChangType",true);	//���ñ������Ϊֻ��
		doTemp.setUnit("AccumulationNo","<input type=button value=\"����\" onClick=parent.SendGDTrade6030()>");	
		System.out.println("������ʾģ��=====================================>>>ֹ");
	}
	
	//�������ʸ�ʽ,����С����6λ
	doTemp.setCheckFormat("BusinessRate,OldBusinessRate,OverdueRate,TARate","16");
	//��ҵ��Ʒ������Ϊ��������֤Ѻ��ʱ�������ʸ���ֵ,����С����6λ	
	if(sBusinessType.equals("1080030"))   //��������֤Ѻ��
	{doTemp.setCheckFormat("RateFloat","16");}
	
	//�����������ͬ��������ʾҪ�صĲ�ͬ����
	if(sApplyType.equals("DependentApply")){//�������ҵ��
		doTemp.setVisible("CreditAggreement",true);
		if(sCustomerType.startsWith("03")){
			doTemp.setReadOnly("CycleFlag",true);  
		}
	}
	//------��ͬ�Ǽ�-----------
	if(sObjectType.equals("BusinessContract"))
	{
		doTemp.setReadOnly("BusinessCurrency",true);
		doTemp.setUnit("VouchTypeName","");
		
	}
	if(sObjectType.equals("AfterLoan"))
	{
		if(sCustomerType.startsWith("03")){//�����弶
			doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from code_library where codeno='ClassifyResult' and length(ItemNo)=2");  
		}else{//��˾ʮ��
			doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from code_library where codeno='ClassifyResult' and length(ItemNo)=4"); 
		}
	}
	
	//��ͬ����ʱ����ͬ�������ֶ�ֻ����� added by zrli
	if(sObjectType.equals("ReinforceContract"))
	{
		doTemp.setReadOnly("",false);
		doTemp.setReadOnly("SerialNo,CustomerID,CustomerName,BusinessTypeName,ArtificialNo,PutOutOrgName,ExposureSum",true);
		doTemp.setReadOnly("BusinessCurrency,BusinessSum,TermMonth,TermDay,BusinessRate,PutOutDate,VouchTypeName",true);
		doTemp.setReadOnly("Maturity,Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,DirectionName",true);
		doTemp.setReadOnly("OverdueDays,FinishType,FinishDate,ManageUserName,ManageOrgName,OperateUserName",true);
		doTemp.setReadOnly("OperateOrgName,InputUserName,InputOrgName,InputDate,UpdateDate,PigeonholeDate,AgriLoanClassifyName",true);
		//����Ǹ���

		if(sBusinessType.startsWith("1110") || sBusinessType.startsWith("1140") || sBusinessType.startsWith("1150")){

			doTemp.setReadOnly("VouchAggreement,VouchCorpName,ThirdParty3,BuildAgreement",true);
			if(sBusinessType.equals("1110020") || sBusinessType.equals("1140020") || sBusinessType.equals("1110040")) 
			{
				doTemp.setReadOnly("ThirdParty3",false);
			}

		}
		//����ҵ�񲻽������ʼ���
		doTemp.setHTMLStyle("BusinessRate,TermMonth,TermDay","");
		//����Ϊ�ɼ�,����,���޸�
		doTemp.setReadOnly("OccurType,ClassifyResult",false);
		doTemp.setVisible("OccurType,ClassifyResult",true);
		doTemp.setRequired("OccurType,ClassifyResult",true);
		doTemp.setRequired("InputUserName,InputOrgName",false);
		if(sCustomerType.startsWith("03")){//�����弶
			doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from code_library where codeno='ClassifyResult' and length(ItemNo)=2");  
		}else{//��˾ʮ��
			doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from code_library where codeno='ClassifyResult' and length(ItemNo)=4"); 
		}
		if(sBusinessType.startsWith("3"))
		{
			doTemp.setReadOnly("",false);
			doTemp.setReadOnly("VouchTypeName,ManageUserName,ManageOrgName,DirectionName,AgriLoanClassifyName,SerialNo,CustomerID,CustomerName,BusinessTypeName,PutOutOrgName,ExposureSum,OccurType,OperateOrgName,OperateUserName,InputUserName,InputOrgName,InputDate,UpdateDate,PigeonholeDate",true);
		}
		if("2010".equals(sBusinessType) || "2070".equals(sBusinessType)){
			doTemp.setReadOnly("",false);
			doTemp.setReadOnly("VouchTypeName,FinishDate,DirectionName,PutOutOrgName,FinishType,AgriLoanClassifyName,ManageUserName,ManageOrgName,SerialNo,CustomerID,CustomerName,BusinessTypeName,ExposureSum,OccurType,OperateOrgName,OperateUserName,InputUserName,InputOrgName,InputDate,UpdateDate,PigeonholeDate",true);
		}
		if(sBusinessType.startsWith("2030") || sBusinessType.startsWith("2040") || sBusinessType.startsWith("2050") 
			|| sBusinessType.startsWith("1020") || sBusinessType.startsWith("1080") || sBusinessType.startsWith("2110")){
			doTemp.setReadOnly("",false);
			doTemp.setReadOnly("VouchTypeName,FinishDate,VouchFlagName,DirectionName,FinishType,PutOutOrgName,AgriLoanClassifyName,ManageUserName,ManageOrgName,SerialNo,CustomerID,CustomerName,BusinessTypeName,ExposureSum,OccurType,OperateOrgName,OperateUserName,InputUserName,InputOrgName,InputDate,UpdateDate,PigeonholeDate",true);
			if("2110020".equals(sBusinessType) || "1080070".equals(sBusinessType))
			{
				doTemp.setReadOnly("OccurType",false);
			}
		}
		if("1110010".equals(sBusinessType)){
			doTemp.setReadOnly("",false);
			doTemp.setReadOnly("OverdueDays,Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,VouchTypeName,FinishDate,DirectionName,PutOutOrgName,FinishType,AgriLoanClassifyName,ManageUserName,ManageOrgName,SerialNo,CustomerID,CustomerName,BusinessTypeName,ExposureSum,OccurType,OperateOrgName,OperateUserName,InputUserName,InputOrgName,InputDate,UpdateDate,PigeonholeDate",true);
		}
		doTemp.setRequired("PutOutOrgName",false);
	}
	
%>
	<%@include file="CheckBusinessDataValidity.jsp"%>	
<%
	//����DataWindow����	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "0"; 
	

	//ֻ��ҵ��Ʒ���Ƕ��ʱ��Ҫ����CL_Info
	if(sBusinessType.startsWith("30") && !sBusinessType.equals("3020"))
	{
		if("ReinforceContract".equals(sObjectType))
		{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateCLInfo(BusinessContract,#SerialNo,#BusinessSum,#BusinessCurrency,#LimitationTerm,#BeginDate,#PutOutDate,#Maturity,#UseTerm,#TermMonth)");
		}else{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateCLInfo("+sObjectType+",#SerialNo,#BusinessSum,#BusinessCurrency,#LimitationTerm,#BeginDate,#PutOutDate,#Maturity,#UseTerm,#TermMonth)");
		}
		
	}
	if(sBusinessType.equals("3020"))
	{
		if("ReinforceContract".equals(sObjectType))
		{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateEntAgreementInfo(#SerialNo,BusinessContract)");
		}else{
			dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateEntAgreementInfo(#SerialNo,"+sObjectType+")");
		}
	}
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//��ȡУ��������Ϣ
	double dCheckBusinessSum = 0.0,dCheckBaseRate = 0.0,dCheckRateFloat = 0.0,dCheckBusinessRate = 0.0;
	double dCheckPdgRatio = 0.0,dCheckPdgSum = 0.0,dCheckBailSum = 0.0,dCheckBailRatio = 0.0,dCognScore=0.0;
	String sCheckRateFloatType = "",sCognResult="";
	int iCheckTermYear = 0,iCheckTermMonth = 0,iCheckTermDay = 0;
	//����������Ϊ��ͬ����Ӧ��������Ϣʱ����ȡ���������������Ӧ��������Ϣ
	if(sObjectType.equals("BusinessContract")||sObjectType.equals("ApproveApply") )
	{
		//��ȡ��������������ˮ��
		sSql = 	" select max(SerialNo) "+
				" from FLOW_Task "+
				" where ObjectType = 'CreditApply' "+
				" and ObjectNo ='"+sRelativeSerialNo+"' ";
		String sTaskSerialNo = Sqlca.getString(sSql);
		
		//������������������ˮ�źͶ����Ż�ȡ��Ӧ��ҵ����Ϣ
		sSql = 	" select BA.BusinessSum,BA.BaseRate,BA.RateFloatType,BA.RateFloat, "+
				" BA.BusinessRate,BA.BailSum,BA.BailRatio,BA.PdgRatio,BA.PdgSum, "+
				" BA.TermYear,BA.TermMonth,BA.TermDay,BA.CognScore,BA.CognResult "+
				" from FLOW_OPINION BA "+
				" where BA.SerialNo =  (select RelativeSerialNo from Flow_Task where Serialno = '"+sTaskSerialNo+"') ";
	}
	
	if(sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract"))
	{
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			dCheckBusinessSum = rs.getDouble("BusinessSum");
			dCheckBaseRate = rs.getDouble("BaseRate");
			dCheckRateFloat = rs.getDouble("RateFloat");
			dCheckBusinessRate = rs.getDouble("BusinessRate");
			dCheckPdgRatio = rs.getDouble("PdgRatio");
			dCheckPdgSum = rs.getDouble("PdgSum");
			dCheckBailSum = rs.getDouble("BailSum");
			dCheckBailRatio = rs.getDouble("BailRatio");
			sCheckRateFloatType = rs.getString("RateFloatType");
			iCheckTermYear = rs.getInt("TermYear");
			iCheckTermMonth = rs.getInt("TermMonth");
			iCheckTermDay = rs.getInt("TermDay");
			dCognScore = rs.getDouble("CognScore");
			sCognResult = rs.getString("CognResult");
		}
		rs.getStatement().close(); 
		if(sCheckRateFloatType == null) sCheckRateFloatType = "";
	}
	
	
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
				{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
				{"true","","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()",sResourcesPath}
		};
	//���ݴ��־Ϊ�񣬼��ѱ��棬�ݴ水ťӦ����
	if(sTempSaveFlag.equals("2"))
		sButtons[1][0] = "false";
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		//¼��������Ч�Լ��
						
		if(vI_all("myiframe0"))
		{
			if("2110020" != "<%=sBusinessType%>" )
			{
				if(!ValidityCheck()) return;
			}
			if("BusinessContract" == "<%=sObjectType%>" ){
				getNewBaseRate();
			}else if("CreditApply" == "<%=sObjectType%>" ){
				if("2110020" == "<%=sBusinessType%>"){
					getAFBaseRateType();
				}else{
					getBaseRateType();
				}
			}
			beforeUpdate();
			setItemValue(0,getRow(),"TempSaveFlag","2"); //�ݴ��־��1���ǣ�2����			
			as_save("myiframe0");
		}
	}
	
	/*~[Describe=�ݴ�;InputParam=��;OutPutParam=��;]~*/
	function saveRecordTemp()
	{
		//0����ʾ��һ��dw
		setNoCheckRequired(0);  //���������б���������
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�2����
		as_save("myiframe0");   //���ݴ�
		setNeedCheckRequired(0);//����ٽ����������û���		
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{	
		sBusinessType = "<%=sBusinessType%>";	
		sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//��ȡ��֤�����
		if(sBusinessType != "2050030")//��������֤
		{
			getBailSum1();
		}
		if(sBusinessType.substring(0,4) != "2030" && sBusinessType.substring(0,4) != "2040" )//����
		{
			getpdgsum1();
		}
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");			
	}
	
	/*~[Describe=��������֤�������ͺ�Զ������֤�������޹�����ϵ����;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function checkBusinessSubType()
	{
	   sBusinessSubType = getItemValue(0,getRow(),"BusinessSubType");
	   if(sBusinessSubType == "01")
	   { 
	     setItemRequired(0,0,"GracePeriod",false);
	   }
	   else {setItemRequired(0,0,"GracePeriod",true); }
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{		
		//��������
		sOccurType = "<%=sOccurType%>";
		//���
		dOldBalance = "<%=dOldBalance%>";
		//��������
		sObjectType = "<%=sObjectType%>";
		//������
		sObjectNo = "<%=sObjectNo%>";
		//ҵ��Ʒ��
		sBusinessType = "<%=sBusinessType%>";
		//��׼���
		dCheckBusinessSum = "<%=dCheckBusinessSum%>";

		//������
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		//��֤����
		dBailSum = getItemValue(0,getRow(),"BailSum");
		//�����ѽ��
		dPdgSum = getItemValue(0,getRow(),"PdgSum");
		//����
		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
		//��ߴ�����
		dPromisesfeeSum = getItemValue(0,getRow(),"PromisesfeeSum");
		//�������
		dDealfee = getItemValue(0,getRow(),"Dealfee");
		//��ߴ������
		dPromisesfeeRatio = getItemValue(0,getRow(),"PromisesfeeRatio");
		//����
		dTermMonth = getItemValue(0,getRow(),"TermMonth");
		//������ҵͶ��
		sDirection = getItemValue(0,getRow(),"Direction");
		//�Ƿ����������
		sCreditSteel = getItemValue(0,getRow(),"CreditSteel");
		if(sDirection == "C3110" || sDirection == "C3120" || sDirection == "C3130" || sDirection == "C3140" || sDirection == "C3150" )
		{    
		     if(sCreditSteel == "2")
		     {
			    alert("���������ҵͶ���ܶ�Ӧ'�Ƿ����������'����Ϊ��");
			    return;
			 }  
		}else if(sDirection != "F5165" && sDirection != "F5164")
		{
		     if(sCreditSteel == "1")
		     {
			    alert("���������ҵͶ���ܶ�Ӧ'�Ƿ����������'����Ϊ�ǣ�");
			    return;
			 } 
		}  				
		if(sBusinessType == "1110010" || sBusinessType == "1110025"){
			dThirdPartyID2 = getItemValue(0,getRow(),"ThirdPartyID2"); //�����ܼ�
			dThirdPartyAdd1 = getItemValue(0,getRow(),"ThirdPartyAdd1"); //�׸���� 
			dThirdPartyZIP1 = getItemValue(0,getRow(),"ThirdPartyZIP1");//�׸�����
			if(parseFloat(dThirdPartyID2-dBusinessSum) - parseFloat(dThirdPartyAdd1)>0.1||parseFloat(dThirdPartyID2-dBusinessSum) - parseFloat(dThirdPartyAdd1)<-0.1){
				alert("��������׸������ڷ����ܼۣ�");
				return;
			}
			if(dThirdPartyZIP1<20){
				alert("�׸���������С��20% ��");
				return;
			}
		}
		
		if("3010,3020,3015,3050,3060,3040".indexOf(sBusinessType)>-1)
		{
			//�����������ܶ��ֻ�������󣬲�������С����Сʱ����ʾ��Ϣ����������
			sReturn = RunMethod("CreditLine","CheckCreditLineSum",sObjectNo+","+dBusinessSum+","+sObjectType+","+sBusinessCurrency+","+dPromisesfeeSum+","+dDealfee+","+dPromisesfeeRatio+","+dTermMonth+","+sBusinessType);
			if(sReturn == "01")	
			{
				alert("���ȸ������������ٸ��������ܶ");
				return false;					
			}
			if(sReturn == "02")	
			{
				alert("���ȸ������ŷ������޺��ٸ������������ޣ�");
				return false;					
			}
			if(sReturn == "03")	
			{
				alert("���ȸ��Ĵ�Э�������ٸ����ܶ");
				return false;					
			}
			if(sReturn == "04")	
			{
				alert("���ȸ��Ĵ�Э����ߴ�������ٸ�����������ߴ����");
				return false;					
			}
			if(sReturn == "05")	
			{
				alert("���ȸ��Ĵ�Э����ߴ������޺��ٸ�����������ߴ������ޣ�");
				return false;					
			}
			if(sReturn == "06")	
			{
				alert("���ȸ��Ĵ�Э����ߴ���������ٸ�����������ߴ��������");
				return false;					
			}
			
		}
		//���޿���		
		if(sObjectType == "CreditApply") //�������
		{
			//����
			dTermMonth = getItemValue(0,getRow(),"TermMonth");
			if(sBusinessType=="1050020")
			{
				if(dTermMonth<0 || dTermMonth>24)
				{
					alert("���ޱ�����ڵ���0,С�ڵ���24��");
					return false;
				}
			}else if(sBusinessType=="1050010")
			{
				if(dTermMonth<0 || dTermMonth>36)
				{
					alert("���ޱ�����ڵ���0,С�ڵ���36��");
					return false;
				}
			}else if(sBusinessType=="1030040")
			{
				if(dTermMonth<0 || dTermMonth>96)
				{
					alert("���ޱ�����ڵ���0,С�ڵ���96��");
					return false;
				}
			}else
			{
				if(dTermMonth<0)
				{
					alert("���ޱ�����ڵ���0��");
					return false;
				}
			}
		}
		
		
		
		if(sObjectType == "CreditApply") //�������
		{
			if(sOccurType == "015") //չ��ҵ��
			{
				dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
				if(dBusinessSum != dOldBalance)
				{
					alert(getBusinessMessage('511'));//չ�ڽ��������չ��ǰ��ҵ����
					return false;
				}
			}
			
			//�����ʽ���� ��ҵͶ����Ϊ���ز�
			if(sBusinessType.substring(0,4) == "1010" && sOccurType !="015"&&sOccurType !="020"&&sOccurType !="060"&&sOccurType !="065")
			{
				var sIndustryType = getItemValue(0,getRow(),"Direction");
				if(sIndustryType.substring(0,1) == "K")
				{
					alert("�����ʽ������ҵͶ����Ϊ���ز�ҵ��");
					return false;
				}
			}
			
			//�ڽ�������֤ҵ��Ʒ���£�У�鱣֤��ɴ������ʵ�����Ž��*��֤�����
			//if("<%=sBusinessType%>" == "2050030")//��������֤
			if(sBusinessType == "2050030")//��������֤
			{
			  dPracticeSum = getItemValue(0,getRow(),"PracticeSum");//ʵ�����Ž��
			  dBailSum = getItemValue(0,getRow(),"BailSum");//��֤����
			  dBailRatio = getItemValue(0,getRow(),"BailRatio");//��֤�����
			  if(parseFloat(dBailSum) < parseFloat(dPracticeSum)*parseFloat(dBailRatio)/100)
			   {
					alert("��֤���������ڵ���ʵ�����Ž��*��֤�����");
					return false;
			    }      
			}
			
			//�ڳ�������֤�������ҵ��Ʒ���£�У��������ô�������֤���ʹ�������ĳ˻�
			if(sBusinessType == "1080020")//��������֤�������
           {
             dOldLCSum = getItemValue(0,getRow(),"OldLCSum");//����֤���
             dBusinessSum = getItemValue(0,getRow(),"BusinessSum");//������
             dBusinessProp = getItemValue(0,getRow(),"BusinessProp");//�������
             if(parseFloat(dOldLCSum) * parseFloat(dBusinessProp)/100 < parseFloat(dBusinessSum))
              {
                alert("������ô�������֤���*�������");
                return false;
              }
            }
			
			//У���������뱣֤����֮���ҵ���߼���ϵ
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0)
			{	
				sBusinessType = "<%=sBusinessType%>";	        	
	        	//û�б�֤����� �ͱ�֤����ֲ��ɼ�
	        	if(sBusinessType == "2050020" || sBusinessType == "2050040" || sBusinessType == "1110070" ||  sBusinessType == "1150020" 
	        		|| sBusinessType == "2010" || sBusinessType == "2020" || sBusinessType.indexOf("2080") == 0 
	        		|| sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0 
	        		|| sBusinessType.indexOf("3030") == 0 || sBusinessType.indexOf("2090") == 0)
	        	{
					if(parseFloat(dBailSum) > parseFloat(dBusinessSum))
					{
						alert("��֤�������С�ڵ���������");
						return false;
					}
	        	}
	        	else
	        	{
	        		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//��ȡ�������
		    		sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//��ȡ��֤�����
		    		if(sBusinessCurrency != sBailCurrency)
		    		{
		    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
		            	if(parseFloat(dBailSum) > parseFloat(dBusinessSum*dERateRatio))
		            	{
		            		alert("��֤�������С�ڵ���������");
							return false;
						}
		            }
		            else
		            {
				        if(parseFloat(dBailSum) > parseFloat(dBusinessSum))
						{
							alert("��֤�������С�ڵ���������");
							return false;
						}
		            }
		        } 
			}
			
			//����������֤Ѻ�㡱Ʒ���£�����Ʊ��Ӧ���ڡ�����Ѻ���
			if("<%=sBusinessType%>" == "1080030" || "<%=sBusinessType%>" == "1080035")//��������֤Ѻ��
			  {	
				dInvoiceSum = getItemValue(0,getRow(),"InvoiceSum");//��Ʊ���
			  	sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//��ȡ�������
		    	sInvoiceCurrency = getItemValue(0,getRow(),"InvoiceCurrency");//��ȡ��Ʊ����
	    		if(sBusinessCurrency != sInvoiceCurrency)
	    		{
	    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sInvoiceCurrency+",''");
	            	if(parseFloat(dInvoiceSum) < parseFloat(dBusinessSum*dERateRatio))
	            	{
	            		alert("��Ʊ���Ӧ���������");
						return false;
					}
	            }else
	            {
			        if(parseFloat(dInvoiceSum) < parseFloat(dBusinessSum))
					{
						alert("��Ʊ���Ӧ���������");
						return false;
					}
	            }
			  }
			  //��������֤Ѻ�� �����ӦС�ڵ��ڡ�������*��1-����֤�����
			if("<%=sBusinessType%>" == "1080070")//��������֤Ѻ��
			  {	
				dOldLCSum = getItemValue(0,getRow(),"OldLCSum");//�������
			  	sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//��ȡ�������
		    	sOldLCCurrency = getItemValue(0,getRow(),"OldLCCurrency");//��ȡ��������
		    	dBusinessProp = getItemValue(0,getRow(),"BusinessProp");//��֤��֤�����
	    		if(sBusinessCurrency != sOldLCCurrency)
	    		{
	    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sOldLCCurrency+",''");
	            	if(parseFloat(dBusinessSum*dERateRatio) > dOldLCSum*(1-dBusinessProp/100))
	            	{
	            		alert("������ӦС�ڵ��ڵ������*��1-��֤�����%)��");
						return false;
					}
	            }else
	            {
			        if(parseFloat(dBusinessSum) > dOldLCSum*(1-dBusinessProp/100))
					{
						alert("������ӦС�ڵ��ڵ������*��1-��֤�����%)��");
						return false;
					}
	            }
			  }
			//У���������������ѽ��֮���ҵ���߼���ϵ
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dPdgSum) >= 0)
			{
				if("<%=sBusinessType%>" == "2050020")//��������֤
			    {	
			        sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
			    	sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
			    	dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");			
			      	if(parseFloat(dPdgSum) > parseFloat(dBusinessSum*dERateRatio))
					{
						alert("�����ѽ�����С�ڻ����������");
						return false;
					}
			    }else
			    {
					if(parseFloat(dPdgSum) > parseFloat(dBusinessSum))
					{
						alert("�����ѽ�����С�ڻ����������");
						return false;
					}
				}
			}
			 //���˹��̻�е����ҵ����ƣ�1��������ó����豸����ֵ��70%��2�����޲��ó���4��
			if("<%=sBusinessType%>" == "1140060")//���˹��̻�е����
			  {	
				dBusinessSum = getItemValue(0,getRow(),"BusinessSum");//������
			  	dEquipmentSum = getItemValue(0,getRow(),"EquipmentSum");//�豸����ֵ
		    	dTermMonth = getItemValue(0,getRow(),"TermMonth");//����
		    	if(parseFloat(dBusinessSum)>parseFloat(dEquipmentSum)*0.7)
		    	{
		    		alert("������ó����豸����ֵ��70%");
					return false;
		    	}
		    	if(parseFloat(dTermMonth)>48)
		    	{
		    		alert("���޲��ó���4��");
					return false;
		    	}
			  }				 		
		}
		
		if(sObjectType == "CreditApply" || sObjectType == 'ApproveApply')
		{
			//�����ʽ�����˵���Ĺ�ϵ
			sDrawingType = getItemValue(0,getRow(),"DrawingType");//��ʽ��01��һ����02���ִ���
			sContextInfo = getItemValue(0,getRow(),"ContextInfo");
			//ҵ��Ʒ��Ϊ���������ʽ������������ʽ���������˰�ʻ��йܴ��
			//��ҵ�жһ�Ʊ����������������Ŀ�������������Ŀ�����������Ŀ����
			//���Ŵ���ʱ
			if(sBusinessType == '1010010' || sBusinessType == '1010020'
			 || sBusinessType == '1010040' || sBusinessType == '1020040'
			 || sBusinessType == '1030010' || sBusinessType == '1030020'
			 || sBusinessType == '1030030' || sBusinessType == '1060'
			 || sBusinessType == '1030015' ) 
			{				
				if(typeof(sDrawingType) != "undefined" && sDrawingType != ""
				&& sDrawingType == "02" && (typeof(sContextInfo) == "undefined" 
				|| sContextInfo == ""))
				{
					alert(getBusinessMessage('490'));//�����ʽΪ�ִ����ʱ�����������˵����
					return false;
				}
			}
			
			//��黹�ʽ�ͻ���˵���Ĺ�ϵ
			sCorpusPayMethod = getItemValue(0,getRow(),"CorpusPayMethod");//���ʽ��1��һ�λ��2���ִλ��
			sPaySource = getItemValue(0,getRow(),"PaySource");
			//ҵ��Ʒ��Ϊ���������ʽ������������ʽ��������ʻ�͸֧��������˰�ʻ��йܴ��
			//���гжһ�Ʊ���֡���ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ�����֡���ҵ�жһ�Ʊ������
			//����������Ŀ�������������Ŀ�����������Ŀ������ز�����������Ŵ��
			//���ں�ͬ��������������֤��������������֤Ѻ�������֡���������Ѻ�������֡�
			//������ҵ��Ʊ���ʡ�����ͥ����������֤Ѻ�㡢���ڱ������ڱ������ڱ����ƽ�����ҵ��
			//ת������������ת�����ʽ�����֯���������㴢��ת�������ծȯת���
			//����ת���ί�д���ʱ
			if(sBusinessType == '1010010' || sBusinessType == '1010020'
			 || sBusinessType == '1010030' || sBusinessType == '1010040'
			 || sBusinessType == '1020010' || sBusinessType == '1020020'
			 || sBusinessType == '1020030' || sBusinessType == '1020040'
			 || sBusinessType == '1030010' || sBusinessType == '1030020'
			 || sBusinessType == '1030030' || sBusinessType == '1050'
			 || sBusinessType == '1060' || sBusinessType == '1080010'
			 || sBusinessType == '1080020' || sBusinessType == '1080030'
			 || sBusinessType == '1080035' || sBusinessType == '1080045'
			 || sBusinessType == '1080040' || sBusinessType == '1080050'
			 || sBusinessType == '1080060' || sBusinessType == '1080070'
			 || sBusinessType == '1090010' || sBusinessType == '1090020'
			 || sBusinessType == '1090030' || sBusinessType == '1100010'
			 || sBusinessType == '2060010' || sBusinessType == '2060020'
			 || sBusinessType == '2060030' || sBusinessType == '2060040'
			 || sBusinessType == '2060050' || sBusinessType == '2060060'
			 || sBusinessType == '2070'|| sBusinessType == '1030015') 
			{
				if(typeof(sCorpusPayMethod) != "undefined" && sCorpusPayMethod != ""
				&& sCorpusPayMethod == "2" && (typeof(sPaySource) == "undefined" 
				|| sPaySource == ""))
				{
					alert(getBusinessMessage('491'));//������ʽΪ�ִλ���ʱ�������뻹��˵����
					return false;
				}
			}
			
			
		}
		
		if(sObjectType == "BusinessContract")//��ͬ����
		{			
			//��ͬ���
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			if(parseFloat(dCheckBusinessSum) >= 0 && parseFloat(dBusinessSum) >= 0)
			{
				if(dBusinessSum > dCheckBusinessSum)
				{
					if(sOccurType == "015") //չ��ҵ��
					{
						alert(getBusinessMessage('552'));//չ�ڽ��(Ԫ)�������������������е���׼չ�ڽ��(Ԫ)��
						return false;
					}else
					{
						if(sBusinessType == '1020030') //Э�鸶ϢƱ������
						{
							alert(getBusinessMessage('553'));//Ʊ���ܽ��(Ԫ)����С�ڻ����������������е���׼Ʊ���ܽ��(Ԫ)��
							return false;
						}else if(sBusinessType == '2050030' || sBusinessType == '2020' || sBusinessType == '2050020') //��������֤����������֤����������֤
						{
							
							alert(getBusinessMessage('554'));//����֤���(Ԫ)����С�ڻ����������������е���׼����֤���(Ԫ)��
							return false;
						}else if(sBusinessType == '2050010') //�������
						{
							alert(getBusinessMessage('555'));//���ݽ��(Ԫ)����С�ڻ����������������е���׼���ݽ��(Ԫ)��
							return false;
						}else if(sBusinessType == '1100010') //�ƽ�����ҵ��
						{
							alert(getBusinessMessage('556'));//���޻ƽ��������С�ڻ����������������е���׼���޻ƽ������
							return false;
						}else if(sBusinessType == '3030010' || sBusinessType == '3030030' || sBusinessType == '3030020') //���˷��ݴ��������Ŀ���������������̡��������Ѵ������������
						{
							alert(getBusinessMessage('557'));//�����ܶ��(Ԫ)����С�ڻ����������������е���׼�����ܶ��(Ԫ)��
							return false;
						}else
						{
							alert(getBusinessMessage('558'));//��ͬ���(Ԫ)����С�ڻ����������������е���׼���(Ԫ)��
							return false;
						}	
					}
				}
	
			}
	
			//��ͬ��ʼ��
			sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
			//��ͬ������
			sMaturity = getItemValue(0,getRow(),"Maturity");			
			if(typeof(sPutOutDate) != "undefined" && sPutOutDate != ""
			&& typeof(sMaturity) != "undefined" && sMaturity != "")
			{
				if(sMaturity <= sPutOutDate)
				{
					if(sOccurType == "015") //չ��ҵ��
					{
						alert(getBusinessMessage('578'));//չ�ڵ����ձ�������չ����ʼ�գ�
						return false;
					}else
					{
						if(sBusinessType == '2050030') //��������֤
						{
							alert(getBusinessMessage('579'));//�����ձ������ڿ�֤�գ�
							return false;
						}else if(sBusinessType == '2020') //��������֤
						{
							alert(getBusinessMessage('580'));//����֤��Ч�ڱ������ڿ�֤�գ�
							return false;
						}else if(sBusinessType == '2050010' || sBusinessType == '2050020' 
						|| sBusinessType == '2090010' || sBusinessType == '2080030'
						|| sBusinessType == '2080020') 
						//�����������������֤��������������Ŵ�֤��������������
						{
							alert(getBusinessMessage('581'));//�����ձ������ڷ����գ�
							return false;
						}else if(sBusinessType == '2050040') //���Ᵽ��
						{
							alert(getBusinessMessage('582'));//���ڸ����ձ�������ǩ���գ�
							return false;
						}else if(sBusinessType == '2010') //���гжһ�Ʊ
						{
							alert(getBusinessMessage('583'));//�����ձ������ڳ�Ʊ�գ�
							return false;
						}else if(sBusinessType == '2030010' || sBusinessType == '2030020'
						|| sBusinessType == '2030030' || sBusinessType == '2030040'
						|| sBusinessType == '2030050' || sBusinessType == '2030060'
						|| sBusinessType == '2030070' || sBusinessType == '2040010'
						|| sBusinessType == '2040020' || sBusinessType == '2040030'
						|| sBusinessType == '2040040' || sBusinessType == '2040050'
						|| sBusinessType == '2040060' || sBusinessType == '2040070'
						|| sBusinessType == '2040080' || sBusinessType == '2040090'
						|| sBusinessType == '2040100' || sBusinessType == '2040110') 
						//������������𳥻�������͸֧�黹��������˰��������������ó�ױ�����
						//����������������Ա�����Ͷ�걣������Լ������Ԥ��������а����̱���
						//����ά�ޱ��������±���������ó�ױ��������ϱ��������ý𱣺���
						//�ӹ�װ��ҵ����ڱ����������������Ա���
						{
							alert(getBusinessMessage('584'));//ʧЧ���ڱ���������Ч���ڣ�
							return false;
						}else if(sBusinessType == '2080010' || sBusinessType == '3010' 
						|| sBusinessType == '1110090' || sBusinessType == '1110110'
						|| sBusinessType == '3030020') 
						//�����ŵ�����ۺ����Ŷ�ȡ�������Ѻ������˵�Ѻ����������Ѵ������������
						{
							alert(getBusinessMessage('585'));//�����ձ���������ʼ�գ�
							return false;
						}else if(sBusinessType == '3030030') //��������������
						{
							alert(getBusinessMessage('586'));//�����ձ�����������ҵ����ʼ�գ�
							return false;
						}else
						{
							alert(getBusinessMessage('587'));//��ͬ�����ձ������ں�ͬ��ʼ�գ�
							return false;
						}						
					}
				}else{
					if("<%=sApplyType%>" == "DependentApply"){
						sCreditAggreement =  getItemValue(0,getRow(),"CreditAggreement");
						//ȡ��Э��ĵ�����
						sAggreementMaturity = RunMethod("BusinessManage","GetMaturity",sCreditAggreement);
				
						dReturn = RunMethod("WorkFlowEngine","DateExcute",sAggreementMaturity+",5,-1");
		                dReturn1 = RunMethod("WorkFlowEngine","DateExcute",sAggreementMaturity+",11,-1");
						if(sMaturity > dReturn && sBusinessType == "2010")
						{
							alert("�������ҵ��(���гжһ�Ʊ�������ղ��ó�����Ⱥ���6����-1�죡");
							return false;
                        }else if(sPutOutDate > sAggreementMaturity && sBusinessType != "2010"){
	                        alert("�������ҵ����ʼ�ղ��ó�����ȵ����գ�");
	                        return false;
                        }else if(sMaturity > dReturn1 && sBusinessType != "2010"){
	                        alert("�������ҵ�����ղ��ó�����Ⱥ���1��-1�죡");
	                        return false;
                        }
					}else if("CreditLineApply" == "<%=sApplyType%>"){
						dReturn = RunMethod("WorkFlowEngine","DateExcute","<%=sApproveDate%>,2,-1");
						if(sPutOutDate > dReturn)
						{
							alert("��ͬ��ʼ�ճ����˶����׼�պ���3����-1�죡");
							return false;
						}
						/*remarked by lpzhang 2010-5-8 
						dReturn = RunMethod("CreditLine","CheckLineDate1",sSerialNo+","+sPutOutDate);
						if(dReturn > 92){
							alert("��ͬ��ʼ��������׼�ճ�����92�첻�ܵǼǺ�ͬ��");
							return false;
						}*/
					}	
					if(sOccurType == "015"){
						sTermDate1 = getItemValue(0,getRow(),"TermDate1");
						dReturn = RunMethod("BusinessManage","CheckExtendTime",sPutOutDate+","+sTermDate1);
						if(dReturn !=1){
							alert("��չ����ʼ�ա�Ϊ��չ��ǰ�����ա���ת�죨�ڶ��죩!");
							return false;
						}
					}
				}
				
				//��������Э��Ķ����Ч�ա����ʹ��������ڡ��������ҵ����ٵ�����������ʼ�ա������յ��߼���ϵ
				sBeginDate = getItemValue(0,getRow(),"BeginDate");
				sLimitationTerm = getItemValue(0,getRow(),"LimitationTerm");
				sUseTerm = getItemValue(0,getRow(),"UseTerm");
				if(typeof(sBeginDate) != "undefined" && sBeginDate != "")
				{
					if(typeof(sPutOutDate) != "undefined" && sPutOutDate != "")
					{
						if(sBeginDate < sPutOutDate)
						{
							alert(getBusinessMessage('612'));//�����Ч�ձ������ڻ������ʼ�գ�
							return false;
						}
					}
					
					if(typeof(sMaturity) != "undefined" && sMaturity != "")
					{					
						if(sBeginDate >= sMaturity)
						{
							alert(getBusinessMessage('613'));//�����Ч�ձ������ڵ����գ�
							return false;
						}
					}
					
					if(typeof(sLimitationTerm) != "undefined" && sLimitationTerm != "")
					{
						if(sLimitationTerm <= sBeginDate)
						{
							alert(getBusinessMessage('614'));//���ʹ��������ڱ������ڶ����Ч�գ�
							return false;
						}
					}
					
					if(typeof(sLimitationTerm) != "undefined" && sLimitationTerm != ""
					&& typeof(sMaturity) != "undefined" && sMaturity != "")
					{
						if(sLimitationTerm >= sMaturity)
						{
							alert(getBusinessMessage('615'));//���ʹ��������ڱ������ڵ����գ�
							return false;
						}
					}
					
					if(typeof(sUseTerm) != "undefined" && sUseTerm != "")
					{
						if(sUseTerm <= sBeginDate)
						{
							alert(getBusinessMessage('616'));//�������ҵ����ٵ������ڱ������ڶ����Ч�գ�
							return false;
						}
					}
					
					if(typeof(sUseTerm) != "undefined" && sUseTerm != ""
					&& typeof(sLimitationTerm) != "undefined" && sLimitationTerm != "")
					{
						if(sUseTerm <= sLimitationTerm)
						{
							alert(getBusinessMessage('617'));//�������ҵ����ٵ������ڱ������ڶ��ʹ��������ڣ�
							return false;
						}
					}
				}
				
				
				//У���ͬ���������ͬ��ʼ��֮��������Ƿ񳬹�����׼������
				iCheckTermMonth = "<%=iCheckTermMonth%>";
				iCheckTermDay =  "<%=iCheckTermDay%>";
				if((typeof(iCheckTermDay) != "undefined" && iCheckTermDay != "") || (typeof(iCheckTermMonth) != "undefined" && iCheckTermMonth != ""))	
				{	/*
					var sPutOutYear = sPutOutDate.substring(0,4);
					var sPutOutMonth = sPutOutDate.substring(5,7);
					var sPutOutDate1 = sPutOutDate.substring(8,10);
					var sMaturityYear = sMaturity.substring(0,4);
					var sMaturityMonth = sMaturity.substring(5,7);
					var sMaturityDate = sMaturity.substring(8,10);	
					var iCheckTermMonth1 = (parseInt(sMaturityYear*12)+parseInt(sMaturityMonth*10)/10)-(parseInt(sPutOutYear*12)+parseInt(sPutOutMonth*10)/10);			
					if(typeof(iCheckTermDay) != "undefined" && iCheckTermDay != "" && iCheckTermDay>0){
						iCheckTermMonth1 = parseInt(iCheckTermMonth1)-1;
					}
					if(parseInt(iCheckTermMonth)<parseInt(iCheckTermMonth1)){
						alert("��ͬ���ޱ���С�ڻ����������������е����ޣ����������£�");
						return;
					}
					*/
					//��ͬ������(��)
					var dTermMonth = getItemValue(0,getRow(),"TermMonth");
					var dTermDay = getItemValue(0,getRow(),"TermDay");
					//�޸�Ϊ���·�ʽ�����ͬ��ʼ�պ͵�����
					var sCheckTermMonth = parseInt(iCheckTermMonth)-1;
					var iCheckTermDay1 =0;
					if(typeof(iCheckTermDay) != "undefined" && iCheckTermDay != "" && iCheckTermDay>0){
						iCheckTermDay1 =iCheckTermDay;
					}
					dReturn = RunMethod("WorkFlowEngine","DateExcute",sPutOutDate+","+sCheckTermMonth+","+iCheckTermDay1);
					if(sMaturity > dReturn && sBusinessType!='2050020' && sBusinessType!='2050030' && sBusinessType!='2050010')
					{
						alert("��ͬ��ʼ�յ��������ޱ���С�ڻ����������������е����ޣ�");
						return false;
					}
					if(dTermMonth==iCheckTermMonth)
					{
						if(dTermDay > iCheckTermDay1)
						{
							alert("��ͬ���ޱ���С�ڻ����������������е����ޣ�");
							return false;
						}
					}else{
						if(dTermMonth > iCheckTermMonth)
						{
							alert("��ͬ���ޱ���С�ڻ����������������е����ޣ�");
							return false;
						}
					}
					/*				
					a = new Date(sPutOutDate);
					b = new Date(sMaturity);			
					if(parseInt((b-a)/1000/24/60/60/30) > (parseInt(iCheckTermMonth)+parseInt(iCheckTermYear)*12))
					{
						alert(getBusinessMessage('591'));//��ͬ���ޱ���С�ڻ����������������е����ޣ����������£���
						return;
					}
					*/
				}			
			}
			
			
			
			//��ͬ���
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//��֤����
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//�����ѽ��
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
			
			if("3010,3020,3015".indexOf(sBusinessType)>-1)
			{
				//�����������ܶ��ֻ�������󣬲�������С����Сʱ����ʾ��Ϣ����������
				sReturn = RunMethod("CreditLine","CheckCreditLineSum",sObjectNo+","+dBusinessSum+","+sObjectType+","+sBusinessCurrency+","+dPromisesfeeSum+","+dDealfee+","+dPromisesfeeRatio+","+dTermMonth+","+sBusinessType);
				if(sReturn == "01")	
				{
					alert("���ȸ������������ٸ��������ܶ");
					return false;					
				}
				if(sReturn == "02")	
				{
					alert("���ȸ������ŷ������޺��ٸ������������ޣ�");
					return false;					
				}
				if(sReturn == "03")	
				{
					alert("���ȸ��Ĵ�Э�������ٸ����ܶ");
					return false;					
				}
				if(sReturn == "04")	
				{
					alert("���ȸ��Ĵ�Э����ߴ�������ٸ�����������ߴ����");
					return false;					
				}
				if(sReturn == "05")	
				{
					alert("���ȸ��Ĵ�Э����ߴ������޺��ٸ�����������ߴ������ޣ�");
					return false;					
				}
				if(sReturn == "06")	
				{
					alert("���ȸ��Ĵ�Э����ߴ���������ٸ�����������ߴ��������");
					return false;					
				}
				
			}
			sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
			dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+",01,''");
			if(sBusinessType == "2050010" || sBusinessType == "2050020" || sBusinessType == "2050040" || sBusinessType == "1110070" 
	        		|| sBusinessType == "2010" || sBusinessType == "2020" || sBusinessType.indexOf("2080") == 0 
	        		|| sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0 
	        		|| sBusinessType.indexOf("3030") == 0 || sBusinessType.indexOf("2090") == 0)
	        {
	        	dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+",01,''");
	        }
	        else
	        {
		    	sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//��ȡ��֤�����
		    	if(!(typeof(sBailCurrency) != "undefined" && sBailCurrency != "")){
		    		sBailCurrency = "01";
		    	}
		    	dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
		    }	
			//У���ͬ����뱣֤����֮���ҵ���߼���ϵ
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0)
			{
				if(parseFloat(dBailSum) > parseFloat(dBusinessSum*dErateRatio))
				{
					if(sBusinessType == '2050030' || sBusinessType == '2020' 
					|| sBusinessType == '2050020') //��������֤����������֤����������֤
					{
						alert(getBusinessMessage('564'));//��֤����(Ԫ)����С�ڻ��������֤���(Ԫ)��
						return false;
					}if(sBusinessType == '2050010') //�������
					{
						alert(getBusinessMessage('566'));//��֤����(Ԫ)����С�ڻ���ڵ��ݽ��(Ԫ)��
						return false;
					}if(sBusinessType == '3030010' || sBusinessType == '3030020' 
					|| sBusinessType == '3030030') //���˷��ݴ��������Ŀ���������Ѵ�����������̡���������������
					{
						alert(getBusinessMessage('569'));//��֤����(Ԫ)����С�ڻ���ڳ����ܶ��(Ԫ)��
						return false;
					}else
					{
						alert("��֤����(Ԫ)����С�ڻ���ں�ͬ���(Ԫ)��");//��֤����(Ԫ)����С�ڻ���ں�ͬ���(Ԫ)��
						return false;
					}
				}
			}
			
			sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
			dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+",01,''");
			if("<%=sBusinessType%>" == "2050020")
	        {	
	        	sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
				dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
	        }
	        else
	        {
				dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+",01,''");
		    }				
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dPdgSum) >= 0)
			{
				if(parseFloat(dPdgSum) > parseFloat(dBusinessSum*dERateRatio))
				{
					if(sBusinessType == '2050030' || sBusinessType == '2020' 
					|| sBusinessType == '2050020') //��������֤����������֤����������֤
					{
						alert(getBusinessMessage('565'));//�����ѽ��(Ԫ)����С�ڻ��������֤���(Ԫ)��
						return false;
					}if(sBusinessType == '2050010') //�������
					{
						alert(getBusinessMessage('567'));//�����ѽ��(Ԫ)����С�ڻ���ڵ��ݽ��(Ԫ)��
						return false;
					}else if(sBusinessType != '1110170' && sBusinessType != '3030010' 
					&& sBusinessType != '3030020' && sBusinessType != '3030030' 
					&& sBusinessType != '1110027' && sBusinessType != '1110140' 
					&& sBusinessType != '1110150') //��Ϊ���˾�Ӫ������˷��ݴ��������Ŀ��
					//�������Ѵ�����������̡��������������̡�����ס������������ҵ��ѧ���������ѧ����
					{
						alert(getBusinessMessage('574'));//�����ѽ��(Ԫ)����С�ڻ���ں�ͬ���(Ԫ)��
						return false;
					}
				}
			}
			
			//��׼�Ļ�׼����
			sCheckBaseRate = "<%=dCheckBaseRate%>";
			//��׼�����ʸ�����ʽ
			sCheckRateFloatType = "<%=sCheckRateFloatType%>";
			//��׼�����ʸ���ֵ
			sCheckRateFloat = "<%=dCheckRateFloat%>";
			//��׼����
			sBaseRate = getItemValue(0,getRow(),"BaseRate");
			//���ʸ�����ʽ
			sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
			//���ʸ���ֵ
			sRateFloat = getItemValue(0,getRow(),"RateFloat");

			if(typeof(sRateFloatType) != "undefined" && sRateFloatType != ""
			&& typeof(sCheckRateFloatType) != "undefined" && sCheckRateFloatType != "")
			{
				if(sRateFloatType == sCheckRateFloatType)
				{
					if(parseFloat(sRateFloat) >= 0 && parseFloat(sCheckRateFloat) >= 0)
					{
						if(parseFloat(sRateFloat) < parseFloat(sCheckRateFloat))
						{
							alert(getBusinessMessage('560'));//���ʸ���ֵ������ڻ����������������е����ʸ���ֵ��
							return false;
						}
					}
				}
			}			
		}
		
		if(sBusinessType == '1020030') //Э�鸶ϢƱ������
		{
			//������Ϣ
			sDiscountInterest = getItemValue(0,getRow(),"DiscountInterest");
			//��Ӧ��������Ϣ
			sPurchaserInterest = getItemValue(0,getRow(),"PurchaserInterest");
			if(parseFloat(sDiscountInterest) >= 0 && parseFloat(sPurchaserInterest) >= 0)
			{
				if(parseFloat(sPurchaserInterest) > parseFloat(sDiscountInterest))
				{
					alert(getBusinessMessage('561'));//��Ӧ��������Ϣ(Ԫ)����С�ڻ����������Ϣ(Ԫ)��
					return false;
				}
			}
		}
		
		//�ж�Զ���Ƿ�����[��������֤�������]
		if(sBusinessType == "1080020") 
		{
		    var sGracePeriod = getItemValue(0,getRow(),"GracePeriod");
		    var sOldLCTermType = getItemValue(0,getRow(),"OldLCTermType");
		    if(sOldLCTermType != "01" && sOldLCTermType != "" && typeof(sOldLCTermType) != "undefined")
		    {
    		    if(typeof(sGracePeriod) == "undefined" || sGracePeriod == "")
    		    {
    		        alert(getBusinessMessage('494')); //ѡ��Զ������֤����ʱ��������Զ������֤�������ޣ�
    		        return;
    		    }
		    }
		}
		
		//�ж�Զ���Ƿ�����[��������֤]
		if(sBusinessType == "2020") 
		{		
			//У�鿪֤���ʱ�
			sThirdPartyZIP2 = getItemValue(0,getRow(),"ThirdPartyZIP2");//��֤���ʱ�
			if(typeof(sThirdPartyZIP2) != "undefined" && sThirdPartyZIP2 != "" )
			{	
				if(!CheckPostalcode(sThirdPartyZIP2))
				{
					alert(getBusinessMessage('489'));//��֤���ʱ�����
					return false;
				}
			}
			
			//У���������ʱ�
			sThirdPartyZIP1 = getItemValue(0,getRow(),"ThirdPartyZIP1");//�������ʱ�
			if(typeof(sThirdPartyZIP1) != "undefined" && sThirdPartyZIP1 != "" )
			{	
				if(!CheckPostalcode(sThirdPartyZIP1))
				{
					alert(getBusinessMessage('488'));//�������ʱ�����
					return false;
				}
			}
		
		    var sTermDay = getItemValue(0,getRow(),"TermDay");		    
		    var sBusinessSubType = getItemValue(0,getRow(),"BusinessSubType");		    		    
		    if(sBusinessSubType != "01" && sBusinessSubType != "" && typeof(sBusinessSubType)!= "undefined")
		    {
    		    if(sTermDay == "")
    		    {
    		        alert(getBusinessMessage('494')); //ѡ��Զ������֤����ʱ��������Զ������֤�������ޣ�
    		        return;
    		    }
		    }
		}
		
		//���Ŵ���
		if(sBusinessType=="1060")
		{
			var sApplyDate  =  "<%=StringFunction.getToday()%>";
			var sFirstDrawingDate = getItemValue(0,getRow(),"FirstDrawingDate");
			var sPromisesFeeBegin = getItemValue(0,getRow(),"PromisesFeeBegin");
			
			if(sFirstDrawingDate < sApplyDate)
			{	
				alert("�״�����ձ��������������!");
				return;
			}
			if(sPromisesFeeBegin < sApplyDate)
			{	
				alert("��ŵ�Ѽ�����ʼ�ձ��������������!");
				return;
			}
		
		}
		//�ж�������������ʽ��ʱ�򣬲��������õ�������Ҫ������ʽ
		var sVouchType = getItemValue(0,getRow(),"VouchType");
		var sVouchClass = getItemValue(0,getRow(),"VouchClass");
		var sVouchFlag = getItemValue(0,getRow(),"VouchFlag");
		if(sVouchFlag == "1") //010������������ʽ
		{
		    if(sVouchType == "005") //005���õ���
		    {
		        alert(getBusinessMessage('551'));//������������ʽʱ����Ҫ������ʽ���������õ�����
		        return false;
		    }		    
		}
		
		//���ַ��ʽ�Э��� 2009-11-20alert("@@@@@@"+"<%=sBusinessType%>");  	
		if(sBusinessType=="1110020" || sBusinessType=="1140020" )
		{
			var sThirdParty1  = getItemValue(0,getRow(),"ThirdParty1");
			
			if(typeof(sThirdParty1) == "undifined" || sThirdParty1 == "")
			{
				if(confirm("�Ƿ���Ҫ�����ʽ�Э���?"))
				{
					getASObject(0,0,"ThirdParty1").focus();
					return false;
				}
			}
		}
		
		//���гжһ�Ʊ ������ܴ���ó�ױ�����ͬ�����֤
		if(sBusinessType == "2010"){
			var dTradeSum = getItemValue(0,getRow(),"TradeSum");
			if(dBusinessSum>dTradeSum){
				alert("������ܴ���ó�ױ�����ͬ���");
				return false;
			}
			var sCycleFlag = getItemValue(0,getRow(),"CycleFlag");
			var sTermMonth = getItemValue(0,getRow(),"TermMonth");
			if(sCycleFlag == "2" && sTermMonth > 6){
				alert("�˱�ҵ�񲻿�ѭ�������޲��ܴ���6���£�");
				return false;
			} 	
		}
		//���������ʽ����������ޱ���Ϊ12�������� lpzhang 2009-12-30
		if(sBusinessType == "1010020")
		{
			var dTermMonth = getItemValue(0,getRow(),"TermMonth");
			var dTermDay = getItemValue(0,getRow(),"TermDay");
			if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			{
				dTermMonth = dTermMonth+1;
			}
			/*if(dTermMonth<=12)
			{
				alert("���������ʽ�������ޱ�����12�������ϣ�");
				return false;
			}*/
		}
		//���������ʽ����������ޱ���Ϊ12�������� lpzhang 2010-1-5 
		if(sBusinessType == "1010010")
		{
			var dTermMonth = getItemValue(0,getRow(),"TermMonth");
			var dTermDay = getItemValue(0,getRow(),"TermDay");
			if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			{
				dTermMonth = dTermMonth+1;
			}
			/*if(dTermMonth>12)
			{
				alert("���������ʽ�������ޱ�����12�������£�");
				return false;
			}*/
		}
		
		if(sBusinessType == "1140110" && "<%=sObjectType%>" == "BusinessContract" ){
			var sContextInfo = getItemValue(0,getRow(),"ContextInfo");
			var sPaySource = getItemValue(0,getRow(),"PaySource");	
			if((typeof(sContextInfo) == "undefined" || sContextInfo == "") && (typeof(sPaySource) == "undefined" || sPaySource == "")){
				alert("�˱��˱�����дһ����");
				return false;
			}		
		}
		//������ְ��Ա��������Ƿ��Ǳ���Ա����������Ǳ���Ա���Ͳ���ѡ��Ա�����Ѵ���
		if(sBusinessType == "1110190"){
			var  sFlag1 = getItemValue(0,getRow(),"Flag1");
			if("020" == sFlag1){
				sReturn = RunMethod("BusinessManage","SelectStaff","<%=sCustomerID%>");
				if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "2"){
					alert("�ÿͻ����Ǳ���Ա��������ѡ��Ա�����Ѵ��");
					setItemValue(0,getRow(),"Flag1","");
					getASObject(0,0,"Flag1").focus();
					return false;
				}
			}
		}
		
		if(sBusinessType.indexOf("1110") == 0 || sBusinessType.indexOf("1140") == 0 ){
			sICType = getItemValue(0,getRow(),"ICType");
			sPayCyc = getItemValue(0,getRow(),"PayCyc");
			sCorPusPayMethod = getItemValue(0,getRow(),"CorPusPayMethod");
			sPaySource = getItemValue(0,getRow(),"PaySource");
			if((sICType == "060" || sPayCyc == "060" || sCorPusPayMethod == "080") && (typeof(sPaySource) == "undefined" || sPaySource == "")){
				alert("��ѡ���ˡ���Լ����������Լ�������������Լ�������е�һ��������д����˵����");
				return false;
			}
		}
		//����Ҫ������ʽ��ѡ�񡰵�����˾��֤���ģ����Ƿ��е�����˾����������ѡ���ǡ�
		sVouchCorpFlag =  getItemValue(0,getRow(),"VouchCorpFlag");
		if(sVouchType.indexOf("01030") == 0 && sVouchCorpFlag!='1' && sBusinessType.indexOf("3")!=0)
		{
			alert("����Ҫ������ʽ��ѡ�񡰵�����˾��֤�������Ƿ��е�����˾��������ѡ���ǡ���");
			return false;
		}
		//��ѯ��ʾ��ǰ�Ƿ������µ����������Ϣ
		if(sObjectType == "CreditApply") //�������
		{
			//��������
			sBaseRateType =  getItemValue(0,getRow(),"BaseRateType");
			if(sBusinessCurrency!="01" && typeof(sBaseRateType)!="undefined" && sBaseRateType.length!=0)
			{
				sReturn=RunMethod("PublicMethod","GetColValue","count(RateID),RATE_INFO,String@RateID@"+sBaseRateType+"@String@Currency@"+sBusinessCurrency+"@String@EfficientDate@<%=StringFunction.getToday()%>");
				sReturnInfo=sReturn.split("@")
				if(typeof(sReturnInfo[1])=="undefined" || sReturnInfo[1].length==0||sReturnInfo[1] == ""  || sReturnInfo[1] == "null" || sReturnInfo[1]=="0") 
				{	
					alert("��ʾ:��ǰ�������µ��������!");
				}
			}
		}
		/*if("<%=sApplyType%>" =="DependentApply"){
			var dTermMonth = getItemValue(0,getRow(),"TermMonth");
			var dTermDay = getItemValue(0,getRow(),"TermDay");
			if(typeof(dTermMonth) == "undefined" && dTermMonth == ""){
				dTermMonth = 0;
			}
			if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			{
				dTermMonth = dTermMonth+1;
			}
			dBailRatio = 0;
			if(sBusinessType == "2010"){
				dBailRatio = getItemValue(0,getRow(),"BailRatio"); //��ȡ��֤�����
			}
			sReturn=RunMethod("BusinessManage","ControlCreditLine","<%=sBAAgreement%>"+","+sBusinessType+","+dTermMonth+","+dBailRatio+","+dBusinessSum+","+"<%=sObjectNo%>"+","+"<%=sObjectType%>");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				PopPage("/Common/WorkFlow/CheckLineView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
				return;  //�á�return���Ƿ���Ч�Ӿ���ҵ���������
			}
		}*/
		return true;
	}
	
	/*~[Describe=�������Ŷ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditLine()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//����ѡ��ͻ���
			return;
		}
		//���Ҹÿͻ�����Ч����Э��
		sParaString = "CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
		setObjectValue("SelectCLContract",sParaString,"@CreditAggreement@0",0,0,"");
	}
			
	/*~[Describe=ѡ����Ҫ������ʽ;InputParam=��;OutPutParam=��;]~*/
	function selectVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	/*~[Describe=ѡ�񳨿ڲ��ַ�������ʽ;InputParam=��;OutPutParam=��;]~*/
	function selectOpenVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchFlag@0@VouchFlagName@1",0,0,"");		
	}
	
	//��Ѻ����Ѻ����
	function selectVouchType1() {
		ssBusinessType = "<%=sBusinessType%>";
		sParaString = "CodeNo"+","+"VouchType";
		if(ssBusinessType == "1140110")
		setObjectValue("SelectImpawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");
		else 
		setObjectValue("SelectPawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");	
			
	}
	
	//��֤����
	function selectVouchType2() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectAssureCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	//��Ѻ��Ѻ����
	function selectVouchType3() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectPawnImpawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	/*~[Describe=����������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser(sType)
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.OrgID%>";
		if(sType == "OperateUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0,"");		
		if(sType == "ManageUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@ManageUserID@0@ManageUserName@1@ManageOrgID@2@ManageOrgName@3",0,0,"");	
		if(sType == "RecoveryUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@RecoveryUserID@0@RecoveryUserName@1@RecoveryOrgID@2@RecoveryOrgName@3",0,0,"");			
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrg(sType)
	{		
		if(sType == "StatOrg")
			setObjectValue("SelectAllOrg","","@StatOrgID@0@StatOrgName@1",0,0,"");		
	}
	
	/*~[Describe=������������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAssureType()
	{		
		sParaString = "CodeNo"+","+"AssureType";
		setObjectValue("SelectCode",sParaString,"@SafeGuardType@0@SafeGuardTypeName@1",0,0,"");		
	}

	/*~[Describe=ѡ����ҵͶ�򣨹�����ҵ���ͣ�;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"Direction");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"Direction",sIndustryTypeValue);
			setItemValue(0,getRow(),"DirectionName",sIndustryTypeName);				
		}
		//���ݡ�������ҵͶ�򡯶�̬���á��Ƿ���������š��Ƿ�Ϊֻ����ȡֵ
		var sDirection = getItemValue(0,getRow(),"Direction");
		if(sDirection == "F5165" || sDirection == "F5164")
		{
		     setItemDisabled(0,0,"CreditSteel",false);
		    // setItemValue(0,getRow(),"CreditSteel","0"); //��1���ǣ�2����0:��ѡ��		
		}else if(sDirection == "C3110" || sDirection == "C3120" || sDirection == "C3130" || sDirection == "C3140" || sDirection == "C3150")
		{
			 setItemDisabled(0,0,"CreditSteel",true);
			 setItemValue(0,getRow(),"CreditSteel","1");
		}else 
		{
		     setItemDisabled(0,0,"CreditSteel",true);
			 setItemValue(0,getRow(),"CreditSteel","2");
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
	
	/*~[Describe=���ݻ�׼���ʡ����ʸ�����ʽ�����ʸ���ֵ����ִ����(��)����;InputParam=��;OutPutParam=��;]~*/
	function getBusinessRate(sFlag)
	{
		if("<%=sObjectType%>" == "ReinforceContract")
		{
			return;
		}
	
		//ҵ������
		sBusinessType = "<%=sBusinessType%>";
		//��׼����
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//���ʸ�����ʽ
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//���ʸ���ֵ
		dRateFloat = getItemValue(0,getRow(),"RateFloat");
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 )
		{			
			if(sRateFloatType=="0")	//�����ٷֱ�
			{
				if(sFlag == 'Y') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
				if(sFlag == 'M') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else	//1:��������
			{
				if(sFlag == 'Y') //ִ��������
					dBusinessRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				if(sFlag == 'M') //ִ��������
					dBusinessRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
			}
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);
		}else
		{
			setItemValue(0,getRow(),"BusinessRate","");
		}
		if(sBusinessType == "1020010" || sBusinessType == "1020020")
		{
			dBusinessRate = parseFloat(dBaseRate)/1.2;
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);
		}
	}
	
	/*~[Describe=����������Ϣ��ʵ�����ֽ��;InputParam=��;OutPutParam=��;]~*/
	function getDiscountInterest()
	{
		//������
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//Ʊ���ܽ��
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		//��ȡ������Ϣ
		if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBusinessRate) >= 0)
		{
			//������Ϣ��Ʊ���ܽ���������
			dDiscountInterst = roundOff(parseFloat(dBusinessSum) * parseFloat(dBusinessRate)/1000,2);
			//����ʵ����Ʊ���ܽ�������Ϣ
			dDiscountSum = parseFloat(dBusinessSum) - parseFloat(dDiscountInterst);
			setItemValue(0,getRow(),"DiscountInterest",dDiscountInterst);
			setItemValue(0,getRow(),"DiscountSum",dDiscountSum);
		}
	}
	
	/*~[Describe=��������Ӧ��������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function getBargainorInterest()
	{
		//������Ϣ
		dDiscountInterest = getItemValue(0,getRow(),"DiscountInterest");
		//��Ӧ��������Ϣ
		dPurchaserInterest = getItemValue(0,getRow(),"PurchaserInterest");
		//��ȡ����Ӧ��������Ϣ
		if(parseFloat(dDiscountInterest) >= 0 && parseFloat(dPurchaserInterest) >= 0)
		{
			//����Ӧ��������Ϣ��������Ϣ����Ӧ��������Ϣ
			dBargainorInterest = parseFloat(dDiscountInterest) - parseFloat(dPurchaserInterest);
			setItemValue(0,getRow(),"BargainorInterest",dBargainorInterest);
		}
	}
	
	/*~[Describe=������������;InputParam=��;OutPutParam=��;]~*/
	function getOverdueRate()
	{
		//���ڸ�������
		dOverdueRateFloat = getItemValue(0,getRow(),"OverdueRateFloat");
		//ִ��������
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//�������ʣ�ִ������*��1+���ڸ���������
		dOverdueRate = parseFloat(dBusinessRate)*(1+parseFloat(dOverdueRateFloat)/100.00);
		setItemValue(0,getRow(),"OverdueRate",roundOff(dOverdueRate,6));
	}
	
	/*~[Describe=��ռ/Ų������InputParam=��;OutPutParam=��;]~*/
	function getTARate()
	{
		//��ռ/Ų�ø�������
		dTARateFloat = getItemValue(0,getRow(),"TARateFloat");
		//ִ��������
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//��ռ/Ų�����ʣ�ִ������*��1+��ռ/Ų�ø���������
		dTARate = parseFloat(dBusinessRate)*(1+parseFloat(dTARateFloat)/100.00);
		setItemValue(0,getRow(),"TARate",roundOff(dTARate,6));
	}
	
	/*~[Describe=���Ŵ����С����д���ݶ�ռ�ȡ�����;InputParam=��;OutPutParam=��;]~*/	
	function setBusinessProp()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    dTradeSum = getItemValue(0,getRow(),"TradeSum");
        dBusinessProp = roundOff(parseFloat(dBusinessSum)/parseFloat(dTradeSum)*100,2);
		if(dBusinessProp>0)
		{
			 setItemValue(0,getRow(),"BusinessProp",dBusinessProp);
		}
    }
	
	/*~[Describe=�����������ʼ���������;InputParam=��;OutPutParam=��;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //��ȡ������
	    if(parseFloat(dBusinessSum) >= 0)
	    {
			dPdgRatio = getItemValue(0,getRow(),"PdgRatio");//��ȡ�����ѱ���
	    	if(parseFloat(dPdgRatio) >= 0)
	    	{
	    		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");		
	    		sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
	    		if(typeof(sFeeCurrency) == "undefined" || sFeeCurrency == "" ){
		        	sFeeCurrency = "01";
		        }
	        	dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
		    	dPdgRatio = roundOff(dPdgRatio,2);
			    dPdgSum = (parseFloat(dBusinessSum)*dErateRatio)*parseFloat(dPdgRatio)/1000;
			    dPdgSum = roundOff(dPdgSum,2);
			    if(dPdgSum<300 && ("<%=sBusinessType%>" == "2050030" || "<%=sBusinessType%>" == "2050010"))
					dPdgSum = 300.00;	
			    setItemValue(0,getRow(),"PdgSum",dPdgSum);
			}
		}
	}
	
	/*~[Describe=���������Ѽ�����������;InputParam=��;OutPutParam=��;]~*/
	function getPdgRatio()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    sBusinessType = getItemValue(0,getRow(),"BusinessType");
	    //����ҵ�񲻽��з���
	    if(parseFloat(dBusinessSum) >= 0 && sBusinessType.substring(0,4)!="2040" && sBusinessType.substring(0,4)!="2030")
	    {
	        dPdgSum = getItemValue(0,getRow(),"PdgSum");
	        dPdgSum = roundOff(dPdgSum,2);
	        if(parseFloat(dPdgSum) >= 0)
	        {	       
	            dPdgRatio = parseFloat(dPdgSum)/parseFloat(dBusinessSum)*1000;
	            dPdgRatio = roundOff(dPdgRatio,2);
	            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
	        }
	    }
	}
	
	/*~[Describe=���"��"�����Ƿ�Ϸ�;InputParam=��;OutPutParam=��;]~*/
	function getTermDay()
	{
	    dTermDay = getItemValue(0,getRow(),"TermDay");
	    if(parseInt(dTermDay) > 30 )
	    {
	    	if(!(sBusinessType=="2050030") && !(sBusinessType=="2020"))
	        alert("��(��)����С�ڵ���30��");
	    }
	}
	
	/*~[Describe=�����׸��������׸�����;InputParam=��;OutPutParam=��;]~*/
	function getThirdPartyRatio()
	{
	    //dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    sBusinessType = "<%=sBusinessType%>";
	    //ȡ�����ܼ�@jlwu
	    sThirdPartyID2 = getItemValue(0,getRow(),"ThirdPartyID2");
	    dThirdPartyID2 = parseFloat(sThirdPartyID2);
	    sThirdParty = getItemValue(0,getRow(),"ThirdPartyAdd1");
	    dThirdParty = parseFloat(sThirdParty);
	    if(parseFloat(sThirdPartyID2) >= 0)
	    {
	        dThirdParty = roundOff(dThirdParty,2);
	        
	        if(parseFloat(dThirdParty) >= 0)
	        {	     
	            dThirdPartyRatio = parseFloat(dThirdParty)/parseFloat(dThirdPartyID2)*100;
	            dThirdPartyRatio = roundOff(dThirdPartyRatio,2);
	            dThirdPartyRatio+="";
	            setItemValue(0,getRow(),"ThirdPartyZIP1",dThirdPartyRatio);
	            setItemValue(0,getRow(),"ThirdPartyZIP2",100-dThirdPartyRatio);//���Ҵ������
	        }
	    }
	}
	
	/*~[Describe=���ݱ�֤��������㱣֤����;InputParam=��;OutPutParam=��;]~*/
	function getBailSum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //��ȡ������
	    if(parseFloat(dBusinessSum) >= 0)
	    {	
	    	dBailRatio = getItemValue(0,getRow(),"BailRatio"); //��ȡ��֤�����
	        if(parseFloat(dBailRatio) >= 0)
	        {	
	        	dBailRatio = roundOff(dBailRatio,2);	        	
	        	sBusinessType = "<%=sBusinessType%>";
		        sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//��ȡ�������
		        sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//��ȡ��֤�����
		        ddBailSum = 0.00;
		        dERateRatio = 1.00;
		        if(typeof(sBailCurrency) == "undefined" || sBailCurrency == "" ){
		        	sBailCurrency = "01";
		        }
		        if(sBusinessCurrency == sBailCurrency){
		           	dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
		        }
	 			else{
	    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
	            	dBailSum = parseFloat(dBusinessSum*dERateRatio)*parseFloat(dBailRatio)/100;
	            }		        
           		dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	            //���гжһ�Ʊ�������Ա������������Ա���
			    if(sBusinessType == "2010" || sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0)
			    {	
			    	setItemValue(0,getRow(),"ExposureSum",roundOff((dBusinessSum-dBailSum/dERateRatio),2));
			    }
	        }
	    }	  
	}
	
	/*~[Describe=���ݱ�֤������㱣֤�����;InputParam=��;OutPutParam=��;]~*/
	function getBailRatio()
	{
	    /*Ĭ���뵱ǰ����һ��
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
		*/
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailSum = getItemValue(0,getRow(),"BailSum");
	        if(parseFloat(dBailSum) >= 0)
	        {	        
				dBailSum = roundOff(dBailSum,2);
	            dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;
	            dBailRatio = roundOff(dBailRatio,2);
	            setItemValue(0,getRow(),"BailRatio",dBailRatio);
				if (dBailRatio=="100") {
					setItemValue(0,getRow(),"VouchType",'005');
					setItemValue(0,getRow(),"VouchTypeName",'����');
				}
	        }
	    }
	}
	
	/*--------------------- add by zwhu -----------------*/
	
	/*~[Describe=�����������ʼ���������;InputParam=��;OutPutParam=��;]~*/
	function getpdgsum1()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //��ȡ������
	    if(parseFloat(dBusinessSum) >= 0)
	    {
			dPdgRatio = getItemValue(0,getRow(),"PdgRatio");//��ȡ�����ѱ���
	    	if(parseFloat(dPdgRatio) >= 0)
	    	{
	    		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");		
	    		sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
	    		if(typeof(sFeeCurrency) == "undefined" || sFeeCurrency == "" ){
		        	sFeeCurrency = "01";
		        }
	        	dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
		    	dPdgRatio = roundOff(dPdgRatio,2);
			    dPdgSum = (parseFloat(dBusinessSum)*dErateRatio)*parseFloat(dPdgRatio)/1000;
			    dPdgSum = roundOff(dPdgSum,2);
			    if(dPdgSum<300 && ("<%=sBusinessType%>" == "2050030" || "<%=sBusinessType%>" == "2050010"))
					dPdgSum = 300.00;	
			    setItemValue(0,getRow(),"PdgSum",dPdgSum);
			}
		}
	}
	
	/*~[Describe=���������Ѽ�����������;InputParam=��;OutPutParam=��;]~*/
	function getPdgRatio1()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {	
	    	if("<%=sBusinessType%>" == "2050020")//��������֤
	    	{	
	    		dPdgSum = getItemValue(0,getRow(),"PdgSum");
	    		if(parseFloat(dPdgSum) >= 0)
		        {	
		        	dPdgSum = roundOff(dPdgSum,2);
		    		sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
			    	sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
			    	dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
			    	dPdgRatio = parseFloat(dPdgSum)/(parseFloat(dBusinessSum)*dERateRatio)*1000
			    	dPdgRatio = roundOff(dPdgRatio,2);
			    	setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
		    	}
	    	}
	    	else
	    	{
		        dPdgSum = getItemValue(0,getRow(),"PdgSum");
		        if(parseFloat(dPdgSum) >= 0)
		        {	     
		        	dPdgSum = roundOff(dPdgSum,2);  
		            dPdgRatio = parseFloat(dPdgSum)/parseFloat(dBusinessSum)*1000;
		            dPdgRatio = roundOff(dPdgRatio,2);
		            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
		        }
	        }
	    }
	}
	
	/*~[Describe=���ݱ�֤��������㱣֤����;InputParam=��;OutPutParam=��;]~*/
	function getBailSum1()
	{	
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //��ȡ������
	    if(parseFloat(dBusinessSum) >= 0)
	    {	
	    	dBailRatio = getItemValue(0,getRow(),"BailRatio"); //��ȡ��֤�����
	        if(parseFloat(dBailRatio) >= 0)
	        {	
	        	dBailRatio = roundOff(dBailRatio,2);	        	
	        	sBusinessType = "<%=sBusinessType%>";
		        sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//��ȡ�������
		        sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//��ȡ��֤�����
		        ddBailSum = 0.00;
		        dERateRatio = 1.00;
		        if(typeof(sBailCurrency) == "undefined" || sBailCurrency == "" ){
		        	sBailCurrency = "01";
		        }
		        if(sBusinessCurrency == sBailCurrency){
		           	dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
		        }
	 			else{
	    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
	            	dBailSum = parseFloat(dBusinessSum*dERateRatio)*parseFloat(dBailRatio)/100;
	            }		        
           		dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	            //���гжһ�Ʊ�������Ա������������Ա���
			    if(sBusinessType == "2010" || sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0)
			    {	
			    	setItemValue(0,getRow(),"ExposureSum",roundOff((dBusinessSum-dBailSum/dERateRatio),2));
			    }
	        }
	    }	    
	}
	
	
	/*~[Describe=���͹�����ϵͳ��ȡ�����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function SendGDTrade6020()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");//������ˮ��
		sAFALoanFlag = getItemValue(0,getRow(),"AFALoanFlag"); //�Ƿ���ϴ���
		sCommercialNo = getItemValue(0,getRow(),"CommercialNo"); //�̴������
		sAccumulationNo = getItemValue(0,getRow(),"AccumulationNo"); //ί�������
		sPhaseNo = "";
		//ȡ�ñ������Ӧ�����̽׶κ�
		sReturn = RunMethod("PublicMethod","GetColValue","PhaseNo,FLOW_OBJECT,String@ObjectType@CreditApply@String@ObjectNO@"+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			sReturnValue = sReturn.split('@');
			sPhaseNo = sReturnValue[1];
		}
		if(sPhaseNo!="0010" && sPhaseNo!="3000")
		{
			alert("��������׶β��ܷ��ͣ�");
			return;
		}
		sTradeType = "6020";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+"CreditApply"+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000")
		{
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			return;
		}else
		{
			alert("���͸����ɹ���"+sReturn[1]);
			sReturn = RunMethod("BusinessManage","UpdateTrade6020",sObjectNo+","+sCommercialNo+","+sAccumulationNo);
			if(typeof(sReturn)!="undefined" && sReturn.length!=0)
			{
				alert(sReturn);
			}
			reloadSelf();
		}
		return;
	}
	
		
	/*~[Describe=���͹�����ϵͳ��ȡ��ر����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function SendGDTrade6030()
	{
		//alert("���");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");//������ˮ��
		sAFALoanFlag = getItemValue(0,getRow(),"AFALoanFlag"); //�Ƿ���ϴ���
		sCommercialNo = getItemValue(0,getRow(),"CommercialNo"); //�̴������
		sAccumulationNo = getItemValue(0,getRow(),"AccumulationNo"); //ί�������
		sChangType = getItemValue(0,getRow(),"ChangType"); //�������
		sPhaseNo = "";
		//ȡ�ñ������Ӧ�����̽׶κ�
		sReturn = RunMethod("PublicMethod","GetColValue","PhaseNo,FLOW_OBJECT,String@ObjectType@CreditApply@String@ObjectNO@"+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			sReturnValue = sReturn.split('@');
			sPhaseNo = sReturnValue[1];
		}
		if(sPhaseNo!="0010" && sPhaseNo!="3000")
		{
			alert("��������׶β��ܷ��ͣ�");
			return;
		}
		sTradeType = "6030";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+"CreditApply"+","+sTradeType+","+sChangType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000")
		{
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			return;
		}else
		{
			alert("���͸����ɹ���"+sReturn[1]);
			sReturn = RunMethod("BusinessManage","UpdateTrade6030",sObjectNo+","+sCommercialNo+","+sAccumulationNo);
			if(typeof(sReturn)!="undefined" && sReturn.length!=0)
			{
				alert(sReturn);
			}
			reloadSelf();
		}
		return;
	}

	
	/*~[Describe=���ݱ�֤������㱣֤�����;InputParam=��;OutPutParam=��;]~*/
	function getBailRatio1()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailSum = getItemValue(0,getRow(),"BailSum");
	        if(parseFloat(dBailSum) >= 0)
	        {	 
	        	dBailSum = roundOff(dBailSum,2);	        	
	        	dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;	        	
	        	sBusinessType = "<%=sBusinessType%>" ;
	            if(sBusinessType == "2050010" || sBusinessType == "2050020" || sBusinessType == "2050040" || sBusinessType == "1110070" 
	        		|| sBusinessType == "2010" || sBusinessType == "2020" || sBusinessType.indexOf("2080") == 0 
	        		|| sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0 
	        		|| sBusinessType.indexOf("3030") == 0 || sBusinessType.indexOf("2090") == 0)
	        	{
	        		dBailRatio = roundOff(dBailSum,2);
	        		setItemValue(0,getRow(),"BailRatio",dBailRatio);
	        	}
	        	else
	        	{
	        		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//��ȡ�������
		    		sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//��ȡ��֤�����
		    		dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;
		    		if(sBusinessCurrency != sBailCurrency)
		    		{
		    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
		    			dBailRatio = parseFloat(dBailSum)/(parseFloat(dBusinessSum)*dERateRatio)*100;
		    		}
		    		 dBailRatio = roundOff(dBailRatio,2);
		    		 setItemValue(0,getRow(),"BailRatio",dBailRatio);
				}
				if (dBailRatio=="100") {
					setItemValue(0,getRow(),"VouchType",'005');
					setItemValue(0,getRow(),"VouchTypeName",'����');
				}
				//���гжһ�Ʊ�������Ա������������Ա���
			    if(sBusinessType == "2010" || sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0)
			    {	
			    	setItemValue(0,getRow(),"ExposureSum",roundOff((dBusinessSum-dBailSum/dERateRatio),2));
			    }
	        }
	    }
	}
	
	/*~[Describe=�������װ����������֤������ʵ�����Ž��;InputParam=��;OutPutParam=��;]~*/
		function getPracticeSum()
		  {
		    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");//��ȡ����ʱ������֤���
		    dFlowover = getItemValue(0,getRow(),"Flowover");//��ȡ����ʱ����װ����
		    var PracticeSum1=dBusinessSum *(1+dFlowover/100);
		    setItemValue(0,getRow(),"PracticeSum",roundOff(PracticeSum1,2));
		   
		   }
	
	
	/*~[Describe=��ʼ������;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		sOccurType = "<%=sOccurType%>";
		sObjectType = "<%=sObjectType%>";
		sBusinessType = "<%=sBusinessType%>";

		if(sBusinessType == "1100010" && sObjectType == "CreditApply" )
		{
			setItemValue(0,getRow(),"BusinessSum",0);
		}
		if(sOccurType == "015" && sObjectType == "CreditApply") //չ��ҵ��
		{
			setItemValue(0,getRow(),"TotalSum","<%=DataConvert.toMoney(dOldBusinessSum)%>");
			setItemValue(0,getRow(),"BusinessSum","<%=DataConvert.toMoney(dOldBalance)%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sOldBusinessCurrency%>");
			setItemValue(0,getRow(),"TermDate1","<%=sOldMaturity%>");
			setItemValue(0,getRow(),"OldBusinessRate","<%=dOldBusinessRate%>");
			setItemValue(0,getRow(),"ExtendTimes","<%=iExtendTimes%>");
		}
			//setItemValue(0,getRow(),"BusinessCurrency","01");
		if(sOccurType == "020") //���»���
		{
			setItemValue(0,getRow(),"LNGOTimes","<%=iLNGOTimes%>");
		}
		if(sOccurType == "060" ||sOccurType == "065") //���ɽ���||��������
		{
			setItemValue(0,getRow(),"GOLNTimes","<%=iGOLNTimes%>");
		}
		if(sOccurType == "030") //ծ������
		{
			setItemValue(0,getRow(),"DRTimes","<%=iDRTimes%>");
		}
		if("<%=sApplyType%>"== "DependentApply" && "<%=sCustomerType%>".substr(0,2)=="03"){//���˶������ҵ��
			setItemValue(0,getRow(),"CycleFlag",2);
		}
		
		//add by zrli ���ӳ�ʼ���������Ա
		if(sObjectType == "ReinforceContract"){
			sManageUserID = getItemValue(0,getRow(),"ManageUserID");
			if(typeof(sManageUserID) == "undefined" || sManageUserID == "")
			{
				setItemValue(0,getRow(),"ManageUserID","<%=CurUser.UserID%>");
				setItemValue(0,getRow(),"ManageUserName","<%=CurUser.UserName%>");
			}
			sOperateUserID = getItemValue(0,getRow(),"OperateUserID");
			if(typeof(sOperateUserID) == "undefined" || sOperateUserID == "")
			{
				setItemValue(0,getRow(),"OperateUserID","<%=CurUser.UserID%>");
				setItemValue(0,getRow(),"OperateUserName","<%=CurUser.UserName%>");
			}
		}
		
		//add by zwhu ���ǳ�ʼ���ſ����
		if(sBusinessType == "2010" || sBusinessType == "2070" || sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0
			|| sBusinessType.indexOf("2050") == 0 || sBusinessType.indexOf("1020") == 0 || sBusinessType.indexOf("1080") == 0 
			|| sBusinessType == "3010" || sBusinessType == "3040" || sBusinessType == "3060"){
			setItemValue(0,getRow(),"PutOutOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"PutOutOrgName","<%=CurOrg.OrgName%>");
		}
	}
	//�����������
	function CreditColumnCheck(sColumnName,sCheckType)
	{
		sCheckWord = getItemValue(0,getRow(),sColumnName);
		if(typeof(sCheckWord) != "undefined" && sCheckWord != "")	
		{
			if(!CheckTypeScript(sCheckWord,sCheckType))	
			{
				alert("�������Ͳ���ȷ�����������룡");
				setItemValue(0,getRow(),sColumnName,"");
				return false;
			}
			return true;
		}
	}
	//����Ƿ��Ǹ�����
	function isDigit(s)
	{
		var patrn=/^(-?\d+)(\.\d+)?$/;
		if (!patrn.exec(s)) 
		{
			alert(s+"���ݸ�ʽ����");
			return false;
		}
		return true;
	}
	//���Ҹÿͻ��ĵ���Э��
	function VouchAgreement()
	{
		sParaString = "";//
		sReturn = selectObjectValue("SelectVouchAgreement",sParaString,"",0,0,"");
		if( sReturn=="_CLEAR_" ){
			setItemValue(0,0,"VouchAggreement","");
			setItemValue(0,0,"VouchCorpName","");
			return;
		}else if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined"){
		 	return;
		}else{
			sReturn= sReturn.split('@');
			sSerialNo = sReturn[0];
			sCustomerName = sReturn[1];
			sPutOutDate = sReturn[2];
			sMaturity = sReturn[3];
			if("<%=StringFunction.getToday()%>" < sPutOutDate || sMaturity < "<%=StringFunction.getToday()%>")
			{
				alert("����������Э����Ч���⣬��������ñ�Э�飡");
				return;
			}
			setItemValue(0,0,"VouchAggreement",sSerialNo);
			setItemValue(0,0,"VouchCorpName",sCustomerName);
		}
	}
	
	//���ҹ��̻�е������Э��
	function DealerAgreement()
	{
		sParaString = "";		
	    sReturn = setObjectValue("SelectDealerAgreement",sParaString,"",0,0,"");
	    if(sReturn == sReturn=="_CLEAR_" ){
	    	setItemValue(0,0,"ConstructContractNo","");
			setItemValue(0,0,"TradeName","");
			setItemValue(0,0,"CropName","");
			return;
	    }
	    else if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined"){
	    	return;
	    }else{
			sReturn= sReturn.split('@');
			sSerialNo = sReturn[0];
			sTradeName = sReturn[1];
			sCustomerName = sReturn[2];
			sPutOutDate = sReturn[3];
			sMaturity = sReturn[4];
			if("<%=StringFunction.getToday()%>" < sPutOutDate || sMaturity < "<%=StringFunction.getToday()%>")
			{
				//add by xhyong ���ӳ�ʼ���������Ա���ݲ��ǲ���Ҫ����
				if(sObjectType != "ReinforceContract"){
					alert("����������Э����Ч���⣬��������ñ�Э�飡");
					return;
				}
			}
			setItemValue(0,0,"ConstructContractNo",sSerialNo);
			setItemValue(0,0,"TradeName",sTradeName);
			setItemValue(0,0,"CropName",sCustomerName);
		}
	}
	//���ҿ�����¥���Э��
	function selectProjectCoop()
	{
		sParaString = "";		
	    sReturn = setObjectValue("selectProjectCoop",sParaString,"",0,0,"");
	    if(sReturn=="_CLEAR_" ){
	    	setItemValue(0,0,"BuildAgreement","");
			setItemValue(0,0,"ThirdParty3","");
	    }else if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined"){
	    	return;
	    }else{
	    	sReturn= sReturn.split('@');
			sSerialNo = sReturn[0];
			sCustomerName = sReturn[1];
			sPutOutDate = sReturn[2];
			sMaturity = sReturn[3];
			if("<%=StringFunction.getToday()%>" < sPutOutDate || sMaturity < "<%=StringFunction.getToday()%>")
			{
				alert("����������Э����Ч���⣬��������ñ�Э�飡");
				return;
			}
			setItemValue(0,0,"BuildAgreement",sSerialNo);
			setItemValue(0,0,"ThirdParty3",sCustomerName);
		}
	}
	
	//ȡ�û�׼������
	function selectBaseRateType(){
		sCurDate = "<%=StringFunction.getToday()%>"
		sParaString = "CurDate"+","+sCurDate;
	    sReturn = setObjectValue("selectBaseRateType",sParaString,"@BaseRateType@0@BaseRate@1",0,0,"");
		getBusinessRate("M");
	}
	//�Զ���ȡ�������� 2009-12-24 
	function getBaseRateType(){
		 var sOccurType = "<%=sOccurType%>";
		 dTermDay = getItemValue(0,getRow(),"TermDay");
		 dTermMonth = getItemValue(0,getRow(),"TermMonth");
		 sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//����
		 sBaseRateID = "";
		 if(typeof(sBusinessCurrency)=="undefined" || sBusinessCurrency.length==0)
		 {
		 	alert("����ѡ�����!");
		 	return ;
		 }
		 if(sBusinessCurrency=="01")//�����
		 {
			 if(sOccurType == "015"){
			 	if(typeof(dTermDay) == "undefined" && dTermDay == "" ){
			 		dTermDay = 0;
			 	}
			 	dTermDay = dTermDay + <%=dOldTermDay%>;
			 	if(dTermDay/30 >1){
			 		dTermMonth = dTermMonth + 2;
			 	}
			 	else if(dTermDay>0){
			 		dTermMonth = dTermMonth + 1;
			 	}
			 	dTermMonth = dTermMonth + <%=dOldTermMonth%>;
			 }
			 else if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			 {
			 	dTermMonth = dTermMonth+1; 
			 }
			 if(dTermMonth <= 6){
			 	sBaseRateID = "10010";
			 }else if(dTermMonth > 6 && dTermMonth <= 12){
			 	sBaseRateID = "10020";
			 }else if(dTermMonth > 12 && dTermMonth <= 36){
			 	sBaseRateID = "10040";
			 }else if(dTermMonth > 36 && dTermMonth <= 60){
			 	sBaseRateID = "10050";
			 }else{
			 	sBaseRateID = "10030";
			 }
		}else{//���
			 if(dTermDay < 7 && dTermMonth==0){
			 	sBaseRateID = "20010";//��ҹ
			 }else if(dTermDay < 14 && dTermMonth==0){
			 	sBaseRateID = "20020";//һ��
			 }else if(dTermMonth==0 ){
			 	sBaseRateID = "20030";//����
			 }else if(dTermMonth <3){
			 	sBaseRateID = "20040";//һ����
			 }else if(dTermMonth <6){
			 	sBaseRateID = "20050";//������
			 }else if(dTermMonth <12){
			 	sBaseRateID = "20060";//������
			 }else{
			 	sBaseRateID = "20070";//ʮ������
			 }
		}
		 setItemValue(0,0,"BaseRateType",sBaseRateID);
		 
		// sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
		sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    } 	    
		getBusinessRate("M");
	}
	
	//�Զ���ȡ�������������� 2011/08/17 
	function getAFBaseRateType(){
		 dTermDay = getItemValue(0,getRow(),"TermDay");
		 dTermMonth = getItemValue(0,getRow(),"TermMonth");
		 sBaseRateID = "";
		 if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
		 {
		 	dTermMonth = dTermMonth+1; 
		 }
		 if(dTermMonth <= 60){
		 	sBaseRateID = "10010";
		 }else{
		 	sBaseRateID = "10020";
		 }
		 setItemValue(0,0,"BaseRateType",sBaseRateID);
		 
		 sReturn = RunMethod("BusinessManage","getAFBaseRate",sBaseRateID);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    }  
		getBusinessRate("M");
	}
	//��֤����Ӫ����ҵ��Ѻ����ҵ���еĳ�����
	function verifyRentRatio(){
		dOperateYears = getItemValue(0,getRow(),"OperateYears");
		dRentRatio = getItemValue(0,getRow(),"RentRatio");
		if(dOperateYears >= 2 && dRentRatio<80){
			alert("����������ڵ���80%");
			setItemValue(0,0,"RentRatio","");
		}else if(dOperateYears < 2 && dRentRatio<70){
			alert("����������ڵ���70%");
			setItemValue(0,0,"RentRatio","");	
		}
	}
	//��֤������һ�֡�������������ҵ���еĴ��������
	function getBusinessProp(){
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//��ȡ�������
		dThirdPartyID2 = getItemValue(0,getRow(),"ThirdPartyID2");
	    dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+",01,''");
	    dBusinessProp = (dBusinessSum*dERateRatio/dThirdPartyID2)*100
		dBusinessProp = roundOff(dBusinessProp,2);
		setItemValue(0,getRow(),"BusinessProp",dBusinessProp);
	}
	
	//�Ƿ��е�����˾����������Э�����
	function setVouchAggreement(){
		sVouchCorpFlag = getItemValue(0,getRow(),"VouchCorpFlag");
		if(sVouchCorpFlag == "2"){
			setItemValue(0,getRow(),"VouchAggreement","");
			setItemValue(0,getRow(),"VouchCorpName","");
		}
	}
	
	/*~~~~~~~~~~~~~~~~~~ѡ����ũ�������~~~~~~~~~~~~~~~~~~~*/
	function selectInvolveAgriculture(){
		sCustomerType = "<%=sCustomerType%>";
		if(sCustomerType.substring(0,3) == "03"){
			sParaString = "CodeNo"+","+"AgriLoanClassify1"+","+"ItemAttribute"+","+"1";
			setObjectValue("SelectInvolveAgriculture",sParaString,"@AgriLoanClassify@0@AgriLoanClassifyName@1",0,0,"");
		}else{
			sParaString = "CodeNo"+","+"AgriLoanClassify1"+","+"ItemAttribute"+","+"2";
			setObjectValue("SelectInvolveAgriculture",sParaString,"@AgriLoanClassify@0@AgriLoanClassifyName@1",0,0,"");
		}
	}
	//��ͬ�׶Σ����»�ȡ��׼���� added by zrli 2010-10-20
	function getNewBaseRate(){
		sBaseRateID = getItemValue(0,getRow(),"BaseRateType");
		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//����
		if("2110020" == "<%=sBusinessType%>"){//����Ǵ����������
			sReturn = RunMethod("BusinessManage","getAFBaseRate",sBaseRateID);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    }
		}else{
			//sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
			sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				setItemValue(0,0,"BaseRate",sReturn);
			} 	
		}    
		getBusinessRate("M");
		getTARate();
		getOverdueRate();
	}
	
	function setRequiredAndUpdate(BailRatio,VouchFlagName)
	{
		getBailSum();
		sBailRatio = getItemValue(0,getRow(),BailRatio);
		if(sBailRatio == 100)
		{
	 	  	setItemRequired(0,0,VouchFlagName,false);	 
		    
		}else
		{
			setItemRequired(0,0,VouchFlagName,true);	 
		}
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
