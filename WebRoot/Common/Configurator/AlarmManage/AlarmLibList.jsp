<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   zxu 2005-06-06
			Tester:
			Content: 预警条件列表
			Input Param:
	                  ScenarioID	预警场景编号
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
		String PG_TITLE = "预警条件列表@PageTitle"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql;
	
    //获得页面参数	
	String sScenarioID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ScenarioID"));
    if (sScenarioID == null) 
        sScenarioID = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders = {
		{"ScenarioID","场景编号"},			
		{"AlarmModelName","模型编号"},		
		{"SortNo","排序号"},
		{"DealMethodName","处理措施"},
		{"RunCondition","运行条件"},
		{"ShowScript","提示Script"},
		{"EffStatus","有效标志"}
	};
	
	sSql =  "select "+
	"ScenarioID,"+
	"AlarmModelNo,"+
	"getAlarmModelName(AlarmModelNo) as AlarmModelName,"+
	"SortNo,"+
	"DealMethod,"+
	"getItemName('LoanMethod',DealMethod) as DealMethodName,"+
	"RunCondition,"+
	"ShowScript,"+
	"getItemName('TrueFalse',EffStatus) as EffStatus"+
		" from ALARM_LIBRARY where 1=1 order by ScenarioID,AlarmModelNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "ALARM_LIBRARY";
	doTemp.setKey("ScenarioID,AlarmModelNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("DealMethodName","2");
 	//置是否可见
	doTemp.setVisible("AlarmModelNo,DealMethod",false);

	//查询
 	doTemp.setFilter(Sqlca,"1","AlarmModelName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(sScenarioID !=null && !sScenarioID.equals(""))
	{
		doTemp.WhereClause+=" And ScenarioID='"+sScenarioID+"'";
	}
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

	doTemp.setHTMLStyle("ScenarioID,SortNo,EffStatus"," style={width:50px} ");
	doTemp.setHTMLStyle("AlarmModelName"," style={width:250px} ");
	doTemp.setHTMLStyle("DealMethodName"," style={width:100px} ");
	doTemp.setHTMLStyle("RunCondition"," style={width:120px} ");
	doTemp.setHTMLStyle("ShowScript"," style={width:150px} ");

	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);
    
	//定义后续事件
	//dwTemp.setEvent("BeforeDelete","!Configurator.DelSightRight(#RightID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回","doReturn('N')",sResourcesPath}
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
		sReturn=popComp("AlarmLibInfo","/Common/Configurator/AlarmManage/AlarmLibInfo.jsp","ScenarioID=<%=sScenarioID%>","");
		//修改数据后刷新列表
		reloadSelf();
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        sAlarmModelNo = getItemValue(0,getRow(),"AlarmModelNo");
        if(typeof(sAlarmModelNo)=="undefined" || sAlarmModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        sReturn=popComp("AlarmLibInfo","/Common/Configurator/AlarmManage/AlarmLibInfo.jsp","ScenarioID="+sScenarioID+"&AlarmModelNo="+sAlarmModelNo,"");
        //修改数据后刷新列表
	reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sAlarmModelNo = getItemValue(0,getRow(),"AlarmModelNo");
        	if(typeof(sAlarmModelNo)=="undefined" || sAlarmModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            		return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ScenarioID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	hideFilterArea();
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
