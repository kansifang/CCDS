<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/26
		Tester:
		Describe: 不良资产认定合同列表;
					BadAssetLCFlag 不良资产认定状态
					'010' 已认定,未审批
					'020' 已认定,已审批
		Input Param:
			ContractType：
			010010未完成认定
			010020已完成认定
			010030已完成审批认定
			020010未完成审批认定
			020020已完成审批认定
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产认定合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
							{"OccurTypeName","发生类型"},	
							{"VouchTypeName","主要担保方式"},	
							{"Currency","币种"},
							{"BusinessSum","合同金额"},
							{"Balance","合同余额"},
							{"ClassifyResult","五级分类结果"},
							{"ClassifyResultName","五级分类结果"},
							{"PutOutDate","合同起始日"},
							{"Maturity","合同到期日"},	
							{"ManageUserName","管户人"},
							{"ManageOrgName","管户机构"},
							{"OperateUserName","经办人"},
							{"OperateOrgName","经办机构"},
						  };
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
    if(sDBName.startsWith("INFORMIX"))
    {
	    sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,"+
					" ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,"+
					" PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,"+
					" getUserName(OperateUserID) as OperateUserName,"+
					" getOrgName(ManageOrgID) as ManageOrgName,"+
					" getUserName(ManageUserID) as ManageUserName "+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}else if(sDBName.startsWith("ORACLE"))
	{
		sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,"+
					" ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,"+
					" PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,"+
					" getUserName(OperateUserID) as OperateUserName,"+
					" getOrgName(ManageOrgID) as ManageOrgName,"+
					" getUserName(ManageUserID) as ManageUserName "+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}if(sDBName.startsWith("DB2"))
    {
	    sSql =      " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,"+
					" ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,"+
					" PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,"+
					" getUserName(OperateUserID) as OperateUserName,"+
					" getOrgName(ManageOrgID) as ManageOrgName,"+
					" getUserName(ManageUserID) as ManageUserName "+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	//010010未完成认定
	//010020已完成认定
	//010030已完成审批认定
	//020010未完成审批认定
	//020020已完成审批认定
	if(sContractType.equals("010010"))
	{
		sSql += " and substr(ClassifyResult,1,2)>'02'  and (FinishDate = '' or FinishDate is null) and (BadAssetLCFlag = '' or BadAssetLCFlag is null)";
	}else if(sContractType.equals("010020")||sContractType.equals("020010"))
	{
		sSql += " and substr(ClassifyResult,1,2)>'02'  and (FinishDate = '' or FinishDate is null) and BadAssetLCFlag = '010'";
	}else if(sContractType.equals("010030")||sContractType.equals("020020"))
	{
		sSql += " and substr(ClassifyResult,1,2)>'02'  and (FinishDate = '' or FinishDate is null) and BadAssetLCFlag = '020'";
	}
		
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
	doTemp.setVisible("OperateOrgName,OperateUserName,VouchTypeName,BusinessType,OccurType,ClassifyResult,BusinessCurrency,VouchType,OperateOrgID,OrgName",false);	
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	
	//设置来源
	doTemp.setDDDWSql("ClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)=2");
	
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency","2");
	doTemp.setColumnAttribute("OperateOrgName,SerialNo,CustomerName,ClassifyResult","IsFilter","1");
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
			{"true","","Button","责任认定","责任认定","duty_Cogn()",sResourcesPath},
			{"true","","Button","责任认定详情","责任认定详情","dutyCogn_Info()",sResourcesPath},
			{"true","","Button","认定完成","认定完成","cogn_Complete()",sResourcesPath},
			{"true","","Button","审批完成","审批完成","approve_Complete()",sResourcesPath},
			{"true","","Button","风险分类详情","风险分类详情","classify_Info()",sResourcesPath},
			{"true","","Button","责任认定表","责任认定表","dutyCogn_Report()",sResourcesPath},
		};
		
	
	if(sContractType.equals("010010"))
	{
		sButtons[getBtnIdxByName(sButtons,"责任认定详情")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"审批完成")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"责任认定表")][0]="false";
	}else if(sContractType.equals("010020"))
	{
		sButtons[getBtnIdxByName(sButtons,"责任认定")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"认定完成")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"责任认定表")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"审批完成")][0]="false";
	}else if(sContractType.equals("010030")||sContractType.equals("020020"))
	{
		sButtons[getBtnIdxByName(sButtons,"责任认定")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"认定完成")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"审批完成")][0]="false";
	}else if(sContractType.equals("020010"))
	{
		sButtons[getBtnIdxByName(sButtons,"责任认定")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"认定完成")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"责任认定表")][0]="false";
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

	/*~[Describe=责任认定;InputParam=无;OutPutParam=无;]~*/
	function duty_Cogn()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			sCompID = "NPAssetDutyList";
			sCompURL = "/CreditManage/CreditPutOut/NPADutyList.jsp";
			sParamString = "EditRight=1&ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}

	/*~[Describe=责任认定详情;InputParam=无;OutPutParam=无;]~*/
	function dutyCogn_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			sCompID = "NPAssetDutyList";
			sCompURL = "/CreditManage/CreditPutOut/NPADutyList.jsp";
			sParamString = "EditRight=2&ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=认定完成;InputParam=无;OutPutParam=无;]~*/
	function cogn_Complete()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('40')))//提交后将不能进行修改操作，确定提交吗？
		{	
			//认定完成操作
			sBadAssetLCFlag = "010";
			var sReturn = RunMethod("BusinessManage","UpdateBadAssetCogniz",sBadAssetLCFlag+","+sSerialNo+",<%=CurUser.UserID%>,<%=CurOrg.OrgID%>");
			if(sReturn == "Success" ) {				
				reloadSelf();	
				alert(getHtmlMessage('71'));	//操作成功！		
			}else
			{
				alert(getHtmlMessage('72'));//操作失败！
				return;	
			}	
		}
	}	
	/*~[Describe=审批完成;InputParam=无;OutPutParam=无;]~*/
	function approve_Complete()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('40')))//提交后将不能进行修改操作，确定提交吗？
		{	
			//认定完成操作
			sBadAssetLCFlag = "020";
			var sReturn = RunMethod("BusinessManage","UpdateBadAssetCogniz",sBadAssetLCFlag+","+sSerialNo+",<%=CurUser.UserID%>,<%=CurOrg.OrgID%>");
			if(sReturn == "Success" ) {				
				reloadSelf();	
				alert(getHtmlMessage('71'));	//操作成功！		
			}else
			{
				alert(getHtmlMessage('72'));//操作失败！
				return;	
			}	
		}
	}	
	
	/*~[Describe=风险分类详情;InputParam=无;OutPutParam=无;]~*/
	function classify_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			sCompID = "ClassifyHistoryList";
			sCompURL = "/CreditManage/CreditPutOut/ClassifyHistoryList.jsp";
			sParamString = "ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=责任认定表;InputParam=无;OutPutParam=无;]~*/
	function dutyCogn_Report()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/FormatDoc/PutOut/5005.jsp?ObjectNo="+sSerialNo,"",""); 
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