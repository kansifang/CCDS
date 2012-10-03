<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2012/02/17
		Tester:
		Content: 预警申请列表信息
		Input Param:
					
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警申请列表信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String sComponentName = "";//--组件名称
	String sType="";
	String PG_CONTENT_TITLE = "";
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));	//获得页面参数	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"ObjectNo","申请流水号"},
							{"CustomerName","客户名称"},
							{"SignalTypeName","预警类型"},
							{"SignalLevelName","预警级别"},
							{"SignalStatusName","预警状态"},		
							{"CustomerOpenBalance","敞口金额"},
							{"PhaseNo","当前阶段号"},
							{"PhaseName","当前阶段"},
							{"OperateUserName","申请人"},
							{"OperateOrgName","申请机构"},
							{"ApproveUserID","最终审批人"},
							{"ApproveOrgID","终审机构"},
							{"ApproveDate","终审日期"}
							}; 
	
	sSql =	" select FO.ObjectType as ObjectType,FO.ObjectNo as ObjectNo,"+
			"getCustomerName(RS.ObjectNo) as CustomerName,"+
			"getItemName('SignalType',RS.SignalType) as SignalTypeName,"+
			"getItemName('SignalLevel',RS.SignalLevel) as SignalLevelName,"+
	        "getItemName('SignalStatus',RS.SignalStatus) as SignalStatusName,"+
	        "RS.CustomerOpenBalance as CustomerOpenBalance,"+
			"FO.UserName as OperateUserName,"+
			"FO.OrgName as OperateOrgName,FO.PhaseType as PhaseType,"+
			"FO.ApplyType as ApplyType,FO.FlowNo as FlowNo,FO.FlowName as FlowName,"+
			"FO.PhaseNo as PhaseNo,FO.PhaseName as PhaseName "+
			"from FLOW_OBJECT FO,RISK_SIGNAL RS "+
			"where FO.ObjectType =  'RiskSignalApply'  and  FO.ObjectNo = RS.SerialNo "+
			" and RS.InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
	sSql += "order by FO.ObjectNo desc";
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("ObjectNo");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	//设置对齐方式
	doTemp.setAlign("CustomerOpenBalance","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("CustomerOpenBalance","2");	
	doTemp.setType("CustomerOpenBalance","Number");
	doTemp.setVisible("ObjectType,PhaseType,ApplyType,FlowNo,FlowName",false);
	//生成查询框
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
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
		{"true","","Button","初始化预警","初始化预警到经办人","initApply()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=初始化批复;InputParam=无;OutPutParam=SerialNo;]~*/
	function initApply()
	{
		//获得业务流水号
		sObjectNo =getItemValue(0,getRow(),"ObjectNo");	
		sPhaseName =getItemValue(0,getRow(),"PhaseName");
		sCustomerName =getItemValue(0,getRow(),"CustomerName");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			if(confirm("你确定要把["+sCustomerName+"]的当前阶段已为["+sPhaseName+"]的申请["+sObjectNo+"]初始化到经办人阶段吗？")){
				sRetValue = PopPage("/SystemManage/SynthesisManage/InitRiskSignalAction.jsp?SerialNo="+sObjectNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if(sRetValue=='00'){
					alert("初始化成功！");
					reloadSelf();
				}else if(sRetValue=='99')
				{
					alert("初始化失败！");
				}else
				{
					alert(sRetValue);
				}
			}
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
