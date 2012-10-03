<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: 合同信息快速查询
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：合同信息快速查询
			          
		Output param:
		History Log: 
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
							{"SerialNo","借据流水号"},
							{"RelativeSerialNo2","合同流水号"},
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称"},
							{"BusinessType","业务品种"},										
							{"BusinessTypeName","业务品种"},										
							{"BusinessSum","金额"},
							{"Balance","余额"},										
							{"Currency","币种"},
							{"RateFloat","利率浮动比率"},
							{"ActualBusinessRate","执行月利率(‰)"},
							{"InterEstBalance1","表内欠息"},
							{"InterEstBalance2","表外欠息"},
							{"NormalBalance","正常余额"},
							{"OverdueBalance","逾期余额"},
							{"DullBalance","呆滞余额"},
							{"BadBalance","呆账余额"},
							{"PutOutDate","借据起始日"},
							{"Maturity","借据到期日"},
							{"VouchType","主要担保方式"},
							{"VouchTypeName","主要担保方式"},
							{"ManageOrgName","管户机构"},
							{"ManageUserName","管户人"},
							{"MfOrgName","出账机构"},
							{"FinancePlatformFlag","是否融资平台"}
							}; 
	if("1".equalsIgnoreCase(sCustomerType)){
		sSql =	" select BD.SerialNo,BD.RelativeSerialNo2,BD.CustomerID,BD.CustomerName,BD.BusinessType, "+
				" getBusinessName(BD.BusinessType) as BusinessTypeName, "+
				" getItemName('Currency',BD.BusinessCurrency) as Currency,BD.BusinessSum,BD.Balance,BC.RateFloat, BD.ActualBusinessRate, "+
				" BD.InterEstBalance1,BD.InterEstBalance2,BD.NormalBalance,BD.OverdueBalance,BD.DullBalance,BD.BadBalance, "+
				" BD.PutOutDate,BD.Maturity,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" getOrgName(BD.MfOrgID) as MfOrgName,"+
				" GETCustomerFPFlag(BD.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT"+
		       	" where BT.TypeNo = BD.BusinessType and BT.Attribute1 = '1' "+
				" and BD.RelativeSerialNo2 = BC.SerialNo and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if("3".equalsIgnoreCase(sCustomerType)){
				sSql =	" select BD.SerialNo,BD.RelativeSerialNo2,BD.CustomerID,BD.CustomerName,BD.BusinessType, "+
				" getBusinessName(BD.BusinessType) as BusinessTypeName, "+
				" getItemName('Currency',BD.BusinessCurrency) as Currency,BD.BusinessSum,BD.Balance,BC.RateFloat, BD.ActualBusinessRate, "+
				" BD.InterEstBalance1,BD.InterEstBalance2,BD.NormalBalance,BD.OverdueBalance,BD.DullBalance,BD.BadBalance, "+
				" BD.PutOutDate,BD.Maturity,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" getOrgName(BD.MfOrgID) as MfOrgName,"+
				" GETCustomerFPFlag(BD.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT"+
		       	" where BT.TypeNo = BD.BusinessType and BT.Attribute1 = '2' "+
				" and BD.RelativeSerialNo2 = BC.SerialNo and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("BD.SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	doTemp.setKey("CustomerID",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("ActualBusinessRate","style={width:60px} "); 		
	//设置对齐方式
	doTemp.setAlign("BusinessSum,ActualBusinessRate,Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum,NormalBalance,OverdueBalance,DullBalance,BadBalance,RateFloat","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setType("BusinessSum,ActualBusinessRate,Balance,TermMonth,InterEstBalance1,InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance","Number");
	doTemp.setVisible("VouchType,BusinessType,BusinessSum,FinancePlatformFlag",false);
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and Length(ItemNo)>3");
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWCode("FinancePlatformFlag","YesNo");
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where Attribute1 = '1' and typeno not like '3%' ");
	}else if("3".equalsIgnoreCase(sCustomerType)) {
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where Attribute1 = '2' and typeno not like '3%'");
	}
	//生成查询框
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.setFilter(Sqlca,"3","BusinessType","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","Balance","");
	doTemp.setFilter(Sqlca,"6","ManageOrgName","");
	doTemp.setFilter(Sqlca,"7","PutOutDate","");
	doTemp.setFilter(Sqlca,"8","Maturity","");	
	doTemp.setFilter(Sqlca,"9","VouchType","");	
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setFilter(Sqlca,"10","FinancePlatformFlag","Operators=EqualsString;");	
	}
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
		{"true","","Button","业务合同详情","业务合同详情","viewTab()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
	};
	if(CurUser.hasRole("095")||CurUser.hasRole("0A2")||CurUser.hasRole("0B5")||CurUser.hasRole("0C2")||
	 CurUser.hasRole("0D2")||CurUser.hasRole("0E9")||CurUser.hasRole("0F4")||CurUser.hasRole("0H5")||
	 CurUser.hasRole("0I4")||CurUser.hasRole("0J1")||CurUser.hasRole("282")||CurUser.hasRole("295")||
	 CurUser.hasRole("2A4")||CurUser.hasRole("2B9")||CurUser.hasRole("2C2")||CurUser.hasRole("2D4")||
	 CurUser.hasRole("2E4")||CurUser.hasRole("2G5")||CurUser.hasRole("2H5")||CurUser.hasRole("2I2")||
	 CurUser.hasRole("421")||CurUser.hasRole("495"))
	{
		sButtons[2][0] = "false";
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
		sSerialNo =getItemValue(0,getRow(),"RelativeSerialNo2");	
		
	    sObjectType = "AfterLoan";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"RelativeSerialNo2");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
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
