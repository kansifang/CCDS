<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: jytian 2004-12-21
			Tester:
			Describe:文档附件列表
			Input Param:
	       		文档编号:BatchNo
			Output Param:

			HistoryLog:zywei 2005/09/03 重检代码
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "文档附件列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量                     
    String sSql = "";   	
	//获得页面参数
	
	//获得组件参数
	String sSerialNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = 	{ 
                            	{"SerialNo","业务号"},
                            	{"ActionType","业务类型"},
                            	{"BeginTime","开始时间"},
                            	{"EndTime","结束时间"},
                            	{"Achievement","活动成果"},
                            	{"Remark","总结"},
                            	{"PhaseName","当前阶段"}
	     			};    		                     
	
	    
    	//定义SQL语句
    	
	sSql = 	" SELECT ObjectType,ObjectNo,FlowNo,PhaseNo,BCA.SerialNo,RelativeSerialNo,"+
				" getItemName('ActionType',ActionType) as ActionType,"+
				" BeginTime,"+
				" EndTime,Achievement,"+
				" Remark,"+
				" PhaseName"+
			    " FROM Batch_Case_Action BCA "+
				" left join Flow_Object FO"+
			    " on BCA.SerialNo=FO.ObjectNo"+
				" and FO.ObjectType in('ApplyCaseHelpOT','ApplyCaseOVisitOT')"+
			    " and FO.UserID='"+CurUser.UserID+"'"+
				" WHERE RelativeSerialNo='"+sSerialNo+"'"+
			    " order by SerialNo asc";
	ASDataObject doTemp = new ASDataObject(sSql);
	//定义列表表头
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "Batch_Case_Action";
	doTemp.setKey("SerialNo",true);	
	
    doTemp.setVisible("RelativeSerialNo,ObjectType,ObjectNo,FlowNo,PhaseNo",false);
	doTemp.setHTMLStyle("BeginTime,EndTime,ContentType"," ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("ContentLength"," style={width:50px} ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("FileName"," style={width:150px} ondblclick=\"javascript:parent.viewFile()\" ");
    doTemp.setAlign("ContentLength","3");
    //生成查询框
  	doTemp.setColumnAttribute("LCustomerName,DCustomerName","IsFilter","1");
  	doTemp.generateFilters(Sqlca);
  	doTemp.parseFilterData(request,iPostChange);
  	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //查询区的页面代码
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
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
				{"true","","Button","新增","新增一个相关附件信息","newRecord()",sResourcesPath},
				{"true","","Button","详情","查看明细信息","viewAndEdit()",sResourcesPath},
				{"true","","Button","删除","删除文档信息","deleteRecord()",sResourcesPath},
				{"true","","Button","上传附件","查看附件详情","uploadDoc()",sResourcesPath},
				{"true","","Button","查看附件","查看附件详情","viewDoc()",sResourcesPath},
				{"true","","Button","签署意见","删除文档信息","signCheckOpinion()",sResourcesPath},
				{"true","","Button","提交","查看附件详情","doSubmitIn()",sResourcesPath},
				{"true","","Button","收回","查看附件详情","takeBack()",sResourcesPath}
			};
	%>
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
%>
<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/	
	function newRecord()
	{
		popComp("ActionInfo","/BusinessManage/Action/ActionInfo.jsp","RelativeSerialNo=<%=sSerialNo%>","dialogWidth=900px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    	{
        	alert("请选择一条记录！");
			return;
    	}
    	else
    	{
    		popComp("ActionInfo","/BusinessManage/Action/ActionInfo.jsp","SerialNo="+sSerialNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    		reloadSelf();
		}
	}
	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function doSubmitIn()
	{
		//获得对象类型、对象编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		//获得任务流水号
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert("请选中一条协催或外访记录！");
			return;
		}
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert("该外访已经提交了，不能再次提交！");//该放贷申请已经提交了，不能再次提交！
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
		sReturn = PopPage("/Common/BusinessFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
			return;
		}
		//弹出审批提交选择窗口		
		sPhaseInfo = PopPage("/Common/BusinessFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
			sPhaseInfo = PopPage("/Common/BusinessFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
	}
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function signCheckOpinion()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选中一条协催或外访记录！");
			return;
		}
		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		sCompID = "SignOpinionInfo";
		sCompURL = "/Common/BusinessFlow/SignOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
			{
        		as_del('myiframe0');
        		as_save('myiframe0'); 
    		}
		}
		
	}	
	//收回
	function takeBack(){
		//所收回任务的流水号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = "0010";	
		//获取任务流水号
		sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0)
		{
			if(confirm(getBusinessMessage('498'))) //确认收回该笔业务吗？
			{
				sRetValue = PopPage("/Common/BusinessFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				reloadSelf();
			}
		}else
		{
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}				
	}
</script>
<script  language=javascript>
	/*~[Describe=上传附件;InputParam=1导入2更新;OutPutParam=无;]~*/
	function uploadDoc(){
		var sObjectType="Action";
		var sObjectNo=getItemValue(0,getRow(),"SerialNo");
		var sDocAttribute="01";
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
		var sObjectType="Action";
		var sObjectNo=getItemValue(0,getRow(),"SerialNo");
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
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>
<%@	include file="/IncludeEnd.jsp"%>
