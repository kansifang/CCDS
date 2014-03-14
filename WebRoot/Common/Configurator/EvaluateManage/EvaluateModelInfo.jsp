<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    评估模型详情
			Input Param:
	                    ModelNo：    报表记录编号
	                    ItemNo：   阶段编号
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
		String PG_TITLE = "评估模型详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	
	//获得组件参数	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
    if(sModelNo==null) sModelNo="";
	if(sItemNo==null) sItemNo="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = {
					{"ModelNo","评估表编号"},
					{"ItemNo","项目编号"},
					{"DisplayNo","显示序号"},
					{"ItemName","项目名称"},
					{"ItemAttribute","项目属性"},
					{"ValueMethod","取值方法"},
					{"ValueCode","取值代码"},
					{"ValueType","值类型"},
					{"EvaluateMethod","评估方法"},
					{"Coefficient","系数"},
					{"Remark","备注"},
	       		   };  

	sSql = " Select  "+
		"ModelNo,"+
		"ItemNo,"+
		"DisplayNo,"+
		"ItemName,"+
		"ItemAttribute,"+
		"ValueMethod,"+
		"ValueCode,"+
		"ValueType,"+
		"EvaluateMethod,"+
		"Coefficient,"+
		"Remark "+
		"From EVALUATE_MODEL Where ModelNo = '"+sModelNo+"' And ItemNo = '"+sItemNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="EVALUATE_MODEL";
	doTemp.setKey("ModelNo,ItemNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setReadOnly("ModelNo",true);
	doTemp.setVisible("ModelNo",false);
	
	doTemp.setHTMLStyle("ItemNo,DisplayNo,ValueType,Coefficient"," style={width:60px} ");
	doTemp.setHTMLStyle("ItemName"," style={width:200px} ");
	doTemp.setHTMLStyle("ItemAttribute"," style={width:160px} ");
	doTemp.setHTMLStyle("ValueCode"," style={width:160px} ");
	doTemp.setEditStyle("ValueMethod,EvaluateMethod,Remark","3");
	doTemp.setHTMLStyle("ValueMethod"," style={height:150px;width:600px;overflow:scroll} ");
	doTemp.setHTMLStyle("EvaluateMethod,Remark"," style={height:100px;width:600px;overflow:scroll} ");

	//设置小数显示状态,
	doTemp.setAlign("Coefficient","3");
	doTemp.setType("Coefficient","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("Coefficient","2");
	
	doTemp.setUnit("ValueCode"," <input type=button class=inputdate value=... onclick=parent.SelectCode(\"ALL\")>");
	doTemp.setUnit("ValueType","（例如：Number，String）");

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
			{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
			// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回代码列表","doReturn('N')",sResourcesPath}
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
    var sCurModelNo=""; //记录当前所选择行的代码号

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
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        OpenComp("EvaluateModelInfo","/Common/Configurator/EvaluateManage/EvaluateModelInfo.jsp","ModelNo="+sModelNo,"_self","");
	}

	function SelectCode(sType)
	{		
		if(sType == "ALL")
		{			
			setObjectValue("SelectAllCode","","@ValueCode@1",0,0,"");			
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
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
            if ("<%=sModelNo%>" !="") 
            {
                setItemValue(0,0,"ModelNo","<%=sModelNo%>");
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
