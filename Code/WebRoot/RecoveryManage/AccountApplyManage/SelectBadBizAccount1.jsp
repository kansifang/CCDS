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
<%
	//�������	    
	String sSql = "";
	//���������SQL���,��ѯ�����,����ֱ�������ر�־
	//����������:��ͼ�ڵ�,�����ʲ�̨��״̬
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sOrgID == null) sOrgID="";
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
				" CompareDate(AccountManageDate,30,'1','2') as AccountNeedManage,CompareDate(AccountManageDate,30,'��','��') as AccountNeedManageName,"+
				" CompareDate(BasicManageDate,90,'1','2') as BasicNeedManage,CompareDate(BasicManageDate,90,'��','��') as BasicNeedManageName,"+
				" CompareDate(LastDunDate,90,'��','��') as NeedDun,"+
				" CompareDate(VouchMaturity,600,'��','��') as VDMature,"+
				" CompareDate(LastDunDate,600,'��','��') as LdMature " +  
		    " from BADBIZ_ACCOUNT "+
		    " where AccountType='010' and StateFlag='10' "+
		    " and BelongOrgID in(Select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
		   
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
	doTemp.setVisible("ClassifyResult,BadLoanType,BelongOrgID,RelativeContractNo,LoanType,CertType,RecoverOrgID,RecoverUserID,IsFinish,AccountNeedManage,BasicNeedManage",false);
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
	doTemp.setDDDWCode("ClassifyResult","ClassifyResult1");
	doTemp.setDDDWCode("BadLoanType","BadLoanType");
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
	//���ɲ�ѯ��

	doTemp.setColumnAttribute("SerialNo,ClassifyResult,BadLoanType,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,AccountNeedManage,BasicNeedManage,IsFinish,RecoverOrgID,RecoverUserID","IsFilter","1");
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
		{"true","","Button","ȷ��","ȷ��","doReturn()",sResourcesPath},
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
	function doReturn(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			self.returnValue=sSerialNo;//���ز���
			self.close();
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

<%@include file="/IncludeEnd.jsp"%>