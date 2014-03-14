<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   CYHui  2003.8.18
			Tester:
			Content: 字段_List
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
	
	//获得页面参数	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = {
		{"DatabaseID","数据ID"},	
		{"TableID","表ID"},
		{"ColID","字段名"},
		{"ColName","字段中文名"},
		{"IsInUse","有效"},
		{"SortNo","排序号"},
		{"ColType","字段类型"},
		{"DomainID","域类型"},
		{"DefaultValue","缺省值"},
		{"CheckFormat","检查格式"},
		{"ValidationType","校验类型"},
		{"ValidationCode","校验代码"},
		{"ColLimit","长度限制"},
		{"ColKey","是否关键字"},
		{"IsForeignKey","是否外键"},
		{"DataPrecision","有效位数"},
		{"DataScale","小数点后位数"},
		{"Attribute1","属性1"},
		{"Attribute2","属性2"},
		{"Attribute3","属性3"},
		{"Attribute4","属性4"},
		{"Attribute5","属性5"},
	       };  

	sSql = " Select  "+
		"DatabaseID,"+
		"TableID,"+
		"ColID,"+
		"ColName,"+
		"IsInUse,"+
		"SortNo,"+
		"ColType,"+
		"DomainID,"+
		"DefaultValue,"+
		"CheckFormat,"+
		"ValidationType,"+
		"ValidationCode,"+
		"ColLimit,"+
		"ColKey,"+
		"IsForeignKey,"+
		"DataPrecision,"+
		"DataScale,"+
		"Attribute1,"+
		"Attribute2,"+
		"Attribute3,"+
		"Attribute4,"+
		"Attribute5 "+
		"From META_COLUMN where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="META_COLUMN";
	doTemp.setKey("DatabaseID,TableID,ColID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DatabaseID"," style={width:160px} ");
	doTemp.setHTMLStyle("TableID"," style={width:160px} ");
	doTemp.setHTMLStyle("ColID"," style={width:160px} ");
	doTemp.setHTMLStyle("ColName"," style={width:160px} ");
	doTemp.setHTMLStyle("IsInUse"," style={width:160px} ");
	doTemp.setHTMLStyle("SortNo"," style={width:160px} ");
	doTemp.setHTMLStyle("ColType"," style={width:160px} ");
	doTemp.setHTMLStyle("DomainID"," style={width:160px} ");
	doTemp.setHTMLStyle("DefaultValue"," style={width:160px} ");
	doTemp.setHTMLStyle("CheckFormat"," style={width:160px} ");
	doTemp.setHTMLStyle("ValidationType"," style={width:160px} ");
	doTemp.setHTMLStyle("ValidationCode"," style={width:160px} ");
	doTemp.setHTMLStyle("ColLimit"," style={width:160px} ");
	doTemp.setHTMLStyle("ColKey"," style={width:160px} ");
	doTemp.setHTMLStyle("IsForeignKey"," style={width:160px} ");
	doTemp.setHTMLStyle("DataPrecision"," style={width:160px} ");
	doTemp.setHTMLStyle("DataScale"," style={width:160px} ");
	doTemp.setHTMLStyle("Attribute1"," style={width:160px} ");
	doTemp.setHTMLStyle("Attribute2"," style={width:160px} ");
	doTemp.setHTMLStyle("Attribute3"," style={width:160px} ");
	doTemp.setHTMLStyle("Attribute4"," style={width:160px} ");
	doTemp.setHTMLStyle("Attribute5"," style={width:160px} ");

	//设置小数显示状态,
	doTemp.setAlign("DataPrecision,DataScale","3");
	doTemp.setType("DataPrecision,DataScale","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("DataPrecision,DataScale","2");

	//设置不可见项
	doTemp.setVisible("DefaultValue,CheckFormat,ValidationType,ValidationCode,ColLimit,ColKey,IsForeignKey,DataPrecision,DataScale,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5",false);	    
	

	//查询
 	doTemp.setColumnAttribute("DatabaseID,TableID,ColID,DataPrecision","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" And 1=2";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
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

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		popComp("MetaColumnInfo","/Common/Configurator/MetaDataManage/MetaColumnInfo.jsp","","");
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sColID = getItemValue(0,getRow(),"ColID");
		
		if (typeof(sColID)=="undefined" || sColID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sDatabaseID=getItemValue(0,getRow(),"DatabaseID");
		sTableID=getItemValue(0,getRow(),"TableID");
		sColumnID=getItemValue(0,getRow(),"ColID");
		if (typeof(sColumnID)=="undefined" || sColumnID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("MetaColumnInfo","/Common/Configurator/MetaDataManage/MetaColumnInfo.jsp","DatabaseID="+sDatabaseID+"&TableID="+sTableID+"&ColumnID="+sColumnID,"");
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>

	
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
