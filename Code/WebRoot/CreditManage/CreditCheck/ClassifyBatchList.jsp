<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2010/02/04
		Tester:
		Describe: 系统批量风险分类结果
		Input Param:			
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
							{"Result1Name","初分结果"}
						  };
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sDBName.startsWith("DB2"))
    {
	    sSql =      " select BC.SerialNo as SerialNo,BC.CustomerName as CustomerName, "+
					" BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+					
					" BC.OccurType as OccurType ,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
					" BC.CreditAggreement as CreditAggreement,"+
					" BC.BusinessCurrency as BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as Currency,"+
					" BC.BusinessSum as BusinessSum,nvl(BC.Balance,0) as Balance,"+
					" getItemName('ClassifyResult',CR.Result1) as Result1Name, "+
					" getOrgName(BC.ManageOrgID) as ManageOrgName,"+
					" getUserName(BC.ManageUserID) as ManageUserName "+
					" from BUSINESS_CONTRACT BC "+
					" LEFT OUTER JOIN CLASSIFY_RECORD CR ON  "+
					" BC.SerialNo=CR.ObjectNo   and CR.ObjectType='BusinessContract' "+
					" and CR.AccountMonth='"+StringFunction.getToday().substring(0,7)+"' "+
					" where (BC.FinishDate is null or BC.FinishDate = '') and BC.ApplyType<>'CreditLineApply' "+
					" and BC.ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}



	//具有支行客户经理、分行客户经理、总行客户经理的用户只能查看自己管户的合同
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
	{
	    sSql += " and BC.ManageUserID = '"+CurUser.UserID+"'";
	}
	sSql += " order by CustomerName";
	//out.println(sSql);
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	//doTemp.setKey("SerialNo",true);
	//doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);

	doTemp.setVisible("OccurTypeName,ManageOrgName,ManageUserName,BusinessType,OccurType,BusinessCurrency",false);	
		
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	//设置html格式
	doTemp.setHTMLStyle("Currency,Result1Name"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency","2");
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,SerialNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
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
			{"true","","Button","合同详情","合同详情","viewTab()",sResourcesPath},
			{"false","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
		};
		
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