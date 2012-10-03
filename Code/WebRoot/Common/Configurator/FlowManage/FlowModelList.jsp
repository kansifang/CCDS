<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: 流程模型列表
		Input Param:
             sFlowNo：流程编号     
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




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
    //获得页面参数	
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
    if (sFlowNo == null) sFlowNo = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String[][] sHeaders={
			{"FlowNo","流程编号"},
			{"PhaseNo","阶段号"},
			{"PhaseType","阶段类型"},
			{"PhaseName","阶段名称"},
			{"PhaseDescribe","阶段描述"},
			{"PhaseAttribute","阶段属性"},
			{"PreScript","前沿执行Script1"},
			{"InitScript","相关承办人Script"},
			{"ChoiceDescribe","意见描述"},
			{"ChoiceScript","意见生成Script"},
			{"ActionDescribe","动作描述"},
			{"ActionScript","动作生成Script"},
			{"PostScript","后续阶段Scripit"},
			{"Attribute1","当前工作功能按钮"},
			{"Attribute2","已完成工作功能按钮"},
			{"Attribute3","意见查看权限方式"},
			{"Attribute4","意见权限阶段"},
			{"Attribute5","查看特权角色"},
			{"Attribute6","仅查看自己签署意见所对应的阶段"},
			{"Attribute7","视图"},
			{"Attribute8","签署意见组件ID"},
			{"Attribute9","属性9"},
			{"Attribute10","属性10"},
			{"AAEnabled","是否有终审权"},
			{"AApointInitScript","审批授权初始化"},
			{"AApointComp","审批授权组件ID"},
			{"AApointCompUrl","审批授权组件URL"}
			
		};

	sSql = "Select "+
			"F.FlowNo,"+
			"F.PhaseNo,"+
			"F.PhaseType,"+
			"C.ItemName as PhaseName,"+
			"F.PhaseDescribe,"+
			"F.PhaseAttribute,"+
			"F.PreScript,"+
			"F.InitScript,"+
			"F.ChoiceDescribe,"+
			"F.ChoiceScript,"+
			"F.ActionDescribe,"+
			"F.ActionScript,"+
			"F.PostScript,"+
			"F.Attribute1,"+
			"F.Attribute2,"+
			"getItemName('OpinionViwRightType',F.Attribute3) as Attribute3,"+
			"F.Attribute4,"+
			"F.Attribute5,"+
			"F.Attribute6, "+
			"F.Attribute7, "+
			"F.Attribute8, "+
			"F.Attribute9, "+
			"F.Attribute10, "+
			"getItemName('YesNo',F.AAEnabled) as AAEnabled, "+
			"F.AApointInitScript, "+
			"F.AApointComp, "+
			"F.AApointCompUrl "+
			" From FLOW_MODEL F,CODE_LIBRARY C"+
			" where F.PhaseType=C.ItemNo and C.isInUse='1'"+
			" and  C.CodeNo in ("+
								"select trim(ItemDescribe) from CODE_LIBRARY where CodeNo='ApplyType' and trim(ItemNo) in ("+
										"select FlowType from FLOW_CATALOG where FlowNo='"+sFlowNo+"'"+
										")"+
								")";	
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_MODEL";
	doTemp.setKey("FlowNo,PhaseNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("PhaseNo"," style={width:60px} ");
	doTemp.setHTMLStyle("PhaseName"," style={width:100px} ");

	//需与申请类型对照
	//sSql = "select ItemNo,ItemName from CODE_LIBRARY where IsInUse='1' and CodeNo in (select trim(ItemDescribe) from CODE_LIBRARY where CodeNo='ApplyType' and trim(ItemNo) in (select FlowType from FLOW_CATALOG where FlowNo='"+sFlowNo+"')) ";
	//doTemp.setDDDWSql("PhaseType",sSql);

	doTemp.setRequired("PhaseNo",true);   //必输项
	//设置共用格式
	doTemp.setVisible("FlowNo,PhaseDescribe,PhaseAttribute",false);

	//doTemp.setEditStyle("PreScript,InitScript,ChoiceDescribe,ChoiceScript,ActionDescribe,ActionScript,PostScript,Attribute1,Attribute3,Attribute4,Attribute5,Attribute6","3");
	//doTemp.setHTMLStyle("PreScript,InitScript,ChoiceDescribe,ChoiceScript,ActionDescribe,ActionScript,PostScript,Attribute1,Attribute3,Attribute4,Attribute5,Attribute6"," style={width:100px;height:22px;overflow:auto} ");

	//查询
 	doTemp.setColumnAttribute("PhaseNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(sFlowNo!=null && !sFlowNo.equals("")) 
	{
		doTemp.WhereClause+=" and FlowNo='"+sFlowNo+"'";
	}
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);
    
	//定义后续事件

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo);
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
		//{"true","","Button","保存","保存","save()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
	};
    %> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    var sCurFlowNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo=<%=sFlowNo%>","");
        //修改数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/FlowManage/FlowModelList.jsp?FlowNo="+sReturnValues[0],"_self","");           
            }
        }
        
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        sReturn=popComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo="+sFlowNo+"~PhaseNo="+sPhaseNo,"");
        //修改数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/FlowManage/FlowModelList.jsp?FlowNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	function save(){
		as_save("myiframe0","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if(typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0) {
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
		sObjectNo = getItemValue(0,getRow(),"FlowNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
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