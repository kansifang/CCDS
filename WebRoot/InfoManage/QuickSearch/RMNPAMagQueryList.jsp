<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
		Author: FSGong  2005-01-26
	
		Tester:
		Describe: �ܻ��Ĳ����ʲ����ٲ�ѯ
		Input Param:
		Output Param:     
		HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ܻ��Ĳ����ʲ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%/*~END~*/%>         
       
                      
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","��ͬ��ˮ��"},				
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},
							{"CustomerName","�ͻ�����"},
							{"BusinessCurrencyName","����"},
							{"BusinessSum","���"},
							{"ShiftBalance","�ƽ����"},
							{"Balance","��ǰ���"},
							{"CAVSum","�������"},
							{"Maturity","��������"},							
							{"ClassifyResultName","�弶����"},							
							{"ShiftTypeName","�ƽ�����"},
							{"ManageUserName","ԭ�ܻ���"},
							{"ManageOrgName","ԭ�ܻ�����"}
						}; 

 	String sSql = " select SerialNo," + 	
		   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		   " getItemName('OccurType',OccurType) as OccurTypeName," + 
		   " CustomerID,CustomerName,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		   " BusinessSum,ShiftBalance,Balance, Cancelsum+CancelInterest as CAVSum,Maturity,"+
		   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName," + 
		   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
		   " getUserName(ManageUserID) as ManageUserName," + 
		   " getOrgName(ManageOrgID) as ManageOrgName,RecoveryUserID,RecoveryOrgID " + 
		   " from BUSINESS_CONTRACT "+
		   " where RecoveryUserID='"+CurUser.UserID+"'"+
		   " and RecoveryOrgID ='"+CurOrg.OrgID+"'"+
		   " and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='')" ;
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("RecoveryUserID,RecoveryOrgID,ShiftBalance,CAVSum,ShiftType,CustomerID,BusinessType,FinishType,FinishDate,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		
    
	//�����п�
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName,Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum,CAVSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,CAVSum,Balance,ActualPutOutSum","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName","2");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
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
		{"true","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath},
		};
%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����Excel;InputParam=��;OutPutParam=��;]~*/
	function export_Excel()
	{
		amarExport("myiframe0");
	}
		
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@include file="/IncludeEnd.jsp"%>
