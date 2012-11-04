<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: 该页面主要处理业务相关的申请列表，如授信额度申请列表，额度项下业务申请列表，
					单笔授信业务申请列表
		Input Param:
		Output param:
		History Log: 
					zywei 2005/07/27 重检页面 
					zywei 2007/10/10 修改取消申请的提示语
					zywei 2007/10/10 新增调查报告时，仅低风险业务、授信项下业务、银票贴现业务、综合授信业务、个人客户、
							中小企业之外的业务才进行调查报告格式保留与否的判断
					zywei 2007/10/10 解决用户打开多个界面进行重复操作而产生的错误
		 */
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
<%
	String PG_TITLE = "授信方案管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/
%>
<%@include file="/Common/WorkFlow/ApplyList.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
	String sIsInuse = "" ;
	sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
	if (sIsInuse== null) sIsInuse="" ;
%>
<script language=javascript>

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newApply()
	{
		//将jsp中的变量值转化成js中的变量值
		sObjectType = "<%=sObjectType%>";	
		sApplyType = "<%=sApplyType%>";	
		sPhaseType = "<%=sPhaseType%>";
		sInitFlowNo = "<%=sInitFlowNo%>";
		sInitPhaseNo = "<%=sInitPhaseNo%>";			
		//弹出新增申请参数对话框
		if(sApplyType == "CreditLineApply") 
		{
			sCompID = "CreditLineApplyCreationInfo";
			sCompURL = "/CreditManage/CreditApply/CreditLineApplyCreationInfo.jsp";			
		}else
		{
			sCompID = "CreditApplyCreation";
			sCompURL = "/CreditManage/CreditApply/CreditApplyCreationInfo1.jsp";
		}
		sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sObjectNo=sReturn[0];
		
        //根据新增申请的流水号，打开申请详情界面
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();		
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function cancelApply()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('70')))//您真的想取消该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sInitFlowNo = "<%=sInitFlowNo%>";
		sInitPhaseNo = "<%=sInitPhaseNo%>";	
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sOccurType = getItemValue(0,getRow(),"OccurType");
	
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
		
		//对占用的综合授信额度的有效性进行检查
		sCreditAggreement = getItemValue(0,getRow(),"CreditAggreement");//授信协议编号
		if(typeof(sCreditAggreement)!="undefined" && sCreditAggreement.length>0) 
		{
			sLineID = RunMethod("CreditLine","GetLineID",sCreditAggreement);	
			sBusinessType = getItemValue(0,getRow(),"BusinessType");
			sReturn=RunMethod("BusinessManage","CreditLineControl",sObjectType+","+sObjectNo+","+sLineID+","+sBusinessType+","+sCustomerID+","+sCreditAggreement+",CreditAggreement");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				PopPage("/Common/WorkFlow/CheckLineView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
				return;  //该“return”是否有效视具体业务需求而定
			}
		}
		//对占用的农户联保的有效性进行检查
		sAssureAgreement = getItemValue(0,getRow(),"AssureAgreement");//授信协议编号
		if(typeof(sAssureAgreement)!="undefined" && sAssureAgreement.length>0) 
		{
			sLineID = RunMethod("CreditLine","GetLineID",sAssureAgreement);	
			sBusinessType = getItemValue(0,getRow(),"BusinessType");
			sReturn=RunMethod("BusinessManage","CreditLineControl",sObjectType+","+sObjectNo+","+sLineID+","+sBusinessType+","+sCustomerID+","+sAssureAgreement+",AssureAgreement");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				PopPage("/Common/WorkFlow/CheckLineView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
				return;  //该“return”是否有效视具体业务需求而定
			}
		}
		//对占用的信用共同体额度的有效性进行检查
		sCommunityAgreement = getItemValue(0,getRow(),"CommunityAgreement");//授信协议编号
		if(typeof(sCommunityAgreement)!="undefined" && sCommunityAgreement.length>0) 
		{
			sLineID = RunMethod("CreditLine","GetLineID",sCommunityAgreement);	
			sBusinessType = getItemValue(0,getRow(),"BusinessType");
			sReturn=RunMethod("BusinessManage","CreditLineControl",sObjectType+","+sObjectNo+","+sLineID+","+sBusinessType+","+sCustomerID+","+sCommunityAgreement+",CommunityAgreement");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				PopPage("/Common/WorkFlow/CheckLineView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
				return;  //该“return”是否有效视具体业务需求而定
			}
		}
		
		var sRehearSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RehearForm");
	   	if ((typeof(sRehearSerialNo)=="undefined" || sRehearSerialNo.length==0 || sRehearSerialNo == "Null")&& sOccurType=="090")
		{
			alert("还未填写复审申请表!");
			return;
		}
		
		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0 || sTaskNo=='Null' || sTaskNo=='null') {
			//alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			reloadSelf();	
			return;
		}
		//检查是否签署意见
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn == 'Null' || sReturn == 'null' ) {
			alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
			return;
		}
		
		//进行业务提示(只提示不控制)
		sReturn=RunMethod("BusinessManage","CheckBusinessRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/ShowRiskView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
		}
		
		//进行业务提交规则检测
		sReturn=RunMethod("BusinessManage","CheckApplyRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
			return;  //该“return”是否有效视具体业务需求而定
			/*if(!confirm("出现红字，业务不能提交，测试阶段是否此控制暂时放行允许提交？")){
				return;
			}*/
		}
		
		//重新初始化流程 放在checkapplyrisk后 by zrli 20100303
		if(sObjectType == "CreditApply" && sInitFlowNo == "CreditFlow" && sPhaseNo == "0010")//重新初始化流程
		{
			 PopPage("/Common/WorkFlow/ReinitFlow.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&TaskNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}
		
		//弹出审批提交选择窗口	
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
		if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}

/*delete by lpzhang 将流程两步改为一步----------------begin-------------
		//弹出审批提交选择窗口		
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined") return;
		else if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else
		{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success")
			{
				alert(getHtmlMessage('18'));//提交成功！
				reloadSelf();
			}else if (sPhaseInfo == "Failure")
			{
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}	
	------------------end -----------	*/			
	}
	
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function signOpinion()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sApplyType = getItemValue(0,getRow(),"ApplyType");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sTempSaveFlag = getItemValue(0,getRow(),"TempSaveFlag");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sTempSaveFlag !="2"){
			alert("申请信息没有填写完整或处于暂存状态");
			return;
		}
		//add by hldu
		//个人客户业务种类和信用评级类型控制规则
        if(sApplyType == "IndependentApply")
        {
        	sReturn = RunMethod("BusinessManage","CheckBusinessTypeAndEvaluate",sObjectNo+","+sObjectType+","+sCustomerID+","+sBusinessType);
        	if(typeof(sReturn) != "undefined" && sReturn != "") 
        	{
        		alert(sReturn);
        		return;
        	}
        }
        // add end
		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0 || sTaskNo=='Null' || sTaskNo=='null') {
			//alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			reloadSelf();	
			return;
		}
		sCompID = "SignTaskOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&CustomerID="+sCustomerID+"&ApplyType="+sApplyType+"&BusinessType="+sBusinessType,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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

	/*~[Describe=归档;InputParam=无;OutPutParam=无;]~*/
	function archive()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('56'))) //您真的想将该信息归档吗？
		{
			//归档操作
			sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",BUSINESS_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getHtmlMessage('60'));//归档失败！
				return;			
			}else
			{
				reloadSelf();	
				alert(getHtmlMessage('57'));//归档成功！
			}			
		}
	}

	/*~[Describe=取消归档;InputParam=无;OutPutParam=无;]~*/
	function cancelarch()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('58'))) //您真的想将该信息归档取消吗？
		{
			//取消归档操作
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BUSINESS_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//取消归档失败！
				return;
			}else
			{
				reloadSelf();
				alert(getHtmlMessage('59'));//取消归档成功！
			}
		}
	}

	/*~[Describe=自动风险报告;InputParam=无;OutPutParam=无;]~*/
	function riskSkan()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//进行风险智能探测
		popComp("ScenarioAlarm.jsp","/PublicInfo/ScenarioAlarm.jsp","OneStepRun=No&ScenarioNo=001&ObjectType=ApplySerialNo&ObjectNo="+sObjectNo,"dialogWidth=45;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
		//sReturn=RunMethod("BusinessManage","CheckApplyRisk",sObjectType+","+sObjectNo);
		//if(typeof(sReturn) != "undefined" && sReturn != "") 
			//PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
	}
		
	/*~[Describe=填写调查报告;InputParam=无;OutPutParam=无;]~*/
	function genReport()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		
		var sDocID = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		//加入担保信息的校验 add by bqliu 2011-05-20
		var sReturn = RunMethod("BusinessManage","CheckVouchInfo",sObjectType+","+sObjectNo);
		if (sReturn != ""&&sBusinessType != "1080030"&&sBusinessType != "1080035"
			&&sBusinessType != "1080055"&&sBusinessType != "1080060")
		{
			alert(sReturn);
			return;
		}
		
		sReturn = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if(typeof(sReturn)=="undefined" || sReturn.length==0)
		{
			
			sFlag = PopPage("/FormatDoc/GetCustomerTypeAction.jsp?ObjectNo="+sObjectNo,"","");
			//个人客户授信业务调查报告
			if(sFlag =="2"){
				sDocID = setObjectValue("SelectIndReportType","","",0,0,"");
				if(sDocID == "" || sDocID == "_CANCEL_" || sDocID == "_NONE_" || sDocID == "_CLEAR_" || typeof(sDocID) == "undefined") return;			
				sDocID = sDocID.split("@");
				sDocID = sDocID[0];
			}
			//公司客户授信业务调查报告
			else
			{
				sDocID = setObjectValue("SelectEntReportType","","",0,0,"");
				if(sDocID == "" || sDocID == "_CANCEL_" || sDocID == "_NONE_" || sDocID == "_CLEAR_" || typeof(sDocID) == "undefined") return;			
				sDocID = sDocID.split("@");
				sDocID = sDocID[0];
			}			
		}else
		{
			sDocID = sReturn;
			sFlag = PopPage("/FormatDoc/GetCustomerTypeAction.jsp?ObjectNo="+sObjectNo,"","");

			sReturn = PopPage("/Common/WorkFlow/ButtonDialog.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sReturn)=="undefined"  || sReturn.length==0 )
			{
				return;
			}else if (sReturn == "_CANCEL_") 
			{
				PopPage("/FormatDoc/DeleteReportAction.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if(sFlag=="1"){
					sDocID = setObjectValue("SelectEntReportType","","",0,0,"");
					if(sDocID == "" || sDocID == "_CANCEL_" || sDocID == "_NONE_" || sDocID == "_CLEAR_" || typeof(sDocID) == "undefined") return;			
					sDocID = sDocID.split("@");
					sDocID = sDocID[0];	
				}
				else{
					sDocID = setObjectValue("SelectIndReportType","","",0,0,"");
					if(sDocID == "" || sDocID == "_CANCEL_" || sDocID == "_NONE_" || sDocID == "_CLEAR_" || typeof(sDocID) == "undefined") return;			
					sDocID = sDocID.split("@");
					sDocID = sDocID[0];	
				}
			}			
		}
		sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		
		if(typeof(sReturn)!='undefined' && sReturn!="")
		{
			sReturnSplit = sReturn.split("?");
			var sFormName=randomNumber().toString();
			sFormName = "AA"+sFormName.substring(2);
			OpenComp("FormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
		}
	}
	
	/*~[Describe=生成调查报告;InputParam=无;OutPutParam=无;]~*/
	function createReport()
	{
		//获得申请类型、申请流水号、客户编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
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
	
	/*~[Describe=查看调查报告;InputParam=无;OutPutParam=无;]~*/
	function viewReport()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("是否查看系统生成的调查报告，点击“确定”查看！点击“取消”查看上传的调查报告！")){
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
				 if((sPhaseNo=="0010"||sPhaseNo=="3000")&&confirm(getBusinessMessage('503')))//调查报告有可能更改，是否生成调查报告后再查看！
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
		else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}	
	}	
	/*~[Describe=复制当前;InputParam=无;OutPutParam=无;]~*/
	function copyThis()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = "<%=sObjectType%>";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sReturn = RunMethod("WorkFlowEngine","CopyApplyFlow",sObjectType+","+sObjectNo);
		if(typeof(sReturn)!="undefined" && sReturn.length!=0)	
		{
			alert("复制成功");
			reloadSelf();					
		}
	}	
	
	/*~[Describe=填写基本信息情况表;InputParam=无;OutPutParam=无;]~*/
	function setBasisInfo()
	{
		//获得申请类型、申请流水号、客户编号
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = "BasisInfo";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sReturn = PopPage("/Common/WorkFlow/ButtonDialog.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sReturn)=="undefined"  || sReturn.length==0 )
		{
			return;
		}else if (sReturn == "_CANCEL_") 
		{
			PopPage("/FormatDoc/DeleteReportAction.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		}	
		var sDocID = "70";
		
		sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		
		if(typeof(sReturn)!='undefined' && sReturn!="")
		{
			sReturnSplit = sReturn.split("?");
			var sFormName=randomNumber().toString();
			sFormName = "AA"+sFormName.substring(2);
			OpenComp("FormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
		}
	}	
	
	/*~[Describe=生成基本信息情况表;InputParam=无;OutPutParam=无;]~*/
	function createBasisInfo(){
	    
	    //获得申请类型、申请流水号、客户编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		sCustomerID = RunMethod("BusinessManage","GetCustomerID",sObjectType+","+sObjectNo);
        sObjectType = "BasisInfo";
        
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0 || sDocID!='70')
		{
			alert("基本信息表还未填写，请先填写后再查看！");
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
	
	/*~[Describe=查看基本信息;InputParam=无;OutPutParam=无;]~*/
	function viewBasisInfo()
	{
		//获得申请类型、申请流水号
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sObjectType = "BasisInfo";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm("是否查看系统生成的基本信息表，点击“确定”查看！点击“取消”查看上传的基本信息表！")){
			var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (typeof(sDocID)=="undefined" || sDocID.length==0 || sDocID!='70')
			{
				alert("基本信息表还未填写，请先填写后再查看！");//调查报告还未填写，请先填写调查报告再查看！
				return;
			}
			
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
			if (sReturn == "false")
			{
				createBasisInfo();
				return;  
			}else
			{
				 if((sPhaseNo=="0010"||sPhaseNo=="3000")&&confirm("基本信息表有可能更改，是否生成基本信息表后再查看！"))
				{
					createBasisInfo();
					return; 
				}else
				{				
					var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
					OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
				}
			}
		}
		else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}
		
	}
		
	/*~[Describe=查看授信业务批复报告;InputParam=无;OutPutParam=无;]~*/
	function viewApproveApproval()
	{	
	    //获得申请类型、申请流水号
		var sObjectType = "ApproveApproval";
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	    
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+","+sObjectType);
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			alert("该业务无批复信息！");
			return;
		}else{
		    //判断是否提交
			var sColName = "FinishApproveUserID";
			var sTableName = "BUSINESS_APPLY";
			var sWhereClause = "String@SerialNo@"+sObjectNo;
		    sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('@');
				if(sReturn[1]=="null")
				{
					alert("批复未通过！");
					return;
				}
			}
			var sCompID = "PurposeInspectTab";
			var sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			var sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true&viewPrint=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		return true;
	}
	
		
	/*~[Describe=发送公积金审批结果;InputParam=无;OutPutParam=无;]~*/	
	function sendApproveResult()
	{
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sOccurType	= getItemValue(0,getRow(),"OccurType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sObjectType = "<%=sObjectType%>";
		var sTradeType = "";
		if(sOccurType == '120')
		{
			sTradeType = "6031";
		}else
		{
			sTradeType = "6021";
		}
		if(sBusinessType == '1110027')
		{
			sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
			sReturn=sReturn.split("@");
			if(sReturn[0] != "0000000"){
				alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
				return;
			}else{
				alert("发送个贷成功！");
			}
		}else
		{
			alert("该笔贷款不是公积金贷款！");
			return;
		}
	}
		
	/*~[Describe=填写复审申请表;InputParam=无;OutPutParam=无;]~*/
	function fillRehearForm()
	{	
	    //获得申请类型、申请流水号
		sObjectType = "RehearForm";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sOccurType = getItemValue(0,getRow(),"OccurType");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sOccurType!="090")
		{
			alert("该笔申请不是复审业务,不需要填写复审申请表!");
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+","+sObjectType);
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sObjectNo+"&InspectType=065","","");
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
	}
	
	/*~[Describe=查看复审申请表;InputParam=无;OutPutParam=无;]~*/
	function viewRehearForm()
	{	
	    //获得申请类型、申请流水号
		var sObjectType = "RehearForm";
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sOccurType = getItemValue(0,getRow(),"OccurType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sOccurType!="090")
		{
			alert("该笔申请不是复审业务,不需要查看复审申请表!");
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+","+sObjectType);
	   	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			alert("还未填写复审申请表!");
			return;
		}else{
			var sCompID = "PurposeInspectTab";
			var sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			var sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		return true;
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
<script language=javascript>
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>		
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>