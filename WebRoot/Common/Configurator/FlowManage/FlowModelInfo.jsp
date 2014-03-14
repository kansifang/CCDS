<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    流程信息详情
			Input Param:
	                    FlowNo：    流程编号
	                    PhaseNo：   阶段编号
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
		String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	
	//获得组件参数	
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
    if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
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
	"FlowNo,"+
	"PhaseNo,"+
	"PhaseType,"+
	"PhaseName,"+
	"PhaseDescribe,"+
	"PhaseAttribute,"+
	"PreScript,"+
	"InitScript,"+
	"ChoiceDescribe,"+
	"ChoiceScript,"+
	"ActionDescribe,"+
	"ActionScript,"+
	"PostScript,"+
	"Attribute1,"+
	"Attribute2,"+
	"Attribute3,"+
	"Attribute4,"+
	"Attribute5,"+
	"Attribute6, "+
	"Attribute7, "+
	"Attribute8, "+
	"Attribute9, "+
	"Attribute10, "+
	"AAEnabled, "+
	"AApointInitScript, "+
	"AApointComp, "+
	"AApointCompUrl "+
	"From FLOW_MODEL "+
	"where FlowNo='"+sFlowNo+"' "+
	"And PhaseNo = '"+sPhaseNo+"'";	
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_MODEL";
	doTemp.setKey("FlowNo,PhaseNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("PhaseNo"," style={width:60px} ");
	doTemp.setHTMLStyle("PhaseName"," style={width:100px} ");

	sSql = " select ItemNo,ItemName from CODE_LIBRARY where IsInUse='1' and CodeNo in (select trim(ItemDescribe) from CODE_LIBRARY where CodeNo='ApplyType' and trim(ItemNo) in (select FlowType from FLOW_CATALOG where FlowNo='"+sFlowNo+"'))";
	doTemp.setDDDWSql("PhaseType",sSql);
	doTemp.setDDDWCode("Attribute3","OpinionViwRightType");
	doTemp.setDDDWCode("AAEnabled","YesNo");

	doTemp.setRequired("PhaseNo,PhaseType",true);   //必输项
	//设置共用格式

	doTemp.setEditStyle("PreScript,InitScript,ChoiceDescribe,ChoiceScript,ActionDescribe,ActionScript,PostScript,Attribute1,Attribute2,Attribute4,Attribute5,Attribute6","3");
	doTemp.setHTMLStyle("PreScript,InitScript,ChoiceDescribe,ChoiceScript,ActionDescribe,ActionScript,PostScript,Attribute1,Attribute2,Attribute4,Attribute5,Attribute6"," style={width:600px;height:100px;overflow:auto} style={width=600px;height=100px;overflow:scroll}");

	//filter过滤条件
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sPhaseNo);
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
			{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()",sResourcesPath},
			{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath}
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
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndReturn()
	{
        as_save("myiframe0","doReturn('Y');");
        
	}
    
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
        as_save("myiframe0","newRecord()");
        
	}

    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"FlowNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        OpenComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo="+sFlowNo,"_self","");
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			if ("<%=sFlowNo%>" !="") 
			{
				setItemValue(0,0,"FlowNo","<%=sFlowNo%>");
			}
			bIsInsert = true;
		}
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
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
