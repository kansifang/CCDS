<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  --fbkang 2005.7.25
		Tester:
		Content: --�ͻ���ͼ������
		Input Param:
			  ObjectNo  ��--�ͻ���
		Output param:
			               
		History Log: 
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�����"; //-- ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //--Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//--Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//--Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = "";	//--���sql���
	String sItemAttribute = "",sItemDescribe = "",sAttribute2 = "",sAttribute3 = "";//--�ͻ�����	
	String sCustomerType = "";//--�ͻ�����	
	String sCustomerScale = "";//--�ͻ���ģ
	String sTreeViewTemplet = "";//--���custmerviewҳ����ͼ��CodeNo
	ASResultSet rs = null;//--��Ž����
	int iCount = 0;//��¼��
	//����������	,�ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//���ҳ�����	

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	
	//�ͻ������λ������/����/֧�У�����Ա���ӿͻ�������Ϣ���в�ѯ���������Լ����е�ǰ�ͻ�����Ϣ�鿴Ȩ����Ϣά��Ȩ�ļ�¼��
	if(CurUser.hasRole("080") || CurUser.hasRole("280") || CurUser.hasRole("480"))
	{
		sSql = 	" select Count(*) from CUSTOMER_BELONG  "+
				" where CustomerID = '"+sCustomerID+"' "+
				" and OrgID = '"+CurOrg.OrgID+"' "+
				" and UserID = '"+CurUser.UserID+"' "+
				" and (BelongAttribute1 = '1' "+
				" or BelongAttribute2 = '1')";
	}else//�ǿͻ������λ����Ա���ӿͻ�������Ϣ���в�ѯ�����������������������е�ǰ�ͻ�����Ϣ�鿴Ȩ����Ϣά��Ȩ�ļ�¼��
	{	
		sSql =  " select sortno||'%' from org_info where orgid='"+CurUser.OrgID+"' ";
		String sSortNo = Sqlca.getString(sSql);
		sSql = 	" select Count(*) from CUSTOMER_BELONG  "+
				" where CustomerID = '"+sCustomerID+"' "+
				" and OrgID in (select orgid from org_info where sortno like '"+sSortNo+"') "+
				" and (BelongAttribute1 = '1' "+
				" or BelongAttribute2 = '1')";
	}
	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
		iCount = rs.getInt(1);
	//�رս����
	rs.getStatement().close();
	
	//����û�û���������Ȩ�ޣ��������Ӧ����ʾ
	if( iCount  <= 0 && false)//��Ϊ˭�����Կ���modified by zrli
	{
%>
		<script>
			//�û����߱���ǰ�ͻ��鿴Ȩ
			alert( getHtmlMessage(15));				
		    self.close();			        
		</script>
<%
	}
	
	//ȡ�ÿͻ�����
	sSql = "select CustomerType,CustomerScale from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerType = rs.getString("CustomerType");	
		sCustomerScale = rs.getString("CustomerScale");	
	}
	rs.getStatement().close();
	
	if(sCustomerType == null) sCustomerType = "";

	//ȡ����ͼģ������	
	sSql = " select ItemDescribe,ItemAttribute,Attribute2,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = '"+sCustomerType+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sItemDescribe = DataConvert.toString(rs.getString("ItemDescribe"));		//�ͻ�������ͼ����
		sAttribute2 = DataConvert.toString(rs.getString("Attribute2"));		//��С��ҵ�ͻ�������ͼ����
	}
	rs.getStatement().close(); 
	
	if(sCustomerScale!=null&&sCustomerScale.startsWith("02"))
	{
		sTreeViewTemplet = sAttribute2;		//��С��˾�ͻ�������ͼ����
	}else
	{
		sTreeViewTemplet = sItemDescribe;		//��˾�ͻ�������ͼ����
	}
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ͻ���Ϣ����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sTreeViewTemplet+"' and isinuse = '1' ";
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
		var sObjectType = "Customer";
		var sCurItemID = getCurTVItem().id;//--�����ͼ�Ľڵ����
		var sCurItemName = getCurTVItem().name;//--�����ͼ�Ľڵ�����
		var sCurItemDescribe = getCurTVItem().value;//--��������¸�ҳ���·������صĲ���
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];//--��������¸�ҳ���·��
		sCurItemDescribe2=sCurItemDescribe[1];//--����¸�ҳ��ĵ�ҳ������
		sCurItemDescribe3=sCurItemDescribe[2];//--����û��
		sCurItemDescribe4=sCurItemDescribe[3];//--����û��

		sCustomerID = "<%=sCustomerID%>";//--��ÿͻ�����
		
		//add by xhyong 2009/08/24 ���ŷ����޶���CustomerLimit��ʾ
		if(sCurItemDescribe4 == "080")//���ŷ����޶�
		{
			sObjectType = 'CustomerLimit';
		}
	    //add by hldu �������õȼ������趨CustomerType
		if(sCurItemDescribe3 == "NewEvaluate" )
		{
			sObjectType = 'NewEvaluate';
		}
		//add end 
		if(sCurItemDescribe2 == "Back")
		{
			top.close();
		}
		else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"&CustomerType=<%=sCustomerType%>&ModelType="+sCurItemDescribe4+"&ObjectNo="+sCustomerID+"&ComponentName="+sCurItemName+"&CustomerID="+sCustomerID+"&ObjectType="+sObjectType+"&NoteType="+sCurItemDescribe3);
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
	selectItem('010');
	sCustomerType = "<%=sCustomerType%>";
	sCustomerScale = "<%=sCustomerScale%>";
	if(sCustomerType != '0201')
	{
		expandNode('010');
	}
	if(sCustomerScale!=null&&sCustomerScale.substring(0,2)=="02")
	{
		selectItem('010005');//�Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	}else 
	{
		selectItem('010010');//�Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	}
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
