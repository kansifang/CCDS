<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29
		Tester:
		Describe: 客户管理权维护
		Input Param:
			RightType：权限类型
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户管理权维护信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数	
	//获得组件参数	
  	String sRightType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));  
	if(sRightType == null) sRightType = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = {     
                            {"CustomerID","客户编号"},
                            {"CustomerName","客户名称"},
                            {"InputOrgID","登记机构"},
                            {"UserName","申请客户经理"},
                            {"OrgName","机构名称"},                           
                            {"BelongAttribute","主办权人"}
			              };   	  		   		
	
	String sSql = 	" select CustomerID, "+
	                " getCustomerName(CustomerID) as CustomerName,"+               
	                " UserID,getUserName(UserID) as UserName," +
	                " OrgID, getOrgName(OrgID) as OrgName, "+
	                " getItemName('YesNo',BelongAttribute) as BelongAttribute"+                
	                " from CUSTOMER_BELONGLOG CB " +
	                " where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
	                "  and approveuserid = '"+CurUser.UserID+"' and approveorgid = '"+CurUser.OrgID+"'";	

	 if(CurUser.hasRole("0A0")||CurUser.hasRole("2A0")||CurUser.hasRole("0M1"))//总行个人客户权限管理员
    {
    	sSql = sSql+" and exists(select 1 from CUSTOMER_INFO CI where CustomerID=CB.CustomerID and CustomerType like '03%')";
	}
	else if(CurUser.hasRole("0D0")||CurUser.hasRole("2D0")||CurUser.hasRole("0M0")){//总行公司客户权限管理员
    	sSql = sSql+" and exists(select 1 from CUSTOMER_INFO CI where CustomerID=CB.CustomerID and CustomerType not like '03%')";
    }
    //add end 
        
  
  	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_BELONG";
	doTemp.setKey("CustomerID,OrgID,UserID",true);	 //为后面的删除
	//设置不可见项
	doTemp.setVisible("OrgID,UserID",false);
	//通常用于外部存储函数得到的字段
	doTemp.setUpdateable("UserName,OrgName",false);   	
    doTemp.setHTMLStyle("CustomerName"," style={width:200px} "); 
    doTemp.setHTMLStyle("BelongAttribute"," style={width:60px} "); 
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,OrgName,UserName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);	
	if(!doTemp.haveReceivedFilterCriteria()) 
	{    
	    if(sRightType.equals("02"))
	    {
	        doTemp.WhereClause+=" and 1=2 ";
	    }
	}
	if(sRightType.equals("01"))
	{
	    doTemp.setVisible("BelongAttribute",false);
	}
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
	//查询区的页面代码
	String sCriteriaAreaHTML = ""; 
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
		{(sRightType.equals("02")?"true":"false"),"","Button","管户权操作","查看并可修改客户维护基本信息","viewAndEdit()",sResourcesPath},
		{(sRightType.equals("01")?"true":"false"),"","Button","审阅申请","审阅申请","CheckApply()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		sOrgID   = getItemValue(0,getRow(),"OrgID");
		sUserID   = getItemValue(0,getRow(),"UserID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{       
			popComp("RightModifyInfo","/SystemManage/GeneralSetup/RightModifyInfo.jsp","CustomerID="+sCustomerID+"&OrgID="+sOrgID+"&UserID="+sUserID,"");
		}
	}
	
	/*~[Describe=审阅申请;InputParam=无;OutPutParam=无;]~*/
	function CheckApply()
	{
	    sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sUserID = getItemValue(0,getRow(),"UserID");
		sOrgID = getItemValue(0,getRow(),"OrgID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","Check=Y&CustomerID="+sCustomerID+"&UserID="+sUserID+"&OrgID="+sOrgID,"");
		reloadSelf();
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
	showFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>