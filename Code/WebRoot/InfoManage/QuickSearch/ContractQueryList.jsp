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
	String sCustomerType =""; //客户类型 1为公司客户 2为同业客户 3为个人客户 4为信用共同体
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
							{"SerialNo","合同流水号"},
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称"},
							{"BusinessType","业务品种"},										
							{"BusinessTypeName","业务品种"},
							{"OccurType","发生类型"},										
							{"OccurTypeName","发生类型"},
							{"BusinessSum","金额"},
							{"Balance","余额"},										
							{"Currency","币种"},
							{"RateFloat","利率浮动比率"},
							{"BusinessRate","执行月利率(‰)"},
							{"InterEstBalance1","表内欠息"},
							{"InterEstBalance2","表外欠息"},
							{"NormalBalance","正常余额"},
							{"OverdueBalance","逾期余额"},
							{"DullBalance","呆滞余额"},
							{"BadBalance","呆账余额"},
							{"PutOutDate","合同起始日"},
							{"Maturity","合同到期日"},
							{"FinishDate","终结日期"},
							{"ClassifyResult","当前风险分类结果（账面）"},
							{"ClassifyResultName","当前风险分类结果（账面）"},
							{"BaseClassifyResult","当前风险分类结果（实际）"},
							{"BaseClassifyResultName","当前风险分类结果（实际）"},
							{"VouchType","主要担保方式"},
							{"VouchTypeName","主要担保方式"},
							{"ManageOrgName","管户机构"},
							{"ManageUserName","管户人"},
							{"FinancePlatformFlag","是否融资平台"}
							}; 
	if(sCustomerType.equalsIgnoreCase("1")){
		sSql =	" select BC.SerialNo,BC.CustomerID,BC.CustomerName,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
				" BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
				" getItemName('Currency',BC.BusinessCurrency) as Currency,BC.BusinessSum,BC.Balance,BC.RateFloat, "+
				" BC.BusinessRate,BC.InterEstBalance1,BC.InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance,"+
				" BC.PutOutDate,BC.Maturity,BC.FinishDate,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName,"+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT"+
		       	" where BT.TypeNo = BC.BusinessType and BT.Attribute1 = '1' and BC.BusinessType not in ('3060','3015')  "+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("2")){
		sSql =	" select BC.SerialNo,BC.CustomerID,BC.CustomerName,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
				" BC.OccurType,getItemName('',BC.OccurType) as OccurTypeName,"+
				" getItemName('Currency',BC.BusinessCurrency) as Currency,BC.BusinessSum,BC.Balance,BC.RateFloat, "+
				" BC.BusinessRate,BC.InterEstBalance1,BC.InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance, "+
				" BC.PutOutDate,BC.Maturity,BC.FinishDate,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName,"+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_CONTRACT BC "+
		       	" where BC.BusinessType = '3015' "+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("3")){
		sSql =	" select BC.SerialNo,BC.CustomerID,BC.CustomerName,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
				" BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
				" getItemName('Currency',BC.BusinessCurrency) as Currency,BC.BusinessSum,BC.Balance,BC.RateFloat, "+
				" BC.BusinessRate,BC.InterEstBalance1,BC.InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance, "+
				" BC.PutOutDate,BC.Maturity,BC.FinishDate,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName,"+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT"+
		       	" where BT.TypeNo = BC.BusinessType and BT.Attribute1 = '2' "+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";		
	}
	else if(sCustomerType.equalsIgnoreCase("4")){
		sSql =	" select BC.SerialNo,BC.CustomerID,BC.CustomerName,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
				" BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
				" getItemName('Currency',BC.BusinessCurrency) as Currency,BC.BusinessSum,BC.Balance,BC.RateFloat, "+
				" BC.BusinessRate,BC.InterEstBalance1,BC.InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance,"+
				" BC.PutOutDate,BC.Maturity,BC.FinishDate,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResult,"+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT"+
		       	" where BT.TypeNo = BC.BusinessType and BT.Attribute1 = '1' and BC.BusinessType = '3060'  "+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	doTemp.setKey("CustomerID",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName,ManageOrgName","style={width:250px} ");  
	doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 	
	doTemp.setHTMLStyle("InterEstBalance1,InterEstBalance2","style={width:80px} "); 		
	
	//设置对齐方式
	doTemp.setAlign("BusinessSum,BusinessRate,Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum,RateFloat","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity,FinishDate","3");
	doTemp.setType("BusinessSum,BusinessRate,Balance,TermMonth,InterEstBalance1,InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance","Number");
	doTemp.setVisible("VouchType,BusinessType,ClassifyResult,BaseClassifyResult,OccurType,InterEstBalance1,InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance,FinancePlatformFlag",false);
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and Length(ItemNo)>3");
	doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' ");
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWCode("FinancePlatformFlag","YesNo");
		doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)>2");	
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}else if("3".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)=2");	
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%2%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}else if("2".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo='3015' ");
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
	doTemp.setFilter(Sqlca,"10","OccurType","");
	doTemp.setFilter(Sqlca,"11","ClassifyResult","");	
	doTemp.setFilter(Sqlca,"12","BaseClassifyResult","");
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setFilter(Sqlca,"13","FinancePlatformFlag","Operators=EqualsString;");	
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
		{"true","","Button","客户交易流水信息","客户交易流水信息","viewBusinessSerialInfo()",sResourcesPath},
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
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
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
	/*~[Describe=查看客户交易流水信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewBusinessSerialInfo()
	{
		//获得客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			popComp("BusinessSerialInfoList","/InfoManage/QuickSearch/BusinessSerialInfoList.jsp","ComponentName=公司客户交易流水信息列表&CustomerID="+sCustomerID,"","");
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
