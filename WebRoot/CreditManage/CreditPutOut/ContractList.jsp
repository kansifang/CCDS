<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: ����̨���б���Ϣ;
		Input Param:
			ContractType��
				010010����δ�ս�ҵ��
				010020����δ�ս�ҵ��
				020010�����ս�ҵ��
				020020�����ս�ҵ��	
				030010010����δ�ս�ҵ��(���ƽ���ȫ)
				030010020����δ�ս�ҵ��(���ƽ���ȫ)
				030020010�����ս�ҵ��(���ƽ���ȫ)
				030020020�����ս�ҵ��(���ƽ���ȫ)						
		Output Param:
			
		HistoryLog:
					2005.7.28 hxli  sql��д�������д
					2005.08.09 ��ҵ� �޸ĵ�������ť
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%

	//�������
	String sSql = "";
 
	//���ҳ�����
	//����������
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));
		  
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerName","�ͻ�����"},							
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"CreditAggreement","���Э����"},						
							{"OccurTypeName","��������"},													
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"Balance","���"},
							{"NormalBalance","�������"},
							{"OverdueBalance","�������"},
							{"DullBalance","�������"},
							{"BadBalance","�������"},
							{"BailAccount","��֤���˺�"},
							{"BailSum","��֤��(Ԫ)"},
							{"ClearSum","���ڽ��(Ԫ)"},
							{"FineBalance1","���ڷ�Ϣ���"},
							{"FineBalance2","��Ϣ���"},							
							{"BusinessRate","����(��)"},
							{"InterestBalance1","����ǷϢ���"},
							{"InterestBalance2","����ǷϢ���"},
							{"PdgRatio","����(��)"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"VouchTypeName","������ʽ"},							
							{"ClassifyResult","��ǰ���շ����������棩"},
							{"BaseClassifyResult","��ǰ���շ�������ʵ�ʣ�"},
							{"UserName","�ͻ�����"},
							{"OperateOrgName","�������"},
							{"VouchType","��Ҫ������ʽ"}
						  };
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
    if(sDBName.startsWith("INFORMIX"))
    {
	    sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" CreditAggreement,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,OverdueBalance,DullBalance,BadBalance,BailAccount,nvl(BailSum,0) as BailSum,"+
					" case when (Balance-nvl(BailSum,0))<0 then 0 else (Balance-nvl(BailSum,0)) end as ClearSum,"+
					" OverdueBalance,nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
					" FineBalance1,FineBalance2,BusinessRate,InterestBalance1,InterestBalance2,PdgRatio,PutOutDate,Maturity,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
					" getItemName('ClassifyResult',BaseClassifyResult) as BaseClassifyResult,"+
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}else if(sDBName.startsWith("ORACLE"))
	{
		sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" CreditAggreement,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,BailAccount,nvl(BailSum,0) as BailSum,"+
					" case when (Balance-nvl(BailSum,0))<0 then 0 else (Balance-nvl(BailSum,0)) end as ClearSum,"+
					" nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
					" FineBalance1,FineBalance2,BusinessRate,PdgRatio,PutOutDate,Maturity,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
					" getItemName('ClassifyResult',BaseClassifyResult) as BaseClassifyResult,"+
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}if(sDBName.startsWith("DB2"))
    {
	    sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" CreditAggreement,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,BailAccount,nvl(BailSum,0) as BailSum,"+
					" case when (Balance-nvl(BailSum,0))<0 then 0 else (Balance-nvl(BailSum,0)) end as ClearSum,"+
					" nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
					" FineBalance1,FineBalance2,BusinessRate,PdgRatio,PutOutDate,Maturity,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
					" getItemName('ClassifyResult',BaseClassifyResult) as BaseClassifyResult,"+
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	//	010010����δ�ս�ҵ��
	//	010020����δ�ս�ҵ��
	//	020010�����ս�ҵ��
	//	020020�����ս�ҵ��
	//  030010010����δ�ս�ҵ��(���ƽ���ȫ)
	//  030010020����δ�ս�ҵ��(���ƽ���ȫ)
	//  030020010�����ս�ҵ��(���ƽ���ȫ)
	//  030020020�����ս�ҵ��(���ƽ���ȫ)

    sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sContractType.equals("010010") || sContractType.equals("030010010"))
	{
		if(sDBName.startsWith("INFORMIX"))
		{
			if(sContractType.equals("010010"))
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}else if(sDBName.startsWith("ORACLE"))
		{
			if(sContractType.equals("010010"))
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID = ' ' or RecoveryOrgID is null)";
			else
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = ' ' or FinishDate is null) and RecoveryOrgID is not null";
		}else if(sDBName.startsWith("DB2"))
		{
			if(sContractType.equals("010010"))
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}
	}
	else if(sContractType.equals("010020") || sContractType.equals("030010020"))
	{
		if(sDBName.startsWith("INFORMIX"))
		{
			if(sContractType.equals("010020"))
				sSql += " and Balance >= 0 and BusinessType like '2%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and Balance >= 0 and BusinessType like '2%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}else if(sDBName.startsWith("ORACLE"))
		{
			if(sContractType.equals("010020"))
				sSql += " and Balance >= 0 and BusinessType like '2%' and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID = ' ' or RecoveryOrgID is null)";
			else
				sSql += " and Balance >= 0 and BusinessType like '2%' and (FinishDate = ' ' or FinishDate is null) and RecoveryOrgID is not null";
		}else if(sDBName.startsWith("DB2"))
		{
			if(sContractType.equals("010020"))
				sSql += " and BusinessType like '2%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and BusinessType like '2%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}
	}	
	else if(sContractType.equals("020010") || sContractType.equals("030020010"))
	{
		if(sDBName.startsWith("INFORMIX"))
		{
			if(sContractType.equals("020010"))
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '1%' and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '1%' and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}else if(sDBName.startsWith("ORACLE"))
		{
			if(sContractType.equals("020010"))
				sSql += " and (FinishDate <> ' ' and FinishDate is not null) and BusinessType like '1%' and (RecoveryOrgID = ' ' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> ' ' and FinishDate is not null) and BusinessType like '1%' and RecoveryOrgID is not null";
		}else if(sDBName.startsWith("DB2"))
		{
			if(sContractType.equals("020010"))
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '1%' and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '1%' and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}	
		
	}
	else if(sContractType.equals("020020") || sContractType.equals("030020020"))
	{
		if(sDBName.startsWith("INFORMIX"))
		{
			if(sContractType.equals("020020"))
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '2%' and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '2%' and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}else if(sDBName.startsWith("ORACLE"))
		{
			if(sContractType.equals("020020"))
				sSql += " and (FinishDate <> ' ' and FinishDate is not null) and BusinessType like '2%' and (RecoveryOrgID = ' ' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> ' ' and FinishDate is not null) and BusinessType like '2%' and RecoveryOrgID is not null";
		}else if(sDBName.startsWith("DB2"))
		{
			if(sContractType.equals("020020"))
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '2%' and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '2%' and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}
	}else if(sContractType.equals("040010"))//�����貹��ҵ��
	{
		if(sDBName.startsWith("DB2"))
		{
				sSql += " and (BusinessType like '1020%' or BusinessType in('1080010','1080035','2050010','1080070','1080020','1080040','1080055','1080045','1080050','1080060','1080030') "+
						" or (BusinessType='1110010' and SerialNo like 'BC%')) "+
				" and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
		}
	}
	else if(sContractType.equals("040020"))//�����貹��ҵ��
	{
		if(sDBName.startsWith("DB2"))
		{
			sSql += " and (BusinessType like '2040%' or BusinessType like '2050%' or BusinessType in('2010','2030','2070','2110040')) "+
			" and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
		}
	}	
		
	//����֧�пͻ��������пͻ��������пͻ�������û�ֻ�ܲ鿴�Լ��ܻ��ĺ�ͬ
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")|| CurUser.hasRole("2A5") || CurUser.hasRole("2D3"))
	{
	    sSql += " and ManageUserID = '"+CurUser.UserID+"'";
	}
	sSql += " order by CustomerName";
	//out.println(sSql);
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	if(sContractType.equals("010010") || sContractType.equals("020010"))
	{
		doTemp.setVisible("BailAccount,BailSum,ClearSum,PdgRatio",false);	
	}
	if(sContractType.equals("010020") || sContractType.equals("020020"))
	{
		doTemp.setVisible("OverdueBalance,OccurTypeName,BusinessRate",false);	
	}
	//���ò��ɼ���
	doTemp.setVisible("BusinessType,BailAccount,BailSum,ClearSum,OccurType,CreditAggreement,PdgRatio,BusinessCurrency,VouchType,OperateOrgID,OrgName",false);	
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BadBalance,DullBalance,NormalBalance,BusinessSum,Balance,BailSum,OverdueBalance,FineBalance1,FineBalance2,BusinessRate,ClearSum,PdgRatio","3");
	doTemp.setType("BadBalance,DullBalance,NormalBalance,InterestBalance1,InterestBalance2,BusinessSum,Balance,BailSum,OverdueBalance,FineBalance1,FineBalance2,BusinessRate,ClearSum,PdgRatio","Number");
	doTemp.setCheckFormat("BadBalance,DullBalance,NormalBalance,BusinessSum,Balance,BailSum,OverdueBalance,FineBalance1,FineBalance2,PdgRatio,ClearSum","2");
	doTemp.setCheckFormat("BusinessRate","16");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName,PdgRatio"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from code_library where codeno = 'VouchType' and ItemNo in ('005','010','020','040')");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency","2");
	//doTemp.setColumnAttribute("CustomerName,BusinessTypeName,SerialNo,Maturity,VouchType","IsFilter","1");
	
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","BusinessTypeName","");	
	doTemp.setFilter(Sqlca,"3","SerialNo","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","Maturity","");
	doTemp.setFilter(Sqlca,"6","VouchType","Operators=BeginsWith");	
	doTemp.setFilter(Sqlca,"7","ClassifyResult","");
	doTemp.setFilter(Sqlca,"8","BaseClassifyResult","");
	doTemp.parseFilterData(request,iPostChange);
	
	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10); 	//��������ҳ

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//��֯���кϼ��ò��� add by zrli 
	String[][] sListSumHeaders = {	{"BusinessCurrency","����"},
									{"BusinessSum","��ͬ���"},
									{"Balance","���"},
									{"BailSum","��֤��(Ԫ)"},
									{"InterestBalance1","����ǷϢ"},
									{"InterestBalance2","����ǷϢ"},
								 };
	String sListSumSql = "Select BusinessCurrency,Sum(BusinessSum) as BusinessSum,Sum(Balance) as Balance,Sum(BailSum) as BailSum,"
						+ " Sum(InterestBalance1) as InterestBalance1, Sum(InterestBalance2) as InterestBalance2 "
						+ " From BUSINESS_CONTRACT "
						+ doTemp.WhereClause
						+ " Group By BusinessCurrency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
	
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
			{"true","","Button","��ͬ����","��ͬ����","viewTab()",sResourcesPath},
			{"false","","Button","������ͬ��Ϣ","������ͬ����","AssureManage()",sResourcesPath},
			{"true","","Button","�����ʼ�","�������ʼ�","WorkRecord()",sResourcesPath},
			{"true","","Button","�����ص�����","�����ص�����","AddUserDefine()",sResourcesPath},
			{"true","","Button","���պ�����","���պ�����","my_DunManage()",sResourcesPath},
			{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
			{"true","","Button","����","������","listSum()",sResourcesPath},
			{"false","","Button","��ͬ����","��ͬ����","BusinessMendInfo()",sResourcesPath},
			{"false","","Button","��ݲ���","��ݲ���","MendDueBillInfo()",sResourcesPath},
			{"false","","Button","ҵ����Ϣ����","ҵ����Ϣ����","MendDueBillInfo()",sResourcesPath},
			{"false","","Button","���ʵʱ���","���ʵʱ���","CheckBalance()",sResourcesPath},
			{"false","","Button","�ֹ��ս�","�ֹ��ս�","FinishDate()",sResourcesPath},
			{"false","","Button","Ʊ����Ϣ����","Ʊ����Ϣ����","MendBillInfo()",sResourcesPath},
		};
		
	if(sContractType.equals("010010")||sContractType.equals("010020"))//δ�ս����ҵ��
	{
		//sButtons[getBtnIdxByName(sButtons,"��Ϣ����")][0]="true";
		//sButtons[getBtnIdxByName(sButtons,"�ֹ��ս�")][0]="true";
	}
	
	if(sContractType.equals("020010") ||sContractType.equals("020020"))//���ս�ҵ��
	{
		sButtons[getBtnIdxByName(sButtons,"������ͬ��Ϣ")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"�ƽ���ȫ")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ص�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"���պ�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ʼ�")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"��ͬ�ս�")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"���ʽ����")][0]="false";
	}
	
	if(sContractType.indexOf("030") >= 0) //���ƽ���ȫ
	{		
		sButtons[getBtnIdxByName(sButtons,"������ͬ��Ϣ")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"�ƽ���ȫ")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ص�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"���պ�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ʼ�")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"��ͬ�ս�")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"���ʽ����")][0]="false";		
	}
	 if(sContractType.equals("040010")||sContractType.equals("040020"))
	 {
		sButtons[getBtnIdxByName(sButtons,"ҵ����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"���ʵʱ���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�ֹ��ս�")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"������ͬ��Ϣ")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ص�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"���պ�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ʼ�")][0]="false";
	 }
	 if(sContractType.equals("040010"))//�����貹��ҵ��
	 {
	 	//sButtons[getBtnIdxByName(sButtons,"Ʊ����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ݲ���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"���ʵʱ���")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"ҵ����Ϣ����")][0]="false";
	 }
	  if(CurUser.hasRole("299"))
	 {
		 sButtons[getBtnIdxByName(sButtons,"�ֹ��ս�")][0]="false";
	 }
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "AfterLoan";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sApproveType = getItemValue(0,getRow(),"ApproveType");
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApproveType="+sApproveType;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}

	/*~[Describe=������ͬ����;InputParam=��;OutPutParam=��;]~*/
	function AssureManage()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("AssureView","/CreditManage/CreditPutOut/AssureView.jsp","ComponentName=������ͬ����&ObjectType=AfterLoan&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}

	/*~[Describe=�������ʼ�;InputParam=��;OutPutParam=��;]~*/
	function WorkRecord()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","ComponentName=�������ʼ�&NoteType=BusinessContract&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=�����ص��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function AddUserDefine()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage('420'))) //Ҫ�������ͬ��Ϣ�����ص��ͬ��������
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
		}
	}
	
	/*~[Describe=���պ�����;InputParam=��;OutPutParam=��;]~*/
	function my_DunManage()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("DunList","/RecoveryManage/DunManage/DunList.jsp","ObjectType=BusinessContract&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=���ⲹ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function BusinessMendInfo()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBusinessType   = getItemValue(0,getRow(),"BusinessType");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(sBusinessType.substring(0,4)=='2050' || (sBusinessType.substring(0,4)=='1080'&&sBusinessType!='1080070'&&sBusinessType!='1080030'&&sBusinessType!='1080035'&&sBusinessType!='1080055') || 
		sBusinessType == '2010' || sBusinessType.substring(0,4)=='1020' || 
		sBusinessType.substring(0,4)=='2030' || sBusinessType.substring(0,4)=='2040')//����ҵ�񡢳жҡ����֡�����
		{
			OpenComp("BusinessMendInfo","/CreditManage/CreditPutOut/BusinessMendInfo.jsp","ObjectNo="+sSerialNo,"_blank",OpenStyle);
			reloadSelf();
		}else{
			alert("��ҵ����Ҫ���ǣ�");
		}
	}
	
	/*~[Describe=��ݲ�����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function MendDueBillInfo()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBusinessType   = getItemValue(0,getRow(),"BusinessType");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			   OpenComp("MendDueBillList","/CreditManage/CreditPutOut/MendDueBillList.jsp","ObjectNo="+sSerialNo,"_blank",OpenStyle);
			   reloadSelf();
		     }
	}
	
	/*~[Describe=���ʵʱ���;InputParam=��;OutPutParam=��;]~*/
	function CheckBalance()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");//��ͬ��ˮ��
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
             sReturn=RunMethod("BusinessManage","GetSumBalanceValue",sSerialNo);//��ý���ܽ��������
             sReturn=sReturn.split("@");
             if(typeof(sReturn) == "undefined" || sReturn.length==0 || sReturn=="Null" || sReturn=="" )
          	 {
          		sReturnValue=RunMethod("PublicMethod","UpdateColValue","Number@Balance@null@Number@ActualPutOutSum@null,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
          		alert("δ¼��ҵ����Ϣ");
          		return;
  		     }else
          	 {	
       		    sReturnValue=RunMethod("PublicMethod","UpdateColValue","Number@Balance@"+parseFloat(sReturn[1])+"@Number@ActualPutOutSum@"+parseFloat(sReturn[0])+",BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
       		    alert("������"+amarMoney(sReturn[1],2));
		     }
             reloadSelf();
		 }
	}
	
	/*~[Describe=�ֹ��ս��ͬ;InputParam=��;OutPutParam=��;]~*/
	function FinishDate()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
	 	dInterestBalance1 =getItemValue(0,getRow(),"InterestBalance1");//��ȡ����ǷϢ
  		dInterestBalance2 =getItemValue(0,getRow(),"InterestBalance2");//��ȡ����ǷϢ
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	  	}else
	  	{
	  		sReturn=RunMethod("BusinessManage","GetSumBalanceValue",sSerialNo);//��ý���ܽ��������
	  	    sReturn=sReturn.split("@");
	  		if(typeof(sReturn) == "undefined" || sReturn.length==0 || sReturn=="Null" || sReturn=="" )
	  		{
	  			sReturnValue=RunMethod("PublicMethod","UpdateColValue","Number@Balance@null@Number@ActualPutOutSum@null,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
	  			alert("��ҵ���ܽ����ֹ��սᣬδ¼��ҵ����Ϣ");
	  		    return ;
	  		}else
	  		{	
	  			sReturnValue=RunMethod("PublicMethod","UpdateColValue","Number@Balance@"+parseFloat(sReturn[1])+"@Number@ActualPutOutSum@"+parseFloat(sReturn[0])+",BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
	  		}
	  		dBalance =parseFloat(sReturn[1]);//��ȡʵʱ��ͬ���
		 	if((parseFloat(dInterestBalance1)+parseFloat(dInterestBalance2)+parseFloat(dBalance))>0)//��ͬ���ӱ�����ǷϢ����0���Ͳ����ֹ��ս�
	  		{
	  			alert("��ҵ���ܽ����ֹ��սᣡ");
	  		 	return;
	  		}else if(confirm("�˱�ҵ���Ƿ�ȷ���ս᣿"))
	  		{
	  			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@FinishDate@<%=StringFunction.getToday()%>,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
	  		  	reloadSelf();
	  		}
	  		
	  	}
	
	} 
	
	//Ʊ����Ϣ����
	function MendBillInfo()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBusinessType   = getItemValue(0,getRow(),"BusinessType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if(sBusinessType != "2010")
			{
				alert("���гжһ�Ʊ���ܽ���Ʊ����Ϣ����");
			}else
			{
			    sReturn = RunMethod("BusinessManage","CheckDueBillList",sSerialNo);
			    if(sReturn > 0) 
			    {
			        OpenComp("MendBillList","/CreditManage/CreditPutOut/MendAcceptBillList.jsp","ObjectNo="+sSerialNo,"_blank",OpenStyle);
			    }else
			    {
			        alert("������н�ݲ��Ǻ���ܽ���Ʊ����Ϣ����");
			    }
			}
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//��̨ͬ����Ϣ
	function my_ManageView()
	{ 
		//��ͬ��ˮ�š���ͬ��š��ͻ�����,����
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sItemMenuNo = "<%=sContractType%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
		}else
		{
			sObjectType = "NPABook";
			sObjectNo = sSerialNo;
			
			if(sItemMenuNo=="010050") 
				sViewID = "001";
			else
				sViewID = "002";

			openObject(sObjectType,sObjectNo,sViewID);
		}
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	/*~[Describe=������;InputParam=��;OutPutParam=��;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
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