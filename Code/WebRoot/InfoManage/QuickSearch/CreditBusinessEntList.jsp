<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  xhyong 2011/09/19	
		Tester:
		Content: 公司类客户授信台账
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "公司类客户授信台账"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "";//--题头
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","借据编号"},
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称"},
							{"CorpID","客户证件号码"},
							{"OccurTypeName","发生类型"},
							{"OccurType","发生类型"},
							{"BusinessTypeName","业务品种"},
							{"BusinessType","业务品种"},
							{"IndustryTypeName","客户所属行业"},
							{"DirectionName","贷款行业投向"},
							{"AgriLoanClassifyName","涉农贷款分类"},
							{"BusinessSum","借据金额"},
							{"Balance","借据余额"},
							{"BusinessRate","执行利率（‰）"},
							{"NormalBalance","正常余额"},
							{"OverDueBalance","逾期余额"},
							{"DullBalance","呆滞余额"},
							{"BadBalance","呆账余额"},
							{"PutOutdate","借据起始日期"},
							{"Maturity","借据终结日期"},
							{"InterestBalance1","表内欠息"},
							{"InterestBalance2","表外欠息"},
							{"ClassifyResult","当前风险分类结果（账面）"},
							{"ClassifyResultName","当前风险分类结果（账面）"},
							{"BaseClassifyResult","当前风险分类结果（实际）"},
							{"BaseClassifyResultName","当前风险分类结果（实际）"},
							{"VouchTypeName","主要担保方式"},
							{"VouchType","主要担保方式"},
							{"ManageUserName","管户人"},
							{"ManageOrgName","管户机构"},
							{"MFOrgName","记账单位"},
							{"OperateOrgName","出账机构"},
							{"ScopeName","企业规模"},
							{"CreditLevel","客户信用等级"}
							}; 					
	sSql =	"select BD.SerialNo,"+
				"BC.CustomerID,BC.CustomerName ,EI.CorpID,EI.CreditLevel,"+
				"getItemName('IndustryType',EI.IndustryType) as IndustryTypeName,"+
				"BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
				"BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
				"getItemName('IndustryType',BC.Direction) as DirectionName,"+
				"getItemName('Scope',EI.Scope) as ScopeName,"+
				"getItemName('AgriLoanClassify1',BC.AgriLoanClassify) as AgriLoanClassifyName,"+
				"BD.BusinessSum,BD.Balance,BC.BusinessRate,"+
				"BD.NormalBalance,BD.OverDueBalance,BD.DullBalance,BD.BadBalance,"+
				"BD.PutOutdate,BD.Maturity,BD.InterestBalance1,BD.InterestBalance2,"+
				"BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				"BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName,"+
				"BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
				"getUserName(BC.ManageUserID) as ManageUserName,"+
				"getOrgName(BC.ManageOrgID) as ManageOrgName,"+
				"getOrgName(BD.MFOrgID) as MFOrgName,"+
				"getOrgName(BD.MFOrgID) as OperateOrgName "+
			" from ENT_INFO EI ,BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC"+
			" where EI.CustomerID=BC.CustomerID and BC.SerialNo=BD.RelativeSerialNo2 "+
			"and (nvl(BD.BALANCE,0)+nvl(BD.INTERESTBALANCE1,0)+nvl(BD.INTERESTBALANCE2,0))>0"+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
		
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("EI.CustomerID");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	//doTemp.setKey("SerialNo",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("ManageOrgName,MFOrgName,OperateOrgName","style={width:250px} ");  
	//设置对齐方式
	doTemp.setAlign("BusinessSum,Balance,BusinessRate,NormalBalance,OverDueBalance,DullBalance,BadBalance,InterestBalance1,InterestBalance2","3");
	doTemp.setVisible("OccurType,VouchType,BaseClassifyResult,ClassifyResult,BusinessType",false);
	//小数为2，整数为5
	doTemp.setCheckFormat("OverDueBalance,DullBalance,BadBalance,InterestBalance1,InterestBalance2","2");
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and Length(ItemNo)>3");
	doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' ");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)>2");	
	
	//生成查询框
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","CorpID","");
	doTemp.setFilter(Sqlca,"4","OccurType","");
	doTemp.setFilter(Sqlca,"5","BusinessType","");
	doTemp.setFilter(Sqlca,"6","DirectionName","");
	doTemp.setFilter(Sqlca,"7","ScopeName","");
	doTemp.setFilter(Sqlca,"8","AgriLoanClassifyName","");
	doTemp.setFilter(Sqlca,"9","BusinessSum","");
	doTemp.setFilter(Sqlca,"10","Balance","");
	doTemp.setFilter(Sqlca,"11","PutOutdate","");
	doTemp.setFilter(Sqlca,"12","Maturity","");
	doTemp.setFilter(Sqlca,"13","ClassifyResult","");
	doTemp.setFilter(Sqlca,"14","BaseClassifyResult","");
	doTemp.setFilter(Sqlca,"15","VouchType","");
	doTemp.setFilter(Sqlca,"16","ManageUserName","");
	doTemp.setFilter(Sqlca,"17","ManageOrgName","");
	doTemp.setFilter(Sqlca,"18","MFOrgName","");
	doTemp.setFilter(Sqlca,"19","OperateOrgName","");
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