<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: bqliu 2011-05-31
		Tester:
		Describe:
		Input Param:
			ContractType��
									
		Output Param:
			
		HistoryLog:
				
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
							{"ClassifyResult","���շ���"},
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
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	
    sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	
	sSql += " and (BusinessType like '2040%' or BusinessType like '2050%' or BusinessType in('2010','2030','2070','2110040','')) "+
		    " and (FinishDate <> '' or FinishDate is not null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
		
		
	//����֧�пͻ��������пͻ��������пͻ�������û�ֻ�ܲ鿴�Լ��ܻ��ĺ�ͬ
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
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
			{"true","","Button","ȡ���ֹ��ս�","ȡ���ֹ��ս�","ClearFinishDate()",sResourcesPath},
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�ֹ��ս��ͬ;InputParam=��;OutPutParam=��;]~*/
	function ClearFinishDate()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBusinessType   = getItemValue(0,getRow(),"BusinessType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(sBusinessType.substring(0,4)=='2050' || sBusinessType == '2010' || 
		sBusinessType.substring(0,4)=='2030' || sBusinessType.substring(0,4)=='2040')
		{
			if(confirm("��ȷ��ȡ���ս���?"))//�������ɾ������Ϣ��
			{
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@FinishDate@None,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				reloadSelf();
			}
		}else{
			alert("��ҵ�����ֹ�ȡ���սᣡ");
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
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