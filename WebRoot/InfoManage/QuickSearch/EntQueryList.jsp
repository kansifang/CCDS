<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
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
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "公司客户快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
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
								{"OldIndustryType","老国标行业分类"},
								{"OldIndustryTypeName","老国标行业分类"},
								{"IndustryType","国标行业分类"},
								{"IndustryTypeName","国标行业分类"},
								{"IndustryType2","本行行业分类"},
								{"IndustryType2Name","本行行业分类"},
								{"MostBusiness","经营范围"},
								{"EmployeeNumber","职工人数"},
								{"OldScopeName","企业规模(老标准)"},
								{"ScopeName","企业规模"},
								{"EnterpriseBelongName","企业隶属"},
								{"ListingCorpOrNotName","是否上市公司"},
								{"RegisterCapital","注册资本"},
								{"RegisterAdd","注册地址"},
								{"CountryCodeName","所在国家(地区)"},
								{"RegionCodeName","省份、直辖市、自治区"},
								{"OfficeAdd","办公地址"},
								{"PCCurrencyName","实收资本币种"},
								{"PaiclUpCapital","实收资本"},
								{"CreditLevel","本行即期信用等级"},
								{"InBalance","表内余额"},
								{"OutBalance","表外余额"},
								{"OutChangkouBalance","表外敞口余额"},
								{"OverdueBalance","逾期余额"},
								{"InterestBalance1","表内欠息余额"},
								{"InterestBalance2","表外欠息余额"},
								{"InputUserName","登记人"},
								{"InputOrgName","登记机构"},
								{"UpdateUserName","更新人员"},
								{"UpdateOrgName","更新机构"},
								{"PreBalance","2.28贷款总额"},
								{"PreCKBalance","2.28承兑敞口"},
								{"Balance1","流动资金贷款"},
								{"Balance2","票据融资"},
								{"Balance3","项目贷款"},
								{"Balance4","法人按揭"},
								{"Balance5","房地产开发贷款"},
								{"Balance6","银团贷款"},
								{"Balance7","国际贸易融资(表内)"},
								{"Balance8","国内贸易融资"},
								{"Balance9","银行承兑汇票"},
								{"Balance10","国内信用证"},
								{"Balance11","保函"},
								{"Balance13","国际贸易融资(表外)"},
								{"Balance14","委托贷款"},
								{"Balance15","贷款承诺"},
								{"Balance16","垫款"},
								{"ReportBalance1","资产"},
								{"ReportBalance2","负债"},
								{"ReportBalance3","所有者权益"},
								{"Flag3Name","行内客户类型"},
								{"OrgName","直属行名称"},
								{"RealtyFlag","重点客户链接类型"},
								{"IndustryType1","特殊客户类型"},
								{"LastDate","最后一笔业务发生日期"},
								{"EconomyTypeName","经营类型"}
				   }; 
	
	if(CurUser.hasRole("098")){
		sSql =	" select getLastDate(EI.CustomerID) as LastDate,"+
		" getItemName('RealtyFlag',RealtyFlag) as RealtyFlag,getItemName('IndustryType1',IndustryType1) as IndustryType1, "+
		" getOrgName(getHeaderOrgID(InputOrgID)) as OrgName, "+
		" EI.CustomerID,EnterpriseName,CorpID,LicenseNo, "+
		" Licensedate,LicenseMaturity, "+
		" OrgType,getItemName('OrgType',OrgType) as OrgTypeName, "+
		" OldIndustryType,getItemName('OldIndustryType',substr(OldIndustryType,1,1))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,3))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,4))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,5)) as OldIndustryTypeName,"+
		" EI.IndustryType,getItemName('IndustryType',substr(EI.IndustryType,1,1))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,3))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,4))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,5)) as IndustryTypeName, "+
		" IndustryType2,getItemName('BankIndustryType',IndustryType2) as IndustryType2Name, "+
		" getItemName('CustomerType2',Flag3) as Flag3Name, "+
		" getItemName('EconomyType',EconomyType) as EconomyTypeName, "+
		" MostBusiness,EmployeeNumber,"+
		" getItemName('Scope',AUS.OldEntScope) as OldScopeName,"+
		" getItemName('Scope',Scope) as ScopeName, "+
		" getItemName('EnterpriseBelong',EnterpriseBelong) as EnterpriseBelongName, "+
		" getItemName('YesNo',ListingCorpOrNot) as ListingCorpOrNotName, "+
		" RegisterCapital, "+
		" RegisterAdd,getItemName('CountryCode',CountryCode) as CountryCodeName, "+
		" getItemName('AreaCode',RegionCode) as RegionCodeName,OfficeAdd, "+
		" getItemName('Currency',PCCurrency) as PCCurrencyName,"+
		" PaiclUpCapital,CreditLevel,"+
		" getCreditBalance(EI.CustomerID,'1') as InBalance, "+
		" getCreditBalance(EI.CustomerID,'2') as OutBalance, "+
		" getOutChangkouBalance(EI.CustomerID) as OutChangkouBalance, "+
		" getSumByType(EI.CustomerID,'10') as OverdueBalance ,"+
		" getSumByType(EI.CustomerID,'20') as InterestBalance1 ,"+
		" getSumByType(EI.CustomerID,'30') as InterestBalance2 ,"+
		" PreBalance,PreCKBalance,"+
		" getCreditBalance(EI.CustomerID,'1010') as Balance1, "+
		" getCreditBalance(EI.CustomerID,'1030') as Balance3, "+
		" getCreditBalance(EI.CustomerID,'1040') as Balance4, "+
		" getCreditBalance(EI.CustomerID,'1050') as Balance5, "+
		" getCreditBalance(EI.CustomerID,'1060') as Balance6, "+
		" getCreditBalance(EI.CustomerID,'1090') as Balance8, "+
		" getCreditBalance(EI.CustomerID,'2010') as Balance9, "+
		" getCreditBalance(EI.CustomerID,'2020') as Balance10, "+
		" (getCreditBalance(EI.CustomerID,'2030')+getCreditBalance(EI.CustomerID,'2040')) as Balance11, "+
		" getCreditBalance(EI.CustomerID,'2070') as Balance14, "+
		" getCreditBalance(EI.CustomerID,'2080') as Balance15, "+
		" getCreditBalance(EI.CustomerID,'1130') as Balance16, "+
		" getUserName(InputUserID) as InputUserName, "+
		" getOrgName(InputOrgID) as InputOrgName,"+
		" getUserName(EI.UpdateUserID) as UpdateUserName,"+
		" getOrgName(EI.UpdateOrgID) as UpdateOrgName "+
		" from ENT_INFO EI left join Als_UpdateEntIndustry AU on EI.CustomerID=AU.CustomerID left join Als_UpdateEntScope AUS on EI.CustomerID=AUS.CustomerID " +
		" where  EI.CustomerID in (select CustomerID from CUSTOMER_BELONG "+
		" where OrgID in (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"')) "+
		" and OrgNature < '0201' ";
	}else{
		sSql =	" select getOrgName(getLastOrgID(EI.CustomerID)) as OrgName, "+
		" EI.CustomerID,EnterpriseName,CorpID,LicenseNo, "+
		" Licensedate,LicenseMaturity, "+
		" OrgType,getItemName('OrgType',OrgType) as OrgTypeName, "+
		" OldIndustryType,getItemName('OldIndustryType',substr(OldIndustryType,1,1))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,3))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,4))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,5)) as OldIndustryTypeName,"+
		" EI.IndustryType,getItemName('IndustryType',substr(EI.IndustryType,1,1))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,3))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,4))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,5)) as IndustryTypeName, "+
		" IndustryType2,getItemName('BankIndustryType',IndustryType2) as IndustryType2Name, "+
		" getItemName('CustomerType2',Flag3) as Flag3Name, "+
		" MostBusiness,EmployeeNumber,"+
		"getItemName('Scope',AUS.OldEntScope) as OldScopeName,"+
		"getItemName('Scope',Scope) as ScopeName, "+
		" getItemName('EnterpriseBelong',EnterpriseBelong) as EnterpriseBelongName, "+
		" getItemName('YesNo',ListingCorpOrNot) as ListingCorpOrNotName, "+
		" RegisterCapital, "+
		" RegisterAdd,getItemName('CountryCode',CountryCode) as CountryCodeName, "+
		" getItemName('AreaCode',RegionCode) as RegionCodeName,OfficeAdd, "+
		" getItemName('Currency',PCCurrency) as PCCurrencyName,"+
		" PaiclUpCapital,CreditLevel, "+
		" getCreditBalance(EI.CustomerID,'1') as InBalance, "+
		" getCreditBalance(EI.CustomerID,'2') as OutBalance, "+
		" getOutChangkouBalance(EI.CustomerID) as OutChangkouBalance, "+
		" getSumByType(EI.CustomerID,'10') as OverdueBalance ,"+
		" getSumByType(EI.CustomerID,'20') as InterestBalance1 ,"+
		" getSumByType(EI.CustomerID,'30') as InterestBalance2 ,"+
		" PreBalance,PreCKBalance,"+
		" getCreditBalance(EI.CustomerID,'1010') as Balance1, "+
		" getCreditBalance(EI.CustomerID,'1030') as Balance3, "+
		" getCreditBalance(EI.CustomerID,'1040') as Balance4, "+
		" getCreditBalance(EI.CustomerID,'1050') as Balance5, "+
		" getCreditBalance(EI.CustomerID,'1060') as Balance6, "+
		" getCreditBalance(EI.CustomerID,'1090') as Balance8, "+
		" getCreditBalance(EI.CustomerID,'2010') as Balance9, "+
		" getCreditBalance(EI.CustomerID,'2020') as Balance10, "+
		" (getCreditBalance(EI.CustomerID,'2030')+getCreditBalance(EI.CustomerID,'2040')) as Balance11, "+
		" getCreditBalance(EI.CustomerID,'2070') as Balance14, "+
		" getCreditBalance(EI.CustomerID,'2080') as Balance15, "+
		" getCreditBalance(EI.CustomerID,'1130') as Balance16, "+
		" getUserName(InputUserID) as InputUserName, "+
		" getOrgName(InputOrgID) as InputOrgName, "+
		" getUserName(EI.UpdateUserID) as UpdateUserName,"+
		" getOrgName(EI.UpdateOrgID) as UpdateOrgName "+
		" from ENT_INFO EI left join Als_UpdateEntIndustry AU on EI.CustomerID=AU.CustomerID left join Als_UpdateEntScope AUS on EI.CustomerID=AUS.CustomerID" +
		" where EI.CustomerID in (select CustomerID from CUSTOMER_BELONG "+
		" where OrgID in (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"')) "+
		" and OrgNature < '0201' ";
	}
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);   
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	doTemp.setKey("CustomerID",true);	 

	//设置字段类型
    doTemp.setType("RegisterCapital,PaiclUpCapital,Balance1,Balance2,Balance3,Balance4,Balance5,Balance6,Balance7,Balance8,"+
    		"Balance9,PreBalance,PreCKBalance,InBalance,OutBalance,OutChangkouBalance,OverdueBalance,InterestBalance1,InterestBalance2,Balance10,"+
    		"Balance11,Balance12,Balance13,Balance14,Balance15,Balance16,ReportBalance1,ReportBalance2,ReportBalance3","Number");
	
    doTemp.setAlign("RegisterCapital,PaiclUpCapital,Balance1,Balance2,Balance3,Balance4,Balance5,Balance6,Balance7,Balance8,"+
    		"Balance9,PreBalance,PreCKBalance,InBalance,OutBalance,OutChangkouBalance,OverdueBalance,InterestBalance1,InterestBalance2,Balance10,"+
    		"Balance11,Balance12,Balance13,Balance14,Balance15,Balance16,ReportBalance1,ReportBalance2,ReportBalance3","3");
	
    doTemp.setCheckFormat("RegisterCapital,PaiclUpCapital,Balance1,Balance2,Balance3,Balance4,Balance5,Balance6,Balance7,Balance8,"+
    		"Balance9,PreBalance,PreCKBalance,InBalance,OutBalance,OutChangkouBalance,OverdueBalance,InterestBalance1,InterestBalance2,Balance10,"+
    		"Balance11,Balance12,Balance13,Balance14,Balance15,Balance16,ReportBalance1,ReportBalance2,ReportBalance3","2");
	
    //设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("EnterpriseName","style={width:250px} ");  
	doTemp.setHTMLStyle("IndustryTypeName","style={width:350px} ");  
    
    doTemp.setVisible("OrgType,IndustryType,OldIndustryType,IndustryType2",false);
    doTemp.setDDDWCode("OrgType","OrgType");
	doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
    
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerID","");
	doTemp.setFilter(Sqlca,"2","CorpID","");
	doTemp.setFilter(Sqlca,"3","EnterpriseName","");
	doTemp.setFilter(Sqlca,"4","OrgType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","IndustryType","Operators=BeginsWith;");
	doTemp.setFilter(Sqlca,"6","RegisterCapital","");
	doTemp.setFilter(Sqlca,"7","RegisterAdd","");
	doTemp.setFilter(Sqlca,"8","OfficeAdd","");
	doTemp.setFilter(Sqlca,"9","LicenseNo","");
	doTemp.setFilter(Sqlca,"10","MostBusiness","");
	if(CurUser.hasRole("098")){
		doTemp.setFilter(Sqlca,"11","RealtyFlag","");
		doTemp.setFilter(Sqlca,"12","EconomyTypeName","");
	}
	doTemp.setAlign("EmployeeNumber","3");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(21);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
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
			{CurUser.hasRole("098")?"true":"false","","Button","客户重点链接","客户重点链接","addIndustryType1()",sResourcesPath},
			{"true","","Button","加入重点客户连接","加入重点客户连接","addUserDefine()",sResourcesPath}
		};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");
		}

	}	
    
   	/*~[added by wwhe 2010-05-11 Describe=客户重点链接;InputParam=无;OutPutParam=SerialNo;]~*/
    function addIndustryType1()
    {
    	//获得客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		PopComp("ChangeCustomer","/InfoManage/QuickSearch/ChangeCustomer.jsp","CustomerID="+sCustomerID,"resizable=yes;dialogWidth=25;dialogHeight=20;center:yes;status:no;statusbar:no");
		reloadSelf();
    }
	/*~[Describe=加入重点信息链接;InputParam=CustomerID,ObjectType=Customer;OutPutParam=无;]~*/
	function addUserDefine()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getBusinessMessage('114'))) //把这个客户信息加入重点客户链接中吗?
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=Customer&ObjectNo="+sCustomerID,"","");
		}
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
	
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
