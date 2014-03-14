<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    流程模型信息详情
			Input Param:
	                    FlowNo：流程编号
	 		Output param:
			                
			History Log: 
	            
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "流程模型信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
	//获得组件参数	
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	if(sFlowNo==null) sFlowNo="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders={
	{"FlowNo","流程编号"},
	{"FlowName","流程名称"},
	{"FlowType","流程类型"},
	{"FlowDescribe","流程描述"},
	{"InitPhase","初始阶段"},
	{"AAEnabled","是否进行授权设置"},
	{"AAPolicyName","授权方案"}
		};

	sSql =  " select FlowNo,FlowName,FlowType,FlowDescribe,InitPhase, "+
	" AAEnabled,AAPolicy,getPolicyName(AAPolicy) as AAPolicyName "+
	" from FLOW_CATALOG where FlowNo = '"+sFlowNo+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_CATALOG";
	doTemp.setKey("FlowNo",true);
	doTemp.setHeader(sHeaders);
	//设置必输项
	doTemp.setRequired("FlowNo,FlowName,FlowType",true);   
	//设置下拉框
	doTemp.setDDDWCode("AAEnabled","YesNo");
	doTemp.setDDDWCode("FlowType","ApplyType");
	//设置不可见性
	doTemp.setVisible("AAPolicy",false);
	//设置不可更新
	doTemp.setUpdateable("AAPolicyName",false);
	doTemp.setReadOnly("AAPolicyName",true);
	//设置格式	
	doTemp.setHTMLStyle("FlowName"," style={width:300px} ");	
	doTemp.setEditStyle("FlowDescribe","3");
	doTemp.setHTMLStyle("FlowDescribe","style={width=400px;height=150px;}");
   	//设置弹出式选择窗口
	doTemp.setUnit("AAPolicyName","<input class=inputdate type=button value=\"...\" onClick=parent.getPolicyID()>");
	
	//filter过滤条件
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = "";
%>

<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/
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
			{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
    var sCurFlowNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
        sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1") //是否进行授权设置
		{
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0)
			{
				alert("请选择授权方案！"); 
				return;
			}
		}else
		{
			//将所填写的授权方案置为空字符串
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
        as_save("myiframe0","");        
	}
    
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
        sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1") //是否进行授权设置
		{
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0)
			{
				alert("请选择授权方案！"); 
				return;
			}
		}else
		{
			//将所填写的授权方案置为空字符串
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
        as_save("myiframe0","newRecord()");        
	}
    
    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        OpenComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","","_self","");
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	
	/*~[Describe=弹出授权方案选择窗口;InputParam=无;OutPutParam=无;]~*/
	function getPolicyID()
	{		
		setObjectValue("SelectPolicy","","@AAPolicy@0@AAPolicyName@1",0,0,"");			
	}
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
		    bIsInsert = true;
		}
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=页面装载时，进行初始化;]~*/
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
