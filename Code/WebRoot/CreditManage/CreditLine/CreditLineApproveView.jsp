<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/11/23
		Tester:
		Content:���Ŷ�����������������
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
	String PG_TITLE = "���Ŷ�����������������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ŷ�����������������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
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
	String sFolder1 = "";	
	int iOrder1 = 1;
	int iOrder2 = 1;

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
	//�����������������Ż�ÿͻ�����
	sSql = " select CustomerID from BUSINESS_APPROVE where SerialNo = '"+sObjectNo+"' ";
	sCustomerID = Sqlca.getString(sSql);  
	//�����������������Ż���ۺ����Ŷ�ȱ��
	sSql = " select LineID from CL_INFO where ApproveSerialNo = '"+sObjectNo+"' ";
	sCreditLineID = Sqlca.getString(sSql);
			
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	tviTemp.insertPage("root","���Ŷ�Ȼ�����Ϣ","",iOrder1++);
	tviTemp.insertPage("root","���Ŷ�ȷ���","",iOrder1++);
	
	sFolder1 = tviTemp.insertFolder("root","������Ϣ","",iOrder1++);
	tviTemp.insertPage(sFolder1,"�����ĵ�����Ϣ","",iOrder2++);
	tviTemp.insertPage(sFolder1,"������ĵ�����ͬ","",iOrder2++);
	tviTemp.insertPage("root","ҵ���ĵ���Ϣ","",iOrder1++);
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
			OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ParentLineID=<%=sCreditLineID%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="�����ĵ�����Ϣ")
		{
			OpenComp("ApproveAssureList1","/CreditManage/CreditAssure/ApproveAssureList1.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="������ĵ�����ͬ")
		{
			OpenComp("ApproveAssureList2","/CreditManage/CreditAssure/ApproveAssureList2.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="ҵ���ĵ���Ϣ")
		{
			OpenComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
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
