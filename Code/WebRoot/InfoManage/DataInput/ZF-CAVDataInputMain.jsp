<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu  2005.03.25
		Tester12:
		Content: 核销资产补充登记主界面
		Input Param:
		Output param:
		History Log: Changed by slliu 2005.03.02
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "核销资产补充登记主界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;核销资产补充登记主界面&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	ASResultSet rs1;
	ASResultSet rs;
	String sSql="";
	String sCurItemName="";
	//获得页面参数	
	
    //获得组件参数	 
	 //补登标志sReinforceFlag表示从不同的列表进入
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="010";	
	    
	
	if(sReinforceFlag.equals("010"))
	{
		sSql = "select count(*) from BUSINESS_CONTRACT where (BusinessType like '[1,2,5]%' or BusinessType is null or BusinessType ='') and ReinforceFlag = '010' and ManageOrgID ='"+CurOrg.OrgID+"' and (DeleteFlag =''  or  DeleteFlag is null) and FinishType like '060%' ";
		sCurItemName = "需补登信贷业务";
	}
	
	if(sReinforceFlag.equals("020"))
	{
		sSql = "select count(*) from BUSINESS_CONTRACT where (BusinessType like '[1,2,5]%' or BusinessType is null or BusinessType ='') and ReinforceFlag = '020' and ManageOrgID ='"+CurOrg.OrgID+"' and (DeleteFlag =''  or  DeleteFlag is null) and FinishType like '060%'";
		sCurItemName = "补登完成信贷业务";
	}
	
		
	rs1=Sqlca.getASResultSet(sSql);
	rs1.next();
	sCurItemName+= "("+rs1.getInt(1)+")件";
	rs1.getStatement().close();	
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"核销资产补充登记主界面","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	//String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'CAVDataInputMain'";

	//tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	sSql = "select SortNo,ItemName,ItemNo,ItemDescribe from CODE_LIBRARY where CodeNo= 'CAVDataInputMain' Order By SortNo";
		
	rs=Sqlca.getASResultSet(sSql);
	
	String sSortNo="";
	String sItemName="";
	String sItemNo="";
	String sItemDescribe="";
	while(rs.next())
	{
		sSortNo = rs.getString("SortNo");
		sItemName = rs.getString("ItemName");
		sItemNo = rs.getString("ItemNo");
		sItemDescribe = rs.getString("ItemDescribe");
		if (sSortNo.equals("010"))	//需补登核销资产
		{
			sSql = "select count(*) from BUSINESS_CONTRACT where (BusinessType like '[1,2,5]%' or BusinessType is null or BusinessType ='') and ReinforceFlag = '010' and ManageOrgID in (select BelongOrgId from ORG_BELONG where OrgId='"+CurOrg.OrgID+"') and (DeleteFlag =''  or  DeleteFlag is null) and FinishType like '060%' ";
						
			sItemName += "("+Sqlca.getString(sSql)+")件"; 
			tviTemp.insertPage(sSortNo,"root",sItemName,sItemNo,"",0);
		}else if (sSortNo.equals("020")) 	//补登完成核销资产
		{
			sSql = "select count(*) from BUSINESS_CONTRACT where (BusinessType like '[1,2,5]%' or BusinessType is null or BusinessType ='') and ReinforceFlag = '020' and ManageOrgID in (select BelongOrgId from ORG_BELONG where OrgId='"+CurOrg.OrgID+"') and (DeleteFlag =''  or  DeleteFlag is null) and FinishType like '060%' ";
			
			sItemName += "("+Sqlca.getString(sSql)+")件"; 
			tviTemp.insertPage(sSortNo,"root",sItemName,sItemNo,"",0);
		}
		
	}
	rs.getStatement().close();
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 

	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview单击选中事件
	function TreeViewOnClick()
	{
		//ItemNo=010需补登核销资产，020补登完成核销资产
		var sItemNo = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		
		if(sItemNo!="root")
		{
			if(typeof(sItemNo)!="undefined" && sItemNo.length > 0)
			{
				OpenComp("CAVInputCreditList","/InfoManage/DataInput/CAVInputCreditList.jsp","ComponentName="+sCurItemName+"&ReinforceFlag="+sItemNo,"right");
			}
			setTitle(getCurTVItem().name);
		}
	}



	//置右面详情的标题
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

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script language="JavaScript">
		startMenu();
		expandNode('root');
		
		OpenComp("CAVInputCreditList","/InfoManage/DataInput/CAVInputCreditList.jsp","ComponentName=需补登信贷业务&ReinforceFlag=<%=sReinforceFlag%>","right");
		setTitle("<%=sCurItemName%>");
	
		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
