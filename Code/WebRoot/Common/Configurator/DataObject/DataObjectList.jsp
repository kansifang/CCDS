<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: 显示模板目录列表
		Input Param:
                  
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
	String sDoName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoName"));
	String sDoNo2 =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo2"));

	if(sDoNo==null) sDoNo="";
	if(sDoName==null) sDoName="";
    if (sDoNo2==null) sDoNo2=""; 
    
	//获得页面参数	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String[][] sHeaders={
			{"DoNo","DO编号"},
			{"DoName","DO名称"},
			{"DoDescribe","DO描述"},
			{"DoType","DO类别"},
			{"DoArguments","DO参数"},
			{"DoAttribute","DO属性"},
			{"DoUpdateTable","更新目标表"},
			{"DoUpdateWhere","更新方式"},
			{"DoFromClause","DOFrom子句"},
			{"DoWhereClause","DOWhere子句"},
			{"DoGroupClause","DOGroup子句"},
			{"DoOrderClause","DOOrder子句"},
			{"Remark","备注"},
			{"DoClass","类型"},
			{"ModifyAuditTable","修改审计表"},
			{"ModifyModeCriteria","修改审计条件"},
			{"DeleteAuditTable","删除审计表"},
			{"DeleteModeCriteria","删除审计条件"},
			{"IsInUse","有效"},
		};

	sSql = "Select "+
			"DoNo,"+
			"DoName,"+
			"DoDescribe,"+
			"getItemName('DOType',DoType) as DoType,"+
			"DoArguments,"+
			"DoAttribute,"+
			"DoUpdateTable,"+
			"getItemName('DoUpdateWhere',DoUpdateWhere) as DoUpdateWhere,"+
			"DoFromClause,"+
			"DoWhereClause,"+
			"DoGroupClause,"+
			"DoOrderClause,"+
			"Remark,"+
			"getItemName('DOClass',DoClass) as DoClass,"+
			"ModifyAuditTable,"+
			"ModifyModeCriteria,"+
			"DeleteAuditTable,"+
			"DeleteModeCriteria,"+
			"getItemName('IsInUse',IsInUse) as IsInUse "+
			"From DATAOBJECT_CATALOG where 1=1";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="DATAOBJECT_CATALOG";
	doTemp.setKey("DoNo",true);
	doTemp.setHeader(sHeaders);

	//隐藏
	doTemp.setVisible("Remark,ModifyAuditTable,ModifyModeCriteria,DeleteAuditTable,DeleteModeCriteria",false);    	

	doTemp.setHTMLStyle("DoName"," style={width:150px} ");
	doTemp.setHTMLStyle("DoNo"," style={width:120px} ");
	doTemp.setHTMLStyle("DoType,DoUpdateWhere,DoClass,IsInUse"," style={width:60px} ");
	doTemp.setHTMLStyle("DoWhereClause"," style={width:260px} ");


	//查询
 	doTemp.setColumnAttribute("DoNo,DoName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelDOLibrary(#DoNo)");
	
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
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","从元数据生成","从元数据生成","generateFromMetaData()",sResourcesPath}
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
        OpenComp("DataObjectView","/Common/Configurator/DataObject/DataObjectView.jsp","","");
		reloadSelf();
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sDoNo = getItemValue(0,getRow(),"DoNo");
        if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        openObject("DataObject",sDoNo,"001");
	}
    

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sDoNo = getItemValue(0,getRow(),"DoNo");
        if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
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

	function generateFromMetaData()
	{
		sDoNo = getItemValue(0,getRow(),"DoNo");
        	if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            		return ;
		}
		sMetaData = popComp("MetaTableSelect","/Common/Configurator/MetaDataManage/MetaTableSelectionList.jsp","","");
		if(typeof(sMetaData)=="undefined" || sMetaData=="_CANCEL_") return;
		alert(sMetaData);
		sMetaDatas = sMetaData.split("@");
		sMetaDatabase = sMetaDatas[0];
		sMetaTable = sMetaDatas[1];
		sReturn = PopPage("/Common/Configurator/DataObject/GenerateFromMetaData.jsp?DatabaseID="+sMetaDatabase+"&TableID="+sMetaTable+"&DoNo="+sDoNo,"","");
		if(sReturn=="succeeded"){
			if(confirm("成功生成数据对象！\n\n打开编辑吗？")) viewAndEdit();
		}
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
<%
    if(!doTemp.haveReceivedFilterCriteria()) {
%>
	showFilterArea();
<%
	}	
%>
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
