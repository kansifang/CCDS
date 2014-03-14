<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: 代码表信息详情
			Input Param:
	                    CodeNo：    代码表编号
	                    ItemNo：    项目编号（新增是不传入）
			Output param:         
			History Log: zywei 2005/07/28 添加一个主键字段ColIndex
	            
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
	String sSql;
	String sSortNo; //排序编号
	
	//获得组件参数	
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
	String sColIndex =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ColIndex"));

	if(sDoNo==null) sDoNo="";
	if(sColIndex==null) sColIndex="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders={
	{"DoNo","DO编号"},
	{"ColIndex","列号"},
	{"ColAttribute","属性"},
	{"ColTableName","数据表名"},
	{"ColActualName","数据库源名"},
	{"ColName","使用名"},
	{"ColType","值类型"},
	{"ColDefaultValue","缺省值"},
	{"ColHeader","中文名称"},
	{"ColUnit","显示后缀"},
	{"ColColumnType","是否Sum"},
	{"ColCheckFormat","检查格式"},
	{"ColAlign","对齐"},
	{"ColEditStyle","编辑形式"},
	{"ColEditSourceType","下拉框来源"},
	{"ColEditSource","来源描述"},
	{"ColHtmlStyle","HTML格式"},
	{"ColLimit","长度"},
	{"ColKey","关键字"},
	{"ColUpdateable","可更新"},
	{"ColVisible","可见"},
	{"ColReadOnly","只读"},
	{"ColRequired","必须"},
	{"ColSortable","排序"},
	{"ColCheckItem","检查"},
	{"ColTransferBack","回传"},
	{"IsForeignKey","是否外键"},
	{"SortNo","字段序"},
	{"IsInUse","是否有效"},
	{"DataPrecision","有效位"},
	{"DataScale","小数位"},
	{"Attribute1","过滤器1"},
	{"Attribute2","过滤器2"},
	{"Attribute3","过滤器3"},
	{"IsFilter","是否设成检索条件"}
		};

	sSql =  " select DoNo,ColIndex,ColAttribute,ColTableName,ColActualName,ColName,ColType, "+
	" ColDefaultValue,ColHeader,ColUnit,ColColumnType,ColCheckFormat,ColAlign,ColEditStyle, "+
	" ColEditSourceType,ColEditSource,ColHtmlStyle,ColLimit,ColKey,ColUpdateable,ColVisible, "+
	" ColReadOnly,ColRequired,ColSortable,ColCheckItem,ColTransferBack,IsForeignKey,SortNo, "+
	" IsInUse,DataPrecision,DataScale,Attribute1,Attribute2,Attribute3,IsFilter "+
	" from DATAOBJECT_LIBRARY "+
	" where DoNo = '"+sDoNo+"' "+
	" and ColIndex = '"+sColIndex+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="DataObject_Library";
	doTemp.setKey("DoNo,ColIndex",true);
	doTemp.setHeader(sHeaders);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
 	doTemp.setRequired("DoNo,ColIndex",true); 	
	if (!sDoNo.equals("")) 
	{
 	  	doTemp.setRequired("DoNo",false);
		doTemp.setReadOnly("DoNo",true);
	}

	doTemp.setDDDWCode("ColType","DataType");	
	doTemp.setDDDWCode("ColColumnType","ColumnType");
	doTemp.setDDDWCode("ColCheckFormat","CheckFormat");
	doTemp.setDDDWCode("ColAlign","ColAlign");
	doTemp.setDDDWCode("ColEditStyle","ColEditStyle");
	doTemp.setDDDWCode("ColEditSourceType","ColEditSourceType");
	doTemp.setDDDWCode("ColKey","TrueFalse");
	doTemp.setDDDWCode("ColUpdateable","TrueFalse");
	doTemp.setDDDWCode("ColVisible","TrueFalse");
	doTemp.setDDDWCode("ColReadOnly","TrueFalse");
	doTemp.setDDDWCode("ColRequired","TrueFalse");
	doTemp.setDDDWCode("ColSortable","TrueFalse");
	doTemp.setDDDWCode("ColCheckItem","TrueFalse");
	doTemp.setDDDWCode("ColTransferBack","TrueFalse");
	doTemp.setDDDWCode("IsForeignKey","TrueFalse");
	doTemp.setDDDWCode("IsFilter","TrueFalse");
	doTemp.setDDDWCode("IsInUse","IsInUse");
	//设置列宽度
	doTemp.setHTMLStyle("ColAttribute"," style={width:400px} ");	
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateDOUpdateTime("+StringFunction.getTodayNow()+","+CurUser.UserID+","+sDoNo+")");
	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo+","+sColIndex);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()",sResourcesPath},
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
    var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
	    as_save("myiframe0");        
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndReturn()
	{
	    as_save("myiframe0","doReturn('Y');");
        
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"DoNo");
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
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
           setItemValue(0,0,"DoNo","<%=sDoNo%>");            
            setItemValue(0,0,"ColKey","0");
            setItemValue(0,0,"ColVisible","1");
            setItemValue(0,0,"ColReadOnly","0");
            setItemValue(0,0,"ColRequired","0");
            setItemValue(0,0,"ColSortable","1");
            setItemValue(0,0,"ColCheckItem","0");
            setItemValue(0,0,"ColTransferBack","0");
            setItemValue(0,0,"IsForeignKey","0");
            setItemValue(0,0,"IsInUse","1");
            setItemValue(0,0,"ColColumnType","1");
            setItemValue(0,0,"ColCheckFormat","1");
            setItemValue(0,0,"ColAlign","1");
            setItemValue(0,0,"ColEditStyle","1");            
            setItemValue(0,0,"ColType","String");
            setItemValue(0,0,"ColUpdateable","1");
            setItemValue(0,0,"ColLimit","0");
            setItemValue(0,0,"IsFilter","0");
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
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
