
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

	sSql = " select '' as Status,SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,FirstPutOutDate,LastMaturity,"+
				" CVDate,getItemName('CAVReason',CVReason) as CVReason,CustomerName,"+
				" getItemName('BorrowerManageStatus',CustomerManageStatus) as CustomerManageStatus,"+
				" getItemName('BorrowerAssetStatus',AssetStatus) as AssetStatus,"+
				" getItemName('AlreadyCAVType',CVBadDebtType) as CVBadDebtType,"+
				" FormerManageName,getItemName('FundSource',CVSource) as CVSource,"+
				" getItemName('ExistNewType',ExistOrNewFLag) as ExistOrNewFLag,"+
				" getItemName('TextDocStatus',TextDocStatus) as TextDocStatus,"+
				" CompareDate(VouchMaturity,0,'','��Ч') as VouchEffectDate,"+
				" CompareDate(LastDunDate,0,'','��Ч') as LawEffectDate,"+
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
				" CompareDate(AccountManageDate,30,'1','2','1') as AccountNeedManage,CompareDate(AccountManageDate,30,'��','��','��') as AccountNeedManageName,"+
				" CompareDate(BasicManageDate,90,'1','2','1') as BasicNeedManage,CompareDate(BasicManageDate,90,'��','��','��') as BasicNeedManageName,"+
				" case when LastDunDate is null then CompareDate(LastMaturity,90,'��','��') else CompareDate(LastDunDate,90,'��','��') end as NeedDun,"+
				" case when LastDunDate is null then CompareDate(LastMaturity,600,'��','��') else CompareDate(LastDunDate,600,'��','��') end as VDMature," +
				" CompareDate(VouchMaturity,600,'��','��') as LdMature "+
		    " from BADBIZ_ACCOUNT "+
		    " where AccountType='030' and StateFlag='"+sStateFlag+"' "+
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
	sSql+= "order by SerialNo";
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("BelongOrgID,RelativeContractNo,CertType,RecoverOrgID,RecoverUserID,IsFinish,AccountNeedManage,BasicNeedManage",false);
	doTemp.UpdateTable="BADBIZ_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
	if(sStateFlag.equals("10"))//δ�Ǽ�
	{
		doTemp.setVisible("Status",true);
	}
	//�����п�
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");
	doTemp.setHTMLStyle("Status"," style={width:50px} ");
	doTemp.setAlign("Status","2");
	doTemp.appendHTMLStyle("Status"," style={width:60px} ondblclick=\"javascript:parent.onDBClick()\" ");
	//���ý��Ϊ��λһ������
	doTemp.setType("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,FinalBalance,CleanInterest","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,FinalBalance,CleanInterest","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,FinalBalance,CleanInterest","3");
	
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWCode("IsFinish","YesNo");
	doTemp.setDDDWCode("AccountNeedManage","YesNo");
	doTemp.setDDDWCode("BasicNeedManage","YesNo");
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
	//���ɲ�ѯ��
	if(sStateFlag.equals("01"))//δ�Ǽ�
	{
		doTemp.setColumnAttribute("BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID","IsFilter","1");
	}else if(sStateFlag.equals("10"))//�ѵǼ�
	{
		doTemp.setColumnAttribute("BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,AccountNeedManage,BasicNeedManage,IsFinish,RecoverOrgName,RecoverUserName","IsFilter","1");
	}else if(sStateFlag.equals("03"))//��ȡ��
	{
		doTemp.setColumnAttribute("BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,RecoverOrgName,RecoverUserName","IsFilter","1");
	}else if(sStateFlag.equals("80"))//���ս�
	{
		doTemp.setColumnAttribute("BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,RecoverOrgName,RecoverUserName,BadBizFinishDate","IsFilter","1");
	}else
	{
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
	String[][] sListSumHeaders = {	{"Sum1","�Ѻ������˱���"},
									{"Sum2","�������ջ��Ѻ������˱���ϼ�"},
									{"Sum3","�����ڻ����ʽ��ջ�"},
									{"Sum4","������������ʽ�ջ�"},
									{"Sum5","��ĩ�Ѻ������˱������"},
									{"Sum6","�������ջ��Ѻ���������Ϣ"},
		 };
	String sListSumSql = "Select sum(InitializeBalance) as Sum1,"
						+"Sum(DisposeTotalSum) as Sum2,"
						+"Sum(MoneyReturnSum) as Sum3,"
						+"Sum(OtherReturnSum) as Sum4,"
						+"Sum(FinalBalance) as Sum5,"
						+"Sum(CleanInterest) as Sum6 "
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
		{"false","","Button","��������","��������","viewTab()",sResourcesPath},
		{"false","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath},
		{"false","","Button","̨������","̨������","account_Info()",sResourcesPath},
		{"false","","Button","������Ϣά��","������Ϣά��","account_Maintenance()",sResourcesPath},
		{"false","","Button","̨����Ϣ����","̨����Ϣ����","new_Account()",sResourcesPath},
		{"false","","Button","̨����Ϣȡ��","̨����Ϣȡ��","cancel_Account()",sResourcesPath},
		{"false","","Button","�Ǽ����","�Ǽ����","register_Complete()",sResourcesPath},
		{"false","","Button","�� ��","�ս�","finish_Account()",sResourcesPath},
		{"false","","Button","�� ��","�˻�","untread_Account()",sResourcesPath},
		{"false","","Button","�� ԭ","��ԭ","revert_Account()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath},
		{"true","","Button","����","����","listSum()",sResourcesPath},
		};
	//���ݲ�ͬ��ͼ��ʾ��ť
	if(sStateFlag.equals("01"))//δ�Ǽ�
	{
		sButtons[getBtnIdxByName(sButtons,"������Ϣά��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣȡ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�Ǽ����")][0]="true";
	}else if(sStateFlag.equals("10"))//�ѵǼ�
	{
		sButtons[getBtnIdxByName(sButtons,"������Ϣά��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�� ��")][0]="true";
	}else if(sStateFlag.equals("03"))//��ȡ��
	{
		sButtons[getBtnIdxByName(sButtons,"̨������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�� ԭ")][0]="true";
	}else if(sStateFlag.equals("80"))//���ս�
	{
		sButtons[getBtnIdxByName(sButtons,"��������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�鿴���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�� ԭ")][0]="true";
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
	
	
	/*~[Describe=������Ϣά��;InputParam=��;OutPutParam=��;]~*/
	function account_Maintenance()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			popComp("BadBizAccountInfo","/RecoveryManage/AccountManage/BadBizAccountInfo.jsp","ComponentName=��������̨������&SerialNo="+sSerialNo+"&StateFlag=<%=sStateFlag%>&AccountType=030&AccountEditFlag=01","","");
			reloadSelf();
		}
	}
	
	
	/*~[Describe=̨����Ϣ����;InputParam=��;OutPutParam=��;]~*/
	function new_Account()
	{
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sTableName = "BADBIZ_ACCOUNT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		popComp("BadBizAccountInfo","/RecoveryManage/AccountManage/BadBizAccountInfo.jsp","ComponentName=��������̨������&SerialNo="+sSerialNo+"&StateFlag=<%=sStateFlag%>&AccountType=030&AccountEditFlag=01","","");
		reloadSelf();
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
			popComp("BadBizAccountInfo","/RecoveryManage/AccountManage/BadBizAccountInfo.jsp","ComponentName=��������̨������&SerialNo="+sSerialNo+"&StateFlag=<%=sStateFlag%>&AccountType=030&AccountEditFlag=03","","");
		}
	}
	
	
	/*~[Describe=̨����Ϣȡ��;InputParam=��;OutPutParam=��;]~*/
	function cancel_Account()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else 
		{	
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@03,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//�����ɹ�
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ��
				return;
			}
		}
	}
		
	
	/*~[Describe=�ս�;InputParam=��;OutPutParam=��;]~*/
	function finish_Account()
	{
		if(!selectRecord()) return;
		if(confirm("��ȷ���ս���?"))//�������ɾ������Ϣ��
		{
			//���ж�ѡ���˶����������е��ҳ���
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "��")
				{	
						sSerialNo = getItemValue(0,i,"SerialNo");	
						sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@80@String@BadBizFinishDate@<%=StringFunction.getToday()%>,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
						reloadSelf();
				}
			}
		}
		/*
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else 
		{	
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@80@String@BadBizFinishDate@<%=StringFunction.getToday()%>,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//�����ɹ�
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ��
				return;
			}
		}
		*/
	}
	
	
	/*~[Describe=�Ǽ����;InputParam=��;OutPutParam=��;]~*/
	function register_Complete()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else 
		{	
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@10,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//�����ɹ�
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ��
				return;
			}
		}
	}
	
	
	/*~[Describe=��ԭ;InputParam=��;OutPutParam=��;]~*/
	function revert_Account()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if("<%=sStateFlag%>"=="03")//��ȡ��
		{
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@01,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//�����ɹ�
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ��
				return;
			}
		}else//���ս�
		{	
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@10@String@BadBizFinishDate@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//�����ɹ�
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ��
				return;
			}
		}
	}
	
	
	/*~[Describe=�˻�;InputParam=��;OutPutParam=��;]~*/
	function untread_Account()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if("<%=sStateFlag%>"=="10")//�ѵǼ�
		{
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@01,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//�����ɹ�
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ��
				return;
			}
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{	
		
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}
	
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		//����������͡�������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��ȡ������ˮ��
		sReturn=RunMethod("BadBizManage","GetFinishAccountApplyNo",sSerialNo);
		sReturnInfo=sReturn.split("@")
		if(typeof(sReturnInfo[0])=="undefined" || sReturnInfo[0].length==0 || sReturnInfo[0]=='Null') 
		{	
			alert("��������Ϣ!");
			return;
		}else
		{
			sObjectNo = sReturnInfo[0];
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=BadBizApply&ObjectNo="+sObjectNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}
	}
	
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��ȡ������ˮ��
		sReturn=RunMethod("BadBizManage","GetFinishAccountApplyNo",sSerialNo);
		sReturnInfo=sReturn.split("@")
		if(typeof(sReturnInfo[0])=="undefined" || sReturnInfo[0].length==0 || sReturnInfo[0]=='Null') 
		{
			alert("���������!");
			return;
		}else
		{
			sObjectNo = sReturnInfo[0];
			popComp("ViewBadBizOpinions","/Common/WorkFlow/ViewBadBizOpinions.jsp","FlowNo=BadBizFlow&PhaseNo=0010&ObjectType=BadBizApply&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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