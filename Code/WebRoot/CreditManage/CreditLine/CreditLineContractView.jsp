<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/11/23
		Tester:
		Content:���Ŷ�Ⱥ�ͬ����
		Input Param:
			ObjectType����������
			ObjectNo��������
		Output param:
		
		History Log: 
		
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ�Ⱥ�ͬ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ŷ�Ⱥ�ͬ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = "";//Sql���
	String sCustomerID = "";//�ͻ�����
	String sCreditLineID = "";//�ۺ����ű��
	String sBusinessType = "";//ҵ��Ʒ��
	String sFolder1 = "";	
	String sApplyType ="";
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
	sSql = " select CustomerID,BusinessType,ApplyType from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
		sBusinessType = rs.getString("BusinessType");
		sApplyType = rs.getString("ApplyType");
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sApplyType == null) sApplyType = "";
	}
	rs.getStatement().close();
	
	
	//���ݺ�ͬ��Ż���ۺ����Ŷ�ȱ��
	sSql = " select LineID from CL_INFO where BCSerialNo = '"+sObjectNo+"' and (ParentLineID is null or ParentLineID='') ";
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
	}else
	{
		tviTemp.insertPage("root","���Ŷ�Ȼ�����Ϣ","",iOrder1++);
		tviTemp.insertPage("root","���Ŷ�ȷ���","",iOrder1++);
		tviTemp.insertPage("root","�������ҵ���ͬ��Ϣ","",iOrder1++);
	}
	
	sFolder1 = tviTemp.insertFolder("root","������ͬ","",iOrder1++);
	tviTemp.insertPage(sFolder1,"һ�㵣����ͬ","",iOrder2++);
	tviTemp.insertPage(sFolder1,"��߶����ͬ","",iOrder2++);
	tviTemp.insertPage("root","ҵ���ĵ���Ϣ","",iOrder1++);
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	var sCreditLineID="<%=sCreditLineID%>";
	
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
			OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ParentLineID=<%=sCreditLineID%>&ObjectType=<%=sObjectType%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="һ�㵣����ͬ")
		{
			OpenComp("ContractAssureList1","/CreditManage/CreditAssure/ContractAssureList1.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="��߶����ͬ")
		{
			OpenComp("ContractAssureList2","/CreditManage/CreditAssure/ContractAssureList2.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="ҵ���ĵ���Ϣ")
		{
			OpenComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}	
		
		if(sCurItemname=="���̻�е���Ҷ����Ϣ")
		{
			OpenComp("CreditInfo","/CreditManage/CreditApply/CreditInfo.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="���̻�е���Ҵ�Э����Ϣ")
		{
			OpenComp("DealerAgreementList","/CreditManage/CreditLine/DealerAgreementList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&Model=Credit&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="�������ҵ���ͬ��Ϣ")
		{
			OpenComp("UnderCreditLineList","/CreditManage/CreditApply/UnderCreditLineList.jsp","ComponentName=�������ҵ����Ϣ&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&BusinessType=<%=sBusinessType%>&Model=Credit&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
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
	startMenu();
	selectItem('1');
	expandNode('root');
	expandNode('<%=sFolder1%>');
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
