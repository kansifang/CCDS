<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2010/02/04
		Tester:
		Describe: ϵͳ�������շ�����
		Input Param:			
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"CreditAggreement","���Э����"},						
							{"OccurTypeName","��������"},													
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"Balance","���"},
							{"Result1Name","���ֽ��"}
						  };
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sDBName.startsWith("DB2"))
    {
	    sSql =      " select BC.SerialNo as SerialNo,BC.CustomerName as CustomerName, "+
					" BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+					
					" BC.OccurType as OccurType ,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
					" BC.CreditAggreement as CreditAggreement,"+
					" BC.BusinessCurrency as BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as Currency,"+
					" BC.BusinessSum as BusinessSum,nvl(BC.Balance,0) as Balance,"+
					" getItemName('ClassifyResult',CR.Result1) as Result1Name, "+
					" getOrgName(BC.ManageOrgID) as ManageOrgName,"+
					" getUserName(BC.ManageUserID) as ManageUserName "+
					" from BUSINESS_CONTRACT BC "+
					" LEFT OUTER JOIN CLASSIFY_RECORD CR ON  "+
					" BC.SerialNo=CR.ObjectNo   and CR.ObjectType='BusinessContract' "+
					" and CR.AccountMonth='"+StringFunction.getToday().substring(0,7)+"' "+
					" where (BC.FinishDate is null or BC.FinishDate = '') and BC.ApplyType<>'CreditLineApply' "+
					" and BC.ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}



	//����֧�пͻ��������пͻ��������пͻ�������û�ֻ�ܲ鿴�Լ��ܻ��ĺ�ͬ
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
	{
	    sSql += " and BC.ManageUserID = '"+CurUser.UserID+"'";
	}
	sSql += " order by CustomerName";
	//out.println(sSql);
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//doTemp.setKey("SerialNo",true);
	//doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);

	doTemp.setVisible("OccurTypeName,ManageOrgName,ManageUserName,BusinessType,OccurType,BusinessCurrency",false);	
		
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,Result1Name"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency","2");
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,SerialNo","IsFilter","1");
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
			{"false","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
		};
		
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