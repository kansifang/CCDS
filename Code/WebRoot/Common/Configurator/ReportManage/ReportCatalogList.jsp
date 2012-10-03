<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: 财务模型目录列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "财务模型目录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	//获得组件参数

	//获得页面参数	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String[][] sHeaders={
			{"MODELNO","报表编号"},
			{"MODELNAME","报表名称"},
			{"MODELTYPE","报表类型"},
			{"MODELDESCRIBE","报表描述"},
			{"MODELABBR","报表缩写"},
			{"MODELCLASS","报表分类"},
			{"ATTRIBUTE1","备用属性1"},
			{"ATTRIBUTE2","备用属性2"},
			{"DISPLAYMETHOD","显示属性"},
			{"HEADERMETHOD","表头描述"},
			{"DELETEFLAG","删除标志"},
			{"REMARK","备注"},	
		};

	sSql = "Select "+
			"MODELNO,"+
			"MODELNAME,"+
			"getItemName('ReportPeriod',MODELTYPE) as MODELTYPE,"+
			"MODELDESCRIBE,"+
			"MODELABBR,"+
			"getItemName('FinanceBelong',MODELCLASS) as MODELCLASS,"+
			"ATTRIBUTE1,"+
			"ATTRIBUTE2,"+
			"getItemName('DisplayMethod',DISPLAYMETHOD) as DISPLAYMETHOD,"+
			"HEADERMETHOD,"+
			"DELETEFLAG,"+
			"REMARK "+
			" From REPORT_CATALOG where 1=1";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REPORT_CATALOG";
	doTemp.setKey("MODELNO",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("MODELNO,MODELTYPE,DELETEFLAG"," style={width:60px} ");
	doTemp.setHTMLStyle("MODELDESCRIBE,REMARK"," style={width:300px} ");
	doTemp.setHTMLStyle("HEADERMETHOD"," style={width:400px} ");
	doTemp.setHTMLStyle("MODELCLASS"," style={width:120px} ");
	doTemp.setHTMLStyle("DISPLAYMETHOD"," style={width:80px} ");
	doTemp.setVisible("MODELDESCRIBE,ATTRIBUTE1,ATTRIBUTE2,DELETEFLAG,REMARK",false);

	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	//查询
 	doTemp.setColumnAttribute("MODELNO","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelReportModel(#MODELNO)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
		{"true","","Button","模型列表","查看/修改模型列表","viewAndEdit2()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
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
		sReturn=popComp("ReportCatalogInfo","/Common/Configurator/ReportManage/ReportCatalogInfo.jsp","","");
		reloadSelf(); 
		//新增数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
		{
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
			{
				OpenPage("/Common/Configurator/ReportManage/ReportCatalogList.jsp","_self",""); 
			}
		}     
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sModelNo = getItemValue(0,getRow(),"MODELNO");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		//openObject("ReportCatalogView",sModelNo,"001");
		popComp("ReportCatalogView","/Common/Configurator/ReportManage/ReportCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0010","");
	}
    
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit2()
	{
		sModelNo = getItemValue(0,getRow(),"MODELNO");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		//popComp("ReportModelList","/Common/Configurator/ReportManage/ReportModelList.jsp","ModelNo="+sModelNo,"");
		popComp("ReportCatalogView","/Common/Configurator/ReportManage/ReportCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0020","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sModelNo = getItemValue(0,getRow(),"MODELNO");
	        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		        return ;
		}
		
		if(confirm(getHtmlMessage('49'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
