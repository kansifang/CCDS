<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: thong 2005-09-14
		Tester:	
		Content: 业务提示和预警配置
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务提示和预警配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过SQL产生ASDataObject对象doTemp
	
	String[][] sHeaders = {
							{"ScenarioID","场景编号"},
							{"ScenarioName","场景名称"},
							{"ObjectType","预警对象类型"},
							{"ScenarioDescribe","场景说明"}
						  };

	sSql = "select ScenarioID,ScenarioName,ObjectType,ScenarioDescribe "+
		   "from ALARM_SCENARIO where 1=1 order by ScenarioID";
		   
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "ALARM_SCENARIO";
	doTemp.setKey("ScenarioID",true);
	doTemp.setHeader(sHeaders);
	doTemp.setHTMLStyle("ScenarioDescribe","Style={width=450px};");

	//查询
 	doTemp.setColumnAttribute("ScenarioID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelScenarioAll(#ScenarioID)");
	
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","预警条件列表","查看/修改预警条件列表","viewAndEditLib()",sResourcesPath},
		{"true","","Button","预警参数配置","查看/修改预警预处理参数","viewAndEditArg()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","提交任务调度管理","提交任务调度管理","submitAlsert()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		sReturn=popComp("OperationAlertInfo","/CreditManage/CreditAlarm/OperationAlertInfo.jsp","","");
	    reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sScenarioID = getItemValue(0,getRow(),"ScenarioID");
		
		if (typeof(sScenarioID)=="undefined" || sScenarioID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
	                return ;
	    }
	    sReturn=popComp("OperationAlertInfo","/CreditManage/CreditAlarm/OperationAlertInfo.jsp","ScenarioID="+sScenarioID,"");
	    reloadSelf();
	}
    /*~[Describe=查看及修改预警条件列表;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditLib()
	{
        	sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            		return ;
		}
        	popComp("AlarmLibList","/Common/Configurator/AlarmManage/AlarmLibList.jsp","ScenarioID="+sScenarioID,"");
	}

    /*~[Describe=查看及修改预警参数;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditArg()
	{
        	sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            		return ;
		}
        	popComp("AlarmArgsList","/Common/Configurator/AlarmManage/AlarmArgsList.jsp","ScenarioID="+sScenarioID,"");
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
