
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2005/08/25
		Tester:
		Content: 授权方案列表页面
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权方案"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	
	//获得页面参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {
							{"PolicyID","方案ID"},
							{"PolicyName","方案名称"},
							{"EffDate","启用日期"},
							{"EffStatus","生效状态"},
							{"AjudicatorID","授权计算器ID"}
						  };
	sSql =  " select PolicyID,PolicyName,EffDate,getItemName('EffStatus',EffStatus) as EffStatus "+
			" from AA_POLICY Where 1 = 1 ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_POLICY";
	doTemp.setKey("PolicyID",true);
	doTemp.setHeader(sHeaders);
		
	doTemp.setColumnAttribute("PolicyName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1 = 1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","openWithObjectViewer()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
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
		popComp("PolicyCreationDialog","/Common/Configurator/AAManage/PolicyCreationInfo.jsp","","dialogwidth:550px;dialogheight:650px");
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		//方案ID   
	    sPolicyID = getItemValue(0,getRow(),"PolicyID");			
		if (typeof(sPolicyID) == "undefined" || sPolicyID.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			sReturn=RunMethod("PublicMethod","GetColValue","AuthID,AA_AUTHPOINT,String@PolicyID@"+sPolicyID);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert("所选授权方案已被某些授权点引用，不能删除！");
				return;
			}else
			{
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
		}
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer()
	{
		//方案ID  
		sPolicyID = getItemValue(0,getRow(),"PolicyID");		
		if (typeof(sPolicyID) == "undefined" || sPolicyID.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		PopComp("EditPolicy","/Common/Configurator/AAManage/PolicySettingInfo.jsp","PolicyID="+sPolicyID,"");
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
