<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: 审批任务列表
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
	<%@include file="/Common/WorkFlow/GuarantyTaskList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%     
    String sSerialNoNew = String.valueOf(new java.util.Date().getTime()); 
    MD5 m = new MD5();
    String sSerialNoNews = m.getMD5ofStr(sSerialNoNew);
    
%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>
	//抵质押物详情
	function GuarantyDetail()
	{
		var sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		var sPawnType = getItemValue(0,getRow(),"GUARANTYTYPE");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			//当对象是抵押
			if(sPawnType.substring(0,2)=="01")
				{
					popComp("ViewPawnInfo","/CreditManage/GuarantyManage/ViewPawnInfo.jsp","GuarantyStatus=02&GuarantyID="+sGuarantyID+"&PawnType="+sPawnType);
				}
			//当对象是质押	
			else if(sPawnType.substring(0,2)=="02")
				{
					popComp("ViewImpawnInfo","/CreditManage/GuarantyManage/ViewImpawnInfo.jsp","GuarantyStatus=02&GuarantyID="+sGuarantyID+"&ImpawnType="+sPawnType);
				}
		}
	}
	
	/*~[Describe=查看担保合同信息;InputParam=无;OutPutParam=无;]~*/
	function viewGuarantyContract()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			popComp("GuarantyContractList","/CreditManage/GuarantyManage/GuarantyContractList.jsp","GuarantyID="+sGuarantyID);
		}
	}
	/*~[Describe=查看业务合同信息;InputParam=无;OutPutParam=无;]~*/
	function contractDetail()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			popComp("BusinessContractList","/CreditManage/GuarantyManage/BusinessContractList.jsp","GuarantyID="+sGuarantyID);
		}
	}

	/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		doSubmitIn(sObjectType,sObjectNo,sBusinessType,sFlowNo,sPhaseNo);
	}

	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function doSubmitIn()
	{
		//获得对象类型、对象编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sConsultNo = getItemValue(0,getRow(),"ConsultNo");
		
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
		if(!((sFlowNo == "GuarantyOutFlow" && sPhaseNo == "0017" ))
		 ){
				sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
				if(typeof(sReturn)=="undefined" || sReturn.length==0) {
					alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
					return;
				}
		 }
		//弹出审批提交选择窗口	
		//提交时检查是否已获取业务参考号	
		if(sFlowNo == "EntPutOutFlow" && sPhaseNo == "0012" &&(sBusinessType.substring(0,4)=='1080' || sBusinessType.substring(0,4)=='2050'))
		{
			if (typeof(sConsultNo)=="undefined" || sConsultNo.length==0)
			{
				alert("国结业务，未获取业务参考号！");
			}
		}
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//如果提交成功，则刷新页面
		if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//提交成功！
			//RunMethod("BusinessManage","UpdateGuaranty_Apply",sSerialNo+","+sUserID+","+sOrgID+","+sInputDate);
			//刷新件数及页面
			//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			reloadSelf();
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}
		
	}
	
    
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function signOpinion()
	{
		//获得任务流水号、对象类型、对象编号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		//签署对应的意见
		sCompID = "SignTaskOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
		
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");

		popComp("ViewLaskOpinion","/Common/WorkFlow/ViewLaskOpinion.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	/*~[Describe=申请详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
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
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sFlowNo=="PutOutFlow" && sPhaseNo != "0035") {
			sParamString += "&ViewID=002"
		}
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
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
		if(!confirm(getBusinessMessage('496'))) return; //您确认要将该出帐申请退回上一环节吗？
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
			}
		}else
		{
			alert(getBusinessMessage('510'));//该业务已签署了意见，不能再退回前一步！
			return;
		}    	
	}
	
	/*~[Describe=打印出帐通知书;InputParam=无;OutPutParam=无;]~*/
	function print(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		//检查出帐通知单是否已经生成
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false") //未生成出帐通知单
		{
			//生成出帐通知单	
			PopPage("/FormatDoc/PutOut/"+sExchangeType+".jsp?DocID="+sExchangeType+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//获得加密后的出帐流水号
		sEncryptSerialNo = PopPage("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo+"&rand="+randomNumber(),"myprint10","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//通过　serverlet 打开页面
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
	}
	
	function viewBusiness(){
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	   	PopComp("CustomerBusiness","/CreditManage/CreditPutOut/CustomerBusinessList.jsp","CustomeID="+sCustomerID,"");
	   	reloadSelf();
	}
	
	/*~[Describe=出库发送;InputParam=无;OutPutParam=无;]~*/
	function sendOut()
	{
		//获得抵质押物编号
        sGuarantyID = getItemValue(0,getRow(),"GuarantyID");	
        sTradeType = "777110";	
        sObjectNo = sGuarantyID;
        sObjectType = "GuarantyInfoUnLoad";
        sAPPROVEOPINION = "";        //最终审批意见
        sObjectNo = getItemValue(0,getRow(),"ObjectNo"); //出入库申请编号
		if (typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		//判断该笔业务的最终审批意见是否为“批准”
		sReturn = RunMethod("PublicMethod","GetColValue","APPROVEOPINION,GUARANTY_APPLY,String@SerialNo@"+sObjectNo);
		if (typeof(sReturn)!="undefined" && sReturn.length!=0) 
		{
			sReturn=sReturn.split("@");
			sAPPROVEOPINION = sReturn[1]
			if(sAPPROVEOPINION!="批准")
			{
				alert("该笔业务未被批准");
				return;
			}	
		}
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else{
			alert("出库成功["+sReturn[1]+"]");
			//该笔抵质押物的发送状态置为“02出库发送”
			RunMethod("PublicMethod","UpdateColValue","String@GISendFlag@02,GUARANTY_INFO,String@GUARANTYID@"+sGuarantyID);
			PopComp("LoadPawnSheet","/CreditManage/GuarantyManage/LoadPawnSheet1.jsp","GuarantyID="+sGuarantyID+"&Churuku=出库","dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
		}
	}	
	
	/*~[Describe=信审会委员查看审查报告;InputParam=无;OutPutParam=无;]~*/
	function viewCreateApproveReport()
	{
		sObjectType = "";
		var sObjectNo1 = getItemValue(0,getRow(),"ObjectNo");
		var sCreditAggreement = getItemValue(0,getRow(),"CreditAggreement");//额度协议号
		if (typeof(sObjectNo1)=="undefined" || sObjectNo1.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (typeof(sCreditAggreement)!="undefined" && sCreditAggreement.length!=0)
		{
			//额度申请流水号
			sReturn=RunMethod("PublicMethod","GetColValue","relativeserialno,business_Contract,String@SerialNo@"+sCreditAggreement);
			sReturnValue =sReturn.split("@")
			sObjectNo =sReturnValue[1];
		}else{
			sObjectNo = RunMethod("WorkFlowEngine","GetApplyNo",sObjectNo1);
		}
		sOrgFlagValue = RunMethod("PublicMethod","GetColValue","OrgFlag,BUSINESS_APPLY,String@SerialNo@"+sObjectNo);
		sOrgFlag=sOrgFlagValue.split("@")
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sPhaseNo = "<%=sPhaseNo%>";
		sFlowNo = "<%=sFlowNo%>";
		/*
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		*/
		if(confirm("是否查看系统生成的审查报告，点击“确定”查看！点击“取消”查看上传的审查报告！")){
			if(sOrgFlag[1]=="0"){
				sObjectType = "CityApprove";
			}else{
				sObjectType = "CountyApprove";
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
			PopComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=CreditApply&ObjectNo="+sObjectNo);
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
	/*~[Describe=查看授信业务批复报告;InputParam=无;OutPutParam=无;]~*/
	function viewApproveApproval()
	{	
	    //获得申请类型、申请流水号
		var sObjectType = "ApproveApproval";
		var sObjectNo1 = getItemValue(0,getRow(),"ObjectNo");
		var sCreditAggreement = getItemValue(0,getRow(),"CreditAggreement");//额度协议号
		if (typeof(sObjectNo1)=="undefined" || sObjectNo1.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (typeof(sCreditAggreement)!="undefined" && sCreditAggreement.length!=0)
		{
			//额度申请流水号
			sReturn=RunMethod("PublicMethod","GetColValue","relativeserialno,business_Contract,String@SerialNo@"+sCreditAggreement);
			sReturnValue =sReturn.split("@")
			sObjectNo =sReturnValue[1];
		}else{
			sObjectNo = RunMethod("WorkFlowEngine","GetApplyNo",sObjectNo1);
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
	/*~[Describe=获取业务参考号;InputParam=无;OutPutParam=无;]~*/
	function viewBusinessNo()
	{
		
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sConsultNo = getItemValue(0,getRow(),"ConsultNo");
		sTradeType = "ISS000000120";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sBusinessType.substring(0,4)=='1080' || sBusinessType.substring(0,4)=='2050')
		{	
			if((typeof(sConsultNo)=="undefined" || sConsultNo.length==0)||confirm("业务参考号已获取，确定重新获取吗！"))
			{
				sReturn = RunMethod("BusinessManage","SendESBGJ",sObjectNo+","+sObjectType+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("国结系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
					return;
				}else{
					alert("业务参考号获取成功！");
					reloadSelf();
				}
				sParaString = "ObjectNo"+","+sObjectNo;
				sReturn = setObjectValue("selectConsultNo",sParaString,"",0,0,"");
				if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
				var sReturn = sReturn.split("@");
				sConsultNo = sReturn[0];
				sReturn = RunMethod("BusinessManage","ESBUpdate",sConsultNo+","+sObjectNo);// 将选中的客户参考号更新到 BP表
				reloadSelf();
			}
			
		}
	}

</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>

<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,"myiframe0");
	hideFilterArea();
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
