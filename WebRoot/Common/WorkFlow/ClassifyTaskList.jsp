<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/20 
		Tester:
		Content: 该页面主要处理信用等级评估的审查审批列表
		Input Param:
		Output param:
		History Log: 初始化页面
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信用等级评估认定审批"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
	<%@include file="/Common/WorkFlow/TaskList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>
	
	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()
	{
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//获取任务流水号
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		if(!((sFlowNo == "ClassifyFlow" && (sPhaseNo == "0060" || sPhaseNo == "0090"))||(sFlowNo == "ClassifyFlow01" && (sPhaseNo == "0060" ))))
		{
			//检查是否签署意见
			var sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {
				alert("请先签署认定意见，然后再提交！");//先签署认定意见
				return;
			}
		}
		//弹出审批提交选择窗口		
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined"){
			 return;
		}else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=信用等级认定审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//提交成功！
				OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=信用等级认定审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}
	}
	
	/*~[Describe=查看模型分类;InputParam=无;OutPutParam=无;]~*/
	function viewModel()
	{				
		sSerialNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectNo = getItemValue(0,getRow(),"BCObjectNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		//得到客户类型	
	    var sColName = "CUSTOMER_INFO.CustomerType";
		var sTableName = "CUSTOMER_INFO|BUSINESS_CONTRACT";
		var sWhereClause = "None@BUSINESS_CONTRACT.CustomerID@CUSTOMER_INFO.CustomerID@String@BUSINESS_CONTRACT.SERIALNO@"+sObjectNo;
			
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "")
		{
			sReturn = sReturn.split('@');			
			if (sReturn[1].substring(0,2)=="03")
			{
				alert("个人客户不用进行模型分类!");
				return;
			}
		}
		
		OpenComp("ClassifyDetails","/CreditManage/CreditCheck/ClassifyDetail.jsp","ComponentName=风险分类参考模型&Action=_DISPLAY_&ObjectType=BusinessContract&ObjectNo="+sObjectNo+"&AccountMonth="+sAccountMonth+"&SerialNo="+sSerialNo+"&ModelNo=Classify1&ClassifyType=020","_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=任务收回;InputParam=无;OutPutParam=无;]~*/
	function takeBack()
	{
		//获取任务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined"||sSerialNo.length == 0 )
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//收回任务操作
		sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"收回任务操作","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		//如果成功，则刷新页面
		if (sRetValue == "Commit")
		{
		    OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
		}		
	}
	
	/*~[Describe=分类认定;InputParam=无;OutPutParam=无;]~*/
	function classifyCogn()
	{	
		//获得类型、流水号、流程编号、阶段编号
		var sSerialNo = getItemValue(0,getRow(),"CRSerialNo");//申请流水号
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");//客户类型 
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//客户ID
		var sCustomerName = getItemValue(0,getRow(),"CustomerName");//客户ID
		var sObjectNo = getItemValue(0,getRow(),"BCObjectNo");//合同流水号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCustomerType = RunMethod("CustomerManage","GetCustomerType",sCustomerID);
		PopComp("ClassifyCogn","/CreditManage/CreditCheck/ClassifyCogn.jsp","SerialNo="+sSerialNo+"&CustomerType="+sCustomerType+"&TaskNo=1"+"&RightType=ReadOnly"+"&ObjectNo="+sObjectNo,"","");
		reloadSelf();
	}
	
	 /*~[Describe=重新认定;InputParam=无;OutPutParam=无;]~*/
	function reSubmit()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBCObjectNo=getItemValue(0,getRow(),"BCObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sOrgID = "<%=CurOrg.OrgID%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		//获得任务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		//取最近一条审批记录
		sMaxRelativeSerialNo=RunMethod("WorkFlowEngine","getMaxClassifyFlowNo",sBCObjectNo);
		if(sSerialNo!=sMaxRelativeSerialNo)
		{
			alert("该笔业务不是最近一期的风险分类申请或者存在在途的风险分类申请,不能进行重新认定!"); 
			return;
		}
		if(confirm("是否真的需要强制收回本笔业务，强制收回会导致以后阶段的意见全部清除，请慎用！")){
			sReturn = RunMethod("BusinessManage","EnforceTakeBackBusiness",sObjectType+","+sObjectNo+","+sPhaseNo+","+sOrgID+","+sSerialNo);	
			alert(sReturn);
			reloadSelf();
		}
	}

		
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function classifyEdit()
	{	
		//获得类型、流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");//申请类型
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");//申请流水号
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sCSerialNo = getItemValue(0,getRow(),"BCObjectNo");//合同流水号
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//客户ID
		var sClassifyLevel = getItemValue(0,getRow(),"Result2Name");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}

		PopComp("SignClassifyOpinionInfo","/Common/WorkFlow/SignClassifyOpinionInfo.jsp","SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo+"&CSerialNo="+sCSerialNo+"&CustomerID="+sCustomerID+"&ClassifyLevel="+sClassifyLevel,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function contractInfo()
	{ 
		//合同流水号
		var sSerialNo = getItemValue(0,getRow(),"BCObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //请选择一条信息！
			return;
		}
		
		openObject("AfterLoan",sSerialNo,"002");
	}
		
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得类型、流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		PopComp("ViewClassifyOpinions","/Common/WorkFlow/ViewClassifyOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=退回前一步;InputParam=无;OutPutParam=无;]~*/
	function backStep()
	{	
			
		//获取任务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");				
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
        {	
    		alert(getHtmlMessage('1'));//请选择一条信息！
    		return;
		}
		
		//检查是否签署意见
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");	
		if(typeof(sReturn)=="undefined" || sReturn.length==0) 
		{						
			//退回任务操作   
			if(!confirm(getBusinessMessage('509'))) return; //您确认要将该申请退回上一环节吗？	
			sRetValue = PopPage("/Common/WorkFlow/CancelTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"退回任务操作","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//如果成功，则刷新页面
			if (sRetValue == "Commit")
			{
				OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=信用等级认定审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			}else{
				alert(sRetValue);
			}
		}else
		{
			alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
			return;
		}
		
	}
	
	/*~~~~~~~~~~~~~~~~~~~~~分发员（其他的不行）批量提交风险分类 add by zwhu 201007005~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
	function batchSubmit(){
		popComp("ClassifyBatchSubmit","/CreditManage/CreditCheck/ClassifyBatchSubmit.jsp","ComponentName=批量提交风险分类&ComponentType=MainWindow","","")
		reloadSelf();
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
