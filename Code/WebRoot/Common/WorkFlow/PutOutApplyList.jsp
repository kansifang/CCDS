<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: 该页面主要处理放贷申请
	Input Param:
	Output param:
	History Log: 
		zywei 2005/07/27 重检页面 
		zywei 2007/10/10 修改取消出帐的提示语
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	/*~[Describe=新增放贷申请;InputParam=无;OutPutParam=无;]~*/
	function newApply()
	{
		//设置合同对象
		sObjectType = "BusinessContract";		
		//待出帐的合同信息
		sParaString = "ManageUserID"+","+"<%=CurUser.UserID%>"+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
		sReturn = setObjectValue("SelectContractOfPutOut",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		//合同流水号
		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sBusinessType = sReturn[1];
		sSurplusPutOutSum = RunMethod("BusinessManage","GetPutOutSum",sObjectNo);
		if(parseFloat(sSurplusPutOutSum) <= 0) //如果合同没有可用金额，则终止出帐申请
		{	
			alert(getBusinessMessage('573'));//此业务合同已没有可用金额，不能进行放贷申请！
			return;
		}
		//当业务品种为贴现业务时，需要检验是否有票据。
		if(sBusinessType =="1020010" || sBusinessType == "1020020" || sBusinessType == "1020030")
		{
			sReturn = RunMethod("BusinessManage","CheckBillInfo",sObjectNo+","+sBusinessType);
			if(sReturn == "00")
			{
				alert("没有录入相关的票据信息，请录入后再进行出账申请！");
				return;
			}
		}
		
		//进行风险智能探测
		sReturn=RunMethod("BusinessManage","CheckContractRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
			return;  //该“return”是否有效视具体业务需求而定
		}
		
		//如果贴现业务需要单张票出帐时，请项目组自行编写选择票据的列表，将所选择的汇票编号赋给sBillNo
		//产品原型中是将该贴现合同项下的票据一次性出帐
		var sBillNo="";
				
		//初始化放贷申请,返回出帐流水号
		sReturn = RunMethod("WorkFlowEngine","InitializePutOut","<%=sObjectType%>,"+sObjectNo+","+sBusinessType+","+sBillNo+",<%=CurUser.UserID%>,<%=sApplyType%>,<%=sInitFlowNo%>,<%=sInitPhaseNo%>,<%=CurUser.OrgID%>");
		if(typeof(sReturn) == "undefined" || sReturn == "") return;
 		//根据业务品种、期限、担保方式获得科目号
 		RunMethod("BusinessManage","GetSubjectByBusinessType",sReturn);
 		//根据合同号取得申请号
 		var shenqinghao = "";
 		shenqinghao = RunMethod("BusinessManage","GetShenqinghaoByHetonghao",sObjectNo);
 		//根据申请号获取放款中心机构编号
 		var LoanOrgID = "";
 		LoanOrgID = RunMethod("BusinessManage","GetLoanOrgID",shenqinghao);
 		//更新放款中心机构编号
 		RunMethod("PublicMethod","UpdateColValue","String@LoanOrgID@"+LoanOrgID+",BUSINESS_PUTOUT,String@serialno@"+sReturn);
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=PutOutApply&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function cancelApply()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sSendFlag = getItemValue(0,getRow(),"SendFlag");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
				
		if(confirm(getHtmlMessage('70')))//您真的想取消该信息吗？
		{
			if(sSendFlag == "1"){
				//部分个贷业务发个贷系统取消 add by zrli 
				if(sBusinessType=='1110010' || sBusinessType=='1110020' || sBusinessType=='1140060'
				 || sBusinessType=='1140010' || sBusinessType=='1140020' || sBusinessType=='1140110' 
				 || sBusinessType=='1110027'|| sBusinessType=='1140025' || sBusinessType == '1110025'){
				 	sTradeType = "6009";
				 	sObjectType = sContractSerialNo;//传入合同号，更新合同归档日期
					sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
					sReturn=sReturn.split("@");
					if(sReturn[0] != "0000000"){
						alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
						return;
					}else{
						alert("个贷取消成功！");
					}
				}else{
					//展期交易有单独交易 added by zrli
					if(sExchangeType == '6201'){
						sTradeType = "798007";
						sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
						sReturn=sReturn.split("@");
						if(sReturn[0] != "0000000"){
							alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
							return;
						}else{
							alert("展期发送核心成功！"+sReturn[1]);
						}
						return;
					}else{
						sTradeType = "798003";
						sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
						sReturn=sReturn.split("@");
						if(sReturn[0] != "0000000"){
							alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
							return;
						}else{
							alert("删除核心成功！");
						}
					}
				}
			}
			//合同取消归档
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@PigeonholeDate@None,BUSINESS_CONTRACT,String@SerialNo@"+sContractSerialNo);
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句			
		}
	}

	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
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
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sPhaseNo != "0010" && sPhaseNo != "3000") {
			sParamString += "&ViewID=002"
		}
		
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()
	{
		//获得出帐类型、出帐流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo"); 
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sERateDate = getItemValue(0,getRow(),"ERateDate");
		var sChangType = "";
		sChangType	= getItemValue(0,getRow(),"ChangType");    //变更类型

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		//测试用程序段，上线前删除 add by zrli
		/*
		var sReturn1 = RunMethod("WorkFlowEngine","GetAfaloanFlag1",sObjectNo);
		if(sReturn1 == "1")
		{
			sTradeType = "6023";
		}else
		{
			sTradeType = "6001";
		}
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else{
			alert("发送个贷成功！"+sReturn[1]);
			//print();
			//reloadSelf();
		}
		return;
		
		//测试程序结束
		*/
		
		
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert("该放贷申请已经提交了，不能再次提交！");//该放贷申请已经提交了，不能再次提交！
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
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
			return;
		}
		
		//判断保证金是否足额
		dBCBailRatio = getItemValue(0,getRow(),"BailRatio");//保证金比例
		dBPBailRatio = getItemValue(0,getRow(),"BPBailRatio");//出账保证金比例
        if(parseFloat(dBCBailRatio)>0 && (parseFloat(dBPBailRatio) < parseFloat(dBCBailRatio)))
        {  			
		    alert("保证金不足额");
		    return ;			
		}
	
		//公积金出账查询
		//sReturn1 = RunMethod("WorkFlowEngine","GetAfaloanFlag3",sObjectNo);
		if(sBusinessType == "1110027")
		{
			if(sChangType != "")
			{
				sTradeType = "6032";
				sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+" "+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
					alert("与个贷系统连接错误，该笔贷款不能出账！");
					return;
				}else
				{
					if(sReturn[4] == "0")
					{
						alert("个贷公积金系统审批未决");
						return;
					}else if(sReturn[4] == "1")
					{
						alert("个贷公积金系统否决");
						return;
					}else if(sReturn[4] == "2")
					{
							alert("个贷公积金系统可审核");
					}else if(sReturn[4] == "3")
					{
							alert("个贷公积金系统已审核");
					}
				}
			
			}else
			{
				sTradeType = "6022";
				sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+" "+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
					alert("与个贷系统连接错误，该笔贷款不能出账！");
					return;
				}else
				{
					if(sReturn[3] == "0")
					{
						alert("个贷公积金系统未决出账");
						return;
					}else if(sReturn[3] == "1")
					{
						alert("个贷公积金系统否决出账");
						return;
					}else
					{
						if(sReturn[2] == "0")
						{
							alert("该笔贷款信贷出账金额与个贷公积金系统出账金额不一致！");
							return;
						}
					}
				}
			}
		}
		
		//进行业务提示(只提示不控制)
		sReturn=RunMethod("BusinessManage","CheckBusinessRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/ShowRiskView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
		}
		
		//进行暂存状态检查与控制规则
		sReturn=RunMethod("BusinessManage","CheckSaveFlag",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			alert(sReturn);
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
	
	//签署意见
	function signOpinion()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		sTempSaveFlag = getItemValue(0,getRow(),"TempSaveFlag");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sTempSaveFlag !="2"){
			alert("放款申请信息没有填写完整或处于暂存状态，不能签署意见！");
			return;
		}

		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		sCompID = "SignTaskOpinion";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得出帐类型、出帐流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}

	/*~[Describe=归档;InputParam=无;OutPutParam=无;]~*/
	function archive(){
		//获得出帐类型、出帐流水号
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
			sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",BUSINESS_PUTOUT");
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
	function cancelarch(){
		//获得出帐类型、出帐流水号
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
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BUSINESS_PUTOUT");
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
	
	/*~[Describe=发送;InputParam=无;OutPutParam=无;]~*/
	function send(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");

		//部分个贷不发送核心直接打印出账通知书 add by zrli 
		if(sBusinessType=='1110010' || sBusinessType=='1110020' || sBusinessType=='1110030' || sBusinessType=='1110040'
		 || sBusinessType=='1140010' || sBusinessType=='1140020'|| sBusinessType=='1140025' 
				 || sBusinessType == '1110025'){
			print();
			return;
		}
		//国际业务、承兑、贴现、保函不发送核心直接打印出账通知书 add by zrli 
		if(sBusinessType.substring(0,4)=='2050' || sBusinessType.substring(0,4)=='1080' || 
		sBusinessType == '2010' || sBusinessType.substring(0,4)=='1020' || 
		sBusinessType.substring(0,4)=='2030' || sBusinessType.substring(0,4)=='2040'){
			print();
			return;
		}
		
		//先进行核心客户信息交互 add by zrli 
		sTradeType = "798001";
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}
		//再发送出账信息 add by zrli 
		sTradeType = "798002";
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else{
			alert("发送核心成功！");
			print();
			reloadSelf();
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