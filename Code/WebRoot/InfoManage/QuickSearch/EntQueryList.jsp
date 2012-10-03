<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: 公司客户快速查询
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：公司客户快速查询
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "公司客户快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;//--存放sql语句
	String sComponentName;//--组件名称
	String PG_CONTENT_TITLE;
	//获得组件参数	
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	//定义表头文件
	String sHeaders[][] = { 							
										{"CustomerID","客户编号"},
										{"EnterpriseName","客户名称"},
										{"EnglishName","客户英文名"},
										{"CorpID","证件号码"},
										{"LicenseNo","工商营业执照号码"},
										{"OrgNatureName","机构类型"},
										{"Licensedate","营业执照登记日"},
										{"LicenseMaturity","营业执照到期日"},
										{"OrgType","企业类型"},
										{"OrgTypeName","企业类型"},
										{"IndustryType","国标行业分类"},
										{"IndustryTypeName","国标行业分类"},
										{"IndustryName","企业规模划分行业分类"},     //new
										{"IndustryDetailName","企业规模划分行业分类"}, //new
										{"MostBusiness","经营范围"},
										{"EmployeeNumber","职工人数"},
										{"TotalAssets","资产总额"},                //new
										{"SellSum","销售额"},                                   //new
										{"Scope","企业规模"},
										{"TechMidCorp","是否科技型中小企业"},      //new
										{"TechTopCorp","是否科技型小巨人企业"},   //new
										{"EnterpriseBelongName","企业隶属"},
										{"ListingCorpOrNotName","上市情况"},
										{"SetupDate","企业成立日期"},
										{"RCCurrencyName","注册资本币种"},
										{"RegisterCapital","注册资本"},
										{"RegisterAdd","注册地址"},
										{"CountryCodeName","所在国家(地区)"},
										{"RegionCodeName","省份、直辖市、自治区"},
										{"OfficeAdd","办公地址"},
										{"OfficeZIP","邮政编码"},
										{"OfficeTel","联系电话"},
										{"LoanCardNo","贷款卡号"},
										{"PCCurrencyName","实收资本币种"},
										{"PaiclUpCapital","实收资本"},
										{"HasIERightName","有无进出口经营权"},
										{"CreditLevel","本行即期信用等级"},
										{"InputUserName","登记人"},
										{"InputOrgName","登记机构"},
										{"InputDate","登记日期"},
										{"UpdateUserName","更新人员"},
										{"UpdateOrgName","更新机构"},
										{"UpdateDate","更新日期"},
										{"OtherCreditLevel","本行评估即期信用等级"},
										{"FinancePlatformFlag","是否融资平台"}
						   }; 
	
	sSql =	" select CustomerID,EnterpriseName,EnglishName,CorpID,LicenseNo, getItemName('CustomerType',OrgNature) as OrgNatureName,"+
			" Licensedate,LicenseMaturity, "+
			" OrgType,getItemName('OrgType',OrgType) as OrgTypeName,IndustryType, "+
			" getItemName('IndustryType',IndustryType) as IndustryTypeName, IndustryName,"+
			"getItemName('IndustryName',IndustryName) as IndustryDetailName,"+
			" MostBusiness,EmployeeNumber,TotalAssets,SellSum,Scope,TechMidCorp,TechTopCorp, "+
			" getItemName('EnterpriseBelong',EnterpriseBelong) as EnterpriseBelongName, "+
			" getItemName('ListingCorpCondition',ListingCorpOrNot) as ListingCorpOrNotName,SetupDate, "+
			" getItemName('Currency',RCCurrency) as RCCurrencyName,RegisterCapital, "+
			" RegisterAdd,getItemName('CountryCode',CountryCode) as CountryCodeName ,getItemName('AreaCode',RegionCode) as RegionCodeName,"+
			" OfficeAdd,OfficeZIP, "+
			" OfficeTel,LoanCardNo,getItemName('Currency',PCCurrency) as PCCurrencyName,"+
			" PaiclUpCapital,getItemName('HaveNot',HasIERight) as HasIERightName,CreditLevel, "+
			" getUserName(InputUserID) as InputUserName, "+
			" getOrgName(InputOrgID) as InputOrgName,InputDate, "+
			" getUserName(UpdateUserID) as UpdateUserName,"+
			" getOrgName(UpdateOrgID) as UpdateOrgName,UpdateDate ,OtherCreditLevel,FinancePlatformFlag "+
			" from ENT_INFO" +
			" where CustomerID in (select CustomerID from CUSTOMER_BELONG "+
			" where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')) "+
			" and OrgNature like '01%' and OrgNature <>'0107'";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);   
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	doTemp.UpdateTable= "ENT_INFO";
	doTemp.setKey("CustomerID",true);	 

	//设置字段类型
    doTemp.setType("RegisterCapital,PaiclUpCapital,TotalAssets,SellSum","Number");
    
    doTemp.setVisible("OrgType,IndustryType,OtherCreditLevel,IndustryName,FinancePlatformFlag,TechMidCorp,TechTopCorp",false);
    doTemp.setDDDWCode("OrgType","OrgType");
    doTemp.setDDDWCode("Scope","Scope");
    doTemp.setDDDWCode("FinancePlatformFlag,TechMidCorp,TechTopCorp","YesNo");
    doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
    doTemp.setDDDWSql("IndustryName","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryName' and isinuse = '1'");
    doTemp.setHTMLStyle("EnterpriseName,RegisterAdd,OfficeAdd","style={width:200px}");
    doTemp.setHTMLStyle("EmployeeNumber","style={width:30px}");    
    doTemp.setHTMLStyle("MostBusiness","style={width:250px}");   
    doTemp.setHTMLStyle("InputOrgName,UpdateOrgName,IndustryTypeName,IndustryDetailName","style={width:200px}"); 
       
    doTemp.setCheckFormat("Licensedate,LicenseMaturity,UpdateDate,InputDate","3");
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerID","");
	doTemp.setFilter(Sqlca,"2","CorpID","");
	doTemp.setFilter(Sqlca,"3","EnterpriseName","");
	doTemp.setFilter(Sqlca,"4","OrgType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","IndustryType","Operators=BeginsWith;");
	doTemp.setFilter(Sqlca,"6","IndustryName","Operators=BeginsWith;");
	doTemp.setFilter(Sqlca,"7","Scope","Operators=BeginsWith;");
	doTemp.setFilter(Sqlca,"8","RegisterCapital","");
	doTemp.setFilter(Sqlca,"9","RegisterAdd","");
	doTemp.setFilter(Sqlca,"10","OfficeAdd","");
	doTemp.setFilter(Sqlca,"11","LicenseNo","");
	doTemp.setFilter(Sqlca,"12","MostBusiness","");
	doTemp.setFilter(Sqlca,"13","CreditLevel","");
	doTemp.setFilter(Sqlca,"14","LoanCardNo","");
	doTemp.setFilter(Sqlca,"15","FinancePlatformFlag","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"16","TechMidCorp","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"17","TechTopCorp","Operators=EqualsString;");

	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);  //服务器分页
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteCustomer(#CustomerID)") ;
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
		//{"true","","Button","彻底删除客户信息","删除高管信息","deleteRecord()",sResourcesPath},
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
		//获得客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" ||sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");
		}

	}	
	
	/*~[Describe=查看客户交易流水信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewBusinessSerialInfo()
	{
		//获得客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" ||sCustomerID.length==0)
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
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" ||sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
    	if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    	{
   			as_del('myiframe0');
   			as_save('myiframe0');  //如果单个删除，则要调用此语句
   		}	
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
