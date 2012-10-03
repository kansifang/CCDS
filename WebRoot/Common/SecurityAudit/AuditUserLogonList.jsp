<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: FSGong  2005-01-26
*
*	Tester:
*	Describe: 管户的不良资产快速查询
*	Input Param:
*	Output Param:     
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "用户访问时间日志"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%/*~END~*/%>         
                      
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
								{"ListID","序号"},
								{"UserID","用户号"},
								{"UserName","用户名称"},
								{"OrgID","机构号"},
								{"OrgName","机构名称"},
								{"BeginTime","开始访问时间"},
								{"EndTime","退出系统时间(空值表示在线或异常退出)"},
							}; 

 	String sSql = "select SessionID,UserID,UserName,OrgID,OrgName,BeginTime,EndTime from USER_LIST where 1=1 ";

	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);	
    doTemp.setKey("SessionID",true);
	doTemp.setVisible("SessionID",false);	
	
	doTemp.UpdateTable = "USER_LIST";

	doTemp.setHTMLStyle("UserName"," style={width:120px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:160px} ");
	doTemp.setHTMLStyle("UserID,OrgID"," style={width:60px} ");
	
	//doTemp.setCheckFormat("BeginTime,EndTime","3");
	//生成查询框
	doTemp.setColumnAttribute("UserName,OrgID,OrgName,BeginTime,EndTime","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) 
	    doTemp.WhereClause+=" and BeginTime like '"+StringFunction.getToday()+"%' and EndTime is null ";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(40); //服务器分页
	
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
		};
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
