<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%> 
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: �������ҵ��
		Input Param:
			ObjectType: �׶α��
			ObjectNo��ҵ����ˮ��
		Output Param:

		HistoryLog: 
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "", sSql1 = "";
	ASResultSet rs=null;

	//���ҳ�����

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sBusinessType1 = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	String sHeaders[][] = 	{
				{"SerialNo","��ͬ��ˮ��"},
				{"CustomerName","�ͻ�����"},
				{"BusinessTypeName","ҵ��Ʒ��"},
				{"OccurTypeName","��������"},
				{"ObjectNo","��ͬ���"},
				{"Currency","����"},
				{"BusinessSum","���(Ԫ)"},
				{"OccurDate","��������"},
				{"VouchTypeName","������ʽ"},
				{"FinishDate","�ս�����"},
				{"OperateOrgName","�������"},
			      	};


	sSql =   " select"+	"  B.SerialNo as SerialNo,"+
					
					" B.CustomerID,getCustomerName(B.CustomerID) as CustomerName,"+
					" B.BusinessType,getBusinessName(B.BusinessType) as BusinessTypeName,"+
					" B.OccurType,getItemName('OccurType',B.OccurType) as OccurTypeName,"+
					" B.BusinessCurrency,getItemName('Currency',B.BusinessCurrency) as Currency,"+
					" B.BusinessSum, "+
					" B.VouchType,getItemName('VouchType',B.VouchType) as VouchTypeName,"+
					" B.FinishDate, "+
					" B.OperateOrgID,getOrgName(B.OperateOrgID) as OperateOrgName"+
					" from  Business_Contract B "+
					" where B.BusinessType not like '30%' and (B.FinishDate = '' or B.FinishDate is null) ";

	
	if(sBusinessType1.equals("3010") || sBusinessType1.equals("3040"))
	{
		sSql1 = " and B.CreditAggreement = '"+sObjectNo+"' ";
	}else if(sBusinessType1.equals("3050"))
	{
		sSql1 = " and B.AssureAgreement = '"+sObjectNo+"' ";
	}else if(sBusinessType1.equals("3060"))
	{
		sSql1 = " and B.CommunityAgreement = '"+sObjectNo+"' ";
	}
	sSql = sSql + sSql1;
	
	//out.println(sSql);

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,OperateOrgID",false);
	//�������ݱ���������
   	doTemp.UpdateTable ="BUSINESS_CONTRACT";                               
    doTemp.setKey("SerialNo",true);
    		  
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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
		{"true","","Button","����","�鿴�������ҵ������","viewAndEdit()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	function viewAndEdit()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
			openObject("BusinessContract",sObjectNo,"001");
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

<%@	include file="/IncludeEnd.jsp"%>
