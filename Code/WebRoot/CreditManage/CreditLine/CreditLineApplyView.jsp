<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/11/23
		Tester:
		Content:���Ŷ����������
		Input Param:
			ObjectType����������
			ObjectNo��������
		Output param:
		
		History Log: 
			zywei 2007/10/10 ������ʾ��һ�����Ͳ˵���
			lpzhang 2009-8-11 ���ӹ��̻�е���Ҷ��Э��
	 */		
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ����������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ŷ����������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = "";//Sql���
	String sCustomerID = "";//�ͻ�����
	String sBusinessType = "";//ҵ��Ʒ��
	String sCreditLineID = "";//�ۺ����ű��
	String sOccurType = "";	  //��������
	String sChangeObject = "";//�������
	String sFolder1 = "";	
	String sApplyType="";
	int iOrder1 = 1;
	int iOrder2 = 1;
	
	ASResultSet rs = null;
	
	//���ҳ�����		
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%	
	//���������Ż�ÿͻ�����
	sSql = " select CustomerID,BusinessType,ApplyType,occurtype,ChangeObject from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
		sBusinessType = rs.getString("BusinessType");
		sApplyType = rs.getString("ApplyType");
		sOccurType = rs.getString("occurtype");
		sChangeObject = rs.getString("changeobject");
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sApplyType == null) sApplyType = "";
		if(sOccurType == null) sOccurType = "";
		if(sChangeObject == null) sChangeObject = "";
	}
	rs.getStatement().close();
	
	//���������Ż���ۺ����Ŷ�ȱ��
	sSql = " select LineID from CL_INFO where ApplySerialNo = '"+sObjectNo+"' and parentLineID is null or  parentLineID=''";
	sCreditLineID = Sqlca.getString(sSql);
			
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	if("3020".equals(sBusinessType))
	{
		tviTemp.insertPage("root","���̻�е���Ҷ����Ϣ","",iOrder1++);
		tviTemp.insertPage("root","���̻�е���Ҵ�Э����Ϣ","",iOrder1++);
	}
	if(!"3020".equals(sBusinessType))
	{
		tviTemp.insertPage("root","���Ŷ�Ȼ�����Ϣ","",iOrder1++);
		tviTemp.insertPage("root","���Ŷ�ȷ���","",iOrder1++);
		//tviTemp.insertPage("root","��������ҵ����Ϣ","",iOrder1++);
	}
	
	sFolder1 = tviTemp.insertFolder("root","������Ϣ","",iOrder1++);
	tviTemp.insertPage(sFolder1,"�����ĵ�����Ϣ","",iOrder2++);
	tviTemp.insertPage(sFolder1,"������ĵ�����ͬ","",iOrder2++);
	tviTemp.insertPage("root","ҵ���ĵ���Ϣ","",iOrder1++);
	if((!sBusinessType.startsWith("30") || sBusinessType.equals("3040") ) && "1150020,1150010,1140030".indexOf(sBusinessType) < 0 )
	{
		tviTemp.insertPage("root","���ն�����","",iOrder1++);
	}
	//�������������120����ұ��������01������Ϣ
	if("120".equals(sOccurType)&&"01".equals(sChangeObject))
	{
		tviTemp.insertPage("root","���ԭ������Ϣ","",iOrder1++);
	}
	//�������������120����ұ��������02��ͬ��Ϣ
	if("120".equals(sOccurType)&&"02".equals(sChangeObject))
	{
		tviTemp.insertPage("root","���ԭ��ͬ��Ϣ","",iOrder1++);
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	
	//treeview����ѡ���¼�	
	function TreeViewOnClick()
	{		
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=="���Ŷ�Ȼ�����Ϣ")
		{
			OpenComp("CreditInfo","/CreditManage/CreditApply/CreditInfo.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="���Ŷ�ȷ���")
		{
			OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ParentLineID=<%=sCreditLineID%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="�����ĵ�����Ϣ")
		{
			OpenComp("ApplyAssureList1","/CreditManage/CreditAssure/ApplyAssureList1.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="������ĵ�����ͬ")
		{
			OpenComp("ApplyAssureList2","/CreditManage/CreditAssure/ApplyAssureList2.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="ҵ���ĵ���Ϣ")
		{
			OpenComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		
		if(sCurItemname=="���ն�����")
		{
			OpenComp("RiskEvaluate","/CreditManage/CreditApply/RiskEvaluate.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&CustomerID=<%=sCustomerID%>&ModelType=030&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		
		if(sCurItemname=="���̻�е���Ҷ����Ϣ")
		{
			OpenComp("CreditInfo","/CreditManage/CreditApply/CreditInfo.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="���̻�е���Ҵ�Э����Ϣ")
		{
			OpenComp("DealerAgreementList","/CreditManage/CreditLine/DealerAgreementList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&Model=Credit&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		/*if(sCurItemname=="��������ҵ����Ϣ")
		{
			OpenComp("CreditLineApplyList","/CreditManage/CreditLine/CreditLineApplyList.jsp","ObjectType=<%=sObjectType%>&ParentLineID=<%=sCreditLineID%>&CustomerID=<%=sCustomerID%>&ObjectNo=<%=sObjectNo%>&Model=Credit&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}*/
		if(sCurItemname=="���ԭ��ͬ��Ϣ")
		{
			OpenComp("OldContractList","/CreditManage/CreditApply/OldContractList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
		}
		if(sCurItemname=="���ԭ������Ϣ")
		{
			OpenComp("OldApplyList","/CreditManage/CreditApply/OldApplyList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
		}
		setTitle(getCurTVItem().name);
	}	

		
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script language="JavaScript">
	myleft.width=170;
	startMenu();
	expandNode('root');
	expandNode('<%=sFolder1%>');
	selectItem('1');
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
