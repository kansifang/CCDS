<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: �Ŵ����ݲ����б�;
		Input Param:
					DataInputType��010�貹���Ŵ�ҵ��
									020��������Ŵ�ҵ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ŵ����ݲ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";
	
	String sClauseWhere="";
	//���ҳ�����
	
	//����������
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag1"));
	if(sReinforceFlag==null) sReinforceFlag="";
	if(sFlag==null) sFlag="";
	
	String sHeaders[][] = {
					{"SerialNo","��ͬ��ˮ��"},
					{"CustomerName","�ͻ�����"},
					{"CustomerID","�ͻ����"},
					{"MFCustomerID","���Ŀͻ���"},
					{"CertTypeName","֤������"},
					{"CertID","֤������"},
					{"LoanCardNo","�����"},
					{"CreditLevelName","�ͻ��������"},
					{"BusinessTypeName","ҵ��Ʒ��"},					
					{"OccurTypeName","��������"},
					{"BDSerialNo","�����˺�"},
					{"ClassifyResultName","��ǰ���շ�����"},
					{"FinishType","�ս᷽ʽ"},
					{"FinishTypeName","�ս᷽ʽ"},									
					{"Currency","����"},
					{"BusinessSum","��ͬ���(Ԫ)"},
					{"Balance","���(Ԫ)"},
					{"NormalBalance","�������(Ԫ)"},
					{"OverdueBalance","�������(Ԫ)"},
					{"DullBalance","�������(Ԫ)"},
					{"BadBalance","�������(Ԫ)"},
					{"Interestbalance1","����ǷϢ(Ԫ)"},
					{"Interestbalance2","����ǷϢ(Ԫ)"},
					{"VouchTypeName","��Ҫ������ʽ"},
					{"PutOutDate","��ʼ����"},
					{"Maturity","��������"},
					{"ManageOrgIDName","�ܻ�����"},
					{"ManageUserIDName","�ܻ���"}					
				  };

	 sSql = " select BC.SerialNo,BC.SerialNo as BDSerialNo,CI.MFCustomerID as MFCustomerID,"+
	 		" BC.CustomerName as CustomerName,"+
			" BC.CustomerID as CustomerID,"+
			" getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID as CertID,"+
			" CI.LoanCardNo as LoanCardNo,"+
			" getItemName('CreditLevel',getCreditLevel(BC.CustomerID)) as CreditLevelName,"+
			" BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
			" BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.FinishType,getItemName('FinishType',BC.FinishType) as FinishTypeName,"+
			" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as Currency,"+
			" BC.BusinessSum,BC.Balance,"+
			" BC.NormalBalance,BC.OverdueBalance,BC.DullBalance,BC.BadBalance,"+
			" BC.Interestbalance1,BC.Interestbalance2,"+
			" BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
			" BC.PutOutDate,BC.Maturity,"+
			" getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
			" getUserName(BC.ManageUserID) as ManageUserIDName,"+
			" getOrgName(BC.ManageOrgID) as ManageOrgIDName "+
			" from BUSINESS_CONTRACT BC left join CUSTOMER_INFO CI ON CI.CUSTOMERID=BC.CUSTOMERID "+
			" where  "+
			" (BC.BusinessType like '1%' "+
			" or BC.BusinessType like '2%' "+
			" or BC.BusinessType like '5%' "+
			" or BC.BusinessType is null "+
			" or BC.BusinessType ='')"+
			" and (BC.FinishDate='' "+
			" or BC.FinishDate is null) "+
			" and (BC.FinishType not like '060%' "+
			" or BC.FinishType is null)" + 
			" and LoanFlag = '1'"+
			" and BC.ManageOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')" ;
	 //�����ֱ��֧�й���Ա,ֱ��֧���������Ź���Ա
	if(CurUser.hasRole("0M2")||CurUser.hasRole("0M4"))
	{
		sSql += " AND BC.ManageOrgID in(select OrgID from ORG_INFO where OrgLevel='3' and OrgFlag='030') ";
	}
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//out.println("<font color='red' size = 2>"+
	//			"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������������ҵ����[��Ȳ��ǹ���]��������[����ҵ��]��[�������]�������ʾ�ͻ������Ⲣ���Ŵ�ϵͳ��ȷ�ϴ˿ͻ���[����]�ɹ�����ô���ں���ϵͳ�����ͻ��ϲ������������������Ӧ����Ѿ����ڣ���ô����Ϳ��԰��ա���������ҵ�񡱽��в��ǣ��������ٲ�¼������Ϣ��"+
	//			"</font>");
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("BC.SerialNo");		//add by hxd in 2005/02/20 for �ӿ��ٶ�
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";	
	doTemp.setKey("BC.SerialNo",true);	 //���ùؼ���
	
	//���ò��ɼ���
	doTemp.setVisible("CustomerType,OccurType,BusinessCurrency,VouchType",false);
	doTemp.setVisible("BusinessType,FinishType,FinishTypeName,Currency",false);
	
	doTemp.setAlign("NormalBalance,OverdueBalance,DullBalance,BadBalance,BusinessSum,Balance,Interestbalance1,Interestbalance2","3");
	doTemp.setType("Interestbalance1,Interestbalance2","Number");
	doTemp.setCheckFormat("NormalBalance,OverdueBalance,DullBalance,BadBalance,BusinessSum,Balance","2");
	
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerTypeName,CertID,ManageUserIDName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("SerialNo,CustomerID"," style={width:160px} ");
	doTemp.setHTMLStyle("VouchTypeName"," style={width:170px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:100px} ");
		
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","SerialNo","");	
	doTemp.setFilter(Sqlca,"3","MFCustomerID","");
	doTemp.setFilter(Sqlca,"4","Interestbalance1","");
	doTemp.setFilter(Sqlca,"5","Interestbalance2","");
	doTemp.parseFilterData(request,iPostChange);	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
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
				{"true","","Button","ҵ������","ҵ������","BusinessInfo()",sResourcesPath}};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function BusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
				alert("����ҵ��û��ҵ��Ʒ�֣����ܲ鿴��ͬ����!");
			}
			else{
				openObject("AfterLoan",sSerialNo,"001");
			}	
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
