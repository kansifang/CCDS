<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2010/05/25
*	Tester:
*	Describe: ��ծ�ʲ�̨��
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�̨��"; // ��������ڱ��� <title> PG_TITLE </title>
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
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�������
	String sHeaders[][] = {
						{"RefromBAFlag","������Դ"},
						{"SerialNo","��ˮ��"},
						{"BelongOrgID","��ծ�ʲ���������"},
						{"BelongOrgName","��ծ�ʲ���������"},		
						{"AssetName","��ծ�ʲ�����"},
						{"GainDate","ȡ��ʱ��"},
						{"GainType","ȡ�÷�ʽ"},
						{"SitAddress","���䣨���ܣ��ص�"},
						{"AssetStatus","�����յ�ծ�ʲ���״"},
						{"FormerManageName","ԭ����������"},
						{"AssetAna","��������"},
						{"AssetArea","�������(Ķ)"},
						{"PropertyFlag","�Ƿ�������֤"},
						{"GroundTransferFlag","�����Ƿ����"},
						{"ConstructionType","�������彨���ṹ"},
						{"HousePurpose","������;"},
						{"ConstructionArea","�������(ƽ����)"},
						{"PropertyFlag1","�Ƿ��з���֤"},
						{"HouseTransferFlag","�����Ƿ����"},
						{"AssetType","��ծ�������"},
						{"EffectsName","��ծ�������ơ�Ʒ��"},
						{"AssetAmount","��ծ����ʵ������"},
						{"ExistOrNewFLag","(����/����)��ʼ���"},
						{"InitializeBalance","��ծ�ʲ������ʼ���"},
						{"DisposeTotalSum","�����ڵ�ծ�ʲ����úϼ�"},
						{"SaleSum","�����ڵ�ծ�ʲ�����"},
						{"HireSum","�����ڵ�ծ�ʲ�����"},
						{"OtherDisposeSum","�����ڵ�ծ�ʲ�������ʽ����"},
						{"LostSum","�����ڵ�ծ�ʲ�������ʧ"},
						{"ReceiveSum","�����ڵ�ծ�ʲ���������"},
						{"FinalAccountBalance","��ĩ����ծ�ʲ��������"},
						{"FactValue","��ծ�ʲ�����ʵ�ʼ�ֵ"},
						{"CustomerName","��ծ������"},
						{"CertType","��ծ��֤������"},
						{"CertTypeName","��ծ��֤������"},
						{"CertID","��ծ��֤������"},
						{"AccountManageDate","������Ϣ���ά������"},
						{"BasicManageDate","������Ϣ���ά������"},
						{"BadBizFinishDate","�����ս�����"},
						{"RecoverOrgID","�ֵ�ծ�ʲ��������"},
						{"RecoverOrgName","�ֵ�ծ�ʲ��������"},
						{"RecoverUserID","�ֵ�ծ�ʲ�����Ա"},
						{"RecoverUserName","�ֵ�ծ�ʲ�����Ա"},
						{"AccountNeedManage","������Ϣ�Ƿ��ά��"},
						{"AccountNeedManageName","������Ϣ�Ƿ��ά��"},
						{"BasicNeedManage","������Ϣ�Ƿ��ά��"},
						{"BasicNeedManageName","������Ϣ�Ƿ��ά��"},
						{"IsFinish","�Ƿ����ս�"},
						{"IsFinishName","�Ƿ����ս�"},
					}; 

	sSql = " select getItemName('RefromBAFlag',RefromBAFlag) as RefromBAFlag ,SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,"+
			" AssetName,GainDate,getItemName('PDAGainType',GainType) as GainType,SitAddress,"+
			" getItemName('AssetActualStatus',AssetStatus) as AssetStatus,"+
			" FormerManageName,"+
			" getItemName('SoilProperty',AssetAna) as AssetAna,AssetArea,"+
			" getItemName('YesNo',PropertyFlag) as PropertyFlag,"+
			" getItemName('YesNo',GroundTransferFlag) as GroundTransferFlag,"+
			" getItemName('AssetAna',ConstructionType) as ConstructionType,"+
			" getItemName('HousePurpose',HousePurpose) as HousePurpose,ConstructionArea,"+
			" getItemName('YesNo',PropertyFlag1) as PropertyFlag1,"+
			" getItemName('YesNo',HouseTransferFlag) as HouseTransferFlag,"+
			" getItemName('PDAAssetType2',AssetType) as AssetType,EffectsName,AssetAmount,"+
			" getItemName('ExistNewType',ExistOrNewFLag) as ExistOrNewFLag,"+
			" InitializeBalance,DisposeTotalSum,"+
			" SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,"+
			" CustomerName,CertType,getItemName('CertType',CertType) as CertTypeName,CertID,"+
			" AccountManageDate,BasicManageDate,"+
			" BadBizFinishDate,RecoverOrgID,getOrgName(RecoverOrgID) as RecoverOrgName,"+
			" RecoverUserID,getUserName(RecoverUserID) as RecoverUserName,"+
			" CompareDate(AccountManageDate,30,'1','2') as AccountNeedManage,CompareDate(AccountManageDate,30,'��','��') as AccountNeedManageName,"+
			" CompareDate(BasicManageDate,90,'1','2') as BasicNeedManage,CompareDate(BasicManageDate,90,'��','��') as BasicNeedManageName,"+
			" IsFinish,getItemName('YesNo',IsFinish) as IsFinishName "+
		" from BADBIZAPPLY_ACCOUNT "+
		" where AccountType='050' and ObjectNo = '"+sObjectNo+"'";
		   
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
    
	//�����п�
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("ConstructionArea,AssetArea,SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("ConstructionArea,AssetArea,SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","2");
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("ConstructionArea,AssetArea,SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","3");
	
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWCode("IsFinish","YesNo");
	doTemp.setDDDWCode("AccountNeedManage","YesNo");
	doTemp.setDDDWCode("BasicNeedManage","YesNo");
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");

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
		{"true","","Button","����","����","viewTab()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","cancel_Account()",sResourcesPath},
		};
	if("1".equals(sRefromBAFlag)){
		sButtons[0][0] = "true";
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
		sAccountType = "050"
		var sObjectNo = PopComp("SelectBadBizAccount5","/RecoveryManage/AccountApplyManage/SelectBadBizAccount5.jsp","OrgID="+sOrgID+"&AccountType="+sAccountType,"","");
		
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
		popComp("BadBizApplyAccountInfo","/RecoveryManage/AccountApplyManage/BadBizApplyAccountInfo.jsp","ComponentName=��������̨����������&SerialNo="+sSerialNo+"&AccountType=050&RefromBAFlag="+sRefromBAFlag+"&ObjectNo="+sObjectNo,"","");
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
			popComp("BadBizApplyAccountInfo","/RecoveryManage/AccountApplyManage/BadBizApplyAccountInfo.jsp","ComponentName=��������̨������&SerialNo="+sSerialNo+"&AccountType=050&AccountEditFlag=01","","");
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