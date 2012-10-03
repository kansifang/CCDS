<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --jytian 
		Tester:
		Describe:--客户经理工作笔记列表;
		Input Param:
			ObjectNo： 对象编号
			NoteType： 笔记类型
			
		Output Param:
			
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	参数、格式				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "工作笔记列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量	
	String sSql = "";//--存放sql语句

	//获得组件参数
	String sNoteType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NoteType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sNoteType == null) sNoteType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	//获取页面参数
	    
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {	
							{"WorkType","工作类型"},
							{"WorkBrief","内容摘要"},
							{"PromptBeginDate","开始提示日期"},
							{"PlanFinishDate","计划完成日期"},
							{"UserName","登记人"},
							{"OrgName","登记机构"}
						 };

	if (sNoteType.equals("All"))
	{
		sSql  =  " select SerialNo,getItemName('WorkType',WorkType) as WorkType,WorkBrief,PromptBeginDate,PlanFinishDate,"+
			     " getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName "+
			     " from WORK_RECORD "+
			     " where InputUserID = '"+CurUser.UserID+"' ";
	}else
	{
		sSql   = " select SerialNo,getItemName('WorkType',WorkType) as WorkType,WorkBrief,PromptBeginDate,PlanFinishDate,"+
			     " getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName "+
			     " from WORK_RECORD "+
			     " where ObjectType = '"+sNoteType+"' "+
			     " and ObjectNo = '"+sObjectNo+"' "+
			     " and InputUserID = '"+CurUser.UserID+"' "; 
	}
	
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
    //设置修改表名
	doTemp.UpdateTable = "WORK_RECORD";
    //设置主键
	doTemp.setKey("SerialNo",true);
	//设置日期居中
	doTemp.setAlign("PlanFinishDate,PromptBeginDate","2");
	//设置时间显示格式
	doTemp.setHTMLStyle("PromptBeginDate,PlanFinishDate,UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:120px} ");
	//设置不显示
	doTemp.setVisible("SerialNo",false);
	
	//生成查询框
	doTemp.setFilter(Sqlca,"1","WorkBrief","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"2","WorkType","Operators=EqualsString,NotEquals;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	//设置DataWindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//设置为Grid风格
	dwTemp.Style="1";      
	//设置为只读
	dwTemp.ReadOnly = "1";
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

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
		{"true","","Button","新增","新增客户经理工作笔记","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看客户经理工作笔记","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除客户经理工作笔记","deleteRecord()",sResourcesPath}
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
		OpenPage("/DeskTop/WorkRecordInfo.jsp","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--当前流水号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else
		{
			OpenPage("/DeskTop/WorkRecordInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	//var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@include file="/IncludeEnd.jsp"%>
