<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: zwhu 2010/05/28
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
	String PG_TITLE = "������ڲ�������̨��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>

<%
	//�������	    
	String sSql = "";
	//���������SQL���,��ѯ�����,����ֱ�������ر�־
	//����������:��ͼ�ڵ�,�����ʲ�̨��״̬
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo="";
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType == null) sObjectType="";
	String sRefromBAFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RefromBAFlag"));
	if(sRefromBAFlag == null) sRefromBAFlag="";	
	String sAccountType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	if(sAccountType == null) sAccountType="";		
	
	//���ҳ�����
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�������
	String sHeaders[][] = {
						{"RefromBAFlag","������Դ"},
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

	sSql = " select getItemName('RefromBAFlag',RefromBAFlag) as RefromBAFlag ,SerialNo,RelativeContractNo,BelongOrgID,"+
				" getOrgName(BelongOrgID) as BelongOrgName,FirstPutOutDate,LastMaturity,LoanAccountNo,"+
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
				" CompareDate(AccountManageDate,30,'1','2') as AccountNeedManage,CompareDate(AccountManageDate,30,'��','��') as AccountNeedManageName,"+
				" CompareDate(BasicManageDate,90,'1','2') as BasicNeedManage,CompareDate(BasicManageDate,90,'��','��') as BasicNeedManageName,"+
				" CompareDate(LastDunDate,90,'��','��') as NeedDun,"+
				" CompareDate(VouchMaturity,600,'��','��') as VDMature,"+
				" CompareDate(LastDunDate,600,'��','��') as LdMature " +  
		    " from BADBIZApply_ACCOUNT "+
		    " where AccountType='010' and ObjectNo = '"+sObjectNo+"'";
		if("1".equals(sRefromBAFlag)){
			String sWhereCause = "and (RefromBAFlag = '1' or RefromBAFlag = '3') ";
			sSql = sSql + sWhereCause;
		}else{
			String sWhereCause = "and RefromBAFlag = '2' ";
			sSql = sSql + sWhereCause;
		}   
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
	doTemp.UpdateTable="BADBIZAPPLY_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
    if("2".equals(sRefromBAFlag)){
    	doTemp.setVisible("RefromBAFlag",false);
    }
	//�����п�
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","3");
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

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
		{"false","","Button","����","����","importAccount()",sResourcesPath},
		{"true","","Button","����","����","new_Account()",sResourcesPath},		
		{"true","","Button","̨������","̨������","viewTab()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","cancel_Account()",sResourcesPath},
		};
	if("1".equals(sRefromBAFlag)){
		sButtons[0][0] = "true";
	}	
	if("050".equals(sAccountType)){
		sButtons[1][0] = "false";
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
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function importAccount(){
		sOrgID = "<%=CurOrg.OrgID%>";
		sAccountType = "010"
		var sObjectNo = PopComp("SelectBadBizAccount1","/RecoveryManage/AccountApplyManage/SelectBadBizAccount1.jsp","OrgID="+sOrgID+"&AccountType="+sAccountType,"","");
		if(sObjectNo == "" || sObjectNo == "_CANCEL_" || sObjectNo == "_NONE_" || sObjectNo == "_CLEAR_" || typeof(sObjectNo) == "undefined")
			return;
		else{
			sObjectNoArray = sObjectNo.split("@");
			sObjectNo = sObjectNoArray[0];
			sReturn = RunMethod("BadBizManage","CopyBadBizAccount",sObjectNo+","+"<%=sObjectNo%>");
			if(sObjectNo == "" || sObjectNo == "_CANCEL_" || sObjectNo == "_NONE_" || sObjectNo == "_CLEAR_" || typeof(sObjectNo) == "undefined"){
				return;
			}
			else{
				reloadSelf();
			}
		}
	}
	
	
	/*~[Describe=̨����Ϣ����;InputParam=��;OutPutParam=��;]~*/
	function new_Account()
	{
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sTableName = "BADBIZAPPLY_ACCOUNT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		sRefromBAFlag = "<%=sRefromBAFlag%>";
		sObjectNo = "<%=sObjectNo%>";
		popComp("BadBizApplyAccountInfo","/RecoveryManage/AccountApplyManage/BadBizApplyAccountInfo.jsp","ComponentName=��������̨����������&SerialNo="+sSerialNo+"&AccountType=010&RefromBAFlag="+sRefromBAFlag+"&ObjectNo="+sObjectNo,"","");
		reloadSelf();
	}
	

	/*~[Describe=̨����Ϣȡ��;InputParam=��;OutPutParam=��;]~*/
	function cancel_Account()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
   		{
   			as_del('myiframe0');
   			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
   		}		
	}
		
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			popComp("BadBizApplyAccountInfo","/RecoveryManage/AccountApplyManage/BadBizApplyAccountInfo.jsp","ComponentName=��������̨������&SerialNo="+sSerialNo+"&AccountType=010&AccountEditFlag=01","","");
			reloadSelf();
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