<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong  2011/03/16
		Tester:
		Content: 预警信号发起
		Input Param:			
			SignalType：预警类型（01：发起；02：解除）
			SignalStatus：预警状态（10：待处理；15：待分发；20：审批中；30：批准；40：否决）   
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "风险预警发起申请列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sSignalType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalType"));	
	String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalStatus"));	
	//将空值转化为空字符串	
	if(sSignalType == null) sSignalType = "";
	if(sSignalStatus == null) sSignalStatus = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
	<%@include file="/Common/WorkFlow/ApplyList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{	
		//OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp","_self","");
		//将jsp中的变量值转化成js中的变量值
		sCustomerInfo=setObjectValue("SelectOwnerCustomer","UserID,"+"<%=CurUser.UserID%>","",0,0,"");
		//判断是否返回有效信息
		if(sCustomerInfo == "" || sCustomerInfo == "_CANCEL_" || sCustomerInfo == "_NONE_" || sCustomerInfo == "_CLEAR_" || typeof(sCustomerInfo) == "undefined") return;
		sCustomerInfo = sCustomerInfo.split('@');
		sCustomerID = sCustomerInfo[0];	
		//初始化预警信号流程及基本信息
		sReturn = RunMethod("BusinessManage","AddRiskSignalInfo",sCustomerID+","+"<%=CurUser.UserID%>");
        //根据新增申请的流水号，打开申请详情界面
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sReturn;
		openComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		/*
		popComp("RiskSignal","/CreditManage/CreditAlarm/RiskSignalMain.jsp","ObjectNo="+sReturn+"&CustomerID="+sCustomerID+"&SignalType=<%=sSignalType%>&SignalStatus=<%=sSignalStatus%>","");
		*/
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		sObjectType = getItemValue(0,getRow(),"ObjectType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			var sReturn = RunMethod("WorkFlowEngine","DeleteRiskSignalTask",sObjectType+","+sSerialNo+",DeleteTask");
			if (typeof(sReturn) != "undefined" && sReturn.length>=0)
			{
				alert("删除成功！");
			}
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}
	
	/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewRiskSignalOpinions","/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
			
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
		/*
		popComp("RiskSignal","/CreditManage/CreditAlarm/RiskSignalMain.jsp","SerialNo="+sSerialNo+"&CustomerID="+sCustomerID+"&SignalType=<%=sSignalType%>&SignalStatus=<%=sSignalStatus%>","");
		*/
		reloadSelf();
		//OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp?ObjectNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function signOpinion()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sApplyType = getItemValue(0,getRow(),"ApplyType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		sCompID = "SignRiskSignalOpinionInfo";
		sCompURL = "/CreditManage/CreditAlarm/SignRiskSignalOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApplyType="+sApplyType,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
	}
	
	/*~[Describe=提交记录;InputParam=无;OutPutParam=无;]~*/
	function commitRecord()
	{

		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}
		
		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		//检查是否签署意见
		var sReturn = PopPage("/Common/WorkFlow/RiskCheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert("请先签署认定意见，然后再提交！");//先签署认定意见
			return;
		}		
		//进行业务提交规则检测
		sReturn=RunMethod("BusinessManage","CheckRiskSignal",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
			return;  //该“return”是否有效视具体业务需求而定
			/*if(!confirm("出现红字，业务不能提交，测试阶段是否此控制暂时放行允许提交？")){
				return;
			}*/
		}
		var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignal");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0|| sSerialNo == "Null") {
			alert("没有填写预警报告审批表!");
			return;
		}
		//弹出审批提交选择窗口	
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
		if (sPhaseInfo == "Success")
		{	
			//置上审批中的标识别
			RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@20,RISK_SIGNAL,String@SerialNo@"+sObjectNo);
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}		
	}
	
	/*~[Describe=填写预警检查报告;InputParam=无;OutPutParam=无;]~*/
	function writeReport()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		/*
		sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,INSPECT_INFO,String@ObjectType@RiskSignal@String@ObjectNo@"+sSerialNo);
		if(typeof(sReturn)!="undefined" && sReturn.length != 0) 
		{
			alert('已经完成预警检查报告，只能查看');//已经完成预警检查报告，只能查看
			
		}
		*/
		PopComp("RiskSignalReports","/CreditManage/CreditAlarm/RiskSignalInspectList.jsp","CustomeID="+sObjectNo,"");
		
	}
		/*~[Describe=填写预警报告审批表;InputParam=无;OutPutParam=无;]~*/
	function writeManulReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sObjectType = "RiskSignal";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignal");
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sObjectNo+"&InspectType=RiskSignal16","","");
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}else {
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}
		//PopComp("CreditAlarm16","/FormatDoc/CreditAlarm/16.jsp","SerialNo=="+sSerialNo+"&ObjectNo="+sObjectNo,"","");				
	}
	/*~[Describe=查看预警报告审批表;InputParam=无;OutPutParam=无;]~*/
	function checkManulReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
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
		}	
	}
	
	
	/*~[Describe=查看预警检查报告;InputParam=无;OutPutParam=无;]~*/
	function viewReport()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
			PopComp("RiskSignalReport","/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
	
	//收回
	function takeBack()
	{
		//所收回任务的流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = "<%=sInitPhaseNo%>";	
		//获取任务流水号
		sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0)
		{
			if(confirm(getBusinessMessage('498'))) //确认收回该笔业务吗？
			{
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				reloadSelf();
			}
		}else
		{
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}				
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
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
