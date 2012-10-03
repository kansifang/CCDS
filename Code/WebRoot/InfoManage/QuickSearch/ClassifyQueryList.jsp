<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: 风险分类信息快速查询
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：风险分类信息快速查询
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "风险分类信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	
	//定义表头文件（合同）
	String sHeaders[][] = {
									{"CustomerID","客户编号"},
									{"CustomerName","客户名称"},
									{"ObjectNo","合同流水号"},
									{"BusinessTypeName","业务品种"},
									{"BusinessType","业务类型"},
									{"AccountMonth","分类截至日期"},
									{"BusinessSum","金额"},
									{"Balance","余额"},
									{"PutOutDate","起始日"},
									{"Maturity","到期日"},
									{"Currency","币种"},
									{"InterEstBalance1","表内欠息"},
									{"InterEstBalance2","表外欠息"},
									{"VouchType","主要担保方式"},
									{"VouchTypeName","主要担保方式"},
									{"Result2Name","客户经理初分结果（账面）"},
									{"ClassifyLevel2","客户经理初分结果（实际）"},
									{"ClassifyResult","当前风险分类结果（账面）"},
									{"ClassifyResultName","当前风险分类结果（账面）"},
									{"BaseClassifyResult","当前风险分类结果（实际）"},
									{"BaseClassifyResultName","当前风险分类结果（实际）"},
									{"FinallyResult","当期风险分类结果（账面）"},
									{"FinallyResultName","当期风险分类结果（账面）"},
									{"FinallyBaseResult","当期风险分类结果（实际）"},
									{"FinallyBaseResultName","当期风险分类结果（实际）"},
									{"OperateOrgID","经办机构"},
									{"OperateOrgName","经办机构"},
									{"OperateUserID","经办人"},
									{"OperateUserName","经办人"},
									{"FinancePlatformFlag","是否融资平台"}
							}; 
	if("1".equalsIgnoreCase(sCustomerType)){						
		sSql = " select CR.ObjectType,Cr.ObjectNo,CR.SerialNo,BC.CustomerID,BC.CustomerName, " +
					" BC.BusinessType,CR.AccountMonth,getBusinessName(BC.BusinessType) as BusinessTypeName, " +
					" getItemName('Currency',BusinessCurrency) as Currency,BC.BusinessSum, BC.Balance, " +
					" BC.InterEstBalance1,BC.InterEstBalance2, "+
					" BC.PutOutDate,BC.Maturity,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
					" getItemName('ClassifyResult',CR.ClassifyLevel) as Result2Name , "+
					" getItemName('ClassifyResult',CR.ClassifyLevel2) as ClassifyLevel2 , "+
					" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName , "+
					" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName , "+
					" CR.FinallyResult,getItemName('ClassifyResult',CR.FinallyResult) as FinallyResultName , "+
					" CR.FinallyBaseResult,getItemName('ClassifyResult',CR.FinallyBaseResult) as FinallyBaseResultName , "+
					" OperateOrgID,getOrgName(BC.OperateOrgID) as OperateOrgName, "+
					" OperateUserID,getUserName(BC.OperateUserID) as OperateUserName, "+
					" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       		" from CLASSIFY_RECORD CR,BUSINESS_CONTRACT BC ,ENT_INFO EI" +
					" where CR.ObjectNo = BC.SerialNo "+
					" and BC.CustomerID = EI.CustomerID  and OrgNature like '01%' and OrgNature <>'07' "+
					" and CR.ObjectType = 'BusinessContract' "+
					" and ManageOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if("3".equalsIgnoreCase(sCustomerType)){
		sSql = " select CR.ObjectType,Cr.ObjectNo,CR.SerialNo,BC.CustomerID,BC.CustomerName, " +
					" BC.BusinessType,CR.AccountMonth,getBusinessName(BC.BusinessType) as BusinessTypeName, " +
					" getItemName('Currency',BusinessCurrency) as Currency,BC.BusinessSum, BC.Balance, " +
					" BC.InterEstBalance1,BC.InterEstBalance2, "+
					" BC.PutOutDate,BC.Maturity,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
					" getItemName('ClassifyResult',CR.ClassifyLevel) as Result2Name, "+
					" getItemName('ClassifyResult',CR.ClassifyLevel2) as ClassifyLevel2 , "+
					" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName , "+
					" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName , "+
					" CR.FinallyResult,getItemName('ClassifyResult',CR.FinallyResult) as FinallyResultName , "+
					" CR.FinallyBaseResult,getItemName('ClassifyResult',CR.FinallyBaseResult) as FinallyBaseResultName , "+
					" OperateOrgID,getOrgName(BC.OperateOrgID) as OperateOrgName, "+
					" OperateUserID,getUserName(BC.OperateUserID) as OperateUserName, "+
					" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       		" from CLASSIFY_RECORD CR,BUSINESS_CONTRACT BC ,IND_INFO II" +
					" where CR.ObjectNo = BC.SerialNo "+
					" and BC.CustomerID = II.CustomerID "+ 
					" and CR.ObjectType = 'BusinessContract' "+
					" and ManageOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	/*
	//定义表头文件（借据）
	String sHeaders[][] = {
									{"CustomerID","客户编号"},
									{"CustomerName","客户名称"},
									{"ObjectNo","借据流水号"},
									{"BusinessTypeName","业务品种"},
									{"BusinessType","业务类型"},
									{"BusinessSum","金额"},
									{"Balance","余额"},
									{"PutOutDate","起息日"},
									{"Maturity","到期日"},
									{"Currency","币种"},
									{"FinallyResult","认定结果"},
									{"FinallyResultName","认定结果"},
									{"OperateOrgName","经办机构"},
									{"OperateUserName","经办人"}
							}; 
							
	sSql =		" select CR.ObjectType,Cr.ObjectNo,CR.SerialNo,BD.CustomerID,BD.CustomerName, " +
				" BD.BusinessType,getBusinessName(BD.BusinessType) as BusinessTypeName, " +
				" getItemName('Currency',BD.BusinessCurrency) as Currency,BD.BusinessSum, BC.Balance" +
				" BD.PutOutDate,BD.Maturity,CR.FinallyResult,getItemName('ClassifyResult',CR.FinallyResult) as FinallyResultName " +
				" getOrgName(BD.OperateOrgID) as OperateOrgName, "+
				" getUserName(BD.OperateUserID) as OperateUserName,"+
	       		" from CLASSIFY_RECORD CR,BUSINESS_DUEBIll BD ,ENT_INFO EI" +
				" where CR.ObjectNo = BD.SerialNo "+
				" and BD.CustomerID = EI.CustomerID  and OrgNature like '01%' and OrgNature <>'0107' "+
				" and CR.ObjectType = 'BusinessDueBill' "+
				" and BD.OperateOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	*/
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("CR.SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CLASSIFY_RECORD";
	
	//设置关键字
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);

	//设置不可见项
	doTemp.setVisible("FinallyResult,FinallyBaseResult,ClassifyResultName,BaseClassifyResultName,ClassifyResult,BaseClassifyResult,ObjectType,SerialNo,CustomerID,BusinessType,VouchType,OperateOrgID,OperateUserID,FinancePlatformFlag",false);
	doTemp.setCheckFormat("PutOutDate,Maturity,FinishDate","3");
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("Currency","style={width:60px} ");
	doTemp.setHTMLStyle("InterEstBalance1,InterEstBalance2","style={width:80px} ");	  
	doTemp.setHTMLStyle("CustomerName,OperateOrgName","style={width:250px} "); 		
	//设置对齐方式
	doTemp.setAlign("BusinessSum","3");
	doTemp.setType("BusinessSum,Balance","Number");

	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum","2");
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWCode("FinancePlatformFlag","YesNo");
		doTemp.setDDDWSql("FinallyResult,FinallyBaseResult,ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)>2");	
	}else if("3".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("FinallyResult,FinallyBaseResult,ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)=2");	
	}
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}else if("3".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%2%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}
	
	doTemp.setDDDWSql("OperateOrgID","select OrgID,OrgName from ORG_INFO");
	//doTemp.setDDDWSql("OperateUserID","select UserID,UserName from USER_INFO");
	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","BusinessType","");
	doTemp.setFilter(Sqlca,"3","ObjectNo","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","AccountMonth","");
	doTemp.setFilter(Sqlca,"6","FinallyResult","");
	doTemp.setFilter(Sqlca,"7","FinallyBaseResult","");
	doTemp.setFilter(Sqlca,"8","Balance","");
	doTemp.setFilter(Sqlca,"9","OperateOrgID","");
	doTemp.setFilter(Sqlca,"10","OperateUserID","");
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
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectNo =getItemValue(0,getRow(),"ObjectNo");
		sObjectType =getItemValue(0,getRow(),"ObjectType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			OpenComp("ClassifyQueryInfo","/InfoManage/QuickSearch/ClassifyQueryInfo.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo, "_bank",OpenStyle);
		}

	}	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
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
