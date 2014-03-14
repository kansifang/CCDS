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
	//获得组件参数
	String sObjectType=DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"))); 
	String sObjectNo=DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")));
	//获得页面参数，文档编号和文档录入人ID
	String sDocNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocNo")));
	String sUserID =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID")));
	String sAutoFinish =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AutoFinish")));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sHeaders[][] = {
	                            {"DocTitle","文档名称"},
	                            {"DocType","文档类型"},
	                            {"DocImportance","文档重要性"},
	                            {"DocSource","文档来源"},
	                            {"DocUnit","编制单位"},
	                            {"DocDate","新建日期"},
	                            {"DocAttribute","文档性质"},
	                            {"Remark","备注"},
	                            {"UserName","登记人"},
	                            {"OrgName","登记机构"},
	                            {"InputTime","登记日期"},
	                            {"UpdateTime","更新日期"}
	                          };

	    String sSql = " select DocNo,DocTitle,DocImportance,DocSource,DocUnit,DocDate,DocAttribute," +
	                  " Remark,OrgID,OrgName,UserID,UserName,InputTime,UpdateTime from DOC_LIBRARY "+
	                  " where DocNo = '" + sDocNo + "' ";
		//产生ASDataObject对象doTemp
	   	ASDataObject doTemp = new ASDataObject(sSql);
	   	//定义表头
		doTemp.setHeader(sHeaders);
		//设置可更新的表
		doTemp.UpdateTable = "DOC_LIBRARY";
		//设置关键字
		doTemp.setKey("DocNo",true);
		//设置是否可见
		doTemp.setVisible("DocNo,OrgID,UserID",false);
		//设置必输项
		doTemp.setRequired("DocTitle",true);

		//下拉框设置
		//doTemp.setDDDWCode("DocType","DocStyle");
		doTemp.setDDDWCode("DocImportance","DocImportance");
		doTemp.setDDDWSql("DocAttribute","select ItemNo,ItemName from Code_Library where CodeNo = 'DocumentKind' and ItemNo <>'02' and IsInUse='1'");
		doTemp.setDefaultValue("DocImportance","01");

	    //编辑形式为备注栏，对应显示模版中的编辑形式1、文本框，2、选择框，3、备注栏，初始为文本框
		doTemp.setEditStyle("Remark","3");
		//设置只读属性
		doTemp.setReadOnly("OrgName,UserName,InputTime,UpdateTime",true);
		//设置日期型，对应显示模版中的格式1、字符串，2数字（带小数），3、日期，4、时间，5、整型数字
		doTemp.setCheckFormat("DocDate","3");
		//置html格式
		doTemp.setEditStyle("Remark","3");
		doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px};overflow:scroll ");
		doTemp.setHTMLStyle("DocTitle,DocSource"," style={width:200px}");
		doTemp.setHTMLStyle("UserName,AttachmentCount,InputTime,UpdateTime"," style={width:80px} ");
		doTemp.setLimit("Remark",200);
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //设置为freeform风格
		dwTemp.ReadOnly = "0"; //设置为非只读

		dwTemp.setEvent("AfterInsert","!DocumentManage.InsertDocRelative(#DocNo,"+sObjectType+","+sObjectNo+")");

		Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{(CurUser.UserID.equals(sUserID)?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{(CurUser.UserID.equals(sUserID)?"true":"false"),"","Button","查看/修改附件","查看/修改选中文档相关的所有附件","viewAndEdit_attachment()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","doReturn()",sResourcesPath}
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
		if (!ValidityCheck()) return;
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
		var sUerID = getItemValue(0,getRow(),"UserID");//取录入人ID
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{
        	alert("请先保存文档内容，再上传附件！");  //请选择一条记录！
			return;
    	}
    	else
    	{
			popComp("AttachmentList","/Common/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUerID);
			//reloadSelf();
		}
	}
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		parent.sObjectInfo = sDocNo;
		parent.closeAndReturn();
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

	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		//校验编制日期是否大于当前日期
		sDocDate = getItemValue(0,0,"DocDate");//编制日期
		sToday = "<%=StringFunction.getToday()%>";//当前日期
		if(typeof(sDocDate) != "undefined" && sDocDate != "" )
		{
			if(sDocDate > sToday)
			{
				alert(getBusinessMessage('161'));//编制日期必须早于当前日期！
				return false;
			}
		}

		return true;
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
		var sPrefix = "";//前缀

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
	//批量文件后台直接执行，以节省时间
	/*
	if("<%=sAutoFinish%>"=="true"){
		setItemValue(0,0,"DocTitle","批量文件_<%=StringFunction.getNow()%>");
		setItemValue(0,0,"DocAttribute","02");
		saveRecord();
		bCheckBeforeUnload=false;
		doReturn();
	}
	*/
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>