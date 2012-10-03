<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei 2005-11-27
		Tester:
		Content: 列表查询选择
		Input Param:
                  
		Output param:
		                
		History Log: 
		  zywei 2007/10/11 新增Attribute4为是否根据检索条件查询，即解决大数据量查询引起的响应延迟
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
	
	//获得组件参数	
	
	//获得页面参数	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String[][] sHeaders={
				{"SelName","查询名称"},
				{"SelDescribe","查询说明"},
				{"SelType","查询类型"},
				{"SelTableName","查询表名"},
				{"SelPrimaryKey","主键"},
				{"SelBrowseMode","展现方式"},
				{"SelArgs","参数"},
				{"SelHideField","隐藏域"},				
				{"SelCode","查询实现代码"},
				{"SelFieldName","列表显示标题"},
				{"SelFieldDisp","列表显示风格"},
				{"SelReturnValue","返回域"},
				{"SelFilterField","检索域"},
				{"MutilOrSingle","选择模式"},
				{"Attribute1","显示字段对齐方式"},
				{"Attribute2","显示字段类型"},
				{"Attribute3","显示字段检查模式"},	
				{"Attribute4","是否根据检索条件查询"},
				{"IsInUse","是否有效"}			
			};

	sSql =  " select SelName,SelDescribe,SelType,SelTableName,SelPrimaryKey,SelBrowseMode, "+
			" SelArgs,SelHideField,SelCode,SelFieldName,SelFieldDisp,SelReturnValue, "+
			" SelFilterField,MutilOrSingle,Attribute1,Attribute2,Attribute3, "+
			" getItemName('YesNo',Attribute4) as Attribute4, "+
			" getItemName('IsInUse',IsInUse) as IsInUse "+
			" from SELECT_CATALOG "+
			" where SelBrowseMode = 'Grid' "+
			" order by UpdateTime desc ";

	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.UpdateTable="SELECT_CATALOG";
	doTemp.setKey("SelName",true);
	doTemp.setHeader(sHeaders);

	//查询
 	doTemp.setColumnAttribute("SelName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//定义后续事件
	
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
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath}
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
		OpenPage("/Common/Configurator/SelectManage/GridSelectInfo.jsp","_self","");      
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sSelName = getItemValue(0,getRow(),"SelName");
        if(typeof(sSelName) == "undefined" || sSelName.length == 0) 
        {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
        
        OpenPage("/Common/Configurator/SelectManage/GridSelectInfo.jsp?SelName="+sSelName,"_self","");           
	}
    
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSelName = getItemValue(0,getRow(),"SelName");
        if(typeof(sSelName) == "undefined" || sSelName.length == 0) 
        {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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
