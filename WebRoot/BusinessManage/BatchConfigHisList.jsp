<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: zywei 2005-11-27
			Tester:
			Describe: 业务申请所对应的新增的担保信息列表;
			Input Param:
			ObjectType：对象类型（CreditApply）
			ObjectNo: 对象编号（申请流水号）
			Output Param:
			
			HistoryLog:
						
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "具体分数项配置列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";//Sql语句
	ASResultSet rs = null;//结果集
	String sCodeNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo")));
	String sCItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo")));
	String sCItemNoSql="";
	if(!"XX".equals(sCItemNo)){
		sCItemNoSql=" and locate('"+sCItemNo+"',ItemNo)>0";
	}
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = {
	{"ItemNo","流水号"},
	{"ItemName","模板名称"},
	{"ItemDescribe","案件要素"},
	{"Attribute1","Excel案件要素"},
	{"IsInUse","有效"},
	{"UpdateUserName","更新人"},
	{"UpdateTime","更新时间"}
		};
	sSql =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
	" getItemName('SModelColumns',ItemDescribe) as ItemDescribe,"+
	" Attribute1,"+
	" getItemName('YesNo',IsInUse) as IsInUse,"+
	" getUserName(UpdateUser) as UpdateUserName,"+
	" UpdateTime"+
	" from Code_Library "+
	" where  CodeNo = '"+sCodeNo+"'"+
	sCItemNoSql+
	" order by ItemDescribe,ItemNo asc";
	
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable= "Code_Library";
	doTemp.setKey("CodeNo,ItemNo",true);
	//设置格式
	doTemp.setVisible("CodeNo,ItemName,SortNo",false);
	//doTemp.setHTMLStyle("Attribute1,Attribute2,Attribute3,Attribute4"," style={width:auto} ");
	//设置字段显示宽度	
	doTemp.appendHTMLStyle("Status"," style={width:90px} onDBLClick=parent.selectOrUnselect() ");
	doTemp.setColumnAttribute("OwnerName,GCSerialNo,GuarantyRightID,ImpawnID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(sCItemNo.length()==0){
		doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	}
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
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
		{(sCItemNo.length()==0?"true":"false"),"","Button","新增","新增","newRecord()",sResourcesPath},
		{(sCItemNo.length()==0?"true":"false"),"","Button","删除","删除","deleteRecord()",sResourcesPath},
		{(sCItemNo.length()==0?"true":"false"),"","Button","详情","查看","viewAndEdit()",sResourcesPath},
		{(sCItemNo.length()==0?"true":"false"),"","Button","查看当前修改历史","查看修改历史","viewModifiedHis('Some')",sResourcesPath},
		{(sCItemNo.length()==0?"true":"false"),"","Button","查看所有修改历史","查看修改历史","viewModifiedHis('All')",sResourcesPath},
		{(sCItemNo.length()==0?"false":"true"),"","Button","返回","返回","goBack()",sResourcesPath}
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

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp?CodeNo=<%=sCodeNo%>","_self","");
		//popComp("EvaluateScoreConfigInfo.jsp","/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp","ModelNo=<sModelNo&ItemNo=sItemNo&CodeNo=sCodeNo","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sItemNo = getItemValue(0,getRow(),"ItemNo");//--押品管理申请流水号
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			backupHis();
			as_del('myiframe0');
   		    as_save('myiframe0');  //如果单个删除,则要调用此语句
   		   // reloadSelf();
		}
	}

	/*~[Describe=查看及修改押品详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//popComp("EvaluateScoreConfigInfo.jsp","/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp","ModelNo="+sItemNo,"");
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp?CodeNo=<%=sCodeNo%>&CItemNo="+sItemNo,"_self","");
		//reloadSelf();
	}
   	function goBack(){
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp","_self","");
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
		function viewModifiedHis(flag)
		{
			var sItemNo='XX';
			if(flag=='Some'){
				sItemNo = getItemValue(0,getRow(),"ItemNo");
				if(typeof(sItemNo)=="undefined" || sItemNo.length==0) 
				{
					alert(getHtmlMessage('1'));//请选择一条信息！
					return;
				}
			}
			//OpenComp("EvaluateScoreConfigList","/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp","ModelNo="+sModelNo+"&ItemNo="+sItemNo+"&ValueCode="+sValueCode+"&ValueMethod="+sValueMethod+"&CodeNo=ScoreToItemValue","DetailFrame","");
		  	OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp?CItemNo="+sItemNo,"DetailFrame","");
		}
	    /*~[Describe=修改前保存一份备份;InputParam=无;OutPutParam=无;]~*/
	   	function backupHis(){
	   		var CodeNo = getItemValue(0,getRow(),"CodeNo");
	   		var ItemNo = getItemValue(0,getRow(),"ItemNo");
	   		RunMethod("SystemManage","InsertScoreConfigInfo",CodeNo+","+ItemNo);
		}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
	//initRow();
	//var bCheckBeforeUnload=false;
</script>
<%
	/*~END~*/
%>
<%@	include file="/IncludeEnd.jsp"%>