<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: 限制项列表
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	//获得页面参数	
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	String sLimitationSetID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LimitationSetID"));
	//将空值转化为空字符串
	if(sSubLineID == null) sSubLineID = "";
	if(sLimitationSetID == null) sLimitationSetID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过显示模版产生ASDataObject对象doTemp
	String[][] sHeaders = {				
				{"LimObjectName","限制对象"},
				{"LineSum1","授信限额"},
				{"LineSum2","敞口限额"},
			};
	sSql = 	" select LimitationID,LimObjectName,LineSum1,LineSum2,UpdateTime "+
			" from CL_LIMITATION "+
			" where LineID = '"+sSubLineID+"' "+
			" and LimitationSetID = '"+sLimitationSetID+"' ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_LIMITATION";
	doTemp.setKey("LimitationID",true);
	doTemp.setHeader(sHeaders);
	//设置不可见行
	doTemp.setVisible("LimitationID,UpdateTime",false);
	//设置格式
	doTemp.setType("LineSum1,LineSum2","Number");
	doTemp.setUnit("LineSum1,LineSum2","(元)");
	//设置只读属性
	doTemp.setReadOnly("LimObjectName",true);
	//设置显示的格式
	doTemp.setHTMLStyle("LimObjectName","style={width:380px}");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
		{"true","","Button","添加","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{ 
		popComp("NewLimitationItem","/CreditManage/CreditLine/LimitationItemInfo.jsp","SubLineID=<%=sSubLineID%>&LimitationSetID=<%=sLimitationSetID%>","dialogwidth:480px;dialogheight:360px");
		reloadSelf();
	}
	
	/*~[Describe=保存记录;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		sCurDate = PopPage("/Common/ToolsB/GetDay.jsp","","");		
		setItemValue(0,0,"UpdateTime",sCurDate);
		as_save("myiframe0");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sLimitationID = getItemValue(0,getRow(),"LimitationID");		
		if (typeof(sLimitationID)=="undefined" || sLimitationID.length==0)
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
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
