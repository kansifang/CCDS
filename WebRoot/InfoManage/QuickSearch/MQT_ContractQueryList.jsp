<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zrli 
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
							{"SerialNo","合同流水号"},
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称"},
							{"BusinessType","业务品种"},										
							{"BusinessTypeName","业务品种"},										
							{"BusinessSum","金额"},
							{"Balance","余额"},										
							{"Currency","币种"},
							{"BusinessRate","执行月利率(‰)"},
							{"InterEstBalance1","表内欠息"},
							{"InterEstBalance2","表外欠息"},
							{"PutOutDate","合同起始日"},
							{"Maturity","合同到期日"},
							{"VouchType","主要担保方式"},
							{"VouchTypeName","主要担保方式"},
							{"ManageOrgName","管户机构"},
							{"ManageUserName","管户人"}
							}; 
	if(sCustomerType.equalsIgnoreCase("1")){
		sSql =	" select SerialNo,CustomerID,CustomerName,BusinessType,BusinessTypeName, "+
				" BusinessCurrency,CurrencyName,BusinessSum,Balance, "+
				" BusinessRate,InterEstBalance1,InterEstBalance2, "+
				" PutOutDate,Maturity,VouchType,VouchTypeName, "+
				" ManageOrgID,ManageOrgName,ManageUserID,ManageUserName " +
		       	" from MQT_ENTBC "+
		       	" where ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("2")){
		sSql =	" select SerialNo,CustomerID,CustomerName,BusinessType,BusinessTypeName, "+
				" BusinessCurrency,CurrencyName,BusinessSum,Balance, "+
				" BusinessRate,InterEstBalance1,InterEstBalance2, "+
				" PutOutDate,Maturity,VouchType,VouchTypeName, "+
				" ManageOrgID,ManageOrgName,ManageUserID,ManageUserName " +
		       	" from MQT_ENTBC "+
		       	" where ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("3")){
		sSql =	" select BC.SerialNo,BC.CustomerID,BC.CustomerName,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
				" getItemName('Currency',BC.BusinessCurrency) as Currency,BC.BusinessSum,BC.Balance, "+
				" BC.BusinessRate,BC.InterEstBalance1,BC.InterEstBalance2, "+
				" BC.PutOutDate,BC.Maturity,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName " +
		       	" from BUSINESS_CONTRACT BC ,IND_INFO II"+
		       	" where BC.CustomerID = II.CustomerID "+
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
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 		
	//设置对齐方式
	doTemp.setAlign("BusinessSum,BusinessRate,Balance","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setType("BusinessSum,BusinessRate,Balance,TermMonth","Number");
	doTemp.setVisible("VouchType,BusinessType",false);
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and Length(ItemNo)>3");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE ");
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
