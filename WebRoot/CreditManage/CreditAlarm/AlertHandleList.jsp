<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui  2003.8.18
		Tester:
		Content: 企业债券发行信息_List
		Input Param:
			                CustomerID：客户编号
			                CustomerRight:权限代码----01查看权，02维护权，03超级维护权
		Output param:
		                CustomerID：当前客户对象的客户号
		              	Issuedate:发行日期
		              	BondType:债券类型
		                CustomerRight:权限代码
		                EditRight:编辑权限代码----01查看权，02编辑权
		History Log: 
		                 2003.08.20 CYHui
		                 2003.08.28 CYHui
		                 2003.09.08 CYHui 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;

	//获得组件参数	
	String sAlertID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertID"));
	String sUserID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sAlertType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertType"));
	String sFinishedFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FinishedFlag"));
	//out.println(sUsersSelected);

	//获得页面参数	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ExampleList";
	String sTempletFilter = "1=1";

	String[][] sHeaders = {
		{"ObjectName","警示相关对象"},
		{"AlertTip","警示信息"},
		{"Requirement","处理要求"},
		{"UserID","发送人"},
		{"UserName","发送人"},
		{"Treatment","处理情况"},
		{"BeginTime","开始时间"},
		{"EndTime","完成时间"},
		};
		
	sSql = "select AL.ObjectType,AL.ObjectNo,GetObjectName(AL.ObjectType,AL.ObjectNo) as ObjectName,AL.AlertTip,AH.SerialNo,AH.HandleNo,AH.UserID,GetUserName(AL.UserID) as UserName,AH.Requirement,AH.Treatment,AH.BeginTime,AH.EndTime "+
		" from ALERT_HANDLE AH,ALERT_LOG AL "+
		" where AH.SerialNo=AL.SerialNo ";
	ASDataObject doTemp = new ASDataObject(sSql);
	
	if(sAlertID!=null) doTemp.WhereClause+=" and AH.SerialNo='"+sAlertID+"'";
	if(sAlertType!=null) doTemp.WhereClause+=" and AL.AlertType='"+sAlertType+"'";
	if(sUserID!=null) doTemp.WhereClause+=" and AH.UserID='"+sUserID+"'";
	if(sFinishedFlag==null) doTemp.WhereClause+=" and AH.EndTime is null";
	if(sFinishedFlag!=null&&sFinishedFlag.equals("FinishedAlarm")) doTemp.WhereClause+=" and AL.AlertType like 'AL%' and AH.EndTime is not null";
	if(sFinishedFlag!=null&&sFinishedFlag.equals("FinishedNotification")) doTemp.WhereClause+=" and AL.AlertType like 'NF%' and AH.EndTime is not null";
	
	
	//doTemp.multiSelectionEnabled=true;
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("SerialNo,HandleNo,UserID,ObjectType,ObjectNo",false);
	doTemp.setHTMLStyle("AlertTip","style={width:250px}");
	doTemp.setHTMLStyle("ObjectName","style={width:200px}");

	doTemp.setColumnAttribute("AlertTip,ObjectName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
	//out.println(doTemp.SourceSql);
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
		{"true","","Button","详情","详情","viewDetail()",sResourcesPath},
		{"true","","Button","完成处理","填写处理情况","handle()",sResourcesPath},
		{"true","","Button","原始情况","查看相关的业务对象","openWithObjectViewer()",sResourcesPath},
		{"true","","Button","任务调度测试","任务调度测试","submitAlsert()",sResourcesPath}
		};
	
	if(sFinishedFlag!=null&&(sFinishedFlag.equals("FinishedNotification")||sFinishedFlag.equals("FinishedAlarm"))){
		sButtons[1][0]="false";
	}
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------


	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function handle(){
		sAlertID=getItemValue(0,getRow(),"SerialNo");
		sHandleNo=getItemValue(0,getRow(),"HandleNo");
		if (typeof(sAlertID)=="undefined" || sAlertID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		popComp("AlertHandleFinishInfo","/CreditManage/CreditAlarm/AlertHandleFinishInfo.jsp","AlertID="+sAlertID+"&HandleNo="+sHandleNo,"","");
		reloadSelf();
	
	}
	
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer()
	{
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectType)=="undefined" || sObjectType.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		openObject(sObjectType,sObjectNo,"001");
	}

	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function viewDetail()
	{
		sAlertID=getItemValue(0,getRow(),"SerialNo");
		sHandleNo=getItemValue(0,getRow(),"HandleNo");
		if (typeof(sAlertID)=="undefined" || sAlertID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		popComp("AlertHandleInfo","/CreditManage/CreditAlarm/AlertHandleInfo.jsp","AlertID="+sAlertID+"&HandleNo="+sHandleNo,"","");
		reloadSelf();
	}
	function submitAlsert()
	{
			var sReturn3;
            var sSerialNo = "1111";
            var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
             
            sReturn3 = popComp("SubmitAlarm","/PublicInfo/SubmitAlarm.jsp","OneStepRun=yes&ScenarioNo="+sScenarioID+"&ObjectType=ApplySerialNo&ObjectNo="+sSerialNo,"dialogWidth=40;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
             
            if (typeof(sReturn3)== 'undefined' || sReturn3.length == 0) 
            {
                alert("好像是个奇怪的错误！");
                
            } else if (sReturn3 >= 0) //成功 
            {
                if( sReturn3 == 0 )
                 { 
                    alert("已经成功提交了预警，你就等着瞧吧！ ：）" );    
                	 
                 }
                 else
                 {
                    alert("想想看，还需要提交别的预警任务吗？ ：） \n或去到\"预警结果分析\"去看吧。" );    
                	                  
                 }
            } 
           
            return;    
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
<%
    if(!doTemp.haveReceivedFilterCriteria()) {
%>
	showFilterArea();
<%
	}	
%>
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
