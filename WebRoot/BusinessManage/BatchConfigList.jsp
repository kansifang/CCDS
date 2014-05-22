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
	//获得组件参数：对象类型、对象编号、对象权限
	String sCodeNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo")));//"BatchColumnConfig";)
	String sType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type")));//"BatchColumnConfig";)
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
					{"Attribute1","Excel案件要素"},
					{"Attribute3","是否主标签"},
					{"ItemDescribe","案件对应表要素"},
					{"Attribute7","操作要素方式"},
					{"Attribute6","要素所在表"},
					{"ItemAttribute","要素注释"},
					{"Attribute8","要素名称"},
					{"Attribute2","要素类型"},
					{"Attribute4","要素长度"},
					{"Attribute5","要素精度"},
					{"IsInUse","有效"},
					{"UpdateUserName","更新人"},
					{"UpdateTime","更新时间"}
				};
	sSql =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
			" Attribute1,getItemName('YesNo',Attribute3) as Attribute3,getItemName('SModelColumns',ItemDescribe) as ItemDescribe,"+
			" getItemName('AlterType',Attribute7) as Attribute7,Attribute6,ItemAttribute,Attribute8,getItemName('DataType',Attribute2) as Attribute2,Attribute4,Attribute5,"+
			" getItemName('YesNo',IsInUse) as IsInUse,"+
			" getUserName(UpdateUser) as UpdateUserName,"+
			" UpdateTime"+
			" from Code_Library "+
			" where  CodeNo = '"+sCodeNo+"'"+
			" and IsInUse='1'"+
			" order by ItemNo,Attribute8 asc";
	
	//用sSql生成数据窗体对象
	ASDataObject doTemp = null;
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setRequired("Attribute5",true);
	doTemp.setHTMLStyle("ItemDescribe"," style={width:150px} ");
	doTemp.UpdateTable= "Code_Library";
	doTemp.setKey("CodeNo,ItemNo",true);
	//设置格式
	doTemp.setVisible("CodeNo,ItemName,SortNo",false);
	if("01".equals(sType)){
		doTemp.setVisible("Attribute7,Attribute6,ItemAttribute,Attribute8,Attribute4,Attribute5,Attribute7", false);
	}else{
		doTemp.setVisible("Attribute1,Attribute3,ItemDescribe", false);
	}
	//doTemp.setHTMLStyle("Attribute1,Attribute2,Attribute3,Attribute4"," style={width:auto} ");
	//设置字段显示宽度	
	//doTemp.appendHTMLStyle("Status"," style={width:90px} onDBLClick=parent.selectOrUnselect() ");
	doTemp.setColumnAttribute("Attribute6","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);
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
				{"true","","Button","新增","新增","newRecord()",sResourcesPath},
				{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
				{"true","","Button","详情","查看","viewAndEdit()",sResourcesPath},
				{"true","","Button","查看当前修改历史","查看修改历史","viewModifiedHis('Some')",sResourcesPath},
				{"true","","Button","查看所有修改历史","查看修改历史","viewModifiedHis('All')",sResourcesPath}
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
		//OpenPage("/BusinessManage/BatchConfigInfo.jsp?CodeNo=<%=sCodeNo%>","_self","");
		popComp("BatchConfigInfo.jsp","/BusinessManage/BatchConfigInfo.jsp","CodeNo=<%=sCodeNo%>","dialogWidth=35;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		reloadSelf();
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
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("BatchConfigInfo","/BusinessManage/BatchConfigInfo.jsp","CodeNo="+sCodeNo+"&ItemNo="+sItemNo,"dialogWidth=40;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		reloadSelf();
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
			sCodeNo = getItemValue(0,getRow(),"CodeNo");
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
		  	PopPage("/BusinessManage/BatchConfigHisList.jsp?CodeNo="+sCodeNo+"&ItemNo="+sItemNo,"DetailFrame","dialogWidth=50;dialogHeight=30;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
	bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	hideFilterArea();
	//initRow();
	//var bCheckBeforeUnload=false;
</script>
<%
	/*~END~*/
%>
<%@	include file="/IncludeEnd.jsp"%>