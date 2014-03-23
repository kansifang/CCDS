<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: 代码目录列表
			Input Param:
	                  
			Output param:
			                
			History Log: 
			wuxiong 2005-02-19
	            
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
		
	//获得页面参数	
	String sCodeTypeOne =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeTypeOne"));
	String sCodeTypeTwo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeTypeTwo"));
	//将空值转化为空字符串	
	if (sCodeTypeOne == null) sCodeTypeOne = ""; 
	if (sCodeTypeTwo == null) sCodeTypeTwo = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders={
		{"CodeNo","配置号"},
		{"CodeName","配置名称"},
		{"SortNo","文件类型"},
		{"CodeDescribe","系统展示要素"},
		{"CodeAttribute","配置类型"},
		{"UpdateUserName","更新人"},
		{"UpdateUser","更新人"},
		{"UpdateTime","更新时间"}
	};

	sSql = "Select "+
		   "CodeNo,"+
		   "CodeName,"+
		   "getItemName('SModelFileType',SortNo) as SortNo,"+
		   "CodeDescribe,CodeAttribute "+
		   "from CODE_CATALOG "+
		   "Where CodeNo like 'b%'";
	ASDataObject doTemp = new ASDataObject(sSql);
	//doTemp.multiSelectionEnabled=false;
	doTemp.UpdateTable="CODE_CATALOG";
	doTemp.setKey("CodeNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCodeTable("CodeAttribute","01,导入对应配置,02,字段维护");
	//doTemp.setHTMLStyle("CodeAttribute"," style={width:160px} ");
	doTemp.setHTMLStyle("CodeNo,CodeName,SortNo,CodeDescribe,CodeAttribute"," style={width:120px;height:20px;overflow:auto;cursor:hand} onDBLClick=\"parent.viewConfigList()\"");
	//查询
 	doTemp.setColumnAttribute("CodeNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
   	doTemp.setVisible("CodeDescribe",false);  
   	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(50);
	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelCodeLibrary(#CodeNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//added by bllou 2012-09-20 显示细项
	CurPage.setAttribute("ShowDetailArea","false");
	CurPage.setAttribute("DetailAreaHeight","150");
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"false","","Button","代码列表","查看/修改代码详情","viewAndEditCode()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"true","","Button","导出","导出所选中的记录","exportDataObject()",sResourcesPath}
			//{"true","","Button","生成SortNo","生成SortNo","GenerateCodeCatalogSortNo()",sResourcesPath}
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
	var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{	        	
        sReturn=popComp("BatchCatalogInfo","/BusinessManage/BatchCatalogInfo.jsp","","dialogWidth=35;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
        reloadSelf();
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sCodeNo = getItemValue(0,getRow(),"CodeNo");
        sCodeName = getItemValue(0,getRow(),"CodeName");
        if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) 
        {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
	    popComp("BatchCatalogInfo","/BusinessManage/BatchCatalogInfo.jsp","CodeNo="+sCodeNo,"");
	    reloadSelf(); 
	}
    
    /*~[Describe=查看及修改代码详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditCode()
	{
        sCodeNo = getItemValue(0,getRow(),"CodeNo");
        sCodeName = getItemValue(0,getRow(),"CodeName");
        if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) 
        {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		popComp("CodeItem","/Common/Configurator/CodeManage/CodeItemList.jsp","CodeNo="+sCodeNo+"&CodeName="+sCodeName,"");  
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCodeNo = getItemValue(0,getRow(),"CodeNo");
		if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) 
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

	function exportDataObject()
	{
		sCodeNo = getItemValue(0,getRow(),"CodeNo");
        if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0 ) 
        {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		sServerRoot = "";
		sReturn = PopPage("/Common/Configurator/ObjectExim/ExportDataObject.jsp?ObjectType=Code&ObjectNo="+sCodeNo+"&ServerRootPath="+sServerRoot,"","");
		if(sReturn=="succeeded"){
			alert("成功导出数据！");
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
	function GenerateCodeCatalogSortNo(){
		RunMethod("Configurator","GenerateCodeCatalogSortNo","");
	}
	
	function mySelectRow()
	{
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
		var sType = getItemValue(0,getRow(),"CodeAttribute");
		if(sCodeNo.length>0){
			document.getElementById("ListHorizontalBar").parentNode.style.display="";
			document.getElementById("ListDetailAreaTD").parentNode.style.display="";
			OpenComp("BatchConfigList","/BusinessManage/BatchConfigList.jsp","CodeNo="+sCodeNo+"&type="+sType,"DetailFrame","");
		}
	}
	function viewConfigList(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
		var sType = getItemValue(0,getRow(),"CodeAttribute");
		if(sCodeNo.length>0){
			popComp("BatchConfigList","/BusinessManage/BatchConfigList.jsp","CodeNo="+sCodeNo+"&type="+sType,"","");
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
	bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	mySelectRow();
	//hideFilterArea();
</script>	
<%
		/*~END~*/
%>

<%@ include file="/IncludeEnd.jsp"%>
