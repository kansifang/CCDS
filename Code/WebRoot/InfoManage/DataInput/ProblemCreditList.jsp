<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: 信贷数据补登列表;
		Input Param:
					DataInputType：010需补登信贷业务
									020补登完成信贷业务
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信贷数据补登列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";
	
	String sClauseWhere="";
	//获得页面参数
	
	//获得组件参数
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag1"));
	if(sReinforceFlag==null) sReinforceFlag="";
	if(sFlag==null) sFlag="";
	
	String sHeaders[][] = {
					{"SerialNo","合同流水号"},
					{"CustomerName","客户名称"},
					{"CustomerID","客户编号"},
					{"MFCustomerID","核心客户号"},
					{"CertTypeName","证件类型"},
					{"CertID","证件号码"},
					{"LoanCardNo","贷款卡号"},
					{"CreditLevelName","客户评级结果"},
					{"BusinessTypeName","业务品种"},					
					{"OccurTypeName","发生类型"},
					{"BDSerialNo","贷款账号"},
					{"ClassifyResultName","当前风险分类结果"},
					{"FinishType","终结方式"},
					{"FinishTypeName","终结方式"},									
					{"Currency","币种"},
					{"BusinessSum","合同金额(元)"},
					{"Balance","余额(元)"},
					{"NormalBalance","正常余额(元)"},
					{"OverdueBalance","逾期余额(元)"},
					{"DullBalance","呆滞余额(元)"},
					{"BadBalance","呆帐余额(元)"},
					{"Interestbalance1","表内欠息(元)"},
					{"Interestbalance2","表外欠息(元)"},
					{"VouchTypeName","主要担保方式"},
					{"PutOutDate","起始日期"},
					{"Maturity","到期日期"},
					{"ManageOrgIDName","管户机构"},
					{"ManageUserIDName","管户人"}					
				  };

	 sSql = " select BC.SerialNo,BC.SerialNo as BDSerialNo,CI.MFCustomerID as MFCustomerID,"+
	 		" BC.CustomerName as CustomerName,"+
			" BC.CustomerID as CustomerID,"+
			" getItemName('CertType',CI.CertType) as CertTypeName,CI.CertID as CertID,"+
			" CI.LoanCardNo as LoanCardNo,"+
			" getItemName('CreditLevel',getCreditLevel(BC.CustomerID)) as CreditLevelName,"+
			" BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
			" BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
			" BC.FinishType,getItemName('FinishType',BC.FinishType) as FinishTypeName,"+
			" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as Currency,"+
			" BC.BusinessSum,BC.Balance,"+
			" BC.NormalBalance,BC.OverdueBalance,BC.DullBalance,BC.BadBalance,"+
			" BC.Interestbalance1,BC.Interestbalance2,"+
			" BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
			" BC.PutOutDate,BC.Maturity,"+
			" getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
			" getUserName(BC.ManageUserID) as ManageUserIDName,"+
			" getOrgName(BC.ManageOrgID) as ManageOrgIDName "+
			" from BUSINESS_CONTRACT BC left join CUSTOMER_INFO CI ON CI.CUSTOMERID=BC.CUSTOMERID "+
			" where  "+
			" (BC.BusinessType like '1%' "+
			" or BC.BusinessType like '2%' "+
			" or BC.BusinessType like '5%' "+
			" or BC.BusinessType is null "+
			" or BC.BusinessType ='')"+
			" and (BC.FinishDate='' "+
			" or BC.FinishDate is null) "+
			" and (BC.FinishType not like '060%' "+
			" or BC.FinishType is null)" + 
			" and LoanFlag = '1'"+
			" and BC.ManageOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')" ;
	 //如果是直属支行管理员,直属支行问题授信管理员
	if(CurUser.hasRole("0M2")||CurUser.hasRole("0M4"))
	{
		sSql += " AND BC.ManageOrgID in(select OrgID from ORG_INFO where OrgLevel='3' and OrgFlag='030') ";
	}
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//out.println("<font color='red' size = 2>"+
	//			"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;√如果额度项下业务先[额度补登管理]，否则先[补登业务]再[补登完成]，如果提示客户有问题并且信贷系统中确认此客户已[保存]成功，那么请在核心系统先做客户合并处理！√如果贷款所对应额度已经过期，那么贷款就可以按照“单笔授信业务”进行补登，并无需再补录其额度信息。"+
	//			"</font>");
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("BC.SerialNo");		//add by hxd in 2005/02/20 for 加快速度
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";	
	doTemp.setKey("BC.SerialNo",true);	 //设置关键字
	
	//设置不可见项
	doTemp.setVisible("CustomerType,OccurType,BusinessCurrency,VouchType",false);
	doTemp.setVisible("BusinessType,FinishType,FinishTypeName,Currency",false);
	
	doTemp.setAlign("NormalBalance,OverdueBalance,DullBalance,BadBalance,BusinessSum,Balance,Interestbalance1,Interestbalance2","3");
	doTemp.setType("Interestbalance1,Interestbalance2","Number");
	doTemp.setCheckFormat("NormalBalance,OverdueBalance,DullBalance,BadBalance,BusinessSum,Balance","2");
	
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerTypeName,CertID,ManageUserIDName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("SerialNo,CustomerID"," style={width:160px} ");
	doTemp.setHTMLStyle("VouchTypeName"," style={width:170px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:100px} ");
		
	//生成查询框
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","SerialNo","");	
	doTemp.setFilter(Sqlca,"3","MFCustomerID","");
	doTemp.setFilter(Sqlca,"4","Interestbalance1","");
	doTemp.setFilter(Sqlca,"5","Interestbalance2","");
	doTemp.parseFilterData(request,iPostChange);	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10); 	//服务器分页

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
				{"true","","Button","业务详情","业务详情","BusinessInfo()",sResourcesPath}};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function BusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
				alert("本笔业务没有业务品种，不能查看合同详情!");
			}
			else{
				openObject("AfterLoan",sSerialNo,"001");
			}	
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
