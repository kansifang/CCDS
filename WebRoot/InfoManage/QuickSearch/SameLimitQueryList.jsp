<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zwhu 2009-08-30
		Tester:
		Describe: 流水台帐列表;
		Input Param:

		Output Param:
			
		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "";
	String sCustomerType =""; //客户类型 1为公司客户 2为同业客户 3为个人客户
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType="";
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 
							{"LineID","额度编号"},							
							{"ApproveSerialNo","额度批复号"},
							{"BusinessType","业务品种"},
							{"BusinessTypeName","业务品种"},
							{"Currency","币种"},
							{"LineSum1","金额"},
							{"FreezeFlag","状态"},										
							{"FreezeFlagName","状态"},										
							{"LineEffDate","使用日期"},
							{"PutOutDeadLine","截止日期"},										
							{"InputUser","经办人"},
							{"InputOrg","经办机构"}
							}; 
	sSql =	" select CI.LineID,CI.ApproveSerialNo,CI.BusinessType,getBusinessName(CI.BusinessType) as BusinessTypeName , "+ 
			" getItemName('Currency',CI.Currency) as Currency,CI.LineSum1,"+
			" FreezeFlag,getItemName('FreezeFlag',CI.FreezeFlag) as FreezeFlagName ,CI.LineEffDate,CI.PutOutDeadLine, "+
			" getUserName(CI.InputUser) as InputUser ,getOrgName(CI.InputOrg) as InputOrg "+
			" from CL_INFO CI,ENT_INFO EI "+
			" WHERE CI.CustomerID = EI.CustomerID and EI.OrgNature like '07%' "+
			" and CI.InputOrg in (select OrgID from ORG_INFO where SortNo like '" +CurOrg.SortNo+"%') ";	
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("LineID");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	doTemp.setKey("LineID",true);	
	//设置对齐方式
	doTemp.setAlign("LineSum1","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("LineSum1","2");	
	doTemp.setCheckFormat("LineEffDate,PutOutDeadLine","3");
	doTemp.setType("LineSum1","Number");
	doTemp.setVisible("LineID,BusinessType,FreezeFlag",false);
	doTemp.setDDDWSql("FreezeFlag","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'FreezeFlag'");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE ");
	doTemp.setHTMLStyle("InputOrg","style={width:250px} ");  	
	//生成查询框
	doTemp.setFilter(Sqlca,"1","ApproveSerialNo","");
	doTemp.setFilter(Sqlca,"2","BusinessType","");	
	doTemp.setFilter(Sqlca,"3","LineEffDate","");
	doTemp.setFilter(Sqlca,"4","PutOutDeadLine","");
	doTemp.setFilter(Sqlca,"5","InputUser","");
	doTemp.setFilter(Sqlca,"6","InputOrg","");
	doTemp.setFilter(Sqlca,"7","FreezeFlag","");
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
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
		{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
	};
	
	if(CurUser.hasRole("095")||CurUser.hasRole("0A2")||CurUser.hasRole("0B5")||CurUser.hasRole("0C2")||
	 CurUser.hasRole("0D2")||CurUser.hasRole("0E9")||CurUser.hasRole("0F4")||CurUser.hasRole("0H5")||
	 CurUser.hasRole("0I4")||CurUser.hasRole("0J1")||CurUser.hasRole("282")||CurUser.hasRole("295")||
	 CurUser.hasRole("2A4")||CurUser.hasRole("2B9")||CurUser.hasRole("2C2")||CurUser.hasRole("2D4")||
	 CurUser.hasRole("2E4")||CurUser.hasRole("2G5")||CurUser.hasRole("2H5")||CurUser.hasRole("2I2")||
	 CurUser.hasRole("421")||CurUser.hasRole("495"))
	{
		sButtons[1][0] = "false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sLineID =getItemValue(0,getRow(),"LineID");	
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			popComp("SameLimitQueryInfo","/InfoManage/QuickSearch/SameLimitQueryInfo.jsp","ComponentName=同业客户额度详细信息&LineID="+sLineID,"","");		
		}

	}		
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	

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
