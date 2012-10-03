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
	<%@include file="/Common/WorkFlow/TaskList.jsp"%>	
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
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		
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
		if(!((sFlowNo == "IndPutOutFlow" && sPhaseNo == "0017" ) || 
		   (sFlowNo == "EntPutOutFlow" && sPhaseNo == "0015" ) ||
		   (sFlowNo == "EntPutOutFlow02" && sPhaseNo == "0025" )||
			(sFlowNo == "EntPutOutFlow" && sPhaseNo == "0011" ))
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
		    //发生类型不为展期
			sReturn = RunMethod("PublicMethod","GetColValue","OccurType,BUSINESS_CONTRACT,String@SerialNO@"+sContractSerialNo);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				sReturnValue = sReturn.split('@');
				sOccurType = sReturnValue[1];
			}
			if ((typeof(sConsultNo)=="undefined" || sConsultNo.length==0) && sOccurType != '015')
			{
				alert("国结业务，未获取业务参考号！");
				return;
			}
		}
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
	/*~[Describe=发送会计系统并打印出账通知;InputParam=无;OutPutParam=无;]~*/
	/* 修改 wangdw 2012-08-06 1、调用798002开户、2、调用777100发送入库申请 */
	function send(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sSendFlag = getItemValue(0,getRow(),"SendFlag");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
/*测试用 临时取消 起
		if(sSendFlag=="9")
		{
			alert("该业务已取消,不能发送！");
			return;
		}
		//被批准的业务才能发送核心
		sRetrun = RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sRetrun != "1000")
		{
			alert("该业务还未被批准，不能发送核心！");
			return;
		}
		if(sSendFlag=='1' ||sSendFlag=='2')
		{
			print();
			return;
		}
		//展期交易有单独交易 added by zrli
		sOccurType = "";
		sReturn = RunMethod("PublicMethod","GetColValue","OccurType,BUSINESS_CONTRACT,String@SerialNO@"+sContractSerialNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			sReturnValue = sReturn.split('@');
			sOccurType = sReturnValue[1];
		}
		if(sOccurType == '015'){
			sTradeType = "798005";
			sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
			sReturn=sReturn.split("@");
			if(sReturn[0] != "0000000"){
				alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
				return;
			}else{
				alert("展期发送核心成功！"+sReturn[1]);
				//print();
				//reloadSelf();
			}
			return;
		}
		//部分个贷不发送核心直接打印出账通知书 add by zrli 
		if(sBusinessType=='1110010' || sBusinessType=='1110020' || sBusinessType=='1140060'
		 || sBusinessType=='1140010' || sBusinessType=='1140020' || sBusinessType=='1140110' 
		 || sBusinessType=='1110027'|| sBusinessType=='1140025' || sBusinessType == '1110025'
		 ||sBusinessType == "2110020"||sBusinessType == '1140150'){
		// alert("个贷接口尚未上线，请按原有业务方式办理！");
			 //先进行核心客户信息交互 add by zrli 
			sTradeType = "798001";
			sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
			sReturn=sReturn.split("@");
			if(sReturn[0] != "0000000"){
				alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
				return;
			}
			
			//
			if(sBusinessType == "1110027"||sBusinessType == "2110020")
			{
				//公积金变更
				if(sOccurType == '120')
				{
					sTradeType = "6033";
				}else
				{
					sTradeType = "6023";
				}
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
					if(sTradeType == '6033'){
						alert("发送个贷成功！");
					}else
					{
						alert("发送个贷成功！"+sReturn[1]);
					}
					print();
					reloadSelf();
			}
			
			return;
		}
		//国际业务、承兑、贴现、保函不发送核心直接打印出账通知书 add by zrli   
		if(sBusinessType.substring(0,4)=='2050' || 
		sBusinessType == '2010' || sBusinessType.substring(0,4)=='1020' || 
		sBusinessType.substring(0,4)=='2030' || sBusinessType.substring(0,4)=='2040'){
			//发送国结系统
			if( sBusinessType.substring(0,4)=='2050')
			{  
				 sTradeType = "ISS000000100";
				// sReturn = RunMethod("BusinessManage","ESBGJTrade",sObjectNo+","+sTradeType);
				 sReturn = RunMethod("BusinessManage","SendESBGJ",sObjectNo+","+sObjectType+","+sTradeType);
				 sReturn=sReturn.split("@");
				 if(sReturn[0] == "0000000"){
					alert("发送国结成功！");
					print();
				 }else{
				 	alert("国结系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
					return;
				 }			 
			}
			//合同自动归档
			else
			{
				RunMethod("BusinessManage","UpdatePigeonhole",sContractSerialNo);
				print();
				return;
			}
			//alert("归档成功！");
			reloadSelf();
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
		//再发送开户信息 add by zrli 
		sTradeType = "798002";
		sObjectType = "0";//交易标识 TradeFlag 0 开户 add by wangdw
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else{
			alert("发送核心成功！");
			//调用798002开户成功后设置BUSINESS_PUTOUT.sendflag 置 3 "发送开户成功"
			// add by wangdw 2012-08-09
			RunMethod("PublicMethod","UpdateColValue","String@sendflag@3,BUSINESS_PUTOUT,String@SERIALNO@"+sObjectNo);
			print();
		}
		测试用 临时取消 止*/
		//发送入库信息 add by wangdw
		GuarantyIn(sObjectNo);
		reloadSelf();
	}
	/*~[Describe=放款;InputParam=无;OutPutParam=无;]~*/
	/*~修改 wangdw 2012-08-06 调用798002放款~*/	
	function send1(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sSendFlag = getItemValue(0,getRow(),"SendFlag");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		//只有当sendflag=3发送开户成功的时候，才可以调用798002放款交易 add by wangdw
		if(sSendFlag!="3")
		{
			alert("该业务“发送核心开户”未成功，不能进行“放款”操作");
			return;
		}
		sTradeType = "798002";
		sObjectType = "1";//交易标识 TradeFlag 1 放款 add by wangdw
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else{
			alert("发送核心成功！");
			//调用798002放款成功后设置BUSINESS_PUTOUT.sendflag 置 1 "发送成功"
			// add by wangdw 2012-08-09
			RunMethod("PublicMethod","UpdateColValue","String@sendflag@1,BUSINESS_PUTOUT,String@SERIALNO@"+sObjectNo);
			print();
			reloadSelf();
		}
	}
	//抵质押物入库 add by wangdw
	function GuarantyIn(sObjectNo)
	{
		var i=0
		var sGuarantyID
		var Arr_GuarantyId = Array();
		sReturn = RunMethod("BusinessManage","GetGuarantyIdByPutOutNo ",sObjectNo);
		alert(sReturn);
		Arr_GuarantyId=sReturn.split("@");
		for(i=0;i<Arr_GuarantyId.length-1;i++)
		{
			//alert(Arr_GuarantyId[i])
			var sGuarantyID = Arr_GuarantyId[i];
			sTradeType = "777100";	
	        sObjectNo = sGuarantyID;
	        sObjectType = "GuarantyInfoLoad";
			if (typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
			{
				alert(getHtmlMessage('1'));
				return;
			}
			sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
			sReturn=sReturn.split("@");
			if(sReturn[0] != "0000000"){
				alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
				return;
			}else{
				alert("入库成功["+sReturn[1]+"]");
			}
			//该笔抵质押物的发送状态置为“入库发送”
			RunMethod("PublicMethod","UpdateColValue","String@GISendFlag@01,GUARANTY_INFO,String@GUARANTYID@"+sGuarantyID);
		}
	}	
	//抵质押物状态查询 add by wangdw
	function guarantyState(){
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	   	PopComp("SearchGuarantyByPutOutNo","/CreditManage/GuarantyManage/SearchGuarantyByPutOutNo.jsp","ObjectNo="+sObjectNo,"");
	   	reloadSelf();
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
	
	/*~[Describe=取消发送;InputParam=无;OutPutParam=无;]~*/
	function cancelSend()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sSendFlag = getItemValue(0,getRow(),"SendFlag");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
//获得"发生类型"起 --- add by wangdw
		sOccurType = "";
		sReturn = RunMethod("PublicMethod","GetColValue","OccurType,BUSINESS_CONTRACT,String@SerialNO@"+sContractSerialNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			sReturnValue = sReturn.split('@');
			sOccurType = sReturnValue[1];
		}
//获得"发生类型"止
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
				 || sBusinessType=='1110027'|| sBusinessType=='1140025' || sBusinessType == '1110025'
				 ||sBusinessType == "2110020"){
					 
					 if(sBusinessType == "1110027"||sBusinessType == "2110020")//公积金组合贷款出帐单独交易
					{
						//公积金贷款的变更的取消交易
						if(sOccurType == '120')
						{
							sTradeType = "6034";
						}else
						{
							sTradeType = "6028";
						}
					}else{
						sTradeType = "6009";
					}
				 	sObjectType = sContractSerialNo;//传入合同号，更新合同归档日期
					sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
					sReturn=sReturn.split("@");
					if(sReturn[0] != "0000000"){
						alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
						return;
					}else{
						//置发送核心标志为空
						//sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@SendFlag@None,BUSINESS_PUTOUT,String@SerialNo@"+sObjectNo);
						alert("个贷取消成功！");
						reloadSelf();
					}
				}else{
					//展期交易有单独交易 added by zrli
					sOccurType = "";
					sReturn = RunMethod("PublicMethod","GetColValue","OccurType,BUSINESS_CONTRACT,String@SerialNO@"+sContractSerialNo);
					if(typeof(sReturn) != "undefined" && sReturn != "") 
					{
						sReturnValue = sReturn.split('@');
						sOccurType = sReturnValue[1];
					}
					if(sOccurType == '015'){
						sTradeType = "798007";
						sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
						sReturn=sReturn.split("@");
						if(sReturn[0] != "0000000"){
							alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
							return;
						}else{
							//置发送核心标志为空
							//sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@SendFlag@None,BUSINESS_PUTOUT,String@SerialNo@"+sObjectNo);
							alert("展期发送核心成功！"+sReturn[1]);
							reloadSelf();
						}
						return;
					}else{
						if( sBusinessType.substring(0,4)=='2050')
						{
							sTradeType = "ISS000000110";
							//sReturn = RunMethod("BusinessManage","ESBGJTrade",sObjectNo+","+sTradeType);
							sReturn = RunMethod("BusinessManage","SendESBGJ",sObjectNo+","+sObjectType+","+sTradeType);
							sReturn=sReturn.split("@");
							if(sReturn[0] != "0000000"){
								alert("国结系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
								return;
							}else{
									alert("国结取消成功！");
									reloadSelf();
								 }
						}
						else
						{
							sTradeType = "798003";
							sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
							sReturn=sReturn.split("@");
							if(sReturn[0] != "0000000"){
								alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
								return;
							}else{
								//置发送核心标志为空
								//sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@SendFlag@None,BUSINESS_PUTOUT,String@SerialNo@"+sObjectNo);
								alert("删除核心成功！");
								reloadSelf();
							}
						}
					}
				}
			}
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
