<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   王业罡 2005-08-18
			Tester:
			Content: 催收函详细信息_Info
			Input Param:
			SerialNo	催收函流水号										
			Output param:
			
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "催收详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//获得组件参数		
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));			
	if(sSerialNo==null) sSerialNo="";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		ASDataObject doTemp = new ASDataObject("DunManageInfo",Sqlca);

		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

	<script language=javascript>
		
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
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>