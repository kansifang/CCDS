<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-3
		Tester:
		Describe: ������ϵ��������;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			RelativeID�������ͻ����

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ϵ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "2000";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sOldCustomerID = "";
	String sCustomerName = "";
	String sCustomerInfoName = "";
	String sRelativeID = "";
	String sRelationName = "";
	String sSql;
	ASResultSet rs=null;

	//Hash��ͬ�Ŀͻ��ţ�����ʾͬһ�ͻ��ڹ������ϵĶ�γ���
	Hashtable myHashtable = new Hashtable();
	//����ÿ������������ϵ������CustomerId���ϣ���һ������ֻ�б��ͻ�һ����¼
	Vector lastCustomer=new Vector();
	//����ÿ��Ҫ������ϵ��ϵ�Ŀͻ�������ÿ���ɼ���lastCustomer����
	String whereClause="";
	//������Σ��������ò�ξͽ���
	int iLayerNum=3;

	//����������	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//���ҳ�����	

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%

	//ȡ�ÿͻ�����
	sSql="select CustomerName  from CUSTOMER_INFO where CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
	   sCustomerName=DataConvert.toString(rs.getString("CustomerName"));
	}
	rs.getStatement().close(); 

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(sCustomerName+"��������ϵͼ��","_top");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//����Item�˵������
	int num=1;

	myHashtable.put(sCustomerID,"0");
	lastCustomer.add(sCustomerID);

	for(int i=0;i<iLayerNum;i++)
	{
		//���ɱ��������Ŀͻ�����
		whereClause="''";
		for(int j=0;j<lastCustomer.size();j++)
		{
			whereClause=whereClause+",'"+lastCustomer.get(j)+"'";
		}
		lastCustomer.removeAllElements();

		//���ɱ���������Sql���
		sSql = "select CustomerID,RelativeID,CustomerName,getCustomerName(RelativeID) as CustomerInfoName, RelationShip,getItemName('RelationShip',RelationShip) as RelationName from Customer_Relative where CustomerID in ("+whereClause+") and CustomerID<>'' and CustomerID is not null order by CustomerID,RelativeID";
		rs=Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sCustomerID = rs.getString("CustomerID");

			//����Item�˵�����ţ������¿ͻ�����Ƿ�;ɿͻ������ͬ
			if(sOldCustomerID.equals(sCustomerID))
			{
				num++;
			}
			else
			{
				num=1;
				sOldCustomerID=sCustomerID;
			}

			sRelativeID = rs.getString("RelativeID");
			if(!myHashtable.containsKey(sRelativeID))
			{
				lastCustomer.add(sRelativeID);
				myHashtable.put(sRelativeID,"0");
			}
			else
			{
				String temp=(String)myHashtable.get(sRelativeID);
				myHashtable.put(sRelativeID,String.valueOf((Integer.parseInt(temp)+1)));
			}

			sCustomerName = rs.getString("CustomerName");
			sCustomerInfoName = rs.getString("CustomerInfoName");
			if (sCustomerInfoName == null) sCustomerInfoName="";
			sRelationName = rs.getString("RelationName");

			//�����ǵ�һ����������IdΪroot
			if(i==0)
			{
				tviTemp.insertFolder(sRelativeID+"@"+myHashtable.get(sRelativeID),"root",sCustomerName+"��"+sRelationName,sCustomerInfoName,"",num);
			}
			else if(i==iLayerNum-1)
			{
				tviTemp.insertPage(sRelativeID+"@"+myHashtable.get(sRelativeID),sCustomerID+"@0",sCustomerName+"��"+sRelationName,sCustomerInfoName,"",num);
			}
			else
			{
				tviTemp.insertFolder(sRelativeID+"@"+myHashtable.get(sRelativeID),sCustomerID+"@0",sCustomerName+"��"+sRelationName,sCustomerInfoName,"",num);
			}
		}
		rs.getStatement().close();
	}
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		if (sCurItemID == "root")
			return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemValue = getCurTVItem().value;
		if (sCurItemValue.length == 1) {
			alert("�ÿͻ�����ϸ��Ϣ��");
			return;
		}
		var sss = sCurItemID.split("@");
		var sCustomerID=sss[0];		
		openObject("Customer",sCustomerID,"002");
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
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>