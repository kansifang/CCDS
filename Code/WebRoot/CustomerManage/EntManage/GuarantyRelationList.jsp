<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-3
		Tester:
		Describe: 担保关系智能搜索;
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			GuarantorID：关联客户编号

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保关系智能搜索"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "2000";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSerialNo = "";
	String sOldCustomerID = "";
	String sCustomerName = "";
	String sGuarantorID = "";
	String sRelationName = "";
	String sSql;
	ASResultSet rs=null;

	//Hash相同的客户号，已显示同一客户在关联数上的多次出现
	Hashtable myHashtable = new Hashtable();
	//保存每次搜索关联关系的正方CustomerId集合，第一次搜索只有本客户一条记录
	Vector lastCustomer=new Vector();
	//保存每次要搜索关系关系的客户条件，每次由集合lastCustomer生成
	String whereClause="";
	//搜索层次，搜索到该层次就结束
	int iLayerNum=3;

	//获得组件参数	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//获得页面参数	

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%

	//取得客户名字
	sSql="select CustomerName  from CUSTOMER_INFO where CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
	   sCustomerName=DataConvert.toString(rs.getString("CustomerName"));
	}
	rs.getStatement().close(); 

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(sCustomerName+"※担保关系图※","_top");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//保存Item菜单的序号
	int num=1;

	//增加接受担保和提供担保的目录
	tviTemp.insertFolder("accept","root",sCustomerName+"：※接受担保关系图※","","",1);
	tviTemp.insertFolder("offer", "root",sCustomerName+"：※提供担保关系图※","","",2);

	//接受担保关联搜索
	myHashtable.put(sCustomerID,"0");
	lastCustomer.add(sCustomerID);
	for(int i=0;i<iLayerNum;i++)
	{
		//生成本次搜索的客户条件
		for(int j=0;j<lastCustomer.size();j++)
		{
			if (j==0) {
				whereClause="'"+lastCustomer.get(j)+"'";
			}
			else {
				whereClause+=",'"+lastCustomer.get(j)+"'";
			}
		}
		lastCustomer.removeAllElements();

		//生成本次搜索的Sql语句
		sSql = "select SerialNo,CustomerID,GuarantorID,GuarantorName,GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName from GUARANTY_CONTRACT where CustomerID in ("+whereClause+") and ContractStatus='020' order by CustomerID,GuarantorID";
		rs=Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sCustomerID = rs.getString("CustomerID");

			//生成Item菜单的序号，根据新客户编号是否和就旧客户编号相同
			if(sOldCustomerID.equals(sCustomerID))
			{
				num++;
			}
			else
			{
				num=1;
				sOldCustomerID=sCustomerID;
			}

			sGuarantorID = rs.getString("GuarantorID");
			if (sGuarantorID == null) sGuarantorID ="";
			if(!myHashtable.containsKey(sGuarantorID))
			{
				lastCustomer.add(sGuarantorID);
				myHashtable.put(sGuarantorID,"0");
			}
			else
			{
				String temp=(String)myHashtable.get(sGuarantorID);
				myHashtable.put(sGuarantorID,String.valueOf((Integer.parseInt(temp)+1)));
			}

			sCustomerName = rs.getString("GuarantorName");
			sSerialNo = rs.getString("SerialNo");
			sRelationName = rs.getString("GuarantyTypeName");

			//假如是第一次搜索，则父Id为accept
			if(i==0)
			{
				tviTemp.insertFolder(sGuarantorID+"@"+myHashtable.get(sGuarantorID),"accept",sCustomerName+"："+sRelationName,sSerialNo,"",num);
			}
			else if(i==iLayerNum-1)
			{
				tviTemp.insertPage(sGuarantorID+"@"+myHashtable.get(sGuarantorID),sCustomerID+"@0",sCustomerName+"："+sRelationName,sSerialNo,"",num);
			}
			else
			{
				tviTemp.insertFolder(sGuarantorID+"@"+myHashtable.get(sGuarantorID),sCustomerID+"@0",sCustomerName+"："+sRelationName,sSerialNo,"",num);
			}
		}
		rs.getStatement().close();
	}

	//提供担保关联搜索
	myHashtable.clear();
	myHashtable.put(sCustomerID,"0");
	lastCustomer.removeAllElements();
	lastCustomer.add(sCustomerID);
	for(int i=0;i<iLayerNum;i++)
	{
		//生成本次搜索的客户条件
		for(int j=0;j<lastCustomer.size();j++)
		{
			if (j==0) {
				whereClause="'"+lastCustomer.get(j)+"'";
			}
			else {
				whereClause+=",'"+lastCustomer.get(j)+"'";
			}
		}
		lastCustomer.removeAllElements();

		//生成本次搜索的Sql语句
		sSql = "select SerialNo,CustomerID,GuarantorID,getCustomerName(CustomerID) as CustomerName,GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName from GUARANTY_CONTRACT where GuarantorID in ("+whereClause+") and ContractStatus='020' order by GuarantorID, CustomerID";
		rs=Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sCustomerID = rs.getString("GuarantorID");

			//生成Item菜单的序号，根据新客户编号是否和就旧客户编号相同
			if(sOldCustomerID.equals(sCustomerID))
			{
				num++;
			}
			else
			{
				num=1;
				sOldCustomerID=sCustomerID;
			}
			sGuarantorID = rs.getString("CustomerID");
			if (sGuarantorID == null) sGuarantorID ="";
			if(!myHashtable.containsKey(sGuarantorID))
			{
				lastCustomer.add(sGuarantorID);
				myHashtable.put(sGuarantorID,"0");
			}
			else
			{
				String temp=(String)myHashtable.get(sGuarantorID);
				myHashtable.put(sGuarantorID,String.valueOf((Integer.parseInt(temp)+1)));
			}

			sCustomerName = rs.getString("CustomerName");
			sSerialNo = rs.getString("SerialNo");
			sRelationName = rs.getString("GuarantyTypeName");

			//假如是第一次搜索，则父Id为offer
			if(i==0)
			{
				tviTemp.insertFolder(sGuarantorID+"@@"+myHashtable.get(sGuarantorID),"offer",sCustomerName+"："+sRelationName,sSerialNo,"",num);
			}
			else if(i==iLayerNum-1)
			{
				tviTemp.insertPage(sGuarantorID+"@@"+myHashtable.get(sGuarantorID),sCustomerID+"@@0",sCustomerName+"："+sRelationName,sSerialNo,"",num);
			}
			else
			{
				tviTemp.insertFolder(sGuarantorID+"@@"+myHashtable.get(sGuarantorID),sCustomerID+"@@0",sCustomerName+"："+sRelationName,sSerialNo,"",num);
			}
		}
		rs.getStatement().close();
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	//treeview单击选中事件
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		if (sCurItemID == "root" || sCurItemID == "accept" || sCurItemID == "offer")
			return;
		var sCurItemName = getCurTVItem().name;
		var sss = sCurItemID.split("@");
		var sCustomerID=sss[0];		
		sSerialNo = getCurTVItem().value;
		openObject("GuarantyContract",sSerialNo,"002");
	}

	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>