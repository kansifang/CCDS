<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: ndeng 2005-04-23
			Tester:
			Describe: 流程情况查询
			Input Param:
		
			Output Param:
		
		
			HistoryLog:
		 */
	%>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "流程情况查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量

	//获得页面参数
	
	//获得组件参数
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
    if(sFlowNo == null) sFlowNo = "";
    String sMainTable=sFlowNo.equals("ApproveFlow")?"Business_Approve":sFlowNo.equals("PutOutFlow")?"Business_PutOut":"Business_Apply";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = 	{
					   {"SerialNo","任务流水号"},
					   {"ObjectNo","业务流水号"},
					   {"FlowNo","流程号"},
                               {"FlowName","流程名称"},
                               {"PhaseNo","流程阶段号"},
                               {"PhaseName","流程阶段名称"},
                               {"UserID","经办人号"}, 
                               {"UserName","经办人"},                              
                               {"OrgName","经办机构"},
                               {"BeginTime","起始日期"},
                               {"EndTime","终止日期"},
                               {"PhaseOpinion1","提交意见"},
                               {"PhaseAction","下一阶段任务人"},
                               {"CustomerID","客户号"},
                               {"CustomerName","客户名称"},
                               {"OperateOrgName","申请机构"},
                               {"OperateUserID","申请人号"},
                               {"OperateUserName","申请人"},
					};

	
	String sSql = " select BX.CustomerID,BX.CustomerName,"+
		  " FT.SerialNo,FT.ObjectType,FT.ObjectNo,FT.FlowNo,FT.FlowName,FT.PhaseNo,FT.PhaseName, "+
                  " FT.UserID,FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime,FT.PhaseOpinion1,FT.PhaseAction,"+
                  " getOrgName(BX.OperateOrgID) as OperateOrgName,BX.OperateUserID,getUserName(BX.OperateUserID) as OperateUserName"+
                  " from Flow_Task FT,"+sMainTable+" BX"+
		  " where FT.ObjectNo=BX.SerialNo"+
		  " and BX.OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "FLOW_TASK";
	doTemp.setKey("SerialNo",true);	 //为后面的删除
	//设置字段不可见性
	doTemp.setVisible("ObjectType",false);
	doTemp.setHTMLStyle("CustomerName","style={width:200px}");
	//设置查询条件
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","CustomerID","");
	doTemp.setFilter(Sqlca,"3","CustomerName","");
	doTemp.setFilter(Sqlca,"4","OperateUserName","");
	doTemp.setFilter(Sqlca,"5","PhaseNo","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"6","PhaseName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"7","UserName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"8","OrgName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
    doTemp.parseFilterData(request,iPostChange);   
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //设置排序条件
    //doTemp.OrderClause = " group by ObjectNo ";
   	doTemp.OrderClause = " order by FT.ObjectNo desc,FT.SerialNo asc ";
    doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
    if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and FT.FlowNo = '"+sFlowNo+"'";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{"true","","Button","当前阶段信息","详情","viewAndEdit1()",sResourcesPath},
			{"true","","Button","业务详情","业务详情","viewAndEdit2()",sResourcesPath},
			{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
			{"Business_Apply".equals(sMainTable)?"true":"false","","Button","申请批复信息","详情","viewApprove()",sResourcesPath},
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
	/*~[Describe=查看及修改详情(flow_task);InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		//获取对象类型和对象编号
		var sTaskNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			popComp("FlowFindInfo","/SystemManage/GeneralSetup/FlowFindInfo.jsp","TaskNo="+sTaskNo);
		}
		reloadSelf();	
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
	/*~[Describe=查看及修改当前阶段详情（flow_object）;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit1()
	{
		//获取对象类型和对象编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			popComp("FlowObjectFindInfo","/SystemManage/GeneralSetup/FlowObjectFindInfo.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		}
		reloadSelf();
	}
	/*~[Describe=查看及修改业务详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2()
	{
		//获取对象类型和对象编号
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenObject(sObjectType,sObjectNo,"002");
		}
	}
	/*~[Describe=查看批复业务详情;InputParam=无;OutPutParam=无;]~*/
	function viewApprove()
	{
		//获取对象类型和对象编号
		var sBASerialNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sBASerialNo)=="undefined" || sBASerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			popComp("ApproveQueryList","/InfoManage/QuickSearch/ApproveQueryList.jsp","BASerialNo="+sBASerialNo);
		}
		reloadSelf();
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
	showFilterArea();
	var bHighlightFirst = true;//自动选中第一条记录
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>
