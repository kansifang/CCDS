<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2010/05/25
*	Tester:
*	Describe: �����ʲ�̨�˹�����ڲ�������̨��̨����Ϣ�б�
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ڲ�������̨��"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//���������SQL���,��ѯ�����,����ֱ�������ر�־
	//����������:��ͼ�ڵ�,�����ʲ�̨��״̬
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
	String sStateFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("StateFlag"));
	if(sStateFlag == null) sStateFlag="";
	//���ҳ�����
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�������
	String sHeaders[][] = {
						{"Status","��ѡ��"},
						{"ReturnFlag","�Ƿ��˻�"},
						{"ReturnFlagName","�Ƿ��˻�"},
						{"OrgChangeFlag","�Ƿ�������"},
						{"OrgChangeFlagName","�Ƿ�������"},
						{"UserChangeFlag","�Ƿ�����˱��"},
						{"UserChangeFlagName","�Ƿ�����˱��"},
						{"SerialNo","̨����ˮ��"},
						{"BelongOrgID","�����ʲ���������"},
						{"BelongOrgName","�����ʲ���������"},
						{"FirstPutOutDate","�״η�����"},
						{"LastMaturity","�������"},
						{"LoanAccountNo","�����ʺ�"},
						{"LoanType","���ʽ"},
						{"LoanTypeName","���ʽ"},
						{"CustomerName","���������"},
						{"CustomerTypeName","��������"},
						{"CustomerProperty","���������"},
						{"CustomerManageStatus","����˾�Ӫ״��"},
						{"AssetStatus","������ʲ�״��"},
						{"CustomerAttitude","�����̬��"},
						{"DebtInstance","ծ����ʵ���"},
						{"FactVouchDegree","ʵ�ʵ����̶�"},
						{"VouchEffectDate","����ʱЧ"},
						{"LawEffectDate","����ʱЧ"},
						{"TextDocStatus","�ı��������"},
						{"FormerManageName","ԭ����������"},
						{"BadLoanType","���������ʼ���"},
						{"BadLoanTypeName","���������ʼ���"},
						{"InitializeBalance","���������ʼ����"},
						{"ClassifyResult","���շ����ʼ���"},
						{"ClassifyResultName","���շ����ʼ���"},
						{"DisposeTotalSum","���������մ��ñ���ϼ�"},
						{"MoneyReturnSum","�����ڻ����ʽ��ջ�"},
						{"ReformUpSum","�����������ϵ�"},
						{"NotReformUpSum","�����ڷ������ϵ�"},
						{"PayDebtSum","���������ʵ�ծ"},
						{"CVSum","�����ں���"},
						{"MetathesisSum","�������ʽ��û�"},
						{"OtherReturnSum","������������ʽ�ջ�"},
						{"CleanInterest1","���������ձ�����Ϣ"},
						{"CleanInterest2","���������ձ�����Ϣ"},
						{"FinalBalance","��ĩ��Ƿ�������"},
						{"FinalInterest","��ĩ��Ƿ��Ϣ���"},
						{"ISLawFlag","�Ƿ�����"},
						{"ReturnLawSum","�����ջر���"},
						{"ReturnLawInterest","�����ջ���Ϣ"},
						{"FactUser","ʵ���ÿ���"},
						{"CertType","�����֤������"},
						{"CertTypeName","�����֤������"},
						{"CertID","�����֤������"},
						{"VouchMaturity","����������"},
						{"LastDunDate","����������"},
						{"AccountManageDate","������Ϣ���ά������"},
						{"BasicManageDate","������Ϣ���ά������"},
						{"BadBizFinishDate","�ս�����"},
						{"RecoverOrgID","�ֲ����ʲ��������"},
						{"RecoverUserID","�ֲ����ʲ�����Ա"},
						{"RecoverOrgName","�ֲ����ʲ��������"},
						{"RecoverUserName","�ֲ����ʲ�����Ա"},
						{"IsFinish","�Ƿ��ս�"},
						{"IsFinishName","�Ƿ��ս�"},
						{"AccountNeedManage","������Ϣ�Ƿ��ά��"},
						{"AccountNeedManageName","������Ϣ�Ƿ��ά��"},
						{"BasicNeedManage","������Ϣ�Ƿ��ά��"},
						{"BasicNeedManageName","������Ϣ�Ƿ��ά��"},
						{"NeedDun","�Ƿ�����մ���"},
						{"VDMature","����ʱЧ�Ƿ���"},
						{"LdMature","����ʱЧ�Ƿ���"}
					}; 

	sSql = " select '' as Status,ReturnFlag,getItemName('YesNo',ReturnFlag) as ReturnFlagName,"+
				" OrgChangeFlag,getItemName('YesNo',OrgChangeFlag) as OrgChangeFlagName,"+
				" UserChangeFlag,getItemName('YesNo',UserChangeFlag) as UserChangeFlagName,"+
				" SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,FirstPutOutDate,LastMaturity,LoanAccountNo,"+
				" LoanType,getItemName('VouchType2',LoanType) as LoanTypeName,CustomerName,"+
				" getItemName('CustomerType1',CustomerType) as CustomerTypeName,"+
				" getItemName('BorrowerType',CustomerProperty) as CustomerProperty,"+
				" getItemName('BorrowerManageStatus',CustomerManageStatus) as CustomerManageStatus,"+
				" getItemName('BorrowerAssetStatus',AssetStatus) as AssetStatus,"+
				" getItemName('BorrowerAttitude',CustomerAttitude) as CustomerAttitude,"+
				" getItemName('DebtInstance',DebtInstance) as DebtInstance,"+
				" getItemName('FactVouchDegree',FactVouchDegree) as FactVouchDegree,"+
				" CompareDate(VouchMaturity,0,'','��Ч') as VouchEffectDate,"+
				" CompareDate(LastMaturity,600,'','��Ч') as LawEffectDate,"+
				" getItemName('TextDocStatus',TextDocStatus) as TextDocStatus,"+
				" FormerManageName,BadLoanType,getItemName('BadLoanType',BadLoanType) as BadLoanTypeName,InitializeBalance,"+
				" ClassifyResult,getItemName('ClassifyResult1',ClassifyResult) as ClassifyResultName,DisposeTotalSum,"+
				" MoneyReturnSum,ReformUpSum,NotReformUpSum,"+
				" PayDebtSum,CVSum,MetathesisSum,OtherReturnSum,CleanInterest1,CleanInterest2,"+
				" FinalBalance,FinalInterest,getItemName('YesNo',ISLawFlag) as ISLawFlag,ReturnLawSum,ReturnLawInterest,FactUser,"+
				" CertType,getItemName('CertType',CertType) as CertTypeName,CertID,"+
				" VouchMaturity,LastDunDate,AccountManageDate,BasicManageDate,"+
				" BadBizFinishDate,RecoverOrgID,getOrgName(RecoverOrgID) as RecoverOrgName,"+
				" RecoverUserID,getUserName(RecoverUserID) as RecoverUserName,"+
				" IsFinish,getItemName('YesNo',IsFinish) as IsFinishName,"+
				" CompareDate(AccountManageDate,30,'1','2','1') as AccountNeedManage,CompareDate(AccountManageDate,30,'��','��','��') as AccountNeedManageName,"+
				" CompareDate(BasicManageDate,90,'1','2','1') as BasicNeedManage,CompareDate(BasicManageDate,90,'��','��','��') as BasicNeedManageName,"+
				" case when LastDunDate is null then CompareDate(LastMaturity,90,'��','��') else CompareDate(LastDunDate,90,'��','��') end as NeedDun,"+
				" case when LastDunDate is null then CompareDate(LastMaturity,600,'��','��') else CompareDate(LastDunDate,600,'��','��') end as VDMature," +
				" CompareDate(VouchMaturity,600,'��','��') as LdMature "+
		    " from BADBIZ_ACCOUNT "+
		    " where AccountType='010' and StateFlag='"+sStateFlag+"' ";
		   
	//������ͼȡ��ͬ�����	 
	/*
		StateFlag ̨�˽׶�:
					01:δ�Ǽ�
					10:�ѵǼ�
					03:��ȡ��
					80:���ս�		
	*/
	if(sDealType.substring(0,3).equals("110"))//ָ�������ʲ��������
	{
		sSql +=" and (RecoverOrgID is null or RecoverOrgID='')  and BelongOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}else if(sDealType.substring(0,3).equals("120"))//�����ʲ�����������
	{
		sSql +=" and RecoverOrgID is not null and RecoverOrgID!='' ";
	}else if(sDealType.substring(0,3).equals("130"))//ָ�������ʲ�������
	{
		sSql +=" and RecoverOrgID ='"+CurOrg.OrgID+"' and (RecoverUserID is null or RecoverUserID='') ";
	}else if(sDealType.substring(0,3).equals("140"))//�����ʲ������˱��
	{
		sSql +=" and RecoverOrgID ='"+CurOrg.OrgID+"'"+
				" and RecoverUserID is not null and  RecoverUserID!='' ";
	}else if(sDealType.substring(0,3).equals("150"))//�����ʲ�ת��
	{
		sSql +=" and RecoverOrgID ='"+CurOrg.OrgID+"'"+
		" and RecoverUserID is not null and  RecoverUserID!='' ";
	}
	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("ClassifyResult,BadLoanType,OrgChangeFlagName,UserChangeFlagName,ReturnFlagName,OrgChangeFlag,UserChangeFlag,ReturnFlag,BelongOrgID,RelativeContractNo,LoanType,CertType,RecoverOrgID,RecoverUserID,IsFinish,AccountNeedManage,BasicNeedManage",false);
	if(sDealType.substring(0,3).equals("110"))//ָ�������ʲ��������
	{
		 doTemp.setVisible("ReturnFlagName",true);
	}else if(sDealType.substring(0,3).equals("120"))//�����ʲ�����������
	{
		 doTemp.setVisible("OrgChangeFlagName",true);
	}else if(sDealType.substring(0,3).equals("130"))//ָ�������ʲ�������
	{
		 doTemp.setVisible("ReturnFlagName",true);
	}else if(sDealType.substring(0,3).equals("140"))//�����ʲ������˱��
	{
		doTemp.setVisible("UserChangeFlagName",true);
	}
	doTemp.UpdateTable="BADBIZ_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
	//����html���
	doTemp.setAlign("Status","2");
	doTemp.appendHTMLStyle("Status"," style={width:60px} ondblclick=\"javascript:parent.onDBClick()\" ");
	//�����п�
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");
	doTemp.setHTMLStyle("OrgChangeFlagName,UserChangeFlagName,ReturnFlag,ReturnFlagName,OrgChangeFlag,UserChangeFlag"," style={width:80px} ");
	
	//���ý��Ϊ��λһ������
	doTemp.setType("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","3");
	
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWCode("IsFinish","YesNo");
	doTemp.setDDDWCode("AccountNeedManage","YesNo");
	doTemp.setDDDWCode("BasicNeedManage","YesNo");
	doTemp.setDDDWCode("ReturnFlag","YesNo");
	doTemp.setDDDWCode("OrgChangeFlag","YesNo");
	doTemp.setDDDWCode("UserChangeFlag","YesNo");
	doTemp.setDDDWCode("ClassifyResult","ClassifyResult1");
	doTemp.setDDDWCode("BadLoanType","BadLoanType");
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
	//���ɲ�ѯ��
	if(sDealType.substring(0,3).equals("110"))//ָ�������ʲ��������
	{
		doTemp.setColumnAttribute("ClassifyResult,BadLoanType,FinalBalance,ReturnFlag,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID","IsFilter","1");
	}else if(sDealType.substring(0,3).equals("120"))//�����ʲ�����������
	{
		doTemp.setColumnAttribute("OrgChangeFlag,ClassifyResult,BadLoanType,FinalBalance,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,RecoverOrgName","IsFilter","1");
	}else if(sDealType.substring(0,3).equals("130"))//ָ�������ʲ�������
	{
		doTemp.setColumnAttribute("ClassifyResult,BadLoanType,FinalBalance,ReturnFlag,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID","IsFilter","1");
	}else if(sDealType.substring(0,3).equals("140"))//�����ʲ������˱��
	{
		doTemp.setColumnAttribute("UserChangeFlag,ClassifyResult,BadLoanType,FinalBalance,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,RecoverOrgName,RecoverUserName","IsFilter","1");
	}else if(sDealType.substring(0,3).equals("150"))//�����ʲ�ת��
	{
		doTemp.setColumnAttribute("ClassifyResult,BadLoanType,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FinalBalance,FinalInterest,RecoverOrgName,RecoverUserName","IsFilter","1");
	}else{
		doTemp.setColumnAttribute("SerialNo","IsFilter","1");
	}
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//����			
	String[][] sListSumHeaders = {	{"Sum1","���������ʼ����"},
									{"Sum2","���������մ��ñ���ϼ�"},
									{"Sum3","�����ڻ����ʽ��ջ�"},
									{"Sum4","�����������ϵ�"},
									{"Sum5","�����ڷ������ϵ�"},
									{"Sum6","���������ʵ�ծ"},
									{"Sum7","�����ں���"},
									{"Sum8","�������ʽ��û�"},
									{"Sum9","������������ʽ�ջ�"},
									{"Sum10","���������ձ�����Ϣ"},
									{"Sum11","���������ձ�����Ϣ"},
									{"Sum12","��ĩ��Ƿ�������"},
									{"Sum13","��ĩ��Ƿ��Ϣ���"},
									{"Sum14","�����ջر���"},
									{"Sum15","�����ջ���Ϣ"},
		 };
	String sListSumSql = "Select sum(InitializeBalance) as Sum1,"
						+"Sum(DisposeTotalSum) as Sum2,"
						+"Sum(MoneyReturnSum) as Sum3,"
						+"Sum(ReformUpSum) as Sum4,"
						+"Sum(NotReformUpSum) as Sum5,"
						+"Sum(PayDebtSum) as Sum6,"
						+"Sum(CVSum) as Sum7,"
						+"Sum(MetathesisSum) as Sum8,"
						+"Sum(OtherReturnSum) as Sum9,"
						+"Sum(CleanInterest1) as Sum10,"
						+"Sum(CleanInterest2) as Sum11,"
						+"Sum(FinalBalance) as Sum12,"
						+"Sum(FinalInterest) as Sum13,"
						+"Sum(ReturnLawSum) as Sum14,"
						+"Sum(ReturnLawInterest) as Sum15 "
						+ " From BADBIZ_ACCOUNT "
						+ doTemp.WhereClause;
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		{"false","","Button","�����϶�����","�����϶�����","dutyCogn_Info()",sResourcesPath},
		{"false","","Button","�����϶�����","�����϶�����","classify_Info()",sResourcesPath},
		{"true","","Button","̨������","̨������","account_Info()",sResourcesPath},
		{"false","","Button","ָ���������","ָ���������","designate_Org()",sResourcesPath},
		{"false","","Button","ָ��������","ָ��������","designate_User()",sResourcesPath},
		{"false","","Button","����������","����������","org_Change()",sResourcesPath},
		{"false","","Button","���������","���������","user_Change()",sResourcesPath},
		{"false","","Button","�鿴������������¼","�鿴������������¼","view_OrgChange()",sResourcesPath},
		{"false","","Button","�鿴�����˱����¼","�鿴�����˱����¼","view_UserChange()",sResourcesPath},
		{"false","","Button","�� ��","�˻�","untread_Account()",sResourcesPath},
		{"false","","Button","ת ��","ת��","transfer_Out()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath},
		{"true","","Button","����","����","listSum()",sResourcesPath},
		};
	//���ݲ�ͬ��ͼ��ʾ��ť
	if(sDealType.substring(0,3).equals("110"))//ָ�������ʲ��������
	{
		sButtons[getBtnIdxByName(sButtons,"ָ���������")][0]="true";
	}else if(sDealType.substring(0,3).equals("120"))//�����ʲ�����������
	{
		sButtons[getBtnIdxByName(sButtons,"����������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�鿴������������¼")][0]="true";
	}else if(sDealType.substring(0,3).equals("130"))//ָ�������ʲ�������
	{
		sButtons[getBtnIdxByName(sButtons,"ָ��������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�� ��")][0]="true";
	}else if(sDealType.substring(0,3).equals("140"))//�����ʲ������˱��
	{
		sButtons[getBtnIdxByName(sButtons,"���������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�鿴�����˱����¼")][0]="true";
	}else if(sDealType.substring(0,3).equals("150"))//�����ʲ�ת��
	{
		sButtons[getBtnIdxByName(sButtons,"ת ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�� ��")][0]="true";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�һ�ѡ����ָ��������̨��;InputParam=��;OutPutParam=��;]~*/
	function onDBClick()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus)=="undefined" || sStatus=="")
			setItemValue(0,getRow(),"Status","��");
		else
			setItemValue(0,getRow(),"Status","");

	}
	
	
	/*~[Describe=ѡ���¼;InputParam=��;OutPutParam=��;]~*/
	function selectRecord()
	{
		var b = getRowCount(0);
		var iCount = 0;				
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"Status");
			if(a == "��")
				iCount = iCount + 1;
		}
		
		if(iCount == 0)
		{
			alert("����ѡ���¼!");
			return false;
		}
		
		return true;
	}
	
	
	/*~[Describe=�����϶�;InputParam=��;OutPutParam=��;]~*/
	function dutyCogn_Info()
	{
		sLoanAccountNo = getItemValue(0,getRow(),"LoanAccountNo");		
		if (typeof(sLoanAccountNo)=="undefined" || sLoanAccountNo.length==0)
		{
			alert("�������϶���Ϣ!");
		}else
		{	
			sRelativeContactNo = sLoanAccountNo;
			sCompID = "NPAssetDutyList";
			sCompURL = "/CreditManage/CreditPutOut/NPADutyList.jsp";
			sParamString = "EditRight=2&ObjectType=BusinessContract&ObjectNo="+sRelativeContactNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	
	/*~[Describe=���շ�������;InputParam=��;OutPutParam=��;]~*/
	function classify_Info()
	{
		sLoanAccountNo = getItemValue(0,getRow(),"LoanAccountNo");		
		if (typeof(sLoanAccountNo)=="undefined" || sLoanAccountNo.length==0)
		{
			alert("�޷����϶���Ϣ");
		}else
		{
			sRelativeContactNo = sLoanAccountNo;
			sCompID = "ClassifyHistoryList";
			sCompURL = "/CreditManage/CreditPutOut/ClassifyHistoryList.jsp";
			sParamString = "ObjectType=BusinessContract&ObjectNo="+sRelativeContactNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	
	/*~[Describe=̨������;InputParam=��;OutPutParam=��;]~*/
	function account_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			popComp("BadBizAccountInfo","/RecoveryManage/AccountManage/BadBizAccountInfo.jsp","ComponentName=��������̨������&SerialNo="+sSerialNo+"&StateFlag=<%=sStateFlag%>&AccountType=010&AccountEditFlag=03","","");
		}
	}
	
	
	/*~[Describe=�˻�;InputParam=��;OutPutParam=��;]~*/
	function untread_Account()
	{	
		if(!selectRecord()) return;
		sDealType = "<%=sDealType%>";
		if(sDealType.substr(0,3)=="110")//ָ�������ʲ��������
		{	
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@01,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
		}else if(sDealType.substr(0,3)=="120")//�����ʲ�����������
		{
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverOrgID@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
		}else if(sDealType.substr(0,3)=="130")//ָ�������ʲ�������
		{
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverOrgID@None@String@ReturnFlag@1,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
		}else if(sDealType.substr(0,3)=="140")//�����ʲ������˱��
		{
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverUserID@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
		}else if(sDealType.substr(0,3)=="150")//�����ʲ�ת��
		{
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverUserID@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
		}
		reloadSelf();
	}
	
	
	/*~[Describe=ת��;InputParam=��;OutPutParam=��;]~*/   
	function transfer_Out()
	{
		if(!selectRecord()) return;
		if(confirm("��ȷ��ת����?"))//�������ɾ������Ϣ��
		{
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{	
						sSerialNo = getItemValue(0,i,"SerialNo");	
						sReturnValue=RunMethod("BadBizManage","DeleteBadBizAccount","BADBIZ_ACCOUNT,SerialNo,"+sSerialNo);
				}
			}
		}
		reloadSelf();
	}
	
	
	/*~[Describe=ָ����ȫ���������;InputParam=��;OutPutParam=��;]~*/   
	function designate_Org()
	{
		if(!selectRecord()) return;
		//�����Ի�ѡ���
		var sRecovery = PopPage("/RecoveryManage/DistributeManage/RecoveryOrgChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
		{
			sRecover = sRecovery.split("@");
			var sRecoverOrgID = sRecover[0];
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverOrgID@"+sRecoverOrgID+"@String@ReturnFlag@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);	
				}
			}
			reloadSelf();
		}
	}
	
	
	/*~[Describe=���ı�ȫ������;InputParam=��;OutPutParam=��;]~*/
	function org_Change()
	{
		/*
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{
			sOldOrgID = getItemValue(0,getRow(),"RecoverOrgID");
			sOldOrgName	= getItemValue(0,getRow(),"RecoverOrgName");
			popComp("ChangeOrgInfo","/RecoveryManage/DistributeManage/ChangeOrgInfo.jsp","ComponentName=�����������&OldOrgName="+sOldOrgName+"&OldOrgID="+sOldOrgID+"&ObjectNo="+sSerialNo+"&ObjectType=BadBizChangOrg","","");
			reloadSelf();
		}
		*/
		if(!selectRecord()) return;
		//�����Ի�ѡ���
		var sRecovery = PopPage("/RecoveryManage/DistributeManage/RecoveryOrgChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
		{
			sRecover = sRecovery.split("@");
			var sRecoverOrgID = sRecover[0];
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");
					sOldRecoverOrgID = getItemValue(0,i,"RecoverOrgID");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverOrgID@"+sRecoverOrgID+"@String@RecoverUserID@None@String@OrgChangeFlag@1,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
					sReturn = PopPage("/RecoveryManage/DistributeManage/ChangeManageAction.jsp?OldOrgID="+sOldRecoverOrgID+"&NewOrgID="+sRecoverOrgID+"&ObjectNo="+sSerialNo+"&ObjectType=BadBizChangOrg","","");	
				}
			}
			reloadSelf();
		}
	}
	
	
	 /*~[Describe=�鿴����������α����¼;InputParam=��;OutPutParam=��;]~*/
	function view_OrgChange()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			popComp("ChangeOrgList","/RecoveryManage/DistributeManage/ChangeOrgList.jsp","ComponentName=�鿴����������α����¼&ObjectType=BadBizChangOrg&ObjectNo="+sSerialNo,"","");			
		}
	}
	
	
	/*~[Describe=ָ����ȫ��������;InputParam=��;OutPutParam=��;]~*/   
	function designate_User()
	{
		if(!selectRecord()) return;
		//�����Ի�ѡ���
		var sRecovery = PopPage("/RecoveryManage/DistributeManage/RecoveryUserChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
		{
			sRecover = sRecovery.split("@");
			var sRecoverUserID = sRecover[0];
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");	
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverUserID@"+sRecoverUserID+"@String@ReturnFlag@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
			reloadSelf();
		}
	}
	
	
	/*~[Describe=���ı�ȫ������;InputParam=��;OutPutParam=��;]~*/
	function user_Change()
	{
		/*
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{
			sOldUserID = getItemValue(0,getRow(),"RecoverUserID");
			sOldUserName	= getItemValue(0,getRow(),"RecoverUserName");
			popComp("ChangeUserInfo","/RecoveryManage/DistributeManage/ChangeUserInfo.jsp","ComponentName=�������������&OldUserName="+sOldUserName+"&OldUserID="+sOldUserID+"&ObjectNo="+sSerialNo+"&ObjectType=BadBizChangUser","","");
			reloadSelf();
		}
		*/
		if(!selectRecord()) return;
		//�����Ի�ѡ���
		var sRecovery = PopPage("/RecoveryManage/DistributeManage/RecoveryUserChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
		{
			sRecover = sRecovery.split("@");
			var sRecoverUserID = sRecover[0];
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");	
					sOldRecoverUserID = getItemValue(0,i,"RecoverUserID");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","@String@RecoverUserID@"+sRecoverUserID+"@String@UserChangeFlag@1,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
					sReturn = PopPage("/RecoveryManage/DistributeManage/ChangeManageAction.jsp?OldUserID="+sOldRecoverUserID+"&NewUserID="+sRecoverUserID+"&ObjectNo="+sSerialNo+"&ObjectType=BadBizChangUser","","");	
				}
			}
			reloadSelf();
		}
	}
	
	
	 /*~[Describe=�鿴����������α����¼;InputParam=��;OutPutParam=��;]~*/
	function view_UserChange()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			popComp("ChangeUserList","/RecoveryManage/DistributeManage/ChangeUserList.jsp","ComponentName=�鿴���������α����¼&ObjectType=BadBizChangUser&ObjectNo="+sSerialNo,"","");			
		}
	}
	
	
	/*~[Describe=����Excel;InputParam=��;OutPutParam=��;]~*/
	function export_Excel()
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

<%@include file="/IncludeEnd.jsp"%>