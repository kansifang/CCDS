
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: jytian 2004-12-21
			Tester:
			Describe:文档附件列表
			Input Param:
	       		文档编号:BatchNo
			Output Param:

			HistoryLog:zywei 2005/09/03 重检代码
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "文档附件列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	//获得页面参数
	
	//获得组件参数
	String sBatchNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BatchNo")));
	String sChangeNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
String sHeaders[][] = 	{ 
					       	{"BatchNo","批次号"},
					       	{"SerialNo","流水号"},
					       	{"ChangeNo","变更号"},
					       	{"SystemName","系统名称"},
					       	{"Status","变更状态"},
					       	{"Summary","摘要"},
					       	{"CreateDate","创建时间"},
					       	{"ChangeType","变更类型"},
					       	{"ChangeUser","变更申请人"},
					       	{"BusinessPriority","业务优先级"},
					       	{"FactoryPriority","厂商优先级"},
					       	{"FinallyTerm","最终实现期次"},
					       	{"ChangeConfirmDate","需求分析完成时间"},
					       	{"UATDate","厂商提交版本时间"},
					       	{"RelativeSystem","涉及相关系统"},
					       	{"ChangeConfirmPerson","厂商需求分析人员"},
					       	{"ChangeWorker","开发人员"},
					       	{"Problem","存在问题"},
					       	{"MeetingContent","讨论过程"},
					       	{"Remark","备注"},
					       	{"BranchSpecial","分行特色"},
					       	{"ChangeCondition","开发状态"},
					       	{"OutFactoryDate","上线版本"},
					       	{"FatherCNo","父变更号"},
					       	{"BusinessWriteCondition","业需编写情况"},
					       	{"SoftWriteCondition","软需编写情况"},
					       	{"SoftWriteDir","软需目录"},
					       	{"BusinessReviewResult","业务评审结果"},
					       	{"ProjectManagerReviewResult","项目负责人评审结果"},
					       	{"ChangeManagerReviewResult","需求组评审结果"},
					       	{"UpdateUserName","维护人"},
					       	{"UpdateTime","维护时间"}
						};    		                     
		//定义SQL语句
		sSql = 	" SELECT BatchNo,SerialNo,ChangeNo,"+
				" SystemName,Status,Summary,CreateDate,"+
				" ChangeType,ChangeUser,BusinessPriority,FactoryPriority,"+
				" FinallyTerm,ChangeConfirmDate,UATDate,RelativeSystem,"+
				" ChangeConfirmPerson,ChangeWorker,Problem,"+
				" MeetingContent,Remark,BranchSpecial,"+
				" ChangeCondition,OutFactoryDate,FatherCNo,BusinessWriteCondition,"+
				" SoftWriteCondition,SoftWriteDir,BusinessReviewResult,ProjectManagerReviewResult,"+
				" ChangeManagerReviewResult,UpdateUserID,getUserName(UpdateUserID) as UpdateUserName,UpdateTime,"+
				" TempSaveFlag"+
				//" getItemName('Status',Status) as Status"+
				" FROM Batch_Case"+
				" WHERE ChangeNo='"+sChangeNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	//定义列表表头
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "Batch_Case";
	doTemp.setKey("ChangeNo",true);	
	
    doTemp.setVisible("BatchNo,SerialNo,UpdateUserID,TempSaveFlag",false);
	doTemp.setHTMLStyle("BeginTime,EndTime,ContentType"," ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("ContentLength"," style={width:50px} ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setEditStyle("Summary,MeetingContent","3");
	doTemp.setHTMLStyle("Summary,MeetingContent,Remark"," style={width:730px;height:50px} ");
    doTemp.setAlign("ContentLength","3");
	doTemp.setReadOnly("UpdateTime,UpdateUserName", true);
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置为Grid风格
	dwTemp.ReadOnly = "0"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
			{"true","","Button","保存","查看附件内容","saveRecord()",sResourcesPath},
			{"false","","Button","返回","返回列表页面","doReturn()",sResourcesPath}
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
		as_save("myiframe0","");
	}
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ChangeNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
</script>
<script language=javascript>
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"TempSaveFlag","2");
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
	function initRow(){
		if (getRowCount(0)== 0){//如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"BatchNo","<%=sBatchNo%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"DocImportance","01");
			setItemValue(0,0,"DocDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"DocFlag","010");
			bIsInsert = true;
		}
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo()
	{
		var sTableName = "Batch_Case";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
<script	language=javascript>
	AsOne.AsInit();
	var bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow();
	//var sSerialNo = getItemValue(0,0,"SerialNo");//编制日期
	//OpenPage("/BusinessManage/CaseLoanBack.jsp?SerialNo="+sSerialNo,"DetailFrame",OpenStyle);
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>
