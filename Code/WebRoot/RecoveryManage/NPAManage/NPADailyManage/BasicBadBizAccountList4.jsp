<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2010/05/25
*	Tester:
*	Describe: �ʽ��û���������̨��
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ʽ��û���������̨��"; // ��������ڱ��� <title> PG_TITLE </title>
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
						{"SerialNo","̨����ˮ��"},
						{"BelongOrgID","�����ʲ���������"},
						{"BelongOrgName","�����ʲ���������"},
						{"FirstPutOutDate","�״η�����"},
						{"LastMaturity","�������"},
						{"loanAccountNo","�����ʺ�"},
						{"LoanType","���ʽ"},
						{"CustomerName","���������"},
						{"CustomerType","��������"},
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
						{"MetathesisType","�û��ʽ����"},
						{"InitializeBalance","�ʽ��û�����������ڳ����"},
						{"ClassifyResult","���շ����ʼ���"},
						{"DisposeTotalSum","���������մ��ñ���ϼ�"},
						{"MoneyReturnSum","�����ڻ����ʽ��ջ�"},
						{"ReformSBSum","����������ת��"},
						{"OtherReturnSum","������������ʽ�ջ�"},
						{"CleanInterest","������������Ϣ"},
						{"FinalBalance","��ĩ��Ƿ�������"},
						{"FinalInterest","��ĩ��Ƿ��Ϣ���"},
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
						{"RecoverOrgName","�ֲ����ʲ��������"},
						{"RecoverUserID","�ֲ����ʲ�����Ա"},
						{"RecoverUserName","�ֲ����ʲ�����Ա"},
						{"IsFinish","�Ƿ��ս�"},
						{"IsFinishName","�Ƿ��ս�"},
						{"AccountNeedManage","������Ϣ�Ƿ��ά��"},
						{"AccountNeedManageName","������Ϣ�Ƿ��ά��"},
						{"BasicNeedManage","������Ϣ�Ƿ��ά��"},
						{"BasicNeedManageName","������Ϣ�Ƿ��ά��"},
						{"NeedDun","�Ƿ�����մ���"},
						{"VDMature","����ʱЧ�Ƿ���"},
						{"LdMature","����ʱЧ�Ƿ���"},
					}; 

	sSql = " select '' as Status,SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,FirstPutOutDate,LastMaturity,LoanAccountNo,"+
			" getItemName('VouchType2',LoanType) as LoanType,CustomerName,"+
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
			" getItemName('MetathesisType',MetathesisType) as MetathesisType,FormerManageName,InitializeBalance,"+
			" getItemName('ClassifyResult1',ClassifyResult) as ClassifyResult,DisposeTotalSum,"+
			" MoneyReturnSum,ReformSBSum,"+
			" OtherReturnSum,CleanInterest,"+
			" FinalBalance,FinalInterest,FactUser,"+
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
		" where AccountType='040' and StateFlag='10' "+
		" and RecoverUserID='"+CurUser.UserID+"'"+
		" and RecoverOrgID='"+CurOrg.OrgID+"'";
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
	doTemp.setVisible("BelongOrgID,RelativeContractNo,CertType,RecoverOrgID,RecoverUserID,IsFinish,AccountNeedManage,BasicNeedManage",false);
	doTemp.UpdateTable="BADBIZ_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
	//����html���
	doTemp.setAlign("Status","2");
	doTemp.appendHTMLStyle("Status"," style={width:60px} ondblclick=\"javascript:parent.onDBClick()\" ");
	//�����п�
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("CleanInterest,OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest,ReformSBSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("CleanInterest,OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest,ReformSBSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("CleanInterest,OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest,ReformSBSum","3");
	
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWCode("IsFinish","YesNo");
	doTemp.setDDDWCode("AccountNeedManage","YesNo");
	doTemp.setDDDWCode("BasicNeedManage","YesNo");
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("NeedDun,VDMature,LdMature,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,AccountNeedManage,BasicNeedManage,IsFinish,NeedDun,VDMature,LdMature","IsFilter","1");
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
	String[][] sListSumHeaders = {	{"Sum1","���������մ��ñ���ϼ�"},
									{"Sum2","�����ڻ����ʽ��ջ�"},
									{"Sum3","����������ת��"},
									{"Sum4","������������ʽ�ջ�"},
									{"Sum5","������������Ϣ"},
									{"Sum6","��ĩ��Ƿ�������"},
									{"Sum7","��ĩ��Ƿ��Ϣ���"},
		 };
	String sListSumSql = "Select "
						+"Sum(DisposeTotalSum) as Sum1,"
						+"Sum(MoneyReturnSum) as Sum2,"
						+"Sum(ReformSBSum) as Sum3,"
						+"Sum(OtherReturnSum) as Sum4,"
						+"Sum(CleanInterest) as Sum5,"
						+"Sum(FinalBalance) as Sum6,"
						+"Sum(FinalInterest) as Sum7 "
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
		{"true","","Button","������Ϣά��","������Ϣά��","bAccount_Maintenance()",sResourcesPath},
		//{"true","","Button","�� ��","�˻�","untread_Account()",sResourcesPath},
		{"true","","Button","���յǼ�","���յǼ�","dun_Note()",sResourcesPath},
		{"true","","Button","����","����","listSum()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath},
		};
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
	/*~[Describe=�һ�ѡ���̨��;InputParam=��;OutPutParam=��;]~*/
	function onDBClick()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus)=="undefined" || sStatus=="")
			setItemValue(0,getRow(),"Status","��");
		else
			setItemValue(0,getRow(),"Status","");

	}
	
	
	/*~[Describe=������Ϣά��;InputParam=��;OutPutParam=��;]~*/
	function bAccount_Maintenance()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			popComp("BadBizAccountInfo","/RecoveryManage/AccountManage/BadBizAccountInfo.jsp","ComponentName=��������̨������&SerialNo="+sSerialNo+"&StateFlag=<%=sStateFlag%>&AccountType=040&AccountEditFlag=02","","");
			reloadSelf();
		}
	}
	
	
	/*~[Describe=�˻�;InputParam=��;OutPutParam=��;]~*/
	function untread_Account()
	{
		if(!selectRecord()) return;	
		//���ж�ѡ���˶����������е��ҳ���
		var b = getRowCount(0);
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"Status");
			if(a == "��")
			{	
				sSerialNo = getItemValue(0,i,"SerialNo");
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverUserID@None@String@ReturnFlag@1,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			}
		}
		reloadSelf();
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
	
	
	/*~[Describe=���պ�����;InputParam=��;OutPutParam=��;]~*/
	function dun_Note()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("DunList","/RecoveryManage/DunManage/DunList.jsp","ObjectType=BadBizAccount&ObjectNo="+sSerialNo,"_blank",OpenStyle);
			reloadSelf();
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