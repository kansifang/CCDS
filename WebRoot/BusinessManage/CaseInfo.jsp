
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
	String sBatchNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BatchNo")));
	String sSerialNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));	
	String sEditable = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Editable")));
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
                            	{"SerialNo","案子号"},
                            	{"DueNo","借据号"},
                            	{"LCustomerID","委托方"},
                            	{"LCustomerName","委托方"},
                            	{"LDate","委托日期"},
                            	{"LSum","委托金额"},
                            	{"DCustomerID","姓名"},
                            	{"DCustomerName","姓名"},
                            	{"ID","身份证号"},
                            	{"CardNo","卡号"},
                            	{"PayBackSum","应还款金额"},
                            	{"PayBackDate","应还日期"},
                            	{"ActualPayBackSum","实际还款金额"},
                            	{"ActualPayBackDate","实际还日期"},
                            	{"Balance","余额"},
                            	{"Remark","评语"},
                            	{"BeginTime","发送开始时间"},
                            	{"EndTime","发送结束时间"},
                            	{"ContentType","类别"},
                            	{"ContentLength","文档长度(字节)"},
                            	{"FileName","委托方"},
                            	{"BeginTime","发送开始时间"},
                            	{"EndTime","发送结束时间"},
                            	{"ContentType","类别"},
                            	{"ContentLength","文档长度(字节)"}
	     			};    		                     
	
	    
    	//定义SQL语句
    	
	sSql = 	" SELECT BatchNo,SerialNo,DueNo,"+
			" LCustomerID,LCustomerName,LDate,LSum,DCustomerID,DCustomerName,"+
			" ID,CardNo,PayBackSum,PayBackDate,ActualPayBackSum,ActualPayBackDate,Balance,Remark,"+
			" BeginTime,EndTime"+
           	" FROM Batch_Case"+
			" WHERE SerialNo='"+sSerialNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	//定义列表表头
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "Batch_Case";
	doTemp.setKey("SerialNo",true);	
	
    doTemp.setVisible("BatchNo,LCustomerID,DCustomerID",false);
	doTemp.setHTMLStyle("BeginTime,EndTime,ContentType"," ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("ContentLength"," style={width:50px} ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("FileName"," style={width:150px} ondblclick=\"javascript:parent.viewFile()\" ");
    doTemp.setAlign("ContentLength","3");
	doTemp.setReadOnly("SerialNo", true);
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置为Grid风格
	dwTemp.ReadOnly = "0"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //查询区的页面代码
	CurPage.setAttribute("ShowDetailArea","true");
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
			{"Y".equals(sEditable)?"true":"false","","Button","保存","查看附件内容","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","doReturn()",sResourcesPath}
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
		sObjectNo = getItemValue(0,getRow(),"CodeNo");
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
	function initRow(){
		if (getRowCount(0)== 0){//如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"BatchNo","<%=sBatchNo%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
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
	var sSerialNo = getItemValue(0,0,"SerialNo");//编制日期
	OpenPage("/BusinessManage/CaseLoanBack.jsp?SerialNo="+sSerialNo,"DetailFrame",OpenStyle);
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>
