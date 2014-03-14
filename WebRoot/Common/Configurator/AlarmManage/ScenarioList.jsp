<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   zxu 2005-06-06
			Tester:
			Content: 预警场景列表
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
		String PG_TITLE = "预警场景列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
		CurPage.setAttribute("ShowDetailArea","true");
		CurPage.setAttribute("DetailAreaHeight","180");
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
	String sSortNo; //排序编号
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
		{"ScenarioName","场景名称"},
		{"ObjectType","预警对象类型"},
		{"ScenarioDescribe","场景说明"}
	};
	sSql = "select "+
		   "ScenarioID,"+
		   "ScenarioName,"+
		   "ObjectType,"+
		   "ScenarioDescribe "+
		  " from ALARM_SCENARIO where 1=1 order by ScenarioID";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "ALARM_SCENARIO";
	doTemp.setKey("ScenarioID",true);
	doTemp.setHeader(sHeaders);

	//查询
 	doTemp.setColumnAttribute("ScenarioID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(30);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelScenarioAll(#ScenarioID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
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
			{"true","","Button","预警条件列表","查看/修改预警条件列表","viewAndEditLib()",sResourcesPath},
			{"true","","Button","预警参数配置","查看/修改预警预处理参数","viewAndEditArg()",sResourcesPath},
			{"false","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
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
    var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        //sReturn=popComp("ScenarioInfo","/Common/Configurator/AlarmManage/ScenarioInfo.jsp","","");
        OpenComp("ScenarioInfo","/Common/Configurator/AlarmManage/ScenarioInfo.jsp","","DetailFrame",OpenStyle);
	    reloadSelf();
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
	    }
	    //sReturn=popComp("ScenarioInfo","/Common/Configurator/AlarmManage/ScenarioInfo.jsp","ScenarioID="+sScenarioID,"");
	    //reloadSelf();
        OpenComp("ScenarioInfo","/Common/Configurator/AlarmManage/ScenarioInfo.jsp","ScenarioID="+sScenarioID,"DetailFrame",OpenStyle);
	}
    
    /*~[Describe=查看及修改预警条件列表;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditLib()
	{
       	sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		//popComp("AlarmLibList","/Common/Configurator/AlarmManage/AlarmLibList.jsp","ScenarioID="+sScenarioID,"");
		OpenComp("AlarmLibList","/Common/Configurator/AlarmManage/AlarmLibList.jsp","ScenarioID="+sScenarioID,"DetailFrame",OpenStyle);
	}

    /*~[Describe=查看及修改预警参数;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditArg()
	{
       	sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
           	return ;
		}
        //popComp("AlarmArgsList","/Common/Configurator/AlarmManage/AlarmArgsList.jsp","ScenarioID="+sScenarioID,"");
        OpenComp("AlarmArgsList","/Common/Configurator/AlarmManage/AlarmArgsList.jsp","ScenarioID="+sScenarioID,"DetailFrame",OpenStyle);
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
           	return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
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
	
	function mySelectRow()
	{
		sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			OpenPage("/Blank.jsp?TextToShow=请选择一条记录","DetailFrame","");
			return;
		}
       	OpenComp("ScenarioInfo","/Common/Configurator/AlarmManage/ScenarioInfo.jsp","ScenarioID="+sScenarioID,"DetailFrame",OpenStyle);
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
	mySelectRow();
    hideFilterArea();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
