<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xlyu 2011-09-29
		Tester:
		Content: 预警信息_Info
		Input Param:	
			SignalType：预警类型（01：发起；02：解除）		
			SignalStatus：预警状态（10：待处理；15：待分发；20：审批中；30：批准；40：否决） 
			SerialNo：预警流水号    
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警发起"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
		
	//获得组件参数		
	//String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//将空值转化为空字符串
    //if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>

<%	
	String[][] sHeaders = {							
							{"SerialNo","预警流水号"},
							{"CustomerName","客户名称"},
							{"SignalTypeName","预警类型"},
							{"SignalType","预警类型"},
							{"SignalLevelName","预警级别"},
							{"SignalLevel","预警级别"},
							{"SignalStatusName","预警状态"},	
							{"SignalStatus","预警状态"},	
							{"CustomerOpenBalance","敞口金额"},
							{"FinalOrgName","最终审批机构"},
							{"FinalUserName","最终审批人"},
							{"OperateOrgName","管户机构"},
							{"OperateUserName","管户人"}
						};
	sSql =  "select RS.SerialNo,RS.SignalType,getItemName('SignalType',RS.SignalType) as SignalTypeName,"+
			" GetCustomerName(RS.ObjectNo) as CustomerName,"+
			" RS.SignalLevel,getItemName('SignalLevel',RS.SignalLevel) as SignalLevelName,"+
	        " RS.SignalStatus,getItemName('SignalStatus',RS.SignalStatus) as SignalStatusName,"+
	        " RS.CustomerOpenBalance as CustomerOpenBalance,"+
	        " getUserName(RS.InputUserID) as OperateUserName,"+
	        " getOrgName(RS.InputOrgID) as OperateOrgName, "+
	        " A.UserName  as FinalUserName,A.OrgName as FinalOrgName "+ 
	        " from RISK_SIGNAL RS  "+
	        " left join (select ObjectNo,OrgName,UserName from FLOW_TASK FT where  FT.ObjectType='RiskSignalApply' and exists(select 1 from FLOW_TASK where RelativeSerialNo=FT.SerialNo and PhaseNo='1000') ) A "+
	        " ON A.ObjectNo = RS.SerialNo "+
	        " where RS.InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
	if(CurUser.hasRole("0J1")) sSql +="and InputUserID in (select userid from user_role where roleid='080')";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置字段位置
	doTemp.setAlign("SignalType,SignalStatus","2");
	//设置关键字
	doTemp.setKey("SignalNo,ObjectNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("SignalType,SignalLevel,SignalStatus",false);
	//设置敞口金额显示为三位一逗，小数点后两位
	doTemp.setType("CustomerOpenBalance","Number");
	doTemp.setCheckFormat("CustomerOpenBalance","2");
	doTemp.setDDDWCode("SignalType","SignalType");
	doTemp.setDDDWCode("SignalLevel","SignalLevel");
	doTemp.setDDDWCode("SignalStatus","SignalStatus");
	//生成查询框
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","OperateOrgName","");
	doTemp.setFilter(Sqlca,"3","SignalType","");
	doTemp.setFilter(Sqlca,"4","SignalLevel","");
	doTemp.setFilter(Sqlca,"5","SignalStatus","");
	doTemp.setFilter(Sqlca,"6","FinalOrgName","");
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","预警详情","预警详情","viewAndEdit()",sResourcesPath},
			{"false","","Button","查看意见","查看意见","viewOpinions()",sResourcesPath},
			{"true","","Button","预警报告审批表","查看预警报告审批表","checkManulReport()",sResourcesPath},
			{"true","","Button","预警解除申请表","查看预警解除申请表","checkRiskFreeReport()",sResourcesPath},
			{"true","","Button","处置报告","查看处置报告","viewDisposeReport()",sResourcesPath}
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    //---------------------定义按钮事件------------------------------------
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//根据新增申请的流水号，打开申请详情界面
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		
		reloadSelf();
	}
	
	/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewRiskSignalOpinions","/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	   }
	   
	/*~[Describe=查看预警报告审批表;InputParam=无;OutPutParam=无;]~*/
	function checkManulReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");//申请预警信号流水号
		var sObjectType = "RiskSignal";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignal");
	    if (typeof(sSerialNo)!="undefined" && sSerialNo.length!=0 && sSerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			return;
		}	
	}
	
	/*~[Describe=查看预警解除申请表;InputParam=无;OutPutParam=无;]~*/
	function checkRiskFreeReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");//申请预警信号流水号
		var sObjectType = "FreeRiskSignal";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",FreeRiskSignal");
	    if (typeof(sSerialNo)!="undefined" && sSerialNo.length!=0 && sSerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}	
	}
	
	/*~[Describe=查看预警处置报告;InputParam=无;OutPutParam=无;]~*/
	function viewDisposeReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = "RiskSignalDispose";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignalDispose");
	    
	    if (typeof(sSerialNo)!="undefined" && sSerialNo.length!=0 && sSerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}	
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function initRow()
	{
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>