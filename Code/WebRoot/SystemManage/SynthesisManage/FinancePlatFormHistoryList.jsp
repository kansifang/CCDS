<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:xhyong
		Tester:
		Describe: 融资平台历史记录
		Input Param:
	              --sComponentName:组件名称
		Output Param:
		
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "融资平台历史记录"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));

	if(sSerialNo == null||"undefined".equals(sSerialNo)) sSerialNo = "";
	//定义变量
	String sSql="";//--存放sql语句
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = { 			                   
		        {"CustomerName","客户名称"},						      
		        {"UserName","登记人"},
		        {"OrgName","登记机构"},
		        {"CustomerID","客户编号"},
		        {"PlatformType","平台类型"},
		        {"DealClassify","处置分类"},
		        {"UpdateOrgName","更新机构"},
	            {"UpdateUser","更新人"},
	            {"UpdateDate","更新时间"}  
	   };   				   		
	
	if(sSerialNo=="" )
	{
		sSql = " select SerialNo,CustomerName,nvl(CustomerID,'') as CustomerID,getItemName('FinancePlatformType',PlatformType) as PlatformType,getItemName('DealClassify',DealClassify) as DealClassify, "+
		" getOrgName(InputOrgID) as OrgName,getUserName(InputUserID) as UserName,getOrgName(UPDATEORG) as UpdateOrgName,getUserName(UpdateUser) as UpdateUser,UpdateDate "+
		" from CUSTOMER_FINANCEPLATFORMLOG where 1=1 order by UpdateDate ";
	}else
	{
		sSql = " select SerialNo,CustomerName,nvl(CustomerID,'') as CustomerID,getItemName('FinancePlatformType',PlatformType) as PlatformType,getItemName('DealClassify',DealClassify) as DealClassify, "+
		" getOrgName(InputOrgID) as OrgName,getUserName(InputUserID) as UserName,getOrgName(UPDATEORG) as UpdateOrgName,getUserName(UpdateUser) as UpdateUser,UpdateDate "+
		" from CUSTOMER_FINANCEPLATFORMLOG where SerialNo='"+sSerialNo+"' order by UpdateDate ";
	}						 
  	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "CUSTOMER_FINANCEPLATFORMlog";
	doTemp.setKey("SerialNo",true);		
	//设置字段的不可见
	doTemp.setVisible("SerialNo",false);
	//生成查询条件
	//增加过滤器
	doTemp.setColumnAttribute(" ","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
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
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
//---------------------定义按钮事件------------------------------------
	
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
