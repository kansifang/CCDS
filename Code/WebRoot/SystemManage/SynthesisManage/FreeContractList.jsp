<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: bqliu 2011-05-31
		Tester:
		Describe:
		Input Param:
			ContractType：
									
		Output Param:
			
		HistoryLog:
				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷后合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%

	//定义变量
	String sSql = "";
	//获得页面参数
	//获得组件参数
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","合同流水号"},
							{"CustomerName","客户名称"},							
							{"BusinessTypeName","业务品种"},
							{"CreditAggreement","额度协议编号"},						
							{"OccurTypeName","发生类型"},													
							{"Currency","币种"},
							{"BusinessSum","合同金额"},
							{"Balance","余额"},
							{"NormalBalance","正常余额"},
							{"OverdueBalance","逾期余额"},
							{"DullBalance","呆滞余额"},
							{"BadBalance","呆帐余额"},
							{"BailAccount","保证金账号"},
							{"BailSum","保证金(元)"},
							{"ClearSum","敞口金额(元)"},
							{"FineBalance1","逾期罚息余额"},
							{"FineBalance2","复息余额"},							
							{"BusinessRate","利率(‰)"},
							{"InterestBalance1","表内欠息余额"},
							{"InterestBalance2","表外欠息余额"},
							{"PdgRatio","费率(‰)"},
							{"PutOutDate","起始日期"},
							{"Maturity","到期日期"},
							{"VouchTypeName","担保方式"},							
							{"ClassifyResult","风险分类"},
							{"UserName","客户经理"},
							{"OperateOrgName","经办机构"},
							{"VouchType","主要担保方式"}
						  };
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
    if(sDBName.startsWith("INFORMIX"))
    {
	    sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" CreditAggreement,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,OverdueBalance,DullBalance,BadBalance,BailAccount,nvl(BailSum,0) as BailSum,"+
					" case when (Balance-nvl(BailSum,0))<0 then 0 else (Balance-nvl(BailSum,0)) end as ClearSum,"+
					" OverdueBalance,nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
					" FineBalance1,FineBalance2,BusinessRate,InterestBalance1,InterestBalance2,PdgRatio,PutOutDate,Maturity,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}else if(sDBName.startsWith("ORACLE"))
	{
		sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" CreditAggreement,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,BailAccount,nvl(BailSum,0) as BailSum,"+
					" case when (Balance-nvl(BailSum,0))<0 then 0 else (Balance-nvl(BailSum,0)) end as ClearSum,"+
					" nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
					" FineBalance1,FineBalance2,BusinessRate,PdgRatio,PutOutDate,Maturity,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}if(sDBName.startsWith("DB2"))
    {
	    sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" CreditAggreement,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,BailAccount,nvl(BailSum,0) as BailSum,"+
					" case when (Balance-nvl(BailSum,0))<0 then 0 else (Balance-nvl(BailSum,0)) end as ClearSum,"+
					" nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
					" FineBalance1,FineBalance2,BusinessRate,PdgRatio,PutOutDate,Maturity,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	
    sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	
	sSql += " and (BusinessType like '2040%' or BusinessType like '2050%' or BusinessType in('2010','2030','2070','2110040','')) "+
		    " and (FinishDate <> '' or FinishDate is not null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
		
		
	//具有支行客户经理、分行客户经理、总行客户经理的用户只能查看自己管户的合同
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
	{
	    sSql += " and ManageUserID = '"+CurUser.UserID+"'";
	}
	sSql += " order by CustomerName";
	//out.println(sSql);
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	
	//设置不可见项
	doTemp.setVisible("BusinessType,BailAccount,BailSum,ClearSum,OccurType,CreditAggreement,PdgRatio,BusinessCurrency,VouchType,OperateOrgID,OrgName",false);	
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BadBalance,DullBalance,NormalBalance,BusinessSum,Balance,BailSum,OverdueBalance,FineBalance1,FineBalance2,BusinessRate,ClearSum,PdgRatio","3");
	doTemp.setType("BadBalance,DullBalance,NormalBalance,InterestBalance1,InterestBalance2,BusinessSum,Balance,BailSum,OverdueBalance,FineBalance1,FineBalance2,BusinessRate,ClearSum,PdgRatio","Number");
	doTemp.setCheckFormat("BadBalance,DullBalance,NormalBalance,BusinessSum,Balance,BailSum,OverdueBalance,FineBalance1,FineBalance2,PdgRatio,ClearSum","2");
	doTemp.setCheckFormat("BusinessRate","16");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName,PdgRatio"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from code_library where codeno = 'VouchType' and ItemNo in ('005','010','020','040')");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency","2");
	//doTemp.setColumnAttribute("CustomerName,BusinessTypeName,SerialNo,Maturity,VouchType","IsFilter","1");
	
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","BusinessTypeName","");	
	doTemp.setFilter(Sqlca,"3","SerialNo","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","Maturity","");
	doTemp.setFilter(Sqlca,"6","VouchType","Operators=BeginsWith");	
	doTemp.parseFilterData(request,iPostChange);
	
	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10); 	//服务器分页

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//组织进行合计用参数 add by zrli 
	String[][] sListSumHeaders = {	{"BusinessCurrency","币种"},
									{"BusinessSum","合同金额"},
									{"Balance","余额"},
									{"BailSum","保证金(元)"},
									{"InterestBalance1","表内欠息"},
									{"InterestBalance2","表外欠息"},
								 };
	String sListSumSql = "Select BusinessCurrency,Sum(BusinessSum) as BusinessSum,Sum(Balance) as Balance,Sum(BailSum) as BailSum,"
						+ " Sum(InterestBalance1) as InterestBalance1, Sum(InterestBalance2) as InterestBalance2 "
						+ " From BUSINESS_CONTRACT "
						+ doTemp.WhereClause
						+ " Group By BusinessCurrency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
	
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
			{"true","","Button","取消手工终结","取消手工终结","ClearFinishDate()",sResourcesPath},
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=手工终结合同;InputParam=无;OutPutParam=无;]~*/
	function ClearFinishDate()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBusinessType   = getItemValue(0,getRow(),"BusinessType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(sBusinessType.substring(0,4)=='2050' || sBusinessType == '2010' || 
		sBusinessType.substring(0,4)=='2030' || sBusinessType.substring(0,4)=='2040')
		{
			if(confirm("您确定取消终结吗?"))//您真的想删除该信息吗？
			{
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@FinishDate@None,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				reloadSelf();
			}
		}else{
			alert("该业务不能手工取消终结！");
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
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