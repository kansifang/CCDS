<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    财务报表目录信息详情
			Input Param:
	                    ModelNo：    报表记录编号
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
		String PG_TITLE = "财务报表目录信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	if(sModelNo==null) sModelNo="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders={
	{"MODELNO","模型编号"},
	{"MODELNAME","模型名称"},
	{"MODELTYPE","模型类型"},
	{"MODELDESCRIBE","模型描述"},
	{"MODELABBR","模型缩写"},
	{"MODELCLASS","模型分类"},
	{"ATTRIBUTE1","模型属性1"},
	{"ATTRIBUTE2","模型属性2"},
	{"DISPLAYMETHOD","显示方法"},
	{"HEADERMETHOD","表头描述"},
	{"DELETEFLAG","删除标志"},
	{"REMARK","备注"},	
		};

	sSql = "Select "+
	"MODELNO,"+
	"MODELNAME,"+
	"MODELTYPE,"+
	"MODELDESCRIBE,"+
	"MODELABBR,"+
	"MODELCLASS,"+
	"ATTRIBUTE1,"+
	"ATTRIBUTE2,"+
	"DISPLAYMETHOD,"+
	"HEADERMETHOD,"+
	"DELETEFLAG,"+
	"REMARK "+
	" From REPORT_CATALOG Where MODELNO = '"+sModelNo+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REPORT_CATALOG";
	doTemp.setKey("MODELNO",true);
	doTemp.setHeader(sHeaders);

	doTemp.setRequired("MODELNO",true);   //必输项
	doTemp.setVisible("DELETEFLAG",false);
	doTemp.setHTMLStyle("MODELNO,MODELTYPE,DELETEFLAG"," style={width:60px} ");
	doTemp.setHTMLStyle("MODELDESCRIBE"," style={width:400px} ");
	doTemp.setHTMLStyle("MODELCLASS"," style={width:120px} ");
	doTemp.setHTMLStyle("DISPLAYMETHOD"," style={width:80px} ");
	doTemp.setEditStyle("HEADERMETHOD,REMARK","3");
	doTemp.setHTMLStyle("HEADERMETHOD,REMARK","style={width=400px;height=100px;overflow=scroll}");

	doTemp.setDDDWSql("MODELTYPE","select ItemName,ItemName from CODE_LIBRARY where CodeNo = 'ReportPeriod' order by SortNo");
	doTemp.setDDDWSql("DISPLAYMETHOD","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'DisplayMethod' order by SortNo ");
	doTemp.setDDDWCode("MODELCLASS","FinanceBelong");
	doTemp.setDDDWCodeTable("DELETEFLAG","Y,是,N,否");

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

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
			{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
			{"false","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
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
	function saveRecord()
	{
	        as_save("myiframe0","");       
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
	        as_save("myiframe0","doReturn('N');");        
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndAdd()
	{
	        as_save("myiframe0","newRecord()");     
	}
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"MODELNO");
	        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    /*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
 	       OpenComp("ReportCatalogInfo","/Common/Configurator/ReportManage/ReportCatalogInfo.jsp","","_self","");
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
