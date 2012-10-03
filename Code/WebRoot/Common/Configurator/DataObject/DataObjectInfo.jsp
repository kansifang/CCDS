<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: 代码表信息详情
		Input Param:
                    DoNo：      数据对象编号
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
	String sSql;
	String sSortNo; //排序编号
	
	//获得组件参数	
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));

	if(sDoNo==null) sDoNo="";

	//获得页面参数	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders={
			{"DONO","DO编号"},
			{"DONAME","DO名称"},
			{"DODESCRIBE","DO描述"},
			{"DOTYPE","DO类别"},
			{"DOARGUMENTS","DO参数"},
			{"DOATTRIBUTE","DO属性"},
			{"DOUPDATETABLE","更新目标表"},
			{"DOUPDATEWHERE","更新方式"},
			{"DOFROMCLAUSE","DOFrom子句"},
			{"DOWHERECLAUSE","DOWhere子句"},
			{"DOGROUPCLAUSE","DOGroup子句"},
			{"DOORDERCLAUSE","DOOrder子句"},
			{"REMARK","备注"},
			{"DOCLASS","类型"},
			{"MODIFYAUDITTABLE","修改审计表"},
			{"MODIFYMODECRITERIA","修改审计条件"},
			{"DELETEAUDITTABLE","删除审计表"},
			{"DELETEMODECRITERIA","删除审计条件"},
			{"ISINUSE","有效"},
		};

	sSql = "Select "+
			"DONO,"+
			"DONAME,"+
			"DODESCRIBE,"+
			"DOTYPE,"+
			"DOARGUMENTS,"+
			"DOATTRIBUTE,"+
			"DOUPDATETABLE,"+
			"DOUPDATEWHERE,"+
			"DOFROMCLAUSE,"+
			"DOWHERECLAUSE,"+
			"DOGROUPCLAUSE,"+
			"DOORDERCLAUSE,"+
			"REMARK,"+
			"DOCLASS,"+
			"MODIFYAUDITTABLE,"+
			"MODIFYMODECRITERIA,"+
			"DELETEAUDITTABLE,"+
			"DELETEMODECRITERIA,"+
			"ISINUSE "+
			"From DATAOBJECT_CATALOG Where DoNo = '"+sDoNo+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="DATAOBJECT_CATALOG";
	doTemp.setKey("DONO",true);
	doTemp.setHeader(sHeaders);

	doTemp.setDDDWCode("DOTYPE","DOType");
	doTemp.setDDDWCode("DOUPDATEWHERE","DoUpdateWhere");
	doTemp.setDDDWCode("DOCLASS","DOClass");
	doTemp.setDDDWCode("ISINUSE","IsInUse");

	doTemp.setHTMLStyle("DONAME"," style={width:150px} ");
	doTemp.setHTMLStyle("DONO"," style={width:120px} ");
	doTemp.setHTMLStyle("DODESCRIBE,DOWHERECLAUSE,DOGROUPCLAUSE,DOORDERCLAUSE"," style={width:600px} ");

	doTemp.setEditStyle("REMARK","3");
	doTemp.setHTMLStyle("REMARK"," style={height:100px;width:600px;overflow:scroll} ");
 
 	doTemp.setRequired("DONO",true);
	if (sDoNo.equals("") || sDoNo.equals("null")) 
	{
 	  	doTemp.setRequired("DONO",true);
		doTemp.setReadOnly("DONO",false);
 	  	
	}else{
		doTemp.setRequired("DONO",false);
		doTemp.setReadOnly("DONO",true);
	}
	//filter过滤条件
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateDOUpdateTime("+StringFunction.getTodayNow()+","+CurUser.UserID+","+sDoNo+")");

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath}
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
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
	    as_save("myiframe0","");
	}
    
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
            setItemValue(0,0,"DOCLASS","10");
            setItemValue(0,0,"ISINUSE","1");
            
            bIsInsert = true;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
