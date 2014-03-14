<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%
  	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
  %>
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
<%
	/*~END~*/
%>

	


<%
		/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
	%>
	<%
		String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/
%>
	<%@include file="/Common/WorkFlow/TaskList.jsp"%>	
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
	String sSerialNoNew = String.valueOf(new java.util.Date().getTime()); 
    MD5 m = new MD5();
    String sSerialNoNews = m.getMD5ofStr(sSerialNoNew);
%>

<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
<script language=javascript>

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
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
			return;
		}
		
		//弹出审批提交选择窗口		
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
		}else
		{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success")
			{
				alert(getHtmlMessage('18'));//提交成功！
				//刷新件数及页面
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			}else if (sPhaseInfo == "Failure")
			{
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
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
		//检查抵质押物的入库情况   add ymwu 2010-02-29 
		//有无未入库抵质押物01、有02、无
		var sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		var value=popComp("PawnList1","/CreditManage/CreditPutOut/PawnList1.jsp","ContractSerialNo="+sContractSerialNo,"null","dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var value=popComp("PawnList1","/CreditManage/CreditPutOut/PawnList1.jsp","ContractSerialNo="+sContractSerialNo,"null","dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//处理方式：01、不在库禁止提交02、不在库只做提示（系统管理员可以在："系统管理---基础配置---代码管理---代码目录--A.管理控制--管理--代码列表---详情---项目号" 进行维护）
		var sColName = "ItemNo";
		var sTableName = "CODE_LIBRARY";
		var sWhereClause = "String@CodeNo@CheckArchive";
		var sReturn = RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('@');
			if(typeof(value)==="undefined"&&"01"===sReturn[1]){
				return;
			}
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
		if(!confirm(getBusinessMessage('496'))) return; //您确认要将该出账申请退回上一环节吗？
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
	
	/*~[Describe=打印出账通知书;InputParam=无;OutPutParam=无;]~*/
	function print(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}	
		//检查出账通知单是否已经生成
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false") //未生成出账通知单
		{
			//生成出账通知单	
			PopPage("/FormatDoc/PutOut/"+sExchangeType+".jsp?DocID="+sExchangeType+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//获得加密后的出账流水号
		sEncryptSerialNo = PopPage("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo+"&rand="+randomNumber(),"myprint10","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		//打开出账通知单
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank",OpenStyle);
	}

	//add by ymwu 20130424 影像扫面
	function scanImage(){  
		sSerialNO = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sSerialNO)=="undefined"||sSerialNO.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
			}
		//通过放款流水号获取合同号
		var sContractSerialNo =RunMethod("PublicMethod","ExecuteSql","select contractserialno from business_putout where serialno='"+sSerialNO+"' ");
		var sRight = PopPage("/PublicInfo/ImageAuthorityCheck.jsp","","");
		if(sRight=="null" || typeof(sRight)== "undefined" ||sRight.length ==0){
			alert("对不起，您没有影像权限！");
			return;
			}
		sPutOutNo = getItemValue(0,getRow(),"SerialNo");
		parameter = "Action=Scan&PhaseType=PutOutApprove&SerialNo="+sContractSerialNo+"&Right="+sRight+"&PhaseNo="+"<%=sPhaseType%>"+"&PutoutNo="+sPutOutNo;
		PopComp("ImageAction","/PublicInfo/ImageAction.jsp",parameter,"","");
		}

	//add by ymwu 20130424 影像查询
	function queryImage(){
		sSerialNO = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sSerialNO)=="undefined"||sSerialNO.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
			}
		//通过放款流水号获取合同号
		var sContractSerialNo =RunMethod("PublicMethod","ExecuteSql","select contractserialno from business_putout where serialno='"+sSerialNO+"' ");
		//在这里传入权限参数是为了提高用户体验
		var sRight = PopPage("/PublicInfo/ImageAuthorityCheck.jsp","","");
		if(sRight=="null" ||sRight.length ==0){
			alert("对不起，您没有影像权限！");
			return;
			}
	     parameter = "Action=Query&PhaseType=BusinessPutOut&SerialNo="+sContractSerialNo+"&Right="+sRight ;
	     PopComp("ImageAction","/PublicInfo/ImageAction.jsp",parameter,"","");
		}
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
	my_load(2,0,"myiframe0");
	hideFilterArea();
</script>
<%
	/*~END~*/
%>




<%@ include file="/IncludeEnd.jsp"%>
