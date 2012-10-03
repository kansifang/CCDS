<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong  2012/02/21
		Tester:
		Describe: 打印预警申请表列表
		Input Param:	
			
		Output Param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "打印预警申请表列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "打印预警申请表列表";//--题头
	String sCustomerType =""; //客户类型 1为公司客户 2为同业客户 3为个人客户 4为信用共同体
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数
	sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType="";	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","预警信号流水号"},
							{"CustomerName","客户名称"},
							{"SignalType","预警类型"},
							{"SignalLevel","预警级别"},	
							{"SignalStatus","预警状态"},
							{"CustomerOpenBalance","敞口金额"},									
							{"OperateUserName","登记人"},
							{"OperateOrgName","登记机构"},
							}; 
						
		sSql =	" select RS.SerialNo as SerialNo,"+
				" GetCustomerName(RS.ObjectNo) as CustomerName,"+
				" getItemName('SignalType',RS.SignalType) as SignalType,"+
				" getItemName('SignalLevel',RS.SignalLevel) as SignalLevel,"+
				" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus,"+
				" RS.CustomerOpenBalance as CustomerOpenBalance,"+
				" getUserName(RS.InputUserID) as OperateUserName,"+
				" getOrgName(RS.InputOrgID) as OperateOrgName "+
			" from FLOW_OBJECT FO,RISK_SIGNAL RS "+
			" where  FO.ObjectType =  'RiskSignalApply' "+
				" and  FO.ObjectNo = RS.SerialNo and FO.PhaseType='1040' "+
				" and FO.ApplyType='RiskSignalApply' and RS.SignalType='01' "+
				" and RS.InputOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
		if(CurUser.hasRole("089")) sSql +="and exists(select 1 from flow_task ft1,flow_task ft2 where ft1.SerialNo=ft2.RelativeSerialNo and ft1.ObjectNo=RS.Serialno and  ft1.ApplyType='RiskSignalApply' and ft2.phaseNo='1000' and ft1.orgid='9900' )";
		if(CurUser.hasRole("08A")) sSql +="and RS.InputUserID in (select userid from user_role where roleid='080')";
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "RISK_SIGNAL";	
	//设置关键字
	doTemp.setKey("SerialNo",true);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("OperateOrgName","style={width:250px} "); 	
	//设置对齐方式
	doTemp.setAlign("CustomerOpenBalance","3");
	doTemp.setType("CustomerOpenBalance","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("CustomerOpenBalance","2");
	

	//生成查询框
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","OperateUserName","");
	doTemp.setFilter(Sqlca,"4","OperateOrgName","");
	
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
		{"true","","Button","预警详情","查看预警详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","查看预警报告审批表","查看预警报告审批表","checkManulReport()",sResourcesPath}
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------


	/*~[Describe=查看预警报告审批表;InputParam=无;OutPutParam=无;]~*/
	function checkManulReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = "RiskSignal";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignal");
	    
	    if (typeof(sSerialNo)!="undefined" && sSerialNo.length!=0 && sSerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}else{
			alert("未填写预警报告审批表!");
		}
	}
    
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//根据新增申请的流水号，打开申请详情界面
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
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
