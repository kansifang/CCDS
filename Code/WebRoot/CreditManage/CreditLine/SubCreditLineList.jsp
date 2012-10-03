<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2006/03/31
		Tester:
		Content: 授信额度分配列表页面
		Input Param:
			ParentLineID：额度编号
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	
	//获得页面参数	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(sObjectType == null) sObjectType = "";
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	if(sParentLineID == null) sParentLineID = "";
	//定义参数
	ASResultSet rs= null;
	String sBusinessType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		
	//显示标题				
	String[][] sHeaders = {		
						{"CustomerID","客户编号"},
						{"CustomerName","客户名称"},
						{"BusinessTypeName","业务品种"},
						{"MemberName","成员名称"},
						{"AssessLevel","信用共同体内评定级别"},
						{"RotativeName","是否循环"},
						{"BailRatio","最低保证金比率"},
						{"TermMonth","期限(月)"},
						{"LineSum1","最高额度金额"},
						{"LineSum2","敞口限额"},
						{"Currency","币种"}
					};
	
		sSql =  " select LineID,CustomerID,CustomerName,BusinessType, "+
				" getBusinessName(BusinessType) as BusinessTypeName, TermMonth,"+
				" Rotative,getItemName('YesNo',Rotative) as RotativeName, "+
				" BailRatio,LineSum1,LineSum2,getItemName('Currency',Currency) as Currency "+
				" from CL_INFO "+
				" Where ParentLineID = '"+sParentLineID+"' ";	
	//如果是同业客户取下面sql	
	String 	sSql1 = "select BusinessType from CL_INFO where LineID = '"+sParentLineID+"' ";
	rs= Sqlca.getASResultSet(sSql1);
	if(rs.next())
	{
		sBusinessType = rs.getString("BusinessType");
		if(sBusinessType == null) sBusinessType="";
	}
	rs.getStatement().close();
	if(sBusinessType.equals("3015"))
	{
		sSql =  " select LineID,CustomerID,CustomerName,BusinessType, "+
				" getItemName('BusinessTypeTY',BusinessType) as BusinessTypeName, TermMonth,"+
				" Rotative,getItemName('YesNo',Rotative) as RotativeName, "+
				" BailRatio,LineSum1,LineSum2,getItemName('Currency',Currency) as Currency "+
				" from CL_INFO "+
				" Where ParentLineID = '"+sParentLineID+"' ";	
	}else if(sBusinessType.equals("3050") || sBusinessType.equals("3060")) //联保小组，信用共同体
	 {
		 sSql = " select LineID,CustomerID,CustomerName, "+
				" MemberName, getItemName('AssessLevel',GETCGALevel(CustomerID,MemberID)) as AssessLevel, LineSum1,LineSum2,getItemName('Currency',Currency) as Currency ,TermMonth,Rotative "+
				" from CL_INFO "+
				" Where ParentLineID = '"+sParentLineID+"' ";	
	 }
		
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID,",true);		
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("LineID,BusinessType,Rotative,LineSum2,BailRatio",false);
	if(sBusinessType.equals("3050"))
	{
		doTemp.setHeader("CustomerName","联保小组名称");
		doTemp.setHeader("MemberName","成员名称");
		doTemp.setVisible("MemberName",true);
		doTemp.setVisible("BusinessTypeName",false);
	}
	if(sBusinessType.equals("3060"))
	{
		doTemp.setHeader("CustomerName","信用共同体名称");
		doTemp.setHeader("MemberName","成员名称");
		doTemp.setVisible("MemberName",true);
		doTemp.setVisible("BusinessTypeName",false);
	}
	//设置格式
	doTemp.setType("LineSum1,LineSum2,BailRatio","Number");
	doTemp.setUnit("BailRatio","(%)");
	doTemp.setAlign("BusinessTypeName","2");		
	//设置Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	//定义后续事件
	dwTemp.setEvent("AfterDelete","!CreditLine.DeleteCLLimitationRelative(#LineID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//组织进行合计用参数 add by zrli 
	String[][] sListSumHeaders = {{"BusinessSum","金额"},
								  {"Currency","币种"}
								 };
	String sListSumSql = "Select getItemName('Currency',Currency) as Currency,Sum(LineSum1) as BusinessSum from CL_INFO "+doTemp.WhereClause +" group by  Currency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"false","","Button","限制条件","新增/查看/修改限制条件","LimitationView()",sResourcesPath},
		{"true","","Button","汇总","金额汇总","listSum()",sResourcesPath}
		};
		if(sObjectType.equals("BusinessContract")){
			sButtons[0][0]= "false";
			sButtons[2][0]= "false";
		}
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditLine/SubCreditLineInfo.jsp?ParentLineID=<%=sParentLineID%>&BusinessType=<%=sBusinessType%>","_self","");
	}
	
	/*~[Describe=新增/查看/修改限制条件;InputParam=无;OutPutParam=无;]~*/
	function LimitationView()
	{
		sSubLineID = getItemValue(0,getRow(),"LineID");
		if (typeof(sSubLineID)=="undefined" || sSubLineID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("CreidtLineLimitationView","/CreditManage/CreditLine/CreidtLineLimitationView.jsp","SubLineID="+sSubLineID,"","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sLineID = getItemValue(0,getRow(),"LineID");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSubLineID = getItemValue(0,getRow(),"LineID");
		var sCLBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSubLineID) == "undefined" || sSubLineID.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenPage("/CreditManage/CreditLine/SubCreditLineInfo.jsp?ParentLineID=<%=sParentLineID%>&BusinessType=<%=sBusinessType%>&SubLineID="+sSubLineID+"&CLBusinessType="+sCLBusinessType,"_self","");
	}

	/*~[Describe=金额汇总;InputParam=无;OutPutParam=无;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
