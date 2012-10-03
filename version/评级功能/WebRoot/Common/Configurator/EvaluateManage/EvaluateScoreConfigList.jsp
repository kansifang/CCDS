<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
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
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "具体分数项配置列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//Sql语句
	ASResultSet rs = null;//结果集
	//获得组件参数：对象类型、对象编号、对象权限
	String sModelNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo")));
	String sItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo")));
	String sValueCode = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ValueCode")));
	String sValueMethod = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ValueMethod")));
	//CreditLevelToTotalScore 评级配置   ScoreToItemValue 项目配置
	String sCodeNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo")));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders0[][] = {
							{"ItemNo","流水号"},
							{"ItemDescribe","a"},
							{"Attribute1","b"},
							{"Attribute2","c"},
							{"Attribute3","d"},
							{"Attribute4","median"},
							{"Attribute5","StDev"},
							{"Attribute6","minScore"},
							{"Attribute7","maxScore"},
							{"IsInUse","是否有效"},
							{"UpdateUserName","更新人"},
							{"UpdateTime","更新时间"}
						};
	String sSql0 =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
						" ItemDescribe,"+
						" Attribute1,"+
						" Attribute2,"+
						" Attribute3,"+
						" Attribute4,"+
						" Attribute5,"+
						" Attribute6,"+
						" Attribute7,"+
						" getItemName('YesNo',IsInUse) as IsInUse,"+
						" getUserName(UpdateUser) as UpdateUserName,"+
						" UpdateTime"+
						" from Code_Library "+
						" where  CodeNo = '"+sCodeNo+"'"+
						" and ItemName='"+sModelNo+"'"+
						" and SortNo='"+sItemNo+"'";
	String sHeaders1[][] = {
							{"ItemNo","流水号"},
							{"ItemDescribe","分值"},
							{"Attribute1","下限操作符（定量）"},
							{"Attribute2","下限边界值（定量）"},
							{"Attribute3","上限操作符（定量）"},
							{"Attribute4","上限边界值（定量）"},		
							{"Attribute5","取值（定性）"},
							{"IsInUse","有效"},
							{"UpdateUserName","更新人"},
							{"UpdateTime","更新时间"}
						};
	String sHeaders2[][] = {
							{"ItemNo","流水号"},
							{"ItemDescribe","评级"},
							{"Attribute1","下限操作符"},
							{"Attribute2","下限边界值"},
							{"Attribute3","上限操作符"},
							{"Attribute4","上限边界值"},		
							{"IsInUse","是否有效"},
							{"UpdateUserName","更新人"},
							{"UpdateTime","更新时间"}
		  				};
	
	sSql =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
				" ItemDescribe,"+
				" getItemName('ArithmeticOpe',Attribute1) as Attribute1,"+
				" Attribute2,"+
				" getItemName('ArithmeticOpe',Attribute3) as Attribute3,"+
				" Attribute4,"+
				" getItemName('"+sValueCode+"',Attribute5) as Attribute5,"+
				" getItemName('YesNo',IsInUse) as IsInUse,"+
				" getUserName(UpdateUser) as UpdateUserName,"+
				" UpdateTime"+
				" from Code_Library "+
				" where  CodeNo = '"+sCodeNo+"'"+
				" and ItemName='"+sModelNo+"'";
	
	//用sSql生成数据窗体对象
	ASDataObject doTemp = null;
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	if("311".equals(sModelNo)&&"1.TJMX".equals(sItemNo)){//制造业中小有统计模型公式
			doTemp = new ASDataObject(sSql0);
			doTemp.setHeader(sHeaders0);
	}else{
		if("ScoreToItemValue".equals(sCodeNo)){
			sSql+=" and SortNo='"+sItemNo+"' order by Double(ItemDescribe) asc ";
			doTemp = new ASDataObject(sSql);
			doTemp.setHeader(sHeaders1);
			if(!"".equals(sValueCode)){
				doTemp.setVisible("Attribute1,Attribute2,Attribute3,Attribute4",false);
				doTemp.setRequired("Attribute5",true);
				doTemp.setHTMLStyle("Attribute5"," style={width:1000px} ");
			}else{
				doTemp.setVisible("Attribute5",false);
			}
		}else if("CreditLevelToTotalScore".equals(sCodeNo)){
			sSql+=" order by ItemDescribe asc ";
			doTemp = new ASDataObject(sSql);
			doTemp.setHeader(sHeaders2);
			doTemp.setVisible("Attribute5",false);
		}
	}
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
	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
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
			{"true","","Button","新增","新增入库抵押物信息","newRecord()",sResourcesPath},
			{"true","","Button","删除","删除入库抵押物信息","deleteRecord()",sResourcesPath},
			{"true","","Button","详情","查看入库抵押物详情","viewAndEdit()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
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
			as_del('myiframe0');
   		    as_save('myiframe0');  //如果单个删除,则要调用此语句
   		    reloadSelf();
		}
	}

	/*~[Describe=查看及修改押品详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sItemNo = getItemValue(0,getRow(),"ItemNo");//--担保合同信息编号
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//popComp("EvaluateScoreConfigInfo.jsp","/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp","ModelNo="+sItemNo,"");
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp?CodeNo=<%=sCodeNo%>&CItemNo="+sItemNo,"_self","");
		//reloadSelf();
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
	my_load(2,0,'myiframe0');
	
	//initRow();
	//var bCheckBeforeUnload=false;
</script>
<%/*~END~*/%>
<%@	include file="/IncludeEnd.jsp"%>