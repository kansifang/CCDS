<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/09/27
*	Tester:
*	Describe: �����ʲ���ͬ�����Ϣ�б�
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ���ͬ�����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sSql1 = "";
	ASResultSet rs1 = null;
	String sOrgFlag = "",sReportType = "";
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
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"CustomerName","�ͻ�����"},
							//{"GuarantorName","����������"},
							{"VouchTypeName","������ʽ"},
							{"BusinessSum","��ͬ���"},
							{"BorrowerManageStatusName","����˾�Ӫ״��"},
							{"BorrowerAssetStatusName","������ʲ�״��"},
							{"BorrowerAttitudeName","�����̬��"},
							{"DebtInstanceName","ծ����ʵ���"},
							{"FactVouchDegreeName","ʵ�ʵ����̶�"},
							{"VouchEffectDate","����ʱЧ"},
							{"LawEffectDate","����ʱЧ"},
							{"ExistNewTypeName","��������"},
							{"Balance","��ǰ���"},					
							{"ClassifyResultName","���շ���"},
							{"BadLoanCaliberName","��������ھ�"},
							{"ShiftTypeName","�ƽ�����"},
							{"RecoveryUserName","������"},
							{"RecoveryOrgName","�������"},
							{"ManageUserName","ԭ�ܻ���"},
							{"ManageOrgName","ԭ�ܻ�����"},
							{"UpdateDate","��󲹵�ʱ��"},
							{"CMonitorDate","�����ʱ��"}
						}; 

 	sSql =  " select SerialNo," + 	
			   " CustomerID,CustomerName," + 
			   " '' as GuarantorName,"+
			   " getItemName('VouchType',VouchType) as VouchTypeName,"+
			   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," +
			   " BusinessSum,nvl(Balance,0) as Balance,"+
			   " getItemName('BorrowerManageStatus',BorrowerManageStatus) as BorrowerManageStatusName," + 
			   " getItemName('BorrowerAssetStatus',BorrowerAssetStatus) as BorrowerAssetStatusName," + 
			   " getItemName('BorrowerAttitude',BorrowerAttitude) as BorrowerAttitudeName," + 
			   " getItemName('DebtInstance',DebtInstance) as DebtInstanceName," + 
			   " getItemName('FactVouchDegree',FactVouchDegree) as FactVouchDegreeName," + 
			   " VouchEffectDate,LawEffectDate," + 
			   " getItemName('ExistNewType',ExistNewType) as ExistNewTypeName," + 
			   " Cancelsum+CancelInterest as CAVSum,"+
			   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,getItemName('BadLoanCaliber',BadLoanCaliber) as BadLoanCaliberName," + 
			   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
			   " getOrgName(RecoveryOrgID) as RecoveryOrgName, " + 
			   " getUserName(RecoveryUserID) as RecoveryUserName," + 
			   " getUserName(ManageUserID) as ManageUserName," + 
			   " getOrgName(ManageOrgID) as ManageOrgName,UpdateDate,CMonitorDate " + 
		    " from BUSINESS_CONTRACT "+
		    " where substr(ClassifyResult,1,2)>'02'";
		   
	//������ͼȡ��ͬ�����	 
	/*
		BadLoanCaliber ��������ھ���ʶ:
					010:���治������
					020:Ʊ���û���������
					030:�ɽ��û���������
					040:�Ѻ�����������
		BadBizProjectFlag ����������Ŀ��ʶ:
					010:һ����Ŀ
					020:�ص���Ŀ
		EMonitorDate ���һ���ص���Ŀ���ʱ��
		CMonitorDate ���һ��һ����Ŀ���ʱ��
						
	*/
	if(sDealType.equals("010010"))//̨����Ϣ����δ����
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and ManageFlag='010' ";
	}else if(sDealType.equals("010020"))//̨����Ϣ�����Ѳ���
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and ManageFlag='080' ";
	}else if(sDealType.equals("030010010"))//���治������һ����δ���
	{
		sSql+=" and (FinishDate is  null or FinishDate ='')  and BadLoanCaliber='010' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "010";
	}else if(sDealType.equals("030010020"))//���治������һ�����Ѽ��
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-90 ";
	}else if(sDealType.equals("030020010"))//���治�������ص���δ���
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "020";
	}else if(sDealType.equals("030020020"))//���治�������ص����Ѽ��
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-90";
	}else if(sDealType.equals("050010010"))//�ɽ��û���������һ����δ���
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "010";
	}else if(sDealType.equals("050010020"))//�ɽ��û���������һ�����Ѽ��
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020'"+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-90";
	}else if(sDealType.equals("050020010"))//�ɽ��û����������ص���δ���
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "020";
	}else if(sDealType.equals("050020020"))//�ɽ��û����������ص����Ѽ��
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-90 ";
	}else if(sDealType.equals("060010010"))//����Ʊ���û���������һ����δ���
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "010";
	}else if(sDealType.equals("060010020"))//����Ʊ���û���������һ�����Ѽ��
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-180 ";
	}else if(sDealType.equals("060020010"))//����Ʊ���û����������ص���δ���
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "020";
	}else if(sDealType.equals("060020020"))//����Ʊ���û����������ص����Ѽ��
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-180";
	}else if(sDealType.equals("040010010"))//�Ѻ�����������һ����δ���
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-180 )";
		sReportType = "010";
	}else if(sDealType.equals("040010020"))//�Ѻ�����������һ�����Ѽ��
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040'"+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-180 ";
	}else if(sDealType.equals("040020010"))//�Ѻ������������ص���δ���
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "020";
	}else if(sDealType.equals("040020020"))//�Ѻ������������ص����Ѽ��
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-180";
	}else if(sDealType.equals("100"))//����ʱЧ������
	{
		sSql+=" and (FinishDate is  null or FinishDate ='')  "+
				" and LawEffectDate is not null and LawEffectDate!='' "+
				" and days(replace(LawEffectDate,'/','-'))<days(current date)";
	}else if(sDealType.equals("110"))//����ʱЧ������
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') "+
		" and VouchEffectDate is not null and VouchEffectDate!='' "+
		" and days(replace(VouchEffectDate,'/','-'))<days(current date)";
	}else
	{
		sSql+=" and 1=2";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("GuarantorName,VouchTypeName,CMonitorDate,ManageUserName,ManageOrgName,RecoveryUserID,RecoveryOrgID,CAVSum,ShiftType,CustomerID,BusinessType,FinishType,FinishDate,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		
    
	if(sDealType.equals("100") || sDealType.equals("110"))
	{
		doTemp.setVisible("CMonitorDate,VouchTypeName",true);
		doTemp.setVisible("UpdateDate,BorrowerManageStatusName,BorrowerAssetStatusName,BorrowerAttitudeName,DebtInstanceName,ExistNewTypeName",false);
	}
	//�����п�
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName,Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,Balance,ActualPutOutSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum,CAVSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,CAVSum,Balance,ActualPutOutSum","3");
	doTemp.setAlign("BusinessTypeName","2");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName","IsFilter","1");
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
		{"false","","Button","һ���ر���","һ���ر���","cMonitor_Report()",sResourcesPath},
		{"false","","Button","�ص��ر���","�ص��ر���","eMonitor_Report()",sResourcesPath},
		{"true","","Button","�ͻ�����","�ͻ�����","customer_Info()",sResourcesPath},
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
		{"false","","Button","̨����Ϣ����","̨����Ϣ����","account_Vindicate()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath},
		};
	//���ݲ�ͬ��ͼ��ʾ��ť
	if(sDealType.equals("010010"))//̨����Ϣ����δ����
	{
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
	}else if(sDealType.equals("010020"))//̨����Ϣ�����Ѳ���
	{
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
	}else if(sDealType.equals("030010010"))//���治������һ����δ���
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر���")][0]="true";
	}else if(sDealType.equals("030010020"))//���治������һ�����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر���")][0]="true";
	}else if(sDealType.equals("030020010"))//���治�������ص���δ���
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر���")][0]="true";
	}else if(sDealType.equals("030020020"))//���治�������ص����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر���")][0]="true";
	}else if(sDealType.equals("050010010"))//�ɽ��û���������һ����δ���
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر���")][0]="true";	
	}else if(sDealType.equals("050010020"))//�ɽ��û���������һ�����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر���")][0]="true";	
	}else if(sDealType.equals("050020010"))//�ɽ��û����������ص���δ���
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر���")][0]="true";	
	}else if(sDealType.equals("050020020"))//�ɽ��û����������ص����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر���")][0]="true";
	}else if(sDealType.equals("060010010"))//����Ʊ���û���������һ����δ���
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر���")][0]="true";
		
	}else if(sDealType.equals("060010020"))//����Ʊ���û���������һ�����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�ͻ�����")][0]="true";
	}else if(sDealType.equals("060020010"))//����Ʊ���û����������ص���δ���
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�ͻ�����")][0]="true";
	}else if(sDealType.equals("060020020"))//����Ʊ���û����������ص����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�ͻ�����")][0]="true";
	}else if(sDealType.equals("040010010"))//�Ѻ�����������һ����δ���
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�ͻ�����")][0]="true";
	}else if(sDealType.equals("040010020"))//�Ѻ�����������һ�����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�ͻ�����")][0]="true";
	}else if(sDealType.equals("040020010"))//�Ѻ������������ص���δ���
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�ͻ�����")][0]="true";
	}else if(sDealType.equals("040020020"))//�Ѻ������������ص����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�ͻ�����")][0]="true";
	}else if(sDealType.equals("100"))//����ʱЧ������
	{
		sButtons[getBtnIdxByName(sButtons,"�ͻ�����")][0]="true";
	}else if(sDealType.equals("110"))//����ʱЧ������
	{
		sButtons[getBtnIdxByName(sButtons,"�ͻ�����")][0]="true";
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
	function cMonitor_Report()
	{
		//��û�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			popComp("MonitorReportList","/RecoveryManage/NPAManage/NPADailyManage/MonitorReportList.jsp","ComponentName=һ���ر����б�&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=�ص��ر���;InputParam=��;OutPutParam=��;]~*/    
	function eMonitor_Report()
	{
		//��û�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			popComp("eMonitorReport","/RecoveryManage/NPAManage/NPADailyManage/eMonitorReportList.jsp","ComponentName=�ص��鱨���б�&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=̨����Ϣά��;InputParam=��;OutPutParam=��;]~*/
	function account_Vindicate()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/AccountVindicateInfo.jsp?SerialNo="+sSerialNo+"&DealType=<%=sDealType%>","_self",""); 
		}
	}
	
	/*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function customer_Info()
	{
		//��ÿͻ����
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");
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