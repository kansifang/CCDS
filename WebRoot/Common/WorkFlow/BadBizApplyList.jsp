<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:    xhyong 2009/09/04 
		Tester:	
		Content:   不良业务申请列表
		Input Param:
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良业务申请列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
		sCompID = "BadBizApplyCreationInfo";
		sCompURL = "/RecoveryManage/NPAManage/NPAApplyManage/BadBizApplyCreationInfo.jsp";			
		sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo,"dialogWidth=25;dialogHeight=15;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sObjectNo=sReturn[0];
		sApplyType=sReturn[1];
		sParaString = "RecoveryOrgID,<%=CurOrg.OrgID%>,RecoveryUserID,<%=CurUser.UserID%>";
		
		/*
		if(sApplyType == "020")//抵债资产处置
		{	
			sParaString = "ManageOrgID,<%=CurOrg.OrgID%>,ManageUserID,<%=CurUser.UserID%>,AssetFlag,020";
			//抵债资产列表
			sReturnValue=setObjectValue("SelectDebtAsset",sParaString,"",0,0,"");
			if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
			{
				sReturnValue = sReturnValue.split("@");
				sRelativeSerialNo=sReturnValue[0];
				//更新抵债资产处置中关联抵债资产
				var sPara="String@RelativeSerialNo@"+sRelativeSerialNo+
						  ",BADBIZ_APPLY,String@SerialNo@"+sObjectNo;
				sReturnValue = RunMethod("PublicMethod","UpdateColValue",sPara);
			}else
			{
				sReturn=RunMethod("WorkFlowEngine","DeleteBadBizTask","BadBizApply,"+sObjectNo+",DeleteTask");	
				return;
			}
		}else if(sApplyType == "025")//抵债资产处置损失核销
		{	
			sParaString = "ManageOrgID,<%=CurOrg.OrgID%>,ManageUserID,<%=CurUser.UserID%>,AssetFlag,020";
			//抵债资产列表
			sReturnValue=setObjectValue("SelectDebtAsset",sParaString,"",0,0,"");
			if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
			{
					sReturnValue = sReturnValue.split("@");
				sRelativeSerialNo=sReturnValue[0];
				//更新抵债资产处置中关联抵债资产
				var sPara="String@RelativeSerialNo@"+sRelativeSerialNo+
						  ",BADBIZ_APPLY,String@SerialNo@"+sObjectNo;
				sReturnValue = RunMethod("PublicMethod","UpdateColValue",sPara);
			}else
			{
				sReturn=RunMethod("WorkFlowEngine","DeleteBadBizTask","BadBizApply,"+sObjectNo+",DeleteTask");	
				return;
			}
		}else if(sApplyType == "030")//核销
		{
			sReturnValue=setObjectValue("SelectBadContract",sParaString,"",0,0,"");
			if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
			{	
				sReturnValue = sReturnValue.split("@");
				var sContractSerialNo = sReturnValue[0];
				var sCustomerID = sReturnValue[1];
				var sBusinessType = sReturnValue[6];
				var sBusinessCurrency = sReturnValue[5];
				var sBalance = sReturnValue[3];
				var sInterestBalance1 = sReturnValue[7];
				var sInterestBalance2 = sReturnValue[8];
				var sClassifyResult = sReturnValue[9];
				//更新核销申请中相关合同信息
				var sPara="String@ContractSerialNo@"+sContractSerialNo+
						  "@String@CustomerID@"+sCustomerID+
						  "@String@BusinessType@"+sBusinessType+
						  "@String@BusinessCurrency@"+sBusinessCurrency+
						  "@String@ClassifyResult@"+sClassifyResult+
						  "@Number@Balance@"+sBalance+
						  "@Number@InterestBalance1@"+sInterestBalance1+
						  "@Number@InterestBalance2@"+sInterestBalance2+
						  ",BADBIZ_APPLY,String@SerialNo@"+sObjectNo;
				sReturnValue = RunMethod("PublicMethod","UpdateColValue",sPara);
			}else
			{
				sReturn=RunMethod("WorkFlowEngine","DeleteBadBizTask","BadBizApply,"+sObjectNo+",DeleteTask");	
				return;
			}
		}else if(sApplyType == "040")//贷款终结
		{	
			//跟新关联合同
			sReturnValue=setObjectValue("SelectFinishContract",sParaString,"",0,0,"");
			if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
			{
				sReturnValue = sReturnValue.split("@");
				sContractSerialNO=sReturnValue[0];
				sReturn = RunMethod("BusinessManage","InsertRelative",sObjectNo+",FinishContract,"+sContractSerialNO+",BADBIZ_RELATIVE");
			}else
			{
				sReturn=RunMethod("WorkFlowEngine","DeleteBadBizTask","BadBizApply,"+sObjectNo+",DeleteTask");	
				return;
			}
		}else if(sApplyType == "050")//诉讼案件
		{
			//弹出新增申请参数对话框
			sCompID = "BadBizLawCaseCreationInfo";
			sCompURL = "/RecoveryManage/NPAManage/NPAApplyManage/BadBizLawCaseCreationInfo.jsp";			
			sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=25;dialogHeight=15;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_")
			{
				sReturn=RunMethod("WorkFlowEngine","DeleteBadBizTask","BadBizApply,"+sObjectNo+",DeleteTask");	
				return;
			}
		}
		*/
        //根据新增申请的流水号，打开申请详情界面
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();		
	}
	
	/*~[Describe=删除不良业务申请记录;InputParam=无;OutPutParam=无;]~*/
	function cancelApply()
	{
		//获得类型、流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			var sReturn = RunMethod("WorkFlowEngine","DeleteBadBizTask",sObjectType+","+sSerialNo+",DeleteTask");
			if (typeof(sReturn) != "undefined" && sReturn.length>=0)
			{
				alert("删除成功！");
			}	
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
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
		
		/*
		//检查是否签署意见
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert("该业务未提交意见,不能提交,请先提交意见！");
			return;
		}
		*/
		
		//进行业务提交规则检测 
		sReturn=RunMethod("BusinessManage","CheckBadBizApplyRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
			return;
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
		sCompID = "SignBadBizOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignBadBizOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApplyType="+sApplyType,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
		popComp("ViewBadBizOpinions","/Common/WorkFlow/ViewBadBizOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@PigeonholeDate@<%=StringFunction.getToday()%>,BADBIZ_APPLY,String@SerialNo@"+sObjectNo);
			if(sReturnValue == "TRUE")//刷新页面
			{
				reloadSelf();	
				alert(getHtmlMessage('57'));//归档成功！
			}else
			{
				alert(getHtmlMessage('60'));//归档失败！
				return;			
			}		
		}
	}

	/*~[Describe=取消归档;InputParam=无;OutPutParam=无;]~*/
	function cancelArch()
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
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BADBIZ_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//取消归档失败！
				return;
			}else
			{
				alert(getHtmlMessage('59'));//取消归档成功！
				reloadSelf();
			}
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
	
	/*~[Describe=入账处理;InputParam=无;OutPutParam=无;]~*/
	function enterAccount()
	{
		alert("此功能正在完善中......");
	}
	
	/*~[Describe=打印通知书;InputParam=无;OutPutParam=无;]~*/
	function myPrint()
	{
		alert("此功能正在完善中......");
	}
	
	/*~[Describe=转为无法执行的申请;InputParam=无;OutPutParam=无;]~*/
	function UnableExcute()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("您真的想要将该信息转为无法执行申请!")) 
		{
			//取消归档操作
			sReturn=RunMethod("BusinessManage","UnableExcuteBusiness",sObjectNo+",BADBIZ_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert("转为无法执行申请失败");
				return;
			}else
			{
				alert("转为无法执行申请成功");
				reloadSelf();
			}
		}
	}
	
	/*~[Describe=转为执行;InputParam=无;OutPutParam=无;]~*/
	function doExcute()
	{
		//获得申请类型、申请流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("您确定转执行操作!")) //您真的想将该信息归档取消吗？
		{
			//取消归档操作
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@UnableExcute@None,BADBIZ_APPLY,String@SerialNo@"+sObjectNo);
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert("操作失败!");
				return;
			}else
			{
				alert("操作成功!");
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
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
    var bHighlightFirst = true;//自动选中第一条记录
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
