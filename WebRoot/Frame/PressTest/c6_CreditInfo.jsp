<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jytian  2004/12/12
		Tester:
		Content: ҵ�������Ϣ
		Input Param:
				 ObjectType����������
				 ObjectNo��������
		Output param:
		History Log: zywei 2005/08/03 �ؼ�ҳ��
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
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "";
	//�����������ѯ��������ʾģ�����ơ��������͡��������͡��ݴ��־
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "";
	//�������������ҵ����֡�����ҵ������
	String sOldBusinessCurrency = "",sOldMaturity = "";
	//�������������ҵ�������ҵ�����ʡ�����ҵ�����
	double dOldBusinessSum = 0.0,dOldBusinessRate = 0.0,dOldBalance = 0.0;
	//���������չ�ڴ��������»��ɴ��������ɽ��´�����ծ���������
	int iExtendTimes = 0,iLNGOTimes = 0,iGOLNTimes = 0,iDRTimes = 0;
	//�����������ѯ�����
	ASResultSet rs = null;
	
	//���ҳ�����	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//���ݶ������ͺͶ����Ŵ����̶�����в�ѯ����Ӧ����������
	sSql = " select ApplyType from FLOW_OBJECT where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
	sApplyType = Sqlca.getString(sSql);	
	if(sApplyType == null) sApplyType = "";
	
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
	sSql = "select CustomerID,BusinessType,OccurType,TempSaveFlag from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
		sOccurType = DataConvert.toString(rs.getString("OccurType"));
		sTempSaveFlag = DataConvert.toString(rs.getString("TempSaveFlag"));
		
		//����ֵת���ɿ��ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sTempSaveFlag == null) sTempSaveFlag = "";
	}
	rs.getStatement().close(); 
		
	//���ҵ��Ʒ��Ϊ��,����ʾ���������ʽ����
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//��ҵ�����Ϊ����ʱ��ִ������ҵ���߼�
	if(sObjectType.equals("CreditApply"))
	{
		//���ݷ������ͣ�ϵͳ�ݴ���չ�ڡ����»��ɡ����ɽ��¡�ծ�������������ͣ���ȡ��Ӧ�Ĺ���ҵ����Ϣ
		if(sOccurType.equals("015") || sOccurType.equals("020") || sOccurType.equals("060")) //չ�ڡ����»��ɡ����ɽ���
		{
			//��ȡչ�ں�ͬ��/��ݣ��Ľ������ʡ����֡������ա�չ�ڴ��������»��ɴ��������ɽ��´�����ծ�������������Ϣ
			//sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //���պ�ͬ
			sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,RenewTimes as LNGOTimes,GOLNTimes,ReorgTimes as DRTimes "+ //���ս��
					//" from BUSINESS_CONTRACT "+ //���պ�ͬ
					" from BUSINESS_DUEBILL "+ //���ս��
					" where SerialNo = (select ObjectNo "+
					" from "+sRelativeTable+" "+
					//" where ObjectType = 'BusinessContract' "+ //���պ�ͬ
					" where ObjectType = 'BusinessDueBill' "+ //���ս��
					" and SerialNo = '"+sObjectNo+"') ";
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
		}else if(sOccurType.equals("030")) //ծ������
		{
			//��ȡ�ʲ����鷽�����
			sSql = 	" select ObjectNo from "+sRelativeTable+" "+
					" where ObjectType = 'CapitalReform' "+
					" and SerialNo = '"+sObjectNo+"' ";
			String sCapitalReformNo = Sqlca.getString(sSql);
			
			//��ȡ�����ͬ�Ľ�ծ�������ͬ�����ʡ����֡������ա�չ�ڴ��������»��ɴ��������ɽ��´�����ծ�������������Ϣ
			sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //���պ�ͬ
					" from BUSINESS_CONTRACT "+ //���պ�ͬ
					" where SerialNo = (select ObjectNo "+
					" from APPLY_RELATIVE "+
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
		}
		//��Щ����ҵ����Ҫ�ٽ��й���һ�Σ�չ��/���»���/���ɽ���/ծ�����飩�������Ҫ��ԭ���Ĵ���������һ��
		iExtendTimes = iExtendTimes + 1;
		iLNGOTimes = iLNGOTimes + 1;
		iGOLNTimes = iExtendTimes + 1;
		iDRTimes = iDRTimes + 1;
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
	
	//�����ֶεĿɼ�����	
	if(sOccurType.equals("020")) //���»���ʱ��ʾ���»��ɴ����ֶ�
		doTemp.setVisible("LNGOTimes",true);
	if(sOccurType.equals("060")) //���ɽ�����ʾ���ɽ��´����ֶ�
		doTemp.setVisible("GOLNTimes",true);
	if(sOccurType.equals("030")) //ծ��������ʾծ����������ֶ�
		doTemp.setVisible("DRTimes",true);	
		
	//�������ʸ�ʽ,����С����6λ
	doTemp.setCheckFormat("BusinessRate","16");
	
	//�����������ͬ��������ʾҪ�صĲ�ͬ����
	if(sApplyType.equals("IndependentApply"))
		doTemp.setVisible("CreditAggreement",false);
%>
	<%@include file="CheckBusinessDataValidity.jsp"%>	
<%
	//����DataWindow����	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "0"; 
	
	//���ñ���ʱ�������̶����Ķ���
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateCLInfo("+sObjectType+",#SerialNo,#BusinessSum,#BusinessCurrency)");
				
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//��ȡУ��������Ϣ
	double dCheckBusinessSum = 0.0,dCheckBaseRate = 0.0,dCheckRateFloat = 0.0,dCheckBusinessRate = 0.0;
	double dCheckPdgRatio = 0.0,dCheckPdgSum = 0.0,dCheckBailSum = 0.0,dCheckBailRatio = 0.0;
	String sCheckRateFloatType = "";
	int iCheckTermYear = 0,iCheckTermMonth = 0,iCheckTermDay = 0;
	//����������Ϊ�����������ʱ����ȡ���������������Ӧ��������Ϣ
	if(sObjectType.equals("ApproveApply"))
	{
		sSql = 	" select BA.BusinessSum,BA.BaseRate,BA.RateFloatType,BA.RateFloat, "+
				" BA.BusinessRate,BA.PdgRatio,BA.PdgSum,BA.BailSum,BA.BailRatio, "+
				" BA.TermYear,BA.TermMonth,BA.TermDay "+
				" from BUSINESS_APPLY BA"+
				" where exists (select BAP.RelativeSerialNo from BUSINESS_APPROVE BAP "+
				" where BAP.SerialNo = '"+sObjectNo+"' "+
				" and BAP.RelativeSerialNo = BA.SerialNo) ";
	}
	//����������Ϊ��ͬʱ����ȡ��ͬ����Ӧ��������Ϣ
	if(sObjectType.equals("BusinessContract"))
	{
		sSql = 	" select BA.BusinessSum,BA.BaseRate,BA.RateFloatType,BA.RateFloat, "+
				" BA.BusinessRate,BA.PdgRatio,BA.PdgSum,BA.BailSum,BA.BailRatio, "+
				" BA.TermYear,BA.TermMonth,BA.TermDay "+
				" from BUSINESS_APPROVE BA"+
				" where exists (select BC.RelativeSerialNo from BUSINESS_CONTRACT BC "+
				" where BC.SerialNo = '"+sObjectNo+"' "+
				" and BC.RelativeSerialNo = BA.SerialNo) ";
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
		if (!ValidityCheck()) return;									
		if(vI_all("myiframe0"))
		{
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
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");			
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
		//ҵ��Ʒ��
		sBusinessType = "<%=sBusinessType%>";
				
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
			
			//������
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//��֤����
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//�����ѽ��
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
			
			//У���������뱣֤����֮���ҵ���߼���ϵ
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0)
			{
				if(parseFloat(dBailSum) > parseFloat(dBusinessSum))
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
						alert(getBusinessMessage('568'));//��֤����(Ԫ)����С�ڻ�������볨���ܶ��(Ԫ)��
						return false;
					}else
					{
						alert(getBusinessMessage('562'));//��֤����(Ԫ)����С�ڻ����������(Ԫ)��
						return false;
					}
				}
			}
			
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dPdgSum) >= 0)
			{
				if(parseFloat(dPdgSum) > parseFloat(dBusinessSum))
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
					&& sBusinessType != '2110010' && sBusinessType != '1110140' 
					&& sBusinessType != '1110150') //��Ϊ���˾�Ӫ������˷��ݴ��������Ŀ��
					//�������Ѵ�����������̡��������������̡�����ס������������ҵ��ѧ���������ѧ����
					{
						alert(getBusinessMessage('563'));//�����ѽ��(Ԫ)����С�ڻ����������(Ԫ)��
						return false;
					}
				}
			}				 		
		}
		
		if(sObjectType == "ApproveApply")//���������������
		{
			//������
			dCheckBusinessSum = <%=dCheckBusinessSum%>;
			//��׼���
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			if(parseFloat(dCheckBusinessSum) >= 0 && parseFloat(dBusinessSum) >= 0)
			{
				if(dBusinessSum > dCheckBusinessSum)
				{
					if(sOccurType == "015") //չ��ҵ��
					{
						alert(getBusinessMessage('512'));//��׼չ�ڽ��(Ԫ)������������е�չ�ڽ��(Ԫ)��
						return false;
					}else
					{					
						if(sBusinessType == '1020030') //Э�鸶ϢƱ������
						{
							alert(getBusinessMessage('513'));//��׼Ʊ���ܽ��(Ԫ)����С�ڻ���������е�Ʊ���ܽ��(Ԫ)��
							return false;
						}else if(sBusinessType == '2050030' || sBusinessType == '2020' || sBusinessType == '2050020') //��������֤����������֤����������֤
						{
							alert(getBusinessMessage('514'));//��׼����֤���(Ԫ)����С�ڻ���������е�����֤���(Ԫ)��
							return false;
						}else if(sBusinessType == '2050010') //�������
						{
							alert(getBusinessMessage('515'));//��׼���ݽ��(Ԫ)����С�ڻ���������еĵ��ݽ��(Ԫ)��
							return false;
						}else if(sBusinessType == '1100010') //�ƽ�����ҵ��
						{
							alert(getBusinessMessage('516'));//��׼���޻ƽ��������С�ڻ���������е����޻ƽ������
							return false;
						}else if(sBusinessType == '3030010' || sBusinessType == '3030030' || sBusinessType == '3030020') //���˷��ݴ��������Ŀ���������������̡��������Ѵ������������
						{
							alert(getBusinessMessage('517'));//��׼�����ܶ��(Ԫ)����С�ڻ���������е����볨���ܶ��(Ԫ)��
							return false;
						}else
						{
							alert(getBusinessMessage('518'));//��׼���(Ԫ)����С�ڻ���������еĽ��(Ԫ)��
							return false;
						}						
					}
				}
			}
			
			//У�����ޣ�ͳһ�������������������������*30�������죨ϵͳ��û��ʹ�������꣩��
			//�����������			
			dCheckTermMonth = "<%=iCheckTermMonth%>";
			//�����������
			dCheckTermDay = "<%=iCheckTermDay%>";
			//�����������
			dCheckTotalDay = parseInt(dCheckTermMonth)*30 + parseInt(dCheckTermDay);
			//��׼��������
			dTermMonth = getItemValue(0,getRow(),"TermMonth");
			//��׼��������
			dTermDay = getItemValue(0,getRow(),"TermDay");
			//��׼��������
			dTotalDay = parseInt(dTermMonth)*30 + parseInt(dTermDay);
			if(parseFloat(dCheckTotalDay) >= 0 && parseFloat(dTotalDay) >= 0)
			{
				if(dTotalDay > dCheckTotalDay)
				{
					alert(getBusinessMessage('550'));//��׼�����ޱ���С�ڻ������������ޣ�
					return false;
				}
			}
			
			//��׼���
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//��֤����
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//�����ѽ��
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
			
			//У����׼����뱣֤����֮���ҵ���߼���ϵ
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0)
			{
				if(parseFloat(dBailSum) > parseFloat(dBusinessSum))
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
						alert(getBusinessMessage('570'));//��֤����(Ԫ)����С�ڻ������׼���(Ԫ)��
						return false;
					}
				}
			}
			
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dPdgSum) >= 0)
			{
				if(parseFloat(dPdgSum) > parseFloat(dBusinessSum))
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
					&& sBusinessType != '2110010' && sBusinessType != '1110140' 
					&& sBusinessType != '1110150') //��Ϊ���˾�Ӫ������˷��ݴ��������Ŀ��
					//�������Ѵ�����������̡��������������̡�����ס������������ҵ��ѧ���������ѧ����
					{
						alert(getBusinessMessage('571'));//�����ѽ��(Ԫ)����С�ڻ������׼���(Ԫ)��
						return false;
					}
				}
			}	
		}
		
		if(sObjectType == "CreditApply" || sObjectType == 'ApproveApply')
		{
			//�����ʽ�����˵���Ĺ�ϵ
			sDrawingType = getItemValue(0,getRow(),"DrawingType");//��ʽ��01��һ����02���ִ���
			sContextInfo = getItemValue(0,getRow(),"ContextInfo");
			//ҵ��Ʒ��Ϊ���������ʽ������������ʽ���������˰�˻��йܴ��
			//��ҵ�жһ�Ʊ����������������Ŀ�������������Ŀ�����������Ŀ����
			//���Ŵ���ʱ
			if(sBusinessType == '1010010' || sBusinessType == '1010020'
			 || sBusinessType == '1010040' || sBusinessType == '1020040'
			 || sBusinessType == '1030010' || sBusinessType == '1030020'
			 || sBusinessType == '1030030' || sBusinessType == '1060') 
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
			//ҵ��Ʒ��Ϊ���������ʽ������������ʽ��������˻�͸֧��������˰�˻��йܴ��
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
			 || sBusinessType == '1080040' || sBusinessType == '1080050'
			 || sBusinessType == '1080060' || sBusinessType == '1080070'
			 || sBusinessType == '1090010' || sBusinessType == '1090020'
			 || sBusinessType == '1090030' || sBusinessType == '1100010'
			 || sBusinessType == '2060010' || sBusinessType == '2060020'
			 || sBusinessType == '2060030' || sBusinessType == '2060040'
			 || sBusinessType == '2060050' || sBusinessType == '2060060'
			 || sBusinessType == '2070') 
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
			//��׼���
			dCheckBusinessSum = <%=dCheckBusinessSum%>;
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
				}
				
				//У���ͬ���������ͬ��ʼ��֮��������Ƿ񳬹�����׼������
				iCheckTermYear = "<%=iCheckTermYear%>";
				iCheckTermMonth = "<%=iCheckTermMonth%>";
				if(typeof(iCheckTermYear) != "undefined" && iCheckTermYear != ""
				&& typeof(iCheckTermMonth) != "undefined" && iCheckTermMonth != "")	
				{						
					a = new Date(sPutOutDate);
					b = new Date(sMaturity);			
					if(parseInt((b-a)/1000/24/60/60/30) > (parseInt(iCheckTermMonth)+parseInt(iCheckTermYear)*12))
					{
						alert(getBusinessMessage('591'));//��ͬ���ޱ���С�ڻ����������������е����ޣ����������£���
						return;
					}
				}			
			}
			
			//��ͬ���
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//��֤����
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//�����ѽ��
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
			
			//У���ͬ����뱣֤����֮���ҵ���߼���ϵ
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0)
			{
				if(parseFloat(dBailSum) > parseFloat(dBusinessSum))
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
						alert(getBusinessMessage('573'));//��֤����(Ԫ)����С�ڻ���ں�ͬ���(Ԫ)��
						return false;
					}
				}
			}
			
			if(parseFloat(dBusinessSum) >= 0 && parseFloat(dPdgSum) >= 0)
			{
				if(parseFloat(dPdgSum) > parseFloat(dBusinessSum))
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
					&& sBusinessType != '2110010' && sBusinessType != '1110140' 
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
			if(parseFloat(sBaseRate) >= 0 && parseFloat(sCheckBaseRate) >= 0)
			{
				if(parseFloat(sBaseRate) < parseFloat(sCheckBaseRate))
				{
					alert(getBusinessMessage('559'));//��׼���ʱ�����ڻ����������������еĻ�׼���ʣ�
					return false;
				}
			}
			
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
		return true;
	}
			
	/*~[Describe=ѡ����Ҫ������ʽ;InputParam=��;OutPutParam=��;]~*/
	function selectVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
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
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}
		else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];
			sIndustryTypeName = sIndustryTypeInfo[1];

			sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue="+sIndustryTypeValue,"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
			if(sIndustryTypeInfo == "NO")
			{
				setItemValue(0,getRow(),"Direction","");
				setItemValue(0,getRow(),"DirectionName","");
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];
				sIndustryTypeName = sIndustryTypeInfo[1];
				setItemValue(0,getRow(),"Direction",sIndustryTypeValue);
				setItemValue(0,getRow(),"DirectionName",sIndustryTypeName);				
			}
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
		//��׼����
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//���ʸ�����ʽ
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//���ʸ���ֵ
		dRateFloat = getItemValue(0,getRow(),"RateFloat");
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 && parseFloat(dRateFloat) >= 0)
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
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgRatio = getItemValue(0,getRow(),"PdgRatio");
	        dPdgRatio = roundOff(dPdgRatio,2);
	        if(parseFloat(dPdgRatio) >= 0)
	        {
	            dPdgSum = parseFloat(dBusinessSum)*parseFloat(dPdgRatio)/1000;
	            dPdgSum = roundOff(dPdgSum,2);
	            setItemValue(0,getRow(),"PdgSum",dPdgSum);
	        }
	    }
	}
	
	/*~[Describe=���������Ѽ�����������;InputParam=��;OutPutParam=��;]~*/
	function getPdgRatio()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgSum = getItemValue(0,getRow(),"PdgSum");
	        dPdgSum = roundOff(dPdgSum,2);
	        if(parseFloat(dPdgSum) >= 0)
	        {	       
	            dPdgRatio = parseFloat(sPdgSum)/parseFloat(dBusinessSum)*1000;
	            dPdgRatio = roundOff(dPdgRatio,2);
	            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
	        }
	    }
	}
	
	/*~[Describe=���ݱ�֤��������㱣֤����;InputParam=��;OutPutParam=��;]~*/
	function getBailSum()
	{
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailRatio = getItemValue(0,getRow(),"BailRatio");
	        dBailRatio = roundOff(dBailRatio,2);
	        if(parseFloat(dBailRatio) >= 0)
	        {	        
	            dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
	            dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	        }
	    }
	}
	
	/*~[Describe=���ݱ�֤������㱣֤�����;InputParam=��;OutPutParam=��;]~*/
	function getBailRatio()
	{
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
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
	
	/*~[Describe=��ʼ������;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		sOccurType = "<%=sOccurType%>";
		sObjectType = "<%=sObjectType%>";
		if(sOccurType == "015" && sObjectType == "CreditApply") //չ��ҵ��
		{
			setItemValue(0,getRow(),"TotalSum","<%=dOldBusinessSum%>");
			setItemValue(0,getRow(),"BusinessSum","<%=dOldBalance%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sOldBusinessCurrency%>");
			setItemValue(0,getRow(),"TermDate1","<%=sOldMaturity%>");
			setItemValue(0,getRow(),"BaseRate","<%=dOldBusinessRate%>");
			setItemValue(0,getRow(),"ExtendTimes","<%=iExtendTimes%>");
		}
		if(sOccurType == "020") //���»���
		{
			setItemValue(0,getRow(),"LNGOTimes","<%=iLNGOTimes%>");
		}
		if(sOccurType == "060") //���ɽ���
		{
			setItemValue(0,getRow(),"GOLNTimes","<%=iGOLNTimes%>");
		}
		if(sOccurType == "030") //ծ������
		{
			setItemValue(0,getRow(),"DRTimes","<%=iDRTimes%>");
		}
		
	}
			
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();	
</script>	
<%/*~END~*/%>


<%@ include file="IncludeEnd.jsp"%>