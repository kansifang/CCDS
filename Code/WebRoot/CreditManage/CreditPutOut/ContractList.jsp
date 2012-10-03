<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: 授信台账列表信息;
		Input Param:
			ContractType：
				010010表内未终结业务
				010020表外未终结业务
				020010表内终结业务
				020020表外终结业务	
				030010010表内未终结业务(已移交保全)
				030010020表外未终结业务(已移交保全)
				030020010表内终结业务(已移交保全)
				030020020表外终结业务(已移交保全)						
		Output Param:
			
		HistoryLog:
					2005.7.28 hxli  sql重写，界面改写
					2005.08.09 王业罡 修改担保管理按钮
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
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));
		  
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
							{"ClassifyResult","当前风险分类结果（账面）"},
							{"BaseClassifyResult","当前风险分类结果（实际）"},
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
					" getItemName('ClassifyResult',BaseClassifyResult) as BaseClassifyResult,"+
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
					" getItemName('ClassifyResult',BaseClassifyResult) as BaseClassifyResult,"+
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
					" getItemName('ClassifyResult',BaseClassifyResult) as BaseClassifyResult,"+
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	//	010010表内未终结业务
	//	010020表外未终结业务
	//	020010表内终结业务
	//	020020表外终结业务
	//  030010010表内未终结业务(已移交保全)
	//  030010020表外未终结业务(已移交保全)
	//  030020010表内终结业务(已移交保全)
	//  030020020表外终结业务(已移交保全)

    sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sContractType.equals("010010") || sContractType.equals("030010010"))
	{
		if(sDBName.startsWith("INFORMIX"))
		{
			if(sContractType.equals("010010"))
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}else if(sDBName.startsWith("ORACLE"))
		{
			if(sContractType.equals("010010"))
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID = ' ' or RecoveryOrgID is null)";
			else
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = ' ' or FinishDate is null) and RecoveryOrgID is not null";
		}else if(sDBName.startsWith("DB2"))
		{
			if(sContractType.equals("010010"))
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and Balance >= 0 and BusinessType like '1%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}
	}
	else if(sContractType.equals("010020") || sContractType.equals("030010020"))
	{
		if(sDBName.startsWith("INFORMIX"))
		{
			if(sContractType.equals("010020"))
				sSql += " and Balance >= 0 and BusinessType like '2%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and Balance >= 0 and BusinessType like '2%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}else if(sDBName.startsWith("ORACLE"))
		{
			if(sContractType.equals("010020"))
				sSql += " and Balance >= 0 and BusinessType like '2%' and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID = ' ' or RecoveryOrgID is null)";
			else
				sSql += " and Balance >= 0 and BusinessType like '2%' and (FinishDate = ' ' or FinishDate is null) and RecoveryOrgID is not null";
		}else if(sDBName.startsWith("DB2"))
		{
			if(sContractType.equals("010020"))
				sSql += " and BusinessType like '2%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and BusinessType like '2%' and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}
	}	
	else if(sContractType.equals("020010") || sContractType.equals("030020010"))
	{
		if(sDBName.startsWith("INFORMIX"))
		{
			if(sContractType.equals("020010"))
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '1%' and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '1%' and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}else if(sDBName.startsWith("ORACLE"))
		{
			if(sContractType.equals("020010"))
				sSql += " and (FinishDate <> ' ' and FinishDate is not null) and BusinessType like '1%' and (RecoveryOrgID = ' ' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> ' ' and FinishDate is not null) and BusinessType like '1%' and RecoveryOrgID is not null";
		}else if(sDBName.startsWith("DB2"))
		{
			if(sContractType.equals("020010"))
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '1%' and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '1%' and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}	
		
	}
	else if(sContractType.equals("020020") || sContractType.equals("030020020"))
	{
		if(sDBName.startsWith("INFORMIX"))
		{
			if(sContractType.equals("020020"))
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '2%' and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '2%' and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}else if(sDBName.startsWith("ORACLE"))
		{
			if(sContractType.equals("020020"))
				sSql += " and (FinishDate <> ' ' and FinishDate is not null) and BusinessType like '2%' and (RecoveryOrgID = ' ' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> ' ' and FinishDate is not null) and BusinessType like '2%' and RecoveryOrgID is not null";
		}else if(sDBName.startsWith("DB2"))
		{
			if(sContractType.equals("020020"))
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '2%' and (RecoveryOrgID = '' or RecoveryOrgID is null)";
			else
				sSql += " and (FinishDate <> '' and FinishDate is not null) and BusinessType like '2%' and (RecoveryOrgID <> '' and RecoveryOrgID is not null)";
		}
	}else if(sContractType.equals("040010"))//表内需补登业务
	{
		if(sDBName.startsWith("DB2"))
		{
				sSql += " and (BusinessType like '1020%' or BusinessType in('1080010','1080035','2050010','1080070','1080020','1080040','1080055','1080045','1080050','1080060','1080030') "+
						" or (BusinessType='1110010' and SerialNo like 'BC%')) "+
				" and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
		}
	}
	else if(sContractType.equals("040020"))//表外需补登业务
	{
		if(sDBName.startsWith("DB2"))
		{
			sSql += " and (BusinessType like '2040%' or BusinessType like '2050%' or BusinessType in('2010','2030','2070','2110040')) "+
			" and (FinishDate = '' or FinishDate is null) and (RecoveryOrgID = '' or RecoveryOrgID is null)";
		}
	}	
		
	//具有支行客户经理、分行客户经理、总行客户经理的用户只能查看自己管户的合同
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")|| CurUser.hasRole("2A5") || CurUser.hasRole("2D3"))
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
	if(sContractType.equals("010010") || sContractType.equals("020010"))
	{
		doTemp.setVisible("BailAccount,BailSum,ClearSum,PdgRatio",false);	
	}
	if(sContractType.equals("010020") || sContractType.equals("020020"))
	{
		doTemp.setVisible("OverdueBalance,OccurTypeName,BusinessRate",false);	
	}
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
	doTemp.setFilter(Sqlca,"7","ClassifyResult","");
	doTemp.setFilter(Sqlca,"8","BaseClassifyResult","");
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
			{"true","","Button","合同详情","合同详情","viewTab()",sResourcesPath},
			{"false","","Button","担保合同信息","担保合同管理","AssureManage()",sResourcesPath},
			{"true","","Button","工作笔记","贷后工作笔记","WorkRecord()",sResourcesPath},
			{"true","","Button","加入重点连接","加入重点连接","AddUserDefine()",sResourcesPath},
			{"true","","Button","催收函管理","催收函管理","my_DunManage()",sResourcesPath},
			{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
			{"true","","Button","汇总","金额汇总","listSum()",sResourcesPath},
			{"false","","Button","合同补登","合同补登","BusinessMendInfo()",sResourcesPath},
			{"false","","Button","借据补登","借据补登","MendDueBillInfo()",sResourcesPath},
			{"false","","Button","业务信息补登","业务信息补登","MendDueBillInfo()",sResourcesPath},
			{"false","","Button","检查实时余额","检查实时余额","CheckBalance()",sResourcesPath},
			{"false","","Button","手工终结","手工终结","FinishDate()",sResourcesPath},
			{"false","","Button","票据信息补登","票据信息补登","MendBillInfo()",sResourcesPath},
		};
		
	if(sContractType.equals("010010")||sContractType.equals("010020"))//未终结表外业务
	{
		//sButtons[getBtnIdxByName(sButtons,"信息补登")][0]="true";
		//sButtons[getBtnIdxByName(sButtons,"手工终结")][0]="true";
	}
	
	if(sContractType.equals("020010") ||sContractType.equals("020020"))//已终结业务
	{
		sButtons[getBtnIdxByName(sButtons,"担保合同信息")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"移交保全")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"加入重点连接")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"催收函管理")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"工作笔记")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"合同终结")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"还款方式补登")][0]="false";
	}
	
	if(sContractType.indexOf("030") >= 0) //已移交保全
	{		
		sButtons[getBtnIdxByName(sButtons,"担保合同信息")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"移交保全")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"加入重点连接")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"催收函管理")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"工作笔记")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"合同终结")][0]="false";
	//	sButtons[getBtnIdxByName(sButtons,"还款方式补登")][0]="false";		
	}
	 if(sContractType.equals("040010")||sContractType.equals("040020"))
	 {
		sButtons[getBtnIdxByName(sButtons,"业务信息补登")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"检查实时余额")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"手工终结")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"担保合同信息")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"加入重点连接")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"催收函管理")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"工作笔记")][0]="false";
	 }
	 if(sContractType.equals("040010"))//表内需补登业务
	 {
	 	//sButtons[getBtnIdxByName(sButtons,"票据信息补登")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"借据补登")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"检查实时余额")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"业务信息补登")][0]="false";
	 }
	  if(CurUser.hasRole("299"))
	 {
		 sButtons[getBtnIdxByName(sButtons,"手工终结")][0]="false";
	 }
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "AfterLoan";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sApproveType = getItemValue(0,getRow(),"ApproveType");
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApproveType="+sApproveType;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}

	/*~[Describe=担保合同管理;InputParam=无;OutPutParam=无;]~*/
	function AssureManage()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("AssureView","/CreditManage/CreditPutOut/AssureView.jsp","ComponentName=担保合同管理&ObjectType=AfterLoan&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}

	/*~[Describe=贷后工作笔记;InputParam=无;OutPutParam=无;]~*/
	function WorkRecord()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","ComponentName=贷后工作笔记&NoteType=BusinessContract&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=加入重点合同连接;InputParam=无;OutPutParam=无;]~*/
	function AddUserDefine()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getBusinessMessage('420'))) //要把这个合同信息加入重点合同链接中吗？
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
		}
	}
	
	/*~[Describe=催收函管理;InputParam=无;OutPutParam=无;]~*/
	function my_DunManage()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("DunList","/RecoveryManage/DunManage/DunList.jsp","ObjectType=BusinessContract&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=表外补登信息;InputParam=无;OutPutParam=无;]~*/
	function BusinessMendInfo()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBusinessType   = getItemValue(0,getRow(),"BusinessType");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(sBusinessType.substring(0,4)=='2050' || (sBusinessType.substring(0,4)=='1080'&&sBusinessType!='1080070'&&sBusinessType!='1080030'&&sBusinessType!='1080035'&&sBusinessType!='1080055') || 
		sBusinessType == '2010' || sBusinessType.substring(0,4)=='1020' || 
		sBusinessType.substring(0,4)=='2030' || sBusinessType.substring(0,4)=='2040')//国际业务、承兑、贴现、保函
		{
			OpenComp("BusinessMendInfo","/CreditManage/CreditPutOut/BusinessMendInfo.jsp","ObjectNo="+sSerialNo,"_blank",OpenStyle);
			reloadSelf();
		}else{
			alert("该业务不需要补登！");
		}
	}
	
	/*~[Describe=借据补登信息;InputParam=无;OutPutParam=无;]~*/
	function MendDueBillInfo()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBusinessType   = getItemValue(0,getRow(),"BusinessType");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			   OpenComp("MendDueBillList","/CreditManage/CreditPutOut/MendDueBillList.jsp","ObjectNo="+sSerialNo,"_blank",OpenStyle);
			   reloadSelf();
		     }
	}
	
	/*~[Describe=检查实时余额;InputParam=无;OutPutParam=无;]~*/
	function CheckBalance()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");//合同流水号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			 alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
             sReturn=RunMethod("BusinessManage","GetSumBalanceValue",sSerialNo);//获得借据总金额和总余额
             sReturn=sReturn.split("@");
             if(typeof(sReturn) == "undefined" || sReturn.length==0 || sReturn=="Null" || sReturn=="" )
          	 {
          		sReturnValue=RunMethod("PublicMethod","UpdateColValue","Number@Balance@null@Number@ActualPutOutSum@null,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
          		alert("未录入业务信息");
          		return;
  		     }else
          	 {	
       		    sReturnValue=RunMethod("PublicMethod","UpdateColValue","Number@Balance@"+parseFloat(sReturn[1])+"@Number@ActualPutOutSum@"+parseFloat(sReturn[0])+",BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
       		    alert("余额等于"+amarMoney(sReturn[1],2));
		     }
             reloadSelf();
		 }
	}
	
	/*~[Describe=手工终结合同;InputParam=无;OutPutParam=无;]~*/
	function FinishDate()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
	 	dInterestBalance1 =getItemValue(0,getRow(),"InterestBalance1");//获取表内欠息
  		dInterestBalance2 =getItemValue(0,getRow(),"InterestBalance2");//获取表外欠息
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
	  	}else
	  	{
	  		sReturn=RunMethod("BusinessManage","GetSumBalanceValue",sSerialNo);//获得借据总金额和总余额
	  	    sReturn=sReturn.split("@");
	  		if(typeof(sReturn) == "undefined" || sReturn.length==0 || sReturn=="Null" || sReturn=="" )
	  		{
	  			sReturnValue=RunMethod("PublicMethod","UpdateColValue","Number@Balance@null@Number@ActualPutOutSum@null,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
	  			alert("该业务不能进行手工终结，未录入业务信息");
	  		    return ;
	  		}else
	  		{	
	  			sReturnValue=RunMethod("PublicMethod","UpdateColValue","Number@Balance@"+parseFloat(sReturn[1])+"@Number@ActualPutOutSum@"+parseFloat(sReturn[0])+",BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
	  		}
	  		dBalance =parseFloat(sReturn[1]);//获取实时合同余额
		 	if((parseFloat(dInterestBalance1)+parseFloat(dInterestBalance2)+parseFloat(dBalance))>0)//合同余额加表内外欠息大于0，就不能手工终结
	  		{
	  			alert("该业务不能进行手工终结！");
	  		 	return;
	  		}else if(confirm("此笔业务是否确认终结？"))
	  		{
	  			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@FinishDate@<%=StringFunction.getToday()%>,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
	  		  	reloadSelf();
	  		}
	  		
	  	}
	
	} 
	
	//票据信息补登
	function MendBillInfo()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBusinessType   = getItemValue(0,getRow(),"BusinessType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if(sBusinessType != "2010")
			{
				alert("银行承兑汇票才能进行票据信息补登");
			}else
			{
			    sReturn = RunMethod("BusinessManage","CheckDueBillList",sSerialNo);
			    if(sReturn > 0) 
			    {
			        OpenComp("MendBillList","/CreditManage/CreditPutOut/MendAcceptBillList.jsp","ObjectNo="+sSerialNo,"_blank",OpenStyle);
			    }else
			    {
			        alert("必须进行借据补登后才能进行票据信息补登");
			    }
			}
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//合同台账信息
	function my_ManageView()
	{ 
		//合同流水号、合同编号、客户名称,币种
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sItemMenuNo = "<%=sContractType%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //请选择一条信息！
		}else
		{
			sObjectType = "NPABook";
			sObjectNo = sSerialNo;
			
			if(sItemMenuNo=="010050") 
				sViewID = "001";
			else
				sViewID = "002";

			openObject(sObjectType,sObjectNo,sViewID);
		}
	}
	
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	/*~[Describe=金额汇总;InputParam=无;OutPutParam=无;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
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