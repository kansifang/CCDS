<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2010/05/25
*	Tester:
*	Describe: �����ʲ�̨�˹������ڲ�������̨��̨����Ϣ�б�
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ڲ�������̨�˼��"; // ��������ڱ��� <title> PG_TITLE </title>
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
						{"InitializeBalance","���������ʼ����"},
						{"ClassifyResult","���շ����ʼ���"},
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
						{"RecoverOrgID","�ֲ����ʲ���������"},
						{"RecoverUserID","�ֲ����ʲ�����Ա"},
						{"RecoverOrgName","�ֲ����ʲ���������"},
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

	sSql = " select SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,FirstPutOutDate,LastMaturity,LoanAccountNo,"+
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
				" FormerManageName,getItemName('BadLoanType',BadLoanType) as BadLoanType,InitializeBalance,"+
				" getItemName('ClassifyResult1',ClassifyResult) as ClassifyResult,DisposeTotalSum,"+
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
		    " where AccountType='010' and StateFlag='10' "+
		    " and BelongOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	//������ͼȡ��ͬ�����	 
	/*
		StateFlag ̨�˽׶�:
					01:δ�Ǽ�
					10:�ѵǼ�
					03:��ȡ��
					80:���ս�		
	*/
	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("BelongOrgID,RelativeContractNo,LoanType,CertType,RecoverOrgID,RecoverUserID,IsFinish,AccountNeedManage,BasicNeedManage",false);
	doTemp.UpdateTable="BADBIZ_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
    
	//�����п�
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");

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
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("RecoverUserName,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,AccountNeedManage,BasicNeedManage,IsFinish,NeedDun,VDMature,LdMature","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
	CurComp.setAttribute("SqlWhereClause",doTemp.WhereClause);
	CurComp.setAttribute("SqlWhereClause1"," where AccountType='010' and StateFlag='10' ");
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
		{"true","","Button","̨�˻�����Ϣ��ά��","̨�˻�����Ϣ��ά��","BadBizListSum1()",sResourcesPath},
		{"true","","Button","������Ϣ��ά��","������Ϣ��ά��","BadBizListSum9()",sResourcesPath},
		{"false","","Button","�������������","�������������","BadBizListSum2()",sResourcesPath},
		{"false","","Button","����ʱЧ������","����ʱЧ������","BadBizListSum3()",sResourcesPath},
		{"false","","Button","����ʱЧ������","����ʱЧ������","BadBizListSum4()",sResourcesPath},
		{"true","","Button","̨�˴��Ǽ�","̨�˴��Ǽ�","BadBizListSum5()",sResourcesPath},
		{"false","","Button","�����ҵ������","�����ҵ������","BadBizListSum6()",sResourcesPath},
		{"false","","Button","�����ʲ���ָ����������","�����ʲ���ָ����������","BadBizListSum7()",sResourcesPath},
		{"false","","Button","�����ʲ���ָ��������","�����ʲ���ָ��������","BadBizListSum8()",sResourcesPath},
		};
	//���ݲ�ͬ��ͼ��ʾ��ť
	if(CurUser.hasRole("410"))//֧���г�
	{
		sButtons[getBtnIdxByName(sButtons,"�������������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����ʱЧ������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����ʱЧ������")][0]="true";
	}else if(CurUser.hasRole("2G1")||CurUser.hasRole("203"))//����֧�б�ȫ������������֧�зֹ��г��������ʲ�����ίԱ������
	{
		sButtons[getBtnIdxByName(sButtons,"�������������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����ʱЧ������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����ʱЧ������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�����ҵ������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�����ʲ���ָ��������")][0]="true";
	}else if(CurUser.hasRole("0G1")||CurUser.hasRole("003"))//���б�ȫ���ܾ��������зֹ��г��������ʲ�����ίԱ�����Σ�
	{
		sButtons[getBtnIdxByName(sButtons,"�������������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����ʱЧ������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����ʱЧ������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�����ҵ������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�����ʲ���ָ����������")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ʲ���ָ��������")][0]="true";
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
	/*~[Describe=����90��δά��̨��;InputParam=��;OutPutParam=��;]~*/
	function BadBizListSum1()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=1&AccountType=010","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=����90��δ����;InputParam=��;OutPutParam=��;]~*/
	function BadBizListSum2()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=2&AccountType=010","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=����ʱЧ������;InputParam=��;OutPutParam=��;]~*/
	function BadBizListSum3()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=3&AccountType=010","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=����ʱЧ������;InputParam=��;OutPutParam=��;]~*/
	function BadBizListSum4()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=4&AccountType=010","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=δ�Ǽ�̨��;InputParam=��;OutPutParam=��;]~*/
	function BadBizListSum5()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=5&AccountType=010","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=δ���������ҵ������;InputParam=��;OutPutParam=��;]~*/
	function BadBizListSum6()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=6&AccountType=010","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=δָ�����������Ĳ�������;InputParam=��;OutPutParam=��;]~*/
	function BadBizListSum7()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=7&AccountType=010","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=δָ�������˵Ĳ�������;InputParam=��;OutPutParam=��;]~*/
	function BadBizListSum8()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=8&AccountType=010","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=������Ϣ��ά��;InputParam=��;OutPutParam=��;]~*/
	function BadBizListSum9()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=9&AccountType=010","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=����Excel;InputParam=��;OutPutParam=��;]~*/
	function export_Excel()
	{
		amarExport("myiframe0");
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