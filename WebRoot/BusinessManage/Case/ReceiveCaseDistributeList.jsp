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
	<%@include file="/Common/BusinessFlow/Receive/ReceiveList.jsp"%>	
<%
		/*~END~*/
	%>
<%
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","150");
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
		sReturn = PopPage("/Common/BusinessFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
			return;
		}
		
		//弹出审批提交选择窗口		
		sPhaseInfo = PopPage("/Common/BusinessFlow/SubmitDialog.jsp?SerialNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined") return;
		else if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//提交成功！
			//刷新件数及页面
			OpenComp("ReceiveMain","/Common/BusinessFlow/Receive/ReceiveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ReceiveType=<%=sReceiveType%>","_top","");
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else
		{
			sPhaseInfo = PopPage("/Common/BusinessFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success")
			{
				alert(getHtmlMessage('18'));//提交成功！
				//刷新件数及页面
				OpenComp("ReceiveMain","/Common/BusinessFlow/Receive/ReceiveMain.jsp","ComponentName=授信业务审批&ComponentType=MainWindow&ReceiveType=<%=sReceiveType%>","_top","");
			}else if (sPhaseInfo == "Failure")
			{
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}
	}
	
    
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function signCheckOpinion()
	{
		//获得任务流水号、对象类型、对象编号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		//签署对应的意见
		sCompID = "SignOpinionInfo";
		sCompURL = "/Common/BusinessFlow/SignOpinionInfo.jsp";
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
		popComp("ViewFlowOpinions","/Common/BusinessFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/
	function viewDetail()
	{
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
        	alert("请选择一条记录！");
			return;
    	}
    	else{
    		popComp("CaseInfo","/BusinessManage/CaseInfo.jsp","SerialNo="+sSerialNo,"");
    		reloadSelf();
		}
	}
	//Doubleclick a certain item of list, calling this event.
	function onDBLClick(){
		viewDetail();
    }	
	/*~[Describe=任务收回;InputParam=无;OutPutParam=无;]~*/
	function takeBack()
	{
		//获取任务流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined"||sSerialNo.length == 0 )
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//收回任务操作
		sRetValue = PopPage("/Common/BusinessFlow/TakeBackTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"收回任务操作","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		//如果成功，则刷新页面
		if (sRetValue == "Commit")
		{
		    OpenComp("ReceiveMain","/Common/BusinessFlow/ReceiveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ReceiveType=<%=sReceiveType%>","_top","")
		}		
	}
	
	/*~[Describe=退回前一步;InputParam=无;OutPutParam=无;]~*/
	function backStep()
	{		
		//获取任务流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length ==0){	
    		alert(getHtmlMessage('1'));//请选择一条信息！
    		return;
		}
		if(!confirm(getBusinessMessage('496'))) return; //您确认要将该出账申请退回上一环节吗？
		//检查是否签署意见
		sReturn = PopPage("/Common/BusinessFlow/CheckOpinionAction.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) 
		{
			//退回任务操作   	
			sRetValue = PopPage("/Common/BusinessFlow/CancelTaskAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&rand="+randomNumber(),"退回任务操作","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//如果成功，则刷新页面
			if (sRetValue == "Commit")
			{
				alert("退回成功！");
				OpenComp("ReceiveMain","/Common/BusinessFlow/Receive/ReceiveMain.jsp","ComponentName=审查审批管理&ComponentType=MainWindow&ReceiveType=<%=sReceiveType%>","_top","")
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
	function mySelectRow()
	{
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");
		if("<%=sPhaseNo%>"!=="0015"){
			document.getElementById("ListHorizontalBar").parentNode.style.display="";
			document.getElementById("ListDetailAreaTD").parentNode.style.display="";
			OpenComp("ActionList","/BusinessManage/Action/ActionList.jsp","SerialNo="+sSerialNo,"DetailFrame","");
		}else{
			document.getElementById("ListHorizontalBar").parentNode.style.display="none";
			document.getElementById("ListDetailAreaTD").parentNode.style.display="none";
		}
	}
</script>
<script  language=javascript>
	/*~[Describe=上传附件;InputParam=1导入2更新;OutPutParam=无;]~*/
	function uploadDoc(){
		var sObjectType="Case";
		var sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		var sDocAttribute="03";
		var sDocTitle="";
		if(typeof(sObjectNo)=="undefined"||sObjectNo.length==0){
	    	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		var sDocNo=RunMethod("PublicMethod","GetColValue","Doc_Library.DocNo,Doc_Relative@Doc_Library,None@Doc_Relative.DocNo@Doc_Library.DocNo@String@ObjectType@"+sObjectType+"@String@ObjectNo@"+sObjectNo+"@String@DocAttribute@"+sDocAttribute);
		if(sDocNo.length==0){
			sDocNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=Doc_Library&ColumnName=DocNo&Prefix=","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			RunMethod("PublicMethod","InsertColValue","String@DocNo@"+sDocNo+"@String@ObjectType@"+sObjectType+"@String@ObjectNo@"+sObjectNo+",Doc_Relative");
			RunMethod("PublicMethod","InsertColValue","String@DocNo@"+sDocNo+"@String@DocTitle@"+sDocTitle+"_默认文件夹_<%=StringFunction.getNow()%>@String@DocAttribute@"+sDocAttribute+"@String@OrgID@<%=CurUser.OrgID%>@String@UserID@<%=CurUser.UserID%>@String@InputOrg@<%=CurUser.OrgID%>@String@InputUser@<%=CurUser.UserID%>@String@InputTime@<%=StringFunction.getToday()%>,Doc_Library");
		}else{
			sDocNo=sDocNo.split("@")[1];
		}
		popComp("FileChooseDialog","/Common/Document/FileChooseDialog.jsp","DocNo="+sDocNo+"&Message=上传成功","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf(); 
	}
	/*~[Describe=查看附件;InputParam=无;OutPutParam=无;]~*/
	function viewDoc(){
		var sObjectType="Case";
		var sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
	    	alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			sReturn=popComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	        reloadSelf(); 
	    }
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
	bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,"myiframe0");
	mySelectRow();
	hideFilterArea();
</script>
<%
	/*~END~*/
%>




<%@ include file="/IncludeEnd.jsp"%>
