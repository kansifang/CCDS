<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/09/16
*	Tester:
*	Describe: �����ʲ���ͬ��Ϣ�б�
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ���ͬ��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"PutOutDate","��ͬ��ʼ��"},
							{"Maturity","��ͬ������"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},
							{"CustomerName","�ͻ�����"},
							{"BusinessCurrencyName","����"},
							{"BusinessSum","��ͬ���"},
							{"ShiftBalance","�ƽ����"},
							{"FactUser","ʵ���ÿ���"},
							{"FirstPutoutDate","�״η�����"},
							{"LastMaturity","�������"},
							{"BorrowerTypeName","���������"},
							{"BorrowerManageStatusName","����˾�Ӫ״��"},
							{"BorrowerAssetStatusName","������ʲ�״��"},
							{"BorrowerAttitudeName","�����̬��"},
							{"DebtInstanceName","ծ����ʵ���"},
							{"FactVouchDegreeName","ʵ�ʵ����̶�"},
							{"VouchEffectDate","����ʱЧ"},
							{"LawEffectDate","����ʱЧ"},
							{"TextDocStatus","�ı��������"},
							{"ExistNewTypeName","����/��������"},
							{"Balance","��ǰ���"},					
							{"ClassifyResultName","���շ���"},
							{"BadLoanCaliberName","��������ھ�"},
							{"InterestBalance1","����ǷϢ"},
							{"InterestBalance2","����ǷϢ"},
							{"ShiftTypeName","�ƽ�����"},
							{"MendInputUserName","�Ǽ���"},
							{"MendInputOrgName","�Ǽǻ���"},
							{"BadBizProjectFlagName","��Ŀ����"},
							{"BadBizFinishTypeName","�ս�����"},
							{"RecoveryUserName","����������"},
							{"RecoveryOrgName","�������"},
							{"ManageUserName","ԭ�ܻ���"},
							{"ManageOrgName","ԭ�ܻ�����"},
							{"DunTimes","���մ���"},
							{"RecentDunDate","�����������"},
							{"ApplyDate","��������"},
							{"FinishDate","��������"},
							{"CMonitorDate","���ʱ��"},
							{"EMonitorDate","���ʱ��"}
						}; 

 	sSql = " select SerialNo,RelativeSerialNo,PutOutDate,Maturity," + 	
		   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		   " getItemName('OccurType',OccurType) as OccurTypeName," + 
		   " CustomerID,CustomerName,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		   " BusinessSum,ShiftBalance,nvl(Balance,0) as Balance,FactUser,"+
		   " FirstPutoutDate,LastMaturity,getItemName('BorrowerType',BorrowerType) as BorrowerTypeName,"+
		   " getItemName('BorrowerManageStatus',BorrowerManageStatus) as BorrowerManageStatusName," + 
		   " getItemName('BorrowerAssetStatus',BorrowerAssetStatus) as BorrowerAssetStatusName," + 
		   " getItemName('BorrowerAttitude',BorrowerAttitude) as BorrowerAttitudeName," + 
		   " getItemName('DebtInstance',DebtInstance) as DebtInstanceName," + 
		   " getItemName('FactVouchDegree',FactVouchDegree) as FactVouchDegreeName," + 
		   " VouchEffectDate,LawEffectDate,getItemName('TextDocStatus',TextDocStatus) as TextDocStatus," + 
		   " getItemName('ExistNewType',ExistNewType) as ExistNewTypeName," + 
		   " Cancelsum+CancelInterest as CAVSum,"+
		   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,getItemName('BadLoanCaliber',BadLoanCaliber) as BadLoanCaliberName," + 
		   " nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
		   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
		   " getUserName(RecoveryUserID) as MendInputUserName," + 
		   " getOrgName(RecoveryOrgID) as MendInputOrgName,"+
		   " getItemName('BadBizProjectFlag',BadBizProjectFlag) as BadBizProjectFlagName,"+
		   " getItemName('BadBizFinishType',BadBizFinishType) as BadBizFinishTypeName,"+
		   " getUserName(RecoveryUserID) as RecoveryUserName," + 
		   " getOrgName(RecoveryOrgID) as RecoveryOrgName,"+
		   " getUserName(ManageUserID) as ManageUserName," + 
		   " getOrgName(ManageOrgID) as ManageOrgName,getDunTimes(SerialNo) as DunTimes,"+
		   " getRecentDunDate(SerialNo) as RecentDunDate,getFCApplyDate(SerialNo) as ApplyDate,FinishDate, " +
		   " CMonitorDate,EMonitorDate "+
		   " from BUSINESS_CONTRACT BC"+
		   " where RecoveryUserID='"+CurUser.UserID+"'"+
		   " and RecoveryOrgID ='"+CurOrg.OrgID+"'";
		   
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
	if(sDealType.equals("010"))//���ս�ֹܲ���������Ϣ
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and FinishDate is not null and FinishDate !=''  ";
	}else if(sDealType.equals("020"))//  δ�ս�ֹܲ���������Ϣ
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') ";
	}else if(sDealType.equals("020002"))//  �ճ����չ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') ";
	}else if(sDealType.equals("020010010"))//̨����Ϣ����δ����
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and ManageFlag='010' ";
	}else if(sDealType.equals("020010020"))//̨����Ϣ�����Ѳ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and ManageFlag='080' ";
	}else if(sDealType.equals("020020010"))//���ʽ����δ����
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') ";
	}else if(sDealType.equals("020020020"))//���ʽ�����Ѳ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') ";
	}else if(sDealType.equals("020030010010010"))//���治������һ����δ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='')  and BadLoanCaliber='010' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "010";
	}else if(sDealType.equals("020030010010020"))//���治������һ�����Ѽ��
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-90 ";
	}else if(sDealType.equals("020030010020010"))//���治�������ص���δ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "020";
	}else if(sDealType.equals("020030010020020"))//���治�������ص����Ѽ��
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-90";
	}else if(sDealType.equals("020030020010010"))//�ɽ��û���������һ����δ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "010";
	}else if(sDealType.equals("020030020010020"))//�ɽ��û���������һ�����Ѽ��
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020'"+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-90";
	}else if(sDealType.equals("020030020020010"))//�ɽ��û����������ص���δ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "020";
	}else if(sDealType.equals("020030020020020"))//�ɽ��û����������ص����Ѽ��
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-90 ";
	}else if(sDealType.equals("020030030010010"))//����Ʊ���û���������һ����δ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "010";
	}else if(sDealType.equals("020030030010020"))//����Ʊ���û���������һ�����Ѽ��
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-180 ";
	}else if(sDealType.equals("020030030020010"))//����Ʊ���û����������ص���δ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "020";
	}else if(sDealType.equals("020030030020020"))//����Ʊ���û����������ص����Ѽ��
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-180";
	}else if(sDealType.equals("020030040010010"))//�Ѻ�����������һ����δ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-180 )";
		sReportType = "010";
	}else if(sDealType.equals("020030040010020"))//�Ѻ�����������һ�����Ѽ��
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040'"+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-180 ";
	}else if(sDealType.equals("020030040020010"))//�Ѻ������������ص���δ���
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "020";
	}else if(sDealType.equals("020030040020020"))//�Ѻ������������ص����Ѽ��
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-180";
	}else if(sDealType.equals("020040010"))//δת��
	{
		sSql+=" and substr(ClassifyResult,1,2) in('01','02') ";
	}else if(sDealType.equals("020040020"))//��ת��
	{
		sSql+=" and ManageFlag = '090' ";
	}else
	{
		sSql+=" and 1=2";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("RelativeSerialNo,CMonitorDate,EMonitorDate,MendInputUserName,MendInputOrgName,TextDocStatus,BorrowerTypeName,FirstPutoutDate,LastMaturity,FactUser,ApplyDate,FinishDate,BadBizFinishTypeName,RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName,ExistNewTypeName,LawEffectDate,VouchEffectDate,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerAssetStatusName,BorrowerManageStatusName,CAVSum,BusinessSum,BadLoanCaliberName,InterestBalance1,InterestBalance2,BusinessCurrencyName,BusinessTypeName,PutOutDate,Maturity,RecentDunDate,DunTimes,ManageUserName,ManageOrgName,OccurTypeName,ShiftBalance,ShiftType,CustomerID,BusinessType,FinishType,FinishDate,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		
    //���ò����ø�ʽ
    if(sDealType.equals("010"))
    {
    	doTemp.setHeader("Balance","�ս����");
    	doTemp.setVisible("ApplyDate,FinishDate,BadBizFinishTypeName,RecoveryUserName,RecoveryOrgName",true);
    }else if(sDealType.equals("020"))//  δ�ս�ֹܲ���������Ϣ
	{
    	doTemp.setVisible("RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName,OccurTypeName,BusinessSum,InterestBalance1,InterestBalance2,BusinessCurrencyName,BusinessTypeName,PutOutDate,Maturity,RecentDunDate,DunTimes",true);
	}else if(sDealType.equals("020002"))//  �ճ����չ���
	{
    	doTemp.setVisible("RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName,OccurTypeName,BusinessSum,InterestBalance1,InterestBalance2,BusinessCurrencyName,BusinessTypeName,PutOutDate,Maturity,RecentDunDate,DunTimes",true);
	}else if(sDealType.equals("020010010"))//̨����Ϣ����δ����
	{
		doTemp.setVisible("MendInputUserName,MendInputOrgName,RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName,ExistNewTypeName,TextDocStatus,LawEffectDate,VouchEffectDate,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerAssetStatusName,BorrowerManageStatusName,BorrowerTypeName,FirstPutoutDate,LastMaturity,FactUser,BusinessSum,BadLoanCaliberName",true);
	}else if(sDealType.equals("020010020"))//̨����Ϣ�����Ѳ���
	{
		doTemp.setHeader("MendInputUserName","ά����");
		doTemp.setHeader("MendInputOrgName","ά������");
		doTemp.setVisible("MendInputUserName,MendInputOrgName,RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName,ExistNewTypeName,TextDocStatus,LawEffectDate,VouchEffectDate,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerAssetStatusName,BorrowerManageStatusName,BorrowerTypeName,FirstPutoutDate,LastMaturity,FactUser,BusinessSum,BadLoanCaliberName",true);
	}else if(sDealType.length()>6&&sDealType.substring(0,6).equals("020030"))//�ճ���ع���
	{	
		doTemp.setHeader("MendInputUserName","�����");
		doTemp.setHeader("MendInputOrgName","��ػ���");
		doTemp.setVisible("MendInputUserName,MendInputOrgName,ExistNewTypeName,TextDocStatus,LawEffectDate,VouchEffectDate,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerAssetStatusName,BorrowerManageStatusName,BorrowerTypeName,FirstPutoutDate,LastMaturity,FactUser,BusinessSum,BadLoanCaliberName",true);
		System.out.println(sDealType.substring(9,12)+"@@@@@@@@@@");
		if(sDealType.length()>12&&sDealType.substring(9,12).equals("010"))
		{
			doTemp.setVisible("CMonitorDate",true);
		}else
		{
			doTemp.setVisible("EMonitorDate",true);
		}
	}
	//�����п�
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance,InterestBalance1,InterestBalance2"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("MendInputOrgName,RecoveryOrgName,ManageOrgName"," style={width:250px} ");
	doTemp.setHTMLStyle("MendInputUserName,RecoveryUserName,ManageUserName"," style={width:60px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum,InterestBalance1,InterestBalance2","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum,InterestBalance1,InterestBalance2","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,Balance,ActualPutOutSum,InterestBalance1,InterestBalance2","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName","2");
	
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
		{"false","","Button","�������յǼ�","�������յǼ�","dun_Note()",sResourcesPath},
		{"false","","Button","��Ϣ���Ǽ�ά��","��Ϣ���Ǽ�ά��","account_Vindicate()",sResourcesPath},
		{"false","","Button","����һ���ر���","����һ���ر���","cMonitor_Report()",sResourcesPath},
		{"false","","Button","һ���ر�������","һ���ر�������","cMonitor_Report()",sResourcesPath},
		{"false","","Button","�����ص��ر���","�����ص��ر���","eMonitor_Report()",sResourcesPath},
		{"false","","Button","�ص��ر�������","�ص��ر�������","eMonitor_Report()",sResourcesPath},
		{"false","","Button","�ͻ�����","�ͻ�����","customer_Info()",sResourcesPath},
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
		{"false","","Button","̨����Ϣ����","̨����Ϣ����","account_Vindicate()",sResourcesPath},
		{"false","","Button","�ս���������","�ս���������","finishApply_Info()",sResourcesPath},
		{"false","","Button","�ս���������","�ս���������","finishApprove_Info()",sResourcesPath},
		{"true","","Button","�����������","�����������","view_Opinions()",sResourcesPath},
		{"false","","Button","�������","�������","mend_Complete()",sResourcesPath},
		{"false","","Button","��ɼ��","��ɼ��","monitor_Complete()",sResourcesPath},
		{"false","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath},
		{"false","","Button","ת��","����ͬ�˻ظ�ԭ�ܻ���","my_ReverseHandover()",sResourcesPath}
		};
	//���ݲ�ͬ��ͼ��ʾ��ť
	if(sDealType.equals("010"))//���ս�ֹܲ���������Ϣ
	{
		sButtons[getBtnIdxByName(sButtons,"�ս���������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�ս���������")][0]="true";
	}else if(sDealType.equals("020002"))//  �ճ����չ���
	{
		sButtons[getBtnIdxByName(sButtons,"�������յǼ�")][0]="true";
	}else if(sDealType.equals("020010010"))//̨����Ϣ����δ����
	{
		sButtons[getBtnIdxByName(sButtons,"��Ϣ���Ǽ�ά��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�������")][0]="true";
	}else if(sDealType.equals("020010020"))//̨����Ϣ�����Ѳ���
	{
		sButtons[getBtnIdxByName(sButtons,"��Ϣ���Ǽ�ά��")][0]="true";
	}else if(sDealType.equals("020030010010010"))//���治������һ����δ���
	{
		sButtons[getBtnIdxByName(sButtons,"����һ���ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ɼ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030010010020"))//���治������һ�����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر�������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030010020010"))//���治�������ص���δ���
	{
		sButtons[getBtnIdxByName(sButtons,"�����ص��ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ɼ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030010020020"))//���治�������ص����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر�������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030020010010"))//�ɽ��û���������һ����δ���
	{
		sButtons[getBtnIdxByName(sButtons,"����һ���ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ɼ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";	
	}else if(sDealType.equals("020030020010020"))//�ɽ��û���������һ�����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر�������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";	
	}else if(sDealType.equals("020030020020010"))//�ɽ��û����������ص���δ���
	{
		sButtons[getBtnIdxByName(sButtons,"�����ص��ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ɼ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";	
	}else if(sDealType.equals("020030020020020"))//�ɽ��û����������ص����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر�������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030030010010"))//����Ʊ���û���������һ����δ���
	{
		sButtons[getBtnIdxByName(sButtons,"����һ���ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ɼ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
		
	}else if(sDealType.equals("020030030010020"))//����Ʊ���û���������һ�����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر�������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030030020010"))//����Ʊ���û����������ص���δ���
	{
		sButtons[getBtnIdxByName(sButtons,"�����ص��ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ɼ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030030020020"))//����Ʊ���û����������ص����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر�������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030040010010"))//�Ѻ�����������һ����δ���
	{
		sButtons[getBtnIdxByName(sButtons,"����һ���ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ɼ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030040010020"))//�Ѻ�����������һ�����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"һ���ر�������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030040020010"))//�Ѻ������������ص���δ���
	{
		sButtons[getBtnIdxByName(sButtons,"�����ص��ر���")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ɼ��")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020030040020020"))//�Ѻ������������ص����Ѽ��
	{
		sButtons[getBtnIdxByName(sButtons,"�ص��ر�������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
	}else if(sDealType.equals("020040010"))//δת��
	{
		sButtons[getBtnIdxByName(sButtons,"ת��")][0]="true";
	}else if(sDealType.equals("020040020"))//��ת��
	{
		
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
	/*~[Describe=���պ�����;InputParam=��;OutPutParam=��;]~*/
	function dun_Note()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("DunList","/RecoveryManage/DunManage/DunList.jsp","ObjectType=BusinessContract&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=ָ����ȫ��������;InputParam=��;OutPutParam=��;]~*/   
	function my_Distribute()
	{
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else
		{
			//�����Ի�ѡ���
			var sRecovery = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserChoice.jsp?ShowFlag=010","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
			{
				sRecovery = sRecovery.split("@");
				var sRecoveryUserID = sRecovery[0];
				var sRecoveryUserName = sRecovery[1];
				var sRecoveryOrgID = sRecovery[2];
				var sBadBizProjectFlag = sRecovery[3];
				
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoveryUserID@"+sRecoveryUserID+"@String@RecoveryOrgID@"+sRecoveryOrgID+"@String@BadBizProjectFlag@"+sBadBizProjectFlag+"@String@ManageFlag@010,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
						alert("�ò����ʲ��ɹ��ַ�����"+sRecoveryUserName+"���ܻ���");
						self.location.reload();
				}
			}
		}
	}
	
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
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function view_Opinions()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"RelativeSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	    popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","ObjectType=CreditApply&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/   
	function mend_Complete()
	{
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			//��֤������Ϣ�Ƿ���д
			sReturn=RunMethod("PublicMethod","GetColValue","BadLoanCaliber,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("�����̨����Ϣ���Ǻ��ٵ��!");
				return;
			}else
			{
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageFlag@080,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('71'));//�����ɹ�
					self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=��ɼ��;InputParam=��;OutPutParam=��;]~*/   
	function monitor_Complete()
	{
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			//��ɼ��
			sReturnValue=RunMethod("BadBizManage","FinishMonitor",sSerialNo+",<%=sReportType%>");
			if(sReturnValue=="True")
			{
				alert(getHtmlMessage('71'));//�����ɹ�
				self.location.reload();
			}else if(sReturnValue=="None")
			{
				alert("û����д��鱨����Ϣ,����д����!");
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ��
			}
			
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
	
	/*~[Describe=ת��;InputParam=��;OutPutParam=��;]~*/	
	function my_ReverseHandover()
	{ 
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else
		{	
			if(confirm(getBusinessMessage('785')))//������뽫�˲����ʲ��˻ظ�ԭ�ܻ�����
    		{	
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoveryUserID@None@String@RecoveryOrgID@None@String@ManageFlag@090,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")//ˢ��ҳ��
				{
					alert(getBusinessMessage('784')); //�ò����ʲ��ѳɹ��˻ظ�ԭ�ܻ��ˣ�
					self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=ʹ��OpenComp���ս���������;InputParam=��;OutPutParam=��;]~*/
	function finishApply_Info()
	{
		//����������͡�������ˮ��
		sObjectType = "BadBizApply";
		sContractNo = getItemValue(0,getRow(),"SerialNo");
		sReturnValue = RunMethod("PublicMethod","GetColValue","SerialNo,BADBIZ_RELATIVE,String@ObjectType@FinishContract@String@ObjectNo@"+sContractNo);
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "") 
		{			
			sReturnValue = sReturnValue.split('@');
		}
		sObjectNo = sReturnValue[1];
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=�鿴�ս��������;InputParam=��;OutPutParam=��;]~*/
	function finishApprove_Info()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sObjectType = "BadBizApply";
		sContractNo = getItemValue(0,getRow(),"SerialNo");
		sReturnValue = RunMethod("PublicMethod","GetColValue","SerialNo,BADBIZ_RELATIVE,String@ObjectType@FinishContract@String@ObjectNo@"+sContractNo);
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "") 
		{			
			sReturnValue = sReturnValue.split('@');
		}
		sObjectNo = sReturnValue[1];
		sFlowNo = "BadBizFlow";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("ViewBadBizOpinions","/Common/WorkFlow/ViewBadBizOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
