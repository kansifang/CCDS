<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   zxu 2005-07-01
			Tester:
			Content: 对象导出资源列表
			Input Param:
	                  
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
		String PG_TITLE = "对象导出资源列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	
    //获得页面参数	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType==null) sObjectType="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders = {
		{"ObjectType","对象类型"},
		{"SortNo","顺序号"},
		{"TableID","数据表名"},
		{"ExportSql","导出用Sql"},
		{"BeforeImpSql","导入时预处理Sql"},
		{"EffStatus","有效标志"}
	};
	
	sSql =  "select "+
	"ObjectType,"+
	"SortNo,"+
	"TableID,"+
	"ExportSql,"+
	"BeforeImpSql,"+
	"EffStatus "+
		" from OBJECT_RES_LIST where 1=1 order by ObjectType,SortNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "OBJECT_RES_LIST";
	doTemp.setKey("ObjectType,SortNo",true);
	doTemp.setHeader(sHeaders);
	
	//查询
 	doTemp.setColumnAttribute("ObjectType,SortNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	doTemp.setDDDWCode("EffStatus","TrueFalse");
	doTemp.setHTMLStyle("ExportSql"," style={width:320px} ");

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);
    
	//定义后续事件
	//dwTemp.setEvent("BeforeDelete","!Configurator.DelSightRight(#RightID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回","doReturn('N')",sResourcesPath}
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
	var sCurMethodNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		sReturn=popComp("ObjectResInfo","/Common/Configurator/ObjectExim/ObjectResInfo.jsp","","");
		//修改数据后刷新列表
		reloadSelf();
	}
	
        /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sSortNo = getItemValue(0,getRow(),"SortNo");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0 || typeof(sSortNo)=="undefined" || sSortNo.length==0 ) {
		alert(getHtmlMessage('1'));//请选择一条信息！
                return ;
	    }
		sReturn=popComp("ObjectResInfo","/Common/Configurator/ObjectExim/ObjectResInfo.jsp","ObjectType="+sObjectType+"&SortNo="+sSortNo,"");
            //修改数据后刷新列表
	    reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sSortNo = getItemValue(0,getRow(),"SortNo");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0 || typeof(sSortNo)=="undefined" || sSortNo.length==0 ) {
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
	    sObjectNo = getItemValue(0,getRow(),"ObjectType");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
	    parent.closeAndReturn();
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
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
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
