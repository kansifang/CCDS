<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/10/09
*	Tester:
*	Describe: �����ʲ���̨ͬ����Ϣ�б�
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ���̨ͬ����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sRetractType = "";
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
	//���ҳ�����
			
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�������
	String sHeaders[][] = {
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"BusinessCurrencyName","����"},
							{"CAVSum","�������"},
							{"CAVSum1","�û����"},
							{"BusinessSum","��ͬ���"},
							{"Balance","��ͬ���"},	
							{"ClassifyResultName","���շ���"},
							{"PutOutDate","��ͬ��ʼ��"},
							{"Maturity","��ͬ������"},
							{"OccurTypeName","��������"},
							{"FinishDate","����ʱ��"},
							{"FinishDate1","�û�ʱ��"},
							{"CancelReason","��������"},
							{"BorrowerTypeName","���������"},
							{"BorrowerManageStatusName","����˾�Ӫ״��"},
							{"BorrowerAssetStatusName","������ʲ�״��"},
							{"BorrowerAttitudeName","�����̬��"},
							{"DebtInstanceName","ծ����ʵ���"},
							{"FactVouchDegreeName","ʵ�ʵ����̶�"},
							{"VouchEffectDate","����ʱЧ"},
							{"LawEffectDate","����ʱЧ"},
							{"CancelBadType","�Ѻ����������"},
							{"CancelSumSource","�����ʽ���Դ"},
							{"CancelType","���"},
							{"RetractSum","�����ʽ��ջؽ��"},
							{"OtherRetractSum","�����ջؽ��"},
							{"TextDocStatusName","�ı��������"},
							{"ExistNewTypeName","(����/����)���"},
							{"InterestBalance1","����"},
							{"InterestBalance2","����"},
							{"InterestBalance","��Ƿ��Ϣ"},
							{"ManageUserName","�ܻ���"},
							{"ManageOrgName","�ܻ�����"}
						}; 

 	sSql = " select SerialNo," + 	
			   " CustomerID,CustomerName," + 
			   " getBusinessName(BusinessType) as BusinessTypeName," +
			   " getItemName('VouchType',VouchType) as VouchTypeName,"+
			   " getItemName('Currency',BusinessCurrency) as BusinessCurrencyName,"+
			   " BusinessSum,nvl(Balance,0) as Balance,"+
			   " getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,"+
			   " PutOutDate,Maturity,"+
			   " getItemName('OccurType',OccurType) as OccurTypeName,"+
			   " FinishDate as FinishDate,FinishDate as FinishDate1,' ' as CancelReason,"+
			   " getItemName('BorrowerType',BorrowerType) as BorrowerTypeName," + 
			   " getItemName('BorrowerManageStatus',BorrowerManageStatus) as BorrowerManageStatusName," + 
			   " getItemName('BorrowerAssetStatus',BorrowerAssetStatus) as BorrowerAssetStatusName," + 
			   " getItemName('BorrowerAttitude',BorrowerAttitude) as BorrowerAttitudeName," + 
			   " getItemName('DebtInstance',DebtInstance) as DebtInstanceName," + 
			   " getItemName('FactVouchDegree',FactVouchDegree) as FactVouchDegreeName," + 
			   " VouchEffectDate,LawEffectDate," + 
			   " '' as CancelBadType,' ' as CancelSumSource,' ' as CancelType,"+
			   " getRetractSum(SerialNo) as RetractSum,"+
			   " getOtherRetractSum(SerialNo) as OtherRetractSum,"+
			   " getItemName('TextDocStatus',TextDocStatus) as TextDocStatusName," + 
			   " getItemName('ExistNewType',ExistNewType) as ExistNewTypeName," + 
			   " nvl(InterestBalance1,0) as InterestBalance1,"+
			   " nvl(InterestBalance2,0) as InterestBalance2,"+
			   " nvl(InterestBalance1+InterestBalance2,0) as InterestBalance,"+
			   " nvl(Cancelsum+CancelInterest,0) as CAVSum,"+
			   " nvl(Cancelsum+CancelInterest,0) as CAVSum1,"+
			   " ClassifyResult," + 
			   " getOrgName(ManageOrgID) as ManageOrgName, " + 
			   " getUserName(ManageUserID) as ManageUserName " + 
		    " from BUSINESS_CONTRACT "+
		    " where RecoveryUserID='"+CurUser.UserID+"'"+
		    " and RecoveryOrgID ='"+CurOrg.OrgID+"'"+
		    " and substr(ClassifyResult,1,2)>'02'";
		   
	//������ͼȡ��ͬ�����	 
	/*
		BadBizFinishType �ս�����:
					010:������
					020:Ʊ���û���
					030:�ɽ��û���
					040:������					
	*/
	if(sDealType.equals("010"))//��������̨��
	{
		sSql+= " and (FinishDate is  null or FinishDate ='')  ";
	}else if(sDealType.equals("030"))//�Ѻ�������̨��
	{
		sSql+= " and BadBizFinishType='010' ";
		sRetractType = "010";
	}else if(sDealType.equals("040"))//����Ʊ���û���������̨��
	{
		sSql+= " and BadBizFinishType='020' ";
		sRetractType = "020";
	}else if(sDealType.equals("050"))//�ɽ��û���������̨��
	{
		sSql+= " and BadBizFinishType='030' ";
		sRetractType = "030";
	}else
	{
		sSql+= " and 1=2";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("InterestBalance,InterestBalance2,InterestBalance1,ExistNewTypeName,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerTypeName,BusinessSum,Balance,ClassifyResultName,VouchTypeName,OtherRetractSum,RetractSum,CancelSumSource,CancelBadType,CancelType,FinishDate1,FinishDate,CancelReason,OccurTypeName,RecoveryOrgName,RecoveryUserName,ShiftBalance,CAVSum,CAVSum1,ShiftType,CustomerID,FinishType,FinishDate,ClassifyResult",false);
	//doTemp.setKeyFilter("SerialNo");		
    if(sDealType.equals("010"))//��������̨��
	{
    	doTemp.setVisible("InterestBalance,InterestBalance2,InterestBalance1,ExistNewTypeName,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerTypeName,VouchTypeName,BusinessSum,Balance,ClassifyResultName",true);
	}else if(sDealType.equals("030"))//�Ѻ�������̨��
	{
		doTemp.setVisible("CAVSum,OccurTypeName,FinishDate,CancelReason,CancelBadType,CancelSumSource,CancelType,RetractSum,OtherRetractSum",true);
	}else if(sDealType.equals("040"))//����Ʊ���û���������̨��
	{
		doTemp.setVisible("CAVSum1,OccurTypeName,FinishDate1,RetractSum,OtherRetractSum",true);
	}else if(sDealType.equals("050"))//�ɽ��û���������̨��
	{
		doTemp.setVisible("CAVSum1,OccurTypeName,FinishDate1,RetractSum,OtherRetractSum",true);
	}
	//�����п�
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName,Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("CAVSum,CAVSum1,OtherRetractSum,RetractSum,BusinessSum,InterestBalance1,InterestBalance2,InterestBalance"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("CAVSum,CAVSum1,OtherRetractSum,RetractSum,BusinessSum,ShiftBalance,Balance,ActualPutOutSum,InterestBalance1,InterestBalance2,InterestBalance","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("CAVSum,CAVSum1,OtherRetractSum,RetractSum,BusinessSum,Balance,ActualPutOutSum,CAVSum,InterestBalance1,InterestBalance2,InterestBalance","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("CAVSum,CAVSum1,OtherRetractSum,RetractSum,BusinessSum,CAVSum,Balance,ActualPutOutSum,InterestBalance1,InterestBalance2,InterestBalance","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName","2");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("SerialNo,CustomerName,BusinessTypeName,Balance,ClassifyResultName,PutOutDate,Maturity,BorrowerTypeName,BorrowerAssetStatusName,BorrowerAssetStatusName,BorrowerAttitudeName,DebtInstanceName,FactVouchDegreeName,VouchEffectDate,LawEffectDate,TextDocStatusName","IsFilter","1");
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
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
		{"false","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath},
		{"false","","Button","�����������Ϣ�Ǽ�","�����������Ϣ�Ǽ�","receive_Record()",sResourcesPath},
		{"false","","Button","�û��������Ϣ�Ǽ�","�û��������Ϣ�Ǽ�","receive_Record()",sResourcesPath}
		};
	//���ݲ�ͬ��ͼ��ʾ��ť
	if(sDealType.equals("010"))//��������̨��
	{
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("030"))//�Ѻ�������̨��
	{
		sButtons[getBtnIdxByName(sButtons,"�����������Ϣ�Ǽ�")][0]="true";
	}else if(sDealType.equals("040"))//����Ʊ���û���������̨��
	{
		sButtons[getBtnIdxByName(sButtons,"�û��������Ϣ�Ǽ�")][0]="true";
	}else if(sDealType.equals("050"))//�ɽ��û���������̨��
	{
		sButtons[getBtnIdxByName(sButtons,"�û��������Ϣ�Ǽ�")][0]="true";
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
	/*~[Describe=һ���ر���;InputParam=��;OutPutParam=��;]~*/    
	function receive_Record()
	{
		//��ú�ͬ���
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			popComp("WrtnOffList","/RecoveryManage/AccountManage/WrtnOffList.jsp","ComponentName=̨��ά��������Ϣ�Ǽ��б�&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>&RetractType=<%=sRetractType%>","","");
		}
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