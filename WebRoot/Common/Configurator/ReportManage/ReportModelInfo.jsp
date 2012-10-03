<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    财务报表模型详情
		Input Param:
                    ModelNo：    报表记录编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "财务报表模型详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	
	//获得组件参数	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	String sRowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RowNo"));
	if(sModelNo==null) sModelNo="";
	if(sRowNo==null) sRowNo="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders={
			{"ModelNo","模型编号"},
			{"RowNo","行编号"},
			{"RowName","行名称"},
			{"RowSubject","对应科目"},
			{"RowSubjectName","对应科目"},
			{"DisplayOrder","显示次序"},
			{"RowAttribute","行属性"},
			{"Col1Def","列1定义"},
			{"Col2Def","列2定义"},
			{"Col3Def","列3定义"},
			{"Col4Def","列4定义"},
			{"StandardValue","标准值"},
			{"DeleteFlag","删除标志"},
		};

	sSql = "Select "+
			"RM.ModelNo,"+
			"RM.RowNo,"+
			"RM.RowName,"+
			"RM.RowSubject,"+
			"FI.ItemName as RowSubjectName,"+
			"RM.DisplayOrder,"+
			"RM.RowAttribute,"+
			"RM.Col1Def,"+
			"RM.Col2Def,"+
			"RM.Col3Def,"+
			"RM.Col4Def,"+
			"RM.StandardValue,"+
			"RM.DeleteFlag "+
			" From REPORT_MODEL RM,FINANCE_ITEM FI "+
			" Where RM.RowSubject = FI.ItemNo and RM.ModelNo = '"+sModelNo+"' And RM.RowNo = '"+sRowNo+"' Order by 2";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REPORT_MODEL";
	doTemp.setKey("ModelNo,RowNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setReadOnly("ModelNo",true);

	doTemp.setRequired("RowNo,RowName",true);   //必输项
	doTemp.setVisible("ModelNo,RowSubject,Col3Def,Col4Def,DeleteFlag",false);
	doTemp.setEditStyle("Col1Def,Col2Def,Col3Def,Col4Def","3");
	doTemp.setHTMLStyle("ModelNo,RowNo,RowSubject,DisplayOrder,StandardValue,DeleteFlag"," style={width:60px} ");
	doTemp.setHTMLStyle("RowName"," style={width:200px} ");
	doTemp.setHTMLStyle("RowAttribute"," style={width:300px} ");
	doTemp.appendHTMLStyle("Col1Def,Col2Def,Col3Def,Col4Def","style={cursor:hand;width=600px;height=100px;overflow:scroll} onDBLClick=\"parent.myDBLClick(this)\"");
	
	doTemp.setUnit("RowSubjectName"," <input type=button class=inputdate value=... onclick=parent.SelectSubject()>");
	doTemp.setReadOnly("RowSubjectName",true);
	doTemp.setUpdateable("RowSubjectName",false);
	
	doTemp.setDDDWCodeTable("DeleteFlag","Y,Y,N,N");
	
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
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
		// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回代码列表","doReturn('N')",sResourcesPath}
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
		OpenComp("ReportModelInfo","/Common/Configurator/ReportManage/ReportModelInfo.jsp","ModelNo="+sModelNo,"_self","");
	}

	function myDBLClick(myobj)
	{
		editObjectValueWithScriptEditorForAFS(myobj,'<%=sModelNo%>');
	}

	function openScriptEditorForAFSAndSetText()
	{
		var oMyobj = oTempObj;
		sOutPut = OpenComp("ScriptEditorForAFS","/Common/ScriptEditor/ScriptEditorForAFS.jsp","","");
		if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_")
		{
			oMyobj.value = amarsoft2Real(sOutPut);
		}
	}

	function SelectSubject()
	{		
		setObjectValue("SelectAllSubject","","@RowSubject@0@RowSubjectName@1",0,0,"");			
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	function initRow()
	{
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
