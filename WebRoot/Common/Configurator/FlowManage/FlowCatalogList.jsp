<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: 流程模型列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "流程模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	
	//获得组件参数	
	
	//获得页面参数	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String[][] sHeaders={
			{"FlowNo","流程编号"},
			{"FlowName","流程名称"},
			{"FlowType","流程类型"},
			{"FlowDescribe","流程描述"},
			{"InitPhase","初始阶段"},
			{"AAEnabled","是否进行授权设置"},
			{"AAPolicy","授权方案"}
		};

	sSql =  " select FlowNo,FlowName,getItemName('ApplyType',FlowType) as FlowType, "+
			" FlowDescribe,getPhaseName(FlowNo,InitPhase) as InitPhase, "+
			" getItemName('YesNo',AAEnabled) as AAEnabled, "+
			" getPolicyName(AAPolicy) as AAPolicy "+
			" from FLOW_CATALOG where 1=1 and FlowNo not in ('SMEConFlow','SMECreditFlow')";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_CATALOG";
	doTemp.setKey("FlowNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("FlowNo,FlowName"," style={width:150px} ");
	doTemp.setHTMLStyle("FlowType,InitPhase"," style={width:150px} ");	
	doTemp.setHTMLStyle("FlowDescribe"," style={width:260px} ");
	doTemp.setAlign("FlowType,AAEnabled","2");

	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	//查询
 	doTemp.setColumnAttribute("FlowNo,FlowName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelFlowModel(#FlowNo)");
	
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","流程模型列表","查看/修改流程模型列表","viewAndEdit2()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","业务流程信息","查看所选流程的业务信息","viewInfo()",sResourcesPath}
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
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","","");        
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //新增数据后刷新列表
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/FlowManage/FlowCatalogList.jsp","_self","");    
                }
            }
        }
        reloadSelf();
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        //openObject("FlowCatalogView",sFlowNo,"001");
        popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo+"&ItemID=0010","");
	}
    
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        //popComp("FlowModelList","/Common/Configurator/FlowManage/FlowModelList.jsp","FlowNo="+sFlowNo,"");
        popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo+"&ItemID=0020","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('49'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	 /*~[Describe=查看所选流程的业务详情;InputParam=无;OutPutParam=无;]~*/
	function viewInfo()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		var sFlowType;		
        if(sFlowNo == "CreditFlow")//授信申请审批流程
        	sFlowType = "01";
        if(sFlowNo == "ApproveFlow")//最终审批意见审批流程
        	sFlowType = "02";
        if(sFlowNo == "PutOutFlow")//业务出帐审批流程
        	sFlowType = "03";
        popComp("FlowFindList","/SystemManage/GeneralSetup/FlowFindList.jsp","FlowType="+sFlowType,"");
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
