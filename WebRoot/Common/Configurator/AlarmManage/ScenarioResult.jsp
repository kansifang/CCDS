<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jacky hao 2005-07-28
		Tester:
		Content: 预警场景列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "视野组列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {
		{"trigger_name","序号"},
		{"trigger_group","场景编号"},
		{"description","场景名称"},
		{"curr_exec_progress","当前进度"},
		{"curr_start_time","开始处理时间"},
		{"curr_end_time","结束处理时间"},		
		{"user_id","创建人"},
		{"create_date","创建时间"}
	};
	sSql = "select "+
		   "trigger_name,"+"trigger_group,"+
		   "description,"+"curr_exec_progress,"+
		   "curr_start_time,"+"curr_end_time,"+
		   "user_id,"+"create_date"+
		  " from atask_progress where 1=1 order by create_date desc";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "atask_progress";
	doTemp.setKey("trigger_name",true);
	doTemp.setKey("trigger_group",true);
	doTemp.setHeader(sHeaders);

	//查询
 	doTemp.setColumnAttribute("trigger_group","IsFilter","1");
 	doTemp.setColumnAttribute("description","IsFilter","1");
 	doTemp.setColumnAttribute("curr_exec_progress","Unit","(单位：%)");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    	dwTemp.setPageSize(20);

	//定义后续事件
	//dwTemp.setEvent("BeforeDelete","!Configurator.DelScenarioAll(#ScenarioID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},		
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		 
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	 
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
            sSerialNo = getItemValue(0,getRow(),"trigger_name");
            if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
                return ;
	    }
	    sReturn=popComp("ScenarioResultInfo","/Common/Configurator/AlarmManage/ScenarioResultInfo.jsp","SerialNo="+sSerialNo,"");
	    reloadSelf();
	}
    
    

   
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		trigger_name = getItemValue(0,getRow(),"trigger_name");
        	if(typeof(trigger_name)=="undefined" || trigger_name.length==0) {
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
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
	}
	
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
