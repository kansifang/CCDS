<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
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
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�ܻ��Ĳ����ʲ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	/*~END~*/
%>         
       
                      
<%
                                      	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
                                      %>
<%
	String sHeaders[][] = {
					{"SerialNo","��ͬ��ˮ��"},										
					{"BusinessType","ҵ��Ʒ��"},
					{"BusinessTypeName","ҵ��Ʒ��"},
					{"OccurType","��������"},
					{"OccurTypeName","��������"},
					{"CustomerName","�ͻ�����"},
					{"BusinessCurrencyName","����"},
					{"BusinessSum","���"},
					{"ActualPutOutSum","��ʵ�ʳ��˽��"},
					{"Balance","��ǰ���"},
					{"ShiftBalance","�ƽ����"},
					{"FinishType","�ս�����"},
					{"FinishTypeName","�ս�����"},
					{"FinishDate","�ս�����"},							
					{"ClassifyResult","�弶����"},
					{"ClassifyResultName","�弶����"},
					{"Maturity","��������"},
					{"ManageUserName","ԭ�ܻ���"},
					{"ManageOrgName","ԭ�ܻ�����"},
					{"RecoveryUserName","��ȫ�ܻ���"}
				}; 

 	String sSql = "select SerialNo," + 							 	
		 " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		 " OccurType,getItemName('OccurType',OccurType) as OccurTypeName," + 
		 " CustomerName," + 
		 " BusinessCurrency,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		 " BusinessSum," + 
		 " ActualPutOutSum," + 
		 " ShiftBalance,Balance," + 
		 " FinishType,getItemName('FinishType',FinishType) as FinishTypeName," + 
		 " FinishDate," + 				
		 " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName," + 
		 " Maturity," +  
		 " getUserName(ManageUserID) as ManageUserName," + 
		 " getOrgName(ManageOrgID) as ManageOrgName," + 
		 " getUserName(RecoveryUserID) as RecoveryUserName" + 
		 " from BUSINESS_CONTRACT" +
		 " Where RecoveryUserID  is not null And ShiftType ='02' " ;     //�ƽ�����Ϊ02-�ͻ��ƽ�

	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setKeyFilter("SerialNo");
	doTemp.setHeader(sHeaders);	

	//����ѡ��˫�����п�	
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("OccurTypeName,Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:80px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("Balance,ShiftBalance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	doTemp.setVisible("BusinessType,OccurType,FinishType,ClassifyResult,BusinessCurrency",false);	

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,Balance,ShiftBalance,ActualPutOutSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance,ShiftBalance,ActualPutOutSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,Balance,ShiftBalance,ActualPutOutSum,OperateUserName,OperateOrgName","3");
	
	//���ɲ�ѯ��
	doTemp.setDDDWCode("OccurType","OccurType");
	doTemp.setDDDWCode("FinishType","FinishType");
	doTemp.setDDDWCode("ClassifyResult","ClassifyResult");	
	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","BusinessTypeName","");
	doTemp.setFilter(Sqlca,"4","OccurType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","FinishType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"6","ClassifyResult","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"7","RecoveryUserName","");
	doTemp.setFilter(Sqlca,"8","ManageOrgName","");
	doTemp.setFilter(Sqlca,"9","ManageUserName","");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	dwTemp.setPageSize(16); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
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
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath}
		};
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	//�鿴��ͬ����
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ú�ͬ��ˮ��
		var sContractNo=getItemValue(0,getRow(),"SerialNo");  
		
		//���ҵ��Ʒ��
		var sBusinessType=getItemValue(0,getRow(),"BusinessType"); 
		if (typeof(sContractNo)=="undefined" || sContractNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		else
		{
			
			if(sBusinessType=="8010" || sBusinessType=="8020" || sBusinessType=="8030")
			{
				OpenComp("DataInputDetailInfo","/InfoManage/DataInput/DataInputDetailInfo.jsp","ComponentName=�б�?&ComponentType=MainWindow&SerialNo="+sContractNo+"&Flag=Y&CurItemDescribe3="+sBusinessType+"","_blank",OpenStyle);
			}
			else
			{
			  	sObjectType = "AfterLoan";
				sObjectNo = sContractNo;
				sViewID = "001";
				
				openObject(sObjectType,sObjectNo,sViewID);
			}
		}
	}
</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>


<%@include file="/IncludeEnd.jsp"%>
