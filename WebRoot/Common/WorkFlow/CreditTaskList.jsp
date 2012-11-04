<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: 该页面主要处理业务相关的审查审批列表
		Input Param:
		Output param:
		History Log: 
			2005.08.03 jbye    重新修改流程审查相关信息
			2005.08.05 zywei   重检页面
			2009-8-18  lpzhang for TJ 修改提交等相关信息
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
		//获得申请类型、申请流水号、阶段编号、流程编号,机构编号,人员编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sUserID = getItemValue(0,getRow(),"UserID");
		//获得任务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("该业务这阶段审批已经提交，不能再次提交！");//该业务这阶段审批已经提交，不能再次提交！
			reloadSelf();
			return;
		}
			
		//检查是否签署意见
		if(!((sFlowNo == "CreditFlow03" && (sPhaseNo == "0060" || sPhaseNo == "0250")) || 
		   (sFlowNo == "EntCreditFlow01" && (sPhaseNo == "0030" || sPhaseNo == "0060" || sPhaseNo == "0090" || sPhaseNo == "0120" ||
		   									 sPhaseNo == "0150" || sPhaseNo == "0190" || sPhaseNo == "0250" || sPhaseNo == "0280" ||
		   									 sPhaseNo == "0220")) ||		   									     
		   (sFlowNo == "EntCreditFlow02" && (sPhaseNo == "0060" || sPhaseNo == "0090" || sPhaseNo == "0120" || sPhaseNo == "0190" ||
		   									 sPhaseNo == "0220" || sPhaseNo == "0250" )) ||	
 		   (sFlowNo == "EntCreditFlow03" && (sPhaseNo == "0040" || sPhaseNo == "0070" || sPhaseNo == "0100"  )) ||			   									 	   
		   (sFlowNo == "IndCreditFlow01" && (sPhaseNo == "0030" || sPhaseNo == "0090" || sPhaseNo == "0120" || sPhaseNo == "0150" ||
		   									 sPhaseNo == "0240" || sPhaseNo == "0260" || sPhaseNo == "0280")) ||			   
		   (sFlowNo == "IndCreditFlow02" && (sPhaseNo == "0050" || sPhaseNo == "0080" || sPhaseNo == "0250" || sPhaseNo == "0180" )) ||
		   (sFlowNo == "EntCreditFlowTJ02"  &&(sPhaseNo == "0040" || sPhaseNo == "0110" || sPhaseNo == "0080" ))||
		   (sFlowNo == "IndCreditFlowTJ02"  &&(sPhaseNo == "0040" || sPhaseNo == "0110"  )) || 
		   (sFlowNo == "EntCreditFlowTJ01" &&(sPhaseNo == "0030" || sPhaseNo == "0120" || sPhaseNo == "0150" || sPhaseNo == "0190" ||
		   									sPhaseNo == "0250" || sPhaseNo == "0280"))||
		   (sFlowNo == "IndCreditFlowTJ01" &&(sPhaseNo == "0030" || sPhaseNo == "0120" || sPhaseNo == "0150" || sPhaseNo == "0190" ||
		   									sPhaseNo == "0280"))									
		   ))
		{
			sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {
				alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
				return;
			}	
		}
		
		if((sFlowNo == "EntCreditFlowTJ01" && (sPhaseNo == "0130" || sPhaseNo == "0260")) 
			|| (sFlowNo == "IndCreditFlowTJ01" && (sPhaseNo == "0130" || sPhaseNo == "0200"))
			|| (sFlowNo == "CreditFlow02" && sPhaseNo == "0030"))
		{
			sObjectType1 = "";
			if (sFlowNo == "EntCreditFlowTJ01" && sPhaseNo == "0130" ){
				sObjectType1 = "CountyApprove";
			}
			else if (sFlowNo == "EntCreditFlowTJ01" && sPhaseNo == "0260" ){
				sObjectType1 = "CityApprove";
			}	
			else if(sFlowNo == "IndCreditFlowTJ01" && sPhaseNo == "0130" ){
				sObjectType1 = "CountyApprove";
			}
			else if(sFlowNo == "IndCreditFlowTJ01" && sPhaseNo == "0200"){
				sObjectType1 = "CityApprove";
			}
			else if(sFlowNo == "CreditFlow02" && sPhaseNo == "0030"){
				sObjectType1 = "SmallCustomerAP";
			}
			/* 由于可以上传审查报告，控制取消 add by zwhu 20100929
			var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType1,"","");
			if (typeof(sDocID)=="undefined" || sDocID.length==0)
			{
				alert("审查报告还未填写，请先填写审查报告！");
				return;
			}
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType1+"&DocID="+sDocID,"","");
			if (sReturn == "false")
			{
				alert("审查报告还未生成，请生成审查报告再提交！")
				return;  
			}
			*/
		}
		
		//增加“填写基本情况信息表”控制规则  add by bqliu 2011-05-26
		if(sFlowNo == "EntCreditFlowTJ01"){
		    sObjectType2 = "BasisInfo";
		    
		    if(sPhaseNo == "0130" || sPhaseNo == "0260" ||sPhaseNo == "0220"){
		        var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType2,"","");
				if (typeof(sDocID)=="undefined" || sDocID.length==0 || sDocID!='70')
				{
					alert("基本信息表还未填写，请先填写后再提交！");
					return;
				}
				sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType2+"&DocID="+sDocID,"","");
				if (sReturn == "false")
				{
					alert("基本信息表还未生成，请先生成基本信息表再提交！");
					return;  
				}
		    }
		}
		
		if("<%=CurUser.hasRole("051")%>"=="true"||"<%=CurUser.hasRole("251")%>"=="true"||"<%=CurUser.hasRole("451")%>"=="true")//针对审批岗
		{
			//非兴农,非总行行长
			if("<%=CurOrg.OrgID%>"!="918010100"&&"<%=CurUser.hasRole("010")%>"=="false")
			{
				//进行有权审批判断,如果有权限则增加提示
				sIsAuthFlag = RunMethod("审批流程","是否在审批权限内",sObjectNo+","+sObjectType+","+sUserID+","+sOrgID+","+sFlowNo+","+sSerialNo);
				if(sIsAuthFlag=="TRUE")
				{
					 sReturn = PopPage("/Common/WorkFlow/ButtonDialog3.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				}else{
					sReturn = PopPage("/Common/WorkFlow/ButtonDialog4.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				}
			}
		}
		//弹出审批提交选择窗口,将流程改为一步提交 lpzhang 2009-8-18	
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined") return;
		else if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//提交成功！
			//刷新件数及页面
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}	
		reloadSelf();
	}
		
	//签署意见
	function signCheckOpinion() 
	{
		//获得任务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		//add by hldu
		//个人客户在途业务种类和信用评级类型控制规则
		sApplyType = getItemValue(0,getRow(),"ApplyType");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sCustomerID = RunMethod("BusinessManage","GetCustomerID",sObjectType+","+sObjectNo);			
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
		
		sCompID = "CheckOpinionTab";
		sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
		OpenComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_blank",OpenStyle);
	}
		
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
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
		dReturn = RunMethod("BusinessManage","CheckApplyApprove",sObjectType+","+sObjectNo);
		if(dReturn < 1){
			alert("本笔业务还没有最终审批通过！");
		}
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=申请详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(sObjectType="CreditApproveApply")
		{
			sObjectType="CreditApply";
		}
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sFlowNo=="PutOutFlow" && sPhaseNo != "0035") {
			sParamString += "&ViewID=002"
		}
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
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
		if(!confirm(getBusinessMessage('509'))) return; //您确认要将该申请退回上一环节吗？
		//检查是否签署意见
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) 
		{			
			//退回任务操作   	
			sRetValue = PopPage("/Common/WorkFlow/CancelTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"退回任务操作","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//如果成功，则刷新页面
			if (sRetValue == "Commit")
			{
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			}else{
				alert(sRetValue);
			}
		}else
		{
			alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
			return;
		}
    	
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
	
	/*~[Describe=自动风险探测;InputParam=无;OutPutParam=无;]~*/
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
	
	/*~[Describe=查看调查报告;InputParam=无;OutPutParam=无;]~*/
	function viewReport()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		
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
				alert("调查报告还未生成，请先生成调查报告再查看！")
				return;  
			}
					
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}	
	}
	//add by cdeng  2009-02-17  增加查看流程历史按钮
	function flowHistory()
	{
		 //获取任务流水号
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
        {	
    		alert(getHtmlMessage('1'));//请选择一条信息！
    		return;
		}
		OpenComp("FlowSubList","/Common/WorkFlow/FlowSubList.jsp","PhaseNo="+sPhaseNo+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&ObjectType="+sObjectType,"_blank");
	}
	/*~[Describe=新增审查报告;InputParam=无;OutPutParam=无;]~*/
	function genApproveReport()
	{
		//获得申请类型、申请流水号\
		sObjectType = "";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sDocID = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("是否手工填写审查报告，点击“确定”填写！点击“取消”上传的审查报告！")){
			sCustomerType = RunMethod("BusinessManage","getCustomerType",sObjectNo);
			if("<%=CurOrg.OrgLevel%>" == "3"){
				sObjectType = "CountyApprove";
			}
			else{
				sObjectType = "CityApprove";
			}	
			sSmallCustomerFlag = RunMethod("BusinessManage","GetSmallCustomer",sObjectNo);
			if(sSmallCustomerFlag == "1"){
				sObjectType = "SmallCustomerAP";
			}
			
			sReturn = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if(typeof(sReturn)=="undefined" || sReturn.length==0)
			{
				if("<%=CurOrg.OrgLevel%>" == "3" && sCustomerType == "03" ){
					sDocID = "17";
				}
				else if("<%=CurOrg.OrgLevel%>" == "0" && sCustomerType == "03" ){
					sDocID = "18";
				}
				else if("<%=CurOrg.OrgLevel%>" == "3" ){
					sDocID = "15";
				}
				else {
					sDocID = "16";
				}	
				
				if(sSmallCustomerFlag == "1"){
					sDocID = "19";
				}	
			}else
			{
				sDocID = sReturn;	
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
		else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}	
	}
	/*~[Describe=生成审查报告;InputParam=无;OutPutParam=无;]~*/
	function createReport()
	{
		//获得申请类型、申请流水号、客户编号
		sObjectType = "";
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		sObjectType   = getItemValue(0,getRow(),"ObjectType");
		sCustomerID = RunMethod("BusinessManage","GetCustomerID",sObjectType+","+sObjectNo);
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if("<%=CurOrg.OrgLevel%>" == "3"){
			sObjectType = "CountyApprove";
		}
		else{
			sObjectType = "CityApprove";
		}
		
		sSmallCustomerFlag = RunMethod("BusinessManage","GetSmallCustomer",sObjectNo);
		if(sSmallCustomerFlag == "1"){
			sObjectType = "SmallCustomerAP";
		}
		
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert("审查报告还未填写，请先填写审查报告再查看！");
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
	
	/*~[Describe=查审查报告;InputParam=无;OutPutParam=无;]~*/
	function viewApproveReport()
	{
		//获得申请类型、申请流水号
		sObjectType = "";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if("<%=CurOrg.OrgLevel%>" == "3"){
			sObjectType = "CountyApprove";
		}
		else{
			sObjectType = "CityApprove";
		}		
		
		sSmallCustomerFlag = RunMethod("BusinessManage","GetSmallCustomer",sObjectNo);
		if(sSmallCustomerFlag == "1"){
			sObjectType = "SmallCustomerAP";
		}
				
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert("审查报告还未填写，请先填写审查报告再查看！");//调查报告还未填写，请先填写调查报告再查看！
			return;
		}
		
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
		if (sReturn == "false")
		{
			createReport();
			return;  
		}else
		{
			if(confirm("审查报告有可能更改，是否生成审查报告后再查看！"))
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
	/*~[Describe=信审会委员查看审查报告;InputParam=无;OutPutParam=无;]~*/
	function viewCreateApproveReport()
	{
		sObjectType = "";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sPhaseNo = "<%=sPhaseNo%>";
		sFlowNo = "<%=sFlowNo%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("是否查看系统生成的审查报告，点击“确定”查看！点击“取消”查看上传的审查报告！")){
			if("<%=CurOrg.OrgLevel%>" == "3" || ((sPhaseNo == "0200" && sFlowNo == "IndCreditFlowTJ01" && "<%=sFinishFlag%>" == "N") || (sPhaseNo == "0260" && sFlowNo == "EntCreditFlowTJ01" && "<%=sFinishFlag%>" == "N"))){
				sObjectType = "CountyApprove";
			}
			else{
				sObjectType = "CityApprove";
			}	
			//既有中心支行审查报告又有总行审查报告,弹出选择框,选择类型
			sCheckApproveReportFlag = RunMethod("BusinessManage","CheckExistApproveReport",sObjectNo);
			if(sCheckApproveReportFlag == "1"){//如果即存在中心支行审查报告,又存在总行审查报告
				sNewObjectType =PopPage("/CreditManage/CreditApply/SelectReprotTypeDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
				if(typeof(sNewObjectType)!="undefined" && sNewObjectType.length!=0 && sNewObjectType != '_none_')
				{
					sObjectType=sNewObjectType;
				}
			}
			sSmallCustomerFlag = RunMethod("BusinessManage","GetSmallCustomer",sObjectNo);
			if(sSmallCustomerFlag == "1"){
				sObjectType = "SmallCustomerAP";
			}	
			
			var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			
			if((typeof(sDocID)=="undefined" || sDocID.length==0) && ((sPhaseNo == "0200" && sFlowNo == "IndCreditFlowTJ01" && "<%=sFinishFlag%>" == "N") || (sPhaseNo == "0260" && sFlowNo == "EntCreditFlowTJ01" && "<%=sFinishFlag%>" == "N"))){
				alert("（区县）审查报告还未填写或本笔业务是直属支行发起！");
				return;
			}
			
			if (typeof(sDocID)=="undefined" || sDocID.length==0)
			{
				alert("审查报告还未填写，请先填写审查报告再查看！");//调查报告还未填写，请先填写调查报告再查看！
				return;
			}
			
			sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
			
			if(sReturn == "false" && ((sPhaseNo == "0200" && sFlowNo == "IndCreditFlowTJ01" && "<%=sFinishFlag%>" == "N") || (sPhaseNo == "0260" && sFlowNo == "EntCreditFlowTJ01" && "<%=sFinishFlag%>" == "N"))){
				alert("（区县）审查报告还未生成或本笔业务是直属支行发起！");
				return;
			}
			
			if (sReturn == "false")
			{
				alert("审查查报告还未生成，请先生成审查报告再查看！")
				return;  
			}
					
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}else{
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}	
	}	

	/*~[Describe=强制收回;InputParam=无;OutPutParam=无;]~*/	
	function enforceTakeBack(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
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
		if(confirm("是否真的需要强制收回本笔业务，强制收回会导致以后阶段的意见全部清除，请慎用！")){
			sReturn = RunMethod("BusinessManage","EnforceTakeBackBusiness",sObjectType+","+sObjectNo+","+sPhaseNo+","+sOrgID+","+sSerialNo);	
			alert(sReturn);
			reloadSelf();
		}
	}
	
	/*~[Describe=获取上级审批人员;InputParam=无;OutPutParam=无;]~*/	
	function getNextExaminer(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		sReturn = RunMethod("BusinessManage","getNextExaminer",sSerialNo);	
		alert("上级审查人员是："+sReturn);	
	}	
	
	/*~[Describe=查看最终审批意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewLaskOpinion()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("ViewLaskOpinion","/Common/WorkFlow/ViewLaskOpinion.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function doApproveSubmit()
	{
		//获得申请类型、申请流水号、阶段编号、流程编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		
		//获得任务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("该业务这阶段审批已经提交，不能再次提交！");//该业务这阶段审批已经提交，不能再次提交！
			reloadSelf();
			return;
		}

		//弹出审批提交选择窗口,将流程改为一步提交 lpzhang 2009-8-18	
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined") return;
		else if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//提交成功！
			//刷新件数及页面
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}	
		reloadSelf();
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
		
		sReturn = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if(typeof(sReturn)!="undefined" && sReturn.length!=0)
		{
		    sReturn = PopPage("/Common/WorkFlow/ButtonDialog2.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		    if(typeof(sReturn)=="undefined"  || sReturn.length==0 )
			{
				return;
			}else if (sReturn == "_CONFIRM_") 
			{
				PopPage("/FormatDoc/DeleteReportAction.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			}
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
	
	
		
	/*~[Describe=填写授信业务批复报告;InputParam=无;OutPutParam=无;]~*/
	function writeApproveApproval()
	{	
	    //获得申请类型、申请流水号
		sObjectType = "ApproveApproval";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+","+sObjectType);
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || sSerialNo == "Null")
		{
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sObjectNo+"&InspectType=060","","");
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
			alert("还未填写批复报告!");
			return;
		}else{
			var sCompID = "PurposeInspectTab";
			var sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			var sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		return true;
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
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
