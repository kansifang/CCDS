
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2010/05/25
*	Tester:
*	Describe: �Ѻ�����������̨��
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ѻ�����������̨��"; // ��������ڱ��� <title> PG_TITLE </title>
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
						{"CustomerName","���������"},
						{"CustomerManageStatus","�����˾�Ӫ��״"},
						{"AssetStatus","�������ʲ���״"},
						{"FirstPutOutDate","�״η���ʱ��"},
						{"LastMaturity","�������"},
						{"CVDate","����ʱ��"},
						{"CVReason","��������"},
						{"TextDocStatus","�ı��������"},
						{"LawEffectDate","����ʱЧ"},
						{"VouchEffectDate","����ʱЧ"},
						{"CVBadDebtType","�Ѻ����������"},
						{"FormerManageName","ԭ����������"},
						{"CVSource","�����ʽ���Դ"},
						{"ExistOrNewFLag","(����/����)��ʼ���"},
						{"InitializeBalance","�Ѻ������˱���"},
						{"DisposeTotalSum","�������ջ��Ѻ������˱���ϼ�"},
						{"MoneyReturnSum","�����ڻ����ʽ��ջ�"},
						{"OtherReturnSum","������������ʽ�ջ�"},
						{"FinalBalance","��ĩ�Ѻ������˱������"},
						{"CleanInterest","�������ջ��Ѻ���������Ϣ"},
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

	sSql = " select getItemName('RefromBAFlag',RefromBAFlag) as RefromBAFlag ,SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,FirstPutOutDate,LastMaturity,"+
				" CVDate,getItemName('CAVReason',CVReason) as CVReason,CustomerName,"+
				" getItemName('BorrowerManageStatus',CustomerManageStatus) as CustomerManageStatus,"+
				" getItemName('BorrowerAssetStatus',AssetStatus) as AssetStatus,"+
				" getItemName('AlreadyCAVType',CVBadDebtType) as CVBadDebtType,"+
				" FormerManageName,getItemName('FundSource',CVSource) as CVSource,"+
				" getItemName('ExistNewType',ExistOrNewFLag) as ExistOrNewFLag,"+
				" getItemName('TextDocStatus',TextDocStatus) as TextDocStatus,"+
				" CompareDate(VouchMaturity,0,'','��Ч') as VouchEffectDate,"+
				" CompareDate(LastMaturity,600,'','��Ч') as LawEffectDate,"+
				" InitializeBalance,"+
				" DisposeTotalSum,"+
				" MoneyReturnSum,"+
				" OtherReturnSum,"+
				" FinalBalance,CleanInterest,FactUser,"+
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
		    " from BADBIZAPPLY_ACCOUNT "+
		    " where AccountType='030' and ObjectNo = '"+sObjectNo+"' ";
		   
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
	doTemp.UpdateTable="BADBIZAPPLY_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
    
	//�����п�
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("InitializeBalance,DisposeTotalSum,MoneyReturnSum,FinalBalance,CleanInterest","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("InitializeBalance,DisposeTotalSum,MoneyReturnSum,FinalBalance,CleanInterest","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("InitializeBalance,DisposeTotalSum,MoneyReturnSum,FinalBalance,CleanInterest","3");
	
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
		{"true","","Button","����","����","importAccount()",sResourcesPath},
		{"true","","Button","����","����","new_Account()",sResourcesPath},		
		{"true","","Button","̨������","̨������","viewTab()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","cancel_Account()",sResourcesPath},
		};
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
		sAccountType = "030"
		var sObjectNo = PopComp("SelectBadBizAccount3","/RecoveryManage/AccountApplyManage/SelectBadBizAccount3.jsp","OrgID="+sOrgID+"&AccountType="+sAccountType,"","");
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
		popComp("BadBizApplyAccountInfo","/RecoveryManage/AccountApplyManage/BadBizApplyAccountInfo.jsp","ComponentName=��������̨����������&SerialNo="+sSerialNo+"&AccountType=030&RefromBAFlag="+sRefromBAFlag+"&ObjectNo="+sObjectNo,"","");
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
			popComp("BadBizApplyAccountInfo","/RecoveryManage/AccountApplyManage/BadBizApplyAccountInfo.jsp","ComponentName=��������̨������&SerialNo="+sSerialNo+"&AccountType=030&AccountEditFlag=01","","");
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