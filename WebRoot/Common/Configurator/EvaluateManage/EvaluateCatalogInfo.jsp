<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    评估模型目录详情
		Input Param:
                    ModelNo：    报表记录编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "评估模型目录详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
	//获得组件参数	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if(sModelNo==null) sModelNo="";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
   	String sHeaders[][] = {
				{"ModelNo","评估表编号"},
				{"ModelName","评估表名称"},
				{"ModelType","评估表类别"},
				{"ModelDescribe","评估表描述"},
				{"TransformMethod","转换方法"},
				{"Remark","备注"},
			       };  

	sSql = " Select  "+
				"ModelNo,"+
				"ModelName,"+
				"ModelType,"+
				"ModelDescribe,"+
				"TransformMethod,"+
				"Remark "+ 
				"From EVALUATE_CATALOG Where ModelNo = '"+sModelNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="EVALUATE_CATALOG";
	doTemp.setKey("ModelNo",true);
	doTemp.setHeader(sHeaders);

	if (!sModelNo.equals(""))
	{
		doTemp.setReadOnly("ModelNo",true);
	}
	else
	{
		doTemp.setRequired("ModelNo",true);
	}
	doTemp.setHTMLStyle("ModelNo"," style={width:160px} ");
	doTemp.setHTMLStyle("ModelName"," style={width:400px} ");
	doTemp.setHTMLStyle("ModelDescribe"," style={width:600px} ");
	doTemp.setEditStyle("TransformMethod,Remark","3");
	doTemp.setHTMLStyle("TransformMethod,Remark"," style={height:150px;width:600px;overflow:scroll} ");

	doTemp.setDDDWCode("ModelType","EvaluateModelType");	

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

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
		{"true","","Button","保存并返回","保存修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
		{"true","","Button","转换方法美化","转换方法美化","my_formatIF()",sResourcesPath},
        	// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回代码列表","doReturn('Y')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
    var sCurModelNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
        as_save("myiframe0","self.close();");
        
	}
    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
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
        OpenComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","","_self","");
	}

	function my_formatIF()
	{
		try{			
			var sValue = getItemValue(0,getRow(),"TransformMethod");
			sValue = sValue.replace(/\r\nif/g,"if"); 
			sValue = sValue.replace(/if/g,"\r\nif"); 
			sValue = sValue.replace("\r\n",""); 
			setItemValue(0,getRow(),"TransformMethod",sValue);	
		} catch(e){
		}	
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
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
