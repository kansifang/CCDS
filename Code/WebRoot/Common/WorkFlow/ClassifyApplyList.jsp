<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:    xhyong 2009/08/19 
		Tester:	
		Content:   风险分类认定列表
		Input Param:
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "风险分类认定列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	/*~[Describe=新增分类记录（单笔）;InputParam=无;OutPutParam=无;]~*/
	function newSingleRecord()
	{    		
		sReturn = popComp("ClassifyDialog","/CreditManage/CreditCheck/ClassifyDialog.jsp","ObjectType=BusinessContract&ModelNo=Classify1&Type=Single&ClassifyType=010","dialogWidth=30;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=新增分类记录（批量）;InputParam=无;OutPutParam=无;]~*/
	function newBatchRecord()
	{    		
		sReturn = popComp("ClassifyDialog","/CreditManage/CreditCheck/ClassifyDialog.jsp","ObjectType=BusinessContract&ModelNo=Classify1&Type=Batch&ClassifyType=010","dialogWidth=30;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	//收回
	function takeBack()
	{
		//所收回任务的流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
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
	
	
	/*~[Describe=分类认定;InputParam=无;OutPutParam=无;]~*/
	function classifyCogn()
	{	
		//获得类型、流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");//申请类型
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//申请流水号
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");//客户类型 
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sCSerialNo = getItemValue(0,getRow(),"ObjectNo");//合同流水号
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//客户ID
		var sRightType="";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		if(sPhaseNo != "0010"){
		    sRightType="ReadOnly";
		}
		PopComp("ClassifyCogn","/CreditManage/CreditCheck/ClassifyCogn.jsp","SerialNo="+sSerialNo+"&CustomerType="+sCustomerType+"&TaskNo="+sTaskNo+"&CustomerID="+sCustomerID+"&ObjectNo="+sCSerialNo+"&RightType="+sRightType,"","");
		reloadSelf();
	}
	
	/*~[Describe=重新认定;InputParam=无;OutPutParam=无;]add by bqliu 2011/06/17 ~*/
	function reSubmit()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");//分类流水号
		sBCObjectNo = getItemValue(0,getRow(),"ObjectNo");//合同流水号
		sPhaseNo = "0010";
		sOrgID = "<%=CurOrg.OrgID%>";
		//获得任务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		//获取最终审批人
		sRuturn = RunMethod("WorkFlowEngine","GetFinalUser",sSerialNo);
		var sUserID = sRuturn.split("@")[0];
		var relativeSerialNo = sRuturn.split("@")[1];
		if(sUserID != "<%=CurUser.UserID%>"){
		    alert("不能重新认定非自己批准的业务");
		    return;
		}
		//取最近一条审批记录
		sMaxRelativeSerialNo=RunMethod("WorkFlowEngine","getMaxClassifyFlowNo",sBCObjectNo);
		if(sSerialNo!=sMaxRelativeSerialNo)
		{
			alert("该笔业务不是最近一期的风险分类申请或者存在在途的风险分类申请,不能进行重新认定!");
			return;
		}
		if(confirm("是否真的需要强制重新认定，强制重新认定会导致签署的意见全部清除，请慎用！")){
			sReturn = RunMethod("BusinessManage","EnforceTakeBackBusiness",sObjectType+","+sObjectNo+","+sPhaseNo+","+sOrgID+","+relativeSerialNo);	
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@FinishDate@None,CLASSIFY_RECORD,String@SerialNo@"+sSerialNo);
			alert(sReturn);
			reloadSelf();
		}
	}
	
	/*~[Describe=模型分类;InputParam=无;OutPutParam=无;]~*/
	function modelClassify()
	{				
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
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
		OpenComp("ClassifyDetails","/CreditManage/CreditCheck/ClassifyDetail.jsp","ComponentName=风险分类参考模型&Action=_DISPLAY_&ObjectType=BusinessContract&ObjectNo="+sObjectNo+"&AccountMonth="+sAccountMonth+"&SerialNo="+sSerialNo+"&ModelNo=Classify1&ClassifyType=010","_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=查看模型分类;InputParam=无;OutPutParam=无;]~*/
	function viewModel()
	{				
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
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
	
	/*~[Describe=删除分类记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		//获得类型、流水号
		var ObjectType = getItemValue(0,getRow(),"ObjectType");
		var SerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(SerialNo)=="undefined" || SerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			var sReturn = RunMethod("WorkFlowEngine","DeleteClassifyTask",ObjectType+","+SerialNo+",DeleteTask");
			if (typeof(sReturn) != "undefined" && sReturn.length>=0)
			{
				alert("删除成功！");
			}	
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}	
	
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function classifyEdit()
	{	
		//获得类型、流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");//申请类型
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//申请流水号
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sCSerialNo = getItemValue(0,getRow(),"ObjectNo");//合同流水号
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//客户ID
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

		PopComp("SignClassifyOpinionInfo","/Common/WorkFlow/SignClassifyOpinionInfo.jsp","SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo+"&CSerialNo="+sCSerialNo+"&CustomerID="+sCustomerID,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=完成分类;InputParam=无;OutPutParam=无;]~*/
	function Finished()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！Result1
			return;
		}
		
		sResult1 = getItemValue(0,getRow(),"Result1");
		if (typeof(sResult1)=="undefined" || sResult1.length==0)	
		{
			alert(getBusinessMessage('658'));//风险分类没有完成！
			return;
		}
		if(confirm(getBusinessMessage('659')))//您确定已经分类完成吗？
		{	
			//认定完成操作
			sFinishDate = "<%=StringFunction.getToday()%>";
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishDate@"+sFinishDate+",CLASSIFY_RECORD,String@SerialNo@"+sSerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
				alert(getBusinessMessage('660'));//完成资产风险分类失败！
				return;			
			}else
			{
				reloadSelf();	
				alert(getBusinessMessage('661'));	//完成资产风险分类成功！
			}	
		}
	}	
	
	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function contractInfo()
	{ 
		//合同流水号
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //请选择一条信息！
			return;
		}
		
		openObject("AfterLoan",sSerialNo,"002");
	}
	
	/*~[Describe=借据详情;InputParam=无;OutPutParam=无;]~*/
	function DueBillInfo()
	{ 
		//借据流水号
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //请选择一条信息！
			return;
		}
		
		openObject("BusinessDueBill",sSerialNo,"002");
	}
	
/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得类型、流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		PopComp("ViewClassifyOpinions","/Common/WorkFlow/ViewClassifyOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()
	{//获得类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	    sFinishDate = "<%=StringFunction.getToday()%>";
		sUserId="<%=CurUser.UserID%>";
		sCustomerName = getItemValue(0,getRow(),"CustomerName");//客户名称
		sResult1 = getItemValue(0,getRow(),"Result1");//初分结果(PhaseOpinion2)
		sClassifyLevel = getItemValue(0,getRow(),"ClassifyLevel");//客户经理分类结果(账面)(PhaseOpinion3)
		sClassifyLevel2 = getItemValue(0,getRow(),"ClassifyLevel2");//客户经理分类结果(实际)(PhaseOpinion4)
	
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
	
		//检查是否签署意见
		var sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert("请先填写分类认定，然后再提交！");//先签署认定意见
			return;
		}
		
		//更新意见表
		sReturn = RunMethod("WorkFlowEngine","UpdateCROpinion",sSerialNo+","+sResult1+","+sClassifyLevel+","+sClassifyLevel2+","+sCustomerName);
		
		//重新初始化流程 
		if(sObjectType == "ClassifyApply")//重新初始化流程
		{
			sReturn=RunMethod("BusinessManage","ReinitClassifyFlow",sSerialNo+","+sObjectType+","+sTaskNo);
		}
		
		//弹出审批提交选择窗口		
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined"){
			 return;
		}else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//提交成功！
				reloadSelf();
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}		
	}
	
	/*~[Describe=填写风险分类认定报告;InputParam=无;OutPutParam=无;]~*/
	function genReport()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sDocID = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sReturn = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if(typeof(sReturn)=="undefined" || sReturn.length==0)
		{
			sDocID = "10";	
		}else
		{
			sDocID = sReturn;
			sReturn = PopPage("/Common/WorkFlow/ButtonDialog.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sReturn)=="undefined"  || sReturn.length==0 )
			{
				return;
			}else if (sReturn == "_CANCEL_") 
			{
				sDocID = "10";
			}			
		}
		sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if(typeof(sReturn)!='undefined' && sReturn!="")
		{
			sReturnSplit = sReturn.split("?");
			var sFormName=randomNumber().toString();
			sFormName = "AA"+sFormName.substring(2);
			OpenComp("MonitorFormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
		}
	}
	
	/*~[Describe=生成风险分类认定报告;InputParam=无;OutPutParam=无;]~*/
	function createReport()
	{
		//获得申请类型、申请流水号、客户编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert(getBusinessMessage('505'));//调查报告还未填写，请先填写调查报告再查看！
			return;
		}	
		var sAttribute = PopPage("/FormatDoc/DefaultPrint/GetAttributeAction.jsp?DocID="+sDocID,"","");
		
		if (confirm(getBusinessMessage('504'))) //是否要增加打印内容,如果是请点击确定按钮！
		{
			var sAttribute1 = PopPage("/Common/WorkFlow/DefaultPrintSelect.jsp?DocID="+sDocID+"&rand="+randomNumber(),"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
			if (typeof(sAttribute1)=="undefined" || sAttribute1.length==0)
				return;
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute1,"_blank02",CurOpenStyle); 
		}
		else
		{
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute,"_blank02",CurOpenStyle); 
		}
	}	
	
	/*~[Describe=打印风险分类认定报告;InputParam=无;OutPutParam=无;]~*/
	function printReport()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert(getBusinessMessage('505'));//调查报告还未填写，请先填写调查报告再查看！
			return;
		}
		
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
		if (sReturn == "false")
		{
			createReport();
			return;  
		}else
		{
			if(confirm(getBusinessMessage('503')))//调查报告有可能更改，是否生成调查报告后再查看！
			{
				createReport();
				return; 
			}else
			{				
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
				OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
		}
		

	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
    var bHighlightFirst = true;//自动选中第一条记录
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
