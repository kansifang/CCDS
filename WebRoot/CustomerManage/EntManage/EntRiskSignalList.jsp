<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xlyu 2011-09-29
		Tester:
		Content: 预警信息_Info
		Input Param:	
			SignalType：预警类型（01：发起；02：解除）		
			SignalStatus：预警状态（10：待处理；15：待分发；20：审批中；30：批准；40：否决） 
			SerialNo：预警流水号    
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警发起"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
		
	//获得组件参数		
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//将空值转化为空字符串
    if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>

<%	
	String[][] sHeaders = {							
							{"SerialNo","预警流水号"},
							{"SignalType","预警类型"},
							{"SignalLevel","预警级别"},
							{"SignalStatus","预警状态"},	
							{"CustomerOpenBalance","敞口金额"},
							{"OperateOrgName","登记机构"},
							{"OperateUserName","登记人"},
							
						};
		
	sSql =  "select RS.SerialNo,getItemName('SignalType',RS.SignalType) as SignalType,getItemName('SignalLevel',RS.SignalLevel) as SignalLevel,"+
	        " getItemName('SignalStatus',RS.SignalStatus) as SignalStatus,"+
	        " RS.CustomerOpenBalance as CustomerOpenBalance,getUserName(RS.InputUserID) as OperateUserName,"+
	        " getOrgName(RS.InputOrgID) as OperateOrgName "+
	        " from FLOW_OBJECT,RISK_SIGNAL RS where  FLOW_OBJECT.ObjectNo = RS.SerialNo and RS.ObjectNo='"+sCustomerID+"'";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//doTemp.UpdateTable="RISK_SIGNAL";
	//doTemp.setHTMLStyle("SignalName","style={width=200px}");
	//设置字段位置
	doTemp.setAlign("SignalType,SignalStatus","2");
	//设置关键字
	doTemp.setKey("SignalNo,ObjectNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	//doTemp.setVisible("SignalNo,ObjectNo",false);
	//设置敞口金额显示为三位一逗，小数点后两位
	doTemp.setType("CustomerOpenBalance","Number");
	doTemp.setCheckFormat("CustomerOpenBalance","2");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
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
			{"true","","Button","预警详情","预警详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","查看意见","查看意见","viewOpinions()",sResourcesPath}
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    //---------------------定义按钮事件------------------------------------
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
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
		//OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp?ObjectNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewRiskSignalOpinions","/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	   }
	   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function initRow()
	{
		//setItemValue(0,0,"OperateUserName","<%=CurUser.UserID%>");
		//setItemValue(0,0,"OperateOrgName","<%=CurUser.OrgID%>");
		//setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>