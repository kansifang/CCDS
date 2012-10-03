<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/26
		Tester:
		Describe: �����ʲ��϶���ͬ�б�;
					BadAssetLCFlag �����ʲ��϶�״̬
					'010' ���϶�,δ����
					'020' ���϶�,������
		Input Param:
			ContractType��
			010010δ����϶�
			010020������϶�
			010030����������϶�
			020010δ��������϶�
			020020����������϶�
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ��϶���ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//���ҳ�����
	//����������
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerName","�ͻ�����"},							
							{"BusinessTypeName","ҵ��Ʒ��"},					
							{"OccurTypeName","��������"},	
							{"VouchTypeName","��Ҫ������ʽ"},	
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"Balance","��ͬ���"},
							{"ClassifyResult","�弶������"},
							{"ClassifyResultName","�弶������"},
							{"PutOutDate","��ͬ��ʼ��"},
							{"Maturity","��ͬ������"},	
							{"ManageUserName","�ܻ���"},
							{"ManageOrgName","�ܻ�����"},
							{"OperateUserName","������"},
							{"OperateOrgName","�������"},
						  };
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
    if(sDBName.startsWith("INFORMIX"))
    {
	    sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,"+
					" ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,"+
					" PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,"+
					" getUserName(OperateUserID) as OperateUserName,"+
					" getOrgName(ManageOrgID) as ManageOrgName,"+
					" getUserName(ManageUserID) as ManageUserName "+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}else if(sDBName.startsWith("ORACLE"))
	{
		sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,"+
					" ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,"+
					" PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,"+
					" getUserName(OperateUserID) as OperateUserName,"+
					" getOrgName(ManageOrgID) as ManageOrgName,"+
					" getUserName(ManageUserID) as ManageUserName "+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}if(sDBName.startsWith("DB2"))
    {
	    sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,"+
					" ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,"+
					" PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,"+
					" getUserName(OperateUserID) as OperateUserName,"+
					" getOrgName(ManageOrgID) as ManageOrgName,"+
					" getUserName(ManageUserID) as ManageUserName "+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	//010010δ����϶�
	//010020������϶�
	//010030����������϶�
	//020010δ��������϶�
	//020020����������϶�
	if(sContractType.equals("010010"))
	{
		sSql += " and substr(ClassifyResult,1,2)>'02'  and (FinishDate = '' or FinishDate is null) and (BadAssetLCFlag = '' or BadAssetLCFlag is null)";
	}else if(sContractType.equals("010020")||sContractType.equals("020010"))
	{
		sSql += " and substr(ClassifyResult,1,2)>'02'  and (FinishDate = '' or FinishDate is null) and BadAssetLCFlag = '010'";
	}else if(sContractType.equals("010030")||sContractType.equals("020020"))
	{
		sSql += " and substr(ClassifyResult,1,2)>'02'  and (FinishDate = '' or FinishDate is null) and BadAssetLCFlag = '020'";
	}
		
	//����֧�пͻ��������пͻ��������пͻ�������û�ֻ�ܲ鿴�Լ��ܻ��ĺ�ͬ
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
	{
	    sSql += " and ManageUserID = '"+CurUser.UserID+"'";
	}
	sSql += " order by CustomerName";
	//out.println(sSql);
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("OperateOrgName,OperateUserName,VouchTypeName,BusinessType,OccurType,ClassifyResult,BusinessCurrency,VouchType,OperateOrgID,OrgName",false);	
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	
	//������Դ
	doTemp.setDDDWSql("ClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)=2");
	
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency","2");
	doTemp.setColumnAttribute("OperateOrgName,SerialNo,CustomerName,ClassifyResult","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10); 	//��������ҳ

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
			{"true","","Button","��ͬ����","��ͬ����","viewTab()",sResourcesPath},
			{"true","","Button","�����϶�","�����϶�","duty_Cogn()",sResourcesPath},
			{"true","","Button","�����϶�����","�����϶�����","dutyCogn_Info()",sResourcesPath},
			{"true","","Button","�϶����","�϶����","cogn_Complete()",sResourcesPath},
			{"true","","Button","�������","�������","approve_Complete()",sResourcesPath},
			{"true","","Button","���շ�������","���շ�������","classify_Info()",sResourcesPath},
			{"true","","Button","�����϶���","�����϶���","dutyCogn_Report()",sResourcesPath},
		};
		
	
	if(sContractType.equals("010010"))
	{
		sButtons[getBtnIdxByName(sButtons,"�����϶�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�������")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����϶���")][0]="false";
	}else if(sContractType.equals("010020"))
	{
		sButtons[getBtnIdxByName(sButtons,"�����϶�")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�϶����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����϶���")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�������")][0]="false";
	}else if(sContractType.equals("010030")||sContractType.equals("020020"))
	{
		sButtons[getBtnIdxByName(sButtons,"�����϶�")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�϶����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�������")][0]="false";
	}else if(sContractType.equals("020010"))
	{
		sButtons[getBtnIdxByName(sButtons,"�����϶�")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�϶����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����϶���")][0]="false";
	}
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "AfterLoan";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sApproveType = getItemValue(0,getRow(),"ApproveType");
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApproveType="+sApproveType;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}

	/*~[Describe=�����϶�;InputParam=��;OutPutParam=��;]~*/
	function duty_Cogn()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			sCompID = "NPAssetDutyList";
			sCompURL = "/CreditManage/CreditPutOut/NPADutyList.jsp";
			sParamString = "EditRight=1&ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}

	/*~[Describe=�����϶�����;InputParam=��;OutPutParam=��;]~*/
	function dutyCogn_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			sCompID = "NPAssetDutyList";
			sCompURL = "/CreditManage/CreditPutOut/NPADutyList.jsp";
			sParamString = "EditRight=2&ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=�϶����;InputParam=��;OutPutParam=��;]~*/
	function cogn_Complete()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('40')))//�ύ�󽫲��ܽ����޸Ĳ�����ȷ���ύ��
		{	
			//�϶���ɲ���
			sBadAssetLCFlag = "010";
			var sReturn = RunMethod("BusinessManage","UpdateBadAssetCogniz",sBadAssetLCFlag+","+sSerialNo+",<%=CurUser.UserID%>,<%=CurOrg.OrgID%>");
			if(sReturn == "Success" ) {				
				reloadSelf();	
				alert(getHtmlMessage('71'));	//�����ɹ���		
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ�ܣ�
				return;	
			}	
		}
	}	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/
	function approve_Complete()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('40')))//�ύ�󽫲��ܽ����޸Ĳ�����ȷ���ύ��
		{	
			//�϶���ɲ���
			sBadAssetLCFlag = "020";
			var sReturn = RunMethod("BusinessManage","UpdateBadAssetCogniz",sBadAssetLCFlag+","+sSerialNo+",<%=CurUser.UserID%>,<%=CurOrg.OrgID%>");
			if(sReturn == "Success" ) {				
				reloadSelf();	
				alert(getHtmlMessage('71'));	//�����ɹ���		
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ�ܣ�
				return;	
			}	
		}
	}	
	
	/*~[Describe=���շ�������;InputParam=��;OutPutParam=��;]~*/
	function classify_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			sCompID = "ClassifyHistoryList";
			sCompURL = "/CreditManage/CreditPutOut/ClassifyHistoryList.jsp";
			sParamString = "ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=�����϶���;InputParam=��;OutPutParam=��;]~*/
	function dutyCogn_Report()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/FormatDoc/PutOut/5005.jsp?ObjectNo="+sSerialNo,"",""); 
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>