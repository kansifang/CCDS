<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: 王业罡　2005-08-17
			Tester:
			Describe:文档基本信息
			Input Param:
			     ObjectNo: 对象编号
	             ObjectType: 对象类型
	             DocNo: 文档编号
			Output Param:
			HistoryLog:

		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "文档基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sObjectNo = "";//--对象编号
	//获得组件参数
	//获得页面参数，文档编号和文档录入人ID
	String sDocNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocNo")));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
<%
	String sTempletNo = "QDocument";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
   	//定义表头
	//下拉框设置
	//doTemp.setDDDWCode("DocType","DocStyle");
	doTemp.setDDDWCode("DocImportance","DocImportance");
	doTemp.setDDDWCode("DocAttribute","DocumentKind");
	doTemp.setDefaultValue("DocImportance","01");

	//设置只读属性
	doTemp.setReadOnly("OrgName,UserName,InputTime,UpdateTime",true);
	//置html格式
	doTemp.setHTMLStyle("DocTitle,DocSource"," style={width:200px}");
	doTemp.setHTMLStyle("UserName,AttachmentCount,InputTime,UpdateTime"," style={width:80px} ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置为freeform风格
	dwTemp.ReadOnly = "0"; //设置为非只读

	Vector vTemp = dwTemp.genHTMLDataWindow(""+sDocNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","查看/修改所有定义","查看/修改所有查询定义","viewAndEdit_attachment()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		//录入数据有效性检查
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=查看附件详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit_attachment()
	{
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{
        	alert("请选择一条记录！");  //请选择一条记录！
			return;
    	}
    	else
    	{
			popComp("QDefinitionList","/Common/Configurator/MetaDataManage/QDefinitionList.jsp","docNo="+sDocNo);
			//reloadSelf();
		}
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/Common/Configurator/MetaDataManage/QDocumentList.jsp","_self","");
	}

	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	}

	function initRow()
	{
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"DocImportance","01");
			setItemValue(0,0,"DocDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo()
	{
		var sTableName = "DOC_LIBRARY";//表名
		var sColumnName = "DocNo";//字段名
		var sPrefix = "QDT";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sDocNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sDocNo);
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/
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