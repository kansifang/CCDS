<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: �ͻ�������
		Input Param:
			                CustomerID���ͻ���
		Output param:
			                CustomerID���ͻ���
		History Log: 
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = "";	
	String sCustomerType = "";
	String sCustomerTemplet = "";
	String sCustomerInfoTemplet = "",sModelType = "";
	ASResultSet rs = null;
	//����������	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//���ҳ�����	

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//ȡ�ÿͻ�����
	sSql="select CustomerType  from CUSTOMER_INFO where CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
	   sCustomerType=DataConvert.toString(rs.getString("CustomerType"));
	}
	rs.getStatement().close(); 

	//ȡ����ͼģ������
	sSql="select ItemDescribe,ItemAttribute  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = '"+sCustomerType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
	   sCustomerTemplet=DataConvert.toString(rs.getString("ItemDescribe"));
	   sCustomerInfoTemplet=DataConvert.toString(rs.getString("ItemAttribute"));
	}
	rs.getStatement().close(); 

	//�ж�ʹ�����õȼ�����ģ�͵�����
	if(sCustomerType!=null&&("01,02").indexOf(sCustomerType.substring(0,2))>=0)// ��˾�ͻ������ſͻ�
	{
		sModelType = "010";
	}else if(sCustomerType!=null&&("03,04,05").indexOf(sCustomerType.substring(0,2))>=0)//���˿ͻ������幤�̻���ũ��
	{
		sModelType = "015";
	}else	sModelType = "010";
	

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ͻ���Ϣ","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sCustomerTemplet+"' and (isinuse is null or isinuse<>'2') and (ItemNo='010' or ItemNo='010010' or ItemNo='010020' or ItemNo='010030' or ItemNo='010040' or ItemNo='010050')";
	
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 

	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sCurItemDescribe3=sCurItemDescribe[2];
		sCurItemDescribe4=sCurItemDescribe[3];

		sCustomerID = "<%=sCustomerID%>";
		sCustomerInfoTemplet = "<%=sCustomerInfoTemplet%>";

		if(sCurItemDescribe2 == "Back")
		{
			top.close();
		}
		else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ModelType="+sCurItemDescribe4+"&ObjectNo="+sCustomerID+"&ComponentName="+sCurItemName+"&CustomerID="+sCustomerID+"&ObjectType=Customer&CustomerInfoTemplet="+sCustomerInfoTemplet+"&NoteType="+sCurItemDescribe3);
			setTitle(getCurTVItem().name);
		}
	}



	//����������ı���
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
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
	expandNode('root');
	expandNode('010');
	sCustomerType = "<%=sCustomerType%>";
	if(sCustomerType != '02')
	{
		openChildComp("CustomerInfo","/CustomerManage/CustomerInfo.jsp","CustomerID=<%=sCustomerID%>&Types=Reinforce");
	}
	setTitle("�ͻ��ſ�");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
