<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  bqliu 2011-5-9
		Tester:
		Content: 授信台账快速查询
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
	String PG_TITLE = "授信台账快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
							{"ObjectNo","申请流水号"},
							{"CustomerName","客户名称"},							
							{"BusinessTypeName","业务品种"},
							{"OccurTypeName","发生类型"},													
							{"CurrencyName","币种"},
							{"BusinessSum","申请金额"},
							{"BusinessSum2","审批批准金额"},
							{"PhaseName","审批状态"},
							{"BailRatio","保证金比例%"},
							{"VouchType","主要担保方式"},
							{"FlowName","审批流程"},
							{"OperateUserName","经办人"},
							{"OperateOrgName","经办机构"},
							{"ApproveUserID","最终审批人"},
							{"ApproveOrgID","终审机构"},
							{"ApproveDate","审批时间"}
						  };
    /*
	sSql =	" select FLOW_OBJECT.ObjectType as ObjectType,FLOW_OBJECT.ObjectNo as ObjectNo,"+
			"BUSINESS_APPLY.CustomerID as CustomerID,BUSINESS_APPLY.CustomerName as CustomerName,"+
			"BUSINESS_APPLY.BusinessType as BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			"BUSINESS_APPLY.OccurType as OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
			"getItemName('Currency',BusinessCurrency) as CurrencyName,"+
			"BUSINESS_APPLY.BusinessSum as BusinessSum,GetBusinessSum2(FLOW_OBJECT.ObjectNo) as BusinessSum2,"+
			"FLOW_OBJECT.PhaseName as PhaseName,BUSINESS_APPLY.BailRatio as BailRatio,"+
			"getItemName('VouchType',BUSINESS_APPLY.VouchType) as VouchType,FLOW_OBJECT.FlowName as FlowName,"+
			"FLOW_OBJECT.UserName as OperateUserName,FLOW_OBJECT.OrgName as OperateOrgName,"+
			"getUserName(BUSINESS_APPLY.ApproveUserID) as ApproveUserID,getOrgName(BUSINESS_APPLY.ApproveOrgID) as ApproveOrgID,BUSINESS_APPLY.ApproveDate as ApproveDate "+
			"from FLOW_OBJECT ,BUSINESS_APPLY "+
			"where FLOW_OBJECT.ObjectType =  'CreditApply'  and  FLOW_OBJECT.ObjectNo = BUSINESS_APPLY.SerialNo "+
			"and FLOW_OBJECT.ApplyType in ('IndependentApply','CreditLineApply','DependentApply','LowRiskApply') "+
			"and BUSINESS_APPLY.PigeonholeDate is null "+
			" and BUSINESS_APPLY.InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
    */
	sSql =	" select BUSINESS_CONTRACT.SerialNo as SerialNo,FLOW_OBJECT.ObjectType as ObjectType,FLOW_OBJECT.ObjectNo as ObjectNo,"+
			"BUSINESS_CONTRACT.CustomerID as CustomerID,BUSINESS_CONTRACT.CustomerName as CustomerName,"+
			"getBusinessName(BUSINESS_CONTRACT.BusinessType) as BusinessTypeName,"+
			"getItemName('OccurType',BUSINESS_CONTRACT.OccurType) as OccurTypeName,"+
			"getItemName('Currency',BUSINESS_CONTRACT.BusinessCurrency) as CurrencyName,"+
			"BUSINESS_APPLY.BusinessSum as BusinessSum,BUSINESS_CONTRACT.BusinessSum as BusinessSum2, "+
			"FLOW_OBJECT.PhaseName as PhaseName,BUSINESS_CONTRACT.BailRatio as BailRatio,"+
			"getItemName('VouchType',BUSINESS_CONTRACT.VouchType) as VouchType,FLOW_OBJECT.FlowName as FlowName,"+
			"getUserName(BUSINESS_CONTRACT.OPERATEUSERID) as OperateUserName,getOrgName(BUSINESS_CONTRACT.OPERATEORGID) as OperateOrgName,"+
			"getUserName(BUSINESS_APPLY.ApproveUserID) as ApproveUserID,getOrgName(BUSINESS_APPLY.ApproveOrgID) as ApproveOrgID,BUSINESS_APPLY.ApproveDate as ApproveDate "+
			"from FLOW_OBJECT ,BUSINESS_CONTRACT,BUSINESS_APPLY "+
			"where FLOW_OBJECT.ObjectType =  'CreditApply'  and FLOW_OBJECT.ObjectNo=BUSINESS_APPLY.SerialNo and  BUSINESS_APPLY.SerialNo= BUSINESS_CONTRACT.RELATIVESERIALNO "+
			"and FLOW_OBJECT.ApplyType in ('IndependentApply','CreditLineApply','DependentApply','LowRiskApply') "+
			"and BUSINESS_CONTRACT.BusinessType not like '3%' "+
			" and BUSINESS_APPLY.InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
			
	//如果是直属支行管理员
	if(CurUser.hasRole("0M2"))
	{
		sSql += " AND BUSINESS_APPLY.InputOrgID in(select OrgID from ORG_INFO where OrgLevel='3' and OrgFlag='030') ";
	}
	//总行业务中心系统管理员
	if(CurUser.hasRole("0J2"))
	{
		sSql += " AND exists(select 1 from user_role where UserID=BUSINESS_APPLY.InputUserID and roleid in('080'))  ";
	}
	sSql += "order by FLOW_OBJECT.ObjectNo desc";
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("ObjectNo");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	doTemp.setKey("CustomerID",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	//设置对齐方式
	doTemp.setAlign("BusinessSum","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum,BusinessSum2,BailRatio","2");
	doTemp.setCheckFormat("ApproveDate","3");
	doTemp.setType("BusinessSum,BusinessSum2,Balance","Number");
	doTemp.setVisible("SerialNo,CustomerID,ObjectType,BusinessType,OccurType",false);
	//生成查询框
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.setFilter(Sqlca,"3","PhaseName","");	
	doTemp.setFilter(Sqlca,"4","ApproveDate","");
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
		{"true","","Button","详细信息","详细信息","viewAndEdit2()",sResourcesPath},
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
		sSerialNo =getItemValue(0,getRow(),"ObjectNo");	
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("CreditApply",sSerialNo,"002");
		}
	}	
    
    function viewAndEdit2()
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